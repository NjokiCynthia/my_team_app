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

class UpdateGroupProfile extends StatefulWidget {
  @override
  _UpdateGroupProfileState createState() => _UpdateGroupProfileState();
}

class _UpdateGroupProfileState extends State<UpdateGroupProfile> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  File avatar;
  String groupName = 'Witcher Welfare';
  String phoneNumber = '+254 701 234 567';
  String emailAddress = 'official@witcher.com';
  String currency = 'KES';
  String country = 'Kenya';

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
          title: new Text("Update Group Name"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              initialValue: groupName,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  groupName = value;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Your Group name is required';
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
                labelText: "Your Group  Name",
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
          title: new Text("Update Group Email Address"),
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
                  return 'Your Group email address is required';
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
                labelText: "Your Group Email Address",
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

  void _updateCurrency() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Update Group Currency"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              initialValue: currency,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  currency = value;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Your Group Currency is required';
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
                labelText: "Your Group Currency",
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

  void _updateCountry() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Update Country"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              initialValue: country,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  country = value;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Your Country';
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
                labelText: "Your Country",
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
                  text: "Update Group Profile",
                  color: Theme.of(context).textSelectionHandleColor),
              subtitle2(
                  text: "Update the profile info for your Group",
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
              InfoUpdateTile(
                labelText: "Group Name",
                updateText: groupName,
                icon: Icons.edit,
                onPressed: () {
                  _updateName();
                },
              ),
              InfoUpdateTile(
                labelText: "Group Phone Number",
                updateText: phoneNumber,
                icon: Icons.edit,
                onPressed: () {
                  _updatePhoneNumber();
                },
              ),
              InfoUpdateTile(
                labelText: "Group Email Address",
                updateText: emailAddress,
                icon: Icons.edit,
                onPressed: () {
                  _updateEmailAddress();
                },
              ),
              InfoUpdateTile(
                labelText: "Currency",
                updateText: currency,
                icon: Icons.edit,
                onPressed: () {
                  _updateCurrency();
                },
              ),
              InfoUpdateTile(
                labelText: "Country",
                updateText: country,
                icon: Icons.edit,
                onPressed: () {
                  _updateCountry();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoUpdateTile extends StatelessWidget {
  final String labelText;
  final String updateText;
  final IconData icon;
  final Function onPressed;
  const InfoUpdateTile({
    this.labelText,
    this.updateText,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("$labelText",
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).bottomAppBarColor,
          )),
      subtitle: Text(
        "$updateText",
        style: TextStyle(
          color: Theme.of(context).textSelectionHandleColor,
          fontSize: 20.0,
        ),
      ),
      trailing: circleIconButton(
        icon: icon,
        color: primaryColor,
        backgroundColor: primaryColor.withOpacity(.1),
        onPressed: onPressed,
      ),
      onTap: () {},
    );
  }
}
