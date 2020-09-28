import 'package:chamasoft/screens/chamasoft/settings/setup-lists/loan-setup-list.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

class LoanTypeSettings extends StatefulWidget {
  final Function onButtonPressed;

  LoanTypeSettings({@required this.onButtonPressed});

  @override
  _LoanTypeSettingsState createState() => _LoanTypeSettingsState();
}

class _LoanTypeSettingsState extends State<LoanTypeSettings> {
  String loanTypeName = '';
  int loanAmountTypeId;
  double minimumLoanAmount;
  double maximumLoanAmount;
  double timesNumberOfSavings;
  int interestTypeId;
  bool enableLoanReducingBalanceRecalculation = false;
  double loanInterestRate;
  int loanInterestRatePerId;
  int loanRepaymentTypeId;
  double fixedRepaymentPeriod;
  double minimumRepaymentPeriod;
  double maximumRepaymentPeriod;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              customTitle(
                  text: "Loan Details",
                  color: Theme.of(context).textSelectionHandleColor,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              subtitle2(
                  text: "Configure the behaviour of your loan",
                  color: Theme.of(context).textSelectionHandleColor,
                  textAlign: TextAlign.start),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                simpleTextInputField(
                  context: context,
                  labelText: 'Loan Type Name',
                  onChanged: (value) {
                    setState(() {
                      loanTypeName = value;
                    });
                  },
                ),
                CustomDropDownButton(
                  labelText: "Loan Amount Type",
                  listItems: loanAmountTypes,
                  selectedItem: loanAmountTypeId,
                  onChanged: (value) {
                    setState(() {
                      loanAmountTypeId = value;
                    });
                  },
                ),
                Visibility(
                  visible: loanAmountTypeId == 1,
                  child: amountTextInputField(
                    context: context,
                    labelText: 'Minimum Loan Amount',
                    hintText: '1,500',
                    onChanged: (value) {
                      setState(() {
                        minimumLoanAmount = double.parse(value);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: loanAmountTypeId == 1,
                  child: amountTextInputField(
                    context: context,
                    labelText: 'Maximum  Loan Amount',
                    hintText: '1,500',
                    onChanged: (value) {
                      setState(() {
                        maximumLoanAmount = double.parse(value);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: loanAmountTypeId == 2,
                  child: amountTextInputField(
                    context: context,
                    labelText: 'How many times the member savings',
                    onChanged: (value) {
                      setState(() {
                        timesNumberOfSavings = double.parse(value);
                      });
                    },
                  ),
                ),
                CustomDropDownButton(
                  labelText: "Interest Type",
                  listItems: interestTypes,
                  selectedItem: interestTypeId,
                  onChanged: (value) {
                    setState(() {
                      interestTypeId = value;
                    });
                  },
                ), // enableLoanReducingBalanceRecalculation
                Visibility(
                  visible: interestTypeId == 2,
                  child: SwitchListTile(
                    title: Text(
                      "Enable loan reducing balance recalculation",
                      style: TextStyle(color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w500),
                    ),
                    value: enableLoanReducingBalanceRecalculation,
                    onChanged: (bool value) {
                      setState(() {
                        enableLoanReducingBalanceRecalculation = value;
                      });
                    },
                  ),
                ),
                amountTextInputField(
                  context: context,
                  labelText: 'Loan Interest Rate(%)',
                  onChanged: (value) {
                    setState(() {
                      loanInterestRate = double.parse(value);
                    });
                  },
                ),
                CustomDropDownButton(
                  labelText: "Loan interest rate per",
                  listItems: loanInterestRatePer,
                  selectedItem: loanInterestRatePerId,
                  onChanged: (value) {
                    setState(() {
                      loanInterestRatePerId = value;
                    });
                  },
                ),
                CustomDropDownButton(
                  labelText: "Loan repayment period type",
                  listItems: loanRepaymentType,
                  selectedItem: loanRepaymentTypeId,
                  onChanged: (value) {
                    setState(() {
                      loanRepaymentTypeId = value;
                    });
                  },
                ),
                Visibility(
                  visible: loanRepaymentTypeId == 1,
                  child: amountTextInputField(
                    context: context,
                    labelText: 'Fixed repayment period',
                    onChanged: (value) {
                      setState(() {
                        fixedRepaymentPeriod = double.parse(value);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: loanRepaymentTypeId == 2,
                  child: amountTextInputField(
                    context: context,
                    labelText: 'Minimum repayment period',
                    hintText: 'Value in months . E.g 3',
                    onChanged: (value) {
                      setState(() {
                        minimumRepaymentPeriod = double.parse(value);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: loanRepaymentTypeId == 2,
                  child: amountTextInputField(
                    context: context,
                    labelText: 'Maximum repayment period',
                    hintText: 'Value in months . E.g 12',
                    onChanged: (value) {
                      setState(() {
                        maximumRepaymentPeriod = double.parse(value);
                      });
                    },
                  ),
                ),
              ]),
            ),
          ),
          defaultButton(
              context: context,
              text: "Save & Continue",
              onPressed: () {
                print("clicked");
                widget.onButtonPressed();
              }),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
