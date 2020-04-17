import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
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
                  heading1(
                      text: "Profile",
                      color: Theme.of(context).textSelectionHandleColor),
                  subtitle1(
                      text: "Fill details to complete\naccount setup",
                      color: Theme.of(context).textSelectionHandleColor),
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
                              icon: Icons.camera_alt,
                              backgroundColor: Colors.white.withOpacity(0.5),
                              textColor: Colors.blueGrey,
                              action: () {}),
                        )
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hasFloatingPlaceholder: true,
                      labelText: "First Name",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hasFloatingPlaceholder: true,
                      labelText: "Last Name",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  defaultButton(
                      context: context,
                      text: "Finish",
                      onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => MyGroups(),
                            ),
                          ))
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
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
