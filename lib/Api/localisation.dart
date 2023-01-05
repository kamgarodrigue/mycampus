import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Localisation extends ChangeNotifier {
  LatLng _location;
  LatLng get location => _location;
  Location locat = Location();
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool isStart = false, _serviceEnabled;

  initLocation() async {
    _serviceEnabled = await locat.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locat.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await locat.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await locat.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }
    _locationData = await locat.getLocation();
    _location = new LatLng(_locationData.latitude, _locationData.longitude);
    notifyListeners();
  }

  Stream<LocationData> currentLocation() {
    locat.onLocationChanged().listen((position) {
      _location = LatLng(position.longitude, position.latitude);
      notifyListeners();
      print(position.latitude.toString() +
          ',' +
          position.longitude.toString() +
          ',' +
          position.altitude.toString());
    });
  }
}
