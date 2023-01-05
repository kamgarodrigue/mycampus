import 'package:flutter/cupertino.dart';

class User {
  String name;
  String surname;
  String gender;
  String photo, address, id;
  String dateOfBirth;
  String email;
  String password;
  String telephone;

  User(
      {this.id,
      @required this.telephone,
      @required this.name,
      @required this.surname,
      @required this.gender,
      @required this.dateOfBirth,
      @required this.email,
      this.address,
      this.photo,
      @required this.password});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["userName"],
        photo: json["avatar"].toString().split('\\').join('/'),
        password: json['password'],
        telephone: json["phone"],
        email: json["email"],
        dateOfBirth: json['dateNaissance'],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": name,
        "email": email,
        "phone": telephone,
        "birthDay": dateOfBirth,
        "avatar": photo,
        "password": password,
        "address": address,
        "sexe": gender
      };
}
