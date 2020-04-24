import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-fine-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/record-loan-payment.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/date-picker.dart';
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

class ContributionTransfer extends StatefulWidget {
  @override
  _ContributionTransferState createState() => _ContributionTransferState();
}

class _ContributionTransferState extends State<ContributionTransfer> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

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

  final formKey = new GlobalKey<FormState>();
  bool toolTipIsVisible = true;
  DateTime refundDate = DateTime.now();
  int refundMethod;
  NamesListItem depositMethodValue;
  int transferFromOptionId;
  int transferToOptionId;
  int groupMemberId;
  int incomeCategoryId;
  int contributionFromId;
  int contributionToId;
  int loanFromId;
  int loanToId;
  int accountId;
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
        title: "Record Contribution Transfer",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            toolTip(
                context: context,
                title: "Manually record contribution transfers",
                message: "",
                visible: toolTipIsVisible,
                toggleToolTip: () {
                  setState(() {
                    toolTipIsVisible = !toolTipIsVisible;
                  });
                }),
            Padding(
              padding: inputPagePadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DatePicker(
                    labelText: 'Select Transfer Date',
                    selectedDate:
                        refundDate == null ? DateTime.now() : refundDate,
                    selectDate: (selectedDate) {
                      setState(() {
                        refundDate = selectedDate;
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
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Contribution To',
                    listItems: contributions,
                    selectedItem: contributionToId,
                    onChanged: (value) {
                      setState(() {
                        contributionToId = value;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Loan To',
                    listItems: loans,
                    selectedItem: loanToId,
                    onChanged: (value) {
                      setState(() {
                        loanFromId = value;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Fine To',
                    listItems: fineOptions,
                    selectedItem: loanToId,
                    onChanged: (value) {
                      setState(() {
                        loanFromId = value;
                      });
                    },
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
                    onPressed: () {
                      print('Refund date: $refundDate');
                      print('Refund Method: $refundMethod');
                      print('Depositor: $transferFromOptionId');
                      print('Account: $accountId');
                      print('Amount: $amount');
                      print('Description: $description');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
