import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

Widget defaultButton({BuildContext context, String text, Function onPressed}) {
  // ignore: deprecated_member_use
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
    ),
    child: Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'SegoeUI',
            fontWeight: FontWeight.w700,
            color: Colors.white),
      ),
    ),
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
    // ignore: deprecated_member_use
    child: TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.all(0.0),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          backgroundColor: backgroundColor),

      child: Icon(
        icon,
        size: iconSize,
      ),
      onPressed: action,

      // textColor: textColor,
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
    // ignore: deprecated_member_use
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(0.0),
      ),
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
    // ignore: deprecated_member_use
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 6.0),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        backgroundColor: backgroundColor,
      ),

      child: customTitle(
        text: text,
        color: textColor,
        fontWeight: FontWeight.w400,
        fontSize: textSize,
      ),
      onPressed: action,

      //textColor: textColor,
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
    IconData iconData = LineAwesomeIcons.parking}) {
  return Container(
    height: buttonHeight,
    // ignore: deprecated_member_use
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 6.0),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        backgroundColor: backgroundColor,
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: textSize,
                fontFamily: 'SegoeUI'),
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

      // textColor: textColor,
    ),
  );
}

Widget cardAmountButton(
    {String currency,
    String amount,
    Function action,
    double size,
    Color color}) {
  // ignore: deprecated_member_use
  return TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 6.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      //overlayColor: Colors.blueGrey.withOpacity(0.1),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "$currency ",
          style: TextStyle(
            color: color,
            fontFamily: 'SegoeUI',
            fontSize: (size - 2.0),
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: size,
            fontFamily: 'SegoeUI',
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
    onPressed: action,
  );
}

Widget plainButtonWithArrow(
    {String text,
    Function action,
    double size,
    Color color,
    double spacing = 4.0}) {
  // ignore: deprecated_member_use
  return TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 6.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    ),

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

    onPressed: action,
    //highlightColor: Colors.blueGrey.withOpacity(0.1),
  );
}

Widget buttonWithArrow(
    {String text,
    Function action,
    double size,
    Color color,
    double spacing = 4.0}) {
  // ignore: deprecated_member_use
  return TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 6.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: primaryColor,
    ),

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

    onPressed: action,
    //highlightColor: Colors.blueGrey.withOpacity(0.1),
  );
}

Widget plainButtonWithIcon(
    {String text,
    Function action,
    double size,
    Color color,
    IconData iconData,
    double spacing = 4.0}) {
  // ignore: deprecated_member_use
  return TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 6.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    ),

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
          // Feather.chevron_right,
          iconData,
          size: (size),
          color: color.withOpacity(0.4),
        )
      ],
    ),

    onPressed: action,
    //highlightColor: Colors.blueGrey.withOpacity(0.1),
  );
}

Widget plainButton(
    {String text,
    Function action,
    double size,
    Color color,
    double spacing = 4.0}) {
  // ignore: deprecated_member_use
  return TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 6.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      //highlightColor: Colors.blueGrey.withOpacity(0.1),
      // splashColor: primaryColor.withOpacity(0.2),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: customTitle(
            text: text,
            color: color,
            fontSize: size,
            fontFamily: 'SegoeUI',
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: spacing,
        ),
      ],
    ),
    onPressed: action,
  );
}

Widget paymentActionButton(
    {bool isFlat = false,
    String text,
    IconData icon,
    double iconSize = 12.0,
    Color color,
    Function action,
    Color textColor,
    bool showIcon = true}) {
  return (!isFlat)
      // ignore: deprecated_member_use
      ? OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            //  borderSide: BorderSide(
            //   width: 3.0,
            //   color: color,
            // ),
            // highlightColor: color.withOpacity(0.1),
            // highlightedBorderColor: color,
          ),
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
              Visibility(
                visible: showIcon,
                child: SizedBox(
                  width: 5.0,
                ),
              ),
              Visibility(
                visible: showIcon,
                child: Icon(
                  icon,
                  color: textColor,
                  size: iconSize,
                ),
              ),
            ],
          ),
          onPressed: action,
        )
      // ignore: deprecated_member_use
      : TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            backgroundColor: color,
          ),
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
              Visibility(
                visible: showIcon,
                child: SizedBox(
                  width: 5.0,
                ),
              ),
              Visibility(
                visible: showIcon,
                child: Icon(
                  icon,
                  color: textColor,
                  size: iconSize,
                ),
              ),
            ],
          ),
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
    bool isHighlighted,
    double margin = 18}) {
  return Container(
    margin: EdgeInsets.all(margin),
    height: 150,
    decoration: cardDecoration(
        gradient: isHighlighted ? csCardGradient() : plainCardGradient(context),
        context: context),
    // ignore: deprecated_member_use
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        //highlightColor: primaryColor.withOpacity(0.1),
      ),
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
      onPressed: action,
    ),
  );
}

