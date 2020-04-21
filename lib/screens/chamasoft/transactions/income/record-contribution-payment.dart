import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../select-member.dart';

List<NamesListItem> memberTypes = [
  NamesListItem(id: 1, name: "Individual Members"),
  NamesListItem(id: 2, name: "All Members"),
];

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

  static final List<String> contributionList = <String>[
    'Monthly Savings',
    'Welfare'
  ];
  static final List<String> accountList = <String>[
    'KCB Bank - 10101241241',
    'Equity Bank - 123123100292',
    'ABSA Bank - 1212111111',
  ];
  static final List<String> memberSelection = <String>[
    'All Members',
    'Individual Members',
  ];
  static final List<String> depositType = <String>[
    'Cash',
    'Mobile Money',
    'Cheque',
  ];

  final formKey = new GlobalKey<FormState>();
  DateTime _selectedDate;
  var selectDateController = TextEditingController();

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
          controller: _scrollController,
          child: Column(children: <Widget>[
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
                          child: TextFormField(
                            controller: selectDateController,
                            onTap: () => showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            ).then((date) {
                              setState(() {
                                _selectedDate = date;
                                print(_selectedDate.toIso8601String());
                                selectDateController.text = _selectedDate ==
                                        null
                                    ? ""
                                    : defaultDateFormat.format(_selectedDate);
                              });
                            }),
                            readOnly: true,
                            decoration: InputDecoration(
                              hasFloatingPlaceholder: true,
                              labelText: 'Select Date',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 3,
                          child: DropDownTextField(
                            hintText: "Select Deposit Method",
                            selectedValue: selectedContributionValue,
                            items: depositType,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropDownTextField(
                      hintText: "Select Contribution",
                      selectedValue: selectedContributionValue,
                      items: contributionList,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropDownTextField(
                      hintText: "Select Account",
                      selectedValue: selectedContributionValue,
                      items: accountList,
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
                              'Select more members',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
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

// ignore: must_be_immutable
class DropDownTextField extends StatefulWidget {
  DropDownTextField({this.hintText, this.selectedValue, this.items});

  final String hintText;
  String selectedValue;
  final List<String> items;

  @override
  _DropDownTextFieldState createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new InputDecorator(
                decoration: InputDecoration(
                    filled: false,
                    hintText: widget.hintText,
                    labelText: widget.selectedValue == null
                        ? widget.hintText
                        : widget.hintText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor, width: 1.0))),
                isEmpty: widget.selectedValue == null,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Theme.of(context).cardColor,
                  ),
                  child: new DropdownButton<String>(
                    value: widget.selectedValue,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        widget.selectedValue = newValue;
                      });
                    },
                    items: widget.items.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
