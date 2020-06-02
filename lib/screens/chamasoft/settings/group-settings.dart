import 'package:chamasoft/screens/chamasoft/settings/configure-preferences.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-contributions.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-loan-types.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dashed-divider.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'list-bank-accounts.dart';
import 'update-group-profile.dart';

class GroupSettings extends StatefulWidget {
  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  String theme = "Light";
  String language = "English";
  bool pushNotifications = true;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  void _deleteGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Delete Group"),
          content: new Text(
              "Are you sure you want to delete the group? You will lose all information regarding this group."),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Delete",
                style: new TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    setState(() {
      theme = themeChange.darkTheme ? "Dark" : "Light";
    });

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Group Settings",
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 20.0, 20.0, 20.0),
                  child: Image(
                    image: AssetImage('assets/no-user.png'),
                    height: 80,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      heading2(
                          text: "Witcher Welfare Association",
                          color: Theme.of(context).textSelectionHandleColor),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: smallBadgeButton(
                              text: "Update Profile",
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              buttonHeight: 30.0,
                              textSize: 12.0,
                              action: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UpdateGroupProfile(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: smallBadgeButton(
                              text: "Preferences",
                              backgroundColor: Color(0xFFEDF8FE),
                              textColor: primaryColor,
                              buttonHeight: 30.0,
                              textSize: 12.0,
                              action: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ConfigurePreferences(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ListTile(
              leading: Icon(
                FontAwesome.file_text,
                size: 40,
              ),
              title: Text("Accounts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
              subtitle: Text(
                "Manage group deposit accounts",
                style: TextStyle(
                  color: Theme.of(context).bottomAppBarColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              dense: true,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListBankAccounts()));
              },
            ),
            DashedDivider(
              color: Color(0xFFECECEC),
              thickness: 1.0,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(
                FontAwesome.file_text,
                size: 40,
              ),
              title: Text("Contributions",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
              subtitle: Text(
                "Manage contributions",
                style: TextStyle(
                  color: Theme.of(context).bottomAppBarColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              dense: true,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListContributions()));
              },
            ),
            DashedDivider(
              color: Color(0xFFECECEC),
              thickness: 1.0,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(
                FontAwesome.file_text,
                size: 40,
              ),
              title: Text("Expenses",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
              subtitle: Text(
                "Manage expense categories",
                style: TextStyle(
                  color: Theme.of(context).bottomAppBarColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              dense: true,
              onTap: () {},
            ),
            DashedDivider(
              color: Color(0xFFECECEC),
              thickness: 1.0,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(
                FontAwesome.file_text,
                size: 40,
              ),
              title: Text("Fine Types",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
              subtitle: Text(
                "Manage group fine categories",
                style: TextStyle(
                  color: Theme.of(context).bottomAppBarColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              dense: true,
              onTap: () {},
            ),
            DashedDivider(
              color: Color(0xFFECECEC),
              thickness: 1.0,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(
                FontAwesome.file_text,
                size: 40,
              ),
              title: Text("Loan Types",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
              subtitle: Text(
                "Manage loan types offered by the group",
                style: TextStyle(
                  color: Theme.of(context).bottomAppBarColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              dense: true,
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ListLoanTypes()));
              },
            ),
            DashedDivider(
              color: Color(0xFFECECEC),
              thickness: 1.0,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(
                FontAwesome.file_text,
                size: 40,
              ),
              title: Text("Members",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
              subtitle: Text(
                "Add or remove members of the group",
                style: TextStyle(
                  color: Theme.of(context).bottomAppBarColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              dense: true,
              onTap: () {},
            ),
            DashedDivider(
              color: Color(0xFFECECEC),
              thickness: 1.0,
              height: 5.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
              ),
              child: Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    "Delete Group".toUpperCase(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () => _deleteGroupDialog(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
