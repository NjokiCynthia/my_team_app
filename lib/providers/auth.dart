import 'dart:convert';

import 'package:chamasoft/screens/chamasoft/models/investment-group.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/custom-helper.dart';
import '../utilities/post-to-server.dart';

class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String accessToken;
  final String phone;
  final String avatarName;
  final String email;

  User(
      {@required this.userId,
      @required this.firstName,
      @required this.lastName,
      @required this.accessToken,
      this.phone,
      this.email,
      this.avatarName});

  String get userName {
    return firstName + " " + lastName;
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

  List<InvestmentGroup> _groups = [];

  List get groups {
    return _groups;
  }

  String get userName {
    return firstName + " " + lastName;
  }

  String get phoneNumber {
    return phone;
  }

  void setUserObject(String userObject) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(user, userObject);
  }

  Future<void> setAccessToken(String accessTokenString) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(accessToken, accessTokenString);
  }

  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessToken);
  }

  static Future<String> getUser(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      String userObject = prefs.getString(user);
      try {
        if (key != null && key.isNotEmpty && key != "0") {
          final extractedUserData =
              json.decode(userObject) as Map<String, Object>;
          if (extractedUserData.containsKey(key)) {
            return extractedUserData[key].toString();
          } else {
            return "";
          }
        } else {
          return "";
        }
      } catch (error) {
        throw HttpException("JSON Passing error " + error.toString());
      }
    } else {
      return "";
    }
  }

  Future<void> generatePin(String identity) async {
    const url = CustomHelper.baseUrl + CustomHelper.generatePin;
    final postRequest = json.encode({
      "identity": identity,
    });
    try {
      await PostToServer.post(postRequest, url);
      notifyListeners();
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      throw ("We could not complete your request at the moment. Try again later");
    }
  }

  Future<dynamic> verifyPin(Map<String, String> object) async {
    const url = CustomHelper.baseUrl + CustomHelper.verifyPin;
    final postRequest = json.encode(object);

    try {
      final response = await PostToServer.post(postRequest, url);
      Map<String,dynamic> userResponse;
      if (response['user_exists'] == 1) {
        setUserObject(json.encode({
          userId: response['user']["id"]..toString(),
          firstName: response['user']["first_name"]..toString(),
          lastName: response['user']["last_name"]..toString(),
          email: response['user']["email"]..toString(),
          phone: response['user']["phone"]..toString(),
          avatar: response['user']["avatar"]..toString(),
        }));
        final accessToken1 = response["access_token"]..toString();
        await setAccessToken(accessToken1);
        await setPreference(isLoggedIn, "true");
        List<dynamic> groupsJSON = response['user_groups'];
        if (groupsJSON.length > 0) {
          for (var groupJSON in groupsJSON) {
            this._groups.add(InvestmentGroup.fromJson(groupJSON));
          }
        }
        userResponse = {
          'userExists' : 1,
          'userGroups' : response['user_groups']
        };
      } else {
        userResponse = {
          'userExists' : 1,
          'userGroups' : '',
        };
      }
      return userResponse;
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      print(error);
      throw ("We could not complete your request at the moment. Try again later");
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLoggedIn);
    prefs.remove(user);
    prefs.remove(accessToken);
    notifyListeners();
  }
}
