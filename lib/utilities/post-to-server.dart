import 'dart:convert';

import 'package:chamasoft/providers/auth.dart';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:simple_rsa/simple_rsa.dart';

import '../utilities/custom-helper.dart';

class PostToServer {
  static const String _defaultAuthenticationToken =
      "d8ng63ttyjp88cnjpkme65efgz6b2gwg";

  static String _encryptAESCryptoJS(String plainText, String passphrase) {
    try {
      final key = Key.fromUtf8(passphrase);
      final iv = IV.fromLength(16);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.base64 + ":" + iv.base64;
    } catch (error) {
      throw error;
    }
  }

  static String _decryptAESCryptoJS(String encryptedString, String passphrase) {
    var explodedString = encryptedString.split(":")..toList();
    final String encryptedBody = explodedString[0];
    final String ivBody = explodedString[1];
    final encryptProtocol =
        Encrypter(AES(Key.fromUtf8(passphrase), mode: AESMode.cbc));
    final encrypted =
        encryptProtocol.decrypt64(encryptedBody, iv: IV.fromBase64(ivBody));
    return encrypted;
  }

  static Future<String> _encryptSecretKey(String randomKey) async {
    try {
      final publicKey =
          "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+VsG3fDU1B8V7258pZST" +
              "0FfZzEXiPCC6i8RtA5pyS/orSBa1Ds3PMnF4qU+Z+HlBB9apKG/pYK73mXR8v1cX" +
              "jZCFxg08Gq/dwam1O5ehNXtEHKhembXdZC2zdFyVVg8emgbyDxaP1oEWwQOqoUI7" +
              "1e1lPqDMrFTUeS65YO2ayWeEKEnY12nE6pgyopSdEo5Boz4RzxCL8jLIhTwRouhi" +
              "MOA9UyWBYuQEp8P1yj8zVoB20WyB6qOazPIiCEUz4MK0/yiVTR6B8hWwQydvMGKu" +
              "QWdCjZcopnehZDPLyXc5fuC++4o6E6WfDoL/GCTMeQ/bCaavCKUX4oypMLUVN1Zd" +
              "3QIDAQAB";
      final encrypted = await encryptString(randomKey, publicKey);
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      return stringToBase64.encode(encrypted);
    } catch (error) {
      throw error;
    }
  }

