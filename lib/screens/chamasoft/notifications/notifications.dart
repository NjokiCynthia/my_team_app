import 'package:chamasoft/screens/chamasoft/models/notification-item.dart';
import 'package:chamasoft/screens/chamasoft/notifications/notification-details.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dashed-divider.dart';
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
    List<NotificationItem> notifications = [
      NotificationItem(
          id: 1,
          message:
              "You have an upcoming savings payment of Ksh 2,000 due on 12 March 2020. Depending on your investment group's constitution, a fine might be imposed on you.",
          dateTime: DateTime.now(),
          isUnread: true),
      NotificationItem(
          id: 1,
          message:
              "You have an upcoming savings payment of Ksh 2,000 due on 12 March 2020. Depending on your investment group's constitution, a fine might be imposed on you.",
          dateTime: DateTime.now(),
          isUnread: true),
      NotificationItem(
          id: 1,
          message:
              "You have an upcoming savings payment of Ksh 2,000 due on 12 March 2020. Depending on your investment group's constitution, a fine might be imposed on you.",
          dateTime: DateTime.now(),
          isUnread: false),
      NotificationItem(
          id: 1,
          message:
              "You have an upcoming savings payment of Ksh 2,000 due on 12 March 2020. Depending on your investment group's constitution, a fine might be imposed on you.",
          dateTime: DateTime.now(),
          isUnread: false),
      NotificationItem(
          id: 1,
          message:
              "You have an upcoming savings payment of Ksh 2,000 due on 12 March 2020. Depending on your investment group's constitution, a fine might be imposed on you.",
          dateTime: DateTime.now(),
          isUnread: false),
      NotificationItem(
          id: 1,
          message:
              "You have an upcoming savings payment of Ksh 2,000 due on 12 March 2020. Depending on your investment group's constitution, a fine might be imposed on you.",
          dateTime: DateTime.now(),
          isUnread: false),
      NotificationItem(
          id: 1,
          message:
              "You have an upcoming savings payment of Ksh 2,000 due on 12 March 2020. Depending on your investment group's constitution, a fine might be imposed on you.",
          dateTime: DateTime.now(),
          isUnread: false),
      NotificationItem(
          id: 1,
          message:
              "You have an upcoming savings payment of Ksh 2,000 due on 12 March 2020. Depending on your investment group's constitution, a fine might be imposed on you.",
          dateTime: DateTime.now(),
          isUnread: false),
    ];
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
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                NotificationItem notification = notifications[index];
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => NotificationDetails(),
                    ),
                  ),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(SPACING_NORMAL),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.notifications,
                                    size: 24.0,
                                    color: notification.isUnread
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      notification.message,
                                      style: TextStyle(
                                          fontWeight: notification.isUnread
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          fontSize: 12.0,
                                          color: Theme.of(context)
                                              .textSelectionHandleColor,
                                          fontFamily: 'SegoeUI'),
                                      textAlign: TextAlign.start,
                                    ),
                                  )
                                ],
                              ),
                              customTitle(
                                  text: defaultDateFormat
                                      .format(notification.dateTime),
                                  fontSize: 12.0,
                                  fontWeight: notification.isUnread
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: Theme.of(context)
                                      .textSelectionHandleColor,
                                  align: TextAlign.end),
                            ],
                          ),
                        ),
                        DashedDivider(
                          color: Theme.of(context).dividerColor,
                          thickness: 1.0,
                          height: 5.0,
                          width: 4.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: notifications.length,
            ),
          )
        ],
      ),
    );
  }
}
