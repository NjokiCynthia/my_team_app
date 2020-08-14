import 'dart:math';

import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/custom-scroll-behaviour.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:contacts_service/contacts_service.dart';
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
  bool addedCurrentUser = false;
  bool _isInit = true;
  GroupRolesStatusAndCurrentMemberStatus _rolesStatusAndCurrentMemberStatus;

  Future<void> _submitMembers(BuildContext context) async {
    List<Map<String, String>> members = [];
    for (CustomContact customContact in selectedContacts) {
      Map<String, String> map = {};
      var phoneList = customContact.contact.phones.toList();

      String email = "";
      String phone = phoneList[0].value;
      if (phone.contains("@")) {
        email = phone;
        phone = "";
      }

      String firstName = customContact.contact.givenName;
      String lastName = customContact.contact.familyName;

      String roleId = customContact.role.roleId;

      map["first_name"] = firstName;
      map["last_name"] = lastName;
      map["email"] = email;
      map["phone"] = phone.replaceAll(" ", "");
      map["group_role_id"] = roleId;

      members.add(map);
    }

    try {
      await Provider.of<Groups>(context, listen: false).addGroupMembers(members);
      Navigator.of(context).pop();

      alertDialogWithAction(context, "You have successfully added members to your group", () {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      }, false);
    } on CustomException catch (error) {
      Navigator.of(context).pop();
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _submitMembers(context);
          });
    }
  }

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
      if (value == 1) {
        roles.forEach((element) {
          if (key == element.roleName) {
            tempRoles.add(element);
          }
        });
      }
    });
  }

  void _showGroupRoles(BuildContext context, int position) {
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

  Future<void> _getUnAssignedGroupRoles(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });

    try {
      await Provider.of<Groups>(context, listen: false).fetchUnAssignedGroupRoles();
      setState(() {
        _isInit = false;
      });
      Navigator.of(context, rootNavigator: true).pop();
    } on CustomException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getUnAssignedGroupRoles(context);
          });
    }
  }

  @override
  void initState() {
    selectedContacts = widget.initialSelectedContacts;
    for (CustomContact contact in selectedContacts) {
      contact.role = memberRole;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    _rolesStatusAndCurrentMemberStatus = Provider.of<Groups>(context).getGroupRolesAndCurrentMemberStatus;
    roles = Provider.of<Groups>(context).getCurrentGroup().groupRoles;

    if (_rolesStatusAndCurrentMemberStatus != null) {
      roleStatus = _rolesStatusAndCurrentMemberStatus.roleStatus;
      if (!addedCurrentUser) {
        if (_rolesStatusAndCurrentMemberStatus.currentMemberStatus == 0) {
          addedCurrentUser = true;
          List<Item> item = [];
          item.add(Item(value: auth.userIdentity));
          CustomContact customContact = CustomContact(
              contact: Contact(displayName: auth.userName, givenName: auth.firstNameOnly, familyName: auth.lastNameOnly, phones: item),
              role: memberRole);
          selectedContacts.insert(0, customContact);
        }
      }
      tempRoles = [];
      tempRoles.add(memberRole);
      _cleanRolesList();
    } else {
      if (_isInit) {
        _getUnAssignedGroupRoles(context);
      }
    }

    return Scaffold(
      appBar: tertiaryPageAppbar(
          context: context,
          title: "Set Group Roles",
          action: () {
            Navigator.of(context).pop();
          },
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.arrow_left,
          trailingIcon: LineAwesomeIcons.check,
          trailingAction: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
            await _submitMembers(context);
          }),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(top: 8.0),
        child: ListView.separated(
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
            }),
      ),
    );
  }
}
