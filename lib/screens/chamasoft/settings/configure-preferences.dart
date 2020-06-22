import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/string-named-list-item.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/custom-dropdown-strings-only.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

List<StringNamesListItem> orderByFields = [
  StringNamesListItem(id: "users.first_name", name: "Member First Name"),
  StringNamesListItem(id: "users.last_name", name: "Member Last Name"),
  StringNamesListItem(id: "members.created_on", name: "Registration Date"),
  StringNamesListItem(
      id: "members.date_of_birth", name: "Member's Date of Birth"),
  StringNamesListItem(
      id: "members.membership_number", name: "Membership Number"),
];

List<StringNamesListItem> orderMembersDirection = [
  StringNamesListItem(
      id: "ASC",
      name: "Smallest to Largest (A-Z / Youngest to Oldest / 1-100)"),
  StringNamesListItem(
      id: "DESC",
      name: "Largest to Smallest (Z-A / Oldest to Youngest / 100-1)"),
];

class ConfigurePreferences extends StatefulWidget {
  @override
  _ConfigurePreferencesState createState() => _ConfigurePreferencesState();
}

class _ConfigurePreferencesState extends State<ConfigurePreferences> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [];
  int memberTypeId;

  String orderByFieldId;
  String selectedMemberOrderDirection;
  String errorText;
  bool memberPrivacyEnabled = true;
  bool showContributionArrears = true;
  bool ignoringContributionTransfersEnabled = true;
  bool monthlyStatementsSendingEnabled = true;
  bool reducingBalanceRecalculationEnabled = true;
  bool disableMemberEditProfile = true;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
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

    refreshSettings();

    super.initState();
  }

  void refreshSettings() {
    orderByFieldId = Provider.of<Groups>(context, listen: false)
        .getCurrentGroup()
        .memberListingOrderBy;
    selectedMemberOrderDirection = Provider.of<Groups>(context, listen: false)
        .getCurrentGroup()
        .orderMembersBy;
    memberPrivacyEnabled = Provider.of<Groups>(context, listen: false)
        .getCurrentGroup()
        .enableMemberInformationPrivacy;
    showContributionArrears = Provider.of<Groups>(context, listen: false)
        .getCurrentGroup()
        .disableArrears;
    ignoringContributionTransfersEnabled =
        Provider.of<Groups>(context, listen: false)
            .getCurrentGroup()
            .disableIgnoreContributionTransfers;
    monthlyStatementsSendingEnabled =
        Provider.of<Groups>(context, listen: false)
            .getCurrentGroup()
            .enableSendMonthlyEmailStatements;
    reducingBalanceRecalculationEnabled =
        Provider.of<Groups>(context, listen: false)
            .getCurrentGroup()
            .enableAbsoluteLoanRecalculation;
    disableMemberEditProfile = Provider.of<Groups>(context, listen: false)
        .getCurrentGroup()
        .disableMemberEditProfile;
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  Future<void> doUpdateSettings(BuildContext context) async {
    errorText = '';
    try {
      final response =
          await Provider.of<Groups>(context, listen: false).updateGroupSettings(
        orderMembersBy: selectedMemberOrderDirection,
        memberListingOrderBy: orderByFieldId,
        enableMemberInformationPrivacy: memberPrivacyEnabled ? "1" : "0",
        disableIgnoreContributionTransfers:
            ignoringContributionTransfersEnabled ? "1" : "0",
        disableArrears: showContributionArrears ? "1" : "0",
        enableSendMonthlyEmailStatements:
            monthlyStatementsSendingEnabled ? "1" : "0",
        disableMemberEditProfile: disableMemberEditProfile ? "1" : "0",
        enableAbsoluteLoanRecalculation:
            reducingBalanceRecalculationEnabled ? "1" : "0",
      );

      if (response['status'] == 1) {
        Navigator.of(context).pop();
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
          "You have successfully updated Group Settings",
        )));
      } else {
        errorText = response['message'];
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
          "Error updating Group Settings",
        )));
      }
    } on CustomException catch (error) {
      print(error.message);
      errorText = 'Network Error occurred: could not update group name';
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Configure Preferences",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                toolTip(
                    context: context,
                    title: "",
                    message:
                        "Configure the behaviour and settings for your group",
                    showTitle: false),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                          child: CustomDropDownStringOnlyButton(
                            labelText: "List Members By",
                            listItems: orderByFields,
                            selectedItem: orderByFieldId,
                            onChanged: (value) async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                              await doUpdateSettings(context);
                              setState(() {
                                orderByFieldId = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                          child: CustomDropDownStringOnlyButton(
                            labelText: "Order Members Direction",
                            listItems: orderMembersDirection,
                            selectedItem: selectedMemberOrderDirection,
                            onChanged: (value) async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                              await doUpdateSettings(context);
                              setState(() {
                                selectedMemberOrderDirection = value;
                              });
                            },
                          ),
                        ),
                        SwitchListTile(
                          title: Text(
                            "Member Information Privacy",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "If enabled, members will not view other members data",
                            style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor),
                          ),
                          value: memberPrivacyEnabled,
                          onChanged: (bool value) async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            await doUpdateSettings(context);
                            setState(() {
                              memberPrivacyEnabled = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "Show Contribution Arrears",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "Show or hide unpaid balances",
                            style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor),
                          ),
                          value: showContributionArrears,
                          onChanged: (bool value) async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            await doUpdateSettings(context);
                            setState(() {
                              showContributionArrears = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "Enable Ignoring of Contribution Transfer",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "If enabled, the contribution  transfers will be ignored",
                            style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor),
                          ),
                          value: ignoringContributionTransfersEnabled,
                          onChanged: (bool value) async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            await doUpdateSettings(context);
                            setState(() {
                              ignoringContributionTransfersEnabled = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "Send Monthly Statements to Members",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "If enabled, members will not view other members data",
                            style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor),
                          ),
                          value: monthlyStatementsSendingEnabled,
                          onChanged: (bool value) async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            await doUpdateSettings(context);
                            setState(() {
                              monthlyStatementsSendingEnabled = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "Absolute Reducing Balance Loan\nRecalculation",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "If enabled, members will not view other members data",
                            style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor),
                          ),
                          value: reducingBalanceRecalculationEnabled,
                          onChanged: (bool value) async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            await doUpdateSettings(context);
                            setState(() {
                              reducingBalanceRecalculationEnabled = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "Disable Member Edit Profile",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "If enabled, members will not update their profile",
                            style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor),
                          ),
                          value: disableMemberEditProfile,
                          onChanged: (bool value) async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            await doUpdateSettings(context);
                            setState(() {
                              disableMemberEditProfile = value;
                            });
                          },
                        ),
                      ]),
                ),
              ],
            ));
      }),
    );
  }
}
