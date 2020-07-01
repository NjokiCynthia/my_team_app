import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
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

List<NamesListItem> refundMethods = [
  NamesListItem(id: 1, name: "Cash"),
  NamesListItem(id: 2, name: "Cheque"),
  NamesListItem(id: 3, name: "MPesa"),
];
List<NamesListItem> fineTypes = [
  NamesListItem(id: 1, name: "Contribution Invoice"),
  NamesListItem(id: 2, name: "Loan Invoice"),
  NamesListItem(id: 3, name: "Goods Invoice"),
];
List<NamesListItem> contributions = [
  NamesListItem(id: 1, name: "Kikopey Land Leasing"),
  NamesListItem(id: 2, name: "Masaai Foreign Advantage"),
  NamesListItem(id: 3, name: "DVEA Properties"),
];
List<NamesListItem> memberTypes = [
  NamesListItem(id: 1, name: "Individual Members"),
  NamesListItem(id: 2, name: "All Members"),
];

class FineMember extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FineMemberState();
  }
}

class FineMemberState extends State<FineMember> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [];

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
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: Chip(
//          avatar: CircleAvatar(child: Text(member.initials)),
          label: Text(member.name),
          onDeleted: () {
            setState(() {
              selectedMembersList.removeWhere((MembersFilterEntry entry) {
                return entry.name == member.name;
              });
            });
          },
        ),
      );
    }
  }

  final formKey = new GlobalKey<FormState>();
  bool toolTipIsVisible = true;
  DateTime fineDate = DateTime.now();
  int fineTypeId;
  int memberTypeId;
  double amount;
  String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Fine Member",
      ),
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              toolTip(
                  context: context,
                  title: "Create custom fines",
                  message: "",
                  visible: toolTipIsVisible,
                  toggleToolTip: () {
                    setState(() {
                      toolTipIsVisible = !toolTipIsVisible;
                    });
                  }),
              Container(
                padding: inputPagePadding,
                height: MediaQuery.of(context).size.height,
                color: Theme.of(context).backgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DatePicker(
                      labelText: 'Select Fine Date',
                      selectedDate:
                          fineDate == null ? DateTime.now() : fineDate,
                      selectDate: (selectedDate) {
                        setState(() {
                          fineDate = selectedDate;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Fine type',
                      listItems: fineTypes,
                      selectedItem: fineTypeId,
                      onChanged: (value) {
                        setState(() {
                          fineTypeId = value;
                        });
                      },
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
                        children: <Widget>[
                          Wrap(
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
                                                membersList: [],
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
                    amountTextInputField(
                        context: context,
                        labelText: 'Enter Amount to fine',
                        onChanged: (value) {
                          setState(() {
                            amount = double.parse(value);
                          });
                        }),
                    multilineTextField(
                        context: context,
                        labelText: 'Short Description (Optional)',
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        }),
                    SizedBox(
                      height: 24,
                    ),
                    defaultButton(
                      context: context,
                      text: "SAVE",
                      onPressed: () {
                        print('Fine date: $fineDate');
                        print('Fine Type: $fineTypeId');
                        print('Member type: $memberTypeId');
                        print('Amount: $amount');
                        print('Description: $description');
                        print('Members: ${selectedMembersList.length}');
                        selectedMembersList.map((MembersFilterEntry mem) {
                          return print(mem.name);
                        }).toList();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
