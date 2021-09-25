import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/record-loan-payment.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/date-picker.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'create-invoice.dart';

List<NamesListItem> transferFromOptions = [
  NamesListItem(id: 1, name: "Contribution"),
  NamesListItem(id: 2, name: "Loan"),
];

List<NamesListItem> transferToOptions = [
  NamesListItem(id: 1, name: "Contribution Share"),
  NamesListItem(id: 2, name: "Fine Payments"),
  NamesListItem(id: 3, name: "Loan Share"),
  NamesListItem(id: 4, name: "Another Member"),
];
List<NamesListItem> memberTransferToOptions = [
  NamesListItem(id: 1, name: "Contribution Share"),
  NamesListItem(id: 2, name: "Fine Payments"),
  NamesListItem(id: 3, name: "Loan Share"),
];
List<NamesListItem> groupMembers = [
  NamesListItem(id: 1, name: "Martin Nzuki"),
  NamesListItem(id: 2, name: "Peter Kimutai"),
  NamesListItem(id: 3, name: "Geoffrey Githaiga"),
  NamesListItem(id: 4, name: "Edwin Kapkei"),
];

class ContributionTransfer extends StatefulWidget {
  @override
  _ContributionTransferState createState() => _ContributionTransferState();
}

class _ContributionTransferState extends State<ContributionTransfer> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final _formKey = new GlobalKey<FormState>();
  bool toolTipIsVisible = true;
  DateTime transferDate = DateTime.now();
  DateTime now = DateTime.now();
  int refundMethod;
  NamesListItem depositMethodValue;
  int transferFromOptionId;
  int transferToOptionId;
  int memberTransferToOptionId;
  int groupMemberId;
  int receiverMemberId;
  int incomeCategoryId;
  int contributionFromId;
  int contributionToId;
  int loanFromId;
  int loanToId;
  int fineToId;
  double amount;
  String description;
  Map<String,dynamic> _formData={};//,_formLoadData={};

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

  void _submit(BuildContext context){
    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();
    _formData['transfer_date'] = transferDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Record Contribution Transfer",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
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
                title: "Manually record contribution transfers",
                message: "",
              ),
              Padding(
                padding: inputPagePadding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      DatePicker(
                        labelText: 'Select Deposit Date',
                        lastDate: DateTime.now(),
                        selectedDate: transferDate == null
                            ? new DateTime(
                                now.year, now.month, now.day - 1, 6, 30)
                            : transferDate,
                        selectDate: (selectedDate) {
                          setState(() {
                            transferDate = selectedDate;
                          });
                        },
                      ),
                      CustomDropDownButton(
                        labelText: 'Select Member',
                        listItems: groupMembers,
                        selectedItem: groupMemberId,
                        onChanged: (value) {
                          setState(() {
                            groupMemberId = value;
                          });
                        },
                      ),
                      CustomDropDownButton(
                        labelText: 'Select Contribution/Loan Transfer',
                        listItems: transferFromOptions,
                        selectedItem: transferFromOptionId,
                        onChanged: (value) {
                          setState(() {
                            transferFromOptionId = value;
                          });
                        },
                      ),
                      Visibility(
                        visible: transferFromOptionId == 1,
                        child: CustomDropDownButton(
                          labelText: 'Select Contribution From',
                          listItems: contributions,
                          selectedItem: contributionFromId,
                          onChanged: (value) {
                            setState(() {
                              contributionFromId = value;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: transferFromOptionId == 2,
                        child: CustomDropDownButton(
                          labelText: 'Select Loan From',
                          listItems: loans,
                          selectedItem: loanFromId,
                          onChanged: (value) {
                            setState(() {
                              loanFromId = value;
                            });
                          },
                        ),
                      ),
                      CustomDropDownButton(
                        labelText: 'Select Transfer To',
                        listItems: transferToOptions,
                        selectedItem: transferToOptionId,
                        onChanged: (value) {
                          setState(() {
                            transferToOptionId = value;
                            memberTransferToOptionId = null;
                          });
                        },
                      ),
                      Visibility(
                        visible: transferToOptionId == 4,
                        child: CustomDropDownButton(
                          labelText: 'Select Member to Receive Transfer',
                          listItems: groupMembers,
                          selectedItem: receiverMemberId,
                          onChanged: (value) {
                            setState(() {
                              receiverMemberId = value;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: transferToOptionId == 4,
                        child: CustomDropDownButton(
                          labelText: 'Select Transfer To',
                          listItems: memberTransferToOptions,
                          selectedItem: memberTransferToOptionId,
                          onChanged: (value) {
                            setState(() {
                              memberTransferToOptionId = value;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: transferToOptionId == 1 ||
                            memberTransferToOptionId == 1,
                        child: CustomDropDownButton(
                          labelText: 'Select Contribution To',
                          listItems: contributions,
                          selectedItem: contributionToId,
                          onChanged: (value) {
                            setState(() {
                              contributionToId = value;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: transferToOptionId == 2 ||
                            memberTransferToOptionId == 2,
                        child: CustomDropDownButton(
                          labelText: 'Select Fine To',
                          listItems: [],
                          selectedItem: fineToId,
                          onChanged: (value) {
                            setState(() {
                              fineToId = value;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: transferToOptionId == 3 ||
                            memberTransferToOptionId == 3,
                        child: CustomDropDownButton(
                          labelText: 'Select Loan To',
                          listItems: loans,
                          selectedItem: loanToId,
                          onChanged: (value) {
                            setState(() {
                              loanFromId = value;
                            });
                          },
                        ),
                      ),
                      amountTextInputField(
                          context: context,
                          labelText: 'Enter Amount',
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
                        onPressed: ()=>_submit(context),
                      ),
                    ],
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
