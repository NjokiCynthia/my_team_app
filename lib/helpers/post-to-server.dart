import 'dart:convert';
import 'dart:io';
import 'package:chamasoft/helpers/get_path.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom-helper.dart';
import 'common.dart';

class PostToServer {
  static const String _defaultAuthenticationToken =
      "d8ng63ttyjp88cnjpkme65efgz6b2gwg";

  static String _encryptAESCryptoJS(String plainText, String passphrase) {
    try {
      final key = Key.fromUtf8(passphrase);
      final iv = IV.fromSecureRandom(16);
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
          '''MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+VsG3fDU1B8V7258pZST
0FfZzEXiPCC6i8RtA5pyS/orSBa1Ds3PMnF4qU+Z+HlBB9apKG/pYK73mXR8v1cX
jZCFxg08Gq/dwam1O5ehNXtEHKhembXdZC2zdFyVVg8emgbyDxaP1oEWwQOqoUI7
1e1lPqDMrFTUeS65YO2ayWeEKEnY12nE6pgyopSdEo5Boz4RzxCL8jLIhTwRouhi
MOA9UyWBYuQEp8P1yj8zVoB20WyB6qOazPIiCEUz4MK0/yiVTR6B8hWwQydvMGKu
QWdCjZcopnehZDPLyXc5fuC++4o6E6WfDoL/GCTMeQ/bCaavCKUX4oypMLUVN1Zd
3QIDAQAB''';

      final parser = RSAKeyParser();
      dynamic key = parser.parse(splitStr(publicKey));
      final encryptProtocol = Encrypter(RSA(publicKey: key));
      final encrypted = encryptProtocol.encrypt(randomKey);
      return encrypted.base64;
    } catch (error) {
      throw error;
    }
  }

  static splitStr(String str) {
    var begin = '-----BEGIN PUBLIC KEY-----\n';
    var end = '\n-----END PUBLIC KEY-----';
    int splitCount = str.length ~/ 64;

    List<String> strList = [];

    for (int i = 0; i < splitCount; i++) {
      strList.add(str.substring(64 * i, 64 * (i + 1)));
    }
    if (str.length % 64 != 0) {
      strList.add(str.substring(64 * splitCount));
    }

    return begin + strList.join('\n') + end;
  }

  static splitPrivateStr(String str) {
    var begin = '-----BEGIN PRIVATE KEY-----\n';
    var end = '\n-----END PRIVATE KEY-----';
    int splitCount = str.length ~/ 64;

    List<String> strList = [];

    for (int i = 0; i < splitCount; i++) {
      strList.add(str.substring(64 * i, 64 * (i + 1)));
    }
    if (str.length % 64 != 0) {
      strList.add(str.substring(64 * splitCount));
    }

    return begin + strList.join('\n') + end;
  }

