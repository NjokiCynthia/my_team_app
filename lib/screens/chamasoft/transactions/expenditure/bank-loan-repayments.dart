import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/reports/withdrawal_receipts.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/date-picker.dart';
import 'package:chamasoft/helpers/setting_helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BankLoanRepayment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BankLoanRepaymentState();
  }
}

class BankLoanRepaymentState extends State<BankLoanRepayment> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  DateTime withdrawalDate = DateTime.now();
  int withdrawalMethod;
  int bankLoanId;
  int accountId;
  double amount;
  String description;
  bool _isInit = true, _isLoading = false, _isFormInputEnabled = true;
  Map<String, dynamic> formLoadData = {}, _formData = {};
  final _formKey = new GlobalKey<FormState>();
  DateTime now = DateTime.now();
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));

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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchDefaultValues(context);
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchDefaultValues(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
    formLoadData = await Provider.of<Groups>(context, listen: false)
        .loadInitialFormData(acc: true, bankLoans: true);
    setState(() {
      _isInit = false;
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
      _isFormInputEnabled = false;
    });
    _formKey.currentState.save();
    _formData['repayment_date'] = withdrawalDate.toString();
    _formData["bank_loan_id"] = bankLoanId;
    _formData["amount"] = amount;
    _formData["repayment_method"] = withdrawalMethod;
    _formData["account_id"] = accountId;
    _formData["description"] = description;
    _formData["request_id"] = requestId;
    try {
      String message = await Provider.of<Groups>(context, listen: false)
          .recordBankLoanRepayment(_formData);
      StatusHandler().showSuccessSnackBar(context, message);

      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => WithdrawalReceipts()));
      });
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
        _isFormInputEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.times,
        title: "Record Bank Loan Repayment",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  toolTip(
                    context: context,
                    title: "Manually record bank loan repayments",
                    message: "",
                  ),
                  Padding(
                    padding: inputPagePadding,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CustomDropDownButton(
                            labelText: 'Select Bank Loan',
                            enabled: _isFormInputEnabled,
                            listItems:
                                formLoadData.containsKey("bankLoansOptions")
                                    ? formLoadData["bankLoansOptions"]
                                    : [],
                            selectedItem: bankLoanId,
                            validator: (value) {
                              if (value == null || value.toString().isEmpty) {
                                return "Field is required";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                bankLoanId = value;
                              });
                            },
                          ),
                          DatePicker(
                            labelText: 'Select Repayment Date',
                            lastDate: now,
                            selectedDate: withdrawalDate == null
                                ? new DateTime(
                                    now.year, now.month, now.day - 1, 6, 30)
                                : withdrawalDate,
                            selectDate: (selectedDate) {
                              setState(() {
                                withdrawalDate = selectedDate;
                              });
                            },
                          ),
                          CustomDropDownButton(
                            labelText: 'Select Account Withdrawn',
                            enabled: _isFormInputEnabled,
                            listItems:
                                formLoadData.containsKey("accountOptions")
                                    ? formLoadData["accountOptions"]
                                    : [],
                            selectedItem: accountId,
                            validator: (value) {
                              if (value == null || value.toString().isEmpty) {
                                return "Field is required";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                accountId = value;
                              });
                            },
                          ),
                          CustomDropDownButton(
                            labelText: 'Select Repayment Method',
                            enabled: _isFormInputEnabled,
                            validator: (value) {
                              if (value == null || value.toString().isEmpty) {
                                return "Field is required";
                              }
                              return null;
                            },
                            listItems: withdrawalMethods,
                            selectedItem: withdrawalMethod,
                            onChanged: (value) {
                              setState(() {
                                withdrawalMethod = value;
                              });
                            },
                          ),
                          amountTextInputField(
                              context: context,
                              labelText: 'Enter Amount',
                              enabled: _isFormInputEnabled,
                              validator: (value) {
                                if (value == null || value.toString().isEmpty) {
                                  return "Field is required";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  amount = double.parse(value);
                                });
                              }),
                          multilineTextField(
                              context: context,
                              maxLines: 5,
                              enabled: _isFormInputEnabled,
                              labelText: 'Short Description',
                              validator: (value) {
                                if (value == null || value.toString().isEmpty) {
                                  return "Field is required";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  description = value;
                                });
                              }),
                          SizedBox(
                            height: 24,
                          ),
                          _isLoading
                              ? Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : defaultButton(
                                  context: context,
                                  text: "SAVE",
                                  onPressed: () {
                                    _submit(context);
                                  },
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
