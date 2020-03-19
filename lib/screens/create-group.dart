import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class CreateGroup extends StatelessWidget {
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
                width: MediaQuery.of(context).size.width,
                decoration: primaryGradient(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heading1(text: "Create Group", color: Colors.blueGrey),
                    subtitle1(text: "Give your group a name", color: Colors.blueGrey),
                    SizedBox(height: 40,),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                      child: Image(
                        image:  AssetImage('assets/no-user.png'),
                        height: 80.0,
                      ),
                    ),
                    heading2(text: "Edwin Kapkei", color: Colors.blueGrey),
                    subtitle1(text: "+254 701 234 567", color: Colors.blueGrey[400]),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hasFloatingPlaceholder: true,
                        labelText: 'Group name',
                      ),
                    ),
                    SizedBox(height: 24,),
                    defaultButton(
                      context: context,
                      text: "Continue",
                      onPressed: () => Navigator.pushReplacementNamed(context, '/configure-group'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 50.0,
              left: 20.0,
              child: screenActionButton(
                icon: LineAwesomeIcons.close,
                backgroundColor: Colors.blue.withOpacity(0.2),
                textColor: Colors.blue,
                action: () => Navigator.pushReplacementNamed(context, '/my-groups'),
              ),
            )
          ],
        ),
      ),
    );
  }
}