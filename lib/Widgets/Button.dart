// @dart=2.9
import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';

class Button extends StatefulWidget {
  final EdgeInsetsGeometry padding;

  final double heigth, raduis, widht, fontSize;
  Color color;
  final String text, fontFamily;

  final Function onTape;

  Button(
      {@required this.padding,
      @required this.widht,
      @required this.heigth,
      @required this.raduis,
      @required this.text,
      @required this.onTape,
      @required this.fontFamily,
      this.color,
      @required this.fontSize});

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTape,
      child: Padding(
        padding: widget.padding,
        child: Container(
            height: widget.heigth,
            width: widget.widht,
            decoration: BoxDecoration(
                color: widget.color == null ? kPrimaryColors : widget.color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.raduis),
                    bottomRight: Radius.circular(widget.raduis))),
            child: Center(
              child: Text(widget.text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.fontSize,
                      fontFamily: widget.fontFamily)),
            )),
      ),
    );
  }
}
