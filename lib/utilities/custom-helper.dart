import 'dart:math';

import 'package:chamasoft/utilities/common.dart';
import 'package:package_info/package_info.dart';

class CustomHelper {
  static const String baseUrl = "https://uat.chamasoft.com";
  static const String prodBaseUrl = "https://app.chamasoft.com";
  static const String imageUrl = baseUrl + "/uploads/groups/";

  static bool validPhone(String phone) {
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(phone))
      return true;
    else
      return false;
  }

  static bool validEmail(String email) {
    Pattern pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
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

  static int parseInt(String db) {
    if (db == null) return 0;
    int rd;
    db = db.replaceAll(' ', '');
    db = db.replaceAll(',', '');
    db = db.trim();
    if (db == null) {
      rd = 0;
    } else {
      try {
        rd = int.parse(db);
      } catch (error) {
        rd = 0;
      }
    }
    return rd;
  }

  static double parseDouble(String db) {
    double rd;
    db = db.replaceAll(' ', '');
    db = db.replaceAll(',', '');
    db = db.trim();
    if (db == null) {
      rd = 0;
    } else {
      try {
        rd = double.parse(db);
      } catch (error) {
        rd = 0;
      }
    }
    return rd;
  }
}

class CustomException implements Exception {
  final String message;
  final ErrorStatusCode status;

  CustomException({this.message, this.status = ErrorStatusCode.statusNormal});

  @override
  String toString() {
    // TODO: implement toString
    return message.toString();
  }
}
