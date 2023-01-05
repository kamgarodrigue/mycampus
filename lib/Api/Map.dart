import 'package:mycampus/Models/Campus.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:mycampus/Api/DioClient.dart';
import 'dart:convert';

//import 'package:image_downloader/image_downloader.dart';
class Map {
  Future<String> getCampus() async {
    Dio.Response response = await dio().get(
        "http://192.168.43.45:5000/upload/Campusrealitygeneraltiffdef.tif");
  }
}
