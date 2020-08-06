import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/svg-icons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget emptyList({Color color, IconData iconData, String text}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SvgPicture.asset(
        customIcons['no-data'],
        semanticsLabel: 'icon',
        height: 120.0,
      ),
      Padding(
        padding: EdgeInsets.all(SPACING_HUGE),
        child: customTitleWithWrap(
            text: text,
            //fontWeight: FontWeight.w500,
            //fontSize: 14.0,
            textAlign: TextAlign.center,
            color: color),
      )
    ],
  );
}
