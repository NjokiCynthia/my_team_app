import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
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

class RecordExpense extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecordExpenseState();
  }
}

class RecordExpenseState extends State<RecordExpense> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isFormInputEnabled = true;
  bool toolTipIsVisible = true;
  DateTime expenseDate = DateTime.now();
  int withdrawalMethod;
  int expenseCategoryId;
  int accountId;
  String description;
  double amount;
  bool _isInit = true, _isLoading = false;
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
        .loadInitialFormData(acc: true, exp: true);
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
    _formData['expense_date'] = expenseDate.toString();
    _formData["expense_category_id"] = expenseCategoryId;
    _formData["withdrawal_method"] = withdrawalMethod;
    _formData["amount"] = amount;
    _formData["account_id"] = accountId;
    _formData["description"] = description;
    _formData["request_id"] = requestId;
    try {
      String message = await Provider.of<Groups>(context, listen: false)
          .recordExpensePayment(_formData);
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
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.times_circle,
        title: currentLanguage == 'English'
            ? 'Record Expense'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Record Expense') ??
                'Record Expense',
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  toolTip(
                      context: context,
                      title: currentLanguage == 'English'
                          ? 'Manually record expense payment'
                          : Provider.of<TranslationProvider>(context,
                                      listen: false)
                                  .translate(
                                      'Manually record expense payment') ??
                              'Manually record expense payment',
                      message: ""),
                  Padding(
                    padding: inputPagePadding,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: DatePicker(
                                  labelText: currentLanguage == 'English'
                                      ? 'Select Expense Date'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate(
                                                  'Select Expense Date') ??
                                          'Select Expense Date',
                                  lastDate: DateTime.now(),
                                  selectedDate: expenseDate == null
                                      ? new DateTime(now.year, now.month,
                                          now.day - 1, 6, 30)
                                      : expenseDate,
                                  selectDate: (selectedDate) {
                                    setState(() {
                                      expenseDate = selectedDate;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomDropDownButton(
                                  labelText: currentLanguage == 'English'
                                      ? 'Select Withdrawal Method'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate(
                                                  'Select Withdrawal Method') ??
                                          'Select Withdrawal Method',
                                  enabled: _isFormInputEnabled,
                                  listItems: withdrawalMethods,
                                  selectedItem: withdrawalMethod,
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
                                  onChanged: (value) {
                                    setState(() {
                                      withdrawalMethod = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          CustomDropDownButton(
                            labelText: currentLanguage == 'English'
                                ? 'Select Expense Category'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate('Select Expense Category') ??
                                    'Select Expense Category',
                            enabled: _isFormInputEnabled,
                            listItems:
                                formLoadData.containsKey("expenseCategories")
                                    ? formLoadData["expenseCategories"]
                                    : [],
                            selectedItem: expenseCategoryId,
                            validator: (value) {
                              if (value == null || value == "") {
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
                            onChanged: (value) {
                              setState(() {
                                expenseCategoryId = value;
                              });
                            },
                          ),
                          CustomDropDownButton(
                            labelText: currentLanguage == 'English'
                                ? 'Select Account'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate('Select Account') ??
                                    'Select Account',
                            enabled: _isFormInputEnabled,
                            listItems:
                                formLoadData.containsKey("accountOptions")
                                    ? formLoadData["accountOptions"]
                                    : [],
                            selectedItem: accountId,
                            validator: (value) {
                              if (value == null || value == "") {
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
                            onChanged: (value) {
                              setState(() {
                                accountId = value;
                              });
                            },
                          ),
                          amountTextInputField(
                              context: context,
                              enabled: _isFormInputEnabled,
                              labelText: currentLanguage == 'English'
                                  ? 'Enter Amount Expensed'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate('Enter Amount Expensed') ??
                                      'Enter Amount Expensed',
                              onChanged: (value) {
                                setState(() {
                                  amount = double.parse(value);
                                });
                              },
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
                              }),
                          multilineTextField(
                              context: context,
                              labelText: currentLanguage == 'English'
                                  ? 'Short Description (Optional)'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate(
                                              'Short Description (Optional)') ??
                                      'Short Description (Optional)',
                              maxLines: 5,
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
                                  text: currentLanguage == 'English'
                                      ? 'SAVE'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate('SAVE') ??
                                          'SAVE',
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
