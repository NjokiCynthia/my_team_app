import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/reports/deposit-receipts.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/date-picker.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
  Map<String, dynamic> formLoadData = {}, _formData = {};
  var accountId;
  final _formKey = new GlobalKey<FormState>();
  bool _isLoading = false, _isFormInputEnabled = true;
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));
  String loanDescription;
  String amountLoaned, totalLoanAmountPayable, loanBalance;

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
    _formData["request_id"] = requestId;
    _formData["description"] = loanDescription;
    _formData["amount_loaned"] = amountLoaned;
    _formData["total_loan_amount_payable"] = totalLoanAmountPayable;
    _formData["loan_balance"] = loanBalance;
    _formData["loan_start_date"] = loanFromDate.toString();
    _formData["loan_end_date"] = loanToDate.toString();
    _formData["account_id"] = accountId;
    try {
      String message = await Provider.of<Groups>(context, listen: false)
          .recordBankLoanIncome(_formData);
      StatusHandler().showSuccessSnackBar(context, message);

      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DepositReceipts()));
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
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: currentLanguage == 'English'
            ? 'Record Bank Loan'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Record Bank Loan') ??
                'Record Bank Loan',
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.times_circle,
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
                    title: currentLanguage == 'English'
                        ? 'Manually record loans received from financial institutions'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate(
                                    'Manually record loans received from financial institutions') ??
                            'Manually record loans received from financial institutions',
                    showTitle: true,
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
                              labelText: currentLanguage == 'English'
                                  ? 'Bank loan description'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate('Bank loan description') ??
                                      'Bank loan description',
                              validator: (value) {
                                if (value == "" || value == null) {
                                  return currentLanguage == 'English'
                                      ? 'This field is required'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate(
                                                  'This field is required') ??
                                          'This field is required';
                                } else if (value.toString().length < 8) {
                                  return currentLanguage == 'English'
                                      ? 'Description is too short'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate(
                                                  'Description is too short') ??
                                          'Description is too short';
                                }
                                return null;
                              },
                              enabled: _isFormInputEnabled,
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
                                  return currentLanguage == 'English'
                                      ? 'This field is required'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate(
                                                  'This field is required') ??
                                          'This field is required';
                                }
                                return null;
                              },
                              enabled: _isFormInputEnabled,
                              labelText: currentLanguage == 'English'
                                  ? 'Total amount received'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate('Total amount received') ??
                                      'Total amount received',
                              onChanged: (value) {
                                setState(() {
                                  amountLoaned = value;
                                });
                              }),
                          amountTextInputField(
                              context: context,
                              validator: (value) {
                                if (value == null || value == "") {
                                  return currentLanguage == 'English'
                                      ? 'This field is required'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate(
                                                  'This field is required') ??
                                          'This field is required';
                                }
                                return null;
                              },
                              enabled: _isFormInputEnabled,
                              labelText: currentLanguage == 'English'
                                  ? 'Total amount payable'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate('Total amount payable') ??
                                      'Total amount payable',
                              onChanged: (value) {
                                setState(() {
                                  totalLoanAmountPayable = value;
                                });
                              }),
                          amountTextInputField(
                              context: context,
                              validator: (value) {
                                if (value == null || value == "") {
                                  return currentLanguage == 'English'
                                      ? 'This field is required'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate(
                                                  'This field is required') ??
                                          'This field is required';
                                }
                                return null;
                              },
                              labelText: currentLanguage == 'English'
                                  ? 'Total loan balance as at date'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate(
                                              'Total loan balance as at date') ??
                                      'Total loan balance as at date',
                              enabled: _isFormInputEnabled,
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
                                    labelText: currentLanguage == 'English'
                                        ? 'Select Deposit Date'
                                        : Provider.of<TranslationProvider>(
                                                    context,
                                                    listen: false)
                                                .translate(
                                                    'Select Deposit Date') ??
                                            'Select Deposit Date',
                                    lastDate: DateTime.now(),
                                    selectedDate: loanFromDate == null
                                        ? new DateTime(now.year, now.month,
                                            now.day - 1, 6, 30)
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
                                  labelText: currentLanguage == 'English'
                                      ? 'Loan To'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate('Loan To') ??
                                          'Loan To',
                                  firstDate: loanFromDate == null
                                      ? new DateTime(now.year, now.month,
                                          now.day - 1, 6, 30)
                                      : loanFromDate,
                                  lastDate: DateTime(2037),
                                  selectedDate: loanToDate == null
                                      ? new DateTime(now.year, now.month,
                                          now.day - 1, 6, 30)
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
                            enabled: _isFormInputEnabled,
                            labelText: currentLanguage == 'English'
                                ? 'Account loan deposited to'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate(
                                            'Account loan deposited to') ??
                                    'Account loan deposited to',
                            listItems:
                                formLoadData.containsKey("accountOptions")
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
                                return currentLanguage == 'English'
                                    ? 'This field is required'
                                    : Provider.of<TranslationProvider>(context,
                                                listen: false)
                                            .translate(
                                                'This field is required') ??
                                        'This field is required';
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
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : defaultButton(
                                  context: context,
                                  text: currentLanguage == 'English'
                                      ? 'SAVE'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate('SAVE') ??
                                          'SAVE',
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
          );
        },
      ),
    );
  }
}
