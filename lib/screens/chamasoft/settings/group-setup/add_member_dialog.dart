import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class AddMemberDialog extends StatefulWidget {
  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  GroupRoles memberRole = GroupRoles(roleId: "0", roleName: "Member");
  String _firstName, _lastName;
  String _phoneNumber, _email;
  bool _isValid = true;
  FocusNode _focusNode;
  bool _focused = false;

  CountryCode _countryCode = CountryCode.fromCode("KE");
  final _phoneController = TextEditingController();

  BorderSide _customInputBorderSide = BorderSide(
    color: Colors.blueGrey,
    width: 1.0,
  );

  void _submitMember() async {
    _formKey.currentState.save();

    bool value = await CustomHelper.validPhoneNumber(_phoneNumber, _countryCode);
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

    List<Item> item = [];
    item.add(Item(value: _phoneNumber));
    CustomContact customContact = CustomContact.simpleContact(
        simpleContact: SimpleContact(
            name: _firstName + " " + _lastName,
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
    // TODO: implement initState
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
          leadingIcon: LineAwesomeIcons.close,
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
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                    labelText: "First Name",
                    labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                onChanged: (value) {
                  _firstName = value;
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
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                    labelText: "Last Name",
                    labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                onChanged: (value) {
                  _lastName = value;
                },
                validator: (value) {
                  if (value.trim() == '' || value.trim() == null) {
                    return 'Enter a valid last name';
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
                  customTitle(text: "Phone Number", textAlign: TextAlign.start, fontSize: 11, color: Theme.of(context).textSelectionHandleColor),
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
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                                child: CountryCodePicker(
                                  // key: _countryKey,
                                  initialSelection: 'KE',
                                  favorite: ['KE', 'UG', 'TZ', 'RW'],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                  flagWidth: 28.0,
                                  textStyle: TextStyle(
                                    fontFamily: 'SegoeUI', /*fontSize: 16,color: Theme.of(context).textSelectionHandleColor*/
                                  ),
                                  searchStyle: TextStyle(fontFamily: 'SegoeUI', fontSize: 16, color: Theme.of(context).textSelectionHandleColor),
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
                                style: TextStyle(fontFamily: 'SegoeUI', fontSize: 16),
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
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                    labelText: "Email Address",
                    labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                onChanged: (value) {
                  _email = value;
                },
                validator: (value) {
                  if (!CustomHelper.validEmail(value)) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              defaultButton(context: context, text: "Add Member", onPressed: () => _submitMember())
            ],
          ),
        ),
      ),
    );
  }
}
