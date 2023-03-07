import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';
import 'package:mycampus/Api/AuthService.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Screens/ForgotPassword.dart';
import 'package:mycampus/Widgets/Button.dart';
import 'package:mycampus/Widgets/Intput.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:mycampus/Widgets/Loader.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class SingUp extends StatefulWidget {
  Function goToLogin;
  SingUp({Key key, @required this.goToLogin}) : super(key: key);

  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  int activeStep = 0; // Initial step set to 5.
  bool isloaging = false;
  int upperBound = 2; // upperBound MUST BE total number of icons minus 1.
  File _image;

  DateTime date;
  Future getImage(ImageSource source) async {
    File pickedFile = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = pickedFile;
    });
  }

  Map valuname = {"value": "", "ontap": false};
  Map valuEmail = {"value": "", "ontap": false};

  Map valudate = {"value": "Date de naissance", "ontap": false};
  Map valutel = {"value": "", "ontap": false};
  Map valusexe = {"value": "", "ontap": false};
  Map valuaddress = {"value": "", "ontap": false};
  Map valupasword = {"value": "", "ontap": false, "isobscure": false};
  bool _isLoading = false, isLogin = true;
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
    //setState(() {
    //  isloaging = false;
    // });
    return Scaffold(
        body: Container(
      child: Padding(
        padding: EdgeInsets.only(top: heigth * 0.05),
        child: Column(
          children: [
            IconStepper(
              activeStepBorderColor: kPrimaryColors,
              stepColor: kSecondaryColor,
              enableNextPreviousButtons: false,
              //  enableStepTapping: false,
              icons: [
                const Icon(Icons.supervised_user_circle, color: whiteColor),
                const Icon(Icons.flag, color: whiteColor),
              ],

              // activeStep property set to activeStep variable defined above.
              activeStep: activeStep,

              // This ensures step-tapping updates the activeStep.
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
            Expanded(
                child: Container(
              child: Stack(
                children: [
                  activeStep == 0 ? bodyStep1(context) : bodyStep2(context),
                  isloaging
                      ? Loader(loadingTxt: "traitement de donné en cour")
                      : Container()
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      },
      child: const Text('Next'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: const Text('Prev'),
    );
  }

  Widget bodyStep1(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: heigth * 0.05,
          ),
          Image.asset(
            "assets/images/logoApp.png",
            height: 100,
            width: 100,
          ),
          SizedBox(height: 32),
          Text(
            "Enregistrement",
            style: TextStyle(
                color: kSecondaryColor,
                fontSize: 30,
                fontFamily: 'Roboto-MediumItalic'),
            textAlign: TextAlign.center,
          ),

          /* 
          InkWell(
            onTap: () => getImage(ImageSource.gallery),
            child: Stack(
              children: [
                Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4.0, color: kPrimaryColors),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 10))
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: FadeInImage(
                              placeholder:
                                  const AssetImage("assets/placeholder1.png"),
                              image: FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const FadeInImage(
                              placeholder:
                                  AssetImage("assets/placeholder1.png"),
                              image: AssetImage("assets/placeholder1.png"),
                              fit: BoxFit.cover,
                            ),
                          )),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () => getImage(ImageSource.camera),
                      child: Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 4.0, color: kSecondaryColor),
                            color: kPrimaryColors,
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.linked_camera,
                          color: whiteColor,
                        ),
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: heigth * 0.02,
          ),
          Text(
            'Ajouter une image de profil',
            style: TextStyle(
                color: kSecondaryColor,
                fontSize: 17,
                fontFamily: 'Roboto-Light'),
          ),
          SizedBox(
            height: heigth * 0.02,
          ),*/
          Padding(
            padding: EdgeInsets.only(
                top: heigth * 0.01, left: widht * 0.04, right: widht * 0.04),
            child: Input(
              isSide: false,
              contentPadding: EdgeInsets.zero,
              fontSize: 17,
              heigth: heigth * 0.7 * 0.11,
              suffixIcon: valuname["ontap"]
                  ? this.valuname["value"].toString() == ""
                      ? IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.error,
                            color: Colors.red,
                          ))
                      : null
                  : null,
              isObscureText: false,
              padding: EdgeInsets.only(
                left: widht * 0.038,
              ),
              raduis: 30.0,
              text: 'Nom complet',
              color: kSecondaryColor,
              value: this.valuname["value"],
              onChanged: (value) {
                setState(() {
                  this.valuname["value"] = value;
                });
              },
              type: 'email',
              getDate: () {
                setState(() {
                  this.valuname["ontap"] = true;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: heigth * 0.01, left: widht * 0.04, right: widht * 0.04),
            child: Input(
              isSide: false,
              contentPadding: EdgeInsets.zero,
              fontSize: 17,
              heigth: heigth * 0.7 * 0.11,
              isObscureText: false,
              padding: EdgeInsets.only(
                left: widht * 0.038,
              ),
              raduis: 30.0,
              suffixIcon: valuEmail["ontap"]
                  ? !isEmail(this.valuEmail["value"])
                      ? IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.error,
                            color: Colors.red,
                          ))
                      : null
                  : null,
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
                top: heigth * 0.01, left: widht * 0.04, right: widht * 0.04),
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
          valupasword["ontap"]
              ? this.valupasword["value"].toString().length < 6
                  ? Text(
                      'mot de passe trop faible',
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: 'Roboto-Light'),
                    )
                  : Container()
              : Container(),
          SizedBox(
            height: heigth * 0.05,
          ),
          Row(
            children: [
              Button(
                fontSize: 24,
                heigth: 50,
                widht: widht * 0.4,
                fontFamily: 'Roboto-Black',
                color: kSecondaryColor,
                onTape: () => widget.goToLogin(),
                padding: EdgeInsets.only(
                    //top: heigth * 0.6 * 0.04,
                    left: widht * 0.04,
                    right: widht * 0.04),
                raduis: 10,
                text: 'Login',
              ),
              Button(
                fontSize: 24,
                heigth: 50,
                widht: widht * 0.4,
                fontFamily: 'Roboto-Black',
                color: this.valuname["value"] == "" ||
                        this.valuEmail["value"] == "" ||
                        this.valupasword["value"] == ""
                    ? kPrimaryColors.withOpacity(0.5)
                    : kPrimaryColors,
                onTape: this.valuname["value"] == "" ||
                        this.valuEmail["value"] == "" ||
                        this.valupasword["value"] == ""
                    ? () {
                        setState(() {
                          this.valuname["ontap"] = true;
                          this.valuEmail["ontap"] = true;
                          this.valupasword["ontap"] = true;
                        });
                      }
                    : () {
                        setState(() {
                          isloaging = true;
                        });
                        var _duration = Duration(seconds: 3);
                        return Timer(_duration, () {
                          if (activeStep < upperBound) {
                            isloaging = false;
                            setState(() {
                              activeStep++;
                            });
                          }
                        });
                      },
                padding: EdgeInsets.only(
                    //top: heigth * 0.6 * 0.04,
                    left: widht * 0.04,
                    right: widht * 0.04),
                raduis: 10,
                text: 'Next',
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget bodyStep2(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;
    bool _isBackPressedOrTouchedOutSide = false,
        _isDropDownOpened = false,
        _isPanDown = false;
    String _selectedItem = '';
    List<String> _list = ["Sexe", "Masculin", "Feminin"];
    return ListView(
      children: [
        SizedBox(
          height: heigth * 0.05,
        ),
        const Text(
          'Information supplementaire',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: kSecondaryColor, fontSize: 20, fontFamily: 'Roboto-Light'),
        ),
        SizedBox(
          height: heigth * 0.05,
        ),
        Padding(
          padding: EdgeInsets.only(
              top: heigth * 0.01, left: widht * 0.04, right: widht * 0.04),
          child: Input(
            isSide: false,
            contentPadding: EdgeInsets.zero,
            fontSize: 17,
            heigth: heigth * 0.7 * 0.11,
            prefixIcon: const Icon(
              Icons.phone,
              color: kPrimaryColors,
            ),
            suffixIcon: this.valutel["ontap"]
                ? this.valutel["value"].toString().length < 9 ||
                        this.valutel["value"].toString().length > 9
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.error,
                          color: Colors.red,
                        ))
                    : null
                : null,
            isObscureText: false,
            padding: EdgeInsets.only(
              left: widht * 0.038,
            ),
            raduis: 30.0,
            text: 'Telephone',
            color: kSecondaryColor,
            value: this.valutel["value"],
            onChanged: (value) {
              setState(() {
                this.valutel["value"] = value;
              });
            },
            type: 'number',
            getDate: () {
              setState(() {
                this.valutel["ontap"] = true;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: heigth * 0.01, left: widht * 0.04, right: widht * 0.04),
          child: Input(
            type: 'date',
            isSide: false,
            prefixIcon: Icon(
              Icons.calendar_today,
              color: kPrimaryColors,
            ),
            suffixIcon: valudate["ontap"]
                ? this.valudate["value"] == "Date de naissance"
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.error,
                          color: Colors.red,
                        ))
                    : null
                : null,
            contentPadding: EdgeInsets.zero,
            fontSize: 17,
            heigth: heigth * 0.7 * 0.11,
            isObscureText: false,
            padding: EdgeInsets.only(
              left: widht * 0.038,
            ),
            raduis: 30.0,
            text: valudate["value"],
            //value: this.dateinput.text,
            getDate: () async {
              DateTime pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(
                      1970), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                print(
                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                print(
                    formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  valudate["value"] = formattedDate;

                  //set output date to TextField value.
                });
              } else {
                print("Date is not selected");
              }
            },
            onChanged: (val) {},
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
                top: heigth * 0.01, left: widht * 0.04, right: widht * 0.04),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 218, 214, 214), //Colors.grey[300],
                  borderRadius: BorderRadius.circular(20)),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: kFontlightColor,
                        fontSize: 17,
                        fontFamily: 'Roboto-MediumItalic'),
                    hintText: 'Choisisser votre sexe'),
                items: _list.map((univ) {
                  return DropdownMenuItem<String>(
                    value: univ,
                    child: Text(univ),
                  );
                }).toList(),
                onChanged: (id) {
                  setState(() {
                    valusexe["value"] = id;
                  });
                },
              ),
            )),
        valusexe["ontap"]
            ? this.valusexe["value"] == ""
                ? Text(
                    'selectioner votre sexe',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontFamily: 'Roboto-Light'),
                  )
                : Container()
            : Container(),
        Padding(
          padding: EdgeInsets.only(
              top: heigth * 0.01, left: widht * 0.04, right: widht * 0.04),
          child: Input(
            isSide: false,
            contentPadding: EdgeInsets.zero,
            fontSize: 17,
            heigth: heigth * 0.7 * 0.11,
            prefixIcon: const Icon(
              Icons.location_on,
              color: kPrimaryColors,
            ),
            suffixIcon: valuaddress["ontap"]
                ? this.valuaddress["value"].toString() == ""
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.error,
                          color: Colors.red,
                        ))
                    : null
                : null,
            isObscureText: false,
            padding: EdgeInsets.only(
              left: widht * 0.038,
            ),
            raduis: 30.0,
            text: 'Address',
            color: kSecondaryColor,
            value: this.valuaddress["value"],
            onChanged: (value) {
              setState(() {
                this.valuaddress["value"] = value;
              });
            },
            type: 'area',
            getDate: () {
              setState(() {
                this.valuaddress["ontap"] = true;
              });
            },
          ),
        ),
        SizedBox(
          height: heigth * 0.05,
        ),
        Row(
          children: [
            Button(
              fontSize: 24,
              heigth: 50,
              widht: widht * 0.4,
              fontFamily: 'Roboto-Black',
              color: kSecondaryColor,
              onTape: () {
                if (activeStep < upperBound) {
                  setState(() {
                    activeStep--;
                  });
                }
              },
              padding: EdgeInsets.only(
                  //top: heigth * 0.6 * 0.04,
                  left: widht * 0.04,
                  right: widht * 0.04),
              raduis: 10,
              text: 'Back',
            ),
            Button(
              fontSize: 24,
              heigth: 50,
              widht: widht * 0.4,
              fontFamily: 'Roboto-Black',
              color: this.valutel["value"].toString().length < 9 ||
                      this.valutel["value"].toString().length > 9 ||
                      this.valudate["value"] == "" ||
                      this.valusexe["value"] == "Sexe" ||
                      this.valuaddress["value"] == ""
                  ? kPrimaryColors.withOpacity(0.5)
                  : kPrimaryColors,
              onTape: this.valutel["value"] == "" ||
                      this.valudate["value"] == "" ||
                      this.valusexe["value"] == "Sexe" ||
                      this.valuaddress["value"] == ""
                  ? () {
                      setState(() {
                        this.valutel["ontap"] = true;
                        this.valudate["ontap"] = true;
                        this.valusexe["ontap"] = true;
                        this.valuaddress["ontap"] = true;
                      });
                    }
                  : () {
                      setState(() {
                        isloaging = true;
                      });
                      AuthService()
                          .register(
                              this.valuname['value'],
                              valudate['value'],
                              valusexe['value'],
                              valuEmail['value'],
                              valupasword['value'],
                              valutel['value'],
                              valuaddress['value'])
                          .then((value) {
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            message: "compte crée",
                          ),
                        );
                        setState(() {
                          isloaging = false;
                        });
                        // Navigator.of(context).pop();
                      }).catchError((e) {
                        print(e.response.data);
                        setState(() {
                          isloaging = false;
                        });
                      });

                      /* var _duration = Duration(seconds: 3);
                      return Timer(_duration, () {
                        if (activeStep < upperBound) {
                          isloaging = false;
                        }
                      });*/
                    },
              padding: EdgeInsets.only(
                  //top: heigth * 0.6 * 0.04,
                  left: widht * 0.04,
                  right: widht * 0.04),
              raduis: 10,
              text: 'Register',
            ),
          ],
        )
      ],
    );
  }

  /// Returns the header wrapping the header text.

  // Returns the header text based on the activeStep.
  // ignore: missing_return
}
