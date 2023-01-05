import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycampus/Api/AuthService.dart';
import 'package:mycampus/Api/DioClient.dart';
import 'package:mycampus/Models/User.dart';
import 'package:mycampus/Provider/AuthProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  BuildContext context;
  AppDrawer({Key key, this.context}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  User user = new User(
      telephone: "",
      id: "",
      photo: "",
      address: "",
      name: "",
      surname: "",
      gender: "",
      dateOfBirth: "",
      email: "",
      password: "");
  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthProvider>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Drawer(
        elevation: 12,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                  child: Stack(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 4.0,
                            color: Theme.of(context).backgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                NetworkImage(baseurl + authProvider.user.photo),
                            fit: BoxFit.cover)),
                  ),
                ],
              )),
            ),
            const Divider(
              height: 2,
            ),
            InkWell(
              onTap: () {
                /* Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyAccount()));*/
              },
              child: ListTile(
                leading: const Icon(
                  Icons.perm_identity_sharp,
                  color: Colors.cyan,
                ),
                title: Text(
                  "Mon compte",
                  style: const TextStyle(),
                ),
                trailing: const Icon(CupertinoIcons.forward),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            InkWell(
              onTap: () {
                /* Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Settings()));*/
              },
              child: ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.cyan,
                ),
                title: Text(
                  "Paramètres",
                  style: const TextStyle(),
                ),
                trailing: const Icon(CupertinoIcons.forward),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            InkWell(
              onTap: () {
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StoredFiles()));*/
              },
              child: ListTile(
                  leading: const Icon(
                    Icons.data_usage_outlined,
                    color: Colors.cyan,
                  ),
                  title: Text(
                    "",
                    style: const TextStyle(),
                  ),
                  trailing: const Icon(CupertinoIcons.forward)),
            ),
            const SizedBox(
              height: 5.0,
            ),
            InkWell(
              onTap: () {
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpCenter()));*/
              },
              child: ListTile(
                leading: const Icon(
                  Icons.help_center_outlined,
                  color: Colors.cyan,
                ),
                title: Text(
                  "à propos de nous",
                  style: const TextStyle(),
                ),
                trailing: const Icon(CupertinoIcons.forward),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            InkWell(
              onTap: () {
                /*  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Favourites()));*/
              },
              child: ListTile(
                leading: const Icon(
                  CupertinoIcons.heart,
                  color: Colors.cyan,
                ),
                title: Text(
                  "Favoris",
                  style: const TextStyle(),
                ),
                trailing: const Icon(CupertinoIcons.forward),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            InkWell(
              onTap: () {
                AuthService().logout();
                Navigator.pop(context);
                //  Navigator.push(context, MaterialPageRoute(builder: (_)=> const LoginForm()));
              },
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.cyan,
                ),
                title: Text(
                  "Déconnextion",
                  style: const TextStyle(),
                ),
                trailing: const Icon(CupertinoIcons.forward),
              ),
            ),
          ],
        ));
  }
}
