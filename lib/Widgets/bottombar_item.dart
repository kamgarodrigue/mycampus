import 'package:flutter/material.dart';
import 'package:mycampus/Constants.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(this.icon,
      {this.onTap,
      this.color = Colors.grey,
      this.activeColor = kPrimaryColors,
      this.isActive = false,
      this.isNotified = false});
  final String icon;
  final Color color;
  final Color activeColor;
  final bool isNotified;
  final bool isActive;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: whiteColor,
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: kSecondaryColor,
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 0), // changes position of shadow
              ),
          ],
        ),
        child: Image.asset(
          icon,
          color: isActive ? activeColor : color,
          width: 23,
          height: 23,
        ),
      ),
    );
  }
}
