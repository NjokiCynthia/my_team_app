import 'dart:convert';


import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String get userName{
    return firstName+" "+lastName;
  }
}


class Auth with ChangeNotifier {
  static const String user = "user";
  static const String userId = "userId";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String avatar = "avatar";
  static const String email = "email";
  static const String phone = "phone";
  static const String accessToken = "accessToken";
  static const String isLoggedIn = "isLoggedIn";

  void setUserObject(String userObject) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(user, userObject);
  }

  void setAccessToken(String accessToken) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(accessToken, accessToken);
  }

  Future<String> getAccessToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessToken);
  }

  Future<String> getUser(String key) async{
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      String userObject = prefs.getString(user);
      try{
          if (key != null && key.isNotEmpty && key != "0") {     
            final extractedUserData = json.decode(userObject) as Map<String, Object>;
            if(extractedUserData.containsKey(key)){
              return extractedUserData[key].toString();
            }else{
              return "";
            }
          }else{
            return "";
          }
      }catch(error){
        throw HttpException("JSON Passing error " + error.toString());
      }
    }else{
      return "";
    }
  }

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
      if(response['user_exists'] == 1){
        setUserObject(json.encode({
          userId : response['user']["id"]..toString(),
          firstName : response['user']["first_name"]..toString(),
          lastName : response['user']["last_name"]..toString(),
          email : response['user']["email"]..toString(),
          phone : response['user']["phone"]..toString(),
          avatar : response['user']["avatar"]..toString(),
        }));
        setAccessToken(response['user']["access_token"]..toString());
        setPreference(isLoggedIn,"true");
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

  void logout() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLoggedIn);
    prefs.remove(user);
    prefs.remove(accessToken);
    notifyListeners();
  }
}
