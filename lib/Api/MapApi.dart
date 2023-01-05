import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:mycampus/Api/DioClient.dart';

class MapApi {
  Future<Dio.Response> getRoute(startLatitude, startLongitude,
      destinationLatitude, destinationLongitude) async {
    print(
        "https://graphhopper.com/api/1/route?point=$startLatitude,$startLongitude&point=$destinationLatitude,$destinationLongitude&vehicle=bike&debug=true&key=c02c2fc1-f8e6-4527-a7c9-22dd81aebe8a&type=json&points_encoded=false");

    return await dio1().get(
        "route?point=$startLatitude,$startLongitude&point=$destinationLatitude,$destinationLongitude&vehicle=bike&debug=true&key=c02c2fc1-f8e6-4527-a7c9-22dd81aebe8a&type=json&points_encoded=false");
  }
}
