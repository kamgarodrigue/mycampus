import 'package:flutter/cupertino.dart';

class Pub {
  String id, intitule, description, etatdelivraison;
  List<String> image;
  double price;
  int qte, ratin;
  bool disponibilite, isnew;
  Pub(
      {@required this.description,
      @required this.disponibilite,
      @required this.etatdelivraison,
      @required this.id,
      @required this.image,
      @required this.intitule,
      @required this.isnew,
      @required this.price,
      @required this.qte,
      @required this.ratin});
  factory Pub.fromJson(Map<String, dynamic> json) => Pub(
      description: json["description"],
      disponibilite: json["disponibilite"],
      etatdelivraison: json["etatdelivraison"],
      id: json["_id"],
      image: json["image"].toString().split(","),
      intitule: json["intitule"],
      isnew: json["isnew"],
      price: double.parse(json["prix"].toString()),
      qte: json["qte"],
      ratin: json["ratin"]);

  Map<String, dynamic> tojson() => {
        "_id": "624771d59f55b23b1492885b",
        "intitule": "TAPIOCA ERUS",
        "description":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
        "image":
            "upload\\pub\\1648849365137.jpg,upload\\pub\\1648849365139.jpg,upload\\pub\\1648849365141.jpg",
        "prix": 7500,
        "qte": 5,
        "ratin": 0,
        "disponibilite": true,
        "etatdelivraison": "en boutique",
        "isnew": true,
        "createdAt": "2022-04-01T21:42:45.753Z",
        "updatedAt": "2022-04-01T21:42:45.753Z",
        "__v": 0
      };
}
