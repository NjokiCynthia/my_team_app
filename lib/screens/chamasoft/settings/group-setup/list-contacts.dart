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

  final Permission _permission = Permission.contacts;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  List<Contact> _contacts = new List<Contact>();
  List<CustomContact> _selectedContacts = List<CustomContact>();
  List<CustomContact> _allContacts = List<CustomContact>();
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
          title: "Add Members",
          trailingIcon: LineAwesomeIcons.check,
          trailingAction: () {
            _selectedContacts = _allContacts
                .where((contact) => contact.isChecked == true)
                .toList();

            _selectedContacts
                .forEach((contact) => print(contact.contact.displayName));
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
                      itemCount: _allContacts?.length,
                      itemBuilder: (BuildContext context, int index) {
                        CustomContact _contact = _allContacts[index];
                        String displayName = _contact.contact.displayName;
                        var _phonesList = _contact.contact.phones.toList();

                        return filter == null || filter == ""
                            ? _buildListTile(
                                _contact,
                                _phonesList,
                                Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)])
                            : displayName
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                ? _buildListTile(
                                    _contact,
                                    _phonesList,
                                    Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)])
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

  ListTile _buildListTile(CustomContact c, List<Item> list, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(c.contact.displayName[0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      title: Text(c.contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
      trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            setState(() {
              c.isChecked = value;
            });
          }),
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
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    setState(() {
      _allContacts =
          _contacts.map((contact) => CustomContact(contact: contact)).toList();
      _isLoading = false;
    });
  }
}

class CustomContact {
  final Contact contact;
  bool isChecked;

  CustomContact({
    this.contact,
    this.isChecked = false,
  });
}
