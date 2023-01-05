import 'package:mycampus/Api/DioClient.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:mycampus/Api/LieuService.dart';
import 'package:mycampus/Models/Lieu.dart';

import '../Api/DioClient.dart';

class SearchLieu extends StatefulWidget {
  SearchLieu({Key key, this.onTap}) : super(key: key);
  final void Function(Lieu) onTap;
  @override
  State<SearchLieu> createState() => _SearchLieuState();
}

class _SearchLieuState extends State<SearchLieu> {
  List<Lieu> enterprises = [];

  List<Lieu> productfilter = [];
  List<Lieu> productinit = [];
  final TextEditingController _searchQuery = new TextEditingController();

  void initState() {
    super.initState();
    LieuService().getLieu1().then((value) {
      setState(() {
        productinit = value;
      });
    });
    print(productinit);
  }

  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Theme.of(context).bottomAppBarColor,
          title: TextField(
            controller: _searchQuery,
            autofocus: true,
            decoration: InputDecoration.collapsed(hintText: "recherche"),
            onChanged: (value) {
              productfilter = [];

              if (value == "") {
                setState(() {
                  enterprises = [];
                });
              } else {
                for (var i = 0; i < productinit.length; i++) {
                  if (productinit
                      .elementAt(i)
                      .intitule
                      .toLowerCase()
                      .contains(value.toLowerCase())) {
                    setState(() {
                      productfilter.add(productinit.elementAt(i));
                    });
                  }
                }
              }

              setState(() {
                enterprises = productfilter;
              });
            },
          ),
        ),
        body: this.enterprises.isEmpty
            ? Center(
                child: Text("Aucun resultat"),
              )
            : Container(
                height: heigth,
                width: widht,
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        enterprises.length,
                        (index) => Container(
                              child: ListTile(
                                onTap: () {
                                  widget.onTap(enterprises[index]);
                                  Navigator.of(context).pop();
                                },
                                title: Text(enterprises[index].intitule),
                              ),
                            )),
                  ),
                ),
              ));
  }
}
