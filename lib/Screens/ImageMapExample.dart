// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mycampus/Api/DioClient.dart';
import 'package:mycampus/Widgets/data.dart';

import 'package:user_location/user_location.dart';

import 'package:shared_preferences/shared_preferences.dart';
//import 'package:latlng/latlng.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

//import 'package:flutter_image_map/flutter_image_map.dart';
class ImageMapExample extends StatefulWidget {
  LatLng point;
  ImageMapExample({Key key, @required point}) : super(key: key);

  @override
  _ImageMapExampleState createState() => _ImageMapExampleState();
}

class _ImageMapExampleState extends State<ImageMapExample> {
  String title = "flutter_image_map Example";
  List<LatLng> data = [];
  LatLng currentLocation = LatLng(3.858169, 11.500118);

  void setTitle(String value) {
    setState(() {
      this.title = value;
    });
  }

  LatLng hoverPoint;
  MapController mapController = MapController();
  List<Marker> markers = [];
  StreamController<LatLng> markerlocationStream = StreamController();
  void dispose() {
    markerlocationStream.close();
  }

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );
  setCurenlocation() async {
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((position) {
      setState(() {
        hoverPoint = LatLng(position.latitude, position.longitude);
      });
    });
  }

  bool star = false, stop = false;
  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;
    this.setCurenlocation();
    return Scaffold(
        body: Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(3.51318907, 11.30000520),
            zoom: 0,
            minZoom: 0,
            maxZoom: 18,
            plugins: [
              UserLocationPlugin(),
            ],
          ),
          layers: [
            TileLayerOptions(
              urlTemplate:
                  "http://192.168.43.45:5000/upload/carte/Mapnik/{z}/{x}/{y}.png",
              tileSize: 256.0,
              maxZoom: 0,
            ),
            PolylineLayerOptions(
              polylines: [],
            ),
            MarkerLayerOptions(markers: [
              //if (hoverPoint is LatLng)
              Marker(
                  point: hoverPoint,
                  width: 8,
                  height: 8,
                  builder: (BuildContext context) => Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)),
                      ))
            ]),
            UserLocationOptions(
                context: context,
                mapController: mapController,
                markers: markers,
                onLocationUpdate: (pos) {
                  // print("onLocationUpdate ${pos.toString()}");

                  // return pos;
                },
                updateMapLocationOnPositionChange: true,
                showMoveToCurrentLocationFloatingActionButton: true,
                verbose: false),
          ],
        ),
        Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              height: heigth * 0.15,
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 32,
                  )),
            )),
        Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: heigth * 0.15,
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32,
                  )),
            ))
      ],
    ));
  }
}
