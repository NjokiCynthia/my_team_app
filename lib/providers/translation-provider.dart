import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class TranslationProvider extends ChangeNotifier {
  String _currentLanguage = 'English';
  Map<String, dynamic> _translations;

  TranslationProvider({
    String initialLanguage,
  }) {
    _currentLanguage = initialLanguage;
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    print('I am here to load translations');

    final jsonString = await rootBundle.loadString('assets/oromo.json');
    final Map<String, dynamic> translationsJson = json.decode(jsonString);
    _translations = translationsJson[_currentLanguage];
    print('Translations: $_translations');
  }

  String translate(String textKey) {
    return _translations[textKey] ?? textKey;
  }

  void changeLanguage(String newLanguage) {
    _currentLanguage = newLanguage;
    _loadTranslations();
    notifyListeners();
  }

  String get currentLanguage => _currentLanguage ?? 'English';
}
