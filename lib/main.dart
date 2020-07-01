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

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
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
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        ),
        ChangeNotifierProxyProvider<Auth,Groups>(
          update: (ctx,auth,previousGroups) => Groups(
            previousGroups == null ? [] : previousGroups.item,
            auth.id,
            auth.token
          ),
          create: (BuildContext context) {},
        ),
      ],
      child: Consumer<DarkThemeProvider>(builder: (BuildContext context, value, Widget child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          color: themeChangeProvider.darkTheme ? Colors.blueGrey[900] : Colors.blue[50],
          title: 'Chamasoft',
          theme: Styles.themeData(themeChangeProvider.darkTheme, context),
          home: IntroScreen(),
          routes: {
            Login.namedRoute: (ctx) => Login(),
            MyGroups.namedRoute: (ctx) => MyGroups(),
            SignUp.namedRoute: (ctx) => SignUp(),
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
