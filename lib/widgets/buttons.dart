import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

Widget defaultButton({BuildContext context, String text, Function onPressed}) {
  return RaisedButton(
    color: primaryColor,
    child: Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Text(
        text,
        style: TextStyle(fontFamily: 'SegoeUI', fontWeight: FontWeight.w700),
      ),
    ),
    textColor: Colors.white,
    onPressed: onPressed,
  );
}

Widget screenActionButton(
    {IconData icon, Color backgroundColor, Color textColor, Function action, double buttonSize = 42.0, double iconSize = 22.0}) {
  return Container(
    width: buttonSize,
    height: buttonSize,
    child: FlatButton(
      padding: EdgeInsets.all(0.0),
      child: Icon(
        icon,
        size: iconSize,
      ),
      onPressed: action,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      textColor: textColor,
      color: backgroundColor,
    ),
  );
}

Widget groupInfoButton(
    {BuildContext context,
    IconData leadingIcon,
    IconData trailingIcon,
    bool hideTrailingIcon = false,
    Color backgroundColor,
    Color textColor,
    String title,
    String subtitle,
    String description = "",
    Color borderColor,
    Function action}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.only(bottom: 10.0),
    // height: 42.0,
    child: OutlineButton(
      padding: EdgeInsets.all(0.0),
      child: ListTile(
        dense: true,
        enabled: true,
        leading: Icon(
          leadingIcon,
          color: textColor.withOpacity(0.8),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            customTitle(
                text: title,
                color: textColor,
                //fontSize: 16,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start),
            FittedBox(
              child: Row(
                children: <Widget>[
                  customTitle(
                    text: subtitle,
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.w800,
                    fontSize: 12.0,
                  ),
                  (description != "")
                      ? customTitle(
                          text: ", " + description,
                          color: textColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
        trailing: hideTrailingIcon
            ? SizedBox()
            : Icon(
                trailingIcon,
                color: textColor.withOpacity(0.8),
                size: 16.0,
              ),
      ),
      onPressed: action,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
      borderSide: BorderSide(color: borderColor, style: BorderStyle.solid, width: 2),
      textColor: textColor,
      color: backgroundColor,
      highlightedBorderColor: borderColor,
    ),
  );
}

Widget smallBadgeButton({Color backgroundColor, String text, Color textColor, Function action, double buttonHeight = 24.0, double textSize = 12.0}) {
  return Container(
    height: buttonHeight,
    child: FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: customTitle(
        text: text,
        color: textColor,
        fontWeight: FontWeight.w400,
        fontSize: textSize,
      ),
      onPressed: action,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      textColor: textColor,
      color: backgroundColor,
    ),
  );
}

Widget smallBadgeButtonWithIcon(
    {Color backgroundColor,
    String text,
    Color textColor,
    Function action,
    double buttonHeight = 24.0,
    double textSize = 12.0,
    IconData iconData = LineAwesomeIcons.warning}) {
  return Container(
    height: buttonHeight,
    child: FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: textSize, fontFamily: 'SegoeUI'),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            iconData,
            size: 16.0,
          ),
        ],
      ),
      onPressed: action,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      textColor: textColor,
      color: backgroundColor,
    ),
  );
}

Widget cardAmountButton({String currency, String amount, Function action, double size, Color color}) {
  return FlatButton(
    padding: EdgeInsets.fromLTRB(16.0, 0.0, 6.0, 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "$currency ",
          style: TextStyle(
            color: color,
            fontSize: (size - 2.0),
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: size,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.end,
        ),
        SizedBox(
          width: 10.0,
        ),
        Icon(
          Feather.chevron_right,
          size: (size - 4.0),
          color: color.withOpacity(0.4),
        )
      ],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    onPressed: action,
    highlightColor: Colors.blueGrey.withOpacity(0.1),
  );
}

Widget plainButtonWithArrow({String text, Function action, double size, Color color, double spacing = 4.0}) {
  return FlatButton(
    padding: EdgeInsets.fromLTRB(16.0, 0.0, 6.0, 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: size,
            fontFamily: 'SegoeUI',
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.end,
        ),
        SizedBox(
          width: spacing,
        ),
        Icon(
          Feather.chevron_right,
          size: (size - 4.0),
          color: color.withOpacity(0.4),
        )
      ],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    onPressed: action,
    highlightColor: Colors.blueGrey.withOpacity(0.1),
  );
}

Widget plainButton({String text, Function action, double size, Color color, double spacing = 4.0}) {
  return FlatButton(
    padding: EdgeInsets.fromLTRB(16.0, 0.0, 6.0, 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: size,
            fontFamily: 'SegoeUI',
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: spacing,
        ),
      ],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    onPressed: action,
    highlightColor: Colors.blueGrey.withOpacity(0.1),
    splashColor: primaryColor,
  );
}

