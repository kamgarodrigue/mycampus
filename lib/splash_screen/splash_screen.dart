import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Screens/HomePage.dart';
import 'package:mycampus/Screens/LoginScreen.dart';
import 'package:mycampus/Screens/root_app.dart';
import 'package:mycampus/splash_screen/Slidermain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;
  @override
  void initState() {
    _loadWidget();
    super.initState();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: 5);
    return Timer(_duration, checkFirstSeen);
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _introSeen = (prefs.getString('user') == null);

    if (!_introSeen) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => RootApp()));
    } else {
      // await prefs.setBool('intro_seen', true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Slidermain()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
            child: Image.asset(
          'assets/images/logoApp.png',
        )),
        Positioned(
            bottom: 35,
            left: 15,
            right: 15,
            child: Center(child: title("My Campus")))
      ],
    ));
  }
}
