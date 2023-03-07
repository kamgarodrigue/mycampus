import 'package:flutter/cupertino.dart';
import 'package:mycampus/Api/AuthService.dart';
import 'package:mycampus/Models/User.dart';

class AuthProvider extends ChangeNotifier {
  User _user = new User(
      telephone: "",
      id: "",
      photo: "",
      address: "",
      name: "",
      surname: "",
      gender: "",
      dateOfBirth: "",
      email: "",
      password: "");
  User get user => _user;
  getUser() {
    AuthService().sharedPreferences().then(
      (value) {
        print(value.getString("user"));
        AuthService().getUserById(value.getString("user")).then((value) {
          _user = User.fromJson(value["user"]);
          print(user.toJson());
          notifyListeners();
        }).catchError(() {});
      },
    );
  }
}
