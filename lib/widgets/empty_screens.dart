import 'package:chamasoft/utilities/svg-icons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget emptyList({Color color, IconData iconData, String text}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          customIcons['no-data'],
          semanticsLabel: 'icon',
          height: 120.0,
        ),
        customTitleWithWrap(
            text: text,
            fontWeight: FontWeight.w700,
            fontSize: 14.0,
            textAlign: TextAlign.center,
            color: Colors.blueGrey[400])
      ],
    ),
  );
}

Widget betterEmptyList(
    {String title = "Nothing to display!", @required message}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SvgPicture.asset(
                customIcons['no-data'],
                semanticsLabel: 'icon',
                height: 120.0,
              ),
              customTitleWithWrap(
                  text: title,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                  textAlign: TextAlign.center,
                  color: Colors.blueGrey[400]),
              customTitleWithWrap(
                  text: message,
                  //fontWeight: FontWeight.w500,
                  fontSize: 12.0,
                  textAlign: TextAlign.center,
                  color: Colors.blueGrey[400])
            ],
          )),
    ],
  );
}
