// ignore_for_file: unused_element

import 'dart:async';

import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/settings/group-setup/set-member-roles.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class ListContacts extends StatefulWidget {
  static const namedRoute = "/list-contacts";
  @override
  _ListContactsState createState() => _ListContactsState();
}

class _ListContactsState extends State<ListContacts> {
  TextEditingController controller = new TextEditingController();
  StreamSubscription<Iterable<Contact>> contactSubscriber;
  String filter;
  int count = 0;

  final Permission _permission = Permission.contacts;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  // initially permissionstatus was undetermined
  // ignore: deprecated_member_use
  List<CustomContact> _contacts = [];
  // ignore: deprecated_member_use
  List<CustomContact> _selectedContacts = [];
  bool _isLoading = false;
  String floatingButtonLabel;
  Color floatingButtonColor;
  IconData icon;

  _ListContactsState({
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
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.times,
          title:
              "Add Members${_selectedContacts.length == 0 ? '' : '(${_selectedContacts.length})'}",
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
          }),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: !_isLoading
          ? Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Search Contact",
                      prefixIcon: Icon(LineAwesomeIcons.search),
                    ),
                    controller: controller,
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
                  subtitle1(text: "Retrieving contact list")
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
          text: contact.displayName ?? "", textAlign: TextAlign.start),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? subtitle1(text: list[0].value, textAlign: TextAlign.start)
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
