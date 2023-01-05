import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Screens/HomePage.dart';
import 'package:mycampus/Screens/MapView.dart';
import 'package:mycampus/Screens/MapViewSearch.dart';
import 'package:mycampus/Screens/pub/homePub.dart';
import 'package:mycampus/Widgets/bottombar_item.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> with TickerProviderStateMixin {
  int activeTab = 0;
  List barItems = [
    {
      "icon": "assets/images/home-free-icon-font.png",
      "active_icon": "assets/images/home-free-icon-font (1).png",
      "page": HomePage(),
    },
    {
      "icon": "assets/images/panier1.png",
      "active_icon": "assets/images/panier.png",
      "page": HomePub(),
    },
    {
      "icon": "assets/images/carte (1).png",
      "active_icon": "assets/images/mapActive.jpg",
      "page": MapView(),
    },
    {
      "icon": "assets/images/search.jpeg",
      "active_icon": "assets/images/search.png",
      "page": MapViewSearch(),
    },
  ];

//====== set animation=====
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  animatedPage(page) {
    return FadeTransition(child: page, opacity: _animation);
  }

  void onPageChanged(int index) {
    _controller.reset();
    setState(() {
      activeTab = index;
    });
    _controller.forward();
  }

//====== end set animation=====

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Fermeture De L\'Aplication'),
              content: Text('Voulez vous fermer l aplication?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('Non'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Oui'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
          backgroundColor: whiteColor,
          bottomNavigationBar: getBottomBar(),
          body: getBarPage()),
    );
  }

  Widget getBarPage() {
    return IndexedStack(
        index: activeTab,
        children: List.generate(
            barItems.length, (index) => animatedPage(barItems[index]["page"])));
  }

  Widget getBottomBar() {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
          //  color: Color.fromARGB(221, 231, 230, 230).withOpacity(0.1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: kPrimaryColors.withOpacity(0.9),
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(1, 1))
          ]),
      child: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            bottom: 15,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  barItems.length,
                  (index) => BottomBarItem(
                        barItems[index]["icon"],
                        isActive: activeTab == index,
                        activeColor: kPrimaryColors,
                        onTap: () {
                          onPageChanged(index);
                        },
                      )))),
    );
  }
}
