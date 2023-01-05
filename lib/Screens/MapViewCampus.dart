import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mycampus/Api/localisation.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Models/Instruction.dart';
import 'package:mycampus/Models/Lieu.dart';
import 'package:mycampus/Screens/DetailPlace.dart';
import 'package:mycampus/Screens/SearchLieu.dart';
import 'package:mycampus/Screens/SearchLieubyCampus.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:flutter/material.dart';

import 'dart:math' show cos, sqrt, asin;
import 'dart:convert';
import 'package:dio/dio.dart' as Dio;
import 'package:mycampus/Api/MapApi.dart';

class MapViewCampus extends StatefulWidget {
  final String idcampus;

  const MapViewCampus({this.idcampus});
  @override
  _MapViewCampusState createState() => _MapViewCampusState();
}

class _MapViewCampusState extends State<MapViewCampus> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  LatLng star;
  LatLng end;
  Lieu lieuStar;
  Lieu lieuEnd;
  String _currentAddress = '';
  List<Instruction> insruction = [];
  Instruction curreentinstruction =
      Instruction(distance: 0.0, text: "", time: 0);
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;
  String _time;
  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  bool navigationstart = false, isStart = false;
  void starLocation(Lieu lieu) {
    setState(() {
      startAddressController.text = lieu.intitule;
      lieuStar = lieu;
      _startAddress = lieu.intitule;
      star = LatLng(lieu.lat, lieu.long);
    });
    print("start " + _startAddress);
  }

  void endLocation(Lieu lieu) {
    setState(() {
      lieuEnd = lieu;
      destinationAddressController.text = lieu.intitule;
      _destinationAddress = lieu.intitule;
      end = LatLng(lieu.lat, lieu.long);
    });
    print(_destinationAddress);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Icon getInstructionIcon(val, Color whiteColor) {
    switch (val) {
      case -98:
        return Icon(
          Icons.arrow_downward,
          color: whiteColor,
          size: 40,
        );
        break;
      case -8:
        return Icon(
          Icons.turn_left,
          color: whiteColor,
          size: 40,
        );
        break;
      case -7:
        return Icon(
          Icons.reply,
          color: whiteColor,
          size: 40,
        );
        break;
      case -6:
        return Icon(
          Icons.roundabout_left,
          color: whiteColor,
          size: 40,
        );
        break;
      case -3:
        return Icon(
          Icons.turn_left,
          color: whiteColor,
          size: 40,
        );
        break;
      case -2:
        return Icon(
          Icons.turn_left,
          color: whiteColor,
          size: 40,
        );
        break;
      case -1:
        return Icon(
          Icons.reply,
          color: whiteColor,
          size: 40,
        );
        break;
      case 0:
        return Icon(
          Icons.arrow_upward,
          color: whiteColor,
          size: 40,
        );
        break;
      case 1:
        return Icon(
          Icons.turn_slight_right,
          color: whiteColor,
          size: 40,
        );
        break;
      case 2:
        return Icon(
          Icons.turn_right,
          color: whiteColor,
          size: 40,
        );
        break;
      case 3:
        return Icon(
          Icons.turn_sharp_right,
          color: whiteColor,
          size: 40,
        );
        break;
      case 4:
        return Icon(
          Icons.location_city,
          color: whiteColor,
          size: 40,
        );
        break;
      case 5:
        return Icon(
          Icons.roundabout_left,
          color: whiteColor,
          size: 40,
        );
        break;
      case 6:
        return Icon(
          Icons.roundabout_left,
          color: whiteColor,
          size: 40,
        );
        break;
      case 7:
        return Icon(
          Icons.call_made,
          color: whiteColor,
          size: 40,
        );
        break;
      case 8:
        return Icon(
          Icons.turn_right,
          color: whiteColor,
          size: 40,
        );
        break;
      default:
    }
  }

  Widget _textField({
    @required TextEditingController controller,
    @required FocusNode focusNode,
    @required String label,
    @required String hint,
    @required double width,
    @required Icon prefixIcon,
    @required Function() onTap,
    Widget suffixIcon,
    @required Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onTap: onTap,
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    //return 12742 * asin(sqrt(a));
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  List<Instruction> decodeInstruction(responseBody) {
    final parsed = responseBody;

    return parsed
        .map<Instruction>((json) => Instruction.fromJson(json))
        .toList();
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    MapApi()
        .getRoute(startLatitude, startLongitude, destinationLatitude,
            destinationLongitude)
        .then(
      (Dio.Response value) {
        List result = value.data["paths"] as List;
        print(result[0]["instructions"]);

        if (result[0]["instructions"] != null) {
          setState(() {
            insruction = decodeInstruction(result[0]["instructions"]);
            insruction.forEach((inst) {
              inst.point = result[0]["points"]["coordinates"]
                  .sublist(inst.interval[0], inst.interval[1]);
            });
            curreentinstruction = insruction[0];
            print("sign " + curreentinstruction.sign.toString());
          });

          ///print(insruction[1].point);
        }
        // print(result[0]["distance"] + 'calule distance');
        if (!result[0]["points"]["coordinates"].isEmpty) {
          print("route");
          print(polylineCoordinates.length.toString());
          result[0]["points"]["coordinates"].forEach((point) {
            setState(() {
              polylineCoordinates.add(LatLng(point[1], point[0]));
            });
          });
          print(polylineCoordinates.length.toString());
        }

        setState(() {
          _placeDistance = result[0]["distance"].toString();
          _time =
              ((result[0]["time"] * 1.66 * 0.00001)).toString().split(',')[0];
        });
        PolylineId id = PolylineId('R101');
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.red,
          points: polylineCoordinates,
          width: 3,
        );
        setState(() {
          polylines[id] = polyline;
          navigationstart = true;
        });
        print(polylines.length.toString());
      },
    );
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    bool _isLoading = false;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      value,
      style: TextStyle(color: Colors.white),
    )));
  }

  _getCurrentLocation() async {
    context.read<Localisation>().initLocation();
  }

  @override
  void initState() {
    super.initState();

    /* RouteService().sharedPreferences().then((value) {
      print(value.getString("route"));
      List route = json.decode(value.getString(""));
      if (!route.isEmpty) {
        for (var i = 0; i < route.length; i++) {
          polylines[PolylineId(i.toString())] = Polyline(
            polylineId: PolylineId(i.toString()),
            color: i % 2 == 0 ? Colors.blue : Colors.red,
            points: route[i]["points"],
            width: 10,
          );
        }
      } else {
        print("froute vide");
        showInSnackBar("vide", context);
      }
    });*/
    //polylines[widget.polyline.polylineId] = widget.polyline;

    _getCurrentLocation();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    print(polylines.length.toString());
    final locat = context.watch<Localisation>();
    _getCurrentLocation();
    locat.locat.onLocationChanged().listen((pos) {
      if (insruction.isNotEmpty) {
        insruction.forEach((instruction) {
          if (instruction.point.isNotEmpty) {
            if (_coordinateDistance(pos.latitude, pos.longitude,
                    instruction.point[0][0], instruction.point[0][1]) <=
                0.5) {
              print("ccvggg" + instruction.point.toString());

              setState(() {
                curreentinstruction = instruction;
              });
            }
          }
        });
      }
    });
    //locat.currentLocation();
    // Method for retrieving the current location

    // Method for retrieving the address
    _getAddress() async {
      try {
        List<Placemark> p = await placemarkFromCoordinates(
            locat.location.latitude, locat.location.longitude);

        Placemark place = p[0];

        setState(() {
          star = locat.location;
          _currentAddress =
              "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
          startAddressController.text = _currentAddress;
          _startAddress = _currentAddress;
          print(_currentAddress);
        });
      } catch (e) {
        print(e);
      }
    }

    // Method for calculating the distance between two places
    Future<bool> _calculateDistance() async {
      try {
        // Retrieving placemarks from addresses
        /*  List<Location> startPlacemark =
            await locationFromAddress(_startAddress);*/
        /* List<Location> destinationPlacemark =
            await locationFromAddress(_destinationAddress);*/

        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        /* double startLatitude = _startAddress == _currentAddress
            ? locat.location.latitude
            : startPlacemark[0].latitude;*/
        double startLatitude = star.latitude;
        double startLongitude = star.longitude;
        /* double startLongitude = _startAddress == _currentAddress
            ? locat.location.longitude
            : startPlacemark[0].longitude;*/
        double destinationLatitude = end.latitude;
        double destinationLongitude = end.longitude;
        print(star.latitude.toString() +
            " " +
            star.longitude.toString() +
            " " +
            end.latitude.toString() +
            " " +
            end.latitude.toString());
        //double destinationLatitude = destinationPlacemark[0].latitude;
        // double destinationLongitude = destinationPlacemark[0].longitude;

        String startCoordinatesString = '($startLatitude, $startLongitude)';
        String destinationCoordinatesString =
            '($destinationLatitude, $destinationLongitude)';

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId(startCoordinatesString),
          position: LatLng(startLatitude, startLongitude),
          infoWindow: InfoWindow(
            title: 'Start $startCoordinatesString',
            snippet: _startAddress,
          ),
          onTap: lieuStar != null
              ? () => showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) => DetailPlace(lieu: lieuStar))
              : () {},
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId(destinationCoordinatesString),
          position: LatLng(destinationLatitude, destinationLongitude),
          infoWindow: InfoWindow(
            title: 'Destination $destinationCoordinatesString',
            snippet: _destinationAddress,
          ),
          onTap: lieuEnd != null
              ? () => showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) => DetailPlace(lieu: lieuEnd))
              : () {},
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print(
          'START COORDINATES: ($startLatitude, $startLongitude)',
        );
        print(
          'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
        );

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.
        double miny = (startLatitude <= destinationLatitude)
            ? startLatitude
            : destinationLatitude;
        double minx = (startLongitude <= destinationLongitude)
            ? startLongitude
            : destinationLongitude;
        double maxy = (startLatitude <= destinationLatitude)
            ? destinationLatitude
            : startLatitude;
        double maxx = (startLongitude <= destinationLongitude)
            ? destinationLongitude
            : startLongitude;

        double southWestLatitude = miny;
        double southWestLongitude = minx;

        double northEastLatitude = maxy;
        double northEastLongitude = maxx;

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(northEastLatitude, northEastLongitude),
              southwest: LatLng(southWestLatitude, southWestLongitude),
            ),
            100.0,
          ),
        );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator.bearingBetween(
        //   startLatitude,
        //   startLongitude,
        //   destinationLatitude,
        //   destinationLongitude,
        // );

        await _createPolylines(startLatitude, startLongitude,
            destinationLatitude, destinationLongitude);

        return true;
      } catch (e) {
        print(e);
      }
      return false;
    }

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.hybrid,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),

            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route
            Visibility(
              visible: !navigationstart,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(179, 41, 37, 37),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      width: width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Places',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(height: 10),
                            _textField(
                                label: 'Start',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SearchLieubyCampus(
                                                onTap: starLocation,
                                                idcampus: widget.idcampus,
                                              )));
                                },
                                hint: 'Choose starting point',
                                prefixIcon: Icon(Icons.looks_one),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.my_location),
                                  onPressed: () {
                                    _getAddress();
                                    setState(() {
                                      startAddressController.text =
                                          _currentAddress;
                                      _startAddress = _currentAddress;
                                    });
                                  },
                                ),
                                controller: startAddressController,
                                focusNode: startAddressFocusNode,
                                width: width,
                                locationCallback: (String value) {
                                  setState(() {
                                    _startAddress = value;
                                  });
                                }),
                            SizedBox(height: 10),
                            _textField(
                                label: 'Destination',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SearchLieubyCampus(
                                                onTap: endLocation,
                                                idcampus: widget.idcampus,
                                              )));
                                },
                                hint: 'Choose destination',
                                prefixIcon: Icon(Icons.looks_two),
                                controller: destinationAddressController,
                                focusNode: desrinationAddressFocusNode,
                                width: width,
                                locationCallback: (String value) {
                                  setState(() {
                                    _destinationAddress = value;
                                  });
                                }),
                            SizedBox(height: 10),
                            Visibility(
                              visible: _placeDistance == null ? false : true,
                              child: Text(
                                'DISTANCE: $_placeDistance m',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: (_startAddress != '' &&
                                      _destinationAddress != '')
                                  ? () async {
                                      startAddressFocusNode.unfocus();
                                      desrinationAddressFocusNode.unfocus();
                                      setState(() {
                                        if (markers.isNotEmpty) markers.clear();
                                        if (polylines.isNotEmpty)
                                          polylines.clear();
                                        if (polylineCoordinates.isNotEmpty)
                                          polylineCoordinates.clear();
                                        _placeDistance = null;
                                      });

                                      _calculateDistance().then((isCalculated) {
                                        if (isCalculated) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Distance Calculated Sucessfully $_placeDistance'),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Error Calculating Distance'),
                                            ),
                                          );
                                        }
                                      });
                                    }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Show Route'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: navigationstart && isStart,
                child: SafeArea(
                    child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: kPrimaryColors,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      width: width,
                      height: height * 0.15,
                      child: ListTile(
                        leading: getInstructionIcon(
                            curreentinstruction.sign, whiteColor),
                        title: Row(
                          children: [
                            Text(
                              (curreentinstruction.time * 1.66 * 0.00001)
                                      .toString() +
                                  " min",
                              // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 20,
                                  fontFamily: "Roboto-Medium"),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "  ( ${curreentinstruction.distance} m ) ",
                              // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 20,
                                  fontFamily: "Roboto-Medium"),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "${curreentinstruction.text}",
                          // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 17,
                              fontFamily: "Roboto-Regular"),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                ))),
            // Show current lo  cation button
            Visibility(
                visible: navigationstart,
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      width: width,
                      height: height * 0.15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "$_time min",
                                // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: kSecondaryColor,
                                    fontSize: 16,
                                    fontFamily: "Roboto-Medium"),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "  ( $_placeDistance m ) ",
                                // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: kSecondaryColor,
                                    fontSize: 16,
                                    fontFamily: "Roboto-Medium"),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Text(
                            "itineraire la plus rapide selon l'etat actuel de la circulation",
                            // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 14,
                                fontFamily: "Roboto-Regular"),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (polylineCoordinates.isNotEmpty)
                                      polylineCoordinates.clear();
                                    _placeDistance = null;
                                    navigationstart = false;
                                    isStart = false;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  child: Icon(Icons.close,
                                      color: Colors.redAccent, size: 25),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isStart = true;
                                  });
                                  print(insruction);
                                },
                                child: Container(
                                  height: height * 0.05,
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      color: kPrimaryColors,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: whiteColor,
                                        size: 25,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Demarer",
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontSize: 17,
                                            fontFamily: "Roboto-Medium"),
                                        overflow: TextOverflow.visible,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    width: width,
                                    height: height,
                                    child: Stack(
                                      children: [
                                        SafeArea(
                                            child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: kSecondaryColor),
                                                  BoxShadow(
                                                      color: kSecondaryColor)
                                                ],
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
                                            width: width,
                                            height: height * 0.1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "$_time min",
                                                      // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color:
                                                              kSecondaryColor,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              "Roboto-Medium"),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      "  ( $_placeDistance m ) ",
                                                      // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color:
                                                              kSecondaryColor,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              "Roboto-Medium"),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "itineraire la plus rapide selon l'etat actuel de la circulation",
                                                  // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 14,
                                                      fontFamily:
                                                          "Roboto-Regular"),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height: height * 0.9,
                                            width: width,
                                            child: ListView.builder(
                                              itemCount: insruction.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  leading: getInstructionIcon(
                                                      insruction[index].sign,
                                                      kSecondaryColor),
                                                  title: Row(
                                                    children: [
                                                      Text(
                                                        "${insruction[index].time} min",
                                                        // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color:
                                                                kSecondaryColor,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                "Roboto-Medium"),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        "  ( ${insruction[index].distance} m ) ",
                                                        // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color:
                                                                kSecondaryColor,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                "Roboto-Medium"),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Text(
                                                    "${insruction[index].text}",
                                                    // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontSize: 17,
                                                        fontFamily:
                                                            "Roboto-Regular"),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                child: Container(
                                  height: height * 0.05,
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.list,
                                          color: kPrimaryColors, size: 25),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Etapes",
                                        style: TextStyle(
                                            color: kFontlightColor,
                                            fontSize: 17,
                                            fontFamily: "Roboto-Medium"),
                                        overflow: TextOverflow.visible,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            Visibility(
              visible: !navigationstart,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                    child: ClipOval(
                      child: Material(
                        color: Colors.orange.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.orange, // inkwell color
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.my_location),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: locat.location,
                                  zoom: 18.0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
