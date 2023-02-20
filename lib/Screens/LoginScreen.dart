import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mycampus/Api/AuthService.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Screens/ForgotPassword.dart';
import 'package:mycampus/Screens/HomePage.dart';
import 'package:mycampus/Screens/Singnup.dart';
import 'package:mycampus/Screens/root_app.dart';
import 'package:mycampus/Widgets/Button.dart';
import 'package:mycampus/Widgets/Intput.dart';
import 'package:mycampus/Widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Map valuEmail = {"value": "", "ontap": false};
  Map valupasword = {"value": "", "ontap": false, "isobscure": false};
  bool _isLoading = false, isLogin = true;
  setConexion() {
    this.setState(() {
      isLogin = !isLogin;
    });
  }

  bool isEmail(String string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
      return false;
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<AuthService>(
        create: (context) => AuthService(),
        child: Consumer<AuthService>(builder: (context, auth, child) {
          if (auth.authenticate) {
            return RootApp();
          } else {
            return isLogin
                ? Scaffold(
                    backgroundColor: whiteColor,
                    body: Stack(
                      children: [
                        Container(
                          height: heigth,
                          width: widht,
                          padding: EdgeInsets.only(top: heigth * .30),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/bacground.png"),
                                  fit: BoxFit.cover)),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              /* Image.asset(
                                "assets/images/logoApp.png",
                                height: heigth * 0.27,
                                width: widht * 0.58,
                              ),*/
                              Text(
                                "Connexion",
                                style: TextStyle(
                                    color: kSecondaryColor,
                                    fontSize: 30,
                                    fontFamily: 'Roboto-MediumItalic'),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: heigth * 0.01,
                                    left: widht * 0.04,
                                    right: widht * 0.04),
                                child: Input(
                                  isSide: false,
                                  contentPadding: EdgeInsets.zero,
                                  suffixIcon: this.valuEmail['ontap']
                                      ? !isEmail(this
                                              .valuEmail["value"]
                                              .toString())
                                          ? IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ))
                                          : null
                                      : null,
                                  fontSize: 17,
                                  heigth: heigth * 0.7 * 0.11,
                                  isObscureText: false,
                                  padding: EdgeInsets.only(
                                    left: widht * 0.038,
                                  ),
                                  raduis: 30.0,
                                  text: 'Email',
                                  color: kSecondaryColor,
                                  value: this.valuEmail["value"],
                                  onChanged: (value) {
                                    setState(() {
                                      this.valuEmail["value"] = value;
                                    });
                                  },
                                  type: 'email',
                                  getDate: () {
                                    setState(() {
                                      this.valuEmail["ontap"] = true;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: heigth * 0.01,
                                    left: widht * 0.04,
                                    right: widht * 0.04),
                                child: Input(
                                  isSide: false,
                                  contentPadding: EdgeInsets.zero,
                                  fontSize: 17,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      this.valupasword["isobscure"]
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: kPrimaryColors,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        this.valupasword["isobscure"] =
                                            !this.valupasword["isobscure"];
                                      });
                                    },
                                  ),
                                  heigth: heigth * 0.7 * 0.11,
                                  isObscureText: this.valupasword["isobscure"],
                                  padding: EdgeInsets.only(
                                    left: widht * 0.038,
                                  ),
                                  raduis: 30.0,
                                  text: 'Password',
                                  color: kSecondaryColor,
                                  value: this.valupasword["value"],
                                  onChanged: (value) {
                                    setState(() {
                                      this.valupasword["value"] = value;
                                    });
                                  },
                                  type: 'password',
                                  getDate: () {
                                    setState(() {
                                      this.valupasword["ontap"] = true;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 32),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()));
                                },
                                child: Text(
                                  'Forgot your password?',
                                  style: TextStyle(
                                      color: kPrimaryColors,
                                      fontSize: 17,
                                      fontFamily: 'Roboto-Light'),
                                ),
                              ),
                              SizedBox(height: 32),
                              Button(
                                fontSize: 24,
                                heigth: 50,
                                widht: widht * 0.6,
                                fontFamily: 'Roboto-Black',
                                color: this.valuEmail["value"] == "" ||
                                        !isEmail(
                                            this.valuEmail["value"].toString())
                                    ? kPrimaryColors.withOpacity(0.5)
                                    : kPrimaryColors,
                                onTape: this.valuEmail["value"] == "" ||
                                        !isEmail(
                                            this.valuEmail["value"].toString())
                                    ? () {
                                        setState(() {
                                          this.valuEmail["ontap"] = true;
                                        });
                                      }
                                    : () async {
                                        setState(() {
                                          _isLoading = true;
                                        });

                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();

                                        AuthService()
                                            .login(this.valuEmail["value"],
                                                this.valupasword["value"])
                                            .then((value) {
                                          print(value.data);
                                          if (value.data["user"] != null) {
                                            pref.setString(
                                                "user",
                                                value.data["user"]['_id']
                                                    .toString());
                                          }
                                          showTopSnackBar(
                                            context,
                                            CustomSnackBar.success(
                                              message: "connecté",
                                            ),
                                          );

                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }).catchError((e) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          print(e);
                                        });
                                      },
                                padding: EdgeInsets.only(
                                    //top: heigth * 0.6 * 0.04,
                                    left: widht * 0.04,
                                    right: widht * 0.04),
                                raduis: 10,
                                text: 'Se Connecter',
                              ),
                              SizedBox(height: 32),
                              GestureDetector(
                                onTap: () {
                                  this.setConexion();
                                },
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Don\'t have an account ? ',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontFamily: 'Roboto-Regular',
                                          fontSize: 17),
                                    ),
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                          color: kPrimaryColors,
                                          fontFamily: 'Livvic-ThinItalic',
                                          fontSize: 17),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _isLoading
                            ? Loader(loadingTxt: "traitement de donné en cour")
                            : Container()
                      ],
                    ))
                : SingUp(
                    goToLogin: setConexion,
                  );
          }
        }));
  }
}
