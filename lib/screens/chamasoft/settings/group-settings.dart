import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/configure-preferences.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-asset-categories.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-contributions.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-income-categories.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-loan-types.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dashed-divider.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'list-accounts.dart';
import 'list-expense-categories.dart';
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
          content: new Text(
              "Are you sure you want to delete the group? You will lose all information regarding this group."),
          actions: <Widget>[
            // ignore: deprecated_member_use
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
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
      await Provider.of<Groups>(context, listen: false)
          .temporaryFetchAccounts();
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ListAccounts()));
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
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchContributions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchContributions();
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ListContributions()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch contributions'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchContributions(context);
          },
        ),
      );
      Navigator.pop(context);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchExpenseCategories(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchExpenseCategories();
      Navigator.pop(context);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ListExpenseCategories()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch expenses'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchExpenseCategories(context);
          },
        ),
      );
      Navigator.pop(context);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchFineTypes(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchFineTypes();
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ListFineTypes()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch fine types'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchFineTypes(context);
          },
        ),
      );
      Navigator.pop(context);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchIncomeCategories(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchDetailedIncomeCategories();
      Navigator.pop(context);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ListIncomeCategories()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch fine types'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchIncomeCategories(context);
          },
        ),
      );
      Navigator.pop(context);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchAssetCategories(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchAssetCategories();
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ListAssetCategories()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch fine types'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchIncomeCategories(context);
          },
        ),
      );
      Navigator.pop(context);
      // ignore: deprecated_member_use
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

      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchCountryOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchCountryOptions();
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UpdateGroupProfile()));
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
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchMembers(BuildContext context, String groupId) async {
    try {
      await Provider.of<Groups>(context, listen: false).getGroupMembersDetails(groupId);
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ListMembers(groupId: groupId)));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch members'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchMembers(context, groupId);
          },
        ),
      );
      Navigator.pop(context);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

   Future<void> fetchLoanTypes(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchLoanTypes();
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ListLoanTypes()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch loan types'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchLoanTypes(context);
          },
        ),
      );
      Navigator.pop(context);
      // ignore: deprecated_member_use
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
                              backgroundImage:
                                  const AssetImage('assets/no-user.png'),
                            ),
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                              radius: 45.0,
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              backgroundImage:
                                  const AssetImage('assets/no-user.png'),
                              radius: 45.0,
                            ),
                            fadeOutDuration: const Duration(seconds: 1),
                            fadeInDuration: const Duration(seconds: 3),
                          )
                        : const CircleAvatar(
                            backgroundImage:
                                const AssetImage('assets/no-user.png'),
                            radius: 45.0,
                          ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        heading2(
                            text: currentGroup.groupName,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
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
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Padding(
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
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
//               ListTile(
//                 leading: Icon(
//                   FontAwesome.file_text,
//                   size: 32,
//                   color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
//                 ),
//                 title: customTitle(
//                   text: "E-Wallet",
//                   fontWeight: FontWeight.w700,
//                   textAlign: TextAlign.start,
//                   color: Theme.of(context).textSelectionHandleColor,
//                 ),
//                 subtitle: customTitle(
//                   text: "Manage E-Wallet account",
//                   textAlign: TextAlign.start,
//                   fontSize: 13.0,
//                   color: Theme.of(context).bottomAppBarColor,
//                 ),
//                 dense: true,
//                 onTap: () /*async*/ {
// //                   showDialog(
// //                       context: context,
// //                       builder: (BuildContext context) {
// //                         return Center(
// //                           child: CircularProgressIndicator(),
// //                         );
// //                       });
// //                   await fetchAccounts(context);
// // //                  Navigator.pop(context);
//                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageEWallet()));
//                 },
//               ),
//               DashedDivider(
//                 color: Theme.of(context).dividerColor,
//                 thickness: 1.0,
//                 height: 5.0,
//               ),
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
                  // ignore: deprecated_member_use
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
                color: Theme.of(context).dividerColor,
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
                  // ignore: deprecated_member_use
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
                },
              ),
              DashedDivider(
                color: Theme.of(context).dividerColor,
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
                  text: "Members",
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  // ignore: deprecated_member_use
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
                  await fetchMembers(context, currentGroup.groupId);
                },
              ),
              DashedDivider(
                color: Theme.of(context).dividerColor,
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
                  text: "Expense Categories",
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                subtitle: customTitle(
                  text: "Manage expense categories",
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
                  await fetchExpenseCategories(context);
//                  Navigator.pop(context);
                },
              ),
              DashedDivider(
                color: Theme.of(context).dividerColor,
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
                  text: "Fine Types",
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                subtitle: customTitle(
                  text: "Manage group fine categories",
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
                  await fetchFineTypes(context);
                },
              ),
              DashedDivider(
                color: Theme.of(context).dividerColor,
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
                  text: "Loan Types",
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                subtitle: customTitle(
                  text: "Manage loan types offered by the group",
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
                  await fetchLoanTypes(context);
                },
              ),
              DashedDivider(
                color: Theme.of(context).dividerColor,
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
                  text: "Income Categories",
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                subtitle: customTitle(
                  text: "Manage group income categories",
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
                  await fetchIncomeCategories(context);
                },
              ),
              DashedDivider(
                color: Theme.of(context).dividerColor,
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
                  text: "Asset Categories",
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                subtitle: customTitle(
                  text: "Manage group asset categories",
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
                  await fetchAssetCategories(context);
                },
              ),
              DashedDivider(
                color: Theme.of(context).dividerColor,
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
//                   color: Theme.of(context).dividerColor,
//                thickness: 1.0,
//                height: 5.0,
//              ),

              // ListTile(
              //   leading: Icon(
              //     FontAwesome.file_text,
              //     size: 32,
              //     color: Theme.of(context).bottomAppBarColor.withOpacity(0.6),
              //   ),
              //   title: customTitle(
              //     text: "Setup Group",
              //     fontWeight: FontWeight.w700,
              //     textAlign: TextAlign.start,
              //     color: Theme.of(context).textSelectionHandleColor,
              //   ),
              //   subtitle: customTitle(
              //     text: "Temporary",
              //     textAlign: TextAlign.start,
              //     fontSize: 13.0,
              //     color: Theme.of(context).bottomAppBarColor,
              //   ),
              //   dense: true,
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (BuildContext context) => ConfigureGroup(),
              //     ));
              //   },
              // ),
              // DashedDivider(
              //   color: Theme.of(context).dividerColor,
              //   thickness: 1.0,
              //   height: 5.0,
              // ),
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
