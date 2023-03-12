import 'dart:async';
import 'package:chamasoft/config.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/login_password.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/notifications.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../providers/auth.dart';
import '../screens/signup.dart';
import '../helpers/common.dart';
import '../helpers/theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/buttons.dart';
import '../widgets/textstyles.dart';

class Verification extends StatefulWidget {
  static const namedRoute = '/verification-screen';

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> with CodeAutoFill {
  String _logo = Config.appName.toLowerCase() == 'chamasoft'
      ? "cs.png"
      : "equity-logo.png";
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _identity;
  bool _isInit = true;
  bool _enableResend = false;
  bool _isLoading = false;
  bool _isFormInputEnabled = true;
  Map<String, String> _authData = {
    'identity': '',
    'pin': '',
  };
  TextEditingController _pinEditingController = TextEditingController();

  Timer _timer;
  int _start = 60;
  String appSignature = "{{app signature}}";

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

  // void _initSmsListener() async{
  //   await SmsAutoFill().listenForCode;
  //   print("Initialize this message");
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) _countDownTimer();
    super.didChangeDependencies();
  }

  @override
  void codeUpdated() {
    if (code.length == 4) {
      _pinEditingController.text = code;
      _submit(context);
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
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _timer.cancel();
    super.dispose();
  }

  void _submit(BuildContext context) async {
    if (this.mounted) {
      if (!_formKey.currentState.validate()) {
        return;
      }
    }
    if (this.mounted) {
      _timer.cancel();
      setState(() {
        _isLoading = true;
        _isFormInputEnabled = false;
      });
    }
    if (this.mounted) {
      _formKey.currentState.save();
    }
    try {
      _authData["identity"] = _identity;
      _authData["pin"] = _pinEditingController.text;

      final response = await Provider.of<Auth>(context, listen: false)
          .verifyPin(_authData) as Map<String, dynamic>;

      if (response['userExists'] == 1) {
        if (Config.appName.toLowerCase() == "chamasoft") {
          if (response.containsKey('userGroups')) {
            Provider.of<Groups>(context, listen: false)
                .addGroups(response['userGroups']);
          }
          NotificationManager.registerUserToken(context, response["userId"]);
          Navigator.of(context).pushNamedAndRemoveUntil(
              MyGroups.namedRoute, ModalRoute.withName('/'),
              arguments: 0);
        } else if (Config.appName.toLowerCase() == "eazzyclub") {
          Navigator.of(context).pushReplacementNamed(LoginPassword.namedRoute,
              arguments: _identity);
        }
      } else {
        final uniqueCode = response['uniqueCode'];
        if (Config.appName.toLowerCase() == "chamasoft") {
          Navigator.pushReplacementNamed(context, SignUp.namedRoute,
              arguments: {
                "identity": _identity,
                "uniqueCode": uniqueCode,
              });
        } else if (Config.appName.toLowerCase() == "eazzyclub") {
          Navigator.of(context)
              .pushReplacementNamed(RegisterScreen.namedRoute, arguments: {
            "identity": _identity,
            "uniqueCode": uniqueCode,
          });
        }
      }
    } on CustomException catch (error) {
      print("new error $error");
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
    if (pin.toString().length == 4) {
      return true;
    }

    return false;
  }

  void _resendOtp(BuildContext context) async {
    final snackBar = SnackBar(
        content: subtitle2(
            text: "Resending verification code", textAlign: TextAlign.start));
    // ignore: deprecated_member_use
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    try {
      await Provider.of<Auth>(context, listen: false)
          .resendPin(_identity, appSignature);
      final snackBar = SnackBar(
          content: subtitle2(
              text: "Verification code has been sent",
              textAlign: TextAlign.start));
      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                              height:
                                  Config.appName.toLowerCase() == 'chamasoft'
                                      ? 100.0
                                      : 50.0,
                            ),
                          ),
                          heading1(
                              text: "Verification",
                              color: Config.appName.toLowerCase() == "chamasoft"
                                  ? Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor
                                  : Theme.of(context).primaryColor),
                          SizedBox(
                            height: 10,
                          ),
                          subtitle2(
                              text: "A verification code has been sent to",
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor),
                          customTitle(
                              text: _identity,
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor),
                          SizedBox(
                            height: 12,
                          ),
                          subtitle2(
                              text: "Enter your code here",
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor),
                          Padding(
                            padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                            child: PinInputTextFormField(
                              pinLength: 4,
                              decoration: UnderlineDecoration(
                                colorBuilder: PinListenColorBuilder(
                                    primaryColor,
                                    // ignore: deprecated_member_use
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor),
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
                              Icon(LineAwesomeIcons.clock_1,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionTheme
                                      .selectionHandleColor),
                              subtitle1(
                                  text:
                                      _start > 9 ? "00:$_start" : "00:0$_start",
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionTheme
                                      .selectionHandleColor),
                              SizedBox(width: 20),
                              InkWell(
                                child: Text(
                                  'Resend',
                                  style: TextStyle(
                                    fontFamily: 'SegoeUI',
                                    color: _enableResend
                                        ? primaryColor
                                        : Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionTheme.selectionHandleColor,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: _enableResend
                                    ? () => _resendOtp(context)
                                    : null,
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
