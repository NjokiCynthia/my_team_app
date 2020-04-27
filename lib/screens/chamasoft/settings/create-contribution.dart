import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/dashed-divider.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'setup-lists/contribution-setup-list.dart';

List<NamesListItem> fineTypesList = [
  NamesListItem(id: 1, name: "Fixed"),
  NamesListItem(id: 2, name: "Percentage"),
  NamesListItem(id: 3, name: "Compounded"),
];

List<NamesListItem> fineFrequenciesList = [
  NamesListItem(id: 1, name: "Daily"),
  NamesListItem(id: 2, name: "Monthly"),
  NamesListItem(id: 3, name: "Annually"),
];

List<NamesListItem> fineFrequencyChargedOnList = [
  NamesListItem(id: 1, name: "Contribution Balance"),
  NamesListItem(id: 2, name: "Contribution"),
  NamesListItem(id: 3, name: "Total Unpaid Balance"),
];

final List<MembersFilterEntry> _membersList = <MembersFilterEntry>[
  MembersFilterEntry('Peter Kimutai', 'PK', '+254 725 854 025', amount: 2500.0),
  MembersFilterEntry('Samuel Wahome', 'SW', '+254 725 854 025', amount: 5820.0),
  MembersFilterEntry('Edwin Kapkei', 'EK', '+254 725 854 025', amount: 7800.0),
  MembersFilterEntry('Geoffrey Githaiga', 'GG', '+254 725 854 025',
      amount: 6000.0),
  MembersFilterEntry('Peter Dragon', 'PD', '+254 725 854 025', amount: 2500.0),
  MembersFilterEntry('Samson Mburu', 'SM', '+254 725 854 025', amount: 5820.0),
  MembersFilterEntry('Kevin Njoroge', 'KN', '+254 725 854 025', amount: 7800.0),
  MembersFilterEntry('Lois Nduku', 'LN', '+254 725 854 025', amount: 6000.0),
  MembersFilterEntry('Alex Dragon', 'PD', '+254 725 854 025', amount: 2500.0),
  MembersFilterEntry('Benson Mburu', 'SM', '+254 725 854 025', amount: 5820.0),
  MembersFilterEntry('Jane Njoroge', 'KN', '+254 725 854 025', amount: 7800.0),
  MembersFilterEntry('Mary Nduku', 'LN', '+254 725 854 025', amount: 6000.0),
];

List<NamesListItem> daysOfMonthList = [];

class CreateContribution extends StatefulWidget {
  @override
  _CreateContributionState createState() => _CreateContributionState();
}

