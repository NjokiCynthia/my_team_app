import 'package:chamasoft/screens/verification.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

import 'chamasoft/apply-loan.dart';

DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String _logo = "cs.png";

  @override
  void initState() {
    (themeChangeProvider.darkTheme) ? _logo = "cs-alt.png" : _logo = "cs.png";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(40.0),
            height: MediaQuery.of(context).size.height,
            decoration: primaryGradient(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: Image(
                    image:  AssetImage('assets/$_logo'),
                    height: 100.0,
                  ),
                ),
                heading1(text: "Chamasoft", color: Theme.of(context).textSelectionHandleColor),
                subtitle1(text: "Let's verify your identity first", color: Theme.of(context).textSelectionHandleColor),
                subtitle2(text: "Enter your phone number or email address below", color: Theme.of(context).textSelectionHandleColor),
                TextFormField(
                  decoration: InputDecoration(
                    hasFloatingPlaceholder: true,
                    labelText: 'Phone or Email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).hintColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24,),
                defaultButton(
                  context: context,
                  text: "Continue",
                  onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ApplyLoan(),),),
                ),
                SizedBox(height: 24,),
                textWithExternalLinks(
                  color: Theme.of(context).textSelectionHandleColor,
                  size: 12.0,
                  textData: {
                    'By continuing you agree to our': {},
                    'terms & conditions': {
                      "url": () => launchURL('https://chamasoft.com/terms-and-conditions/'),
                      "color": Colors.blue,
                      "weight": FontWeight.w500
                    },
                    'and': {},
                    'privacy policy.': {
                      "url": () => launchURL('https://chamasoft.com/terms-and-conditions/'),
                      "color": Colors.blue,
                      "weight": FontWeight.w500
                    },
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}