import 'package:chamasoft/screens/chamasoft/settings/setup-lists/loan-setup-list.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:flutter/material.dart';

class LoanFeesAndGuarantors extends StatefulWidget {
  final Function onButtonPressed;

  LoanFeesAndGuarantors({@required this.onButtonPressed});

  @override
  _LoanFeesAndGuarantorsState createState() => _LoanFeesAndGuarantorsState();
}

class _LoanFeesAndGuarantorsState extends State<LoanFeesAndGuarantors> {
  bool enableLoanGuarantors = false;

  int guarantorOptionId;
  int minimumAllowedGuarantors;

  bool chargeLoanProcessingFee = false;

  int loanProcessingFeeTypeId;

  double loanProcessingFeeAmount;
  double loanProcessingFeePercentage;
  int loanProcessingFeePercentageChargedOnId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "General Details",
              style: TextStyle(
                  color: Theme.of(context).textSelectionHandleColor,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "",
              style: TextStyle(color: Theme.of(context).bottomAppBarColor),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    title: Text(
                      "Enable loan guarantors",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w500),
                    ),
                    value: enableLoanGuarantors,
                    onChanged: (bool value) {
                      setState(() {
                        enableLoanGuarantors = value;
                      });
                    },
                  ),
                  Visibility(
                    visible: enableLoanGuarantors,
                    child: ListTile(
                      title: Text(
                        "Choose guarantor option",
                        style: TextStyle(
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: enableLoanGuarantors,
                    child: RadioListTile(
                      title: Text(
                        "Every time member applying loan",
                        style: TextStyle(
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w500),
                      ),
                      onChanged: (value) {
                        setState(() {
                          guarantorOptionId = value;
                        });
                      },
                      value: 1,
                      groupValue: guarantorOptionId,
                    ),
                  ),
                  Visibility(
                    visible: enableLoanGuarantors,
                    child: RadioListTile(
                      title: Text(
                        "When a member loan request exceeds maximum loan amount",
                        style: TextStyle(
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w500),
                      ),
                      onChanged: (value) {
                        setState(() {
                          guarantorOptionId = value;
                        });
                      },
                      value: 2,
                      groupValue: guarantorOptionId,
                    ),
                  ),
                  Visibility(
                    visible: enableLoanGuarantors,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: amountTextInputField(
                        context: context,
                        labelText: 'Enter minimum allowed guarantors',
                        onChanged: (value) {
                          setState(() {
                            minimumAllowedGuarantors = int.parse(value);
                          });
                        },
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: Text(
                      "Charge loan processing fee",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w500),
                    ),
                    value: chargeLoanProcessingFee,
                    onChanged: (bool value) {
                      setState(() {
                        chargeLoanProcessingFee = value;
                      });
                    },
                  ),
                  Visibility(
                    visible: chargeLoanProcessingFee,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomDropDownButton(
                        labelText: "Loan processing fee type",
                        listItems: loanProcessingFeeTypes,
                        selectedItem: loanProcessingFeeTypeId,
                        onChanged: (value) {
                          setState(() {
                            loanProcessingFeeTypeId = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: loanProcessingFeeTypeId == 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: amountTextInputField(
                        context: context,
                        labelText: 'Enter processing fee amount',
                        onChanged: (value) {
                          setState(() {
                            loanProcessingFeeAmount = double.parse(value);
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: loanProcessingFeeTypeId == 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: amountTextInputField(
                        context: context,
                        labelText: 'Enter processing fee percentage',
                        onChanged: (value) {
                          setState(() {
                            loanProcessingFeePercentage = double.parse(value);
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: loanProcessingFeeTypeId == 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomDropDownButton(
                        labelText: "Percentage charged on",
                        listItems: loanProcessingFeePercentageChargedOn,
                        selectedItem: loanProcessingFeePercentageChargedOnId,
                        onChanged: (value) {
                          setState(() {
                            loanProcessingFeePercentageChargedOnId = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          defaultButton(
            context: context,
            text: "Save & Finish",
            onPressed: () => widget.onButtonPressed(),
          )
        ],
      ),
    );
  }
}
