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

List<NamesListItem> depositors = [
  NamesListItem(id: 1, name: "Peter Parker"),
  NamesListItem(id: 2, name: "Tony Stark"),
  NamesListItem(id: 3, name: "Stephen Strange"),
];
List<NamesListItem> incomeCategories = [
  NamesListItem(id: 1, name: "Tax Refunds"),
  NamesListItem(id: 2, name: "Dividends"),
  NamesListItem(id: 3, name: "Share Profits"),
];

class RecordIncome extends StatefulWidget {
  @override
  _RecordIncomeState createState() => _RecordIncomeState();
}

class _RecordIncomeState extends State<RecordIncome> {
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
  int depositorId;
  int groupMemberId;
  int incomeCategoryId;
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
        title: "Record Income",
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
                  title: "Manually record income payments",
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
                      labelText: 'Select Deposit Date',
                      selectedDate:
                          refundDate == null ? DateTime.now() : refundDate,
                      selectDate: (selectedDate) {
                        setState(() {
                          refundDate = selectedDate;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Depositor',
                      listItems: depositors,
                      selectedItem: depositorId,
                      onChanged: (value) {
                        setState(() {
                          depositorId = value;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Income Category',
                      listItems: incomeCategories,
                      selectedItem: incomeCategoryId,
                      onChanged: (value) {
                        setState(() {
                          incomeCategoryId = value;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Account',
                      listItems: accounts,
                      selectedItem: accountId,
                      onChanged: (value) {
                        setState(() {
                          accountId = value;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Deposit Method',
                      listItems: depositMethods,
                      selectedItem: refundMethod,
                      onChanged: (value) {
                        setState(() {
                          refundMethod = value;
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
                        print('Depositor: $depositorId');
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
      ),
    );
  }
}
