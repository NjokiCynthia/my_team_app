import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/configure-preferences.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-contributions.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-loan-types.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dashed-divider.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../../configure-group.dart';
import 'list-accounts.dart';
import 'list-expenses.dart';
import 'list-fine-types.dart';
import 'list-members.dart';
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
          content: new Text("Are you sure you want to delete the group? You will lose all information regarding this group."),
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

  Future<void> fetchAccounts(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).temporaryFetchAccounts();
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListAccounts()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch accounts'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchAccounts(context);
          },
        ),
      );
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchContributions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchContributions();
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListContributions()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch contributions'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchAccounts(context);
          },
        ),
      );
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchExpenses(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchExpenses();
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListExpenses()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch expenses'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchAccounts(context);
          },
        ),
      );
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchFineTypes(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchFineTypes();
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListFineTypes()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch fine types'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchAccounts(context);
          },
        ),
      );
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchLoanTypes(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchLoanTypes();
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListLoanTypes()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch loan types'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchAccounts(context);
          },
        ),
      );
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchCurrencyOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchCurrencyOptions();
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch currencies'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchCurrencyOptions(context);
          },
        ),
      );

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchCountryOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchCountryOptions();
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateGroupProfile()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch countries'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchCountryOptions(context);
          },
        ),
      );
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchMembers(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchMembers();
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListMembers()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch members'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchAccounts(context);
          },
        ),
      );
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    setState(() {
      theme = themeChange.darkTheme ? "Dark" : "Light";
    });

    final group = Provider.of<Groups>(context);
    final currentGroup = group.getCurrentGroup();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Group Settings",
      ),
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 20.0, 20.0, 20.0),
                    child: group.getCurrentGroupDisplayAvatar() != null
                        ? new CachedNetworkImage(
                            imageUrl: group.getCurrentGroupDisplayAvatar(),
                            placeholder: (context, url) => const CircleAvatar(
                              radius: 45.0,
                              backgroundImage: const AssetImage('assets/no-user.png'),
                            ),
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                              radius: 45.0,
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
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
                        heading2(text: currentGroup.groupName, color: Theme.of(context).textSelectionHandleColor),
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
                                action: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      });
                                  await fetchCurrencyOptions(context);
                                  await fetchCountryOptions(context);
//                                  Navigator.pop(context);
                                },
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
                                    builder: (BuildContext context) => ConfigurePreferences(),
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
                  size: 32,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
                title: customTitle(
                  text: "Accounts",
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                subtitle: customTitle(
                  text: "Manage group deposit accounts",
                  textAlign: TextAlign.start,
                  fontSize: 13.0,
                  color: Theme.of(context).bottomAppBarColor,
                ),
                dense: true,
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  await fetchAccounts(context);
//                  Navigator.pop(context);
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
                  size: 32,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
                title: customTitle(
                  text: "Contributions",
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                subtitle: customTitle(
                  text: "Manage contributions",
                  textAlign: TextAlign.start,
                  fontSize: 13.0,
                  color: Theme.of(context).bottomAppBarColor,
                ),
                dense: true,
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  await fetchContributions(context);
//                  Navigator.pop(context);
                },
              ),
              DashedDivider(
                color: Color(0xFFECECEC),
                thickness: 1.0,
                height: 5.0,
              ),
