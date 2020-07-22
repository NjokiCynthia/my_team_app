import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/settings/setup-lists/fine-setup-list.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/custom-dropdown-strings-only.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/dashed-divider.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'list-accounts.dart';
import 'setup-lists/contribution-setup-list.dart';

List<NamesListItem> fineTypesList = [
  NamesListItem(id: 1, name: "Fixed Amount Fine Of"),
  NamesListItem(id: 2, name: "Percentage Rate Fine of"),
];

List<NamesListItem> fineForList = [
  NamesListItem(id: 1, name: "for each unpaid contribution"),
  NamesListItem(id: 2, name: "for outstanding balance"),
];

final List<MembersFilterEntry> _membersList = <MembersFilterEntry>[];

List<NamesListItem> daysOfMonthList = [];

class CreateContribution extends StatefulWidget {
  @override
  _CreateContributionState createState() => _CreateContributionState();
}

class _CreateContributionState extends State<CreateContribution>
    with SingleTickerProviderStateMixin {
  double _appBarElevation = 0;
  List<MembersFilterEntry> selectedMembersList = [];
  final _contributionFormKey = GlobalKey<FormState>();
  final _fineFormKey = GlobalKey<FormState>();

  PageController _pageController;
  int selectedTabIndex = 0;
  bool selectAll = false;
  int currentPage = 0;

  double contributionAmount = 0;
  int startingMonthId;
  int dayOfMonthId;
  String contributionName = '';
  int contributionTypeId;

  int weekdayId;
  int weekNumberId;
  int twoWeekdayId;
  int dateOfMonthId;

  int contributionFrequencyId;

  int memberTypeId;

  bool fineSettingsEnabled = false;
  int fineTypeId;
  int fineFrequencyIid;
  int fineFrequencyChargedOnId;
  double fineAmount = 0;
  int fineForId;
  int fineLimitId;
  String fineChargeableOn;
  int percentageFineOptionId;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> createContribution(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false)
          .createContributionSetting(
        name: contributionName,
        amount: contributionAmount.toString(),
        oneTimeInvoicingActive: "",
        accountType: "",
        regularInvoicingActive: "",
        weekNumberFortnight: weekNumberId.toString(),
        weekDayMultiple: weekdayId.toString(),
        weekDayFortninght: twoWeekdayId.toString(),
        weekDayWeekly: weekdayId.toString(),
        weekDayMonthly: weekdayId.toString(),
        monthDayMonthly: dayOfMonthId.toString(),
        invoiceDays: "",
        contributionFrequency: contributionFrequencyId.toString(),
        contributionDate: "",
        invoiceDate: "",
      );

      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully added a Bank Account",
      )));
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => ListAccounts()));
    } on CustomException catch (error) {
      Navigator.pop(context);

      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "Error Adding the Bank Account. ${error.message} ",
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageTabbedAppbar(
        context: context,
        title: "Create Contribution",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Divider(
                        thickness: 5.0,
                        indent: 10,
                        endIndent: 10,
                        color:
                            currentPage == 0 ? primaryColor : Color(0xFFAEAEAE),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Divider(
                        thickness: 5.0,
                        indent: 10,
                        endIndent: 10,
                        color:
                            currentPage == 1 ? primaryColor : Color(0xFFAEAEAE),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Divider(
                        thickness: 5.0,
                        indent: 10,
                        endIndent: 10,
                        color:
                            currentPage == 2 ? primaryColor : Color(0xFFAEAEAE),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    height: MediaQuery.of(context).size.height,
                    child: Form(
                      key: _contributionFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "Settings",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textSelectionHandleColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              "Configure the behaviour of your contribution",
                              style: TextStyle(
                                  color: Theme.of(context).bottomAppBarColor),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      simpleTextInputField(
                                        context: context,
                                        labelText: 'Contribution Name',
                                        hintText: 'Monthly Contributions'
                                            .toUpperCase(),
                                        validator: (value) {
                                          if (value.length < 1)
                                            return 'Invalid Contribution Name';
                                          else
                                            return null;
                                        },
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
                                        validator: (value) {
                                          if (double.parse(value) < 0)
                                            return 'Invalid contribution Amount';
                                          else
                                            return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            contributionAmount =
                                                double.parse(value);
                                          });
                                        },
                                      ),
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
                                          listItems:
                                              getContributionFrequencyOptions,
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
                                                    (dateOfMonthId == 1 ||
                                                        dateOfMonthId == 2 ||
                                                        dateOfMonthId == 3 ||
                                                        dayOfMonthId == 4) ||
                                                dateOfMonthId == 32) &&
                                            (contributionFrequencyId != 6 &&
                                                contributionFrequencyId != 7 &&
                                                contributionFrequencyId != 8),
                                        child: CustomDropDownButton(
                                          labelText: "Select Day of the Month",
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
                                    ]),
                              ),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              if (_contributionFormKey.currentState
                                  .validate()) {
                                await createContribution(context);
                              }

                              if (_pageController.hasClients) {
                                _pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }

                              setState(() {
                                currentPage = 1;
                              });
                            },
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
                                  color: Theme.of(context)
                                      .textSelectionHandleColor,
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
                                  color: Theme.of(context)
                                      .textSelectionHandleColor,
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
                              separatorBuilder: (context, index) =>
                                  DashedDivider(
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
                                        selectedMembersList
                                            .add(_membersList[index]);
                                      } else {
                                        selectedMembersList
                                            .remove(_membersList[index]);
                                      }
                                    });
                                  },
                                  title: Text(_membersList[index].name),
                                  subtitle:
                                      Text(_membersList[index].phoneNumber),
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  if (_pageController.hasClients) {
                                    _pageController.animateToPage(
                                      0,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  }

                                  setState(() {
                                    currentPage = 0;
                                  });
                                },
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
                                onPressed: () {
                                  if (_pageController.hasClients) {
                                    _pageController.animateToPage(
                                      2,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  }

                                  setState(() {
                                    currentPage = 2;
                                  });
                                },
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
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "Select Fines for Late Members",
                            style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor),
                          ),
                        ),
                        SwitchListTile(
                          title: Text(
                            "Activate Fine Settings",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          value: fineSettingsEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              fineSettingsEnabled = value;
                            });
                          },
                        ),
                        Visibility(
                          visible: fineSettingsEnabled,
                          child: Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                      Visibility(
                                        visible: fineTypeId == 1,
                                        child: amountTextInputField(
                                          context: context,
                                          labelText: 'Fixed Amount',
                                          hintText: '1,500',
                                          onChanged: (value) {
                                            setState(() {
                                              fineAmount = double.parse(value);
                                            });
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: fineTypeId == 2,
                                        child: amountTextInputField(
                                          context: context,
                                          labelText: 'Percentage Rate',
                                          hintText: '',
                                          onChanged: (value) {
                                            setState(() {
                                              fineAmount = double.parse(value);
                                            });
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: fineTypeId == 2,
                                        child: CustomDropDownButton(
                                          labelText:
                                              "Select percentage fine option",
                                          listItems: percentageFineOnOptions,
                                          selectedItem: percentageFineOptionId,
                                          onChanged: (value) {
                                            setState(() {
                                              percentageFineOptionId = value;
                                            });
                                          },
                                        ),
                                      ),
                                      CustomDropDownStringOnlyButton(
                                        labelText: "Select Fine Chargeable On",
                                        listItems: fineChargeableOnOptions,
                                        selectedItem: fineChargeableOn,
                                        onChanged: (value) {
                                          setState(() {
                                            fineChargeableOn = value;
                                          });
                                        },
                                      ),
                                      CustomDropDownButton(
                                        labelText: "Select Fine For",
                                        listItems: fineForList,
                                        selectedItem: fineForId,
                                        onChanged: (value) {
                                          setState(() {
                                            fineForId = value;
                                          });
                                        },
                                      ),
                                      CustomDropDownButton(
                                        labelText: "Select Fine Frequency",
                                        listItems: fineFrequencyOptions,
                                        selectedItem: fineFrequencyIid,
                                        onChanged: (value) {
                                          setState(() {
                                            fineFrequencyIid = value;
                                          });
                                        },
                                      ),
                                      Visibility(
                                        visible: fineForId == 1,
                                        child: CustomDropDownButton(
                                          labelText: "Select Fine Limit",
                                          listItems: fineLimitOptions,
                                          selectedItem: fineLimitId,
                                          onChanged: (value) {
                                            setState(() {
                                              fineLimitId = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                if (_pageController.hasClients) {
                                  _pageController.animateToPage(
                                    1,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                }

                                setState(() {
                                  currentPage = 1;
                                });
                              },
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
          ],
        ),
      ),
    );
  }
}
