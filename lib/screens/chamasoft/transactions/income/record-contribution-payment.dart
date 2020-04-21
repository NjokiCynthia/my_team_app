import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/record-expense.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/fine-member.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/date-picker.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../select-member.dart';

class RecordContributionPayment extends StatefulWidget {
  @override
  _RecordContributionPaymentState createState() =>
      _RecordContributionPaymentState();
}

String selectedContributionValue;
String selectedAccountValue;
String selectedMemberType;

class _RecordContributionPaymentState extends State<RecordContributionPayment> {
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

  Iterable<Widget> get memberWidgets sync* {
    for (MembersFilterEntry member in selectedMembersList) {
      yield ListTile(
//          avatar: CircleAvatar(child: Text(member.initials)),
        title: Text(member.name,
            style: TextStyle(
                color: Color(0xFFB3C7D9), fontWeight: FontWeight.w700)),
        contentPadding: EdgeInsets.all(4.0),
        subtitle: Text(
          member.phoneNumber,
          style: TextStyle(color: Color(0xFFB3C7D9)),
        ),
        trailing: Container(
          width: 250.0,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: amountTextInputField(
                    context: context,
                    labelText: 'Enter Amount',
                    onChanged: (value) {
                      member.amount = value;
                    }),
              ),
              Expanded(
                child: circleIconButton(
                    backgroundColor: Color(0xFFFFF2F2),
                    color: Color(0xFFE40000),
                    icon: Icons.close,
                    iconSize: 18,
                    onPressed: () {
                      setState(() {
                        selectedMembersList
                            .removeWhere((MembersFilterEntry entry) {
                          return entry.name == member.name;
                        });
                      });
                    }),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  final formKey = new GlobalKey<FormState>();
  DateTime contributionDate = DateTime.now();

  int depositMethod;
  int contributionId;
  int accountId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Record Contribution Payment",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            toolTip(
                context: context,
                title: "Note that...",
                message: "Manually record contribution payments",
                showTitle: false),
            Container(
                padding: EdgeInsets.all(SPACING_NORMAL),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: DatePicker(
                            labelText: 'Select Expense Date',
                            selectedDate: contributionDate == null
                                ? DateTime.now()
                                : contributionDate,
                            selectDate: (selectedDate) {
                              setState(() {
                                contributionDate = selectedDate;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            flex: 3,
                            child: CustomDropDownButton(
                              labelText: "Select Deposit Method",
                              listItems: withdrawalMethods,
                              selectedItem: depositMethod,
                              onChanged: (value) {
                                setState(() {
                                  depositMethod = value;
                                });
                              },
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomDropDownButton(
                      labelText: "Select Contribution",
                      listItems: contributions,
                      selectedItem: contributionId,
                      onChanged: (value) {
                        setState(() {
                          contributionId = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomDropDownButton(
                      labelText: "Select Account",
                      listItems: accounts,
                      selectedItem: accountId,
                      onChanged: (value) {
                        setState(() {
                          accountId = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Member',
                      listItems: memberTypes,
                      selectedItem: memberTypeId,
                      onChanged: (value) {
                        setState(() {
                          memberTypeId = value;
                        });
                      },
                    ),
                    Visibility(
                      visible: memberTypeId == 1,
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                children: memberWidgets.toList(),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  //open select members dialog
                                  selectedMembersList = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SelectMember(
                                                initialMembersList:
                                                    selectedMembersList,
                                              )));
                                },
                                child: Text(
                                  'Select members',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                        visible: memberTypeId == 2,
                        child: amountTextInputField(
                            context: context,
                            labelText: 'Enter Amount',
                            onChanged: (value) {
                              //member.amount = value;
                            })),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200,
                      height: 44,
                      child: defaultButton(
                        context: context,
                        text: "Save",
                        onPressed: () {
                          print("Contribution: " + selectedContributionValue);
                          print("Account: " + selectedAccountValue);
                        },
                      ),
                    ),
                  ],
                ))
          ])),
    );
  }
}
