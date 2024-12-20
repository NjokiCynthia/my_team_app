import 'dart:convert';
import 'dart:io' as io;

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom-helper.dart';
import '../helpers/post-to-server.dart';

class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String accessToken;
  final String phone;
  final String avatarName;
  final String email;
  final String mobileToken;

  User(
      {@required this.userId,
      @required this.firstName,
      @required this.lastName,
      @required this.accessToken,
      this.phone,
      this.email,
      this.avatarName,
      this.mobileToken});

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
  static const String identity = "identity";
  String _firstName = "";
  String _lastName = "";
  String _phoneNumber = "";
  String _userId = "";
  String _emailAddress = "";
  String _avatar = "";
  String _mobileToken = "";

  String get userName {
    return _firstName + " " + _lastName;
  }

  String get firstNameOnly {
    return _firstName;
  }

  String get lastNameOnly {
    return _lastName;
  }

  String get phoneNumber {
    return _phoneNumber;
  }

  String get id {
    return _userId;
  }

  String get userIdentity {
    return _phoneNumber != null ? _phoneNumber : _emailAddress;
  }

  String get token {
    return accessToken;
  }

  String get emailAddress {
    return _emailAddress;
  }

  String get avatar {
    return _avatar;
  }

  String get mobileToken {
    return _mobileToken;
  }

  void setUserMobileToken(String token) {
    print("this is the token to set $token");
    _mobileToken = token;
  }

  static Future<bool> imageExists(avatarUrl) async {
    return io.File(avatarUrl).exists();
  }

  String get displayAvatar {
    var result = (_avatar != null && _avatar != 'null' && _avatar != '')
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
          _phoneNumber = extractedUserData[phone].toString();
        }
        if (_firstName == "") {
          _firstName = extractedUserData[firstName].toString();
        }
        if (_lastName == "") {
          _lastName = extractedUserData[lastName].toString();
        }
        if (_emailAddress == "") {
          _emailAddress = extractedUserData[email].toString();
        }
        if (_avatar == "") {
          _avatar = extractedUserData[userAvatar].toString();
        }
        if (_userId == "") {
          _userId = extractedUserData[userId].toString();
        }
      } catch (error) {}
    }
  }

  void setUserObject(String userObject) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(user)) {
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
          } else if (key == identity) {
            if (extractedUserData[phone].toString() != '') {
              return extractedUserData[phone].toString();
            } else {
              return extractedUserData[email].toString();
            }
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

  Future<void> updateUserDetails(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(user)) {
      String userObject = prefs.getString(user);
      try {
        if (key != null && key.isNotEmpty && key != "0") {
          final extractedUserData =
              json.decode(userObject) as Map<String, Object>;
          if (extractedUserData.containsKey(key)) {
            extractedUserData[key] = value;
          }
          final data = json.encode(extractedUserData);
          setUserObject(data);
        } else {
          return;
        }
      } catch (error) {
        throw CustomException(
            message: "JSON Passing error " + error.toString());
      }
    } else {
      return;
    }
  }

  Future<void> generatePin(String identity, String appSignature) async {
    final url = EndpointUrl.GENERATE_OTP;

    print("The url generated is $url");
    final postRequest = json.encode({
      "identity": identity,
      "appSignature": appSignature,
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

  Future<void> resendPin(String identity, String appSignature) async {
    final url = EndpointUrl.RESEND_OTP;
    final postRequest = json.encode({
      "identity": identity,
      "appSignature": appSignature,
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
    final url = EndpointUrl.VERIFY_OTP;
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
        String userMobileToken =
            response['user']["mobile_token"].toString() ?? "";
        print(response["user"]);
        var userObject = json.encode({
          userId: userUserId,
          firstName: userFirstName,
          lastName: userLastName,
          email: userUserEmail,
          phone: userUserPhone,
          userAvatar: userUserAvatar,
          mobileToken: userMobileToken,
        });
        setUserObject(userObject);
        print("user object $userObject");
        _firstName = userFirstName;
        _lastName = userLastName;
        _userId = userUserId;
        _emailAddress = userUserEmail;
        _phoneNumber = userUserPhone;
        _avatar = userUserAvatar;
        _mobileToken = userMobileToken;
        final accessToken1 = response["access_token"]..toString();
        await setAccessToken(accessToken1);
        await setPreference(isLoggedIn, "true");
        userResponse = {
          'userExists': 1,
          'userGroups': response['user_groups'],
          "userId": userUserId
        };
      } else {
        userResponse = {
          'userExists': 2,
          'userGroups': '',
          'uniqueCode': response['unique_code'],
        };
      }
      notifyListeners();
      return userResponse;
    } on CustomException catch (error) {
      print("error here $error");
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      print("error here2 $error");
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<bool> updateUserToken(Map<String, String> object) async {
    final url = EndpointUrl.UPDATE_USER_MOBILE_TOKEN;
    final postRequest = json.encode(object);
    try {
      await PostToServer.post(postRequest, url);
      notifyListeners();
      return true;
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> registerUser(Map<String, dynamic> userObject) async {
    try {
      String newAvatar;
      if (userObject['avatar'] != null) {
        newAvatar = base64Encode(userObject['avatar'].readAsBytesSync());
      }
      final url = EndpointUrl.SIGNUP;
      final postRequest = json.encode({
        "identity": userObject['identity'],
        "first_name": userObject['firstName'],
        "last_name": userObject['lastName'],
        "avatar": newAvatar,
        "password": userObject['identity'],
        "confirm_password": userObject['identity'],
        'unique_code': userObject['uniqueCode'],
      });
      final response = await PostToServer.post(postRequest, url);
      String userFirstName = response['user']["first_name"].toString();
      String userLastName = response['user']["last_name"].toString();
      String userUserId = response['user']["id"].toString();
      String userUserEmail = response['user']["email"].toString();
      String userUserPhone = response['user']["phone"].toString();
      String userUserAvatar = response['user']["avatar"].toString();
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
      final accessToken1 = response["access_token"].toString();
      await setAccessToken(accessToken1);
      await setPreference(isLoggedIn, "true");
      notifyListeners();
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLoggedIn);
    prefs.remove(user);
    prefs.remove(accessToken);
    notifyListeners();
  }

  Future<void> updateUserName(String name) async {
    final url = EndpointUrl.UPDATE_USER_NAME;
    final postRequest = json.encode({
      "name": name.trim(),
      "user_id": _userId,
    });
    try {
      final response = await PostToServer.post(postRequest, url);
      String userFirstName = response["first_name"]..toString();
      String userLastName = response["last_name"]..toString();
      _firstName = userFirstName;
      _lastName = userLastName;
      await updateUserDetails(firstName, userFirstName);
      await updateUserDetails(lastName, userLastName);
      notifyListeners();
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> updatePhoneNumber(String name) async {
    final url = EndpointUrl.UPDATE_USER_NAME;
    final postRequest = json.encode({
      "name": name.trim(),
      "user_id": _userId,
    });
    try {
      final response = await PostToServer.post(postRequest, url);
      String userFirstName = response["first_name"]..toString();
      String userLastName = response["last_name"]..toString();
      _firstName = userFirstName;
      _lastName = userLastName;
      await updateUserDetails(firstName, userFirstName);
      await updateUserDetails(lastName, userLastName);
      notifyListeners();
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> updateUserEmailAddress(String emailAddress) async {
    final url = EndpointUrl.UPDATE_USER_EMAIL_ADDRESS;
    final postRequest = json.encode({
      "email": emailAddress.trim(),
      "user_id": _userId,
    });
    try {
      await PostToServer.post(postRequest, url);
      _emailAddress = emailAddress;
      await updateUserDetails(email, emailAddress);
      notifyListeners();
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> updateUserAvatar(io.File avatar) async {
    final url = EndpointUrl.EDIT_NEW_USER_PHOTO;
    try {
      final resizedImage = await CustomHelper.resizeFileImage(avatar, 300);
      print("resizedImage : $resizedImage");
      try {
        final newAvatar = base64Encode(resizedImage.readAsBytesSync());
        final postRequest = json.encode({
          "avatar": newAvatar,
          "user_id": _userId,
        });
        final response = await PostToServer.post(postRequest, url);
        try {
          final newUserAvatar = response["avatar"];
          _avatar = newUserAvatar;
          await updateUserDetails(userAvatar, newUserAvatar);
          notifyListeners();
        } catch (error) {
          throw CustomException(message: ERROR_MESSAGE);
        }
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }
}