class _CreateContributionState extends State<CreateContribution>
    with SingleTickerProviderStateMixin {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [];
  int memberTypeId;
  TabController _tabController;

  int selectedTabIndex = 0;
  int contributionTypeId;
  int dayOfMonthId;
  int fineTypeId;
  int fineFrequencyIid;
  int fineFrequencyChargedOnId;
  double contributionAmount = 0;
  double fineAmount = 0;
  String contributionName = '';
  bool selectAll = false;
  bool fineSettingsEnabled = false;
  int weekdayId;
  int contributionFrequencyId;

  int startingMonthId;

  int weekNumberId;

  int twoWeekdayId;

  int dateOfMonthId;

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
    _tabController = TabController(vsync: this, length: 3);
    String trail;
    daysOfMonthList.clear();
    for (int i = 1; i <= 31; i++) {
      trail = 'th';
      if (i % 10 == 1 && i != 11) {
        trail = 'st';
      } else if (i % 10 == 2 && i != 12) {
        trail = 'nd';
      } else if (i % 10 == 3 && i != 13) {
        trail = 'rd';
      }
      setState(() {
        daysOfMonthList.add(NamesListItem(id: i, name: "Every $i$trail"));
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: secondaryPageTabbedAppbar(
          context: context,
          title: "Create Contribution",
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          bottom: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                child: Divider(
                  thickness: 5.0,
                  color:
                      selectedTabIndex == 0 ? primaryColor : Color(0xFFAEAEAE),
                ),
              ),
              Tab(
                child: Divider(
                  thickness: 5.0,
                  color:
                      selectedTabIndex == 1 ? primaryColor : Color(0xFFAEAEAE),
                ),
              ),
              Tab(
                child: Divider(
                  thickness: 5.0,
                  color:
                      selectedTabIndex == 2 ? primaryColor : Color(0xFFAEAEAE),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Settings",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Configure the behaviour of your contribution",
                      style:
                          TextStyle(color: Theme.of(context).bottomAppBarColor),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomDropDownButton(
                              labelText: "Select Contribution Type",
                              listItems: contributionTypeOptions,
                              selectedItem: contributionTypeId,
                              onChanged: (value) {
                                setState(() {
                                  contributionTypeId = value;
                                });
                              },
                            ),
                            Visibility(
                              visible: contributionTypeId == 1,
                              child: CustomDropDownButton(
                                labelText: "Select Frequency",
                                listItems: getContributionFrequencyOptions,
                                selectedItem: contributionFrequencyId,
                                onChanged: (value) {
                                  setState(() {
                                    contributionFrequencyId = value;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: contributionFrequencyId == 1 ||
                                  contributionFrequencyId == 2 ||
                                  contributionFrequencyId == 3 ||
                                  contributionFrequencyId == 4 ||
                                  contributionFrequencyId == 5 ||
                                  contributionFrequencyId == 9,
                              child: CustomDropDownButton(
                                labelText: "Select Day of Month",
                                listItems: getDaysOfTheMonth,
                                selectedItem: dateOfMonthId,
                                onChanged: (value) {
                                  setState(() {
                                    dateOfMonthId = value;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: contributionFrequencyId == 7,
                              child: CustomDropDownButton(
                                labelText: "Select Day of Week",
                                listItems: getEveryTwoWeekDays,
                                selectedItem: twoWeekdayId,
                                onChanged: (value) {
                                  setState(() {
                                    twoWeekdayId = value;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: contributionFrequencyId == 6,
                              child: CustomDropDownButton(
                                labelText: "Select Day of Month",
                                listItems: getWeekDays,
                                selectedItem: dayOfMonthId,
                                onChanged: (value) {
                                  setState(() {
                                    dayOfMonthId = value;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: (dateOfMonthId != null &&
                                          dateOfMonthId > 0 &&
                                          dayOfMonthId <= 4 ||
                                      dateOfMonthId == 32) &&
                                  (contributionFrequencyId != 6 &&
                                      contributionFrequencyId != 7 &&
                                      contributionFrequencyId != 8),
                              child: CustomDropDownButton(
                                labelText: "Select Day of Week",
                                listItems: getMonthDays,
                                selectedItem: weekdayId,
                                onChanged: (value) {
                                  setState(() {
                                    weekdayId = value;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: contributionFrequencyId == 2 ||
                                  contributionFrequencyId == 3 ||
                                  contributionFrequencyId == 4 ||
                                  contributionFrequencyId == 5 ||
                                  contributionFrequencyId == 9,
                              child: CustomDropDownButton(
                                labelText: "Starting Month",
                                listItems: getStartingMonths,
                                selectedItem: startingMonthId,
                                onChanged: (value) {
                                  setState(() {
                                    startingMonthId = value;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: contributionFrequencyId == 7,
                              child: CustomDropDownButton(
                                labelText: "Select Week",
                                listItems: getWeekNumbers,
                                selectedItem: weekNumberId,
                                onChanged: (value) {
                                  setState(() {
                                    weekNumberId = value;
                                  });
                                },
                              ),
                            ),
                            simpleTextInputField(
                              context: context,
                              labelText: 'Contribution Name',
                              hintText: 'Monthly Contributions'.toUpperCase(),
                              onChanged: (value) {
                                setState(() {
                                  contributionName = value;
                                });
                              },
                            ),
                            amountTextInputField(
                              context: context,
                              labelText: 'Contribution Amount',
                              hintText: '1,500',
                              onChanged: (value) {
                                setState(() {
                                  contributionAmount = double.parse(value);
                                });
                              },
                            ),
                          ]),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    color: primaryColor,
                    child: Text(
                      'Save & Continue',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Members",
                        style: TextStyle(
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        "Select members who will contribute",
                        style: TextStyle(
                            color: Theme.of(context).bottomAppBarColor),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Select All",
                        style: TextStyle(
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w500),
                      ),
                      value: selectAll,
                      onChanged: (value) {
                        setState(() {
                          selectAll = value;
                          if (selectAll) {
                            selectedMembersList.clear();
                            selectedMembersList.addAll(_membersList);
                          } else {
                            selectedMembersList.clear();
                          }
                        });
                      },
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _membersList.length,
                        separatorBuilder: (context, index) => DashedDivider(
                          thickness: 1.0,
                          color: Color(0xFFD4D4D4),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                            secondary: const Icon(Icons.person),
                            value: selectedMembersList
                                .contains(_membersList[index]),
                            onChanged: (value) {
                              setState(() {
                                if (value) {
                                  selectedMembersList.add(_membersList[index]);
                                } else {
                                  selectedMembersList
                                      .remove(_membersList[index]);
                                }
                              });
                            },
                            title: Text(_membersList[index].name),
                            subtitle: Text(_membersList[index].phoneNumber),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {},
                          color: primaryColor,
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          color: primaryColor,
                          child: Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Fines",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Select Fines for Late Members",
                      style:
                          TextStyle(color: Theme.of(context).bottomAppBarColor),
                    ),
                  ),
                  SwitchListTile(
                    title: Text(
                      "Activate Fine Settings",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w500),
                    ),
                    value: fineSettingsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        fineSettingsEnabled = value;
                      });
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomDropDownButton(
                              labelText: "Select Fine Type",
                              listItems: fineTypesList,
                              selectedItem: fineTypeId,
                              onChanged: (value) {
                                setState(() {
                                  fineTypeId = value;
                                });
                              },
                            ),
                            CustomDropDownButton(
                              labelText: "Select Fine Frequency",
                              listItems: fineFrequenciesList,
                              selectedItem: fineFrequencyIid,
                              onChanged: (value) {
                                setState(() {
                                  fineFrequencyIid = value;
                                });
                              },
                            ),
                            CustomDropDownButton(
                              labelText: "Select Fine Frequency Charged On",
                              listItems: fineFrequencyChargedOnList,
                              selectedItem: fineFrequencyChargedOnId,
                              onChanged: (value) {
                                setState(() {
                                  fineFrequencyChargedOnId = value;
                                });
                              },
                            ),
                            amountTextInputField(
                              context: context,
                              labelText: 'Fine Amount',
                              hintText: '1,500',
                              onChanged: (value) {
                                setState(() {
                                  fineAmount = double.parse(value);
                                });
                              },
                            ),
                          ]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {},
                        color: primaryColor,
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        color: primaryColor,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
