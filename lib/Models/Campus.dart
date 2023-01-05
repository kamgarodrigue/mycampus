import 'package:flutter/cupertino.dart';

class Campus {
  String id;
  String intitule, description;
  String image;
  double lat, long;

  Campus(
      {this.id,
      @required this.image,
      @required this.intitule,
      @required this.description,
      @required this.lat,
      @required this.long});

  factory Campus.fromJson(Map<String, dynamic> json) => Campus(
        id: json["_id"],
        image: json["image"].toString().split("\\").join('/'),
        intitule: json["intitule"],
        lat: json["lat"],
        long: json["long"],   
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "intitule": intitule,
        "image": image,
        "lat": lat,
        "long": long,
        "description": description
      };
}
