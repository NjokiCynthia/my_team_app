import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/create-group.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'chamasoft/models/investment-group.dart';

class MyGroups extends StatefulWidget {
  static const namedRoute = '/my-groups-screen';
  @override
  _MyGroupsState createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
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
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        decoration: primaryGradient(context),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              heading1(
                  text: "My Groups",
                  color: Theme.of(context).textSelectionHandleColor),
              subtitle1(
                  text: "All groups I belong to",
                  color: Theme.of(context).textSelectionHandleColor),
              SizedBox(
                height: 32,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Image(
                  image: AssetImage('assets/no-user.png'),
                  height: 80.0,
                ),
              ),
              heading2(
                  text: auth.userName,
                  color: Theme.of(context).textSelectionHandleColor),
              subtitle1(
                  text: auth.phoneNumber, //auth.phoneNumber,
                  color: Theme.of(context)
                      .textSelectionHandleColor
                      .withOpacity(0.6)),
              SizedBox(
                height: 20,
              ),
              groupInfoButton(
                context: context,
                leadingIcon: LineAwesomeIcons.plus,
                trailingIcon: LineAwesomeIcons.angle_right,
                hideTrailingIcon: true,
                backgroundColor: primaryColor.withOpacity(0.2),
                title: "ADD NEW GROUP",
                subtitle: "Chairperson",
                textColor: primaryColor,
                borderColor: primaryColor,
                action: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CreateGroup(),
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: auth.groups.length,
                  itemBuilder: (context, index) {
                    InvestmentGroup groupModel = auth.groups[index];
                    return groupInfoButton(
                      context: context,
                      leadingIcon: LineAwesomeIcons.group,
                      trailingIcon: LineAwesomeIcons.angle_right,
                      backgroundColor: primaryColor.withOpacity(0.2),
                      title: "${groupModel.name}",
                      subtitle: "${groupModel.size} Members",
                      description: "${groupModel.role}",
                      textColor: Colors.blueGrey,
                      borderColor: Colors.blueGrey.withOpacity(0.2),
                      action: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ChamasoftDashboard(),
                        ),
                      ),
                    );
                  }),
              SizedBox(
                height: 32,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).logout();
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
