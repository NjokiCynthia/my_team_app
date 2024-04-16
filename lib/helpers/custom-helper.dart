import 'dart:io';
import 'dart:math';

import 'package:chamasoft/config.dart';
import 'package:chamasoft/helpers/common.dart';
// import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:image/image.dart';
import 'package:libphonenumber/libphonenumber.dart';
// import 'package:package_info/package_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:url_launcher/url_launcher.dart';

class CustomHelper {
  static final String _flavor = Config.APP_FLAVOR.toLowerCase();

  static final String baseUrl = _getBaseUrl();
  //static const String chamasoftProdUrl = "https://app.chamasoft.com";
  static const String chamasoftProdUrl = "https://uat.chamasoft.com";
  static const String chamasoftUatUrl = "https://uat.chamasoft.com";
  static const String EazzychamaUatUrl = "https://app.eazzychamademo.com";
  static const String EazzychamaProdUrl = "https://app.eazzychama.co.ke";
  static const String EazzykikundiProdUrl = "https://app.eazzykikundi.com";
  static const String EazzyclubProdUrl = "https://app.eazzyclub.co.ug";
  static const String EazzyclubDevUrl =
      "http://chamasoft-we-001-dev.azurewebsites.net";
  static final String imageUrl = baseUrl + "/uploads/groups/";

  static String _getBaseUrl() {
    String _url = chamasoftUatUrl;
    //print("the flavor $_flavor");
    if (_flavor.contains("eazzyclub"))
      //change back to prodUrl
      // _url = EazzyclubDevUrl;
      _url = chamasoftUatUrl;
    else if (_flavor.contains("eazzychamadev"))
      _url = EazzychamaProdUrl;
    else if (_flavor.contains("eazzykikundi"))
      _url = EazzykikundiProdUrl;
    else if (_flavor.contains("eazzychama"))
      _url = EazzychamaUatUrl;
    else if (_flavor.contains("chamasoftdev"))
      _url = chamasoftUatUrl;
    else if (_flavor.contains("chamasoft")) _url = chamasoftProdUrl;
    return _url;
  }

  static bool validPhone(String phone) {
    RegExp regex = new RegExp(r'(^(?:[+0]9)?[0-9]{9,12}$)');
    if (regex.hasMatch(phone))
      return true;
    else
      return false;
  }

  static String getInitials(String name) => name.isNotEmpty
      ? name
          .trim()
          .split(' ')
          .map((l) => l.length > 1 ? l[0] : " - ")
          .take(2)
          .join()
      : '';

  static bool validEmail(String email) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (regex.hasMatch(email))
      return true;
    else
      return false;
  }

  static bool validIdentity(String identity) {
    return validEmail(identity) || validPhone(identity);
  }

  static Future<bool> validPhoneNumber(
      String phone, CountryCode countryCode) async {
    if (phone.trim().isNotEmpty) {
      String number = countryCode.dialCode +
          (phone.startsWith("0") ? phone.replaceFirst("0", "") : phone);
      bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
          phoneNumber: number, isoCode: countryCode.code);
      return isValid;
    } else
      return false;
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

  static Future<File> resizeFileImage(File imageFile, int width) async {
    try {
      final appDir = await syspaths.getTemporaryDirectory();
      Image image = decodeImage(imageFile.readAsBytesSync());
      Image thumbnail = copyResize(image, width: width);
      final File thumbnailNew = new File("${appDir.path}/thumbnail.png")
        ..writeAsBytesSync(encodePng(thumbnail));
      return thumbnailNew;
    } catch (error) {
      print("resize error :  ${error.toString()}");
      throw error;
    }
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static Future<void> callNumber(String number) async {
    // launch("tel://$number");
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
  }
}

class CustomException implements Exception {
  final String message;
  final ErrorStatusCode status;

  CustomException({this.message, this.status = ErrorStatusCode.statusNormal});

  @override
  String toString() {
    // ignore: todo
    // TODO: implement toString
    return message.toString();
  }
}
