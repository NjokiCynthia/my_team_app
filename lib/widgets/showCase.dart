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
    description: description,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 13.0,
      fontFamily: 'SegoeUI',
    ),
    descTextStyle: TextStyle(
        fontWeight: FontWeight.w300, fontSize: 12.0, fontFamily: 'SegoeUI'),
    textColor: textColor,
  );
}
