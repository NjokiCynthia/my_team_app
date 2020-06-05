import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/widgets/dialogs.dart';
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
  String _pin;
  bool _isLoading = false;
  Map<String, String> _authData = {
    'identity': '',
    'pin': '',
  };
  TextEditingController _pinEditingController = TextEditingController();

  @override
  void initState() {
    (themeChangeProvider.darkTheme) ? _logo = "cs-alt.png" : _logo = "cs.png";
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
    });
    try {
      _authData["identity"] = _identity;
      _authData["pin"] = _pinEditingController.text;
      final response = await Provider.of<Auth>(context, listen: false)
          .verifyPin(_authData) as Map<String, dynamic>;
      if (response['userExists'] == 1) {
        if (response.containsKey('userGroups') &&
            response['userGroups'].length > 0) {
          Provider.of<Groups>(context, listen: false)
              .addGroups(response['userGroups']);
        }
        Navigator.of(context).pushNamedAndRemoveUntil(
            MyGroups.namedRoute, ModalRoute.withName('/'));
      } else {
        Navigator.pushReplacementNamed(context, SignUp.namedRoute);
      }
    } on HttpException catch (error) {
      alertDialog(context, error.toString());
    } catch (error) {
      alertDialog(context, error.toString());
    } finally {
      setState(() {
        _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    _identity = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
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
                    heading1(
                        text: "Verification",
                        color: Theme.of(context).textSelectionHandleColor),
                    SizedBox(
                      height: 10,
                    ),
                    subtitle1(
                        text: "A verification code has been sent to",
                        color: Theme.of(context).textSelectionHandleColor),
                    customTitle(
                        text: _identity,
                        color: Theme.of(context).textSelectionHandleColor),
                    SizedBox(
                      height: 12,
                    ),
                    subtitle2(
                        text: "Enter your code here",
                        color: Theme.of(context).textSelectionHandleColor),
                    Padding(
                      padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                      child: PinInputTextFormField(
                        //child: PinInputTextField(
                        pinLength: 4,
                        decoration: UnderlineDecoration(
                          enteredColor: primaryColor,
                          color: Theme.of(context).textSelectionHandleColor,
                          lineHeight: 2.0,
                          textStyle: TextStyle(
                            color: primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
                          ),
                          obscureStyle: ObscureStyle(
                            isTextObscure: false,
                          ),
                          // hintText: "1234",
                        ),
                        controller: _pinEditingController,
                        textInputAction: TextInputAction.done,
                        enabled: true,
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
                            text: "Verify Phone",
                            onPressed: () => _submit(context),
                          ),
                    SizedBox(
                      height: 24,
                    ),
                    textWithExternalLinks(
                        color: Theme.of(context).textSelectionHandleColor,
                        size: 12.0,
                        textData: {
                          "Didn't receive verification code?": {},
                          'Resend': {
                            "url": () => print("Resending now..."),
                            "color": primaryColor,
                            "weight": FontWeight.w700
                          },
                        }),
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
      ),
    );
  }
}
