import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';

Widget emptyList({Color color, IconData iconData, String text}) {
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Icon(
        iconData,
        size: 250,
        color: color.withOpacity(0.15),
      ),
      Padding(
        padding: EdgeInsets.all(SPACING_HUGE),
        child: customTitleWithWrap(text: text, fontWeight: FontWeight.w700, fontSize: 14.0, textAlign: TextAlign.center, color: color),
      )
    ],
  );
}