Widget paymentActionButton({bool isFlat = false, String text, IconData icon, double iconSize = 12.0, Color color, Function action, Color textColor}) {
  return (!isFlat)
      ? OutlineButton(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: customTitle(
                  text: text,
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                icon,
                color: textColor,
                size: iconSize,
              ),
            ],
          ),
          borderSide: BorderSide(
            width: 3.0,
            color: color,
          ),
          highlightColor: color.withOpacity(0.1),
          highlightedBorderColor: color,
          onPressed: action,
        )
      : FlatButton(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: customTitle(
                  text: text,
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                icon,
                color: textColor,
                size: iconSize,
              ),
            ],
          ),
          color: color,
          onPressed: action,
        );
}

Widget gridButton({BuildContext context, Color color, IconData icon, String title, String subtitle = "", Function action, bool isHighlighted, double margin = 18}) {
  return Container(
    margin: EdgeInsets.all(margin),
    height: 150,
    decoration: cardDecoration(gradient: isHighlighted ? csCardGradient() : plainCardGradient(context), context: context),
    child: FlatButton(
      padding: EdgeInsets.all(0),
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, children: <Widget>[
        Positioned(
          top: 0.0,
          right: 40.0,
          child: Icon(
            icon,
            size: 120.0,
            color: color.withOpacity(0.04),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 38.0,
              color: color.withOpacity(0.7),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0,
                  fontFamily: 'SegoeUI',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                subtitle,
                style: TextStyle(
                  color: color.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SegoeUI',
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      highlightColor: primaryColor.withOpacity(0.1),
      onPressed: action,
    ),
  );
}

Widget svgGridButton({BuildContext context, Color color, String icon, String title, String subtitle = "", Function action, bool isHighlighted, double margin = 18}) {
  return Container(
    margin: EdgeInsets.all(margin),
    height: 150,
    decoration: cardDecoration(gradient: isHighlighted ? csCardGradient() : plainCardGradient(context), context: context),
    child: FlatButton(
      padding: EdgeInsets.all(0),
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, children: <Widget>[
        Positioned(
          top: 0.0,
          right: 0.0,
          left: 0.0,
          child: SvgPicture.asset(
              icon,
              semanticsLabel: 'icon',
              height: 120.0,
            ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SvgPicture.asset(
            //   icon,
            //   semanticsLabel: 'icon',
            //   height: 100.0,
            // ),
            SizedBox(
              height: 100.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0,
                  fontFamily: 'SegoeUI',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                subtitle,
                style: TextStyle(
                  color: color.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SegoeUI',
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      highlightColor: primaryColor.withOpacity(0.1),
      onPressed: action,
    ),
  );
}

Widget statusChip({String text, Color textColor, Color backgroundColor}) {
  return Chip(
    label: customTitle(
      text: text,
      color: textColor,
      fontSize: 12.0,
    ),
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  );
}

Widget circleIconButton({IconData icon, Color color, Color backgroundColor, Function onPressed, double iconSize = 32.0, double padding = 2.0}) {
  return Container(
    padding: EdgeInsets.all(padding),
    decoration: ShapeDecoration(
      color: backgroundColor,
      shape: CircleBorder(),
    ),
    child: IconButton(
      icon: Icon(
        icon,
        size: iconSize,
      ),
      onPressed: onPressed,
      color: color,
    ),
  );
}

Widget negativeActionDialogButton({String text = "Cancel", Color color, Function action}) {
  return FlatButton(
    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        customTitle(
          text: text,
          color: color,
          fontWeight: FontWeight.w600,
        )
      ],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    onPressed: action,
    highlightColor: Colors.blueGrey.withOpacity(0.1),
    splashColor: primaryColor.withOpacity(0.2),
  );
}

Widget positiveActionDialogButton({String text, Color color, Function action}) {
  return FlatButton(
    padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
    child: customTitle(
      text: text,
      color: color,
      fontWeight: FontWeight.w600,
    ),
    onPressed: action,
    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
    textColor: primaryColor,
    color: primaryColor.withOpacity(0.2),
  );
}

ButtonTheme groupSetupButton(BuildContext context, String text, Function action) {
  return ButtonTheme(
    height: 36,
    child: FlatButton(
      onPressed: action,
      padding: EdgeInsets.only(left: 4, right: 4),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).hintColor, width: 1.0, style: BorderStyle.solid), borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: <Widget>[
          Icon(
            LineAwesomeIcons.plus,
            color: Theme.of(context).hintColor,
            size: 16,
          ),
          SizedBox(
            width: 5,
          ),
          customTitle(text: text, fontSize: 12, color: Theme.of(context).textSelectionHandleColor),
        ],
      ),
    ),
  );
}
