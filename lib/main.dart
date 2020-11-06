import 'package:chamasoft/providers/dashboard.dart';
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/groups.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  void disableCrashlytics() async {
//    if (kDebugMode) {
//      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
//    } else {}
//  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
//    Firebase.initializeApp().whenComplete(() {
//      disableCrashlytics();
//
//      setState(() {});
//    });
    getCurrentAppTheme();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
