// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:chamasoft/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  setDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("theme", value ? "dark" : "light");
  }

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("theme") ?? 'light'; //set default to 'light'
    bool resp = (value == 'dark') ? true : false;
    return resp;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return Config.appName.toLowerCase() == 'chamasoft'
        ? ThemeData(
            primarySwatch: Colors.blue,
            backgroundColor: isDarkTheme ? Colors.blueGrey[900] : Colors.white,
            splashColor: isDarkTheme ? Colors.blueGrey[900] : Colors.white,
            primaryColor: isDarkTheme ? Colors.blueGrey[100] : primaryColor,
            indicatorColor:
                isDarkTheme ? Colors.blueGrey[100] : Colors.blue[600],
            buttonTheme: ButtonThemeData(
              buttonColor: isDarkTheme
                  ? Colors.blueGrey[800]?.withOpacity(0.7)
                  : Colors.white,
              colorScheme:
              isDarkTheme ? ColorScheme.dark() : ColorScheme.light(),//  <-- this auto selects the right color
            ),

            hintColor: isDarkTheme ? Colors.blueGrey[400] : Colors.blueGrey,
            highlightColor:
                isDarkTheme ? Colors.blueGrey[800] : Colors.grey[300],
            hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
            focusColor: isDarkTheme ? Colors.blueGrey[900] : Color(0xFFF8F8FF),
            selectedRowColor:
                isDarkTheme ? Colors.blueGrey[800] : Colors.blue[100],
            // ignore: deprecated_member_use
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.yellow,
              selectionColor: isDarkTheme ? Colors.white : Colors.blueGrey[800],
              selectionHandleColor: isDarkTheme ? Colors.blueGrey[100] : Colors.blueGrey,
            ),
            disabledColor: Colors.grey,
            unselectedWidgetColor:
                isDarkTheme ? Colors.black38 : Colors.blueGrey[100],
            // ignore: deprecated_member_use

            cardColor: isDarkTheme ? Colors.blueGrey : Colors.white,
            canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
            bottomAppBarTheme: BottomAppBarTheme(
              color: isDarkTheme ? Colors.blueGrey[900] : Colors.white,
            ),
            bottomAppBarColor:
                isDarkTheme ? Colors.blueGrey[300] : Colors.blueGrey[400],
            accentColor: isDarkTheme ? Colors.blue[700] : primaryColor,
            dividerColor: isDarkTheme ? Colors.grey[900] : Colors.grey[300], checkboxTheme: CheckboxThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return isDarkTheme ? Colors.blue[700] : primaryColor; }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return isDarkTheme ? Colors.blue[700] : primaryColor; }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return isDarkTheme ? Colors.blue[700] : primaryColor; }
 return null;
 }),
 trackColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return isDarkTheme ? Colors.blue[700] : primaryColor; }
 return null;
 }),
 ),
          )
        : ThemeData(
            primarySwatch: Colors.brown,
            backgroundColor: isDarkTheme ? Colors.blueGrey[900] : Colors.white,
            splashColor: isDarkTheme ? Colors.blueGrey[900] : Colors.white,
            primaryColor: isDarkTheme ? Colors.blueGrey[100] : primaryColor,
            indicatorColor:
                isDarkTheme ? Colors.blueGrey[100] : Colors.brown[600],
            buttonTheme: ButtonThemeData(
              buttonColor: isDarkTheme
                  ? Colors.blueGrey[800]?.withOpacity(0.7)
                  : Colors.white,
              colorScheme:
              isDarkTheme ? ColorScheme.dark() : ColorScheme.light(),//  <-- this auto selects the right color
            ),
            hintColor: isDarkTheme ? Colors.blueGrey[400] : Colors.blueGrey,
            highlightColor:
                isDarkTheme ? Colors.blueGrey[800] : Colors.grey[300],
            hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
            focusColor: isDarkTheme ? Colors.blueGrey[900] : Color(0xFFF8F8FF),
            selectedRowColor:
                isDarkTheme ? Colors.blueGrey[800] : Colors.orange[50],
            // ignore: deprecated_member_use
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.yellow,
              selectionColor: isDarkTheme ? Colors.white : Colors.blueGrey[800],
              selectionHandleColor: isDarkTheme ? Colors.blueGrey[100] : Colors.blueGrey,
            ),
            disabledColor: Colors.grey,
            unselectedWidgetColor:
                isDarkTheme ? Colors.black38 : Colors.blueGrey[100],
            // ignore: deprecated_member_use
            cardColor: isDarkTheme ? Colors.blueGrey : Colors.white,
            canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,

            bottomAppBarTheme: BottomAppBarTheme(
              color: isDarkTheme ? Colors.blueGrey[900] : Colors.white,
            ),
            bottomAppBarColor:
                isDarkTheme ? Colors.blueGrey[300] : Colors.blueGrey[400],
            toggleableActiveColor:
                isDarkTheme ? Colors.brown[700] : primaryColor,
            accentColor: isDarkTheme ? Colors.brown[700] : primaryColor,
            dividerColor: isDarkTheme ? Colors.grey[900] : Colors.grey[300],
          );
  }
}

Color primaryColor = Config.appName.toLowerCase() == 'chamasoft'
    ? Color(0xff00a9f0)
    : Color(0xff8f2c21);
Color backgroundColor = Color(0xffEDEDFE);
