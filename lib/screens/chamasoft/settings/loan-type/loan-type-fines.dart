import 'package:chamasoft/screens/chamasoft/settings/setup-lists/loan-setup-list.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

class LoanTypeFines extends StatefulWidget {
  final Function onButtonPressed;

  LoanTypeFines({@required this.onButtonPressed});

  @override
  _LoanTypeFinesState createState() => _LoanTypeFinesState();
}

class _LoanTypeFinesState extends State<LoanTypeFines> {
  bool enableLateLoanRepaymentFines = false;
  int lateLoanPaymentFineTypeId;

  int oneOffFineTypeId;
  double oneOffFixedAmount;
  double oneOffPercentage;
  int oneOffPercentageOnId;

  double fixedFineAmount;
  int fixedFineFrequencyId;
  int fixedFineAmountFrequencyOnId;

  double percentageFineRate;
  int percentageFineFrequencyId;
  int percentageFineOnId;

  bool enableFinesForOutstandingBalances = false;
  int outstandingBalanceFineTypeId;

  double outstandingLoanBalanceOneOffFineAmount;

  double outstandingLoanBalanceFixedFineAmount;
  int outstandingLoanBalanceFixedFineFrequencyId;

  double outstandingLoanBalancePercentageFineRate;
  int outstandingLoanBalancePercentageFineFrequencyId;
  int outstandingLoanBalancePercentageFineChargedOnId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: MediaQuery.of(context).size.height,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            customTitle(
                text: "Fines Details",
                color: Theme.of(context).textSelectionHandleColor,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.start),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            subtitle2(
                text: "Configure the fine settings",
                color: Theme.of(context).textSelectionHandleColor,
                textAlign: TextAlign.start),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            customTitle(
                text: "Enable late loan repayment fines",
                color: Theme.of(context).textSelectionHandleColor,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start),
            Switch(
              value: enableLateLoanRepaymentFines,
              onChanged: (value) {
                setState(() {
                  enableLateLoanRepaymentFines = value;
                });
              },
            )
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: enableLateLoanRepaymentFines,
                  child: Column(
                    children: <Widget>[
                      CustomDropDownButton(
                        labelText: "Late Loan repayment fine type",
                        listItems: lateLoanPaymentFineTypes,
                        selectedItem: lateLoanPaymentFineTypeId,
                        onChanged: (value) {
                          setState(() {
                            lateLoanPaymentFineTypeId = value;
                          });
                        },
                      ),
                      Visibility(
                        visible: lateLoanPaymentFineTypeId == 3,
                        child: CustomDropDownButton(
                          labelText: "Select one off fine type",
                          listItems: oneOffFineTypes,
                          selectedItem: oneOffFineTypeId,
                          onChanged: (value) {
                            setState(() {
                              oneOffFineTypeId = value;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: oneOffFineTypeId == 1,
                        child: amountTextInputField(
                          context: context,
                          labelText: 'Enter One Off Fixed Amount',
                          onChanged: (value) {
                            setState(() {
                              oneOffFixedAmount = double.parse(value);
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: oneOffFineTypeId == 2,
                        child: amountTextInputField(
                          context: context,
                          labelText: 'Enter one off percentage (%)',
                          onChanged: (value) {
                            setState(() {
                              oneOffPercentage = double.parse(value);
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: oneOffFineTypeId == 2,
                        child: CustomDropDownButton(
                          labelText: "Select percentage fine on",
                          listItems: oneOffPercentageRateOn,
                          selectedItem: oneOffPercentageOnId,
                          onChanged: (value) {
                            setState(() {
                              oneOffPercentageOnId = value;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: lateLoanPaymentFineTypeId == 1,
                        child: amountTextInputField(
                          context: context,
                          labelText: 'Enter fixed fine amount',
                          onChanged: (value) {
                            setState(() {
                              fixedFineAmount = double.parse(value);
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: lateLoanPaymentFineTypeId == 1,
                        child: CustomDropDownButton(
                          labelText: "Select amount fine frequency",
                          listItems: fixedAmountFineFrequencyOn,
                          selectedItem: fixedFineFrequencyId,
                          onChanged: (value) {
                            setState(() {
                              fixedFineFrequencyId = value;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: lateLoanPaymentFineTypeId == 2,
                        child: amountTextInputField(
                          context: context,
                          labelText: 'Enter fine percentage rate',
                          onChanged: (value) {
                            setState(() {
                              percentageFineRate = double.parse(value);
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: lateLoanPaymentFineTypeId == 2,
                        child: CustomDropDownButton(
                          labelText: "Select percentage fine Frequency",
                          listItems: latePaymentsFineFrequency,
                          selectedItem: percentageFineFrequencyId,
                          onChanged: (value) {
                            setState(() {
                              percentageFineFrequencyId = value;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: lateLoanPaymentFineTypeId == 2,
                        child: CustomDropDownButton(
                          labelText: "Select percentage fine on",
                          listItems: percentageFineOn,
                          selectedItem: percentageFineOnId,
                          onChanged: (value) {
                            setState(() {
                              percentageFineOnId = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    customTitle(
                        text: "Enable fines for outstanding balances",
                        color: Theme.of(context).textSelectionHandleColor,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start),
                    Switch(
                      value: enableFinesForOutstandingBalances,
                      onChanged: (value) {
                        setState(() {
                          enableFinesForOutstandingBalances = value;
                        });
                      },
                    )
                  ],
                ),
                Visibility(
                  visible: enableFinesForOutstandingBalances,
                  child: CustomDropDownButton(
                    labelText: "Select fine type",
                    listItems: lateLoanPaymentFineTypes,
                    selectedItem: outstandingBalanceFineTypeId,
                    onChanged: (value) {
                      setState(() {
                        outstandingBalanceFineTypeId = value;
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: outstandingBalanceFineTypeId == 1,
                  child: amountTextInputField(
                    context: context,
                    labelText: 'Outstanding Loan Balance One Off Fine Amount',
                    onChanged: (value) {
                      setState(() {
                        outstandingLoanBalanceOneOffFineAmount = double.parse(value);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: outstandingBalanceFineTypeId == 2,
                  child: amountTextInputField(
                    context: context,
                    labelText: 'Outstanding loan balance fixed fine amount',
                    onChanged: (value) {
                      setState(() {
                        outstandingLoanBalanceFixedFineAmount = double.parse(value);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: outstandingBalanceFineTypeId == 2,
                  child: CustomDropDownButton(
                    labelText: "Fixed fine amount charged on",
                    listItems: latePaymentsFineFrequency,
                    selectedItem: outstandingLoanBalanceFixedFineFrequencyId,
                    onChanged: (value) {
                      setState(() {
                        outstandingLoanBalanceFixedFineFrequencyId = value;
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: outstandingBalanceFineTypeId == 3,
                  child: amountTextInputField(
                    context: context,
                    labelText: 'Outstanding loan balance percentage fine rate',
                    onChanged: (value) {
                      setState(() {
                        outstandingLoanBalancePercentageFineRate = double.parse(value);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: outstandingBalanceFineTypeId == 3,
                  child: CustomDropDownButton(
                    labelText: "Percentage fine frequency",
                    listItems: latePaymentsFineFrequency,
                    selectedItem: outstandingLoanBalancePercentageFineFrequencyId,
                    onChanged: (value) {
                      setState(() {
                        outstandingLoanBalancePercentageFineFrequencyId = value;
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: outstandingBalanceFineTypeId == 3,
                  child: CustomDropDownButton(
                    labelText: "Percentage fine rate charged on",
                    listItems: percentageFineOn,
                    selectedItem: outstandingLoanBalancePercentageFineChargedOnId,
                    onChanged: (value) {
                      setState(() {
                        outstandingLoanBalancePercentageFineChargedOnId = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            defaultButton(
              context: context,
              text: "Save & Continue",
              onPressed: () => widget.onButtonPressed(),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ]),
    );
  }
}
