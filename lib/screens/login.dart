import 'package:chamasoft/screens/verification.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../utilities/custom-helper.dart';

class Login extends StatefulWidget {
  static const namedRoute = "/login-screen";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _logo = "cs.png";
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _identity;
  bool _isLoading = false;
  bool _isFormInputEnabled = true;
  @override
  void initState() {
    (themeChangeProvider.darkTheme) ? _logo = "cs-alt.png" : _logo = "cs.png";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showErrorDialog(BuildContext context, String message) {
    alertDialog(context, message);
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
      _isFormInputEnabled = false;
    });
    try {
      await Provider.of<Auth>(context, listen: false).generatePin(_identity);
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Verification(), settings: RouteSettings(arguments: _identity)));
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
                        height: 100.0,
                      ),
                    ),
                    heading1(text: "Chamasoft", color: Theme.of(context).textSelectionHandleColor),
                    SizedBox(
                      height: 10,
                    ),
                    subtitle1(text: "Let's verify your identity first", color: Theme.of(context).textSelectionHandleColor),
                    subtitle2(text: "Enter your phone number or email address below", color: Theme.of(context).textSelectionHandleColor),
                    TextFormField(
                      enabled: _isFormInputEnabled,
                      decoration: InputDecoration(
                        hasFloatingPlaceholder: true,
                        labelText: 'Phone number or Email',
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Theme.of(context).hintColor,
                        //     width: 1.0,
                        //   ),
                        // ),
                      ),
                      validator: (value) {
                        if (!CustomHelper.validIdentity(value.trim())) {
                          return 'Enter valid email or phone number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _identity = value.trim();
                      },
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
                    textWithExternalLinks(color: Theme.of(context).textSelectionHandleColor, size: 12.0, textData: {
                      'By continuing you agree to our': {},
                      'terms & conditions': {
                        "url": () => launchURL('https://chamasoft.com/terms-and-conditions/'),
                        "color": primaryColor,
                        "weight": FontWeight.w500
                      },
                      'and': {},
                      'privacy policy.': {
                        "url": () => launchURL('https://chamasoft.com/terms-and-conditions/'),
                        "color": primaryColor,
                        "weight": FontWeight.w500
                      },
                    }),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