Widget svgGridButton(
    {BuildContext context,
    Color color,
    String icon,
    String title,
    String subtitle = "",
    Function action,
    bool isHighlighted,
    double margin = 18,
    double imageHeight = 120,
    int notifications = 0}) {
  return Container(
    margin: EdgeInsets.all(margin),
    height: 150,
    decoration: cardDecoration(
        gradient: isHighlighted ? csCardGradient() : plainCardGradient(context),
        context: context),
    // ignore: deprecated_member_use
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        //highlightColor: primaryColor.withOpacity(0.1),
      ),
      child:
          Stack(fit: StackFit.expand, alignment: Alignment.center, children: [
        // Show the icon based on available notifications
        if (notifications != null && notifications > 0)
          Positioned(
            top: 0.0,
            right: 2.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                color: color,
                height: 30,
                width: 30,
                padding: EdgeInsets.all(5),
                child: Text(
                  "$notifications",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        Positioned(
          top: 0.0,
          right: 0.0,
          left: 0.0,
          child: SvgPicture.asset(
            icon,
            semanticsLabel: 'icon',
            height: imageHeight,
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
                  fontSize: 12.0,
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
                  fontSize: 10.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ]),
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

Widget circleIconButton(
    {IconData icon,
    Color color,
    Color backgroundColor,
    Function onPressed,
    double iconSize = 32.0,
    double padding = 2.0}) {
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

Widget circleButton(
    {Color color,
    Color backgroundColor,
    double iconSize = 32.0,
    double padding = 2.0}) {
  return Container(
    padding: EdgeInsets.all(padding),
    width: 10,
    height: 10,
    decoration: ShapeDecoration(
      color: backgroundColor,
      shape: CircleBorder(),
    ),
  );
}

Widget negativeActionDialogButton(
    {String text = "Cancel", Color color, Function action}) {
  // ignore: deprecated_member_use
  return TextButton(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),

      //highlightColor: Colors.blueGrey.withOpacity(0.1),
      // splashColor: primaryColor.withOpacity(0.2),
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
    ),
    child: customTitle(
      text: text,
      color: color,
      fontWeight: FontWeight.w600,
    ),
    onPressed: action,
  );
}

Widget positiveActionDialogButton({String text, Color color, Function action}) {
  // ignore: deprecated_member_use
  return TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(4.0)),
      backgroundColor: primaryColor.withOpacity(0.2),
    ),

    child: customTitle(
      text: text,
      color: color,
      fontWeight: FontWeight.w600,
    ),
    onPressed: action,

    // textColor: primaryColor,
  );
}

ButtonTheme groupSetupButton(
    BuildContext context, String text, Function action) {
  return ButtonTheme(
    height: 36,
    // ignore: deprecated_member_use
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.only(left: 4, right: 4),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: action,
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
          customTitle(
              text: text,
              fontSize: 12,
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionTheme.selectionHandleColor),
        ],
      ),
    ),
  );
}

Widget meetingMegaButton(
    {BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon,
    Function action}) {
  // ignore: deprecated_member_use
  return OutlinedButton(
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                ),
              ),
              subtitle2(
                text: subtitle,
                color: color,
              )
            ],
          ),
          Icon(
            icon,
            color: color,
          ),
        ],
      ),
    ),
    borderSide: BorderSide(
      width: 0.0,
      color: color.withOpacity(0.0),
    ),
    highlightColor: color.withOpacity(0.1),
    highlightedBorderColor: color.withOpacity(0.0),
    onPressed: action,
  );
}

Widget textButton(
    {String text,
    Color color,
    TextAlign textAlign = TextAlign.center,
    Function action}) {
  return TextButton(
      onPressed: action,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            color: color,
            fontFamily: 'SegoeUI'),
        textAlign: textAlign,
      ));
}

Widget actionDialogButtonWithBgColor(
    {String text,
    Color color,
    Function action,
    Color textColor,
    double buttonSize}) {
  // ignore: deprecated_member_use
  return Padding(
    padding: const EdgeInsets.only(left: 11.0),
    child: SizedBox(
        width: buttonSize,
        child: ElevatedButton(
            // style: ButtonStyle(

            //     backgroundColor: MaterialStateProperty.all<Color>(color,)),
            style: ElevatedButton.styleFrom(primary: color),
            onPressed: action,
            child: customTitle(
              text: text,
              color: textColor,
              fontWeight: FontWeight.w600,
            ))),
  );
}

Widget defaultButtonWithBg(
    {BuildContext context, String text, Function action, Color btnColor}) {
  // ignore: deprecated_member_use
  // return RaisedButton(
  //   color: primaryColor,
  //   child: Padding(
  //     padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
  //     child: Text(
  //       text,
  //       style: TextStyle(fontFamily: 'SegoeUI', fontWeight: FontWeight.w700),
  //     ),
  //   ),
  //   textColor: Colors.white,
  //   onPressed: onPressed,
  // );
  return SizedBox(
    width: double.infinity,
    height: 45,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: btnColor),
        onPressed: action,
        child: customTitle(
          text: text,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        )),
  );
}
