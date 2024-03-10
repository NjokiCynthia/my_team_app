import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final jsonString = await rootBundle.loadString('assets/oromo.json');
    final Map<String, dynamic> translationsJson = json.decode(jsonString);
    _translations = translationsJson[_currentLanguage];
  }

  String translate(String textKey) {
    return _translations[textKey] ?? textKey;
  }

  void changeLanguage(String newLanguage) async {
    _currentLanguage = newLanguage;
    await _loadTranslations();
    notifyListeners();
    _saveLanguagePreference(newLanguage);
  }

  String get currentLanguage => _currentLanguage ?? 'English';

  Future<void> _saveLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  static Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language') ?? 'English';
  }
}
