import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/custom-scroll-behaviour.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'add_member_dialog.dart';

class AddMembersManually extends StatefulWidget {
  static const namedRoute = "add-members-manually";

  @override
  _AddMembersManuallyState createState() => _AddMembersManuallyState();
}

class _AddMembersManuallyState extends State<AddMembersManually> {
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

      String email = customContact.simpleContact.email;
      String phone = customContact.simpleContact.phoneNumber;

      String firstName = customContact.simpleContact.firstName;
      String lastName = customContact.simpleContact.lastName;

      String roleId = customContact.role.roleId;

      map["first_name"] = firstName;
      map["last_name"] = lastName;
      map["email"] = email;
      map["phone"] = phone.replaceAll(" ", "");
      map["group_role_id"] = roleId;

      members.add(map);
    }

    try {
      await Provider.of<Groups>(context, listen: false)
          .addGroupMembers(members);
      Navigator.of(context).pop();

      alertDialogWithAction(
          context, "You have successfully added members to your group", () {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      });
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
      await Provider.of<Groups>(context, listen: false)
          .fetchUnAssignedGroupRoles();
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
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                          color: Theme.of(context).dividerColor,
                        ),
                        itemBuilder: (context, index) {
                          GroupRoles groupRole = tempRoles[index];
                          return CupertinoDialogAction(
                            child: customTitleWithWrap(
                                text: groupRole.roleName,
                                textAlign: TextAlign.center,
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor),
                            onPressed: () {
                              print(groupRole.roleName + " tapped");
                              setState(() {
                                _updateRoleStatus(
                                    selectedContacts[position].role, groupRole);
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
              title: heading2(
                  text: "Set Role",
                  textAlign: TextAlign.center,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    _rolesStatusAndCurrentMemberStatus =
        Provider.of<Groups>(context).getGroupRolesAndCurrentMemberStatus;
    roles = Provider.of<Groups>(context).getCurrentGroup().groupRoles;

    if (_rolesStatusAndCurrentMemberStatus != null) {
      roleStatus = _rolesStatusAndCurrentMemberStatus.roleStatus;
      if (!addedCurrentUser) {
        if (_rolesStatusAndCurrentMemberStatus.currentMemberStatus == 0) {
          addedCurrentUser = true;
          List<Item> item = [];
          item.add(Item(value: auth.userIdentity));
          SimpleContact simpleContact = SimpleContact(
              name: auth.userName,
              firstName: auth.firstNameOnly,
              lastName: auth.lastNameOnly,
              phoneNumber: auth.phoneNumber,
              email: auth.emailAddress);
          CustomContact customContact = CustomContact.simpleContact(
              simpleContact: simpleContact, role: memberRole);
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
          title: "Add Members Manually",
          action: () {
            Navigator.of(context).pop();
          },
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.arrow_left,
          trailingIcon: LineAwesomeIcons.check,
          trailingAction: selectedContacts.length > 0
              ? () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  await _submitMembers(context);
                }
              : null),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(top: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () async {
                      //addMember(context);
                      CustomContact contact = await Navigator.of(context).push(
                          new MaterialPageRoute<CustomContact>(
                              builder: (BuildContext context) {
                        return AddMemberDialog();
                      }));

                      if (contact != null) {
                        setState(() {
                          selectedContacts.add(contact);
                        });
                      } else {
                        print("Contact is null");
                      }
                    },
                    padding: EdgeInsets.only(left: 4, right: 4),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).hintColor,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          LineAwesomeIcons.plus,
                          color: Theme.of(context).hintColor,
                          size: 16,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        customTitle(
                            text: "ADD MEMBER",
                            fontSize: 12,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: selectedContacts.length > 0
                    ? ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              color: Theme.of(context).dividerColor,
                            ),
                        itemCount: selectedContacts.length,
                        itemBuilder: (BuildContext context, int index) {
                          CustomContact customContact = selectedContacts[index];
                          String displayName = customContact.simpleContact.name;
                          return Container(
                            padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor:
                                      primaryColor, // Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                  child: Text(displayName[0].toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        subtitle1(
                                            text: displayName,
                                            textAlign: TextAlign.start),
                                        subtitle1(
                                            text: customContact
                                                .simpleContact.phoneNumber,
                                            textAlign: TextAlign.start)
                                      ],
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        smallBadgeButton(
                                          backgroundColor:
                                              Colors.blueGrey.withOpacity(0.2),
                                          textColor: Colors.blueGrey,
                                          text: customContact.role.roleName,
                                          action: () =>
                                              _showGroupRoles(context, index),
                                          buttonHeight: 24.0,
                                          textSize: 12.0,
                                        ),
                                        SizedBox(width: 10.0),
                                        Visibility(
                                          visible:
                                              !(addedCurrentUser && index == 0),
                                          child: screenActionButton(
                                            icon: LineAwesomeIcons.times,
                                            backgroundColor:
                                                Colors.red.withOpacity(0.1),
                                            textColor: Colors.red,
                                            action: () {
                                              setState(() {
                                                _updateRoleStatus(
                                                    selectedContacts[index]
                                                        .role,
                                                    memberRole);
                                                selectedContacts
                                                    .removeAt(index);
                                              });
                                            },
                                            buttonSize: 30.0,
                                            iconSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: customTitleWithWrap(
                              text:
                                  "Start adding members by clicking on the button above", // ignore: deprecated_member_use
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context).textSelectionHandleColor),
                        ),
                      )),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
