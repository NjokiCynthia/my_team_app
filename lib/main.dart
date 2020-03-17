import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/login.dart';
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
          '/home': (context) => ChamasoftDashboard(),
        },
      ),
    );
  }
}