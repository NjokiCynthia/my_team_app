import 'package:flutter/foundation.dart';

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

  List<Group> _groups = [];

  List<Group> get group{
    return [..._groups];
  }

  void addGroups(List<Group> groupObject){
    
  }

}