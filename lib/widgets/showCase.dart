import 'package:chamasoft/helpers/theme.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

Widget customShowCase(
    {BuildContext context,
    String title,
    String description,
    Widget child,
    Color textColor,
    GlobalKey key}) {
  return Showcase(
    key: key,
    child: child,
    title: title,
    targetShapeBorder: CircleBorder(),
    description: description,
    // overlayColor: primaryColor,
    tooltipBackgroundColor: primaryColor,
    // backgroundColor: primaryColor,
    targetBorderRadius: BorderRadius.all(Radius.circular(40)),
    //radius: BorderRadius.all(Radius.circular(40)),
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 13.0,
      fontFamily: 'SegoeUI',
    ),
    descTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 13.0,
        fontFamily: 'SegoeUI'),
    textColor: textColor,
  );
}
