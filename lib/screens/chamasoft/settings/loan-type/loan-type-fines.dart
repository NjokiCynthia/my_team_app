import 'dart:developer';

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/setup-lists/loan-setup-list.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoanTypeFines extends StatefulWidget {
  final dynamic responseData;
  final bool isEditMode;
  final dynamic loanDetails;
  final Function(dynamic) onButtonPressed;

  LoanTypeFines(
      {this.responseData,
      this.isEditMode,
      this.loanDetails,
      @required this.onButtonPressed});

  @override
  _LoanTypeFinesState createState() => _LoanTypeFinesState();
}

class _LoanTypeFinesState extends State<LoanTypeFines> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormEnabled = true;
  var _isLoading = false;

  String requestId =
      ((DateTime.now().millisecondsSinceEpoch / 1000).truncate()).toString();
  String loanTypeID;

  bool enableLateLoanRepaymentFines = false;
  int lateLoanPaymentFineTypeId;

  int oneOffFineTypeId;
  String oneOffFixedAmount;
  String oneOffPercentage;
  int oneOffPercentageOnId;

  String fixedFineAmount;
  int fixedFineFrequencyId;
  int fixedFineAmountFrequencyOnId;

  String percentageFineRate;
  int percentageFineFrequencyId;
  int percentageFineOnId;

  bool enableFinesForOutstandingBalances = false;
  int outstandingBalanceFineTypeId;

  String outstandingLoanBalanceOneOffFineAmount;

  String outstandingLoanBalanceFixedFineAmount;
  int outstandingLoanBalanceFixedFineFrequencyId;

  String outstandingLoanBalancePercentageFineRate;
  int outstandingLoanBalancePercentageFineFrequencyId;
  int outstandingLoanBalancePercentageFineChargedOnId;

  void _getFineDetails() {
    if (widget.isEditMode) {
      dynamic type = widget.loanDetails['loan_type'] as dynamic;
      loanTypeID = type['id'].toString();

      dynamic settings = widget.loanDetails['fine'] as dynamic;

      log(settings.toString());
      enableLateLoanRepaymentFines =
          (int.tryParse(settings['enable_loan_fines'].toString()) ?? 0) == 1
              ? true
              : false;
      lateLoanPaymentFineTypeId =
          parseZeroDropdownValues(settings, "loan_fine_type");
      oneOffFineTypeId = parseZeroDropdownValues(settings, "one_off_fine_type");
      oneOffFixedAmount = settings['one_off_fixed_amount'].toString();
      oneOffPercentage = settings['one_off_percentage_rate'].toString();
      oneOffPercentageOnId =
          parseZeroDropdownValues(settings, "one_off_percentage_rate_on");
      fixedFineAmount = settings['fixed_fine_amount'].toString();
      fixedFineFrequencyId =
          parseZeroDropdownValues(settings, "fixed_amount_fine_frequency");
      fixedFineAmountFrequencyOnId =
          parseZeroDropdownValues(settings, "fixed_amount_fine_frequency_on");
      percentageFineRate = settings['percentage_fine_rate'].toString();
      percentageFineFrequencyId =
          parseZeroDropdownValues(settings, "percentage_fine_frequency");
      percentageFineOnId =
          parseZeroDropdownValues(settings, "percentage_fine_on");

      enableFinesForOutstandingBalances = (int.tryParse(
                      settings['enable_outstanding_loan_balance_fines']
                          .toString()) ??
                  0) ==
              1
          ? true
          : false;
      outstandingBalanceFineTypeId = parseZeroDropdownValues(
          settings, "outstanding_loan_balance_fine_type");
      outstandingLoanBalanceOneOffFineAmount =
          settings['outstanding_loan_balance_fine_one_off_amount'].toString();
      outstandingLoanBalanceFixedFineAmount =
          settings['outstanding_loan_balance_fine_fixed_amount'].toString();
      outstandingLoanBalanceFixedFineFrequencyId = parseZeroDropdownValues(
          settings, "outstanding_loan_balance_fixed_fine_frequency");
      outstandingLoanBalancePercentageFineRate =
          settings['outstanding_loan_balance_percentage_fine_rate'].toString();
      outstandingLoanBalancePercentageFineFrequencyId = parseZeroDropdownValues(
          settings, "outstanding_loan_balance_percentage_fine_frequency");
      outstandingLoanBalancePercentageFineChargedOnId = parseZeroDropdownValues(
          settings, "outstanding_loan_balance_percentage_fine_on");
    } else
      loanTypeID = widget.responseData['id'].toString();
  }

  int parseZeroDropdownValues(dynamic settings, String key) {
    int value = int.tryParse(settings[key].toString()) ?? null;

    if (value == null || value != 0) {
      return value;
    } else
      return null;
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      print("Fine settings OK");
    }

    setState(() {
      _isFormEnabled = false;
      _isLoading = true;
    });

    Map<String, dynamic> formData = {};

    formData["request_id"] = requestId;
    formData["id"] = loanTypeID;
    formData["enable_loan_fines"] = enableLateLoanRepaymentFines ? 1 : 0;
    formData["loan_fine_type"] = lateLoanPaymentFineTypeId;
    formData["fixed_fine_amount"] = fixedFineAmount;
    formData["fixed_amount_fine_frequency"] = fixedFineFrequencyId;
    formData["fixed_amount_fine_frequency_on"] = fixedFineAmountFrequencyOnId;
    formData["percentage_fine_rate"] = percentageFineRate;
    formData["percentage_fine_frequency"] = percentageFineFrequencyId;
    formData["percentage_fine_on"] = percentageFineOnId;
    formData["one_off_fine_type"] = oneOffFineTypeId;
    formData["one_off_fixed_amount"] = oneOffFixedAmount;
    formData["one_off_percentage_rate"] = oneOffPercentage;
    formData["one_off_percentage_rate_on"] = oneOffPercentageOnId;
    formData["enable_outstanding_loan_balance_fines"] =
        enableFinesForOutstandingBalances ? 1 : 0;
    formData["outstanding_loan_balance_fine_type"] =
        outstandingBalanceFineTypeId;
    formData["outstanding_loan_balance_fine_fixed_amount"] =
        outstandingLoanBalanceFixedFineAmount;
    formData["outstanding_loan_balance_fixed_fine_frequency"] =
        outstandingLoanBalanceFixedFineFrequencyId;
    formData["outstanding_loan_balance_percentage_fine_rate"] =
        outstandingLoanBalancePercentageFineRate;
    formData["outstanding_loan_balance_percentage_fine_frequency"] =
        outstandingLoanBalancePercentageFineFrequencyId;
    formData["outstanding_loan_balance_percentage_fine_on"] =
        outstandingLoanBalancePercentageFineChargedOnId;
    formData["outstanding_loan_balance_fine_one_off_amount"] =
        outstandingLoanBalanceOneOffFineAmount;

    print("$formData");
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .addLoanTypeStepTwo(formData);
      print(response);
      requestId = null;
      alertDialogWithAction(context, response["message"].toString(), () {
        Navigator.of(context).pop();
        widget.onButtonPressed(response);
      }, false);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _submit(context);
          });
    } finally {
      setState(() {
        _isLoading = false;
        _isFormEnabled = true;
      });
    }
  }

  @override
  void initState() {
    _getFineDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("${widget.loanDetails}");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: MediaQuery.of(context).size.height,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                customTitle(
                    text: "Fines Details",
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.start),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                subtitle2(
                    text: "Configure the fine settings",
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                    textAlign: TextAlign.start),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          customTitle(
                              text: "Enable late loan repayment fines",
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                              fontWeight: FontWeight.w600,
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
                      Visibility(
                        visible: enableLateLoanRepaymentFines,
                        child: Column(
                          children: <Widget>[
                            CustomDropDownButton(
                                labelText: "Late Loan repayment fine type",
                                listItems: lateLoanPaymentFineTypes,
                                enabled: _isFormEnabled,
                                selectedItem: lateLoanPaymentFineTypeId,
                                onChanged: (value) {
                                  setState(() {
                                    lateLoanPaymentFineTypeId = value;
                                  });
                                },
                                validator: (value) {
                                  if (enableLateLoanRepaymentFines) if (value ==
                                      null) {
                                    return "This field is required";
                                  }
                                  return null;
                                }),
                            Visibility(
                              visible: lateLoanPaymentFineTypeId == 3,
                              child: CustomDropDownButton(
                                  labelText: "Select one off fine type",
                                  listItems: oneOffFineTypes,
                                  enabled: _isFormEnabled,
                                  selectedItem: oneOffFineTypeId,
                                  onChanged: (value) {
                                    setState(() {
                                      oneOffFineTypeId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (enableLateLoanRepaymentFines &&
                                        lateLoanPaymentFineTypeId ==
                                            3) if (value == null) {
                                      return "This field is required";
                                    }
                                    return null;
                                  }),
                            ),
                            Visibility(
                              visible: lateLoanPaymentFineTypeId == 3 &&
                                  oneOffFineTypeId == 1,
                              child: numberDecimalFieldWithInitialValue(
                                initialValue: oneOffFixedAmount != null
                                    ? oneOffFixedAmount
                                    : '',
                                context: context,
                                isFormEnabled: _isFormEnabled,
                                labelText: 'Enter One Off Fixed Amount',
                                onChanged: (value) {
                                  oneOffFixedAmount = value;
                                },
                                validator: (value) {
                                  if (enableLateLoanRepaymentFines &&
                                      oneOffFineTypeId == 1) {
                                    if (value.trim() == '' ||
                                        value.trim() == null) {
                                      return 'This field is required';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Visibility(
                              visible: lateLoanPaymentFineTypeId == 3 &&
                                  oneOffFineTypeId == 2,
                              child: numberDecimalFieldWithInitialValue(
                                initialValue: oneOffPercentage != null
                                    ? oneOffPercentage
                                    : '',
                                context: context,
                                isFormEnabled: _isFormEnabled,
                                labelText: 'Enter one off percentage (%)',
                                onChanged: (value) {
                                  oneOffPercentage = value;
                                },
                                validator: (value) {
                                  if (enableLateLoanRepaymentFines &&
                                      oneOffFineTypeId == 2) {
                                    if (value.trim() == '' ||
                                        value.trim() == null) {
                                      return 'This field is required';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Visibility(
                              visible: lateLoanPaymentFineTypeId == 3 &&
                                  oneOffFineTypeId == 2,
                              child: CustomDropDownButton(
                                  labelText: "Select percentage fine on",
                                  listItems: oneOffPercentageRateOn,
                                  selectedItem: oneOffPercentageOnId,
                                  enabled: _isFormEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      oneOffPercentageOnId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (enableLateLoanRepaymentFines &&
                                        oneOffFineTypeId ==
                                            2) if (value == null) {
                                      return "This field is required";
                                    }
                                    return null;
                                  }),
                            ),
                            Visibility(
                              visible: lateLoanPaymentFineTypeId == 1,
                              child: numberDecimalFieldWithInitialValue(
                                initialValue: fixedFineAmount != null
                                    ? fixedFineAmount
                                    : '',
                                context: context,
                                labelText: 'Enter fixed fine amount',
                                isFormEnabled: _isFormEnabled,
                                onChanged: (value) {
                                  fixedFineAmount = value;
                                },
                                validator: (value) {
                                  if (enableLateLoanRepaymentFines &&
                                      lateLoanPaymentFineTypeId == 1) {
                                    if (value.trim() == '' ||
                                        value.trim() == null) {
                                      return 'This field is required';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Visibility(
                              visible: lateLoanPaymentFineTypeId == 1,
                              child: CustomDropDownButton(
                                  labelText: "Select amount fine frequency",
                                  listItems: fixedAmountFineFrequencyOn,
                                  selectedItem: fixedFineFrequencyId,
                                  enabled: _isFormEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      fixedFineFrequencyId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (enableLateLoanRepaymentFines &&
                                        lateLoanPaymentFineTypeId ==
                                            1) if (value == null) {
                                      return "This field is required";
                                    }
                                    return null;
                                  }),
                            ),
                            Visibility(
                              visible: lateLoanPaymentFineTypeId == 2,
                              child: numberDecimalFieldWithInitialValue(
                                initialValue: percentageFineRate != null
                                    ? percentageFineRate
                                    : '',
                                context: context,
                                isFormEnabled: _isFormEnabled,
                                labelText: 'Enter fine percentage rate',
                                onChanged: (value) {
                                  percentageFineRate = value;
                                },
                                validator: (value) {
                                  if (enableLateLoanRepaymentFines &&
                                      lateLoanPaymentFineTypeId == 2) {
                                    if (value.trim() == '' ||
                                        value.trim() == null) {
                                      return 'This field is required';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Visibility(
                              visible: lateLoanPaymentFineTypeId == 2,
                              child: CustomDropDownButton(
                                  labelText: "Select percentage fine Frequency",
                                  listItems: latePaymentsFineFrequency,
                                  selectedItem: percentageFineFrequencyId,
                                  enabled: _isFormEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      percentageFineFrequencyId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (enableLateLoanRepaymentFines &&
                                        lateLoanPaymentFineTypeId ==
                                            2) if (value == null) {
                                      return "This field is required";
                                    }
                                    return null;
                                  }),
                            ),
                            Visibility(
                              visible: lateLoanPaymentFineTypeId == 2,
                              child: CustomDropDownButton(
                                  labelText: "Select percentage fine on",
                                  listItems: percentageFineOn,
                                  selectedItem: percentageFineOnId,
                                  enabled: _isFormEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      percentageFineOnId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (enableLateLoanRepaymentFines &&
                                        lateLoanPaymentFineTypeId ==
                                            2) if (value == null) {
                                      return "This field is required";
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          customTitle(
                              text: "Enable fines for outstanding balances",
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                              fontWeight: FontWeight.w600,
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
                        child: Column(children: <Widget>[
                          CustomDropDownButton(
                              labelText: "Select fine type",
                              listItems: lateLoanPaymentFineTypes,
                              selectedItem: outstandingBalanceFineTypeId,
                              enabled: _isFormEnabled,
                              onChanged: (value) {
                                setState(() {
                                  outstandingBalanceFineTypeId = value;
                                });
                              },
                              validator: (value) {
                                if (enableFinesForOutstandingBalances) if (value ==
                                    null) {
                                  return "This field is required";
                                }
                                return null;
                              }),
                          Visibility(
                            visible: outstandingBalanceFineTypeId == 3,
                            child: numberDecimalFieldWithInitialValue(
                                initialValue:
                                    outstandingLoanBalanceOneOffFineAmount !=
                                            null
                                        ? outstandingLoanBalanceOneOffFineAmount
                                        : '',
                                context: context,
                                labelText:
                                    'Outstanding Loan Balance One Off Fine Amount',
                                isFormEnabled: _isFormEnabled,
                                onChanged: (value) {
                                  outstandingLoanBalanceOneOffFineAmount =
                                      value;
                                },
                                validator: (value) {
                                  if (enableFinesForOutstandingBalances &&
                                      outstandingBalanceFineTypeId ==
                                          3) if (value.trim() == '' ||
                                      value.trim() == null) {
                                    return "This field is required";
                                  }
                                  return null;
                                }),
                          ),
                          Visibility(
                            visible: outstandingBalanceFineTypeId == 1,
                            child: numberDecimalFieldWithInitialValue(
                                initialValue:
                                    outstandingLoanBalanceFixedFineAmount !=
                                            null
                                        ? outstandingLoanBalanceFixedFineAmount
                                        : '',
                                context: context,
                                isFormEnabled: _isFormEnabled,
                                labelText:
                                    'Outstanding Loan Balance Fixed Fine Amount',
                                onChanged: (value) {
                                  outstandingLoanBalanceFixedFineAmount = value;
                                },
                                validator: (value) {
                                  if (enableFinesForOutstandingBalances &&
                                      outstandingBalanceFineTypeId == 1) {
                                    if (value.trim() == '' ||
                                        value.trim() == null) {
                                      return 'This field is required';
                                    }
                                  }
                                  return null;
                                }),
                          ),
                          Visibility(
                            visible: outstandingBalanceFineTypeId == 1,
                            child: CustomDropDownButton(
                                labelText: "Fixed Fine Amount Frequency",
                                listItems: latePaymentsFineFrequency,
                                selectedItem:
                                    outstandingLoanBalanceFixedFineFrequencyId,
                                enabled: _isFormEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    outstandingLoanBalanceFixedFineFrequencyId =
                                        value;
                                  });
                                },
                                validator: (value) {
                                  if (enableFinesForOutstandingBalances &&
                                      outstandingBalanceFineTypeId ==
                                          1) if (value == null) {
                                    return "This field is required";
                                  }
                                  return null;
                                }),
                          ),
                          Visibility(
                            visible: outstandingBalanceFineTypeId == 2,
                            child: numberDecimalFieldWithInitialValue(
                              initialValue:
                                  outstandingLoanBalancePercentageFineRate !=
                                          null
                                      ? outstandingLoanBalancePercentageFineRate
                                      : '',
                              context: context,
                              isFormEnabled: _isFormEnabled,
                              labelText:
                                  'Outstanding Loan Balance Percentage Fine Rate',
                              onChanged: (value) {
                                outstandingLoanBalancePercentageFineRate =
                                    value;
                              },
                              validator: (value) {
                                if (enableFinesForOutstandingBalances &&
                                    outstandingBalanceFineTypeId == 2) {
                                  if (value.trim() == '' ||
                                      value.trim() == null) {
                                    return 'This field is required';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          Visibility(
                            visible: outstandingBalanceFineTypeId == 2,
                            child: CustomDropDownButton(
                                labelText: "Percentage Fine Frequency",
                                listItems: latePaymentsFineFrequency,
                                selectedItem:
                                    outstandingLoanBalancePercentageFineFrequencyId,
                                enabled: _isFormEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    outstandingLoanBalancePercentageFineFrequencyId =
                                        value;
                                  });
                                },
                                validator: (value) {
                                  if (enableFinesForOutstandingBalances &&
                                      outstandingBalanceFineTypeId ==
                                          2) if (value == null) {
                                    return "This field is required";
                                  }
                                  return null;
                                }),
                          ),
                          Visibility(
                            visible: outstandingBalanceFineTypeId == 2,
                            child: CustomDropDownButton(
                                labelText: "Percentage Fine Rate Charged On",
                                listItems: percentageFineOn,
                                selectedItem:
                                    outstandingLoanBalancePercentageFineChargedOnId,
                                enabled: _isFormEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    outstandingLoanBalancePercentageFineChargedOnId =
                                        value;
                                  });
                                },
                                validator: (value) {
                                  if (enableFinesForOutstandingBalances &&
                                      outstandingBalanceFineTypeId ==
                                          2) if (value == null) {
                                    return "This field is required";
                                  }
                                  return null;
                                }),
                          ),
                        ]),
                      ),
                      SizedBox(height: 5)
                    ],
                  ),
                ),
              ),
            ),
            _isLoading
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    children: [
                      defaultButton(
                          context: context,
                          text: "Save & Continue",
                          onPressed: () => _submit(context)),
                    ],
                  ),
            SizedBox(
              height: 10,
            )
          ]),
    );
  }
}
