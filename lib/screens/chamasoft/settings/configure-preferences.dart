import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<NamesListItem> orderByFields = [
  NamesListItem(id: 1, name: "First Name"),
  NamesListItem(id: 2, name: "Last Name"),
  NamesListItem(id: 3, name: "Amount"),
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
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  int orderByFieldId;
  bool memberPrivacyEnabled = true;
  bool showContributionArrears = true;
  bool ignoringContributionTransfersEnabled = true;
  bool monthlyStatementsSendingEnabled = true;
  bool reducingBalanceRecalculationEnabled = true;

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
      body: SingleChildScrollView(
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
                        child: CustomDropDownButton(
                          labelText: "Order Members By",
                          listItems: orderByFields,
                          selectedItem: orderByFieldId,
                          onChanged: (value) {
                            setState(() {
                              orderByFieldId = value;
                            });
                          },
                        ),
                      ),
                      SwitchListTile(
                        title: Text(
                          "Member Information Privacy",
                          style: TextStyle(
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "If enabled, members will not view other members data",
                          style: TextStyle(
                              color: Theme.of(context).bottomAppBarColor),
                        ),
                        value: memberPrivacyEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            memberPrivacyEnabled = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          "Show Contribution Arrears",
                          style: TextStyle(
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "Show or hide unpaid balances",
                          style: TextStyle(
                              color: Theme.of(context).bottomAppBarColor),
                        ),
                        value: showContributionArrears,
                        onChanged: (bool value) {
                          setState(() {
                            showContributionArrears = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          "Enable Ignoring of Contribution Transfer",
                          style: TextStyle(
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "If enabled, members will not view other members data",
                          style: TextStyle(
                              color: Theme.of(context).bottomAppBarColor),
                        ),
                        value: ignoringContributionTransfersEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            ignoringContributionTransfersEnabled = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          "Send Monthly Statementts to Members",
                          style: TextStyle(
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "If enabled, members will not view other members data",
                          style: TextStyle(
                              color: Theme.of(context).bottomAppBarColor),
                        ),
                        value: monthlyStatementsSendingEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            monthlyStatementsSendingEnabled = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          "Absolute Reducing Balance Loan\nRecalculation",
                          style: TextStyle(
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "If enabled, members will not view other members data",
                          style: TextStyle(
                              color: Theme.of(context).bottomAppBarColor),
                        ),
                        value: reducingBalanceRecalculationEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            reducingBalanceRecalculationEnabled = value;
                          });
                        },
                      ),
                    ]),
              ),
            ],
          )),
    );
  }
}
