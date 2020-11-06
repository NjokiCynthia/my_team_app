import 'dart:developer';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/setup-lists/loan-setup-list.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoanTypeSettings extends StatefulWidget {
  final bool isEditMode;
  final dynamic loanDetails;
  final Function(dynamic) onButtonPressed;

  LoanTypeSettings({this.isEditMode, this.loanDetails, @required this.onButtonPressed});

  @override
  _LoanTypeSettingsState createState() => _LoanTypeSettingsState();
}

class _LoanTypeSettingsState extends State<LoanTypeSettings> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormEnabled = true;
  var _isLoading = false;
  String requestId = ((DateTime.now().millisecondsSinceEpoch / 1000).truncate()).toString();

  String loanTypeID;
  String loanTypeName = '';
  int loanAmountTypeId;
  String minimumLoanAmount;
  String maximumLoanAmount;
  String timesNumberOfSavings;
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

    if (widget.isEditMode) formData["id"] = loanTypeID;
    print(formData);

    try {
      final response =
          await Provider.of<Groups>(context, listen: false).addLoanTypeStepOne(formData, widget.isEditMode);
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

  void _prepareForm() {
    log('Editing ${widget.loanDetails}');
    dynamic settings = widget.loanDetails['loan_type'] as dynamic;
    log('Settings $settings');

    setState(() {
      loanTypeID = settings['id'].toString();
      loanTypeName = settings['name'].toString();
      loanAmountTypeId = int.tryParse(settings['loan_amount_type'].toString()) ?? null;
      minimumLoanAmount = settings['minimum_loan_amount'].toString();
      maximumLoanAmount = settings['maximum_loan_amount'].toString();
      timesNumberOfSavings = settings['savings_times'].toString();
      interestTypeId = int.tryParse(settings['interest_type'].toString()) ?? null;
      enableLoanReducingBalanceRecalculation =
          (int.tryParse(settings['enable_reducing_balance_installment_recalculation'].toString()) ?? 0) == 1
              ? true
              : false;
      loanInterestRate = double.tryParse(settings['interest_rate'].toString()) ?? null;
      loanInterestRatePerId = int.tryParse(settings['loan_interest_rate_per'].toString()) ?? null;
      loanRepaymentTypeId = int.tryParse(settings['loan_repayment_period_type'].toString()) ?? null;
      fixedRepaymentPeriod = int.tryParse(settings['fixed_repayment_period'].toString()) ?? null;
      minimumRepaymentPeriod = int.tryParse(settings['minimum_repayment_period'].toString()) ?? null;
      maximumRepaymentPeriod = int.tryParse(settings['maximum_repayment_period'].toString()) ?? null;
    });
  }

  @override
  void initState() {
    if (widget.isEditMode) {
      _prepareForm();
    }
    super.initState();
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
                  TextFormField(
                    initialValue: loanTypeName != null ? loanTypeName : '',
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: inputTextStyle(),
                    enabled: _isFormEnabled,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                        labelText: 'Loan Type Name',
                        labelStyle: inputTextStyle()),
                    onChanged: (value) {
                      loanTypeName = value;
                    },
                    validator: (value) {
                      if (value.trim() == '' || value.trim() == null) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
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
                    child: TextFormField(
                      initialValue: minimumLoanAmount != null ? minimumLoanAmount : '',
                      style: inputTextStyle(),
                      enabled: _isFormEnabled,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                          labelText: 'Minimum Loan Amount',
                          labelStyle: inputTextStyle()),
                      onChanged: (value) {
                        minimumLoanAmount = value;
                      },
                      validator: (value) {
                        if (loanAmountTypeId == 1) {
                          if (value.trim() == '' || value.trim() == null) {
                            return 'This field is required';
                          }
                          return null;
                        }
                        return null;
                      },
                    ),
                  ),
                  Visibility(
                      visible: loanAmountTypeId == 1,
                      child: TextFormField(
                        initialValue: maximumLoanAmount != null ? maximumLoanAmount : '',
                        style: inputTextStyle(),
                        enabled: _isFormEnabled,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                            labelText: 'Maximum  Loan Amount',
                            labelStyle: inputTextStyle()),
                        onChanged: (value) {
                          maximumLoanAmount = value;
                        },
                        validator: (value) {
                          if (loanAmountTypeId == 1) {
                            if (value.trim() == '' || value.trim() == null) {
                              return 'This field is required';
                            }
                            return null;
                          }
                          return null;
                        },
                      )),
                  Visibility(
                      visible: loanAmountTypeId == 2,
                      child: TextFormField(
                          initialValue: timesNumberOfSavings != null ? timesNumberOfSavings : '',
                          style: inputTextStyle(),
                          enabled: _isFormEnabled,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                              labelText: 'How many times the member savings',
                              labelStyle: inputTextStyle()),
                          onChanged: (value) {
                            timesNumberOfSavings = value;
                          },
                          validator: (value) {
                            if (loanAmountTypeId == 2) {
                              if (value.trim() == '' || value.trim() == null) {
                                return 'This field is required';
                              }
                              return null;
                            }
                            return null;
                          })),
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
                  TextFormField(
                      initialValue: loanInterestRate != null ? loanInterestRate.toString() : '',
                      style: inputTextStyle(),
                      enabled: _isFormEnabled,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                          labelText: 'Loan Interest Rate(%)',
                          labelStyle: inputTextStyle()),
                      onChanged: (value) {
                        loanInterestRate = double.parse(value);
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
                      child: TextFormField(
                          initialValue: fixedRepaymentPeriod != null ? fixedRepaymentPeriod.toString() : '',
                          style: inputTextStyle(),
                          enabled: _isFormEnabled,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                              labelText: 'Fixed Repayment Period',
                              hintText: 'Value in months . E.g 3',
                              labelStyle: inputTextStyle()),
                          onChanged: (value) {
                            fixedRepaymentPeriod = int.tryParse(value) ?? 1;
                          },
                          validator: (value) {
                            if (loanRepaymentTypeId == 1) {
                              if (value.trim() == '' || value.trim() == null) {
                                return 'This field is required';
                              }
                              return null;
                            }
                            return null;
                          })),
                  Visibility(
                      visible: loanRepaymentTypeId == 2,
                      child: TextFormField(
                          initialValue: minimumRepaymentPeriod != null ? minimumRepaymentPeriod.toString() : '',
                          style: inputTextStyle(),
                          enabled: _isFormEnabled,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                              labelText: 'Minimum Repayment Period',
                              hintText: 'Value in months . E.g 3',
                              labelStyle: inputTextStyle()),
                          onChanged: (value) {
                            minimumRepaymentPeriod = int.tryParse(value) ?? 1;
                          },
                          validator: (value) {
                            if (loanRepaymentTypeId == 2) {
                              if (value.trim() == '' || value.trim() == null) {
                                return 'This field is required';
                              }
                              return null;
                            }
                            return null;
                          })),
                  Visibility(
                      visible: loanRepaymentTypeId == 2,
                      child: TextFormField(
                          initialValue: maximumRepaymentPeriod != null ? maximumRepaymentPeriod.toString() : '',
                          style: inputTextStyle(),
                          enabled: _isFormEnabled,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1.0)),
                              labelText: 'Maximum Repayment period',
                              hintText: 'Value in months . E.g 12',
                              labelStyle: inputTextStyle()),
                          onChanged: (value) {
                            maximumRepaymentPeriod = int.tryParse(value) ?? 1;
                          },
                          validator: (value) {
                            if (loanRepaymentTypeId == 2) {
                              if (value.trim() == '' || value.trim() == null) {
                                return 'This field is required';
                              }
                              return null;
                            }
                            return null;
                          })),
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