  static Future<String> _decryptSecretKey(String encryptedSecretKey) async {
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

      final parser = RSAKeyParser();
      dynamic key = parser.parse(splitPrivateStr(privateKey));
      final decryptProtocol = Encrypter(RSA(privateKey: key));

      final decrypted = decryptProtocol.decrypt64(encryptedSecretKey);
      return decrypted;
    } catch (error) {
      throw error;
    }
  }

  static Future<dynamic> generateResponse(String jsonObjectResponse) async {
    try {
      final response = json.decode(jsonObjectResponse);

      print(response);
      final String secretKey = response["secret"] ?? "";
      final String body = response["body"] ?? "";
      try {
        if (body.isEmpty || secretKey.isEmpty) {
          return;
        }
        final secretKeyString = await _decryptSecretKey(secretKey);
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
      final result = await InternetAddress.lookup("example.com")
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw CustomException(
          message: ERROR_MESSAGE_INTERNET,
          status: ErrorStatusCode.statusNoInternet,
        );
      });
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final String randomKey = CustomHelper.generateRandomString(16);
        // print(url);
        var newrequestDate = DateTime.now().millisecondsSinceEpoch;
        print("$newrequestDate $url");
        try {
          final String secretKey = await _encryptSecretKey(randomKey);
          final String versionCode =
              await CustomHelper.getApplicationBuildNumber();
          final String userAccessTokenKey = await Auth.getAccessToken();
          final String userAccessToken =
              userAccessTokenKey ?? _defaultAuthenticationToken;
          final Map<String, String> headers = {
            "Secret": secretKey,
            "Versioncode": versionCode,
            "Authorization": userAccessToken,
          };
          print("Request >>>>>>> $jsonObject");
          final String postRequest = _encryptAESCryptoJS(jsonObject, randomKey);
          // print("_encryptAESCryptoJS: $postRequest");
          try {
            final http.Response response = await http
                .post(Uri.parse(url), headers: headers, body: postRequest)
                .timeout(const Duration(seconds: 60), onTimeout: () {
              throw CustomException(
                  message: ERROR_MESSAGE, status: ErrorStatusCode.statusNormal);
            });
            try {
              var newResponseDate = DateTime.now().millisecondsSinceEpoch;
              final responseBody = await generateResponse(response.body);
              print("Server Response >>>>>>>> $responseBody");
              String message = responseBody["message"].toString();
              String groupId = json.decode(jsonObject)['group_id'] ?? 'null';
              String userId = json.decode(jsonObject)['user_id'] ?? 'null';
              await writeData(url, groupId, userId, newrequestDate.toString(),
                  newResponseDate.toString());

              /* final _dirPath = await getDirPath();

              final _myFile = File('$_dirPath/data.txt');

              print("File size is : ${ await _myFile.length()}");

              if(await _myFile.length() >= 1000){
                print("Hello, its more than 10kb");

                await _myFile.delete();


                // readFileData();

              }
              else{
                print("Hello, its less than 10kb");
                // readFileData();
              }*/

              // readFileData();

              switch (responseBody['status']) {
                case 0:
                  //handle validation and other generic errors
                  //display error(s)
                  // writeData();
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  if (responseBody["validation_errors"] != null) {
                    message = "";
                    Map<String, dynamic> validationErrors =
                        responseBody["validation_errors"];
                    validationErrors.forEach((key, value) {
                      message = message + value + "\n";
                    });

                    throw CustomException(
                      message: message,
                      status: ErrorStatusCode.statusFormValidationError,
                    );
                  }
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());

                  throw CustomException(message: message);
                case 1:
                  //request successful
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  return responseBody;
                case 2:
                case 3:
                  //generic error
                  //display error
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  throw CustomException(message: message);
                case 4:
                case 8:
                case 9:
                  //reset app
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  throw CustomException(
                      message: message,
                      status: ErrorStatusCode.statusRequireLogout);
                case 5:
                case 6:
                case 10:
                  //clear current group loaded to preferences
                  //clear screens and restart app from splash screen
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  throw CustomException(
                      message: message,
                      status: ErrorStatusCode.statusRequireRestart);
                case 7:
                  //generic error
                  //display error
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  throw CustomException(message: message);
                case 11:
                case 13:
                  //invalid request id or format
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  throw CustomException(message: message);
                case 12:
                  //duplicate request submitted
                  //treat as case 1
                  //notify user of duplicates
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  return responseBody;
                case 400:
                  //log out user
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  throw CustomException(
                      message: ERROR_MESSAGE_LOGIN,
                      status: ErrorStatusCode.statusRequireLogout);
                case 404:
                  //generic error
                  //display error
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  throw CustomException(message: ERROR_MESSAGE);
                default:
                  //generic error
                  //display error
                  await writeData(url, groupId, userId,
                      newrequestDate.toString(), newResponseDate.toString());
                  throw CustomException(message: ERROR_MESSAGE);
              }
            } catch (error) {
              //log(response.body);

              print("1: ${response.body}");
              throw error;
            }
          } catch (error) {
            print("2: ${error.toString()}");
            throw error;
          }
        } catch (error) {
          print("3: ${error.toString()}");
          throw (error);
        }
      } else {
        throw CustomException(
          message: ERROR_MESSAGE_INTERNET,
          status: ErrorStatusCode.statusNoInternet,
        );
      }
    } on SocketException catch (_) {
      throw CustomException(
        message: ERROR_MESSAGE_INTERNET,
        status: ErrorStatusCode.statusNoInternet,
      );
    }
  }

  static Future<dynamic> ResponseGenerate(jsonObjectResponse) async {
    try {
      final response = jsonObjectResponse;
      //json.decode(jsonObjectResponse.toString());
      final String secretKey = response["secret"] ?? "";
      final String body = response["body"] ?? "";
      try {
        if (body.isEmpty || secretKey.isEmpty) {
          return;
        }
        final secretKeyString = await _decryptSecretKey(secretKey);
        var response = _decryptAESCryptoJS(body, secretKeyString);
        return json.decode(response);
      } catch (error) {
        throw (error.toString());
      }
    } catch (error) {
      throw (error.toString());
    }
  }

  static Future<dynamic> postDio(FormData formData, String url) async {
    try {
      final result = await InternetAddress.lookup("example.com")
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw CustomException(
          message: ERROR_MESSAGE_INTERNET,
          status: ErrorStatusCode.statusNoInternet,
        );
      });
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final String randomKey = CustomHelper.generateRandomString(16);
        // print(url);
        var newrequestDate = DateTime.now().millisecondsSinceEpoch;
        print("$newrequestDate $url");
        try {
          final dio = Dio();
          final String secretKey = await _encryptSecretKey(randomKey);
          final String versionCode =
              await CustomHelper.getApplicationBuildNumber();
          final String userAccessTokenKey = await Auth.getAccessToken();
          final String userAccessToken =
              userAccessTokenKey ?? _defaultAuthenticationToken;
          print("Request >>>>>>> ${formData.fields} ${formData.files}");
          // final String postRequest = _encryptAESCryptoJS(formData, randomKey);
          // print("_encryptAESCryptoJS: $postRequest");
          Map<String, dynamic> headers = {
            'Secret': secretKey,
            'VersionCode': versionCode,
            'Authorization': userAccessToken,
          };
          final response = await dio.post(
            url.toString(),
            options: Options(headers: headers),
            data: formData,
          );
          print('Show response');
          print(response.data);
          final responseBody = await ResponseGenerate(response.data);
          print("Server Response >>>>>>>> $responseBody");
          return responseBody;
        } catch (error) {
          print("3: ${error.toString()}");
          throw (error);
        }
      } else {
        throw CustomException(
          message: ERROR_MESSAGE_INTERNET,
          status: ErrorStatusCode.statusNoInternet,
        );
      }
    } on SocketException catch (_) {
      throw CustomException(
        message: ERROR_MESSAGE_INTERNET,
        status: ErrorStatusCode.statusNoInternet,
      );
    }
  }
}
