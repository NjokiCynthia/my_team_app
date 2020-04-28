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
  List<CustomContact> _uiCustomContacts = List<CustomContact>();
  List<CustomContact> _allContacts = List<CustomContact>();
  bool _isLoading = false;
  bool _isSelectedContactsView = false;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: 2.5,
        leadingIcon: LineAwesomeIcons.close,
        title: "Add Members",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: !_isLoading
          ? Container(
              child: ListView.builder(
                itemCount: _uiCustomContacts?.length,
                itemBuilder: (BuildContext context, int index) {
                  CustomContact _contact = _uiCustomContacts[index];
                  var _phonesList = _contact.contact.phones.toList();

                  return _buildListTile(
                      _contact,
                      _phonesList,
                      Colors.primaries[
                          Random().nextInt(Colors.primaries.length)]);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: floatingButtonColor,
        onPressed: _onSubmit,
        icon: Icon(icon),
        label: Text(floatingButtonLabel),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> requestPermission() async {
    final status = await Permission.contacts.request();

    setState(() {
      _permissionStatus = status;

      if (_permissionStatus.isGranted) {
        refreshContacts();
      }
    });
  }

  void _onSubmit() {
    setState(() {
      if (!_isSelectedContactsView) {
        _uiCustomContacts =
            _allContacts.where((contact) => contact.isChecked == true).toList();
        _isSelectedContactsView = true;
        _restateFloatingButton(
          widget.reloadLabel,
          Icons.refresh,
          Colors.green,
        );
      } else {
        _uiCustomContacts = _allContacts;
        _isSelectedContactsView = false;
        _restateFloatingButton(
          widget.fireLabel,
          Icons.filter_center_focus,
          Colors.red,
        );
      }
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

  void _restateFloatingButton(String label, IconData icon, Color color) {
    floatingButtonLabel = label;
    icon = icon;
    floatingButtonColor = color;
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
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    setState(() {
      _uiCustomContacts = _allContacts;
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
