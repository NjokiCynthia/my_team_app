import 'package:flutter/material.dart';

class AccessTokenProvider with ChangeNotifier {
  String _accessToken;

  String get accessToken => _accessToken;

  void updateAccessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }
}
