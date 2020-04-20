import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

Widget defaultButton({BuildContext context, String text, Function onPressed}) {
  return RaisedButton(
    color: primaryColor,
    child: Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Text(text),
    ),
    textColor: Colors.white,
    onPressed: onPressed,
  );
}

Widget screenActionButton(
    {IconData icon,
    Color backgroundColor,
    Color textColor,
    Function action,
    double buttonSize = 42.0,
    double iconSize = 22.0}) {
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
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
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
            SizedBox(
              height: 10,
            ),
            customTitle(
                text: title,
                color: textColor,
                //fontSize: 16,
                fontWeight: FontWeight.w700,
                align: TextAlign.start),
//            Text(
//              title,
//              style: TextStyle(
//                color: textColor,
//                fontWeight: FontWeight.w700,
//                fontSize: 18.0,
//              ),
//              maxLines: 1,
//              overflow: TextOverflow.ellipsis,
//            ),
            Row(
              children: <Widget>[
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.w800,
                    fontSize: 12.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                (description != "")
                    ? Text(
                        ", " + description,
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 10,
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
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(50.0)),
      borderSide:
          BorderSide(color: borderColor, style: BorderStyle.solid, width: 2),
      textColor: textColor,
      color: backgroundColor,
      highlightedBorderColor: borderColor,
    ),
  );
}

Widget smallBadgeButton(
    {Color backgroundColor,
    String text,
    Color textColor,
    Function action,
    double buttonHeight = 24.0,
    double textSize = 12.0}) {
  return Container(
    height: buttonHeight,
    child: FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w400,
          fontSize: textSize,
        ),
      ),
      onPressed: action,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      textColor: textColor,
      color: backgroundColor,
    ),
  );
}

Widget cardAmountButton(
    {String currency,
    String amount,
    Function action,
    double size,
    Color color}) {
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

Widget plainButtonWithArrow(
    {String text,
    Function action,
    double size,
    Color color,
    double spacing = 4.0}) {
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

Widget plainButton(
    {String text,
    Function action,
    double size,
    Color color,
    double spacing = 4.0}) {
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
            fontWeight: FontWeight.w800,
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
  );
}

Widget paymentActionButton(
    {bool isFlat = false,
    String text,
    IconData icon,
    double iconSize = 12.0,
    Color color,
    Function action,
    Color textColor}) {
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

Widget gridButton(
    {BuildContext context,
    Color color,
    IconData icon,
    String title,
    String subtitle = "",
    Function action,
    bool isHighlighted}) {
  return Container(
    margin: EdgeInsets.all(16),
    height: 150,
    decoration: cardDecoration(
        gradient: isHighlighted ? csCardGradient() : plainCardGradient(context),
        context: context),
    child: FlatButton(
      padding: EdgeInsets.all(0),
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
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