  static Future<String> _decretSecretKey(String encryptedSecretKey) async {
    try {
      final privateKey = "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDAuo8TA41+kUZv" +
          "jM4sB+o9k4wkzuEdqUIZa710GmCPzQCc4kRTc7nrTO6sfNSq1Rz1O5XwQkhF1mFf" +
          "2+CNF4sUSJdZ/9i+CqpTvEr9/kaEqFmVcD0DP0IK9V/rAp1bBER3sv9xkVfNwGeV" +
          "N4JvIHFz/NPyo8DGsrwn+F72mIzkP8N9OyyuVVqVU+n63fF/qWFvIycau6oZBjFV" +
          "RO3BIdwtRPAImT1YrVZ1cuCZuqlwcVsW4P21YMMU2fyxjoEVxcePuhOF+ZxG9v21" +
          "Y4agXmf1GFaU98qlxtf2QvFwZTUbHDmKYjbc1bbo+SZHyaqXnSy78G/ktj3VlCl+" +
          "qNmM1mRlAgMBAAECggEASObIs/KGFTgyooNqgXFFA6HKQyoWMTgTDraYZVCM8hgj" +
          "gTR9j+uYig8BwTE+6JfQalrtroIEAJbFIpNzbytWqoeC6MJEZC54m1AANe93ETr1" +
          "F/fqvE2zV53VeHn2t7T3iSemRHkr82IyTFlA93QYNj2OlpumkgKN9biXg0PVF4j2" +
          "rTsmxKyTE8pxokl61cssRwgI7dmGVsJziwY1+QQxb7P70MJ5DbnnQ/xyaFytbUJp" +
          "UbCHmMj7/wADSbWAk6XPN5ky0y+1Hu3G64BV7S1w0P8Rz/efzSDsuNuo4HR9ULRc" +
          "JBSf/r/764CHvh/9tmte+QTPRDD7OvFtOO3MVlD3SQKBgQDtEWibsj1h5QTjTfMD" +
          "eGQeUyV9QloxZ9nLc1X65Gk6b/gnDyk7YMBP5qDALZjkKtdZgDf1gQUYIBgBQ7I1" +
          "w8R0F4q5HDcdS06/BntsYCPy0kkWH7xrDXOvteAZgQKSDpuAdMLv4+KhMhl9a6a/" +
          "ULk4FJZzMCSQnJIJPpxef+Q5wwKBgQDQHq76+vGe154CzkL2ywDrRJeoAh3kK37y" +
          "ZMaaJI1mPOHtyrdjWPzGJAuUoZe0RlN9PWsJov4pUHWKZT1navikhRbP/U2C8SKj" +
          "lT33Cq4t2zSB6zXhyW5r348A3n9Oa05B/ey6H0MRoVkcJBND8Ce/KDtFvxRBBRQi" +
          "VSAb617etwKBgQCtnAQZkUw2drs/owQGVJItSwK3WnImoED1Jz+d/su5CeqW4Bl3" +
          "7ICpguHSGxJOdblDSAyy84tBga9SrbrCeN1TjzH+IdWS1GWUqzCTy0xINQtk8lTP" +
          "qQhBc1XsF3hEcgIa7mcbuq1rEv9rw/xXOsyJbzpGnMkKRj8EGh/1bH88dQKBgQCY" +
          "u+vuhPuNdu+fX4AFXjXucwhZZDRLnyArA4o81VZwEX485OhxIH1hbFKTYYPT6Uic" +
          "QNas29FqwIGCb4oAu6B+HK4BNgQMdKrXIk+3XT82qAiAz/1bFljTEd4A5UjIZDeq" +
          "do+kiAzQg3jCDjeVREnnH79gEDrs/K0qBQ7rbnDRQQKBgGurtk1ZHZbtZD/zrTf8" +
          "cdXW2XtPie7zVwJHjtpqNBeY0cZQ59afWR3wXuamdGMgRLBPMi+0M9NJT0ljorj7" +
          "Ay/pWc2QlVxxiYr7k8AO8upqb0hrb4eg8kkf5njp7SGT1Mr7Bc3cMBwj6HBz3VZT" +
          "LbklZ8LTNYtSPV7UrLazVYqN";
      final decrypted = await decryptString(encryptedSecretKey, privateKey);
      return decrypted;
    } catch (error) {
      throw error;
    }
  }

  static Future<dynamic> generateResponse(String jsonObjectResponse) async {
    try {
      final response = json.decode(jsonObjectResponse);
      final String secretKey = response["secret"];
      final String body = response["body"];
      try {
        if (body == null ||
            body.isEmpty ||
            secretKey == null ||
            secretKey.isEmpty) {
          return;
        }
        final secretKeyString = await _decretSecretKey(secretKey);
        var response = _decryptAESCryptoJS(body, secretKeyString);
        return json.decode(response);
      } catch (error) {
        throw (error.toString());
      }
    } catch (error) {
      throw (error.toString());
    }
  }

  static Future<dynamic> post(String jsonObject, String url) async {
    final String randomKey = CustomHelper.generateRandomString(16);
    try {
      final String secretKey = await _encryptSecretKey(randomKey);
      final String versionCode = await CustomHelper.getApplicationBuildNumber();
      final String userAccessTokenKey = await Auth.getAccessToken();
      final String userAccessToken = userAccessTokenKey!=null?userAccessTokenKey:_defaultAuthenticationToken;
      print(userAccessToken);
      final Map<String, String> headers = {
        "Secret": secretKey,
        "Versioncode": versionCode,
        "Authorization": userAccessToken,
      };
      final String postRequest = _encryptAESCryptoJS(jsonObject, randomKey);
      try {
        final http.Response response =
            await http.post(url, headers: headers, body: postRequest);
        try {
          final responseBody = await generateResponse(response.body);
          if (responseBody['status'] == 1) {
            return responseBody;
          } else {
            throw HttpException(responseBody['message'].toString());
          }
        } catch (error) {
          throw error;
        }
      } catch (error) {
        throw error;
      }
    } catch (error) {
      throw (error);
    }
  }
}
