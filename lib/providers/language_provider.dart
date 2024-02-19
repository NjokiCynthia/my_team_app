import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = Locale('en', ''); // Default to English

  Locale get currentLocale => _currentLocale;

  void updateLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }
}
