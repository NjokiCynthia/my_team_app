import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'buttons.dart';

Widget primaryPageAppBar({String title}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    centerTitle: false,
    title: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w900,
            fontSize: 22.0),
      ),
    ),
    elevation: 0.5,
    automaticallyImplyLeading: false,
    actions: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 15.0, right: 12.0),
        child: IconButton(
          icon: Icon(LineAwesomeIcons.close, color: primaryColor),
          iconSize: 22.0,
          onPressed: () {},
        ),
      )
    ],
    flexibleSpace: Container(
      height: 100,
    ),
  );
}

Widget secondaryPageAppbar(
    {BuildContext context,
    String title,
    Function action,
    double elevation,
    IconData leadingIcon,
    List<Widget> actions}) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        screenActionButton(
          icon: leadingIcon,
          backgroundColor: primaryColor.withOpacity(0.1),
          textColor: primaryColor,
          action: action,
        ),
        SizedBox(width: 20.0),
        heading2(color: primaryColor, text: title),
      ],
    ),
    elevation: elevation,
    backgroundColor: Theme.of(context).backgroundColor,
    automaticallyImplyLeading: false,
    actions: actions,
  );
}

Widget tertiaryPageAppbar(
    {BuildContext context,
    String title,
    Function action,
    double elevation,
    IconData leadingIcon,
    IconData trailingIcon,
    Function trailingAction,
    List<Widget> actions}) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        screenActionButton(
          icon: leadingIcon,
          backgroundColor: primaryColor.withOpacity(0.1),
          textColor: primaryColor,
          action: action,
        ),
        heading2(color: primaryColor, text: title),
        screenActionButton(
          icon: trailingIcon,
          backgroundColor: primaryColor.withOpacity(0.1),
          textColor: primaryColor,
          action: trailingAction,
        ),
      ],
    ),
    elevation: elevation,
    backgroundColor: Theme.of(context).backgroundColor,
    automaticallyImplyLeading: false,
    actions: actions,
  );
}
