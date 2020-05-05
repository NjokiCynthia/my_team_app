import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'setup-lists/loan-setup-list.dart';

class CreateLoanType extends StatefulWidget {
  @override
  _CreateLoanTypeState createState() => _CreateLoanTypeState();
}

class _CreateLoanTypeState extends State<CreateLoanType>
    with SingleTickerProviderStateMixin {
  double _appBarElevation = 0;
  PageController _pageController;

  //Loan Details
  String loanTypeName = '';
  int loanAmountTypeId;
  double minimumLoanAmount;
  double maximumLoanAmount;
  double timesNumberOfSavings;

  int interestTypeId;
  bool enableLoanReducingBalanceRecalculation;
  double loanInterestRate;
  int loanInterestRatePerId;
  int loanRepaymentTypeId;
  double fixedRepaymentPeriod;
  double minimumRepaymentPeriod;
  double maximumRepaymentPeriod;

  //Fines
  bool enableLateLoanRepaymentFines;
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

  bool enableFinesForOutstandingBalances;
  int outstandingBalanceFineTypeId;

  double outstandingLoanBalanceOneOffFineAmount;

  double outstandingLoanBalanceFixedFineAmount;
  int outstandingLoanBalanceFixedFineFrequencyId;

  double outstandingLoanBalancePercentageFineRate;
  int outstandingLoanBalancePercentageFineFrequencyId;
  int outstandingLoanBalancePercentageFineChargedOnId;

  //General Details
  bool enableLoanGuarantors;

  int guarantorOptionId;
  int minimumAllowedGuarantors;

  bool chargeLoanProcessingFee;

  int loanProcessingFeeTypeId;

  double loanProcessingFeeAmount;
  double loanProcessingFeePercentage;
  int loanProcessingFeePercentageChargedOnId;

  int currentPage = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageTabbedAppbar(
        context: context,
        title: "Create Loan Type",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Divider(
                        thickness: 5.0,
                        indent: 10,
                        endIndent: 10,
                        color:
                            currentPage == 0 ? primaryColor : Color(0xFFAEAEAE),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Divider(
                        thickness: 5.0,
                        indent: 10,
                        endIndent: 10,
                        color:
                            currentPage == 1 ? primaryColor : Color(0xFFAEAEAE),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Divider(
                        thickness: 5.0,
                        indent: 10,
                        endIndent: 10,
                        color:
                            currentPage == 2 ? primaryColor : Color(0xFFAEAEAE),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "Settings",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "Configure the behaviour of your loan",
                            style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
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
                                          minimumLoanAmount =
                                              double.parse(value);
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
                                          maximumLoanAmount =
                                              double.parse(value);
                                        });
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: loanAmountTypeId == 2,
                                    child: amountTextInputField(
                                      context: context,
                                      labelText:
                                          'How many times the member savings',
                                      onChanged: (value) {
                                        setState(() {
                                          timesNumberOfSavings =
                                              double.parse(value);
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
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textSelectionHandleColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      value:
                                          enableLoanReducingBalanceRecalculation,
                                      onChanged: (bool value) {
                                        setState(() {
                                          enableLoanReducingBalanceRecalculation =
                                              value;
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
                                          fixedRepaymentPeriod =
                                              double.parse(value);
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
                                          minimumRepaymentPeriod =
                                              double.parse(value);
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
                                          maximumRepaymentPeriod =
                                              double.parse(value);
                                        });
                                      },
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            if (_pageController.hasClients) {
                              _pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }

                            setState(() {
                              currentPage = 1;
                            });
                          },
                          color: primaryColor,
                          child: Text(
                            'Save & Continue',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "Fines",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                "",
                                style: TextStyle(
                                    color: Theme.of(context).bottomAppBarColor),
                              ),
                            ),
                            SwitchListTile(
                              title: Text(
                                "Enable late loan repayment fines",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              value: enableLateLoanRepaymentFines,
                              onChanged: (bool value) {
                                setState(() {
                                  enableLateLoanRepaymentFines = value;
                                });
                              },
                            ),
                            Visibility(
                              visible: enableLateLoanRepaymentFines,
                              child: CustomDropDownButton(
                                labelText: "Late Loan repayment fine type",
                                listItems: lateLoanPaymentFineTypes,
                                selectedItem: lateLoanPaymentFineTypeId,
                                onChanged: (value) {
                                  setState(() {
                                    lateLoanPaymentFineTypeId = value;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: lateLoanPaymentFineTypeId == 1,
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
                              visible: lateLoanPaymentFineTypeId == 2,
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
                              visible: oneOffFineTypeId == 2,
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
                              visible: lateLoanPaymentFineTypeId == 3,
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
                              visible: lateLoanPaymentFineTypeId == 3,
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
                              visible: lateLoanPaymentFineTypeId == 3,
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
                            SwitchListTile(
                              title: Text(
                                "Enable fines for outstanding balances",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              value: enableFinesForOutstandingBalances,
                              onChanged: (bool value) {
                                setState(() {
                                  enableFinesForOutstandingBalances = value;
                                });
                              },
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
                                labelText:
                                    'Outstanding Loan Balance One Off Fine Amount',
                                onChanged: (value) {
                                  setState(() {
                                    outstandingLoanBalanceOneOffFineAmount =
                                        double.parse(value);
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: outstandingBalanceFineTypeId == 2,
                              child: amountTextInputField(
                                context: context,
                                labelText:
                                    'Outstanding loan balance fixed fine amount',
                                onChanged: (value) {
                                  setState(() {
                                    outstandingLoanBalanceFixedFineAmount =
                                        double.parse(value);
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: outstandingBalanceFineTypeId == 2,
                              child: CustomDropDownButton(
                                labelText: "Fixed fine amount charged on",
                                listItems: latePaymentsFineFrequency,
                                selectedItem:
                                    outstandingLoanBalanceFixedFineFrequencyId,
                                onChanged: (value) {
                                  setState(() {
                                    outstandingLoanBalanceFixedFineFrequencyId =
                                        value;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: outstandingBalanceFineTypeId == 3,
                              child: amountTextInputField(
                                context: context,
                                labelText:
                                    'Outstanding loan balance percentage fine rate',
                                onChanged: (value) {
                                  setState(() {
                                    outstandingLoanBalancePercentageFineRate =
                                        double.parse(value);
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: outstandingBalanceFineTypeId == 3,
                              child: CustomDropDownButton(
                                labelText: "Percentage fine frequency",
                                listItems: latePaymentsFineFrequency,
                                selectedItem:
                                    outstandingLoanBalancePercentageFineFrequencyId,
                                onChanged: (value) {
                                  setState(() {
                                    outstandingLoanBalancePercentageFineFrequencyId =
                                        value;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: outstandingBalanceFineTypeId == 3,
                              child: CustomDropDownButton(
                                labelText: "Percentage fine rate charged on",
                                listItems: percentageFineOn,
                                selectedItem:
                                    outstandingLoanBalancePercentageFineChargedOnId,
                                onChanged: (value) {
                                  setState(() {
                                    outstandingLoanBalancePercentageFineChargedOnId =
                                        value;
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () {
                                    if (_pageController.hasClients) {
                                      _pageController.animateToPage(
                                        0,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    }

                                    setState(() {
                                      currentPage = 0;
                                    });
                                  },
                                  color: primaryColor,
                                  child: Text(
                                    'Back',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    if (_pageController.hasClients) {
                                      _pageController.animateToPage(
                                        2,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    }

                                    setState(() {
                                      currentPage = 2;
                                    });
                                  },
                                  color: primaryColor,
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "General Details",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "",
                            style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor),
                          ),
                        ),
                        SwitchListTile(
                          title: Text(
                            "Enable loan guarantors",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          value: enableLoanGuarantors,
                          onChanged: (bool value) {
                            setState(() {
                              enableLoanGuarantors = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "Charge loan processing fee",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          value: chargeLoanProcessingFee,
                          onChanged: (bool value) {
                            setState(() {
                              chargeLoanProcessingFee = value;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                if (_pageController.hasClients) {
                                  _pageController.animateToPage(
                                    1,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                }

                                setState(() {
                                  currentPage = 1;
                                });
                              },
                              color: primaryColor,
                              child: Text(
                                'Back',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                print('Ready to save values');
                              },
                              color: primaryColor,
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
