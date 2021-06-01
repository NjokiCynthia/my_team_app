import 'package:chamasoft/providers/auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
class NotificationManager{

  NotificationManager(){
    WidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> registerUserToken(BuildContext context, String userId) async{
    String token = await FirebaseMessaging.instance.getToken();
    Map<String, String> notificationData = {
      'userId': userId,
      'token': token,
    };
    await Provider.of<Auth>(context, listen: false)
          .updateUserToken(notificationData) as Map<String, dynamic>;
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

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }


}