//              ListTile(
//                leading: Icon(
//                  FontAwesome.file_text,
//                  size: 32,
//                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
//                ),
//                title: customTitle(
//                  text: "Expenses",
//                  fontWeight: FontWeight.w700,
//                  textAlign: TextAlign.start,
//                  color: Theme.of(context).textSelectionHandleColor,
//                ),
//                subtitle: customTitle(
//                  text: "Manage expense categories",
//                  textAlign: TextAlign.start,
//                  fontSize: 13.0,
//                  color: Theme.of(context).bottomAppBarColor,
//                ),
//                dense: true,
//                onTap: () async {
//                  showDialog(
//                      context: context,
//                      builder: (BuildContext context) {
//                        return Center(
//                          child: CircularProgressIndicator(),
//                        );
//                      });
//                  await fetchExpenses(context);
////                  Navigator.pop(context);
//                },
//              ),
//              DashedDivider(
//                color: Color(0xFFECECEC),
//                thickness: 1.0,
//                height: 5.0,
//              ),
//              ListTile(
//                leading: Icon(
//                  FontAwesome.file_text,
//                  size: 32,
//                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
//                ),
//                title: customTitle(
//                  text: "Fine Types",
//                  fontWeight: FontWeight.w700,
//                  textAlign: TextAlign.start,
//                  color: Theme.of(context).textSelectionHandleColor,
//                ),
//                subtitle: customTitle(
//                  text: "Manage group fine categories",
//                  textAlign: TextAlign.start,
//                  fontSize: 13.0,
//                  color: Theme.of(context).bottomAppBarColor,
//                ),
//                dense: true,
//                onTap: () async {
//                  showDialog(
//                      context: context,
//                      builder: (BuildContext context) {
//                        return Center(
//                          child: CircularProgressIndicator(),
//                        );
//                      });
//                  await fetchFineTypes(context);
//                  Navigator.pop(context);
//                },
//              ),
//              DashedDivider(
//                color: Color(0xFFECECEC),
//                thickness: 1.0,
//                height: 5.0,
//              ),
//              ListTile(
//                leading: Icon(
//                  FontAwesome.file_text,
//                  size: 32,
//                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
//                ),
//                title: customTitle(
//                  text: "Loan Types",
//                  fontWeight: FontWeight.w700,
//                  textAlign: TextAlign.start,
//                  color: Theme.of(context).textSelectionHandleColor,
//                ),
//                subtitle: customTitle(
//                  text: "Manage loan types offered by the group",
//                  textAlign: TextAlign.start,
//                  fontSize: 13.0,
//                  color: Theme.of(context).bottomAppBarColor,
//                ),
//                dense: true,
//                onTap: () async {
//                  showDialog(
//                      context: context,
//                      builder: (BuildContext context) {
//                        return Center(
//                          child: CircularProgressIndicator(),
//                        );
//                      });
//                  await fetchLoanTypes(context);
//                },
//              ),
//              DashedDivider(
//                color: Color(0xFFECECEC),
//                thickness: 1.0,
//                height: 5.0,
//              ),
//              ListTile(
//                leading: Icon(
//                  FontAwesome.file_text,
//                  size: 32,
//                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
//                ),
//                title: customTitle(
//                  text: "Income Categories",
//                  fontWeight: FontWeight.w700,
//                  textAlign: TextAlign.start,
//                  color: Theme.of(context).textSelectionHandleColor,
//                ),
//                subtitle: customTitle(
//                  text: "Manage income categories of the group",
//                  textAlign: TextAlign.start,
//                  fontSize: 13.0,
//                  color: Theme.of(context).bottomAppBarColor,
//                ),
//                dense: true,
//                onTap: () async {
//                  showDialog(
//                      context: context,
//                      builder: (BuildContext context) {
//                        return Center(
//                          child: CircularProgressIndicator(),
//                        );
//                      });
//                  await fetchLoanTypes(context);
//                },
//              ),
//              DashedDivider(
//                color: Color(0xFFECECEC),
//                thickness: 1.0,
//                height: 5.0,
//              ),
//              ListTile(
//                leading: Icon(
//                  FontAwesome.file_text,
//                  size: 32,
//                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
//                ),
//                title: customTitle(
//                  text: "Asset Categories",
//                  fontWeight: FontWeight.w700,
//                  textAlign: TextAlign.start,
//                  color: Theme.of(context).textSelectionHandleColor,
//                ),
//                subtitle: customTitle(
//                  text: "Manage asset categories of the group",
//                  textAlign: TextAlign.start,
//                  fontSize: 13.0,
//                  color: Theme.of(context).bottomAppBarColor,
//                ),
//                dense: true,
//                onTap: () async {
//                  showDialog(
//                      context: context,
//                      builder: (BuildContext context) {
//                        return Center(
//                          child: CircularProgressIndicator(),
//                        );
//                      });
//                  await fetchLoanTypes(context);
//                },
//              ),
//              DashedDivider(
//                color: Color(0xFFECECEC),
//                thickness: 1.0,
//                height: 5.0,
//              ),
//              ListTile(
//                leading: Icon(
//                  FontAwesome.file_text,
//                  size: 32,
//                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
//                ),
//                title: customTitle(
//                  text: "Group Roles",
//                  fontWeight: FontWeight.w700,
//                  textAlign: TextAlign.start,
//                  color: Theme.of(context).textSelectionHandleColor,
//                ),
//                subtitle: customTitle(
//                  text: "Manage group roles of the group",
//                  textAlign: TextAlign.start,
//                  fontSize: 13.0,
//                  color: Theme.of(context).bottomAppBarColor,
//                ),
//                dense: true,
//                onTap: () async {
//                  showDialog(
//                      context: context,
//                      builder: (BuildContext context) {
//                        return Center(
//                          child: CircularProgressIndicator(),
//                        );
//                      });
//                  await fetchLoanTypes(context);
//                },
//              ),
//              DashedDivider(
//                color: Color(0xFFECECEC),
//                thickness: 1.0,
//                height: 5.0,
//              ),
              ListTile(
                leading: Icon(
                  FontAwesome.file_text,
                  size: 32,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
                title: customTitle(
                  text: "Members",
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                subtitle: customTitle(
                  text: "Add or remove members of the group",
                  textAlign: TextAlign.start,
                  fontSize: 13.0,
                  color: Theme.of(context).bottomAppBarColor,
                ),
                dense: true,
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  await fetchMembers(context);
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
                  size: 32,
                  color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
                ),
                title: customTitle(
                  text: "Setup Group",
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                subtitle: customTitle(
                  text: "Temporary",
                  textAlign: TextAlign.start,
                  fontSize: 13.0,
                  color: Theme.of(context).bottomAppBarColor,
                ),
                dense: true,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ConfigureGroup(),
                  ));
                },
              ),
              DashedDivider(
                color: Color(0xFFECECEC),
                thickness: 1.0,
                height: 5.0,
              ),
              Visibility(
                visible: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: smallBadgeButtonWithIcon(
                      text: "Delete Group",
                      backgroundColor: Colors.red.withOpacity(0.2),
                      textColor: Colors.red,
                      buttonHeight: 36.0,
                      textSize: 15.0,
                      action: () => _deleteGroupDialog(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
