import 'dart:convert';
import 'dart:io' as io;

import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/endpoint-url.dart';
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
  static const String userAvatar = "avatar";
  static const String email = "email";
  static const String phone = "phone";
  static const String accessToken = "accessToken";
  static const String isLoggedIn = "isLoggedIn";
  String _firstName = "";
  String _lastName = "";
  String _phoneNumber = "";
  String _userId = "";
  String _emailAddress = "";
  String _avatar = "";

  String get userName {
    return _firstName + " " + _lastName;
  }

  String get phoneNumber {
    return _phoneNumber;
  }

  String get id {
    return _userId;
  }

  String get emailAddress {
    return _emailAddress;
  }

  String get avatar {
    return _avatar;
  }

  static Future<bool> imageExists(avatarUrl) async {
    return io.File(avatarUrl).exists();
  }

  String get displayAvatar {
    var result = (_avatar != null || _avatar == "")
        ? CustomHelper.imageUrl + _avatar
        : null;
    return result;
  }

  Future<void> setUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(user)) {
      String userObject = prefs.getString(user);
      try {
        final extractedUserData =
            json.decode(userObject) as Map<String, Object>;
        if (_phoneNumber == "") {
          _phoneNumber = extractedUserData[phone]..toString();
        }
        if (_firstName == "") {
          _firstName = extractedUserData[firstName]..toString();
        }
        if (_lastName == "") {
          _lastName = extractedUserData[lastName]..toString();
        }
        if (_emailAddress == "") {
          _emailAddress = extractedUserData[email]..toString();
        }
        if (_avatar == "") {
          _avatar = extractedUserData[userAvatar]..toString();
        }
        if (_userId == "") {
          _userId = extractedUserData[userId]..toString();
        }
      } catch (error) {}
    }
  }

  void setUserObject(String userObject) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(user)){
      prefs.remove(user);
    }
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
    if (prefs.containsKey(user)) {
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
        throw CustomException(
            message: "JSON Passing error " + error.toString());
      }
    } else {
      return "";
    }
  }

  Future<void> updateUserDetails(String key, String value) async{
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(user)) {
      String userObject = prefs.getString(user);
      try {
        if (key != null && key.isNotEmpty && key != "0") {
          final extractedUserData = json.decode(userObject) as Map<String, Object>;
          if (extractedUserData.containsKey(key)) {
            extractedUserData[key] = value;
          }
          final data = json.encode(extractedUserData);
          setUserObject(data);
        } else {
          return "";
        }
      } catch (error) {
        throw CustomException(message: "JSON Passing error " + error.toString());
      }
    } else {
      return "";
    }
  }

  Future<void> generatePin(String identity) async {
    const url = EndpointUrl.GENERATE_OTP;
    final postRequest = json.encode({
      "identity": identity,
    });
    try {
      await PostToServer.post(postRequest, url);
      notifyListeners();
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> resendPin(String identity) async {
    const url = EndpointUrl.RESEND_OTP;
    final postRequest = json.encode({
      "identity": identity,
    });
    try {
      await PostToServer.post(postRequest, url);
      notifyListeners();
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<dynamic> verifyPin(Map<String, String> object) async {
    const url = EndpointUrl.VERIFY_OTP;
    final postRequest = json.encode(object);

    try {
      final response = await PostToServer.post(postRequest, url);
      Map<String, dynamic> userResponse;
      if (response['user_exists'] == 1) {
        String userFirstName = response['user']["first_name"]..toString();
        String userLastName = response['user']["last_name"]..toString();
        String userUserId = response['user']["id"]..toString();
        String userUserEmail = response['user']["email"]..toString();
        String userUserPhone = response['user']["phone"]..toString();
        String userUserAvatar = response['user']["avatar"]..toString();
        setUserObject(json.encode({
          userId: userUserId,
          firstName: userFirstName,
          lastName: userLastName,
          email: userUserEmail,
          phone: userUserPhone,
          userAvatar: userUserAvatar,
        }));
        _firstName = userFirstName;
        _lastName = userLastName;
        _userId = userUserId;
        _emailAddress = userUserEmail;
        _phoneNumber = userUserPhone;
        _avatar = userUserAvatar;
        final accessToken1 = response["access_token"]..toString();
        await setAccessToken(accessToken1);
        await setPreference(isLoggedIn, "true");
        userResponse = {'userExists': 1, 'userGroups': response['user_groups']};
      } else {
        userResponse = {
          'userExists': 2,
          'userGroups': '',
        };
      }
      return userResponse;
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLoggedIn);
    prefs.remove(user);
    prefs.remove(accessToken);
    notifyListeners();
  }

  Future<void> updateUserName(String name)async{
    const url = EndpointUrl.UPDATE_USER_NAME;
    final postRequest = json.encode({
      "name": name.trim(),
      "user_id" : _userId,
    });
    try {
      final response = await PostToServer.post(postRequest, url);
      String userFirstName = response["first_name"]..toString();
      String userLastName = response["last_name"]..toString();
      _firstName = userFirstName;
      _lastName = userLastName;
      await updateUserDetails(firstName,userFirstName);
      await updateUserDetails(lastName,userLastName);
      notifyListeners();
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> updateUserEmailAddress(String emailAddress) async{
    const url = EndpointUrl.UPDATE_USER_EMAIL_ADDRESS;
    final postRequest = json.encode({
      "email": emailAddress.trim(),
      "user_id" : _userId,
    });
    try {
      await PostToServer.post(postRequest, url);
      _emailAddress = emailAddress;
      await updateUserDetails(email,emailAddress);
      notifyListeners();
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> updateUserAvatar(io.File avatar)async{
    const url = EndpointUrl.EDIT_NEW_USER_PHOTO;
    try{
      final resizedImage = await CustomHelper.resizeFileImage(avatar,300);
      print("resizedImage : $resizedImage");
      try{
        final newAvatar = base64Encode(resizedImage.readAsBytesSync());
        final postRequest = json.encode({
          "avatar": newAvatar,
          "user_id" : _userId,
        });
        final response = await PostToServer.post(postRequest, url);
        try{
          final newUserAvatar = response["avatar"];
          _avatar = newUserAvatar;
          await updateUserDetails(userAvatar,newUserAvatar);
          notifyListeners();
        }catch (error) {
          throw CustomException(message: ERROR_MESSAGE);
        }
      }catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    }catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }
}
