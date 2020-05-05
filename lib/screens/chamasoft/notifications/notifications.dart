import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ChamasoftNotifications extends StatefulWidget {
  @override
  _ChamasoftNotificationsState createState() => _ChamasoftNotificationsState();
}

class _ChamasoftNotificationsState extends State<ChamasoftNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "Notifications",
          action: () => Navigator.pop(context),
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            color: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Color(0xffededfe),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      subtitle1(
                          text: "Mark as Read",
                          color: Theme.of(context).textSelectionHandleColor,
                          align: TextAlign.start),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 13.0,
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontFamily: 'SegoeUI'),
                            children: [
                              TextSpan(text: "Mark all notifications as "),
                              TextSpan(
                                  text: "read",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.0,
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      fontFamily: 'SegoeUI'))
                            ]),
                      ),
                    ],
                  ),
                ),
                screenActionButton(
                    icon: LineAwesomeIcons.check,
                    textColor: Theme.of(context).textSelectionHandleColor,
                    action: () {})
              ],
            ),
          ),
        ],
      ),
    );
  }
}
