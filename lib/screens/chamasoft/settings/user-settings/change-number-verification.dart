import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ChangeNumberVerification extends StatefulWidget {
  @override
  _ChangeNumberVerification createState() => _ChangeNumberVerification();
}

class _ChangeNumberVerification extends State<ChangeNumberVerification> {
  String _logo = "cs.png";
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _identity;
  // String _pin;
  bool _isLoading = false;
  bool _isFormInputEnabled = true;
  Map<String, String> _authData = {
    'identity': '',
    'pin': '',
  };
  TextEditingController _pinEditingController = TextEditingController();
  String appSignature = "{{app signature}}";

  @override
  void initState() {
    (themeChangeProvider.darkTheme) ? _logo = "cs-alt.png" : _logo = "cs.png";
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
      _isFormInputEnabled = false;
    });
    try {
      _authData["identity"] = _identity;
      _authData["pin"] = _pinEditingController.text;
      final response = await Provider.of<Auth>(context, listen: false)
          .verifyPin(_authData) as Map<String, dynamic>;
      print(response);
    } on CustomException catch (error) {
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
    final snackBar = SnackBar(
        content: subtitle2(
            text: "Resending verification code", textAlign: TextAlign.start));
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(snackBar);
    try {
      await Provider.of<Auth>(context, listen: false)
          .resendPin(_identity, appSignature);
      final snackBar = SnackBar(
          content: subtitle2(
              text: "Verification code has been sent",
              textAlign: TextAlign.start));
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(snackBar);
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
                          heading2(
                              text: "Change Phone Number",
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context).textSelectionHandleColor),
                          SizedBox(
                            height: 10,
                          ),
                          subtitle1(
                              text: "A verification code has been sent to",
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context).textSelectionHandleColor),
                          customTitle(
                              text: _identity,
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context).textSelectionHandleColor),
                          SizedBox(
                            height: 12,
                          ),
                          subtitle2(
                              text: "Enter your code here",
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context).textSelectionHandleColor),
                          Padding(
                            padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                            child: PinInputTextFormField(
                              pinLength: 4,
                              decoration: UnderlineDecoration(
                                colorBuilder: PinListenColorBuilder(
                                    primaryColor,
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor),
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
                              customTitle(
                                  text: "Didn't receive verification code? ",
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  fontSize: 13.0),
                              InkWell(
                                child: Text(
                                  'Resend',
                                  style: TextStyle(
                                    fontFamily: 'SegoeUI',
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: () => _resendOtp(context),
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
                    icon: LineAwesomeIcons.close,
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
