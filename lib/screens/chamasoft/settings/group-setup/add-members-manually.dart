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
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();

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

      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
            content: heading2(
                text: "You have successfully added members to your group",
                textAlign: TextAlign.center,
                color: Theme.of(context).textSelectionHandleColor),
            actions: <Widget>[
              CupertinoDialogAction(
                child: subtitle1(text: "Okay", color: primaryColor),
                onPressed: () {
                  Navigator.of(context).pop();
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
              )
            ]),
      );
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

  void addMember(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    String firstName = "";
    String lastName = "";
    String phoneNumber = "";
    String email = "";
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
              title: heading2(textAlign: TextAlign.start, text: "Add Member", color: Theme.of(context).textSelectionHandleColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  //var height = MediaQuery.of(context).size.height;
                  return SingleChildScrollView(
                    child: Container(
                      width: width * 3 / 4,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2.0)),
                                  labelText: "First Name",
                                  labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                              onChanged: (value) {
                                firstName = value;
                              },
                              validator: (value) {
                                if (value.trim() == '' || value.trim() == null) {
                                  return 'Enter a valid first name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2.0)),
                                  labelText: "Last Name",
                                  labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                              onChanged: (value) {
                                firstName = value;
                              },
                              validator: (value) {
                                if (value.trim() == '' || value.trim() == null) {
                                  return 'Enter a valid last name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2.0)),
                                  labelText: "Phone Number",
                                  labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2.0)),
                                  labelText: "Email Address",
                                  labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              actions: <Widget>[
                negativeActionDialogButton(
                    text: "Cancel",
                    color: Theme.of(context).textSelectionHandleColor,
                    action: () {
                      Navigator.of(context).pop();
                    }),
                positiveActionDialogButton(
                    text: "Add",
                    color: primaryColor,
                    action: () {
                      if (_formKey.currentState.validate()) {
                        print("Valid stuff");
                      } else {
                        print("You shall not pass");
                      }
                    }),
                SizedBox(
                  width: 10,
                ),
              ],
            ));
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    roles = Provider.of<Groups>(context).getCurrentGroup().groupRoles;
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
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
                  child: FlatButton(
                    onPressed: () {
                      //addMember(context);
                      Navigator.of(context).push(new MaterialPageRoute<Null>(builder: (BuildContext context) {
                        return AddMemberDialog();
                      }));
                    },
                    padding: EdgeInsets.only(left: 4, right: 4),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Theme.of(context).hintColor, width: 1.0, style: BorderStyle.solid),
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
                        customTitle(text: "ADD MEMBER", fontSize: 12, color: Theme.of(context).textSelectionHandleColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Consumer<Groups>(builder: (context, data, child) {
                roleStatus = data.getGroupRolesAndCurrentMemberStatus.roleStatus;
//                if (!addedCurrentUser) {
//                  if (data.getGroupRolesAndCurrentMemberStatus.currentMemberStatus == 0) {
//                    addedCurrentUser = true;
//                    List<Item> item = [];
//                    item.add(Item(value: auth.userIdentity));
//                    CustomContact customContact = CustomContact(
//                        contact: Contact(displayName: auth.userName, givenName: auth.firstNameOnly, familyName: auth.lastNameOnly, phones: item),
//                        role: memberRole);
//                    selectedContacts.insert(0, customContact);
//                  }
//                }
                tempRoles = [];
                tempRoles.add(memberRole);
                _cleanRolesList();
                return selectedContacts.length > 0
                    ? ListView.separated(
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
                        })
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: customTitleWithWrap(
                              text: "Start adding members by clicking on the button above", color: Theme.of(context).textSelectionHandleColor),
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
