import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/textstyles.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';

PreferredSizeWidget secondaryPageAppbar(
    {@required BuildContext context,
    @required String title,
    action,
    double elevation,
    @required IconData leadingIcon,
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

PreferredSizeWidget secondaryPageTabbedAppbar(
    {@required BuildContext context,
    @required String title,
    action,
    @required double elevation,
    @required IconData leadingIcon,
    List<Widget> actions,
    PreferredSizeWidget bottom}) {
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
    bottom: bottom,
  );
}

PreferredSizeWidget tertiaryPageAppbar(
    {@required BuildContext context,
    @required String title,
    action,
    @required double elevation,
    @required IconData leadingIcon,
    IconData trailingIcon,
    trailingAction,
    List<Widget> actions}) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        screenActionButton(
          icon: leadingIcon,
          backgroundColor: primaryColor.withOpacity(0.1),
          textColor: primaryColor,
          action: action,
        ),
        SizedBox(width: 20.0),
        heading2(color: primaryColor, text: title),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              screenActionButton(
                icon: trailingIcon,
                backgroundColor: primaryColor.withOpacity(0.1),
                textColor: primaryColor,
                action: trailingAction,
              ),
            ],
          ),
        ),
      ],
    ),
    elevation: elevation,
    backgroundColor: Theme.of(context).backgroundColor,
    automaticallyImplyLeading: false,
    actions: actions,
  );
}
