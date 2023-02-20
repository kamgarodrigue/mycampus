import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Screens/DetailAnnonce.dart';

class Annonce extends StatefulWidget {
  Annonce({Key key}) : super(key: key);

  @override
  State<Annonce> createState() => _AnnonceState();
}

class _AnnonceState extends State<Annonce> {
  TabController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxScrolled) => [
            SliverAppBar(
              backgroundColor: whiteColor,
              pinned: true,
              floating: true,
              leading: Builder(
                  builder: (context) => (IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Image.asset(
                          "assets/images/logoApp.png",
                        ),
                      ))),
              title: Text(
                "Annonce",
                style: TextStyle(
                    color: kPrimaryColors, fontFamily: "Roboto-Black"),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeSearch()));*/
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: kBlack,
                      size: 30,
                    )),
              ],
              bottom: TabBar(
                physics: const ScrollPhysics(),
                isScrollable: false,
                labelColor: kPrimaryColors,
                indicatorColor: kSecondaryColor,
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.home),
                    text: "Tout",
                  ),
                  Tab(
                    icon: const Icon(Icons.home),
                    text: "Min Sup",
                  ),
                  Tab(
                      icon: const Icon(Icons.apartment_sharp),
                      text: "Rectorat"),
                  Tab(
                    icon: const Icon(Icons.shopping_cart),
                    text: "Décana",
                  ),
                  Tab(
                    icon: const Icon(Icons.shopping_cart),
                    text: "département",
                  ),
                ],
              ),
            )
          ],
          body: TabBarView(
            children: [
              Container(
                child: RefreshIndicator(
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: List.generate(
                        5,
                        (index) => Card(
                              elevation: 1,
                              child: Container(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                height: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Titre de l’annonce',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: kFontlightColor,
                                          fontFamily: "Roboto-Black"),
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      "Lorem ipsum dolor sit amet consectetur. Id morbi at lorem eu aliquam. Felis sed at mattis nec cursus. Erat id turpis facilisis consectetur. Aenean pellentesque orci nec tellus aliquam ornare. Donec viverra in mollis integer ut. ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: kFontlightColor,
                                          fontFamily: "Roboto-Light"),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailAnnonces(),
                                            ));
                                      },
                                      child: Text(
                                        "voir plus",
                                        style: TextStyle(color: kPrimaryColors),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                  ),
                  onRefresh: () => null,
                ),
              ),
              Container(),
              Container(),
              Container(),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
