import 'package:chamasoft/config.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/screens/verification.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../utilities/custom-helper.dart';

class Login extends StatefulWidget {
  static const namedRoute = "/login-screen";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _logo = Config.appName.toLowerCase() == 'chamasoft'
      ? "cs.png"
      : "equity-logo.png";
  final GlobalKey<FormState> _formKey = GlobalKey();
  // final GlobalKey<CountryCodePickerState> _countryKey = GlobalKey();
  String _identity;
  CountryCode _countryCode = CountryCode.fromCode("KE");
  final _countryCodeController = TextEditingController(text: "+254");
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isFormInputEnabled = true;
  bool _isPhoneNumber = false;
  bool _setStateCalled = false;
  String appSignature = "{{app signature}}";

  FocusNode _focusNode;
  bool _focused = false;
  bool _isValid = true;
  BorderSide _custInputBorderSide = BorderSide(
    color: Colors.blueGrey,
    width: 1.0,
  );

  _printLatestValues() {
    final text = _phoneController.text;
    if (text.length >= 2 && CustomHelper.isNumeric(text)) {
      if (!_setStateCalled) {
        _setStateCalled = true;
        setState(() {
          _isPhoneNumber = true;
        });
      }
    } else {
      if (_isPhoneNumber) {
        _setStateCalled = false;
        setState(() {
          _isPhoneNumber = false;
          _isValid = true;
        });
      }
    }
  }

