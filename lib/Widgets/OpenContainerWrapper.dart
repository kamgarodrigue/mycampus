import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class OpenContainerWrapper extends StatelessWidget {
  OpenContainerWrapper(
      {@required this.closedBuilder,
      @required this.transitionType,
      @required this.onClosed,
      @required this.child});

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return child;
      },
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
