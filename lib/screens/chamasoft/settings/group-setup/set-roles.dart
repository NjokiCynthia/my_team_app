import 'dart:math';

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/utilities/custom-scroll-behaviour.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class SetMemberRoles extends StatefulWidget {
  final List<CustomContact> initialSelectedContacts;

  SetMemberRoles({this.initialSelectedContacts});

  @override
  _SetMemberRolesState createState() => _SetMemberRolesState();
}

class _SetMemberRolesState extends State<SetMemberRoles> {
  List<GroupRoles> roles = [];
  List<GroupRoles> tempRoles = [];
  GroupRoles memberRole = GroupRoles(roleId: "0", roleName: "Member");
  List<CustomContact> selectedContacts = [];
  Map<String, int> roleStatus = {};
  GlobalKey _dropdownButtonKey;

  void _updateRoleStatus(GroupRoles currentRole, GroupRoles newRole) {
    if ("0" == currentRole.roleId && "0" != newRole.roleId) {
      roleStatus[newRole.roleName] = 0;

      tempRoles.clear();
      tempRoles.add(memberRole);
      _cleanRolesList();
    } else if ("0" != currentRole.roleId && "0" == newRole.roleId) {
      roleStatus[currentRole.roleName] = 1;

      tempRoles.clear();
      tempRoles.add(memberRole);
      _cleanRolesList();
    } else if ("0" != currentRole.roleId && "0" != newRole.roleId) {
      roleStatus[currentRole.roleName] = 1;
      roleStatus[newRole.roleName] = 0;

      tempRoles.clear();
      tempRoles.add(memberRole);
      _cleanRolesList();
    }
  }

  void _cleanRolesList() {
    roleStatus.forEach((key, value) {
      print("Key: $key, Value: $value");
      if (value == 1) {
        roles.forEach((element) {
          if (key == element.roleName) {
            tempRoles.add(element);
            print("Added: " + element.roleName);
          }
        });
      }
    });
  }

  void _showGroupRoles(BuildContext context, int position) {
    for (GroupRoles role in tempRoles) {
      print("Temp role: " + role.roleName);
    }
    showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 300,
                    child: ScrollConfiguration(
                      behavior: CustomScrollBehavior(),
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) => Divider(
                          color: Theme.of(context).dividerColor,
                        ),
                        itemBuilder: (context, index) {
                          GroupRoles groupRole = tempRoles[index];
                          return CupertinoDialogAction(
                            child: customTitleWithWrap(
                                text: groupRole.roleName, textAlign: TextAlign.center, color: Theme.of(context).textSelectionHandleColor),
                            onPressed: () {
                              print(groupRole.roleName + " tapped");
                              setState(() {
                                _updateRoleStatus(selectedContacts[position].role, groupRole);
                                selectedContacts[position].role = groupRole;
                              });
                              Navigator.of(ctx).pop();
                            },
                          );
                        },
                        itemCount: tempRoles.length,
                      ),
                    ),
                  ),
                ],
              ),
              title: heading2(text: "Set Role", textAlign: TextAlign.center, color: Theme.of(context).textSelectionHandleColor),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: subtitle1(text: "Close", color: primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  @override
  void initState() {
    selectedContacts = widget.initialSelectedContacts;
    final role = GroupRoles(roleName: "Member", roleId: "0");
    for (CustomContact customContact in selectedContacts) {
      customContact.role = role;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    roles = Provider.of<Groups>(context).getCurrentGroup().groupRoles;

    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "Set Group Roles",
          action: () {
            Navigator.of(context).pop();
          },
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(top: 8.0),
        child: Consumer<Groups>(builder: (context, data, child) {
          roleStatus = data.getGroupRolesAndCurrentMemberStatus.roleStatus;
          tempRoles = [];
          tempRoles.add(memberRole);
          _cleanRolesList();
          return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(
                    color: Theme.of(context).dividerColor,
                  ),
              itemCount: selectedContacts.length,
              itemBuilder: (BuildContext context, int index) {
                CustomContact customContact = selectedContacts[index];
                String displayName = customContact.contact.displayName;
                var phoneList = customContact.contact.phones.toList();
                return Container(
                  padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                        child: Text(displayName[0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 24)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            subtitle1(text: displayName ?? "", textAlign: TextAlign.start),
                            phoneList.length >= 1 && phoneList[0]?.value != null
                                ? subtitle1(text: phoneList[0].value, textAlign: TextAlign.start)
                                : Text(''),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: smallBadgeButton(
                          backgroundColor: Colors.blueGrey.withOpacity(0.2),
                          textColor: Colors.blueGrey,
                          text: customContact.role.roleName,
                          // == null ? "Member" : customContact.role.roleName,
                          action: () => _showGroupRoles(context, index),
                          buttonHeight: 24.0,
                          textSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                );
              });
        }),
      ),
    );
  }
}
