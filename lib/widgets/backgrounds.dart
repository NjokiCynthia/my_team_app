import 'package:flutter/material.dart';

BoxDecoration primaryGradient(BuildContext context) {
  return BoxDecoration(
      gradient: RadialGradient(
    colors: [
      Theme.of(context).backgroundColor,
      Theme.of(context).selectedRowColor
    ],
    radius: 2.0,
  ));
}

Gradient plainCardGradient(BuildContext context) {
  return LinearGradient(
    colors: [
      Theme.of(context).backgroundColor,
      Theme.of(context).focusColor
    ], //[Colors.white, Color(0xFFF8F8FF)],
    stops: [0.0, 1.0],
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    tileMode: TileMode.repeated,
  );
}

Gradient csCardGradient() {
  return LinearGradient(
    colors: [Color(0xFF00ABF2), Color(0xFF008CC5)],
    stops: [0.0, 1.0],
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    tileMode: TileMode.repeated,
  );
}

List<BoxShadow> mildShadow(Color color) {
  return [
    BoxShadow(
      color: color,
      blurRadius: 6.0,
      spreadRadius: 1.0,
      offset: Offset(
        2.0,
        2.0,
      ),
    ),
  ];
}

List<BoxShadow> appSwitcherShadow(Color color) {
  return [
    BoxShadow(
      color: color,
      blurRadius: 2.0,
      offset: Offset(
        0.0,
        2.0,
      ),
    ),
  ];
}

BoxDecoration cardDecoration({Gradient gradient, BuildContext context}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
    boxShadow: mildShadow(Theme.of(context).unselectedWidgetColor),
    gradient: gradient,
  );
}
