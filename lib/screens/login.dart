import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(40.0),
            height: MediaQuery.of(context).size.height,
            decoration: primaryGradient(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: Image(
                    image:  AssetImage('assets/cs.png'),
                    height: 100.0,
                  ),
                ),
                heading1(text: "Chamasoft"),
                subtitle1(text: "Let's verify your identity first"),
                subtitle2(text: "Enter your phone number or email address below"),
                TextFormField(
                  decoration: InputDecoration(
                    hasFloatingPlaceholder: true,
                    // hintText: 'Phone Number or Email Address',
                    labelText: 'Phone or Email',
                  ),
                ),
                SizedBox(height: 24,),
                defaultButton(
                  context: context,
                  text: "Continue",
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
                SizedBox(height: 24,),
                textWithExternalLinks(
                  color: Colors.blueGrey,
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