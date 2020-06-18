import 'dart:convert';
import 'dart:io';

import 'package:chamasoft/providers/auth.dart';
import 'package:encrypt/encrypt.dart';
import 'package:simple_rsa/simple_rsa.dart';

import '../utilities/custom-helper.dart';
import 'common.dart';

class PostToServer {
  static const String _defaultAuthenticationToken = "d8ng63ttyjp88cnjpkme65efgz6b2gwg";

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
    final encryptProtocol = Encrypter(AES(Key.fromUtf8(passphrase), mode: AESMode.cbc));
    final encrypted = encryptProtocol.decrypt64(encryptedBody, iv: IV.fromBase64(ivBody));
    return encrypted;
  }

  static Future<String> _encryptSecretKey(String randomKey) async {
    try {
      final publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+VsG3fDU1B8V7258pZST" +
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
      print(jsonObjectResponse);
      final response = json.decode(jsonObjectResponse);
      final String secretKey = response["secret"];
      final String body = response["body"];
      try {
        if (body == null || body.isEmpty || secretKey == null || secretKey.isEmpty) {
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
    try {
      final result = await InternetAddress.lookup("example.com").timeout(const Duration(seconds: 10), onTimeout: () {
        throw CustomException(message: ERROR_MESSAGE_INTERNET, status: ErrorStatusCode.statusNoInternet);
      });
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final String randomKey = CustomHelper.generateRandomString(16);
        print(url);
        try {
          final String secretKey = await _encryptSecretKey(randomKey);
          final String versionCode = await CustomHelper.getApplicationBuildNumber();
          final String userAccessTokenKey = await Auth.getAccessToken();
          final String userAccessToken = userAccessTokenKey != null ? userAccessTokenKey : _defaultAuthenticationToken;
          print("Access Token: " + userAccessToken);
          print("Secret: " + secretKey);
          final Map<String, String> headers = {
            "Secret": secretKey,
            "Versioncode": versionCode,
            "Authorization": userAccessToken,
          };
          final String postRequest = _encryptAESCryptoJS(jsonObject, randomKey);
          print("Body: " + postRequest);
          try {
//            final http.Response response =
//                await http.post(url, headers: headers, body: postRequest).timeout(const Duration(seconds: 120), onTimeout: () {
//              throw CustomException(message: ERROR_MESSAGE, status: ErrorStatusCode.statusNormal);
//            });
            try {
              String response =
                  '{"secret": "mDSCfe0BKRxVyWn6OD1RbAfbI9Mj54KxGghhBTX0tQgNzq2QCuiLuZn13xRUOnR8Z/0BocoytsYarz8csq9cALBg2bTOFA9OZUmYsh1gBWjSp15GC93wkpHoqIoaV40d0NjPjxIRm3Vj5Wws7LanMfIQePUId9s2rMsFTMDF+BLqqD3HRb3KTfE4ifFmg0NHmu+k1vZywEI4wzcBUCZmwFJ/sjMtR/HMXyRI8tKPn4BJrzsRttEsno0ZCWN6hetkkyhJIdFnbyqlzJoe4cULOUo9yjwSw7TUV83MPzZviXQaouDwzRW4tUIWWuO/qThHcFDP56vTfksl6hu0Ff/6Rg==","body": "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:MTU5MjQ3MzM1OTEyMzQ1Ng=="}';
              final responseBody = await generateResponse(response);
              print("Server response $responseBody");
              String message = responseBody["message"].toString();
              print("error message $message");
              switch (responseBody['status']) {
                case 0:
                  //handle validation and other generic errors
                  //display error(s)
                  throw CustomException(message: message);
                  break;
                case 1:
                  //request successful
                  //throw HttpException(message, ErrorStatusCode.statusNormal);
                  return responseBody;
                  break;
                case 2:
                case 3:
                  //generic error
                  //display error
                  throw CustomException(message: message);
                  break;
                case 4:
                case 8:
                case 9:
                  //reset app
                  throw CustomException(message: message, status: ErrorStatusCode.statusRequireLogout);
                  break;
                case 5:
                case 6:
                case 10:
                  //clear current group loaded to preferences
                  //clear screens and restart app from splash screen
                  throw CustomException(message: message, status: ErrorStatusCode.statusRequireRestart);
                  break;
                case 7:
                  //generic error
                  //display error
                  throw CustomException(message: message);
                  break;
                case 11:
                case 13:
                  //invalid request id or format
                  throw CustomException(message: message);
                  break;
                case 12:
                  //duplicate request submitted
                  //treat as case 1
                  //notify user of duplicates
                  return responseBody;
                  break;
                case 400:
                  //log out user
                  throw CustomException(message: ERROR_MESSAGE_LOGIN, status: ErrorStatusCode.statusRequireLogout);
                  break;
                case 404:
                  //generic error
                  //display error
                  throw CustomException(message: ERROR_MESSAGE);
                  break;
                default:
                  //generic error
                  //display error
                  throw CustomException(message: ERROR_MESSAGE);
              }
            } catch (error) {
              throw error;
            }
          } catch (error) {
            print(error.toString());
            throw error;
          }
        } catch (error) {
          throw (error);
        }
      } else {
        throw CustomException(message: ERROR_MESSAGE_INTERNET, status: ErrorStatusCode.statusNoInternet);
      }
    } on SocketException catch (_) {
      throw CustomException(message: ERROR_MESSAGE_INTERNET, status: ErrorStatusCode.statusNoInternet);
    }
  }
}
