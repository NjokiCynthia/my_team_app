import 'package:chamasoft/screens/configure-group.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

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
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.all(40.0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: primaryGradient(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heading1(text: "Create Group", color: Theme.of(context).textSelectionHandleColor),
                    subtitle1(text: "Give your group a name", color: Theme.of(context).textSelectionHandleColor),
                    SizedBox(height: 40,),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                      child: Image(
                        image:  AssetImage('assets/no-user.png'),
                        height: 80.0,
                      ),
                    ),
                    heading2(text: "Edwin Kapkei", color: Theme.of(context).textSelectionHandleColor),
                    subtitle1(text: "+254 701 234 567", color: Theme.of(context).textSelectionHandleColor.withOpacity(0.6)),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hasFloatingPlaceholder: true,
                        labelText: 'Group name',
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
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ConfigureGroup(),),),
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
                action: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MyGroups(),),),
              ),
            )
          ],
        ),
      ),
    );
  }
}