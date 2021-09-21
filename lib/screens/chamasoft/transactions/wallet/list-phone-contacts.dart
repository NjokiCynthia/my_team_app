import 'dart:async';
import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:permission_handler/permission_handler.dart';

import 'amount-to-withdraw.dart';

class ListPhoneContacts extends StatefulWidget {
  final Map<String, String> formData;

  ListPhoneContacts({this.formData});

  @override
  _ListPhoneContactsState createState() => _ListPhoneContactsState();
}

class _ListPhoneContactsState extends State<ListPhoneContacts> {
  TextEditingController _controller = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  StreamSubscription<Iterable<Contact>> contactSubscriber;
  String filter;
  int count = 0;

  final Permission _permission = Permission.contacts;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  // undetermined
  // ignore: deprecated_member_use
  List<CustomContact> _contacts = new List<CustomContact>();
  bool _isLoading = false;
  String floatingButtonLabel;
  Color floatingButtonColor;
  IconData icon;
  Contact selectedContact;

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

  void _proceedToAmountPage(int flag) async {
    if (flag == 1) {
      var _phonesList = selectedContact.phones.toList();
      if (_phonesList.length >= 1 && _phonesList[0]?.value != null) {
        widget.formData["phone"] = _phonesList[0]
            .value
            .replaceAll(" ", "")
            .replaceAll("+", "")
            .replaceAll("-", "");
      } else
        return;
    } else {
      widget.formData["phone"] = _phoneController.text;
    }

    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            AmountToWithdraw(formData: widget.formData)));
    if (result != null) {
      print(result.toString());
      final id = int.tryParse(result) ?? 0;
      if (id != 0) {
        Navigator.of(context).pop(result);
      }
    } else {
      print("Empty result");
    }
  }

  void _numberPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
              text: "Set Recipient Contact",
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionHandleColor,
              textAlign: TextAlign.start),
          content: TextFormField(
            controller: _phoneController,
            style: inputTextStyle(),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              // ignore: deprecated_member_use
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
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
            negativeActionDialogButton(
                text: "Cancel",
                // ignore: deprecated_member_use
                color: Theme.of(context).textSelectionHandleColor,
                action: () {
                  Navigator.of(context).pop();
                }),
            positiveActionDialogButton(
                text: "Continue",
                color: primaryColor,
                action: () {
                  print("Phone: ${_phoneController.text}");
                  if (CustomHelper.validPhone(_phoneController.text)) {
                    Navigator.of(context).pop();
                    _proceedToAmountPage(2);
                  }
                })
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();

    _controller.addListener(() {
      setState(() {
        filter = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _phoneController.dispose();
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
          trailingIcon: LineAwesomeIcons.user_plus,
          trailingAction: () => _numberPrompt()),
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
                    controller: _controller,
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

  ListTile _buildListTile(int index, Contact contact, List<Item> list) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor:
              primaryColor, //Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: Text(contact.displayName[0].toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 24))),
      onTap: () {
        selectedContact = contact;
        _proceedToAmountPage(1);
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
