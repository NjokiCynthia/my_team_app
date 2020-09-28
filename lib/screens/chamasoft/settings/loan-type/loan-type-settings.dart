import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/setup-lists/loan-setup-list.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoanTypeSettings extends StatefulWidget {
  final Function onButtonPressed;

  LoanTypeSettings({@required this.onButtonPressed});

  @override
  _LoanTypeSettingsState createState() => _LoanTypeSettingsState();
}

class _LoanTypeSettingsState extends State<LoanTypeSettings> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormEnabled = true;
  var _isLoading = false;
  String requestId = ((DateTime.now().millisecondsSinceEpoch / 1000).truncate()).toString();

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
  int fixedRepaymentPeriod;
  int minimumRepaymentPeriod;
  int maximumRepaymentPeriod;

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      print("No validation issues");
    }

    setState(() {
      _isFormEnabled = false;
      _isLoading = true;
    });

    Map<String, dynamic> formData = {};

    formData["request_id"] = requestId;
    formData["name"] = loanTypeName;
    formData["loan_amount_type"] = loanAmountTypeId;
    formData['minimum_loan_amount'] = minimumLoanAmount;
    formData["maximum_loan_amount"] = maximumLoanAmount;
    formData['savings_times'] = timesNumberOfSavings;
    formData["interest_type"] = interestTypeId;
    formData["enable_reducing_balance_installment_recalculation"] = enableLoanReducingBalanceRecalculation ? 1 : 0;
    formData["interest_rate"] = loanInterestRate;
    formData["interest_rate_per"] = loanInterestRatePerId;
    formData["repayment_period_type"] = loanRepaymentTypeId;
    formData["fixed_repayment_period"] = fixedRepaymentPeriod;
    formData["minimum_repayment_period"] = minimumRepaymentPeriod;
    formData["maximum_repayment_period"] = maximumRepaymentPeriod;

    print(formData);

    //formData["id"] = contributionId; //TODO: Editing

    // if (loanTypeID != 0) {
    //   url = Constants.EDIT_LOAN_TYPE;
    //   jsonObject.addProperty("id", loanTypeID);
    // }

    try {
      final response = await Provider.of<Groups>(context, listen: false).addLoanTypeStepOne(formData, false);
      print(response);
      requestId = null;
      alertDialogWithAction(context, response["message"].toString(), () {
        Navigator.of(context).pop();
        //widget.onButtonPressed(response);
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
              child: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  simpleTextInputField(
                      context: context,
                      enabled: _isFormEnabled,
                      labelText: 'Loan Type Name',
                      onChanged: (value) {
                        setState(() {
                          loanTypeName = value;
                        });
                      },
                      validator: (value) {
                        if (value.trim() == '' || value.trim() == null) {
                          return 'This field is required';
                        }
                        return null;
                      }),
                  CustomDropDownButton(
                      labelText: "Loan Amount Type",
                      listItems: loanAmountTypes,
                      selectedItem: loanAmountTypeId,
                      enabled: _isFormEnabled,
                      onChanged: (value) {
                        setState(() {
                          loanAmountTypeId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                        return null;
                      }),
                  Visibility(
                    visible: loanAmountTypeId == 1,
                    child: amountTextInputField(
                        context: context,
                        labelText: 'Minimum Loan Amount',
                        enabled: _isFormEnabled,
                        onChanged: (value) {
                          setState(() {
                            minimumLoanAmount = double.parse(value);
                          });
                        },
                        validator: (value) {
                          if (loanAmountTypeId == 1) {
                            if (value.trim() == '' || value.trim() == null) {
                              return 'This field is required';
                            }
                            return null;
                          }
                        }),
                  ),
                  Visibility(
                    visible: loanAmountTypeId == 1,
                    child: amountTextInputField(
                        context: context,
                        labelText: 'Maximum  Loan Amount',
                        enabled: _isFormEnabled,
                        onChanged: (value) {
                          setState(() {
                            maximumLoanAmount = double.parse(value);
                          });
                        },
                        validator: (value) {
                          if (loanAmountTypeId == 1) {
                            if (value.trim() == '' || value.trim() == null) {
                              return 'This field is required';
                            }
                            return null;
                          }
                        }),
                  ),
                  Visibility(
                    visible: loanAmountTypeId == 2,
                    child: amountTextInputField(
                        context: context,
                        labelText: 'How many times the member savings',
                        enabled: _isFormEnabled,
                        onChanged: (value) {
                          setState(() {
                            timesNumberOfSavings = double.parse(value);
                          });
                        },
                        validator: (value) {
                          if (loanAmountTypeId == 2) {
                            if (value.trim() == '' || value.trim() == null) {
                              return 'This field is required';
                            }
                            return null;
                          }
                        }),
                  ),
                  CustomDropDownButton(
                      labelText: "Interest Type",
                      listItems: interestTypes,
                      selectedItem: interestTypeId,
                      enabled: _isFormEnabled,
                      onChanged: (value) {
                        setState(() {
                          interestTypeId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                        return null;
                      }),
                  Visibility(
                    visible: interestTypeId == 2,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          customTitle(
                              text: "Enable late loan repayment fines",
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start),
                          Switch(
                            value: enableLoanReducingBalanceRecalculation,
                            onChanged: (value) {
                              setState(() {
                                enableLoanReducingBalanceRecalculation = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  amountTextInputField(
                      context: context,
                      labelText: 'Loan Interest Rate(%)',
                      enabled: _isFormEnabled,
                      onChanged: (value) {
                        setState(() {
                          loanInterestRate = double.parse(value);
                        });
                      },
                      validator: (value) {
                        if (value.trim() == '' || value.trim() == null) {
                          return 'This field is required';
                        }
                        return null;
                      }),
                  CustomDropDownButton(
                      labelText: "Loan Interest Rate Per",
                      listItems: loanInterestRatePer,
                      selectedItem: loanInterestRatePerId,
                      enabled: _isFormEnabled,
                      onChanged: (value) {
                        setState(() {
                          loanInterestRatePerId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                        return null;
                      }),
                  CustomDropDownButton(
                      labelText: "Loan Repayment Period Type",
                      listItems: loanRepaymentType,
                      selectedItem: loanRepaymentTypeId,
                      enabled: _isFormEnabled,
                      onChanged: (value) {
                        setState(() {
                          loanRepaymentTypeId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                        return null;
                      }),
                  Visibility(
                    visible: loanRepaymentTypeId == 1,
                    child: amountTextInputField(
                        context: context,
                        labelText: 'Fixed Repayment Period',
                        hintText: 'Value in months . E.g 3',
                        onChanged: (value) {
                          setState(() {
                            fixedRepaymentPeriod = int.tryParse(value) ?? 1;
                          });
                        },
                        validator: (value) {
                          if (loanRepaymentTypeId == 1) {
                            if (value.trim() == '' || value.trim() == null) {
                              return 'This field is required';
                            }
                            return null;
                          }
                        }),
                  ),
                  Visibility(
                    visible: loanRepaymentTypeId == 2,
                    child: amountTextInputField(
                        context: context,
                        labelText: 'Minimum Repayment Period',
                        hintText: 'Value in months . E.g 3',
                        onChanged: (value) {
                          setState(() {
                            minimumRepaymentPeriod = int.tryParse(value) ?? 1;
                          });
                        },
                        validator: (value) {
                          if (loanRepaymentTypeId == 2) {
                            if (value.trim() == '' || value.trim() == null) {
                              return 'This field is required';
                            }
                            return null;
                          }
                        }),
                  ),
                  Visibility(
                    visible: loanRepaymentTypeId == 2,
                    child: amountTextInputField(
                        context: context,
                        labelText: 'Maximum Repayment period',
                        hintText: 'Value in months . E.g 12',
                        onChanged: (value) {
                          setState(() {
                            maximumRepaymentPeriod = int.tryParse(value) ?? 1;
                          });
                        },
                        validator: (value) {
                          if (loanRepaymentTypeId == 2) {
                            if (value.trim() == '' || value.trim() == null) {
                              return 'This field is required';
                            }
                            return null;
                          }
                        }),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ]),
              ),
            ),
          ),
          _isLoading
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(child: CircularProgressIndicator()),
                )
              : defaultButton(
                  context: context,
                  text: "Save & Continue",
                  onPressed: () {
                    _submit(context);
                  }),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
