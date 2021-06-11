import 'dart:async';

import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/settings/group-setup/set-member-roles.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectFromContacts extends StatefulWidget {
  @override
  _SelectFromContactsState createState() => _SelectFromContactsState();
}

class _SelectFromContactsState extends State<SelectFromContacts> {
  TextEditingController controller = new TextEditingController();
  StreamSubscription<Iterable<Contact>> contactSubscriber;
  String filter;
  int count = 0;

  final Permission _permission = Permission.contacts;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  // initially permissionstatus was undetermined
  // ignore: deprecated_member_use
  List<CustomContact> _contacts = new List<CustomContact>();
  // ignore: deprecated_member_use
  List<CustomContact> _selectedContacts = List<CustomContact>();
  bool _isLoading = false;
  String floatingButtonLabel;
  Color floatingButtonColor;
  IconData icon;

  _SelectFromContactsState({
    this.floatingButtonLabel,
    this.icon,
    this.floatingButtonColor,
  });

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() {
      _permissionStatus = status;
      if (_permissionStatus == PermissionStatus.granted) {
        contactSubscriber = refreshContacts().asStream().listen((contacts) {
          _populateContacts(contacts);
        });
      } else {
        requestPermission();
      }
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    _listenForPermissionStatus();

    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    contactSubscriber.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tertiaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: 0,
        leadingIcon: LineAwesomeIcons.close,
        title:
            "Select Members${_selectedContacts.length == 0 ? '' : ' (${_selectedContacts.length})'}",
        trailingIcon: LineAwesomeIcons.check,
        trailingAction: () async {
          if (_selectedContacts.length > 0) {
            final result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SetMemberRoles(
                      initialSelectedContacts: _selectedContacts.toList(),
                    )));
            if (result != null && result) {
              Navigator.of(context).pop(true);
            }
          }
        },
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: !_isLoading
          ? Container(
              child: Column(
                children: <Widget>[
                  Container(
                    color: (themeChangeProvider.darkTheme)
                        ? Colors.blueGrey[800]
                        : Color(0xffededfe),
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Search contact",
                          prefixIcon: Icon(LineAwesomeIcons.search),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: 15,
                            bottom: 11,
                            top: 11,
                            right: 15,
                          ),
                        ),
                        controller: controller,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _contacts?.length,
                      itemBuilder: (BuildContext context, int index) {
                        Contact _contact = _contacts[index].contact;
                        String displayName = _contact.displayName;
                        var _phonesList = _contact.phones.toList();

                        return filter == null || filter == ""
                            ? _buildListTile(index, _contact, _phonesList)
                            : displayName
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                ? _buildListTile(index, _contact, _phonesList)
                                : Visibility(
                                    visible: false, child: new Container());
                      },
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  subtitle1(
                    text: "Retrieving contact list",
                    color: Theme.of(context)
                        // ignore: deprecated_member_use
                        .textSelectionHandleColor,
                  ),
                  subtitle2(
                    text: "Please be patient",
                    color: Theme.of(context)
                        // ignore: deprecated_member_use
                        .textSelectionHandleColor,
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> requestPermission() async {
    final status = await Permission.contacts.request();

    setState(() {
      _permissionStatus = status;

      if (_permissionStatus.isGranted) {
        contactSubscriber = refreshContacts().asStream().listen((contacts) {
          _populateContacts(contacts);
        });
      } else {}
    });
  }

  CheckboxListTile _buildListTile(int index, Contact contact, List<Item> list) {
    return CheckboxListTile(
      secondary: CircleAvatar(
          backgroundColor:
              primaryColor, //Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: Text(contact.displayName[0].toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 24))),
      value: _selectedContacts.contains(_contacts[index]),
      onChanged: (value) {
        setState(() {
          if (value) {
            _selectedContacts.add(_contacts[index]);
          } else {
            _selectedContacts.remove(_contacts[index]);
          }
        });
      },
      title: subtitle1(
        text: contact.displayName ?? "",
        textAlign: TextAlign.start,
      ),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? subtitle1(
              text: list[0].value,
              textAlign: TextAlign.start,
            )
          : Text(''),
    );
  }

  Future<Iterable<Contact>> refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts(withThumbnails: false);
    return contacts;
  }

  void _populateContacts(Iterable<Contact> contacts) {
    final role = GroupRoles(roleName: "Member", roleId: "0");
    for (Contact contact in contacts) {
      if (contact.phones.length > 0) {
        _contacts.add(CustomContact(contact: contact, role: role));
      }
    }

    setState(() {
      _contacts.sort(
          (a, b) => a.contact.displayName.compareTo(b.contact.displayName));
      _isLoading = false;
    });
  }
}
