import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';

class AddMemberDialog extends StatefulWidget {
  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  GroupRoles memberRole = GroupRoles(roleId: "0", roleName: "Member");
  String _fullName, _firstName, _lastName;
  String _phoneNumber, _email;
  bool _isValid = true;
  FocusNode _focusNode;
  bool _focused = false;

  CountryCode _countryCode = CountryCode.fromCountryCode("KE");
  final _phoneController = TextEditingController();

  BorderSide _customInputBorderSide = BorderSide(
    color: Colors.blueGrey,
    width: 1.0,
  );

  void _submitMember() async {
    _formKey.currentState.save();

    bool value =
        await CustomHelper.validPhoneNumber(_phoneNumber, _countryCode);
    if (!value) {
      setState(() {
        _isValid = false;
      });
    } else {
      setState(() {
        _isValid = true;
      });
    }

    if (!_formKey.currentState.validate() || !_isValid) {
      return;
    }

    var names = _fullName.trim().split(new RegExp("\\s+"));
    if (names.length > 1) {
      _firstName = names[0];
      if (names.length > 2) {
        _lastName = names[1] + " " + names[2];
      } else {
        _lastName = names[1];
      }
    } else {
      _firstName = _fullName;
      _lastName = "";
    }

    List<Item> item = [];
    item.add(Item(value: _phoneNumber));
    CustomContact customContact = CustomContact.simpleContact(
        simpleContact: SimpleContact(
            name: _fullName,
            firstName: _firstName,
            lastName: _lastName,
            phoneNumber: _countryCode.dialCode + _phoneNumber,
            email: _email),
        role: memberRole);

    Navigator.of(context).pop(customContact);
  }

  void _handleFocusChange() {
    setState(() {
      _focused = _focusNode.hasFocus;
      if (!_focused) {
        _customInputBorderSide = BorderSide(
          color: (!_isValid) ? Colors.red : Colors.blueGrey,
          width: 1.0,
        );
      } else {
        _customInputBorderSide = BorderSide(
          color: (!_isValid) ? Colors.red : Colors.blue,
          width: 2.0,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _focusNode = new FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "Add Member",
          action: () => Navigator.of(context).pop(),
          elevation: 1.0,
          leadingIcon: LineAwesomeIcons.times,
          actions: []),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(40.0),
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
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor, width: 1.0)),
                    labelText: "Full Name",
                    labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                onChanged: (value) {
                  _fullName = value.trim();
                },
                validator: (value) {
                  if (value.trim() == '' || value.trim() == null) {
                    return 'Enter a valid name name';
                  } else {
                    var name = value.trim();
                    var names = name.split(new RegExp("\\s+"));
                    if (names.length < 2) {
                      print("Name: $name");
                      return "Enter at least two names";
                    }
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  customTitle(
                      text: "Phone Number",
                      textAlign: TextAlign.start,
                      fontSize: 11,
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionTheme.selectionHandleColor),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: _customInputBorderSide,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 34,
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                                child: CountryCodePicker(
                                  // key: _countryKey,
                                  initialSelection: 'KE',
                                  favorite: ['KE', 'UG', 'TZ', 'RW'],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                  flagWidth: 28.0,
                                  textStyle: TextStyle(
                                    fontFamily:
                                        'SegoeUI', /*fontSize: 16,color: Theme.of(context).textSelectionTheme.selectionHandleColor*/
                                  ),
                                  searchStyle: TextStyle(
                                      fontFamily: 'SegoeUI',
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionTheme.selectionHandleColor),
                                  onChanged: (countryCode) {
                                    setState(() {
                                      _countryCode = countryCode;
                                      print("Code: " + countryCode.dialCode);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              height: 34,
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: '',
                                ),
                                focusNode: _focusNode,
                                style: TextStyle(
                                    fontFamily: 'SegoeUI', fontSize: 16),
                                onSaved: (value) {
                                  _phoneNumber = value.trim();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: !_isValid,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.5),
                  child: customTitle(
                    text: 'Enter valid phone number',
                    color: Colors.red,
                    fontSize: 12.0,
                  ),
                ),
              ),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1.0)),
                      labelText: "Email Address",
                      labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                  onChanged: (value) {
                    _email = value;
                  }),
              SizedBox(
                height: 20,
              ),
              defaultButton(
                  context: context,
                  text: "Add Member",
                  onPressed: () => _submitMember())
            ],
          ),
        ),
      ),
    );
  }
}
