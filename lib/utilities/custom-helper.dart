import 'dart:math';

import 'package:package_info/package_info.dart';

class CustomHelper {
  static const String baseUrl = "https://uat.chamasoft.com/";
  static const String generatePin = "mobile/generate_pin";

  static bool validPhone(String phone) {
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(phone))
      return true;
    else
      return false;
  }

  static bool validEmail(String email) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(email))
      return true;
    else
      return false;
  }

  static bool validIdentity(String identity) {
    return validEmail(identity) || validPhone(identity);
  }

  static String generateRandomStringCharacterPair(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });
    return new String.fromCharCodes(codeUnits);
  }

  static String generateRandomString(int strlen) {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  static Future<String> getApplicationBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message.toString();
  }
}
