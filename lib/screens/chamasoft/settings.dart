import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'settings/group-settings.dart';
import 'settings/user-settings/update-profile.dart';

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
              child: new Text(
                "Cancel",
                style: TextStyle(color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
                child: new Text(
                  "Logout",
                  style: new TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  StatusHandler().logout(context);
                }

                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => Login(),
                //   ),
                // ),
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
    final group = Provider.of<Groups>(context, listen: false).getCurrentGroup();

    setState(() {
      theme = themeChange.darkTheme ? "Dark" : "Light";
    });
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Settings",
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
                  child: auth.displayAvatar != null
                      ? new CachedNetworkImage(
                          imageUrl: auth.displayAvatar,
                          placeholder: (context, url) => const CircleAvatar(
                            radius: 45.0,
                            backgroundImage: const AssetImage('assets/no-user.png'),
                          ),
                          imageBuilder: (context, image) => CircleAvatar(
                            backgroundImage: image,
                            radius: 45.0,
                          ),
                          errorWidget: (context, url, error) => const CircleAvatar(
                            backgroundImage: const AssetImage('assets/no-user.png'),
                            radius: 45.0,
                          ),
                          fadeOutDuration: const Duration(seconds: 1),
                          fadeInDuration: const Duration(seconds: 3),
                        )
                      : const CircleAvatar(
                          backgroundImage: const AssetImage('assets/no-user.png'),
                          radius: 45.0,
                        ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      heading2(text: auth.userName, color: Theme.of(context).textSelectionHandleColor),
                      subtitle2(text: auth.phoneNumber, color: Theme.of(context).textSelectionHandleColor),
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
                              builder: (BuildContext context) => UpdateProfile(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: group.isGroupAdmin,
              child: ListTile(
                title: Text("Group Settings",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Theme.of(context).textSelectionHandleColor,
                    )),
                subtitle: Text(
                  group.groupName,
                  style: TextStyle(color: Theme.of(context).bottomAppBarColor),
                ),
                trailing: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                  ),
                ),
                dense: true,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => GroupSettings(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: heading2(
                  text: "Preferences",
                  color: Colors.blueGrey,
                ),
              ),
            ),
            SwitchListTile(
              title: Text(
                "Push Notifications",
                style: TextStyle(color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                pushNotifications ? "Enabled" : "Disabled",
                style: TextStyle(color: Theme.of(context).bottomAppBarColor),
              ),
              value: pushNotifications,
              onChanged: (bool value) {
                setState(() {
                  pushNotifications = value;
                });
              },
            ),
            //tobe implemented in next phase
            // PopupMenuButton(
            //   child: ListTile(
            //     dense: true,
            //     title: Text(
            //       "Language",
            //       style: TextStyle(
            //         color: Theme.of(context).textSelectionHandleColor,
            //         fontWeight: FontWeight.w500,
            //         fontSize: 16.0,
            //       ),
            //     ),
            //     subtitle: Text(
            //       language,
            //       style: TextStyle(color: Theme.of(context).bottomAppBarColor),
            //     ),
            //     trailing: Padding(
            //       padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
            //       child: Icon(
            //         Icons.language,
            //         color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
            //       ),
            //     ),
            //   ),
            //   onSelected: (value) {
            //     setState(() {
            //       language = value;
            //     });
            //   },
            //   tooltip: "Language",
            //   offset: Offset.fromDirection(1.0),
            //   itemBuilder: (context) => [
            //     PopupMenuItem(
            //         value: "English",
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: <Widget>[
            //             Text("English", style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).indicatorColor)),
            //           ],
            //         )),
            //     PopupMenuItem(
            //         value: "Swahili",
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: <Widget>[
            //             Text("Swahili", style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).indicatorColor)),
            //           ],
            //         )),
            //   ],
            // ),
            PopupMenuButton(
              child: ListTile(
                dense: true,
                title: Text(
                  "Theme",
                  style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Text(
                  theme,
                  style: TextStyle(color: Theme.of(context).bottomAppBarColor),
                ),
                trailing: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                  child: Icon(
                    Icons.color_lens,
                    color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                  ),
                ),
              ),
              onSelected: (value) {
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
                        Text("Light",
                            style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).indicatorColor)),
                      ],
                    )),
                PopupMenuItem(
                    value: "Dark",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Icon(MaterialCommunityIcons.weather_night, color: Theme.of(context).indicatorColor),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 10.0)
                        // ),
                        Text("Dark",
                            style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).indicatorColor)),
                      ],
                    )),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: heading2(
                  text: "Help & Assistance",
                  color: Colors.blueGrey,
                ),
              ),
            ),
            ListTile(
              title: Text("Documentation & FAQ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
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
//            ListTile(
//              title: Text("Chat Support",
//                  style: TextStyle(
//                    fontWeight: FontWeight.w500,
//                    fontSize: 16,
//                    color: Theme.of(context).textSelectionHandleColor,
//                  )),
//              trailing: Padding(
//                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
//                child: Icon(
//                  Icons.chat,
//                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
//                ),
//              ),
//              dense: true,
//              onTap: () {},
//            ),
            ListTile(
              title: Text("Call Support",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
              trailing: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: Icon(
                  Icons.call,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
              ),
              dense: true,
              onTap: () {
                CustomHelper.callNumber("+254733366240");
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: heading2(
                  text: "About & Terms",
                  color: Colors.blueGrey,
                ),
              ),
            ),
            ListTile(
              title: Text("About Chamasoft",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
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
              title: Text("Terms & Conditions",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
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
              title: Text("E-Wallet Charges",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Theme.of(context).textSelectionHandleColor,
                  )),
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
              padding: EdgeInsets.only(
                top: 20.0,
              ),
              child: Align(
                alignment: Alignment.center,
                child: smallBadgeButton(
                  text: "Logout",
                  backgroundColor: Colors.red.withOpacity(0.2),
                  textColor: Colors.red,
                  buttonHeight: 36.0,
                  textSize: 15.0,
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
