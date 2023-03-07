import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycampus/Api/AuthService.dart';
import 'package:mycampus/Api/LieuService.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Models/User.dart';
import 'package:mycampus/Provider/AuthProvider.dart';
import 'package:mycampus/Provider/CampusProvider.dart';
import 'package:mycampus/Widgets/Button.dart';
import 'package:mycampus/Widgets/Intput.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class Identification extends StatefulWidget {
  Identification({Key key}) : super(key: key);

  @override
  State<Identification> createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
  Map valuname = {"value": "", "ontap": false};
  Map valuEmail = {"value": "", "ontap": false};
  Map valupasword = {"value": "", "ontap": false, "isobscure": false};
  bool _isLoading = false;
  File _image;

  DateTime date;
  Future getImage(ImageSource source) async {
    File pickedFile = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = pickedFile;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CampusProvider>().campusList();
    context.read<AuthProvider>().getUser();
  }

  String departement, faculte;
  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;
    final campusProvider = context.watch<CampusProvider>();
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: heigth * 0.1,
          ),
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
          ),
          Padding(
            padding: EdgeInsets.only(
                top: heigth * 0.01, left: widht * 0.04, right: widht * 0.04),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: whiteColor),
              child: DropdownButtonFormField<dynamic>(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 8)),
                hint: Text(" Choisir votre Faculté",
                    style: TextStyle(
                        color: kBlack,
                        fontSize: 17,
                        fontFamily: 'ComRegular.')),
                items: campusProvider.list
                    .map<DropdownMenuItem<dynamic>>((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(" " + e.intitule,
                              style: TextStyle(
                                  color: kBlack,
                                  fontSize: 17,
                                  fontFamily: 'ComRegular.')),
                        ))
                    .toList(),
                onChanged: (value) {
                  print(value);
                  context
                      .read<LieuService>()
                      .getLieuByTypeAndCampus(value, "6242d1d43d78410e3805cfa7")
                      .then((value) => print(value));
                  faculte = value.toString();
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: heigth * 0.01, left: widht * 0.04, right: widht * 0.04),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: whiteColor),
              child: DropdownButtonFormField<dynamic>(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 8)),
                hint: Text("Choisir votre  departement",
                    style: TextStyle(
                        color: kBlack,
                        fontSize: 17,
                        fontFamily: 'ComRegular.')),
                items: context
                    .read<LieuService>()
                    .listbytype
                    .map<DropdownMenuItem<dynamic>>((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(" " + e.intitule,
                              style: TextStyle(
                                  color: kBlack,
                                  fontSize: 17,
                                  fontFamily: 'ComRegular.')),
                        ))
                    .toList(),
                onChanged: (value) {
                  departement = value.toString();
                },
              ),
            ),
          ),
          SizedBox(
            height: heigth * 0.05,
          ),
          Button(
            fontSize: 16,
            heigth: 50,
            widht: widht * 0.9,
            fontFamily: 'Roboto-Black',
            color: faculte == "" || departement == ""
                ? kPrimaryColors.withOpacity(0.5)
                : kPrimaryColors,
            onTape: faculte == "" || departement == ""
                ? () {
                    setState(() {
                      this.valuname["ontap"] = true;
                      this.valuEmail["ontap"] = true;
                      this.valupasword["ontap"] = true;
                    });
                  }
                : () {
                    setState(() {
                      _isLoading = true;
                    });
                    User user = authProvider.user;
                    user.departement = departement;
                    user.faculte = faculte;
                    context
                        .read<AuthService>()
                        .Identification(user, _image)
                        .then((value) {
                      setState(() {
                        _isLoading = true;
                      });
                      context.read<AuthProvider>().getUser();

                      showTopSnackBar(
                        context,
                        CustomSnackBar.success(
                          message: "vous etes desormais etudiant",
                        ),
                      );
                    }).catchError((e) {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.info(
                          message: e.toString(),
                        ),
                      );
                      setState(() {
                        _isLoading = false;
                      });
                      print(e);
                    });
                    ;
                  },
            padding: EdgeInsets.only(
                //top: heigth * 0.6 * 0.04,
                left: widht * 0.04,
                right: widht * 0.04),
            raduis: 10,
            text: 'M\'identifier en tant que etudiant',
          ),
        ],
      ),
    )));
  }
}