  @override
  void initState() {
    (themeChangeProvider.darkTheme)
        ? _logo = Config.appName.toLowerCase() == 'chamasoft'
            ? "cs-alt.png"
            : "equity-logo-alt.png"
        : _logo = Config.appName.toLowerCase() == 'chamasoft'
            ? "cs.png"
            : "equity-logo.png";
    super.initState();
    _phoneController.addListener(_printLatestValues);
    _focusNode = new FocusNode();
    _focusNode.addListener(_handleFocusChange);
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  void _handleFocusChange() {
    setState(() {
      _focused = _focusNode.hasFocus;
      if (!_focused) {
        _custInputBorderSide = BorderSide(
          color: (!_isValid) ? Colors.red : Colors.blueGrey,
          width: 1.0,
        );
      } else {
        _custInputBorderSide = BorderSide(
          color: (!_isValid) ? Colors.red : primaryColor,
          width: 2.0,
        );
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
    _focusNode.dispose();
  }

  void _submit(BuildContext context) async {
    _formKey.currentState.save();

    if (_identity.contains("@")) {
      if (!CustomHelper.validEmail(_identity)) {
        setState(() {
          print("Invalid Email");
          _isValid = false;
        });
        return;
      }
      setState(() {
        print("Valid Email");
        _isValid = true;
      });
    } else {
      print(_identity);
      bool value = await CustomHelper.validPhoneNumber(_identity, _countryCode);
      if (!value) {
        print("Invalid");
        setState(() {
          _isValid = false;
        });
      } else {
        setState(() {
          print("Valid");
          _isValid = true;
        });
      }
    }

    if (!_formKey.currentState.validate() || !_isValid) {
      // Invalid!
      return;
    }

    String title = "Confirm Email Address";
    if (!_identity.contains("@")) {
      _identity = _identity.startsWith("0")
          ? _identity.replaceFirst("0", "")
          : _identity;
      _identity = _countryCode.dialCode + _identity;
      title = "Confirm Phone Number";
    }

    twoButtonAlertDialog(
        context: context,
        message: _identity,
        title: title,
        action: () async {
          Navigator.of(context).pop();
          setState(() {
            _isLoading = true;
            _isFormInputEnabled = false;
          });
          try {
            await Provider.of<Auth>(context, listen: false)
                .generatePin(_identity, appSignature);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Verification(),
                settings: RouteSettings(arguments: _identity)));
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
        });
  }

  @override
  Widget build(BuildContext context) {
    //FirebaseCrashlytics.instance.crash();
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.center,
              decoration: primaryGradient(context),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                      child: Image(
                        image: AssetImage('assets/$_logo'),
                        height: Config.appName.toLowerCase() == 'chamasoft'
                            ? 100.0
                            : 50.0,
                      ),
                    ),
                    SizedBox(
                      height: Config.appName.toLowerCase() == 'chamasoft'
                          ? 0.0
                          : 6.0,
                    ),
                    heading1(
                        text: Config.appName,
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor),
                    SizedBox(
                      height: 10,
                    ),
                    subtitle1(
                        text: "Let's verify your identity first",
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor),
                    subtitle2(
                        text: "Enter your phone number or email address below",
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor),

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 8.0),
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: _custInputBorderSide,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Visibility(
                                  visible: _isPhoneNumber,
                                  child: Row(
                                    children: <Widget>[
                                      CountryCodePicker(
                                        // key: _countryKey,
                                        initialSelection: 'KE',
                                        favorite: ['KE', 'UG', 'TZ', 'RW'],
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                        flagWidth: 28.0,
                                        enabled: _isFormInputEnabled,
                                        textStyle: TextStyle(
                                          fontFamily:
                                              'SegoeUI', /*fontSize: 16,color: Theme.of(context).textSelectionHandleColor*/
                                        ),
                                        searchStyle: TextStyle(
                                            fontFamily: 'SegoeUI',
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor),
                                        onChanged: (countryCode) {
                                          setState(() {
                                            _countryCode = countryCode;
                                            _countryCodeController.text =
                                                countryCode.dialCode;
                                            print("Code: " +
                                                countryCode.dialCode);
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
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
                                      hintText: 'Email or mobile number',
                                    ),
                                    enabled: _isFormInputEnabled,
                                    focusNode: _focusNode,
                                    style: TextStyle(fontFamily: 'SegoeUI'),
                                    onSaved: (value) {
                                      _identity = value.trim();
                                    },
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
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20.0,
                          ),
                          Icon(
                            Icons.info_outline,
                            color: Colors.red,
                            size: 16.0,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.5),
                            child: Text(
                              'Enter valid email or mobile number',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Expanded(
                    //       flex: 1,
                    //       child: Container(),
                    //     ),
                    //     _isPhoneNumber
                    //         ? Flexible(
                    //             flex: 2,
                    //             child: CountryCodePicker(
                    //               key: _countryKey,
                    //               enabled: _isFormInputEnabled,
                    //               initialSelection: 'KE',
                    //               builder: (country) {
                    //                 return TextFormField(
                    //                   controller: _countryCodeController,
                    //                   onTap: () => _countryKey.currentState.showCountryCodePickerDialog(),
                    //                   style: TextStyle(fontFamily: 'SegoeUI'),
                    //                   enabled: _isFormInputEnabled,
                    //                   readOnly: true,
                    //                   showCursor: false,
                    //                   decoration: InputDecoration(
                    //                     labelText: 'Code',
                    //                     floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //                   ),
                    //                 );
                    //               },
                    //               favorite: ['+254', 'KE'],
                    //               showFlag: true,
                    //               textStyle: TextStyle(fontFamily: 'SegoeUI', /*fontSize: 16,*/ // ignore: deprecated_member_use
//  color: Theme.of(context).textSelectionHandleColor),
                    //               showCountryOnly: false,
                    //               searchStyle: TextStyle(fontFamily: 'SegoeUI', fontSize: 16, // ignore: deprecated_member_use
//  color: Theme.of(context).textSelectionHandleColor),
                    //               showOnlyCountryWhenClosed: false,
                    //               alignLeft: true,
                    //               onChanged: (countryCode) {
                    //                 setState(() {
                    //                   _countryCode = countryCode;
                    //                   _countryCodeController.text = countryCode.dialCode;
                    //                   print("Code: " + countryCode.dialCode);
                    //                 });
                    //               },
                    //             ),
                    //           )
                    //         : Container(),
                    //     SizedBox(
                    //       width: 5,
                    //     ),
                    //     Expanded(
                    //       flex: 5,
                    //       child: TextFormField(
                    //         controller: _phoneController,
                    //         style: TextStyle(fontFamily: 'SegoeUI'),
                    //         enabled: _isFormInputEnabled,
                    //         decoration: InputDecoration(
                    //           floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //           labelText: 'Phone Number or Email',
                    //           labelStyle: TextStyle(fontFamily: 'SegoeUI'),
                    //         ),
                    //         validator: (value) {
                    //           if (!CustomHelper.validIdentity(value.trim())) {
                    //             return 'Enter valid phone or email';
                    //           }
                    //           return null;
                    //         },
                    //         onSaved: (value) {
                    //           _identity = value.trim();
                    //         },
                    //       ),
                    //     ),
                    //     Expanded(
                    //       flex: 1,
                    //       child: Container(),
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : defaultButton(
                            context: context,
                            text: "Continue",
                            onPressed: () => _submit(context),
                          ),
                    SizedBox(
                      height: 24,
                    ),
                    textWithExternalLinks(
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor,
                        size: 12.0,
                        textData: {
                          'By continuing you agree to our': {},
                          'terms & conditions': {
                            "url": () => launchURL(
                                'https://chamasoft.com/terms-and-conditions/'),
                            "color": primaryColor,
                            "weight": FontWeight.w500
                          },
                          // 'and': {},
                          // 'privacy policy.': {
                          //   "url": () => launchURL('https://chamasoft.com/terms-and-conditions/'),
                          //   "color": primaryColor,
                          //   "weight": FontWeight.w500
                          // },
                        }),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
