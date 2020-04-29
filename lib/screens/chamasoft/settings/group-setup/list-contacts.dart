import 'dart:math';

import 'package:chamasoft/widgets/appbars.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class ListContacts extends StatefulWidget {
  final String reloadLabel = 'Reload!';
  final String fireLabel = 'Fire in the hole!';
  final Color floatingButtonColor = Colors.red;
  final IconData reloadIcon = Icons.refresh;
  final IconData fireIcon = Icons.filter_center_focus;

  @override
  _ListContactsState createState() => _ListContactsState(
        floatingButtonLabel: this.fireLabel,
        icon: this.fireIcon,
        floatingButtonColor: this.floatingButtonColor,
      );
}

class _ListContactsState extends State<ListContacts> {
  TextEditingController controller = new TextEditingController();
  String filter;
  int count = 0;

  final Permission _permission = Permission.contacts;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  List<Contact> _contacts = new List<Contact>();
  List<Contact> _selectedContacts = List<Contact>();
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
        refreshContacts();
      } else {
        requestPermission();
      }
    });
  }

  @override
  void initState() {
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
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tertiaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.close,
          title:
              "Add Members${_selectedContacts.length == 0 ? '' : '(${_selectedContacts.length})'}",
          trailingIcon: LineAwesomeIcons.check,
          trailingAction: () {
            _selectedContacts.forEach((contact) => print(contact.displayName));
          }),
      backgroundColor: Theme.of(context).backgroundColor,
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
                        Contact _contact = _contacts[index];
                        String displayName = _contact.displayName;
                        var _phonesList = _contact.phones.toList();

                        return filter == null || filter == ""
                            ? _buildListTile(index, _contact, _phonesList)
                            : displayName
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                ? _buildListTile(index, _contact, _phonesList)
                                : new Container();
                      },
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> requestPermission() async {
    final status = await Permission.contacts.request();

    setState(() {
      _permissionStatus = status;

      if (_permissionStatus.isGranted) {
        refreshContacts();
      } else {}
    });
  }

  CheckboxListTile _buildListTile(int index, Contact contact, List<Item> list) {
    return CheckboxListTile(
      secondary: CircleAvatar(
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
        child: Text(contact.displayName[0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
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
      title: Text(contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
    );
  }

  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    for (Contact contact in contacts) {
      if (contact.phones.length > 0) {
        _contacts.add(contact);
      }
    }

    setState(() {
      _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
      _isLoading = false;
    });
  }
}
