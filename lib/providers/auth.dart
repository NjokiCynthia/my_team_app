import 'dart:convert';

import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:flutter/material.dart';

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
  String _userId;
  String _firstName;
  String _lastName;
  String _accessToken;
  String _phone;
  String _avatarName;
  String _email;

  List<GroupModel> _groups = [];

  List get groups {
    return _groups;
  }

  String get userName {
    return _firstName + " " + _lastName;
  }

  String get phoneNumber {
    return _phone;
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

  Future<int> verifyPin(Map<String, String> object) async {
    const url = CustomHelper.baseUrl + CustomHelper.verifyPin;
    final postRequest = json.encode(object);
    try {
      final response = await PostToServer.post(postRequest, url);
      _userId = response['user']["id"]..toString();
      _firstName = response['user']["first_name"]..toString();
      _lastName = response['user']["last_name"]..toString();
      _accessToken = response['user']["access_token"]..toString();
      _email = response['user']["email"]..toString();
      _phone = response['user']["phone"]..toString();
      _avatarName = response['user']["avatar"]..toString();

      List<dynamic> groupsJSON = response['user_groups'];
      if (groupsJSON.length > 0) {
        for (var groupJSON in groupsJSON) {
          this._groups.add(GroupModel.fromJson(groupJSON));
        }
      }

      if (response['user_exists'] == 1) {
        return 1;
      } else {
        return 2;
      }
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      print(error);
      throw ("We could not complete your request at the moment. Try again later");
    }
  }
}
