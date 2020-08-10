import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  File avatar;
  String _userAvatar;
  String name = 'Jane Doe';
  String _oldName;
  String phoneNumber = '+254 701 234 567';
  String newNumber;
  String emailAddress, _oldEmailAddress;
  final _userNameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  bool _isLoadingImage = false;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  // BorderSide _customInputBorderSide = BorderSide(
  //   color: Colors.blueGrey,
  //   width: 1.0,
  // );

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    final auth = Provider.of<Auth>(context, listen: false);
    name = auth.userName;
    _oldName = name;
    phoneNumber = auth.phoneNumber;
    emailAddress = auth.emailAddress;
    _oldEmailAddress = emailAddress;
    _userAvatar = auth.displayAvatar;

    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  Future<void> _uploadUserAvatar(BuildContext context) async {
    if (avatar != null) {
      setState(() {
        _isLoadingImage = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false).updateUserAvatar(avatar);
        setState(() {
          _userAvatar = null;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
          "You have successfully updated your profile picture",
        )));
      } on CustomException catch (error) {
        setState(() {
          avatar = null;
        });
        StatusHandler().handleStatus(
            context: context,
            error: error,
            callback: () {
              _uploadUserAvatar(context);
            });
      } finally {
        _isLoadingImage = false;
      }
    }
  }

  Future<void> _updateUserName(BuildContext context) async {
    try {
      if (!_userNameFormKey.currentState.validate()) {
        return;
      }
      _userNameFormKey.currentState.save();
      Navigator.of(context).pop();
      if (name != _oldName) {
        await Provider.of<Auth>(context, listen: false).updateUserName(name);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
          "Name successfully updated",
        )));
      }
    } on CustomException catch (error) {
      setState(() {
        name = _oldName;
      });
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _updateUserName(context);
          });
    } finally {}
  }

  // Future<void> _updateNumber(BuildContext context, String number) async {
  //   try {
  //     String temp = number.startsWith("+") ? number.replaceFirst("+", "") : number;
  //     print("Temp: $temp");
  //     print("Actual: $phoneNumber");
  //     if (temp != phoneNumber) {
  //       //await Provider.of<Auth>(context, listen: false).updateUserName(name);
  //       Navigator.of(context)
  //           .push(new MaterialPageRoute(builder: (context) => ChangeNumberVerification(), settings: RouteSettings(arguments: number)));
  //     }
  //   } on CustomException catch (error) {
  //     setState(() {
  //       name = _oldName;
  //     });

  //     StatusHandler().handleStatus(
  //         context: context,
  //         error: error,
  //         callback: () {
  //           _updateUserName(context);
  //         });
  //   } finally {}
  // }

  Future<void> _updateUserEmailAddress(BuildContext context) async {
    try {
      if (!_emailFormKey.currentState.validate()) {
        return;
      }
      _emailFormKey.currentState.save();
      if (emailAddress != _oldEmailAddress) {
        await Provider.of<Auth>(context, listen: false).updateUserEmailAddress(emailAddress);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
          "You have successfully updated your email address",
        )));
      }
    } on CustomException catch (error) {
      setState(() {
        emailAddress = _oldEmailAddress;
      });
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _updateUserEmailAddress(context);
          });
    } finally {}
  }

  // void _updatePhoneNumber() {
  //   bool _isValid = true;
  //   CountryCode _countryCode = CountryCode.fromCode("KE");
  //   final _phoneController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Theme.of(context).backgroundColor,
  //         title: heading2(text: "Update Phone Number", textAlign: TextAlign.start),
  //         content: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 customTitleWithWrap(
  //                     text: 'Before updating your number kindly ensure you can receive SMS on your new number',
  //                     fontSize: 12,
  //                     textAlign: TextAlign.start),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     customTitle(
  //                         text: "New Phone Number", textAlign: TextAlign.start, fontSize: 11, color: Theme.of(context).textSelectionHandleColor),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: <Widget>[
  //                     Expanded(
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           border: Border(
  //                             bottom: _customInputBorderSide,
  //                           ),
  //                         ),
  //                         child: Row(
  //                           children: <Widget>[
  //                             Row(
  //                               children: <Widget>[
  //                                 Container(
  //                                   height: 34,
  //                                   padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
  //                                   child: CountryCodePicker(
  //                                     // key: _countryKey,
  //                                     initialSelection: 'KE',
  //                                     favorite: ['KE', 'UG', 'TZ', 'RW'],
  //                                     showCountryOnly: false,
  //                                     showOnlyCountryWhenClosed: false,
  //                                     alignLeft: false,
  //                                     flagWidth: 28.0,
  //                                     textStyle: TextStyle(
  //                                       fontFamily: 'SegoeUI', /*fontSize: 16,color: Theme.of(context).textSelectionHandleColor*/
  //                                     ),
  //                                     searchStyle: TextStyle(fontFamily: 'SegoeUI', fontSize: 16, color: Theme.of(context).textSelectionHandleColor),
  //                                     onChanged: (countryCode) {
  //                                       setState(() {
  //                                         _countryCode = countryCode;
  //                                         print("Code: " + countryCode.dialCode);
  //                                       });
  //                                     },
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 10,
  //                                 ),
  //                               ],
  //                             ),
  //                             Expanded(
  //                               child: Container(
  //                                 height: 34,
  //                                 padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
  //                                 child: TextFormField(
  //                                   controller: _phoneController,
  //                                   keyboardType: TextInputType.phone,
  //                                   decoration: InputDecoration(
  //                                     border: InputBorder.none,
  //                                     isDense: true,
  //                                     focusedBorder: InputBorder.none,
  //                                     enabledBorder: InputBorder.none,
  //                                     errorBorder: InputBorder.none,
  //                                     disabledBorder: InputBorder.none,
  //                                     hintText: '',
  //                                   ),
  //                                   style: TextStyle(fontFamily: 'SegoeUI', fontSize: 16),
  //                                 ),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Visibility(
  //                   visible: !_isValid,
  //                   child: Padding(
  //                     padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.5),
  //                     child: customTitle(
  //                       text: 'Enter valid phone number',
  //                       color: Colors.red,
  //                       fontSize: 12.0,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: <Widget>[
  //                     negativeActionDialogButton(
  //                         color: Theme.of(context).textSelectionHandleColor,
  //                         action: () {
  //                           Navigator.of(context).pop();
  //                         }),
  //                     positiveActionDialogButton(
  //                         text: "Continue",
  //                         color: primaryColor,
  //                         action: () async {
  //                           bool value = await CustomHelper.validPhoneNumber(_phoneController.text, _countryCode);
  //                           print("valid $value");
  //                           if (!value) {
  //                             setState(() {
  //                               _isValid = false;
  //                             });
  //                           } else {
  //                             setState(() {
  //                               _isValid = true;
  //                             });
  //                           }

  //                           if (!_isValid) return;

  //                           final identity = _countryCode.dialCode + _phoneController.text;
  //                           Navigator.of(context).pop();
  //                           _updateNumber(context, identity);
  //                         }),
  //                   ],
  //                 )
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  void _updateName(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Update Name"),
          content: Form(
            key: _userNameFormKey,
            child: TextFormField(
              initialValue: name,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    name = _oldName;
                  } else if (value.trim().split(" ").length < 2) {
                    name = _oldName;
                  } else {
                    name = value;
                  }
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Your name is required';
                } else if (value.trim().split(" ").length < 2) {
                  return "Enter atleast 2 names";
                }
                return null;
              },
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
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
            negativeActionDialogButton(
                color: Theme.of(context).textSelectionHandleColor,
                action: () {
                  Navigator.of(context).pop();
                }),
            positiveActionDialogButton(
                text: "Save",
                color: primaryColor,
                action: () {
                  _updateUserName(context);
                }),
            SizedBox(
              width: 10,
            )
          ],
        );
      },
    );
  }

  void _updateEmailAddress(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Update Email Address"),
          content: Form(
            key: _emailFormKey,
            child: TextFormField(
              initialValue: emailAddress,
              key: ValueKey("email"),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  if (CustomHelper.validEmail(value)) {
                    emailAddress = value;
                  }
                });
              },
              validator: (email) {
                if (email.isEmpty) {
                  return "Field is required";
                } else {
                  if (!CustomHelper.validEmail(email)) {
                    return "Enter a valid email address";
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Theme.of(context).hintColor,
                  width: 2.0,
                )),
                labelText: "Your Email Address",
              ),
            ),
          ),
          actions: <Widget>[
            negativeActionDialogButton(
                color: Theme.of(context).textSelectionHandleColor,
                action: () {
                  Navigator.of(context).pop();
                }),
            positiveActionDialogButton(
                text: "Save",
                color: primaryColor,
                action: () {
                  Navigator.of(context).pop();
                  _updateUserEmailAddress(context);
                }),
            SizedBox(
              width: 10,
            )
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
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  heading1(text: "Update Profile", color: Theme.of(context).textSelectionHandleColor),
                  subtitle2(text: "Update your Chamasoft Profile", color: Theme.of(context).textSelectionHandleColor),
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
                            : _userAvatar != null
                                ? CachedNetworkImage(
                                    imageUrl: _userAvatar,
                                    placeholder: (context, url) => const CircleAvatar(
                                      radius: 45.0,
                                      backgroundImage: const AssetImage('assets/no-user.png'),
                                    ),
                                    imageBuilder: (context, image) => CircleAvatar(
                                      backgroundImage: image,
                                      radius: 45.0,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fadeOutDuration: const Duration(seconds: 1),
                                    fadeInDuration: const Duration(seconds: 3),
                                  )
                                : CircleAvatar(
                                    backgroundImage: _userAvatar != null
                                        ? NetworkImage(_userAvatar)
                                        : (avatar == null ? AssetImage('assets/no-user.png') : FileImage(avatar)),
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
                              File newAvatar = await FilePicker.getFile(type: FileType.image);
                              setState(() {
                                avatar = newAvatar;
                              });
                              _uploadUserAvatar(context);
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
                      _updateName(context);
                    },
                  ),
                  InfoUpdateTile(
                    labelText: "Phone Number",
                    updateText: phoneNumber,
                    icon: Icons.edit,
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                        "Coming Soon",
                      )));
                      //_updatePhoneNumber();
                    },
                  ),
                  InfoUpdateTile(
                    labelText: "Email Address",
                    updateText: emailAddress,
                    icon: Icons.edit,
                    onPressed: () {
                      _updateEmailAddress(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
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
      trailing: Container(
        width: 32,
        height: 32,
        padding: EdgeInsets.all(2),
        decoration: ShapeDecoration(
          color: primaryColor.withOpacity(.1),
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(
            icon,
            size: 14,
          ),
          onPressed: onPressed,
          color: primaryColor,
        ),
      ),
      onTap: () {},
    );
  }
}
