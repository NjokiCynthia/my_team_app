import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

class PostToServer{

  static Future<String> encryptJson(String jsonObject) async{
    // String key = '1245714587458745'; //combination of 16 character
    // String iv = 'e16ce913a20dadb8'; ////combination of 16 character
    // String encryptedString =
    // await Cipher2.encryptAesCbc128Padding7(jsonObject, key, iv);
    // print("key:$key");
    // print("iv:$iv");
    // print("String:$encryptedString");
  }


  static Future<String> encryptSecretKey(var key) async{
    try{
      final publicCert = await rootBundle.loadString('assets/certificates/mpesachama.crt');
      final publicKey = RSAKeyParser().parse(publicCert) as RSAPublicKey;
      try{
        final encrypter = Encrypter(
          RSA(
            publicKey: publicKey,
            encoding: RSAEncoding.PKCS1,
          ),
        );
        return (encrypter.encrypt(key)).base64;
      }catch(error){
        print("error2 ${error.toString()}");
      }
    }catch(error){
      print("error ${error.toString()}");
    }
  }

  static Future<void> post(String jsonObject){
    final key = Key.fromLength(32);
    print("key ${key.toString()}");
    print("encrypted: ${encryptSecretKey(key)}");
    encryptJson(jsonObject);
  }
}