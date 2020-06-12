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
import 'package:provider/provider.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  File avatar;
  String name = 'Jane Doe';
  String _newName;
  String phoneNumber = '+254 701 234 567';
  String emailAddress = 'jane.doe@gmail.com';
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final auth = Provider.of<Auth>(context, listen: false);
    name = auth.userName;
    phoneNumber = auth.phoneNumber;
    emailAddress = auth.emailAddress;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }


  Future<void> _updateUserName(BuildContext context)async{
    try{
      if(name!=_newName){
        await Provider.of<Auth>(context,listen:false).updateUserName(_newName);
        setState(() {
          name = _newName;
        });
        _scaffoldKey.currentState
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text("Copied \"Row \"")));
        //Scaffold.of(context).showSnackBar(SnackBar(content: Text("Name successfully updated",textAlign: TextAlign.center,)));
      }else{
        _scaffoldKey.currentState
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text("Copied \"Row \"")));
        //Scaffold.of(context).showSnackBar(SnackBar(content: Text("Name was not changed no update",textAlign: TextAlign.center,)));
      }
    }on CustomException catch(error){
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _updateUserName(context);
          });
    }finally{

    }
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
                  _newName = value;
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
                Navigator.of(context).pop();
                _updateUserName(context);
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

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Are you talkin\' to me?'));
    Scaffold.of(context).showSnackBar(snackBar);
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
              Builder(builder: (ctx)=>RaisedButton(
              child: Text('Show Snackbar'),
              onPressed: ()=>_displaySnackBar(ctx),
              ),),
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
              InfoUpdateTile(
                labelText: "Name",
                updateText: name,
                icon: Icons.edit,
                onPressed: () {
                  _updateName();
                },
              ),
              InfoUpdateTile(
                labelText: "Phone Number",
                updateText: phoneNumber,
                icon: Icons.edit,
                onPressed: () {
                  _updatePhoneNumber();
                },
              ),
              InfoUpdateTile(
                labelText: "Email Address",
                updateText: emailAddress,
                icon: Icons.edit,
                onPressed: () {
                  _updateEmailAddress();
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
