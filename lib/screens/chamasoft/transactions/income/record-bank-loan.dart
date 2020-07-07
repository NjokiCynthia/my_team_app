import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/record-loan-payment.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/date-picker.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class RecordBankLoan extends StatefulWidget {
  @override
  _RecordBankLoanState createState() => _RecordBankLoanState();
}

class _RecordBankLoanState extends State<RecordBankLoan> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  DateTime loanFromDate = DateTime.now();
  DateTime loanToDate = DateTime.now();
  DateTime now = DateTime.now();
  bool _isInit = true;
  Map<String, dynamic> formLoadData = {}, _formData={};
  var accountId;
  final _formKey = new GlobalKey<FormState>();
  bool _isLoading = false, _isFormInputEnabled = true;
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));
  String loanDescription;
  double amountLoaned, totalLoanAmountPayable, loanBalance;

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
        .loadInitialFormData(acc: true);
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
    //_formData["request_id"] = requestId;
    _formData["description"] = loanDescription;
    _formData["amount_loaned"] = amountLoaned;
    _formData["total_loan_amount_payable"] = totalLoanAmountPayable;
    _formData["loan_balance"] = loanBalance;
    _formData["loan_start_date"] = loanFromDate.toString();
    _formData["loan_end_date"] = loanToDate.toString();
    _formData["account_id"] = accountId;
    print(_formData);
    try {
      await Provider.of<Groups>(context, listen: false)
          .recordBankLoanIncome(_formData);
      Navigator.of(context).pop();
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
        title: "Record Bank Loan",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              toolTip(
                context: context,
                title:
                    "Manually record loans received from financial institutions",
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
                      simpleTextInputField(
                          context: context,
                          labelText: "Bank loan description",
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            } else if (value.toString().length < 8) {
                              return "Description is too short";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              loanDescription = value;
                            });
                          }),
                      amountTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              print("Empty value2");
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Total amount received",
                          onChanged: (value) {
                            setState(() {
                              amountLoaned = value;
                            });
                          }),
                      amountTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              print("Empty value");
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Total amount payable",
                          onChanged: (value) {
                            setState(() {
                              totalLoanAmountPayable = value;
                            });
                          }),
                      amountTextInputField(
                          context: context,
                          validator: (value) {
                            print("Empty value3");
                            if (value == null || value == "") {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Total loan balance as at date",
                          onChanged: (value) {
                            setState(() {
                              loanBalance = value;
                            });
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: DatePicker(
                                labelText: 'Select Deposit Date',
                                lastDate: DateTime.now(),
                                selectedDate: loanFromDate == null
                                    ? new DateTime(
                                        now.year, now.month, now.day - 1, 6, 30)
                                    : loanFromDate,
                                selectDate: (selectedDate) {
                                  setState(() {
                                    loanFromDate = selectedDate;
                                  });
                                },
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 1,
                            child: DatePicker(
                              labelText: 'Loan To',
                              firstDate: loanFromDate == null
                                  ? new DateTime(
                                      now.year, now.month, now.day - 1, 6, 30)
                                  : loanFromDate,
                              lastDate: DateTime(2037),
                              selectedDate: loanToDate == null
                                  ? new DateTime(
                                      now.year, now.month, now.day - 1, 6, 30)
                                  : loanToDate,
                              selectDate: (selectedDate) {
                                setState(() {
                                  loanToDate = selectedDate;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      CustomDropDownButton(
                        labelText: "Account loan deposited to",
                        listItems: formLoadData.containsKey("accountOptions")
                            ? formLoadData["accountOptions"]
                            : [],
                        selectedItem: accountId,
                        onChanged: (value) {
                          setState(() {
                            accountId = value;
                          });
                        },
                        validator: (value) {
                          if (value == "" || value == null) {
                            return "This field is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.all(10),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : defaultButton(
                              context: context,
                              text: "SAVE",
                              onPressed: () {
                                print("this is clicked");
                                _submit(context);
                              })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
