import 'dart:io';

import 'package:dio/dio.dart' as Dio;

import 'package:flutter/cupertino.dart';
import 'package:mycampus/Api/DioClient.dart';
import 'package:mycampus/Models/User.dart';
import 'package:mycampus/Screens/Identification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AuthService extends ChangeNotifier {
  Future<SharedPreferences> sharedPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref;
  }

  bool _isLoggedIn = false;
  bool get authenticate {
    sharedPreferences().then((value) {
      _isLoggedIn = value.getString("user") == null ? false : true;
      //  print(json.decode("${value.getString("user")}"));
      notifyListeners();
    });
    return this._isLoggedIn;
  }

  Future login(String email, String password) async {
    Map data = {
      "userName": email,
      "password": password,
    };

    SharedPreferences pref = await SharedPreferences.getInstance();

    Dio.Response response = await dio().post("users/login", data: data);

    return response;
  }

  Future getUserById(String id) async {
    Map data = {
      "userID": id,
    };

    Dio.Response response = await dio().post("users/show", data: data);

    return response.data;
  }

  Future register(
      String name,
      String dateNaissance,
      String sexe,
      // String pays,
      String gmail,
      password,
      // String vile,
      String tel,
      String address) async {
    Dio.FormData data = Dio.FormData.fromMap({
      "userName": name,
      //"avatar": Dio.MultipartFile.fromFile(image.path, filename: "profil.png"),
      "birthDay": dateNaissance,
      "sexe": sexe,
      "email": gmail,
      "phone": tel,
      "address": address,
      "password": password
    });
    Dio.Response response = await dio().post("users/register", data: {
      "userName": name,
      "avatar": "",
      "birthDay": dateNaissance,
      "sexe": sexe,
      "email": gmail,
      "phone": tel,
      "address": address,
      "password": password
    });
    // print(response.data.toString());
    return response;
  }

  Future Identification(User user, img) async {
    Map<String, dynamic> data1 = {
      "userID": user.id,
      "birthDay": user.dateOfBirth,
      "sexe": user.sexe,
      "email": user.email,
      "phone": user.telephone,
      "address": user.address,
      "faculte": user.faculte,
      "departement": user.departement,
    };
    var request =
        http.MultipartRequest("POST", Uri.parse(baseurl + "users/register"));

    request.files.add(await http.MultipartFile.fromBytes(
      "avatar",
      img,
      filename: "${user.name}.png",
      contentType: MediaType("image", "png"),
    ));

    request.fields.addAll(data1.cast<String, String>());
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final Responsedata = json.decode(responsed.body);
    print(Responsedata.toString());

    return responsed.body;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("user");
    notifyListeners();
  }
}
