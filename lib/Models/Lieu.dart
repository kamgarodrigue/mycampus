import 'package:flutter/cupertino.dart';

class Lieu {
  String id, intitule, description, id_campus, id_type;
  List<String> image;
  double lat, long;
  int rating;
  Lieu(
      {@required this.id,
      @required this.description,
      @required this.id_campus,
      @required this.id_type,
      @required this.image,
      @required this.intitule,
      @required this.lat,
      @required this.long,
      @required this.rating});
  factory Lieu.fromJson(Map<String, dynamic> json) => Lieu(
      id: json["_id"],
      description: json["description"],
      id_campus: json["id_campus"],
      id_type: json["id_type"],
      image: json["image"].toString().split(","),
      intitule: json["intitule"],
      lat: json["lat"],
      long: json["long"],
      rating: int.tryParse(json["rating"].toString()));
}
