import 'package:chamasoft/screens/chamasoft/settings/setup-lists/contribution-setup-list.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:flutter/material.dart';

class ContributionSettings extends StatefulWidget {
  final VoidCallback onButtonPressed;

  ContributionSettings({@required this.onButtonPressed});

  @override
  _ContributionSettingsState createState() => _ContributionSettingsState();
}

class _ContributionSettingsState extends State<ContributionSettings> {
  double contributionAmount = 0;
  int startingMonthId;
  int dayOfMonthId;
  String contributionName = '';

//  "one_time_invoicing_active": 1,
  int contributionTypeId;

//  "regular_invoicing_active": 1,
//  "week_number_fortnight": 0,
  int weekdayId;
  int weekNumberId;
  int twoWeekdayId;
  int dateOfMonthId;

//  "week_day_fortnight": 0,
//  "week_day_weekly": 0,
//  "week_day_monthly": 0,
//  "month_day_monthly": 10,
//  "invoice_days": 1,
  int contributionFrequencyId;

//  "contribution_date": "01-01-1970",
//  "invoice_date": "01-01-1970"

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              "Settings",
              style: TextStyle(color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "Configure the behaviour of your contribution",
              style: TextStyle(color: Theme.of(context).bottomAppBarColor),
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
                        visible: (dateOfMonthId != null && (dateOfMonthId == 1 || dateOfMonthId == 2 || dateOfMonthId == 3 || dayOfMonthId == 4) ||
                                dateOfMonthId == 32) &&
                            (contributionFrequencyId != 6 && contributionFrequencyId != 7 && contributionFrequencyId != 8),
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
          ),
          RaisedButton(
            onPressed: widget.onButtonPressed,
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
    );
  }
}
