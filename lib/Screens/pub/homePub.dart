import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';
import 'package:mycampus/Screens/pub/ArticlePage.dart';

class HomePub extends StatefulWidget {
  HomePub({Key key}) : super(key: key);

  @override
  State<HomePub> createState() => _HomePubState();
}

class _HomePubState extends State<HomePub> {
  TabController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                "Pub",
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
                      Icons.search,
                      size: 30,
                    )),
              ],
              bottom: TabBar(
                physics: const ScrollPhysics(),
                isScrollable: false,
                labelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).indicatorColor,
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.home),
                    text: "Articles",
                  ),
                  Tab(
                      icon: const Icon(Icons.apartment_sharp),
                      text: "Boutiques"),
                  Tab(
                    icon: const Icon(Icons.shopping_cart),
                    text: "Panier",
                  ),
                ],
              ),
            )
          ],
          body: TabBarView(
            children: [ArticlePage(), Container(), Container()],
          ),
        ),
      ),
    );
  }
}
