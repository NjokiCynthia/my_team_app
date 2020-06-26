import 'dart:io';

import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  static const String namedRoute = '/signup-screen';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File avatar;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  bool _isFormInputEnabled = true;
  final _lastNameFocusNode = FocusNode();
  String _firstName, _lastName;
  String _identity, _uniqueCode;
  Map<String, dynamic> _authData = {
    'identity': '',
    'avatar': '',
    'firstName': '',
    'lastName': '',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
      _isFormInputEnabled = false;
    });
    try {
      _authData['firstName'] = _firstName;
      _authData['lastName'] = _lastName;
      _authData['identity'] = _identity;
      _authData['avatar'] = avatar;
      _authData['uniqueCode'] = _uniqueCode;
      await Provider.of<Auth>(context, listen: false).registerUser(_authData);
      Navigator.of(context).pushNamedAndRemoveUntil(MyGroups.namedRoute, ModalRoute.withName('/'), arguments: 0);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _submit(context);
          });
    } finally {
      setState(() {
        _isLoading = false;
        _isFormInputEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final modalRoute = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (modalRoute.length > 0) {
      _identity = modalRoute['identity'];
      _uniqueCode = modalRoute['uniqueCode'];
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: primaryGradient(context),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heading1(text: "Profile", color: Theme.of(context).textSelectionHandleColor),
                    subtitle1(text: "Fill details to complete\naccount setup", color: Theme.of(context).textSelectionHandleColor),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: avatar == null ? AssetImage('assets/no-user.png') : FileImage(avatar),
                            backgroundColor: Colors.transparent,
                            radius: 50,
                          ),
                          Positioned(
                            bottom: -12.0,
                            right: -12.0,
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                File newAvatar = await FilePicker.getFile(type: FileType.image);
                                setState(() {
                                  avatar = newAvatar;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      enabled: _isFormInputEnabled,
                      decoration: InputDecoration(
                        hasFloatingPlaceholder: true,
                        labelText: "First Name",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value.trim() == '' || value.trim() == null) {
                          return 'Enter a valid last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _firstName = value;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_lastNameFocusNode);
                      },
                    ),
                    TextFormField(
                      enabled: _isFormInputEnabled,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hasFloatingPlaceholder: true,
                        labelText: "Last Name",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onSaved: (value) {
                        _lastName = value;
                      },
                      validator: (value) {
                        if (value.trim() == '' || value.trim() == null) {
                          return 'Enter a valid last name';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      focusNode: _lastNameFocusNode,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    _isLoading ? CircularProgressIndicator() : defaultButton(context: context, text: "Finish", onPressed: () => _submit(context))
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: screenActionButton(
              icon: LineAwesomeIcons.arrow_left,
              backgroundColor: primaryColor.withOpacity(0.2),
              textColor: primaryColor,
              action: () => Navigator.of(context).pop(),
            ),
          )
        ],
      ),
    );
  }
}
