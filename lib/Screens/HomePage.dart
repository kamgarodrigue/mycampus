import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycampus/Api/AuthService.dart';
import 'package:mycampus/Api/CampusService.dart';
import 'package:mycampus/Api/DioClient.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Models/Campus.dart';
import 'package:mycampus/Provider/CampusProvider.dart';
import 'package:mycampus/Screens/DetailFaculte.dart';
import 'package:mycampus/Screens/MapViewCampus.dart';
import 'package:mycampus/Screens/home_drawer.dart';

import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _showBottomSheetCallback() {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return Container();
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<CampusProvider>().campusList();
  }

  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;

    final campusProvider = context.watch<CampusProvider>();

    /*CampusService().getCampus().then(
      (value) {
        setState(() {
          campus = value;
        });
      },
    );*/
    ContainerTransitionType _containerTransitionType =
        ContainerTransitionType.fade;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "My Campus",
              style: TextStyle(
                  color: kPrimaryColors,
                  fontSize: 30,
                  fontFamily: 'Roboto-Black'),
            ),
            leading: Image.asset(
              "assets/images/logoApp.png",
            ),
            trailing: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  size: 30,
                  color: kPrimaryColors,
                )),
          ),
          /* SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
              ),
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return Container();
              }))*/

          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return RefreshIndicator(
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: OpenContainer(
                    transitionType: _containerTransitionType,
                    transitionDuration: Duration(seconds: 1),
                    openBuilder: (context, action) => MapViewCampus(
                        idcampus: campusProvider.list[index].id,
                        campus: campusProvider.list[index]),
                    closedBuilder: (context, action) => Container(
                      width: 400,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: []),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: kSecondaryColor,
                              size: 40,
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Detailfaculte(
                                            campus: campusProvider.list[index]),
                                      ));
                                },
                                icon: Icon(
                                  Icons.visibility,
                                  color: kPrimaryColors,
                                  size: 40,
                                )),
                            title: Text(
                              campusProvider.list[index].intitule,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "Roboto-Black",
                                  color: kSecondaryColor),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10.0),
                              child: Container(
                                width: widht * 0.85,
                                height: heigth * 0.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        baseurl +
                                            campusProvider.list[index].image,
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                              ))
                        ],
                      ),
                    ),
                  )),
              onRefresh: () => CampusService().getCampus().then(
                (value) {
                  setState(() {
                    //campus = value;
                  });
                },
              ),
            );
          }, childCount: campusProvider.list.length)),
        ],
      ),
    );
  }
}
/*
SliverAppBar(
            toolbarHeight: heigth * 0.1,
            backgroundColor: whiteColor,
            centerTitle: true,
            leading: Image.asset(
              "assets/images/logoApp.png",
            ),
            title: title("My Campus"),
            actions: [
              IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                    color: kPrimaryColors,
                  ))
            ],
          )
 */