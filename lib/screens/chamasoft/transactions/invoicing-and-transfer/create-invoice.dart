import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/date-picker.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../select-member.dart';
import 'fine-member.dart';

List<NamesListItem> refundMethods = [
  NamesListItem(id: 1, name: "Cash"),
  NamesListItem(id: 2, name: "Cheque"),
  NamesListItem(id: 3, name: "MPesa"),
];
List<NamesListItem> invoiceTypes = [
  NamesListItem(id: 1, name: "Contribution Invoice"),
  NamesListItem(id: 2, name: "Loan Invoice"),
  NamesListItem(id: 3, name: "Goods Invoice"),
];
List<NamesListItem> contributions = [
  NamesListItem(id: 1, name: "Kikopey Land Leasing"),
  NamesListItem(id: 2, name: "Masaai Foreign Advantage"),
  NamesListItem(id: 3, name: "DVEA Properties"),
];

class CreateInvoice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateInvoiceState();
  }
}

class CreateInvoiceState extends State<CreateInvoice> {
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
  DateTime invoiceDate = DateTime.now();
  DateTime dueDate = DateTime.now();
  int invoiceTypeId;
  int memberTypeId;
  int contributionId;
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
        title: "Create Invoice",
      ),
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              toolTip(
                  context: context,
                  title: "Create and send custom invoices",
                  message: "",
                  visible: toolTipIsVisible,
                  toggleToolTip: () {
                    setState(() {
                      toolTipIsVisible = !toolTipIsVisible;
                    });
                  }),
              Expanded(
                child: Container(
                  padding: inputPagePadding,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: DatePicker(
                                labelText: 'Select Invoice Date',
                                selectedDate: invoiceDate == null
                                    ? DateTime.now()
                                    : invoiceDate,
                                selectDate: (selectedDate) {
                                  setState(() {
                                    invoiceDate = selectedDate;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: DatePicker(
                                labelText: 'Select Due Date',
                                selectedDate:
                                    dueDate == null ? DateTime.now() : dueDate,
                                selectDate: (selectedDate) {
                                  setState(() {
                                    dueDate = selectedDate;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        CustomDropDownButton(
                          labelText: 'Select invoice type',
                          listItems: invoiceTypes,
                          selectedItem: invoiceTypeId,
                          onChanged: (value) {
                            setState(() {
                              invoiceTypeId = value;
                            });
                          },
                        ),
                        CustomDropDownButton(
                          labelText: 'Select Contribution ',
                          listItems: contributions,
                          selectedItem: contributionId,
                          onChanged: (value) {
                            setState(() {
                              contributionId = value;
                            });
                          },
                        ),
                        CustomDropDownButton(
                          labelText: 'Select Member',
                          listItems: memberTypes,
                          selectedItem: memberTypeId,
                          onChanged: (selected) async {
                            if (selected == 1) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectMember(
                                            initialMembersList:
                                                selectedMembersList,
                                            //membersList: memberOptions,
                                          ))).then((value) {
                                setState(() {
                                  memberTypeId = selected;
                                  selectedMembersList = value;
                                });
                              });
                            } else {
                              setState(() {
                                memberTypeId = selected;
                              });
                            }
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
                              // ignore: deprecated_member_use
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
                        amountTextInputField(
                            context: context,
                            labelText: 'Enter Amount to invoice',
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
                            print('Invoice date: $invoiceDate');
                            print('Due date: $dueDate');
                            print('Invoice Type: $invoiceTypeId');
                            print('Contribution: $contributionId');
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
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
