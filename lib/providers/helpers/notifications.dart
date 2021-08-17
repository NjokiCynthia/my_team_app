import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class NotificationManager {
   static const notificationNamedRoute = '/screens/notifications/notifications';
  NotificationManager() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  // Register a user token, then map it to the auth provider. This helps ensure that even after an update, a user whom
  // does not logout still updates their token
  static Future<void> registerUserToken(
      BuildContext context, String userId) async {
    String token = await FirebaseMessaging.instance.getToken();
    Map<String, String> notificationData = {
      'user_id': userId,
      'mobile_token': token,
    };
    print("refresh toke stream");
    await Provider.of<Auth>(context, listen: false)
        .updateUserToken(notificationData)
        .then((response) => {
              if (response)
                {
                  Provider.of<Auth>(context, listen: false)
                      .setUserMobileToken(token)
                }
            });
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

  static Future<void> firebaseMessageNotificationHandler() async {
    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // String token = await FirebaseMessaging.instance.getToken();
    // print("token $token");
  }

  static Map<String,dynamic>  firebaseNotificationListenHandler() {
    Map<String,dynamic> _message = {};
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      print("initial message2 $message");
      // if (message != null) {

      //   // Navigator.pushNamed(context, '/message',
      //   //     arguments: MessageArguments(message, true));
      // }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Listening to a message");
      print(message.data);
      //  uncomment this section when we get a nice icon
      // RemoteNotification notification = message.notification;
      // AndroidNotification android = message.notification?.android;
      // if (notification != null && android != null) {
      //   flutterLocalNotificationsPlugin.show(
      //       notification.hashCode,
      //       notification.title,
      //       notification.body,
      //       NotificationDetails(
      //         android: AndroidNotificationDetails(
      //           channel.id,
      //           channel.name,
      //           channel.description,
      //           // ignore: todo
      //           // TODO add a proper drawable resource to android, for now using
      //           //      one that already exists in example app.
      //           icon: 'launch_background',
      //         ),
      //       ));
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      print("notification ${notification.title}");
    });

    return _message;
  }

  static void listenTokenChange(BuildContext context) {
    Stream<String> _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen((token) async {
      print("new token $token");
      if (await getPreference("isLoggedIn") == true) {
        String token = await FirebaseMessaging.instance.getToken();
        Map<String, String> notificationData = {
          'user_id': Provider.of<Auth>(context,listen: false).id,
          'mobile_token': token,
        };
        await Provider.of<Auth>(context, listen: false)
            .updateUserToken(notificationData)
            .then((response) => {
                  if (response)
                    {
                      Provider.of<Auth>(context, listen: false)
                          .setUserMobileToken(token)
                    }
                });
      }
    });
  }
}
