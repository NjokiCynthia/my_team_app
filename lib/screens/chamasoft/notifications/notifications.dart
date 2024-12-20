import 'dart:async';

import 'package:chamasoft/providers/groups.dart' as GroupProvider;
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/screens/chamasoft/notifications/notification-alert.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dashed-divider.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
// import 'notification-alert.dart';

class ChamasoftNotifications extends StatefulWidget {
  @override
  _ChamasoftNotificationsState createState() => _ChamasoftNotificationsState();
}

class _ChamasoftNotificationsState extends State<ChamasoftNotifications> {
  bool isFetched = false;

  //bool isFetched = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    fetchGroupNotifications(context);
    _requestNotificationPermissions();
    _configureLocalNotifications();
    _initializeLocalNotifications();
    _showStaticNotification();
  }

  void _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showStaticNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'static_notification_channel_id', // Channel ID
      'Static Notification Channel', // Channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Chamasoft Notification', // Title
      'Please continue using chamasoft', // Notification message
      platformChannelSpecifics,
    );
  }

  Future<bool> fetchGroupNotifications(BuildContext context) async {
    try {
      await Provider.of<GroupProvider.Groups>(context, listen: false)
          .fetchGroupNotifications();
      setState(() {
        isFetched = true;
      });
      return true;
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            fetchGroupNotifications(context);
          });
      return false;
    }
  }

  Future<void> _requestNotificationPermissions() async {
    await _firebaseMessaging.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  Future<void> _onSelectNotification(String payload) async {
    // Handle the notification tap action here
    print('Notification tapped with payload: $payload');
  }

  void _configureLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: _onSelectNotification);
  }

  Future<bool> markAllNotificationsAsRead(BuildContext context) async {
    try {
      await Provider.of<GroupProvider.Groups>(context, listen: false)
          .markAllNotificationsAsRead();
     
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "All notifications marked as read",
      )));

      return true;
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            fetchGroupNotifications(context);
          });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "Notifications",
          action: () => Navigator.pop(context, true),
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(builder: (context) {
        return Column(
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
                           
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
                            textAlign: TextAlign.start),
                        RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13.0,
                                  color: Theme.of(context)
                                     
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                  fontFamily: 'SegoeUI'),
                              children: [
                                TextSpan(text: "Mark all notifications as "),
                                TextSpan(
                                    text: "read",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.0,
                                        color: Theme.of(context)
                                           
                                            .textSelectionTheme
                                            .selectionHandleColor,
                                        fontFamily: 'SegoeUI'))
                              ]),
                        ),
                      ],
                    ),
                  ),
                  screenActionButton(
                      icon: LineAwesomeIcons.check,
                     
                      textColor: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                      action: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        await markAllNotificationsAsRead(context);
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
            Expanded(
              child: isFetched
                  ? Consumer<GroupProvider.Groups>(
                      builder: (context, groupData, child) {
                      return groupData.notifications.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                GroupProvider.Notification notification =
                                    groupData.notifications[index];
                                return InkWell(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          NotificationAlert(
                                        notification: notification,
                                      ),
                                      // NotificationDetails(
                                      //     notification: notification),
                                    ),
                                  ),
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              EdgeInsets.all(SPACING_NORMAL),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.notifications,
                                                    size: 24.0,
                                                    color:
                                                        notification.isRead ==
                                                                "0"
                                                            ? Theme.of(context)
                                                                .hintColor
                                                            : Theme.of(context)
                                                                .dividerColor,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      notification.message,
                                                      style: TextStyle(
                                                          fontWeight: notification
                                                                      .isRead ==
                                                                  "0"
                                                              ? FontWeight.w700
                                                              : FontWeight.w400,
                                                          fontSize: 12.0,
                                                          color: Theme.of(
                                                                  context)
                                                             
                                                              .textSelectionTheme
                                                              .selectionHandleColor,
                                                          fontFamily:
                                                              'SegoeUI'),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              customTitle(
                                                  text: notification.timeAgo,
                                                  fontSize: 12.0,
                                                  fontWeight:
                                                      notification.isRead == "0"
                                                          ? FontWeight.w700
                                                          : FontWeight.w400,
                                                  color: Theme.of(context)
                                                     
                                                      .textSelectionTheme
                                                      .selectionHandleColor,
                                                  textAlign: TextAlign.end),
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
                              itemCount: groupData.notifications.length,
                            )
                          : Center(child: Text('No new notifications'));
                    })
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            )
          ],
        );
      }),
    );
  }
}
