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

class BankLoanRepayment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BankLoanRepaymentState();
  }
}

class BankLoanRepaymentState extends State<BankLoanRepayment> {
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
  DateTime depositDate = DateTime.now();
  int depositMethod;
  NamesListItem depositMethodValue;
  int groupMemberId;
  int loanId;
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
        title: "Record Bank Loan Repayment",
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
                  title: "Manually record bank loan repayments",
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
                    CustomDropDownButton(
                      labelText: 'Select Bank Loan',
                      listItems: loans,
                      selectedItem: loanId,
                      onChanged: (value) {
                        setState(() {
                          loanId = value;
                        });
                      },
                    ),
                    DatePicker(
                      labelText: 'Select Repayment Date',
                      selectedDate:
                          depositDate == null ? DateTime.now() : depositDate,
                      selectDate: (selectedDate) {
                        setState(() {
                          depositDate = selectedDate;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Account Withdrawn',
                      listItems: accounts,
                      selectedItem: accountId,
                      onChanged: (value) {
                        setState(() {
                          accountId = value;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Repayment Method',
                      listItems: depositMethods,
                      selectedItem: depositMethod,
                      onChanged: (value) {
                        setState(() {
                          depositMethod = value;
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
                        print('Deposit date: $depositDate');
                        print('Deposit Method: $depositMethod');
                        print('Member: $groupMemberId');
                        print('Loan: $loanId');
                        print('Account: $accountId');
                        print('Amount: $amount');
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
