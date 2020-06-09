import 'dart:convert';

import 'package:chamasoft/providers/auth.dart';
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
  String currentGroupId = "";

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
        throw HttpException(error.toString());
      }
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      print("error ${error.toString()}");
      throw ("We could not complete your request at the moment. Try again later");
    }
  }

  setSelectedGroupId(String groupId) async{
    currentGroupId = groupId;
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


  Group getCurrentGroup(){
    Group group;
    bool groupFound = false;
    _items.forEach((element) {
      if(element.groupId == currentGroupId ){
        group =  element;
        groupFound = true;
      }
    });

    if(groupFound){
      return group;
    } else {
      return this._items[0];
    }

  }

}