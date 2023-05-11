import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
import 'package:file_picker/file_picker.dart';


class Identification extends StatefulWidget {
  Function goToLogin;
  Identification({Key key, @required this.goToLogin}) : super(key: key);

  @override
  _IdentificationState createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: whiteColor,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.green),
          title: Row(
            children: [
              SizedBox(width: 10),

              // crossAxisAlignment: CrossAxisAlignment.start,

              Text(
                'Identification',
                style: TextStyle(
                    fontSize: 18,
                    color: kFontlightColor,
                    fontFamily: "Roboto-Black"),
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
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
                      activeStep == 0
                          ? _bodyStep1(context)
                          : bodyStep2(context),
                      isloaging
                          ? Loader(loadingTxt: "traitement des donnés en cour")
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

  Widget _bodyStep1(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: heigth * 0.05,
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
              text: 'Université',
              color: kSecondaryColor,
              value: this.valuname["value"],
              onChanged: (value) {
                setState(() {
                  this.valuname["value"] = value;
                });
              },
              type: 'text',
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
              text: 'Faculté',
              color: kSecondaryColor,
              value: this.valuname["value"],
              onChanged: (value) {
                setState(() {
                  this.valuname["value"] = value;
                });
              },
              type: 'text',
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
              text: 'Departement',
              color: kSecondaryColor,
              value: this.valuname["value"],
              onChanged: (value) {
                setState(() {
                  this.valuname["value"] = value;
                });
              },
              type: 'text',
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
              text: 'Filière',
              color: kSecondaryColor,
              value: this.valuname["value"],
              onChanged: (value) {
                setState(() {
                  this.valuname["value"] = value;
                });
              },
              type: 'text',
              getDate: () {
                setState(() {
                  this.valuname["ontap"] = true;
                });
              },
            ),
          ),
          SizedBox(
            height: heigth * 0.05,
          ),
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
            text: 'Niveau',
            color: kSecondaryColor,
            value: this.valutel["value"],
            onChanged: (value) {
              setState(() {
                this.valutel["value"] = value;
              });
            },
            type: 'text',
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
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  // color: Color.fromARGB(255, 218, 214, 214), //Colors.grey[300],
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
        SizedBox(
          height: heigth * 0.05,
        ),
        Column(
  children: [
    InkWell(
     onTap: () async {
    // Ouvrir la galerie d'images
    /*final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    // Vérifier si l'utilisateur a sélectionné une image
    if (pickedFile != null) {
      // Créer un fichier à partir de l'image sélectionnée
      final imageFile = File(pickedFile.path);

      // Afficher l'image dans le CircleAvatar
      setState(() {
        _profileImageFile = imageFile;
      });
    }
    */
  },
      child: CircleAvatar(
        backgroundColor: Colors.grey[200],
        radius: 50,
        child: Icon(
          MdiIcons.cameraPlus,
          size: 40,
          color: Colors.grey[700],
        ),
      ),
    ),
    SizedBox(height: 10),
    Text(
      'Choisir une image',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
      ),
    ),
  ],
),

        SizedBox(
          height: heigth * 0.05,
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
                    Navigator.of(context).pop();
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
          text: 'Enregistrer',
        ),
      ],
    );
  }

  /// Returns the header wrapping the header text.

  // Returns the header text based on the activeStep.
  // ignore: missing_return
}
