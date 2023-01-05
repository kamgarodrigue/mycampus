import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';

class Item extends StatelessWidget {
  String image, titel, subtitle;
  Item(this.image, this.subtitle, this.titel);

  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            this.image,
            height: heigth * 0.3,
            width: widht * 0.58,
          ),
          title(this.titel),
          Container(
            width: widht * 0.9,
            child: subTitle(this.subtitle),
          )
        ],
      ),
    );
  }
}
