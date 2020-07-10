import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class AddMemberDialog extends StatefulWidget {
  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  List<GroupRoles> roles = [];
  List<GroupRoles> tempRoles = [];
  GroupRoles memberRole = GroupRoles(roleId: "0", roleName: "Member");
  String _firstName, _lastName;
  String _phoneNumber, _email;

  CountryCode _countryCode = CountryCode.fromCode("KE");
  final _countryCodeController = TextEditingController(text: "+254");
  final _phoneController = TextEditingController();

  BorderSide _customInputBorderSide = BorderSide(
    color: Colors.blueGrey,
    width: 1.0,
  );

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
              SizedBox(
                height: 10,
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
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                    labelText: "Phone Number",
                    labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                onChanged: (value) {
                  _phoneNumber = value;
                },
                validator: (value) {},
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 8.0),
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: _customInputBorderSide,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CountryCodePicker(
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
                                    _countryCodeController.text = countryCode.dialCode;
                                    print("Code: " + countryCode.dialCode);
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Phone Number',
                              ),
                              //focusNode: _focusNode,
                              style: TextStyle(fontFamily: 'SegoeUI'),
                              onSaved: (value) {
                                _phoneNumber = value.trim();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
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
              defaultButton(context: context, text: "Add Member", onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
