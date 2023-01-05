import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycampus/Api/DioClient.dart';
import 'package:mycampus/Api/LieuService.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Models/Lieu.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animations/animations.dart';

class DetailPlace extends StatefulWidget {
  DetailPlace({Key key, @required this.lieu}) : super(key: key);
  Lieu lieu;
  @override
  State<DetailPlace> createState() => _DetailPlaceState();
}

class _DetailPlaceState extends State<DetailPlace> {
  bool _showDescription = true;
  ContainerTransitionType _containerTransitionType =
      ContainerTransitionType.fade;
  @override
  void initState() {
    // TODO: implement initState

    //  context.read<LieuService>().getLieuByTypeAndCampus(widget.campus.id);

    context
        .read<LieuService>()
        .getLieuByTypeAndCampus(widget.lieu.id_campus, widget.lieu.id_type);
  }

  CarouselController bouteon = CarouselController();

  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;
    final lieuProvider = context.watch<LieuService>();

    return Container(
      child: Stack(
        children: [
          Container(
            height: heigth * 0.45,
            width: widht,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/placeholder1.png"),
                    fit: BoxFit.cover)),
            child: CarouselSlider(
              options: CarouselOptions(
                height: heigth * 0.5,
                // autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                autoPlay: true,
                aspectRatio: 0,
                disableCenter: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {},
              ),
              carouselController: this.bouteon,
              items: widget.lieu.image.map((imag) {
                return Builder(builder: (BuildContext context) {
                  return Image.network(
                    baseurl + imag.split('\\').join("/"),
                    fit: BoxFit.cover,
                  );
                });
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: heigth * 0.6,
                width: widht,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: [
                    Text(
                      widget.lieu.intitule,
                      style: TextStyle(
                          fontSize: 18,
                          color: kFontlightColor,
                          fontFamily: "Roboto-Black"),
                      overflow: TextOverflow.visible,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: widht * 0.9,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showDescription = !_showDescription;
                          });
                        },
                        child: _showDescription
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.lieu.description,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: kFontlightColor,
                                        fontFamily: "Roboto-Light"),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  widget.lieu.description.length >= 100
                                      ? Container(
                                          width: widht * 0.9,
                                          child: Text(
                                            "voir plus",
                                            style: TextStyle(
                                                color: kPrimaryColors),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              )
                            : Text(
                                widget.lieu.description,
                                style: TextStyle(
                                    color: kFontlightColor,
                                    fontSize: 16,
                                    fontFamily: "Roboto-Light"),
                                overflow: TextOverflow.visible,
                              ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: widht,
                      height: heigth * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Latitude",
                                style: TextStyle(
                                    color: kFontlightColor,
                                    fontSize: 17,
                                    fontFamily: "Roboto-Medium"),
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                widget.lieu.lat.toString(),
                                style: TextStyle(
                                    color: kFontlightColor,
                                    fontSize: 13,
                                    fontFamily: "Roboto-Regular"),
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Longitude",
                                style: TextStyle(
                                    color: kFontlightColor,
                                    fontSize: 17,
                                    fontFamily: "Roboto-Medium"),
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                widget.lieu.long.toString(),
                                style: TextStyle(
                                    color: kFontlightColor,
                                    fontSize: 13,
                                    fontFamily: "Roboto-Regular"),
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "like",
                                style: TextStyle(
                                    color: kFontlightColor,
                                    fontSize: 17,
                                    fontFamily: "Roboto-Medium"),
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                "10",
                                style: TextStyle(
                                    color: kFontlightColor,
                                    fontSize: 13,
                                    fontFamily: "Roboto-Regular"),
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Espace Similaire",
                      style: TextStyle(
                          fontSize: 18,
                          color: kFontlightColor,
                          fontFamily: "Roboto-Black"),
                      overflow: TextOverflow.visible,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          lieuProvider.listbytype.length,
                          (index) => OpenContainer(
                                transitionType: _containerTransitionType,
                                transitionDuration: Duration(seconds: 1),
                                closedBuilder: (context, action) => Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  height: heigth * 0.3,
                                  width: widht * 0.95,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/placeholder1.png"),
                                          fit: BoxFit.cover),
                                      color: Colors.white24),
                                  child: Stack(children: [
                                    Image.network(
                                        baseurl +
                                            lieuProvider
                                                .listbytype[index].image[0]
                                                .split('\\')
                                                .join("/"),
                                        width: widht * 0.95,
                                        fit: BoxFit.cover),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: heigth * 0.1,
                                        width: widht * 0.95,
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        color: Colors.black54,
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              lieuProvider
                                                  .listbytype[index].intitule,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontFamily: "Roboto-Bold"),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  CupertinoIcons.heart,
                                                  color: kPrimaryColors,
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  lieuProvider
                                                      .listbytype[index].rating
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontFamily:
                                                          "Roboto-Bold"),
                                                )
                                              ],
                                            )
                                          ],
                                        )),
                                      ),
                                    )
                                  ]),
                                ),
                                openBuilder: (context, action) => DetailPlace(
                                    lieu: lieuProvider.listbytype[index]),
                              )),
                    )
                  ],
                )),
          ),
          Positioned(
              top: heigth * 0.05,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 25,
                  ))),
          Positioned(
              top: heigth * 0.35,
              left: widht * 0.75,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    CupertinoIcons.heart,
                    size: 24,
                    color: kPrimaryColors,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
