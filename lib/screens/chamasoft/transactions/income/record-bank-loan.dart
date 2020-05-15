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

class RecordBankLoan extends StatefulWidget {
  @override
  _RecordBankLoanState createState() => _RecordBankLoanState();
}

class _RecordBankLoanState extends State<RecordBankLoan> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  DateTime loanFromDate = DateTime.now();
  DateTime loanToDate = DateTime.now();

  var accountId;

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

  bool toolTipIsVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Record Bank Loan",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
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
                  title: "Manually record bank loans",
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
                    simpleTextInputField(
                        context: context,
                        labelText: "Bank loan description",
                        onChanged: (value) {}),
                    amountTextInputField(
                        context: context,
                        labelText: "Total amount received",
                        onChanged: (value) {}),
                    amountTextInputField(
                        context: context,
                        labelText: "Total amount payable",
                        onChanged: (value) {}),
                    amountTextInputField(
                        context: context,
                        labelText: "Total loan balance as at date",
                        onChanged: (value) {}),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: DatePicker(
                            labelText: 'Loan From',
                            selectedDate: loanFromDate == null
                                ? DateTime.now()
                                : loanFromDate,
                            selectDate: (selectedDate) {
                              setState(() {
                                loanFromDate = selectedDate;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 1,
                          child: DatePicker(
                            labelText: 'Loan To',
                            selectedDate: loanToDate == null
                                ? DateTime.now()
                                : loanToDate,
                            selectDate: (selectedDate) {
                              setState(() {
                                loanToDate = selectedDate;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    CustomDropDownButton(
                      labelText: "Account loan deposited to",
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
                    defaultButton(
                      context: context,
                      text: "SAVE",
                      onPressed: () {},
                    )
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
