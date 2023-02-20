import 'package:dio/dio.dart' as Dio;
import 'package:mycampus/Api/DioClient.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:mycampus/Models/Lieu.dart';

class LieuService extends ChangeNotifier {
  List<Lieu> _list = [];
  List<Lieu> get list => _list;
  List<Lieu> _listbytype = [];
  List<Lieu> _search = [];
  List<Lieu> _listri = [];
  List<Lieu> get listbytype => _listbytype;
  List<Lieu> get tableaurecherche => _search;
  List<Lieu> get tableautri => _listri;
  List _typerLieu = [];
  List get typerLieu => _typerLieu;
  Future<List<Lieu>> getLieu() async {
    Dio.Response response = await dio().get("lieu/");
    //print(response.data["response"]);
    return decodeListLieu(response.data["response"]);
  }

  Future<List<Lieu>> getLieu1() async {
    Dio.Response response = await dio().get("lieu/");
    //  print(response.data["response"]);
    return decodeListLieu2(response.data["response"]);
  }

  void recherche(String text) {
    print(text);
    print(_listri.length);
    if (text == "") {
      _listri = [];
      notifyListeners();
    } else {
      for (var i = 0; i < _search.length; i++) {
        if (_search
            .elementAt(i)
            .intitule
            .toLowerCase()
            .contains(text.toLowerCase())) {
          _listri.add(_search.elementAt(i));
          notifyListeners();
          print(_listri.length);
          notifyListeners();
        }
      }
    }
  }

  List<Lieu> decodeListLieu2(responseBody) {
    final parsed = responseBody;
    _search = parsed.map<Lieu>((json) => Lieu.fromJson(json)).toList();
    notifyListeners();

    return parsed.map<Lieu>((json) => Lieu.fromJson(json)).toList();
  }

  Future<List> getTypeLieu() async {
    Dio.Response response = await dio().get(
      "typeLieu/",
    );

    _typerLieu = response.data["response"] as List;
    for (var i = 0; i < _typerLieu.length; i++) {
      Map elemt = typerLieu[i] as Map;
      elemt["ischeck"] = i == 0 ? true : false;

      typerLieu[i] = elemt;
    }

    notifyListeners();
    print(typerLieu);
    return response.data["response"];
  }

  Future<List<Lieu>> getLieuByTypeAndCampus(
      String id_campus, String typelieu) async {
    var data = {"typelieu": typelieu, "id_campus": id_campus};
    Dio.Response response = await dio().post("typeLieu/getlieu", data: data);
    print(response.data["lieu"]);
    return decodeListLieu1(response.data["lieu"]);
  }

  Future<List<Lieu>> getCampusLieu(String id_campus) async {
    var data = {"id_campus": id_campus};
    Dio.Response response = await dio().post("campus/getallplace/", data: data);
    print(response.data["lieu"]);
    return decodeListLieu(response.data["lieu"]);
  }

/*Future<List<Lieu>> getLieu() async {
   
    Dio.Response response = await dio().get("campus/getallplace/",);
    print(response.data["lieu"]);
    return decodeListLieu(response.data["lieu"]);
  }*/

  List<Lieu> decodeListLieu1(responseBody) {
    final parsed = responseBody;

    _listbytype = parsed.map<Lieu>((json) => Lieu.fromJson(json)).toList();
    notifyListeners();
    return parsed.map<Lieu>((json) => Lieu.fromJson(json)).toList();
  }

  List<Lieu> decodeListLieu(responseBody) {
    final parsed = responseBody;
    _list = parsed.map<Lieu>((json) => Lieu.fromJson(json)).toList();
    notifyListeners();
    return parsed.map<Lieu>((json) => Lieu.fromJson(json)).toList();
  }

  Future<Lieu> getCampusById(int id) async {
    Dio.Response response = await dio().get("publication/$id");
    // print(response.toString());
    return decodeCampus(response.data);
  }

  Lieu decodeCampus(responseBody) {
    return Lieu.fromJson(responseBody);
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
