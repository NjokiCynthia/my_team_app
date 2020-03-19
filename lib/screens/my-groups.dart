import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class MyGroups extends StatelessWidget {
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
                    heading1(text: "My Groups", color: Colors.blueGrey),
                    subtitle1(text: "All groups I belong to", color: Colors.blueGrey),
                    SizedBox(height: 32,),
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
                    groupInfoButton(
                      context: context,
                      leadingIcon: LineAwesomeIcons.plus,
                      trailingIcon: LineAwesomeIcons.angle_right,
                      hideTrailingIcon: true,
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      title: "ADD NEW GROUP",
                      subtitle: "Chairperson",
                      textColor: Colors.blue,
                      borderColor: Colors.blue,
                      action: () => Navigator.pushReplacementNamed(context, '/create-group'),
                    ),
                    SizedBox(height: 32,),
                    groupInfoButton(
                      context: context,
                      leadingIcon: LineAwesomeIcons.group,
                      trailingIcon: LineAwesomeIcons.angle_right,
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      title: "WITCHER WELFARE ASSOCIATION",
                      subtitle: "9 Members",
                      description: "Chairperson",
                      textColor: Colors.blueGrey,
                      borderColor: Colors.blueGrey.withOpacity(0.2),
                      action: (){},
                    ),
                    SizedBox(height: 12,),
                    groupInfoButton(
                      context: context,
                      leadingIcon: LineAwesomeIcons.group,
                      trailingIcon: LineAwesomeIcons.angle_right,
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      title: "DVEA WELFARE",
                      subtitle: "16 Members",
                      description: "Member",
                      textColor: Colors.blueGrey,
                      borderColor: Colors.blueGrey.withOpacity(0.2),
                      action: (){},
                    ),
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
                action: () => Navigator.pushReplacementNamed(context, '/signup'),
              ),
            )
          ],
        ),
      ),
    );
  }
}