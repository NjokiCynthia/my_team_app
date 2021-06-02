import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/screens/chamasoft/models/deposit.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
class NotificationManager{

  NotificationManager(){
    WidgetsFlutterBinding.ensureInitialized();
  }

  // Register a user token, then map it to the auth provider. This helps ensure that even after an update, a user whom
  // does not logout still updates their token
  static Future<void> registerUserToken(BuildContext context, String userId) async{
    String token = await FirebaseMessaging.instance.getToken();
    Map<String, String> notificationData = {
      'user_id': userId,
      'mobile_token': token,
    };
    final response = await Provider.of<Auth>(context, listen: false)
          .updateUserToken(notificationData);
    if(response){
      Provider.of<Auth>(context, listen: false).setUserMobileToken(token);
    }
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