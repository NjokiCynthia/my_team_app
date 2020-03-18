import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class Verification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _pinEditingController = TextEditingController();
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
                heading1(text: "Verification"),
                subtitle1(text: "A verification code has been sent to"),
                subtitle1(text: "+254 701 234 567"),
                SizedBox(height: 12,),
                subtitle2(text: "Enter your code here"),
                PinInputTextField(
                  pinLength: 4,
                  decoration: UnderlineDecoration(
                    enteredColor: Colors.blue,
                    textStyle: TextStyle(
                      color: Colors.blue
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
                SizedBox(height: 24,),
                defaultButton(
                  context: context,
                  text: "Verify Phone",
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
                SizedBox(height: 24,),
                textWithExternalLinks(
                  color: Colors.blueGrey,
                  size: 12.0,
                  textData: {
                    "Didn't receive verification code?": {},
                    'Resend': {
                      "url": () => print("Resending now..."),
                      "color": Colors.blue,
                      "weight": FontWeight.w700
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