import 'dart:math';

import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/screens/chamasoft/models/member-role.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class SetMemberRoles extends StatefulWidget {
  final List<CustomContact> initialSelectedContacts;

  SetMemberRoles({this.initialSelectedContacts});

  @override
  _SetMemberRolesState createState() => _SetMemberRolesState();
}

class _SetMemberRolesState extends State<SetMemberRoles> {
  List<MemberRole> roles = [
    MemberRole(id: 1, name: "Chairman"),
    MemberRole(id: 2, name: "Treasurer"),
    MemberRole(id: 3, name: "Secretary"),
    MemberRole(id: 0, name: "Member"),
  ];

  List<CustomContact> selectedContacts = [];

  @override
  void initState() {
    selectedContacts = widget.initialSelectedContacts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "Set Group Roles",
          action: () => Navigator.pop(context, selectedContacts),
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.arrow_left),
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
                      backgroundColor: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      child: Text(displayName[0].toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 24)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          subtitle1(
                              text: displayName ?? "",
                              textAlign: TextAlign.start),
                          phoneList.length >= 1 && phoneList[0]?.value != null
                              ? subtitle1(
                                  text: phoneList[0].value,
                                  textAlign: TextAlign.start)
                              : Text(''),
                        ],
                      ),
                    ),
                    DropdownButton(
                      hint: Text("Set Role"),
                      value: roles.indexOf(customContact.role) != -1
                          ? roles[roles.indexOf(customContact.role)]
                          : null,
                      onChanged: (MemberRole role) {
                        setState(() {
                          customContact.role = role;
                        });
                      },
                      items: roles.map((MemberRole role) {
                        return DropdownMenuItem<MemberRole>(
                          value: role,
                          child: Text(
                            role.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
