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
    return ThemeData(
      primarySwatch: Colors.blue, //in use
      backgroundColor:
          isDarkTheme ? Colors.blueGrey[900] : Colors.white, //in use
      splashColor: isDarkTheme ? Colors.blueGrey[900] : Colors.white, //in use,
      primaryColor: isDarkTheme ? Colors.blueGrey[100] : Colors.blue, //in use
      indicatorColor:
          isDarkTheme ? Colors.blueGrey[100] : Colors.blue[600], //in use
      buttonColor: isDarkTheme
          ? Colors.blueGrey[800].withOpacity(0.7)
          : Colors.white, //in use
      hintColor: isDarkTheme ? Colors.blueGrey[400] : Colors.blueGrey, //in use
      highlightColor: isDarkTheme ? Colors.blueGrey[800] : Colors.grey[300],
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor:
          isDarkTheme ? Colors.blueGrey[900] : Color(0xFFF8F8FF), //in use
      selectedRowColor:
          isDarkTheme ? Colors.blueGrey[800] : Color(0xFFEDEDFE), //in use
      textSelectionHandleColor:
          isDarkTheme ? Colors.blueGrey[100] : Color(0xff707070), //in use
      disabledColor: Colors.grey, //in use
      unselectedWidgetColor:
          isDarkTheme ? Colors.black38 : Colors.blueGrey[100], //in use
      textSelectionColor:
          isDarkTheme ? Colors.white : Color(0xFFEDEDFE), //in use
      cardColor: isDarkTheme ? Colors.blueGrey : Colors.white, //in use
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50], //in use
      brightness: isDarkTheme ? Brightness.dark : Brightness.light, //in use
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme:
                isDarkTheme ? ColorScheme.dark() : ColorScheme.light(), //in use
          ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: isDarkTheme ? Colors.blueGrey[900] : Colors.white, //in use
      ),
      bottomAppBarColor:
          isDarkTheme ? Colors.blueGrey[300] : Colors.blueGrey[400],
      toggleableActiveColor: isDarkTheme ? Colors.blue[700] : Colors.blue,
      accentColor: isDarkTheme ? Colors.blue[700] : Colors.blue,
      dividerColor: isDarkTheme ? Colors.grey[900] : Colors.grey[300], //in use
    );
  }
}
