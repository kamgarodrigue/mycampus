import 'package:dio/dio.dart' as Dio;
import 'package:mycampus/Api/DioClient.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:mycampus/Models/Pub.dart';

class PubService extends ChangeNotifier {
  List<Pub> _listPub = [];
  List<Pub> get listPub => _listPub;
  List<Pub> _newPubs = [];
  List<Pub> get newPubs => _newPubs;

  List<Pub> decodeListPub(responseBody) {
    final parsed = responseBody;
    _listPub = parsed.map<Pub>((json) => Pub.fromJson(json)).toList();
    notifyListeners();
    return parsed.map<Pub>((json) => Pub.fromJson(json)).toList();
  }

  List<Pub> decodeLisPub1(responseBody) {
    final parsed = responseBody;
    _newPubs = parsed.map<Pub>((json) => Pub.fromJson(json)).toList();
    notifyListeners();
    return parsed.map<Pub>((json) => Pub.fromJson(json)).toList();
  }

  Future<List<Pub>> getlistPub() async {
    var data = {"isnew": false};
    Dio.Response response = await dio().post("pub/pubmode/", data: data);
    print(response.data["response"]);
    return decodeListPub(response.data["response"]);
  }

  Future<List<Pub>> getnewPub() async {
    var data = {"isnew": true};
    Dio.Response response = await dio().post("pub/pubmode/", data: data);
    print(response.data["response"]);
    return decodeLisPub1(response.data["response"]);
  }
}
