import 'dart:io';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/screens/login_password.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  static const namedRoute = "/registerScreen";
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _passwordController;
  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;

  @override
  void initState() {
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  PickedFile avatar;
  final ImagePicker _picker = ImagePicker();

  Future<void> retrieveLostData() async {
    final LostData lostData = await _picker.getLostData();
    if (lostData.isEmpty) return;

    if (lostData.file != null) {
      setState(() {
        avatar = lostData.file;
      });
    } else {}
  }

  void _onImagePickerClicked(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await _picker.getImage(
          source: source,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: IMAGE_QUALITY);
      setState(() {
        avatar = pickedFile;
      });
    } catch (e) {
      //show SnackBar?
      //setState(() {});
    }
  }

  Future<void> _submit(String identity) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    Navigator.of(context)
        .pushReplacementNamed(LoginPassword.namedRoute, arguments: identity);
  }

  @override
  Widget build(BuildContext context) {
    String _identity = ModalRoute.of(context).settings.arguments as String;
    Map<String, String> _authData = {
      'firstName': '',
      'lastName': '',
      'password': ''
    };
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Form(
            key: _formKey,
            child: Container(
              height: double.infinity,
              decoration: primaryGradient(context),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: MediaQuery.of(context).size.height * 0.1),
                child: Column(
                  children: [
                    // CircleAvatar(
                    //   backgroundImage: AssetImage('assets/no-user.png'),
                    //   backgroundColor: Colors.transparent,
                    //   radius: 47,
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: <Widget>[
                          !kIsWeb &&
                                  defaultTargetPlatform ==
                                      TargetPlatform.android
                              ? FutureBuilder<void>(
                                  future: retrieveLostData(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<void> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return CircleAvatar(
                                          backgroundImage:
                                              AssetImage('assets/no-user.png'),
                                          backgroundColor: Colors.transparent,
                                          radius: 50,
                                        );
                                      case ConnectionState.done:
                                        return CircleAvatar(
                                          backgroundImage: avatar == null
                                              ? AssetImage('assets/no-user.png')
                                              : FileImage(File(avatar.path)),
                                          backgroundColor: Colors.transparent,
                                          radius: 50,
                                        );
                                      default:
                                        return CircleAvatar(
                                          backgroundImage:
                                              AssetImage('assets/no-user.png'),
                                          backgroundColor: Colors.transparent,
                                          radius: 50,
                                        );
                                    }
                                  },
                                )
                              : CircleAvatar(
                                  backgroundImage: avatar == null
                                      ? AssetImage('assets/no-user.png')
                                      : FileImage(File(avatar.path)),
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
                                _onImagePickerClicked(
                                    ImageSource.gallery, context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    heading3(
                        text: _identity, color: Theme.of(context).primaryColor),
                    SizedBox(
                      height: 15,
                    ),
                    subtitle1(
                        text: "Fill details to complete account setup",
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'First Name',
                      ),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontFamily: 'SegoeUI'),
                      validator: (value) {
                        if (value.trim() == '' || value.trim() == null) {
                          return 'Enter a valid first name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['firstName'] = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Last Name',
                      ),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontFamily: 'SegoeUI'),
                      validator: (value) {
                        if (value.trim() == '' || value.trim() == null) {
                          return 'Enter a valid last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['lastName'] = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: _passwordVisible,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Password',
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Icon(_passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontFamily: 'SegoeUI'),
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: _confirmPasswordVisible,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Confirm Password',
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                          child: Icon(_confirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontFamily: 'SegoeUI'),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    defaultButton(
                      context: context,
                      text: "Register",
                      onPressed: () {
                        _submit(_identity);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
