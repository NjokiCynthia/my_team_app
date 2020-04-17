import 'package:chamasoft/screens/signup.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
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
    TextEditingController _pinEditingController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
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
                  subtitle1(
                      text: "A verification code has been sent to",
                      color: Theme.of(context).textSelectionHandleColor),
                  subtitle1(
                      text: "+254 701 234 567",
                      color: Theme.of(context).textSelectionHandleColor),
                  SizedBox(
                    height: 12,
                  ),
                  subtitle2(
                      text: "Enter your code here",
                      color: Theme.of(context).textSelectionHandleColor),
                  Padding(
                    padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                    child: PinInputTextField(
                      pinLength: 4,
                      decoration: UnderlineDecoration(
                        enteredColor: Colors.blue,
                        color: Theme.of(context).textSelectionHandleColor,
                        lineHeight: 2.0,
                        textStyle: TextStyle(
                          color: Colors.blue,
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
                      onSubmit: (pin) {
                        print('submit pin:$pin');
                      },
                      onChanged: (pin) {
                        print('onChanged execute. pin:$pin');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  defaultButton(
                    context: context,
                    text: "Verify Phone",
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SignUp(),
                      ),
                    ),
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
                          "color": Colors.blue,
                          "weight": FontWeight.w700
                        },
                      }),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50.0,
            left: 20.0,
            child: screenActionButton(
              icon: LineAwesomeIcons.arrow_left,
              backgroundColor: Colors.blue.withOpacity(0.2),
              textColor: Colors.blue,
              action: () => Navigator.of(context).pop(),
            ),
          )
        ],
      ),
    );
  }
}
