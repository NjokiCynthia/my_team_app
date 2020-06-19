import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/verification.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
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
  String errorText = '';
  int countryId = 0;
  int currencyId = 0;
  bool _isLoadingImage = false;
  String _groupAvatar = null;

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
    _groupAvatar = Provider.of<Groups>(context, listen: false)
        .getCurrentGroupDisplayAvatar();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  Future<void> doUpdateName(BuildContext context) async {
    errorText = '';
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .updateGroupName(groupName);
      if (response['status'] == 1) {
        Navigator.of(context).pop();
      } else {
        errorText = response['message'];
      }
    } on CustomException catch (error) {
      print(error.message);
      errorText = 'Network Error occurred: could not update group name';
    }
  }

  Future<void> doUpdateEmail(BuildContext context) async {
    errorText = '';
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .updateGroupEmail(emailAddress);
      if (response['status'] == 1) {
        Navigator.of(context).pop();
      } else {
        errorText = response['message'];
      }
    } on CustomException catch (error) {
      print(error.message);
      errorText = 'Network Error occurred: could not update group email';
    }
  }

  Future<void> doUpdatePhone(BuildContext context) async {
    errorText = '';
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .updateGroupPhoneNumber(phoneNumber);
      if (response['status'] == 1) {
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (context) => Verification()));
      } else {
        errorText = response['message'];
      }
    } on CustomException catch (error) {
      print(error.message);
      errorText = 'Network Error occurred: could not update group email';
    }
  }

  Future<void> doUpdateCurrency(BuildContext context) async {
    errorText = '';
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .updateGroupCurrency(currencyId);
      if (response['status'] == 1) {
        Navigator.of(context).pop();
      } else {
        errorText = response['message'];
      }
    } on CustomException catch (error) {
      print(error.message);
      errorText = 'Network Error occurred: could not update group currency';
    }
  }

  Future<void> doUpdateCountry(BuildContext context) async {
    errorText = '';
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .updateGroupCountry(countryId);
      if (response['status'] == 1) {
        Navigator.of(context).pop();
      } else {
        errorText = response['message'];
      }
    } on CustomException catch (error) {
      print(error.message);
      errorText = 'Network Error occurred: could not update group country';
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
              onPressed: () async {
                if (_formKey.currentState.validate()) {
//                  Navigator.of(context).pop();
                  await doUpdatePhone(context);
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              errorText.length > 0
                  ? Text(
                      errorText,
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
              Form(
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
            ],
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
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await doUpdateName(context);
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
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await doUpdateEmail(context);
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
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: new Text("Update Group Currency"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: CurrencyDropdown(
                    labelText: 'Select Currency',
                    listItems: Provider.of<Groups>(context, listen: false)
                        .currencyOptions,
                    selectedItem: currencyId,
                    onChanged: (value) {
                      setState(() {
                        currencyId = value;
                      });
                    },
                  ),
                ),
              ],
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
                onPressed: () async {
                  await doUpdateCurrency(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _updateCountry() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: new Text("Update Country"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Consumer<Groups>(builder: (context, groupData, child) {
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
              ],
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
                onPressed: () async {
                  await doUpdateCountry(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _uploadGroupAvatar(BuildContext context) async {
    if (avatar != null) {
      setState(() {
        _isLoadingImage = true;
      });
      try {
        await Provider.of<Groups>(context, listen: false)
            .updateGroupAvatar(avatar);
        setState(() {
          _groupAvatar = null;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
          "You have successfully updated Group profile picture",
        )));
      } on CustomException catch (error) {
        setState(() {
          avatar = null;
        });
        StatusHandler().handleStatus(
            context: context,
            error: error,
            callback: () {
              _uploadGroupAvatar(context);
            });
      } finally {
        _isLoadingImage = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(builder: (BuildContext context) {
        return (SingleChildScrollView(
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
                      _isLoadingImage
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _groupAvatar != null
                              ? CachedNetworkImage(
                                  imageUrl: _groupAvatar,
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                    radius: 45.0,
                                    backgroundImage:
                                        const AssetImage('assets/no-user.png'),
                                  ),
                                  imageBuilder: (context, image) =>
                                      CircleAvatar(
                                    backgroundImage: image,
                                    radius: 45.0,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fadeOutDuration: const Duration(seconds: 1),
                                  fadeInDuration: const Duration(seconds: 3),
                                )
                              : CircleAvatar(
                                  backgroundImage: _groupAvatar != null
                                      ? NetworkImage(_groupAvatar)
                                      : (avatar == null
                                          ? AssetImage('assets/no-user.png')
                                          : FileImage(avatar)),
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
                            _uploadGroupAvatar(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                InfoUpdateTile(
                  labelText: "Group Name",
                  updateText: currentGroup.groupName,
                  icon: Icons.edit,
                  onPressed: () {
                    _updateName();
                  },
                ),
                InfoUpdateTile(
                  labelText: "Group Phone Number",
                  updateText: currentGroup.groupPhone,
                  icon: Icons.edit,
                  onPressed: () {
                    _updatePhoneNumber();
                  },
                ),
                InfoUpdateTile(
                  labelText: "Group Email Address",
                  updateText: currentGroup.groupEmail,
                  icon: Icons.edit,
                  onPressed: () {
                    _updateEmailAddress();
                  },
                ),
                InfoUpdateTile(
                  labelText: "Currency",
                  updateText: currentGroup.groupCurrencyName,
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
                  updateText: currentGroup.groupCountryName,
                  icon: Icons.edit,
                  onPressed: () {
                    setState(() {
                      countryId = int.parse(currentGroup.groupCountryId);
                    });

                    _updateCountry();
                  },
                ),
              ],
            ),
          ),
        ));
      }),
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
