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

  static void decryptAESCryptoJS(String key, String body) {
    try {
      final parts = body.split(":");
      final encryptProtocol =
          Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
      final encrypted =
          encryptProtocol.decrypt64(parts[0], iv: IV.fromBase64(parts[1]));
      print("Decrypted: $encrypted");
    } catch (error) {
      print("Decrypt AES Error: $error");
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

  static Future<void> decryptSecretKey() async {
    print("Start Decryption");
    try {
      final privateKey =
          "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDAuo8TA41+kUZvjM4sB+o9k4wkzuEdqUIZa710GmCPzQCc4kRTc7nrTO6sfNSq1Rz1O5XwQkhF1mFf2+CNF4sUSJdZ/9i+CqpTvEr9/kaEqFmVcD0DP0IK9V/rAp1bBER3sv9xkVfNwGeVN4JvIHFz/NPyo8DGsrwn+F72mIzkP8N9OyyuVVqVU+n63fF/qWFvIycau6oZBjFVRO3BIdwtRPAImT1YrVZ1cuCZuqlwcVsW4P21YMMU2fyxjoEVxcePuhOF+ZxG9v21Y4agXmf1GFaU98qlxtf2QvFwZTUbHDmKYjbc1bbo+SZHyaqXnSy78G/ktj3VlCl+qNmM1mRlAgMBAAECggEASObIs/KGFTgyooNqgXFFA6HKQyoWMTgTDraYZVCM8hgjgTR9j+uYig8BwTE+6JfQalrtroIEAJbFIpNzbytWqoeC6MJEZC54m1AANe93ETr1F/fqvE2zV53VeHn2t7T3iSemRHkr82IyTFlA93QYNj2OlpumkgKN9biXg0PVF4j2rTsmxKyTE8pxokl61cssRwgI7dmGVsJziwY1+QQxb7P70MJ5DbnnQ/xyaFytbUJpUbCHmMj7/wADSbWAk6XPN5ky0y+1Hu3G64BV7S1w0P8Rz/efzSDsuNuo4HR9ULRcJBSf/r/764CHvh/9tmte+QTPRDD7OvFtOO3MVlD3SQKBgQDtEWibsj1h5QTjTfMDeGQeUyV9QloxZ9nLc1X65Gk6b/gnDyk7YMBP5qDALZjkKtdZgDf1gQUYIBgBQ7I1w8R0F4q5HDcdS06/BntsYCPy0kkWH7xrDXOvteAZgQKSDpuAdMLv4+KhMhl9a6a/ULk4FJZzMCSQnJIJPpxef+Q5wwKBgQDQHq76+vGe154CzkL2ywDrRJeoAh3kK37yZMaaJI1mPOHtyrdjWPzGJAuUoZe0RlN9PWsJov4pUHWKZT1navikhRbP/U2C8SKjlT33Cq4t2zSB6zXhyW5r348A3n9Oa05B/ey6H0MRoVkcJBND8Ce/KDtFvxRBBRQiVSAb617etwKBgQCtnAQZkUw2drs/owQGVJItSwK3WnImoED1Jz+d/su5CeqW4Bl37ICpguHSGxJOdblDSAyy84tBga9SrbrCeN1TjzH+IdWS1GWUqzCTy0xINQtk8lTPqQhBc1XsF3hEcgIa7mcbuq1rEv9rw/xXOsyJbzpGnMkKRj8EGh/1bH88dQKBgQCYu+vuhPuNdu+fX4AFXjXucwhZZDRLnyArA4o81VZwEX485OhxIH1hbFKTYYPT6UicQNas29FqwIGCb4oAu6B+HK4BNgQMdKrXIk+3XT82qAiAz/1bFljTEd4A5UjIZDeqdo+kiAzQg3jCDjeVREnnH79gEDrs/K0qBQ7rbnDRQQKBgGurtk1ZHZbtZD/zrTf8cdXW2XtPie7zVwJHjtpqNBeY0cZQ59afWR3wXuamdGMgRLBPMi+0M9NJT0ljorj7Ay/pWc2QlVxxiYr7k8AO8upqb0hrb4eg8kkf5njp7SGT1Mr7Bc3cMBwj6HBz3VZTLbklZ8LTNYtSPV7UrLazVYqN";

//      String secret =
//          "PJNK/6CJBvyAqWdakfjEkLCkCfM1NbMKJ/z6uuD7qhbfUPdodOLekJKgZrpkLUpaJJKqy07mwsNHVSIiQ85CMi68I2Yzrfc73wageYqK+jSagibojA3kLn4hW+W2mu0vgb9ZfR7qQ5gfeD3rMEUhP0yL5wykIyj8bofmejCqpZKgnSatFl/pTV0rLLCNAhkhg13HgUxNgo82M+uabXLSim8hvlcI0W4yRO/v4b0Fh8J5wIX2HKTzxp8b7LExfaDEeO0DRwXnQZ75Y2PXRV1csDrkt7eaCHmh6uVef4gHI9FleKePAnqNI6FXGIESs7pcmi+jCic+tIPHMaCp0WID4A==";
//      String secret =
//          "OXlfUuk33LlXcqOEC48GJLmqvmI7Tk6W58ivMOvD4pdThQXVsarmnZLHrMBO7jCGv32bjNYP+3ewrxs4Xt2oA1toO5oktRpLsSHwWcvB/pvsyLzLhhl8eqIZPZA7Ng56Zhg3ES4FHEn0FJ8Wifjo3du/797zC+uA6h3NkDHYhmMTJ0iyx0Vq2Ug2SCFhUOrD9unX4o6h6Ui7iEx0Yu6TZ7FeAM3ERJrCunRUUqHWiT37nEbzZpt67SHWYgv+Ce4CGiE/cOKkC+cp/7YJh1M6EtjDQWVsUDt15GHkDst4ovRuIM1i4CqxAM+vdl/Tz1EtCJCceTPDjlpU2NJEIGumAw==";
//      String body =
//          "ISYXje0J/vF/Tf0wTpMR3Fh4PLaxCZy/hE9ZLRtx8AP3t6YA8ZaNQJ7gDtV2YrFl:MTU4OTI4MDY4NjEyMzQ1Ng==";
      String secret =
          "DQNXOgADONwWunnbEfju8hjNrJ+E5Av+fhftz0tJgM8ojaHMwTPdPMlBO6Cx\/mGc+P1ZvfBS15mNGcNzIGhoJxrl5N1+VUEy\/WCJLX8Ub60aNyd9JhhBJVqxC0Al6jcWqJ89HN0vNNV4ZWXityBIAUxKpiOSg94Iw1eCGk6EA5kgWoSNK7ALYMpkGqIS6U32mueMEA7P9SZfTURvOUON1jlTSKolju6vJrWZPBOjmapPFn89Q1DNpe4d8Ip1zqe980+MGLHXZPqaXNv3YLKrsNrqSWvqWQOvWqN1tiZxlS0bVd2WemALuMmeHMoEet0yxgSWjZOnE2pNJDENkmVcrA==";
      String body =
          "OBFQGMUbW10rnjz7Gxlo5z4ODSuaa4fFeHC4EOkBdxG7EPPWB9nqQ7tHVgOoIyZr:MTU4OTk2NzQwNzEyMzQ1Ng==";

      String decrypted = await decryptString(secret, privateKey);
      print(decrypted);
      decryptAESCryptoJS(decrypted, body);
    } catch (error) {
      print("Decrypt Error: $error");
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
          print(responseBody);
          if (responseBody['status'] == 1) {
            await decryptSecretKey();
            return responseBody;
          } else {
            throw HttpException(responseBody['message'].toString());
          }
        } catch (error) {
          print(error);
          throw error;
        }
      } catch (error) {
        print(error);
        throw error;
      }
    } catch (error) {
      throw (error);
    }
  }
}
