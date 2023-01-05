import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: kSecondaryColor,
            )
          ],
        ),
      ),
    );
  }
}
