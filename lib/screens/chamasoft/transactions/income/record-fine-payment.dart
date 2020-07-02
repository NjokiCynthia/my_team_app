import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/record-expense.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/fine-member.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/date-picker.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../select-member.dart';

List<NamesListItem> fineOptions = [
  NamesListItem(id: 1, name: "Lateness to Meeting"),
  NamesListItem(id: 2, name: "Noise Making"),
  NamesListItem(id: 3, name: "Civil Disobedience"),
];

class RecordFinePayment extends StatefulWidget {
  @override
  _RecordFinePaymentState createState() => _RecordFinePaymentState();
}

class _RecordFinePaymentState extends State<RecordFinePayment> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [];
  int memberTypeId;

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

  Iterable<Widget> get memberWidgets sync* {
    for (MembersFilterEntry member in selectedMembersList) {
      yield Container(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              //flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customTitle(
                      text: member.name,
                      color: Color(0xFFB3C7D9),
                      fontWeight: FontWeight.w700),
                  customTitle(
                      text: member.phoneNumber, color: Color(0xFFB3C7D9))
                ],
              ),
            ),
            Expanded(
              child: amountTextInputField(
                  context: context,
                  labelText: 'Enter Amount',
                  onChanged: (value) {
                    member.amount = value;
                  }),
            ),
            circleIconButton(
                backgroundColor: Color(0xFFFFF2F2),
                color: Color(0xFFE40000),
                icon: Icons.close,
                iconSize: 18,
                onPressed: () {
                  setState(() {
                    selectedMembersList.removeWhere((MembersFilterEntry entry) {
                      return entry.name == member.name;
                    });
                  });
                })
          ],
        ),
      );

//      ListTile(
////          avatar: CircleAvatar(child: Text(member.initials)),
//        title: Text(member.name,
//            style: TextStyle(
//                color: Color(0xFFB3C7D9), fontWeight: FontWeight.w700)),
//        contentPadding: EdgeInsets.all(4.0),
//        subtitle: Text(
//          member.phoneNumber,
//          style: TextStyle(color: Color(0xFFB3C7D9)),
//        ),
//        trailing: Container(
//          width: 250.0,
//          child: Row(
//            children: <Widget>[
//              Expanded(
//                flex: 5,
//                child: amountTextInputField(
//                    context: context,
//                    labelText: 'Enter Amount',
//                    onChanged: (value) {
//                      member.amount = value;
//                    }),
//              ),
//              Expanded(
//                child: circleIconButton(
//                    backgroundColor: Color(0xFFFFF2F2),
//                    color: Color(0xFFE40000),
//                    icon: Icons.close,
//                    iconSize: 18,
//                    onPressed: () {
//                      setState(() {
//                        selectedMembersList
//                            .removeWhere((MembersFilterEntry entry) {
//                          return entry.name == member.name;
//                        });
//                      });
//                    }),
//              ),
//            ],
//          ),
//        ),
//      );
    }
  }

  final formKey = new GlobalKey<FormState>();
  DateTime finePaymentDate = DateTime.now();
  int depositMethod;
  int fineId;
  int accountId;

  var selectDateController = TextEditingController();
  double amountInputValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Record Fine Payment",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              toolTip(
                  context: context,
                  title: "Note that...",
                  message: "Manually record fine payments",
                  showTitle: false),
              Padding(
                padding: inputPagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: DatePicker(
                            labelText: 'Select Deposit Date',
                            selectedDate: finePaymentDate == null
                                ? DateTime.now()
                                : finePaymentDate,
                            selectDate: (selectedDate) {
                              setState(() {
                                finePaymentDate = selectedDate;
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
                      labelText: "Select Fine",
                      listItems: fineOptions,
                      selectedItem: fineId,
                      onChanged: (value) {
                        setState(() {
                          fineId = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomDropDownButton(
                      labelText: "Select Deposit Account",
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
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                        visible: memberTypeId == 2,
                        child: amountTextInputField(
                            context: context,
                            labelText: "Enter Amount(for each member)",
                            onChanged: (value) {
                              setState(() {
                                amountInputValue = double.parse(value);
                              });
                            })),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: defaultButton(
                        context: context,
                        text: "Save",
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
