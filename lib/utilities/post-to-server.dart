import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:simple_rsa/simple_rsa.dart';

import '../utilities/custom-helper.dart';

class PostToServer {
  static String encryptAESCryptoJS(String plainText, String passphrase) {
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

  static Future<String> encryptSecretKey(String randomKey) async {
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

  static Future<dynamic> post(String jsonObject, String url) async {
    final String randomKey = CustomHelper.generateRandomString(16);
    try {
      final String secretKey = await encryptSecretKey(randomKey);
      final String versionCode = await CustomHelper.getApplicationBuildNumber();
      final Map<String, String> headers = {
        "Secret": secretKey,
        "Versioncode": versionCode,
        "Authorization": "d8ng63ttyjp88cnjpkme65efgz6b2gwg",
      };
      final String postRequest = encryptAESCryptoJS(jsonObject, randomKey);
      try {
        final http.Response response =
            await http.post(url, headers: headers, body: postRequest);
        try {
          final responseBody = json.decode(response.body);
          if(responseBody['status']==1){
            return responseBody;
          }else{
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
