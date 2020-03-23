import 'package:chamasoft/screens/chamasoft/apply-loan.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/pay-now.dart';
import 'package:chamasoft/screens/configure-group.dart';
import 'package:chamasoft/screens/create-group.dart';
import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/screens/signup.dart';
import 'package:chamasoft/screens/verification.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chamasoft',
        theme: Styles.themeData(themeChangeProvider.darkTheme, context),
        initialRoute: '/',
        routes: {
          '/': (context) => Login(),
          '/verification': (context) => Verification(),
          '/signup': (context) => SignUp(),
          '/my-groups': (context) => MyGroups(),
          '/create-group': (context) => CreateGroup(),
          '/home': (context) => ChamasoftDashboard(),
          '/configure-group': (context) => ConfigureGroup(),
          '/chamasoft-home': (context) => ChamasoftDashboard(),
          '/pay-now': (context) => PayNow(),
          '/apply-loan': (context) => ApplyLoan(),
        },
      ),
    );
  }
}
