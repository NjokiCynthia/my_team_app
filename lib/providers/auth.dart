import 'dart:convert';


import 'package:flutter/material.dart';

import '../utilities/post-to-server.dart';
import '../utilities/custom-helper.dart';

class Auth with ChangeNotifier {
  Future<void> generatePin(String identity) async {
    const url = CustomHelper.baseUrl + CustomHelper.generatePin;
    final postRequest = json.encode({
      "identity": identity,
    });
    try{
      await PostToServer.post(postRequest,url);
      notifyListeners();
    }on HttpException catch(error){
      throw HttpException(error.toString());
    }catch(error){
      throw ("We could not complete your request at the moment. Try again later");
    }

  }
}
