import 'dart:convert';


import 'package:chamasoft/providers/groups.dart';
import 'package:flutter/material.dart';

import '../utilities/post-to-server.dart';
import '../utilities/custom-helper.dart';

class User{
  final String userId;
  final String firstName;
  final String lastName;
  final String accessToken;
  final String phone;
  final String avatarName;
  final String email;

  User({
    @required this.userId,
    @required this.firstName,
    @required this.lastName,
    @required this.accessToken,
    this.phone,
    this.email,
    this.avatarName
  });

  
}


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

  Future <int> verifyPin(Map <String,String> object) async{
    const url = CustomHelper.baseUrl + CustomHelper.verifyPin;
    final postRequest = json.encode(object);
    try{
      final response = await PostToServer.post(postRequest,url);
      print(response);
      User(
        userId: response['user']["id"]..toString(), 
        firstName: response['user']["first_name"]..toString(),  
        lastName: response['user']["last_name"]..toString(),  
        accessToken: response['user']["access_token"]..toString()
      );
      if(response['user_exists'] == 1){
        return 1;
      }else{
        return 2;
      }
    }on HttpException catch(error){
      throw HttpException(error.toString());
    }catch(error){
      throw ("We could not complete your request at the moment. Try again later");
    }
  }
}
