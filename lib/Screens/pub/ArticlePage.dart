import 'package:flutter/material.dart';
import 'package:mycampus/Api/DioClient.dart';
import 'package:mycampus/Api/PubService.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Screens/DetailArticle.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animations/animations.dart';

class ArticlePage extends StatefulWidget {
  ArticlePage({Key key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<PubService>().getnewPub();
    context.read<PubService>().getlistPub();
  }

  CarouselController bouteon = CarouselController();
  ContainerTransitionType _containerTransitionType =
      ContainerTransitionType.fade;
  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final widht = MediaQuery.of(context).size.width;
    final pubProvider = context.watch<PubService>();
    return Padding(
        //height: heigth,
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Wrap(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: heigth * 0.45,

                // autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                autoPlay: true,
                //aspectRatio: 0,
                disableCenter: true,
                viewportFraction: 0.7,
                onPageChanged: (index, reason) {},
              ),
              carouselController: this.bouteon,
              items: pubProvider.newPubs.map((pub) {
                return Builder(builder: (BuildContext context) {
                  return OpenContainer(
                    transitionType: _containerTransitionType,
                    transitionDuration: Duration(seconds: 1),
                    openBuilder: (context, action) => DetailArticle(pub: pub),
                    closedBuilder: (context, action) => Container(
                      width: widht * 0.45,
                      height: heigth * 0.45,
                      margin: EdgeInsets.only(
                        left: 8.0,
                      ),
                      decoration: BoxDecoration(
                          color: kContainerColors,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: heigth * 0.25,
                                width: widht,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/placeholder1.png")),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: Image.network(
                                  baseurl + pub.image[0].split('\\').join("/"),
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 8.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Column(children: [
                                Container(
                                  width: widht,
                                  child: Text(
                                    pub.intitule,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 25,
                                        fontFamily: "Roboto-Medium"),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  pub.description,
                                  // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tempor pulvinar orci consequat magna feugiat praesent aliquam est scelerisque.",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontFamily: "Roboto-Regular"),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Container(
                                  width: widht * .5,
                                  child: Text(
                                    pub.price.toString() + "FCFA",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 20,
                                        fontFamily: "Roboto-Black"),
                                    overflow: TextOverflow.visible,
                                  ),
                                )
                              ]),
                            )
                          ]),
                    ),
                  );
                });
              }).toList(),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              //  width: widht,
              child: Column(
                children: List.generate(
                    pubProvider.listPub.length,
                    (index) => OpenContainer(
                          transitionType: _containerTransitionType,
                          transitionDuration: Duration(seconds: 1),
                          openBuilder: (context, action) =>
                              DetailArticle(pub: pubProvider.listPub[index]),
                          closedBuilder: (context, action) => Container(
                            height: heigth * 0.1,
                            width: widht * 0.95,
                            margin: EdgeInsets.only(bottom: 8.0),
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: heigth * widht * 0.05,
                                  width: widht * 0.25,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/placeholder1.png")),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Image.network(
                                      baseurl +
                                          pubProvider.listPub[index].image[0]
                                              .split('\\')
                                              .join("/"),
                                      fit: BoxFit.cover),
                                ),
                                Container(
                                  width: widht * 0.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        //width: widht,
                                        child: Text(
                                          pubProvider.listPub[index].intitule,
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: kSecondaryColor,
                                              fontSize: 17,
                                              fontFamily: "Roboto-Medium"),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          pubProvider.listPub[index].price
                                                  .toString() +
                                              "FCFA",
                                          style: TextStyle(
                                              color: kSecondaryColor,
                                              fontSize: 20,
                                              fontFamily: "Roboto-Black"),
                                          overflow: TextOverflow.visible,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Icon(Icons.bookmark,
                                    size: 17, color: kPrimaryColors),
                              ],
                            ),
                          ),
                        )),
              ),
            )
          ],
        ));
  }
}
