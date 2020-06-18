import 'dart:io';

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/verification.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/country-dropdown.dart';
import 'package:chamasoft/widgets/currency-dropdown.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

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
  int countryId = 0;
  int currencyId = 0;

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
                  initialValue: Provider.of<Groups>(context, listen: false)
                      .getCurrentGroup()
                      .groupPhone,
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
              initialValue: Provider.of<Groups>(context, listen: false)
                  .getCurrentGroup()
                  .groupName,
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
              initialValue: Provider.of<Groups>(context, listen: false)
                  .getCurrentGroup()
                  .groupEmail,
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
            child: CurrencyDropdown(
              labelText: 'Select Currency',
              listItems:
                  Provider.of<Groups>(context, listen: false).currencyOptions,
              selectedItem: currencyId,
              onChanged: (value) {
                setState(() {
                  currencyId = value;
                });
              },
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
            child: Consumer<Groups>(builder: (context, groupData, child) {
              print("length of data is : ${groupData.countryOptions.length}");
              return CountryDropdown(
                labelText: 'Select Country',
                listItems: groupData.countryOptions,
                selectedItem: countryId,
                onChanged: (value) {
                  setState(() {
                    countryId = value;
                  });
                },
              );
            }),
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

//  Future<void> fetchLoanTypes(BuildContext context) async {
//    try {
//      await Provider.of<Groups>(context, listen: false).fetchLoanTypes();
//
//      Navigator.of(context)
//          .push(MaterialPageRoute(builder: (context) => ListLoanTypes()));
//    } on CustomException catch (error) {
//      print(error.message);
//    }
//  }

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
                updateText: Provider.of<Groups>(context, listen: false)
                    .getCurrentGroup()
                    .groupName,
                icon: Icons.edit,
                onPressed: () {
                  _updateName();
                },
              ),
              InfoUpdateTile(
                labelText: "Group Phone Number",
                updateText: Provider.of<Groups>(context, listen: false)
                    .getCurrentGroup()
                    .groupPhone,
                icon: Icons.edit,
                onPressed: () {
                  _updatePhoneNumber();
                },
              ),
              InfoUpdateTile(
                labelText: "Group Email Address",
                updateText: Provider.of<Groups>(context, listen: false)
                    .getCurrentGroup()
                    .groupEmail,
                icon: Icons.edit,
                onPressed: () {
                  _updateEmailAddress();
                },
              ),
              InfoUpdateTile(
                labelText: "Currency",
                updateText: Provider.of<Groups>(context, listen: false)
                    .getCurrentGroup()
                    .groupCurrencyName,
                icon: Icons.edit,
                onPressed: () async {
                  setState(() {
                    currencyId = int.parse(
                        Provider.of<Groups>(context, listen: false)
                            .getCurrentGroup()
                            .groupCurrencyId);
                  });
                  _updateCurrency();
                },
              ),
              InfoUpdateTile(
                labelText: "Country",
                updateText: Provider.of<Groups>(context, listen: false)
                    .getCurrentGroup()
                    .groupCountryName,
                icon: Icons.edit,
                onPressed: () {
                  setState(() {
                    countryId = int.parse(
                        Provider.of<Groups>(context, listen: false)
                            .getCurrentGroup()
                            .groupCountryId);
                  });

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
