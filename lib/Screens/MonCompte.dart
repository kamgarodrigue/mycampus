import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';

class Moncompte extends StatefulWidget {
  Moncompte({Key key}) : super(key: key);

  @override
  State<Moncompte> createState() => _MoncompteState();
}

class _MoncompteState extends State<Moncompte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Mon compte",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Moncompte()));
          },
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.cyan,
                ),
                title: const Text(
                  "Mes informations",
                  style: TextStyle(),
                ),
              ),
              const Divider(),
              
              ListTile(
                leading: const Icon(
                  Icons.perm_identity_sharp,
                  color: Colors.cyan,
                ),
                title: const Text(
                  "Identification",
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
