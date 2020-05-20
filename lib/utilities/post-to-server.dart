import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

class PostToServer{

  static splitStr(String str) {
    var begin = '-----BEGIN PUBLIC KEY-----\n';
    var end = '\n-----END PUBLIC KEY-----';
    int splitCount = str.length ~/ 64;
    List<String> strList=List();

    for (int i=0; i<splitCount; i++) {
      strList.add(str.substring(64*i, 64*(i+1)));
    }
    if (str.length%64 != 0) {
      strList.add(str.substring(64*splitCount));
    }
    return begin + strList.join('\n') + end;
  }

  static _login(String password) async {
    try {
      final publicCert = await rootBundle.loadString('assets/certificates/mpesachama.crt');
      final parser = RSAKeyParser();

      String publicKeyString = splitStr(publicCert);
      try{
        RSAPublicKey publicKey = parser.parse(publicKeyString);
        try{
          final encrypter = Encrypter(RSA(publicKey: publicKey));
          final rsaPasswd = encrypter.encrypt(password).base64;
          print(rsaPasswd);
        }catch(error3){
          print("Error3 $error3");
        }
      }catch(error2){
        print("Error2 $error2");
      }
      
    } catch (e) {
      print(e);
    }
  }

  static Future<void> post(String jsonObject){
    _login(jsonObject);
  }
}