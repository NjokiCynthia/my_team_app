import 'package:chamasoft/config.dart';
import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/helpers/notifications.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/settings/accounts/create-bank-account.dart';
import 'package:chamasoft/screens/chamasoft/settings/accounts/list-institutions.dart';
import 'package:chamasoft/screens/chamasoft/settings/group-setup/add-contribution-dialog.dart';
import 'package:chamasoft/screens/chamasoft/settings/group-setup/add-members-manually.dart';
import 'package:chamasoft/screens/chamasoft/settings/group-setup/list-contacts.dart';
import 'package:chamasoft/screens/configure-group.dart';
import 'package:chamasoft/screens/create-group.dart';
import 'package:chamasoft/screens/intro.dart';
import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/screens/signup.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/groups.dart';

void main() async {
  //  Status bar fixes
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Config.appName.toLowerCase() == 'chamasoft'
          ? Color(0xff00a9f0)
          : Color(0xff8f2c21),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(NotificationManager.firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await NotificationManager.flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(NotificationManager.channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}







class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  initDB() async {
    // Any call to the DB will instantiate it, whether valid or invalid
    await getLocalData('app');
  }

  @override
  void initState() {
    getCurrentAppTheme();
    initDB();
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print("initial message $message");
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        NotificationManager.flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                NotificationManager.channel.id,
                NotificationManager.channel.name,
                NotificationManager.channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
      print("initial message $message");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    FirebaseMessaging.instance.subscribeToTopic('chamasoft');
    _getUserFirebaseToken();
    super.didChangeDependencies();
  }

  void _getUserFirebaseToken() async{
    String token = await FirebaseMessaging.instance.getToken();
    print("Token: $token");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        ),
        ChangeNotifierProxyProvider<Auth, Groups>(
          update: (ctx, auth, previousGroups) => Groups(
            previousGroups == null ? [] : previousGroups.item,
            auth.id,
            auth.userIdentity,
            previousGroups == null ? '' : previousGroups.currentGroupId,
          ),
          // ignore: missing_return
          create: (BuildContext context) {},
        ),
        ChangeNotifierProxyProvider<Groups, Dashboard>(
          update: (ctx, groups, dashboardData) => Dashboard(
              groups.userId,
              groups.currentGroupId,
              dashboardData == null ? {} : dashboardData.memberDashboardData,
              dashboardData == null ? {} : dashboardData.groupDashboardData),
          // ignore: missing_return
          create: (BuildContext context) {},
        )
      ],
      child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget child) {
        return MaterialApp(
          builder: (BuildContext context, Widget child) {
            final data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(
                  textScaleFactor:
                      data.textScaleFactor > 1.0 ? 1.0 : data.textScaleFactor),
              child: child,
            );
          },
          debugShowCheckedModeBanner: false,
          color: themeChangeProvider.darkTheme
              ? Colors.blueGrey[900]
              : Colors.blue[50],
          title: 'Chamasoft',
          theme: Styles.themeData(themeChangeProvider.darkTheme, context),
          home: IntroScreen(),
          routes: {
            IntroScreen.namedRoute: (ctx) => IntroScreen(),
            Login.namedRoute: (ctx) => Login(),
            MyGroups.namedRoute: (ctx) => MyGroups(),
            SignUp.namedRoute: (ctx) => SignUp(),
            CreateGroup.namedRoute: (ctx) => CreateGroup(),
            ConfigureGroup.namedRoute: (ctx) => ConfigureGroup(),
            ListContacts.namedRoute: (ctx) => ListContacts(),
            CreateBankAccount.namedRoute: (ctx) => CreateBankAccount(),
            AddContributionDialog.namedRoute: (ctx) => AddContributionDialog(),
            AddMembersManually.namedRoute: (ctx) => AddMembersManually(),
            ListInstitutions.namedRoute: (ctx) => ListInstitutions(),
            ChamasoftDashboard.namedRoute: (ctx) => ChamasoftDashboard(),
          },
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (context) => IntroScreen());
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (context) => IntroScreen());
          },
        );
      }),
    );
  }
}
