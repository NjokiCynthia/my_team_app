import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ChamasoftSettings extends StatefulWidget {
  @override
  _ChamasoftSettingsState createState() => _ChamasoftSettingsState();
}

class _ChamasoftSettingsState extends State<ChamasoftSettings> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  String theme = "Light";
  String language = "English";
  bool pushNotifications = true;

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Logout"),
          content: new Text("Are you sure you want to log out? You'll have to login again to continue."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel", style: TextStyle(color: Theme.of(context).textSelectionHandleColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Logout",style: new TextStyle(color: Colors.red),),
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Login(),),),
            ),
          ],
        );
      },
    );
  }

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            screenActionButton(
              icon: LineAwesomeIcons.arrow_left,
              backgroundColor: Colors.blue.withOpacity(0.1),
              textColor: Colors.blue,
              action: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChamasoftDashboard(),),),
            ),
            SizedBox(width: 20.0),
            heading2(color: Colors.blue, text: "Settings"),
          ],
        ),
        elevation: _appBarElevation,
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
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
                      heading2(text: "Edwin Kapkei", color: Theme.of(context).textSelectionHandleColor),
                      subtitle2(text: "+254 701 234 567", color: Theme.of(context).textSelectionHandleColor),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,),
                        child: smallBadgeButton(
                          text: "Update Profile",
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          buttonHeight: 30.0,
                          textSize: 12.0,
                          action: (){},),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text("Group Settings", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0, color: Theme.of(context).textSelectionHandleColor,)),
              subtitle: Text("Witcher Welfare Association", style: TextStyle(color: Theme.of(context).bottomAppBarColor),),
              trailing: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
              ),
              dense: true,
              onTap: () {},
            ),
            
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: heading2(text: "Preferences", color: Colors.blueGrey,),
              ),
            ),
            SwitchListTile(
              title: Text("Push Notifications", style: TextStyle(color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w500),),
              subtitle: Text(pushNotifications ? "Enabled":"Disabled", style: TextStyle(color: Theme.of(context).bottomAppBarColor),),
              value: pushNotifications ? true:false,
              onChanged: (bool value) {
                setState(() {
                  pushNotifications = value;
                });
              },
            ),
            PopupMenuButton(
              child: ListTile(
                dense: true,
                title: Text("Language", style: TextStyle(color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w500, fontSize: 16.0,),),
                subtitle: Text(language, style: TextStyle(color: Theme.of(context).bottomAppBarColor),),
                trailing: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                  child: Icon(
                    Icons.language,
                    color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                  ),
                ),
              ),
              onSelected: (value){
                setState(() {
                  language = value;
                });
              },
              tooltip: "Language",
              offset: Offset.fromDirection(1.0),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "English",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("English", style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).indicatorColor)),
                    ],
                  )
                ),
                PopupMenuItem(
                  value: "Swahili",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Swahili", style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).indicatorColor)),
                    ],
                  )
                ),
              ],
            ),
            PopupMenuButton(
              child: ListTile(
                dense: true,
                title: Text("Theme", style: TextStyle(color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w500, fontSize: 16.0,),),
                subtitle: Text(theme, style: TextStyle(color: Theme.of(context).bottomAppBarColor),),
                trailing: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                  child: Icon(
                    Icons.color_lens,
                    color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                  ),
                ),
              ),
              onSelected: (value){
                setState(() {
                  theme = value;
                  (theme == "Dark") ? themeChange.darkTheme = true : themeChange.darkTheme = false;
                });
              },
              tooltip: "Change theme",
              offset: Offset.fromDirection(1.0),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "Light",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Icon(MaterialCommunityIcons.weather_sunny, color: Theme.of(context).indicatorColor),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 10.0)
                      // ),
                      Text("Light", style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).indicatorColor)),
                    ],
                  )
                ),
                PopupMenuItem(
                  value: "Dark",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Icon(MaterialCommunityIcons.weather_night, color: Theme.of(context).indicatorColor),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 10.0)
                      // ),
                      Text("Dark", style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).indicatorColor)),
                    ],
                  )
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: heading2(text: "Help & Assistance", color: Colors.blueGrey,),
              ),
            ),
            ListTile(
              title: Text("Documentation & FAQ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Theme.of(context).textSelectionHandleColor,)),
              trailing: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: Icon(
                  Icons.link,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
              ),
              dense: true,
              onTap: () => launchURL("https://help.chamasoft.com/"),
            ),
            ListTile(
              title: Text("Chat Support", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Theme.of(context).textSelectionHandleColor,)),
              trailing: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: Icon(
                  Icons.chat,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
              ),
              dense: true,
              onTap: () {},
            ),
            ListTile(
              title: Text("Call Support", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Theme.of(context).textSelectionHandleColor,)),
              trailing: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: Icon(
                  Icons.call,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
              ),
              dense: true,
              onTap: () {},
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: heading2(text: "About & Terms", color: Colors.blueGrey,),
              ),
            ),
            ListTile(
              title: Text("About Chamasoft", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Theme.of(context).textSelectionHandleColor,)),
              trailing: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: Icon(
                  Icons.link,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
              ),
              dense: true,
              onTap: () => launchURL("https://chamasoft.com/company/about-chamasoft"),
            ),
            ListTile(
              title: Text("Terms & Conditions", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Theme.of(context).textSelectionHandleColor,)),
              trailing: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: Icon(
                  Icons.link,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
              ),
              dense: true,
              onTap: () => launchURL("https://chamasoft.com/terms-and-conditions"),
            ),
            ListTile(
              title: Text("E-Wallet Charges", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Theme.of(context).textSelectionHandleColor,)),
              trailing: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: Icon(
                  Icons.link,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
              ),
              dense: true,
              onTap: () => launchURL("https://chamasoft.com/"),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.0,),
              child: Align(
                alignment: Alignment.center,
                child: smallBadgeButton(
                  text: "Logout",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  buttonHeight: 32.0,
                  textSize: 12.0,
                  action: () => _logoutDialog(),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
