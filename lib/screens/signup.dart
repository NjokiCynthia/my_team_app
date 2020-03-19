import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.all(40.0),
              height: MediaQuery.of(context).size.height,
              decoration: primaryGradient(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  heading1(text: "Profile", color: Colors.blueGrey),
                  subtitle2(
                      text: "Fill details to complete account setup",
                      color: Colors.blueGrey),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/no-user.png'),
                          height: 100,
                        ),
                        Positioned(
                          height: 32,
                          width: 32,
                          child: screenActionButton(
                              icon: LineAwesomeIcons.camera,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              action: () => Navigator.pushReplacementNamed(
                                  context, '/verification')),
                        )
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hasFloatingPlaceholder: true, labelText: "First Name"),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hasFloatingPlaceholder: true, labelText: "Last Name"),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  defaultButton(
                      context: context,
                      text: "Finish",
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/my-groups'))
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: screenActionButton(
                icon: LineAwesomeIcons.arrow_left,
                backgroundColor: Colors.blue.withOpacity(0.2),
                textColor: Colors.blue,
                action: () =>
                    Navigator.pushReplacementNamed(context, '/verification')),
          )
        ],
      )),
    );
  }
}
