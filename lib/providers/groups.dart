import 'dart:convert';

import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/post-to-server.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Group{
  final String groupId;
  final String groupName;
  final String groupSize;

  Group({
    @required this.groupId,
    @required this.groupName,
    @required this.groupSize,
  });
}

class Groups with ChangeNotifier{
  static const String selectedGroupId = "selectedGroupId";

  List<Group> _items = [];

  List<Group> get item{
    return [..._items];
  }

  void addGroups(List<dynamic> groupObject){
    final List<Group> loadedGroups = [];
    if (groupObject.length > 0) {
      for (var groupJSON in groupObject) {
        final newGroup = Group(
          groupId: groupJSON['id']..toString(), 
          groupName: groupJSON['name']..toString(), 
          groupSize: groupJSON['size']..toString()
        );
        loadedGroups.add(newGroup);
      }
      _items = loadedGroups;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetUserGroups()async{
    const url = CustomHelper.baseUrl + CustomHelper.getCheckinData;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
      });
      try{
        final response =  await PostToServer.post(postRequest, url);
        final userGroups =  response['user_groups'] as List<dynamic>;
        addGroups(userGroups);
      }catch(error){
        throw HttpException(error.toString(), ErrorStatusCode.statusNormal);
      }
    } on HttpException catch (error) {
      throw HttpException(error.toString(), error.status);
    } catch (error) {
      print("error ${error.toString()}");
      throw (ERROR_MESSAGE);
    }
  }

  setSelectedGroupId(String groupId) async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(selectedGroupId)){
      prefs.remove(selectedGroupId);
    }
    prefs.setString(selectedGroupId, groupId);
  }

  getCurrentGroupId() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedGroupId);
  }

}