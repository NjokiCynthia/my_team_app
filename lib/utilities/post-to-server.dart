import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;
import 'package:simple_rsa/simple_rsa.dart';
import 'package:crypto/crypto.dart';
import 'package:tuple/tuple.dart';


import '../utilities/custom-helper.dart';

class PostToServer {
  static String encryptAESCryptoJS(String plainText, String passphrase) {
    try {
      final salt = genRandomWithNonZero(8);
      var keyndIV = deriveKeyAndIV(passphrase, salt);
      final key = encrypt.Key(keyndIV.item1);
      final iv = encrypt.IV(keyndIV.item2);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      Uint8List encryptedBytesWithSalt = Uint8List.fromList(
          createUint8ListFromString("Salted__") + salt + encrypted.bytes);
      Uint8List encryptedIv = Uint8List.fromList(
          createUint8ListFromString("Salted__") + salt + iv.bytes);    
      return base64.encode(encryptedBytesWithSalt)+":"+base64.encode(encryptedIv);
    } catch (error) {
      throw error;
    }
  }

  // static String decryptAESCryptoJS(String encrypted, String passphrase) {
  //   try {
  //     Uint8List encryptedBytesWithSalt = base64.decode(encrypted);

  //     Uint8List encryptedBytes =
  //         encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
  //     final salt = encryptedBytesWithSalt.sublist(8, 16);
  //     var keyndIV = deriveKeyAndIV(passphrase, salt);
  //     final key = encrypt.Key(keyndIV.item1);
  //     final iv = encrypt.IV(keyndIV.item2);

  //     final encrypter = encrypt.Encrypter(
  //         encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
  //     final decrypted =
  //         encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
  //     return decrypted;
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  static Tuple2<Uint8List, Uint8List> deriveKeyAndIV(
    String passphrase, Uint8List salt) {
    var password = createUint8ListFromString(passphrase);
    Uint8List concatenatedHashes = Uint8List(0);
    Uint8List currentHash = Uint8List(0);
    bool enoughBytesForKey = false;
    Uint8List preHash = Uint8List(0);

    while (!enoughBytesForKey) {
      int preHashLength = currentHash.length + password.length + salt.length;
      if (currentHash.length > 0)
        preHash = Uint8List.fromList(currentHash + password + salt);
      else
        preHash = Uint8List.fromList(password + salt);

      currentHash = md5.convert(preHash).bytes;
      concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
      if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
    }

    var keyBtyes = concatenatedHashes.sublist(0, 32);
    var ivBtyes = concatenatedHashes.sublist(32, 48);
    return new Tuple2(keyBtyes, ivBtyes);
  }

  static Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  static Uint8List genRandomWithNonZero(int seedLength) {
    final random = Random.secure();
    const int randomMax = 245;
    final Uint8List uint8list = Uint8List(seedLength);
    for (int i = 0; i < seedLength; i++) {
      uint8list[i] = random.nextInt(randomMax) + 1;
    }
    return uint8list;
  }

  static encryptSecretKey(String randomKey) async {
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
      return encrypted;
    } catch (e) {
      print("Error3 $e");
      return e;
    }
  }

  static Future<void> post(String jsonObject,String url) async{
    final String randomKey = CustomHelper.generateRandomString(32);
    final String secretKey = encryptSecretKey(randomKey);
    final String versionCode = await CustomHelper.getApplicationBuildNumber();
    final Map<String,String> headers = {
      "Secret":secretKey,
      "Versioncode" : versionCode,
      "Authorization" : "d8ng63ttyjp88cnjpkme65efgz6b2gwg",
    };
    final String postRequest = encryptAESCryptoJS(jsonObject,randomKey);
    print(headers);
    print(postRequest);
    try{
      final http.Response response = await http.post(url,headers:headers,body:postRequest);
      print(response.body);
    }catch(error){
      print(error);
    }
  }
}
