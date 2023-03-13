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

class LoanFeesAndGuarantors extends StatefulWidget {
  final dynamic responseData;
  final bool isEditMode;
  final dynamic loanDetails;
  final Function(dynamic) onButtonPressed;

  LoanFeesAndGuarantors(
      {this.responseData,
      this.isEditMode,
      this.loanDetails,
      @required this.onButtonPressed});

  @override
  _LoanFeesAndGuarantorsState createState() => _LoanFeesAndGuarantorsState();
}

class _LoanFeesAndGuarantorsState extends State<LoanFeesAndGuarantors> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormEnabled = true;
  var _isLoading = false;

  String requestId =
      ((DateTime.now().millisecondsSinceEpoch / 1000).truncate()).toString();
  String loanTypeID;

  bool enableLoanGuarantors = false;

  int guarantorOptionId;
  String minimumAllowedGuarantors;

  bool chargeLoanProcessingFee = false;

  int loanProcessingFeeTypeId;

  String loanProcessingFeeAmount;
  String loanProcessingFeePercentage;
  int loanProcessingFeePercentageChargedOnId;

  void _getFineDetails() {
    if (widget.isEditMode) {
      dynamic type = widget.loanDetails['loan_type'] as dynamic;
      loanTypeID = type['id'].toString();

      dynamic settings = widget.loanDetails['general_details'] as dynamic;

      log(settings.toString());
      chargeLoanProcessingFee =
          (int.tryParse(settings['enable_loan_processing_fee'].toString()) ??
                      0) ==
                  1
              ? true
              : false;
      loanProcessingFeeTypeId =
          parseZeroDropdownValues(settings, "loan_processing_fee_type");
      loanProcessingFeeAmount =
          settings['loan_processing_fee_fixed_amount'].toString() != '0'
              ? settings['loan_processing_fee_fixed_amount'].toString()
              : '';
      loanProcessingFeePercentage =
          settings['loan_processing_fee_percentage_rate'].toString() != '0'
              ? settings['loan_processing_fee_percentage_rate'].toString()
              : '';
      loanProcessingFeePercentageChargedOnId = parseZeroDropdownValues(
          settings, "loan_processing_fee_percentage_charged_on");

      enableLoanGuarantors =
          (int.tryParse(settings['enable_loan_guarantors'].toString()) ?? 0) ==
                  1
              ? true
              : false;
      guarantorOptionId =
          (int.tryParse(settings["loan_guarantors_type"].toString()) ?? 1) == 0
              ? 1
              : (int.tryParse(settings["loan_guarantors_type"].toString()) ??
                  1);
      minimumAllowedGuarantors =
          settings['minimum_guarantors'].toString() != '0'
              ? settings['minimum_guarantors'].toString()
              : '';
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
      print("General settings OK");
    }

    setState(() {
      _isFormEnabled = false;
      _isLoading = true;
    });

    Map<String, dynamic> formData = {};

    formData["id"] = loanTypeID;
    formData["request_id"] = requestId;
    formData["enable_loan_guarantors"] = enableLoanGuarantors ? 1 : 0;
    formData["loan_guarantors_type"] = guarantorOptionId;
    formData["minimum_guarantors"] = minimumAllowedGuarantors;
    formData["enable_loan_processing_fee"] = chargeLoanProcessingFee ? 1 : 0;
    formData["loan_processing_fee_type"] = loanProcessingFeeTypeId;
    formData["loan_processing_fee_fixed_amount"] = loanProcessingFeeAmount;
    formData["loan_processing_fee_percentage_rate"] =
        loanProcessingFeePercentage;
    formData["loan_processing_fee_percentage_charged_on"] =
        loanProcessingFeePercentageChargedOnId;

    print("$formData");
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .addLoanTypeStepThree(formData);
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
                  // ignore: deprecated_member_use
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              subtitle2(
                  text: "Set Guarantor Requirements and Loan Fees",
                  // ignore: deprecated_member_use
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
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
                            text: "Enable loan guarantors",
                            // ignore: deprecated_member_use
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
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
                    Visibility(
                        visible: enableLoanGuarantors,
                        child: SizedBox(height: 5)),
                    Visibility(
                      visible: enableLoanGuarantors,
                      child: Row(
                        children: [
                          customTitle(
                            text: "Choose guarantor option",
                            // ignore: deprecated_member_use
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
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
                              // ignore: deprecated_member_use
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
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
                                text:
                                    "When a member loan request exceeds maximum loan amount",
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: enableLoanGuarantors,
                      child: numberDecimalFieldWithInitialValue(
                          initialValue: minimumAllowedGuarantors != null
                              ? minimumAllowedGuarantors
                              : '',
                          isFormEnabled: _isFormEnabled,
                          context: context,
                          labelText: 'Enter minimum allowed guarantors',
                          onChanged: (value) {
                            setState(() {
                              minimumAllowedGuarantors = value;
                            });
                          },
                          validator: (value) {
                            if (enableLoanGuarantors) {
                              if (value.trim() == '' || value.trim() == null) {
                                return "This field is required";
                              } else {
                                if ((int.tryParse(value) ?? 0) < 1)
                                  return "Minimum is 1";
                              }
                            }
                            return null;
                          }),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        customTitle(
                            text: "Charge loan processing fee",
                            // ignore: deprecated_member_use
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
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
                          validator: (value) {
                            if (chargeLoanProcessingFee) if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                    ),
                    Visibility(
                      visible: chargeLoanProcessingFee &&
                          loanProcessingFeeTypeId == 1,
                      child: numberDecimalFieldWithInitialValue(
                          initialValue: loanProcessingFeeAmount != null
                              ? loanProcessingFeeAmount
                              : '',
                          context: context,
                          isFormEnabled: _isFormEnabled,
                          labelText: 'Enter processing fee amount',
                          onChanged: (value) {
                            setState(() {
                              loanProcessingFeeAmount = value;
                            });
                          },
                          validator: (value) {
                            if (chargeLoanProcessingFee &&
                                loanProcessingFeeTypeId == 1) {
                              if (value.trim() == '' || value.trim() == null) {
                                return "This field is required";
                              } else if ((int.tryParse(value) ?? 0) < 1)
                                return "Minimum is 1";
                            }
                            return null;
                          }),
                    ),
                    Visibility(
                      visible: chargeLoanProcessingFee &&
                          loanProcessingFeeTypeId == 2,
                      child: numberDecimalFieldWithInitialValue(
                          initialValue: loanProcessingFeePercentage != null
                              ? loanProcessingFeePercentage
                              : '',
                          isFormEnabled: _isFormEnabled,
                          context: context,
                          labelText: 'Enter processing fee percentage',
                          onChanged: (value) {
                            setState(() {
                              loanProcessingFeePercentage = value;
                            });
                          },
                          validator: (value) {
                            if (chargeLoanProcessingFee &&
                                loanProcessingFeeTypeId == 2) {
                              if (value.trim() == '' || value.trim() == null) {
                                return "This field is required";
                              } else if ((double.tryParse(value) ?? 0) < 0.01)
                                return "Minimum is 0.01";
                            }
                            return null;
                          }),
                    ),
                    Visibility(
                      visible: chargeLoanProcessingFee &&
                          loanProcessingFeeTypeId == 2,
                      child: CustomDropDownButton(
                          labelText: "Percentage charged on",
                          listItems: loanProcessingFeePercentageChargedOn,
                          selectedItem: loanProcessingFeePercentageChargedOnId,
                          onChanged: (value) {
                            setState(() {
                              loanProcessingFeePercentageChargedOnId = value;
                            });
                          },
                          validator: (value) {
                            if (chargeLoanProcessingFee &&
                                loanProcessingFeeTypeId ==
                                    2) if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
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
              : defaultButton(
                  context: context,
                  text: "Save & Finish",
                  onPressed: () => _submit(context),
                ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
