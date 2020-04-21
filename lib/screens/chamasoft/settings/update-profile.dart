import 'dart:io';

import 'package:chamasoft/screens/verification.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  File avatar;
  String name = 'Jane Doe';
  String phoneNumber = '+254 701 234 567';
  String emailAddress = 'jane.doe@gmail.com';
  final _formKey = GlobalKey<FormState>();

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void _updatePhoneNumber() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Update Phone Number"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Before updating your number kindly ensure you can receive SMS on your new number',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                TextFormField(
                  initialValue: phoneNumber,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Your phone number is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hasFloatingPlaceholder: true,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 2.0,
                    )),
                    // hintText: 'Phone Number or Email Address',
                    labelText: "Phone Number",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Continue",
                style: new TextStyle(color: primaryColor),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
//                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => Verification()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _updateName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Update Name"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              initialValue: name,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Your name is required';
                }
                return null;
              },
              decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Theme.of(context).hintColor,
                  width: 2.0,
                )),
                // hintText: 'Phone Number or Email Address',
                labelText: "Your Name",
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Save",
                style: new TextStyle(color: primaryColor),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _updateEmailAddress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Update Email Address"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              initialValue: emailAddress,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  emailAddress = value;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Your email address is required';
                }
                return null;
              },
              decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Theme.of(context).hintColor,
                  width: 2.0,
                )),
                // hintText: 'Phone Number or Email Address',
                labelText: "Your Email Address",
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Save",
                style: new TextStyle(color: primaryColor),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              heading1(
                  text: "Update Profile",
                  color: Theme.of(context).textSelectionHandleColor),
              subtitle2(
                  text: "Update your Chamasoft Profile",
                  color: Theme.of(context).textSelectionHandleColor),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 100,
                width: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: avatar == null
                          ? AssetImage('assets/no-user.png')
                          : FileImage(avatar),
                      backgroundColor: Colors.transparent,
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
                          File newAvatar =
                              await FilePicker.getFile(type: FileType.image);
                          setState(() {
                            avatar = newAvatar;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                title: Text("Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Theme.of(context).bottomAppBarColor,
                    )),
                subtitle: Text(
                  name,
                  style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                    fontSize: 20.0,
                  ),
                ),
                trailing: circleIconButton(
                  icon: Icons.edit,
                  color: primaryColor,
                  backgroundColor: primaryColor.withOpacity(.1),
                  onPressed: () {
                    _updateName();
                  },
                ),
                dense: true,
                onTap: () {},
              ),
              ListTile(
                title: Text("Phone Number",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Theme.of(context).bottomAppBarColor,
                    )),
                subtitle: Text(
                  phoneNumber,
                  style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                    fontSize: 20.0,
                  ),
                ),
                trailing: circleIconButton(
                  icon: Icons.edit,
                  color: primaryColor,
                  backgroundColor: primaryColor.withOpacity(.1),
                  onPressed: () {
                    _updatePhoneNumber();
                  },
                ),
                dense: true,
                onTap: () {},
              ),
              ListTile(
                title: Text("Email Address",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Theme.of(context).bottomAppBarColor,
                    )),
                subtitle: Text(
                  emailAddress,
                  style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                    fontSize: 20.0,
                  ),
                ),
                trailing: circleIconButton(
                  icon: Icons.edit,
                  color: primaryColor,
                  backgroundColor: primaryColor.withOpacity(.1),
                  onPressed: () {
                    _updateEmailAddress();
                  },
                ),
                dense: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
