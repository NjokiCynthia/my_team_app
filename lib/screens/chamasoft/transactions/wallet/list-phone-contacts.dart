import 'dart:async';
import 'dart:math';

import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:permission_handler/permission_handler.dart';

import 'amount-to-withdraw.dart';

class ListPhoneContacts extends StatefulWidget {
  final String reloadLabel = 'Reload!';
  final String fireLabel = 'Fire in the hole!';
  final Color floatingButtonColor = Colors.red;
  final IconData reloadIcon = Icons.refresh;
  final IconData fireIcon = Icons.filter_center_focus;

  @override
  _ListPhoneContactsState createState() => _ListPhoneContactsState(
        floatingButtonLabel: this.fireLabel,
        icon: this.fireIcon,
        floatingButtonColor: this.floatingButtonColor,
      );
}

class _ListPhoneContactsState extends State<ListPhoneContacts> {
  TextEditingController controller = new TextEditingController();
  StreamSubscription<Iterable<Contact>> contactSubscriber;
  String filter;
  int count = 0;

  final Permission _permission = Permission.contacts;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  List<CustomContact> _contacts = new List<CustomContact>();
  List<CustomContact> _selectedContacts = List<CustomContact>();
  bool _isLoading = false;
  String floatingButtonLabel;
  Color floatingButtonColor;
  IconData icon;
  String selectedContactPhoneNumber = "";

  _ListPhoneContactsState({
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

  void _numberPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
              text: "Set Recipient Contact",
              color: Theme.of(context).textSelectionHandleColor,
              textAlign: TextAlign.start),
          content: TextFormField(
            //controller: controller,
            style: inputTextStyle(),
            initialValue: selectedContactPhoneNumber,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              hasFloatingPlaceholder: true,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
              )),
              // hintText: 'Phone Number or Email Address',
              labelText: "Enter Phone Number",
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                    fontFamily: 'SegoeUI'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Continue",
                style:
                    new TextStyle(color: primaryColor, fontFamily: 'SegoeUI'),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AmountToWithdraw()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
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
    contactSubscriber.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tertiaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.close,
          title: "Select Recipient",
          trailingIcon: LineAwesomeIcons.check,
          trailingAction: () {
            if (_selectedContacts.length > 0) {
              String phone =
                  _selectedContacts[0].contact.phones.elementAt(0).value;
              setState(() {
                selectedContactPhoneNumber = phone;
              });
              _numberPrompt();
            }
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
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
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
              Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: Text(contact.displayName[0].toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 24))),
      value: _selectedContacts.contains(_contacts[index]),
      onChanged: (value) {
        setState(() {
          if (value) {
            _selectedContacts.clear();
            _selectedContacts.add(_contacts[index]);
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
    var contacts = await ContactsService.getContacts();
    return contacts;
  }

  void _populateContacts(Iterable<Contact> contacts) {
    for (Contact contact in contacts) {
      if (contact.phones.length > 0) {
        _contacts.add(CustomContact(contact: contact));
      }
    }

    setState(() {
      _contacts.sort(
          (a, b) => a.contact.displayName.compareTo(b.contact.displayName));
      _isLoading = false;
    });
  }
}
