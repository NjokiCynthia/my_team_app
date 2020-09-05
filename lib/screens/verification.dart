import 'dart:async';

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/signup.dart';
import '../utilities/common.dart';
import '../utilities/theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/buttons.dart';
import '../widgets/textstyles.dart';

class Verification extends StatefulWidget {
  static const namedRoute = '/verification-screen';

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  String _logo = "cs.png";
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _identity;
  bool _isInit = true;
  bool _enableResend = false;
  String _code;
  String _signature;

  // String _pin;
  bool _isLoading = false;
  bool _isFormInputEnabled = true;
  Map<String, String> _authData = {
    'identity': '',
    'pin': '',
  };
  TextEditingController _pinEditingController = TextEditingController();

  Timer _timer;
  int _start = 60;

  void _countDownTimer() {
    _isInit = false;
    _enableResend = false;
    const singleUnit = Duration(seconds: 1);
    _timer = new Timer.periodic(singleUnit, (Timer timer) {
      setState(() {
        if (_start < 1) {
          _enableResend = true;
          _timer.cancel();
        } else {
          _start -= 1;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) _countDownTimer();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    (themeChangeProvider.darkTheme) ? _logo = "cs-alt.png" : _logo = "cs.png";
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _timer.cancel();
    setState(() {
      _isLoading = true;
      _isFormInputEnabled = false;
    });
    try {
      _authData["identity"] = _identity;
      _authData["pin"] = _pinEditingController.text;
      final response = await Provider.of<Auth>(context, listen: false).verifyPin(_authData) as Map<String, dynamic>;
      print(response);
      if (response['userExists'] == 1) {
        if (response.containsKey('userGroups')) {
          Provider.of<Groups>(context, listen: false).addGroups(response['userGroups']);
        }
        Navigator.of(context).pushNamedAndRemoveUntil(MyGroups.namedRoute, ModalRoute.withName('/'), arguments: 0);
      } else {
        final uniqueCode = response['uniqueCode'];
        Navigator.pushReplacementNamed(context, SignUp.namedRoute, arguments: {
          "identity": _identity,
          "uniqueCode": uniqueCode,
        });
      }
    } on CustomException catch (error) {
      _countDownTimer();
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _submit(context);
          });
    } finally {
      setState(() {
        _pinEditingController.clear();
        _isLoading = false;
        _isFormInputEnabled = true;
      });
    }
  }

  bool _validOtp(String otp) {
    int pin = int.parse(otp);
    if (pin.toString().length != 4) {
      return false;
    }
    return true;
  }

  void _resendOtp(BuildContext context) async {
    final snackBar = SnackBar(content: subtitle2(text: "Resending verification code", textAlign: TextAlign.start));
    Scaffold.of(context).showSnackBar(snackBar);
    try {
      await Provider.of<Auth>(context, listen: false).resendPin(_identity);
      final snackBar =
          SnackBar(content: subtitle2(text: "Verification code has been sent", textAlign: TextAlign.start));
      Scaffold.of(context).showSnackBar(snackBar);
      _start = 60;
      _countDownTimer();
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
    _identity = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (BuildContext context) {
            return Stack(
              children: <Widget>[
                Form(
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
                              height: 100.0,
                            ),
                          ),
                          heading1(text: "Verification", color: Theme.of(context).textSelectionHandleColor),
                          SizedBox(
                            height: 10,
                          ),
                          subtitle1(
                              text: "A verification code has been sent to",
                              color: Theme.of(context).textSelectionHandleColor),
                          customTitle(text: _identity, color: Theme.of(context).textSelectionHandleColor),
                          SizedBox(
                            height: 12,
                          ),
                          subtitle2(text: "Enter your code here", color: Theme.of(context).textSelectionHandleColor),
                          Padding(
                            padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                            child: PinInputTextFormField(
                              pinLength: 4,
                              decoration: UnderlineDecoration(
                                colorBuilder:  PinListenColorBuilder(primaryColor,Theme.of(context).textSelectionHandleColor),
                                lineHeight: 2.0,
                                textStyle: TextStyle(
                                  color: primaryColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                ),
                                obscureStyle: ObscureStyle(
                                  isTextObscure: false,
                                ),
                              ),
                              controller: _pinEditingController,
                              textInputAction: TextInputAction.done,
                              enabled: _isFormInputEnabled,
                              autoFocus: true,
                              validator: (value) {
                                if (!_validOtp(value)) {
                                  return "Please enter a valid pin";
                                }
                                return null;
                              },
                              onSubmit: (pin) {
                                _submit(context);
                              },
                              onChanged: (pin) {
                                if (pin.length == 4) {
                                  _submit(context);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          _isLoading
                              ? CircularProgressIndicator()
                              : defaultButton(
                                  context: context,
                                  text: "Verify Code",
                                  onPressed: () => _submit(context),
                                ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(LineAwesomeIcons.clock_o, color: Theme.of(context).textSelectionHandleColor),
                              subtitle1(
                                  text: _start > 9 ? "00:$_start" : "00:0$_start",
                                  color: Theme.of(context).textSelectionHandleColor),
                              SizedBox(width: 20),
                              InkWell(
                                child: Text(
                                  'Resend',
                                  style: TextStyle(
                                    fontFamily: 'SegoeUI',
                                    color: _enableResend ? primaryColor : Theme.of(context).textSelectionHandleColor,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: _enableResend ? () => _resendOtp(context) : null,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50.0,
                  left: 20.0,
                  child: screenActionButton(
                    icon: LineAwesomeIcons.arrow_left,
                    backgroundColor: primaryColor.withOpacity(0.2),
                    textColor: primaryColor,
                    action: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            );
          },
        ));
  }
}
