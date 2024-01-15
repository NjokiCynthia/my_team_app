import 'dart:convert';
import 'package:flutter/services.dart';

class TranslationService {
  Map<String, dynamic> _translations = {}; // Change the type to dynamic

  Future<void> loadTranslations(String filePath) async {
    try {
      print("Loading translations from file: $filePath");

      // Read the file content
      print("Reading file content...");
      String content = await rootBundle.loadString('assets/json/oromo.json');

      print('content is : $content');

      // Parse JSON
      print("Parsing JSON...");
      _translations = json.decode(content);

      print("Translations loaded successfully.");
    } catch (e) {
      print("Error loading translations file: $e");
    }
  }

  String translate(String key) {
    return _translations[key] ?? key;
  }
}
