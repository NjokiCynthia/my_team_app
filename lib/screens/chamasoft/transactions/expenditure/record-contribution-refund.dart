import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
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

List<NamesListItem> contributions = [
  NamesListItem(id: 1, name: "Kikopey Land Leasing"),
  NamesListItem(id: 2, name: "Masaai Foreign Advantage"),
  NamesListItem(id: 3, name: "DVEA Properties"),
];

List<NamesListItem> groupMembers = [
  NamesListItem(id: 1, name: "Martin Nzuki"),
  NamesListItem(id: 2, name: "Peter Kimutai"),
  NamesListItem(id: 3, name: "Geoffrey Githaiga"),
  NamesListItem(id: 4, name: "Edwin Kapkei"),
];

class RecordContributionRefund extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecordContributionRefundState();
  }
}

class RecordContributionRefundState extends State<RecordContributionRefund> {
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
  int contributionId;
  int groupMemberId;
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
        title: "Record Contribution Refund",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            toolTip(
                context: context,
                title: "Manually record contribution refund",
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: DatePicker(
                          labelText: 'Select Refund Date',
                          selectedDate:
                              refundDate == null ? DateTime.now() : refundDate,
                          selectDate: (selectedDate) {
                            setState(() {
                              refundDate = selectedDate;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: CustomDropDownButton(
                          labelText: 'Select Refund Method',
                          listItems: depositMethods,
                          selectedItem: refundMethod,
                          onChanged: (value) {
                            setState(() {
                              refundMethod = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Contribution to refund from',
                    listItems: contributions,
                    selectedItem: contributionId,
                    onChanged: (value) {
                      setState(() {
                        contributionId = value;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select account to refund from',
                    listItems: accounts,
                    selectedItem: accountId,
                    onChanged: (value) {
                      setState(() {
                        accountId = value;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Member to refund',
                    listItems: groupMembers,
                    selectedItem: groupMemberId,
                    onChanged: (value) {
                      setState(() {
                        groupMemberId = value;
                      });
                    },
                  ),
                  amountTextInputField(
                      context: context,
                      labelText: 'Enter Amount refunded',
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
                      print('Member: $contributionId');
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
