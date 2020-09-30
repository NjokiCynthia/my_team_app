import 'package:chamasoft/screens/chamasoft/settings/setup-lists/loan-setup-list.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

class LoanFeesAndGuarantors extends StatefulWidget {
  final dynamic responseData;
  final bool isEditMode;
  final dynamic loanDetails;
  final Function(dynamic) onButtonPressed;

  LoanFeesAndGuarantors({this.responseData, this.isEditMode, this.loanDetails, @required this.onButtonPressed});

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              customTitle(
                  text: "General Details",
                  color: Theme.of(context).textSelectionHandleColor,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              subtitle2(
                  text: "Set Guarantor Requirements and Loan Fees",
                  color: Theme.of(context).textSelectionHandleColor,
                  textAlign: TextAlign.start),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      customTitle(
                          text: "Enable loan guarantors",
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start),
                      Switch(
                        value: enableLoanGuarantors,
                        onChanged: (value) {
                          setState(() {
                            enableLoanGuarantors = value;
                          });
                        },
                      )
                    ],
                  ),
                  Visibility(visible: enableLoanGuarantors, child: SizedBox(height: 5)),
                  Visibility(
                    visible: enableLoanGuarantors,
                    child: Row(
                      children: [
                        customTitle(
                          text: "Choose guarantor option",
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: enableLoanGuarantors,
                    child: Row(
                      children: <Widget>[
                        Radio(
                          groupValue: guarantorOptionId,
                          value: 1,
                          onChanged: (value) {
                            setState(() {
                              guarantorOptionId = value;
                            });
                          },
                        ),
                        customTitleWithWrap(
                            text: "Every time member applying loan",
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: enableLoanGuarantors,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Radio(
                          value: 2,
                          groupValue: guarantorOptionId,
                          onChanged: (value) {
                            setState(() {
                              guarantorOptionId = value;
                            });
                          },
                        ),
                        Expanded(
                          child: customTitleWithWrap(
                              text: "When a member loan request exceeds maximum loan amount",
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: enableLoanGuarantors,
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
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      customTitle(
                          text: "Charge loan processing fee",
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start),
                      Switch(
                        value: chargeLoanProcessingFee,
                        onChanged: (value) {
                          setState(() {
                            chargeLoanProcessingFee = value;
                          });
                        },
                      )
                    ],
                  ),
                  Visibility(
                    visible: chargeLoanProcessingFee,
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
                  Visibility(
                    visible: chargeLoanProcessingFee && loanProcessingFeeTypeId == 1,
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
                  Visibility(
                    visible: chargeLoanProcessingFee && loanProcessingFeeTypeId == 2,
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
                  Visibility(
                    visible: chargeLoanProcessingFee && loanProcessingFeeTypeId == 2,
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
                  SizedBox(height: 5)
                ],
              ),
            ),
          ),
          defaultButton(context: context, text: "Save & Finish", onPressed: () {} //=> widget.onButtonPressed(),
              ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
