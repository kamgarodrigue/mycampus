import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';

class DetailAnnonces extends StatefulWidget {
  DetailAnnonces({Key key}) : super(key: key);

  @override
  State<DetailAnnonces> createState() => _DetailAnnoncesState();
}

class _DetailAnnoncesState extends State<DetailAnnonces> {
  bool _showDescription = true;
  String desc =
      "Lorem ipsum dolor sit amet consectetur. Id morbi at lorem eu aliquam. Felis sed at mattis nec cursus. Erat id turpis facilisis consectetur. Aenean pellentesque orci nec tellus aliquam ornare. Donec viverra in mollis integer ut. Lobortis nunc id lacus tempor eget bibendum arcu eu enim. Tellus nibh enim varius et orci. Vestibulum lacus sed sit augue bibendum sapien faucibus commodo congue. Diamrhoncus bibendum tellus egestas tristique sit euismod. Mauris massa at ut mi blandit velit lectus eget volutpat. Sed amet sollicitudin nunc nulla posuere cras vestibulum massa. Auctor neque tincidunt mattis amet. Suspendisse lorem elit morbi vel.";

  @override
  Widget build(BuildContext context) {
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
              'Titre de l\'annonce',
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
        decoration: BoxDecoration(
            image: DecorationImage(
                // fit: BoxFit.cover,
                image: AssetImage("assets/images/anonbg.png"))),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/userprofil.png"),
                  radius: 20,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recteur",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    RichText(
                        text: TextSpan(
                            children: [
                          TextSpan(
                              text: " il y’a une heure ",
                              style: TextStyle(
                                  color: kBlack,
                                  fontSize: 15,
                                  fontFamily: 'Roboto-Light'))
                        ],
                            text: "02 Fev. 2023",
                            style: TextStyle(
                                color: kBlack,
                                fontSize: 15,
                                fontFamily: 'Roboto-Regular'))),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: "Source: ",
                style: TextStyle(
                  color: kBlack,
                  fontSize: 15,
                  fontFamily: 'Roboto-Regular',
                ),
                children: [
                  TextSpan(
                    text: "Département d'informatique",
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 15,
                      fontFamily: 'Roboto-Light',
                    ),
                  ),
                ],
              ),
            ),
            Container(
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
                            desc,
                            style: TextStyle(
                                fontSize: 16,
                                color: kFontlightColor,
                                fontFamily: "Roboto-Light"),
                            maxLines: 20,
                            overflow: TextOverflow.ellipsis,
                          ),
                          desc.length >= 1000
                              ? Container(
                                  child: Text(
                                    "voir plus",
                                    style: TextStyle(color: kPrimaryColors),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                )
                              : const SizedBox()
                        ],
                      )
                    : Text(
                        desc,
                        style: TextStyle(
                            color: kFontlightColor,
                            fontSize: 16,
                            fontFamily: "Roboto-Light"),
                        overflow: TextOverflow.visible,
                      ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.blue,
                        ),
                        //SizedBox(width: 8.0),
                        Text(
                          "Screenshot",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        //  SizedBox(width: 8.0),
                        Icon(
                          Icons.download_rounded,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.save,
                          color: Colors.blue,
                        ),
                        //SizedBox(width: 8.0),
                        Text(
                          "Telecharger...",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Icon(
                          Icons.download_rounded,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
