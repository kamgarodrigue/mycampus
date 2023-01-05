import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';

class Input extends StatefulWidget {
  final String value, text;

  final bool isObscureText;
  bool isSide;
  final double fontSize, heigth, raduis, width;

  final EdgeInsetsGeometry padding, contentPadding;
  final Icon prefixIcon;
  final IconButton suffixIcon;
  String type = '';
  Color color;
  final void Function() getDate;
  final void Function(String) validator;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  Input(
      {this.isSide,
      this.color,
      this.type,
      this.validator,
      this.controller,
      @required this.width,
      @required this.contentPadding,
      @required this.isObscureText,
      this.onChanged,
      @required this.value,
      @required this.fontSize,
      @required this.text,
      @required this.raduis,
      @required this.padding,
      @required this.heigth,
      this.getDate,
      this.prefixIcon,
      this.suffixIcon});

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  String value;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: widget.padding,
        height: widget.heigth,
        width: widget.width,
        decoration: widget.isSide
            ? BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 1), //Colors.grey[300],
                borderRadius: BorderRadius.circular(widget.raduis),
                border: Border(
                  bottom: BorderSide(
                    color: widget.color,
                  ),
                  right: BorderSide(color: widget.color),
                  left: BorderSide(color: widget.color),
                  top: BorderSide(color: widget.color),
                ))
            : BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 1), //Colors.grey[300],
                borderRadius: BorderRadius.circular(widget.raduis),
              ),
        child: Center(
          child: widget.type.toLowerCase() == 'area'
              ? TextFormField(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 5,
                  controller: widget.controller,
                  initialValue: widget.value,
                  cursorColor: kPrimaryColors,
                  validator: widget.validator,
                  style: TextStyle(
                      color: kFontlightColor,
                      fontSize: widget.fontSize,
                      fontFamily: 'Roboto-MediumItalic'),
                  decoration: InputDecoration(
                      prefixIcon: widget.prefixIcon,
                      suffixIcon: widget.suffixIcon,
                      hintText: widget.text,

                      //    contentPadding: widget.contentPadding,
                      hintStyle: TextStyle(
                          color: kFontlightColor,
                          fontSize: widget.fontSize,
                          fontFamily: 'Roboto-MediumItalic'),
                      border: InputBorder.none),
                  onChanged: widget.onChanged,
                  obscureText: widget.isObscureText,
                  onTap: () => widget.getDate(),
                )
              : TextFormField(
                  keyboardType: widget.type.toLowerCase() == 'number'
                      ? TextInputType.number
                      : TextInputType.text,
                  controller: widget.controller,
                  cursorColor: kPrimaryColors,
                  validator: widget.validator,
                  initialValue: widget.value,
                  style: TextStyle(
                      color: kFontlightColor,
                      fontSize: widget.fontSize,
                      fontFamily: 'Roboto-MediumItalic'),
                  decoration: InputDecoration(
                      prefixIcon: widget.prefixIcon,
                      suffixIcon: widget.suffixIcon,
                      hintText: widget.text,

                      //  contentPadding: widget.contentPadding,
                      hintStyle: TextStyle(
                          color: kFontlightColor,
                          fontSize: widget.fontSize,
                          fontFamily: 'Roboto-MediumItalic'),
                      border: InputBorder.none),
                  onChanged: widget.onChanged,
                  obscureText: widget.isObscureText,
                  onTap: () => widget.getDate(),
                ),
        ));
  }
}
