import 'package:chamasoft/screens/intro.dart';
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
        home: IntroScreen(),
      ),
    );
  }
}
