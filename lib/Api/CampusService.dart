import 'package:dio/dio.dart' as Dio;
import 'package:mycampus/Api/DioClient.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:mycampus/Models/Campus.dart';

class CampusService extends ChangeNotifier {
  Future<List<Campus>> getCampus() async {
    Dio.Response response = await dio().get("campus/");
    //  print(response.data["response"]);
    return decodeListCampus(response.data["response"]);
  }

  List<Campus> decodeListCampus(responseBody) {
    final parsed = responseBody;

    return parsed.map<Campus>((json) => Campus.fromJson(json)).toList();
  }

  Future<Campus> getCampusById(int id) async {
    Dio.Response response = await dio().get("publication/$id");
    // print(response.toString());
    return decodeCampus(response.data);
  }

  Campus decodeCampus(responseBody) {
    return Campus.fromJson(responseBody);
  }

  Future upadateCampus(int id, Dio.FormData data) async {
    Dio.Response response = await dio().post("", data: data);
    return json.decode(response.toString());
  }

  Future deleteCampus(int id, Dio.FormData data) async {
    Dio.Response response = await dio().post("", data: data);
    return json.decode(response.toString());
  }
}
