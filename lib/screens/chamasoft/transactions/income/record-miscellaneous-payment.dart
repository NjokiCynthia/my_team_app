import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/reports/deposit-receipts.dart';
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

class RecordMiscellaneousPayment extends StatefulWidget {
  @override
  _RecordMiscellaneousPayment createState() => _RecordMiscellaneousPayment();
}

class _RecordMiscellaneousPayment extends State<RecordMiscellaneousPayment> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isInit = true;
  Map<String, dynamic> formLoadData = {};
  DateTime now = DateTime.now();
  DateTime depositDate = DateTime.now();
  int depositMethod, memberId, accountId;
  double amount;
  String description;
  final _formKey = new GlobalKey<FormState>();
  bool _isFormInputEnabled = true;
  Map<String, dynamic> _formData = {};
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));
  bool _isLoading = false;

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
        .loadInitialFormData(member: true, acc: true);
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
    _formData['request_id'] = requestId;
    _formData["deposit_date"] = depositDate.toString();
    _formData["deposit_method"] = depositMethod;
    _formData["member_id"] = memberId;
    _formData["account_id"] = accountId;
    _formData["amount"] = amount;
    _formData["description"] = description;

    try {
      String message = await Provider.of<Groups>(context, listen: false)
          .recordMiscellaneousPayments(_formData);
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
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.times_circle,
          title: currentLanguage == 'English'
              ? 'Record Miscellaneous Payment'
              : Provider.of<TranslationProvider>(context, listen: false)
                      .translate('Record Miscellaneous Payment') ??
                  'Record Miscellaneous Payment',
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
                            ? 'Manually record miscellaneous payments'
                            : Provider.of<TranslationProvider>(context,
                                        listen: false)
                                    .translate(
                                        'Manually record miscellaneous payments') ??
                                'Manually record miscellaneous payments',
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
                                        ? 'Select Deposit Date'
                                        : Provider.of<TranslationProvider>(
                                                    context,
                                                    listen: false)
                                                .translate(
                                                    'Select Deposit Date') ??
                                            'Select Deposit Date',
                                    lastDate: DateTime.now(),
                                    selectedDate: depositDate == null
                                        ? new DateTime(now.year, now.month,
                                            now.day - 1, 6, 30)
                                        : depositDate,
                                    selectDate: (selectedDate) {
                                      setState(() {
                                        depositDate = selectedDate;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  flex: 3,
                                  child: CustomDropDownButton(
                                    labelText: currentLanguage == 'English'
                                        ? 'Select Deposit Method'
                                        : Provider.of<TranslationProvider>(
                                                    context,
                                                    listen: false)
                                                .translate(
                                                    'Select Deposit Method') ??
                                            'Select Deposit Method',
                                    enabled: _isFormInputEnabled,
                                    listItems: depositMethods,
                                    selectedItem: depositMethod,
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
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        depositMethod = value;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            CustomDropDownButton(
                              labelText: currentLanguage == 'English'
                                  ? 'Select Member'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate('Select Member') ??
                                      'Select Member',
                              enabled: _isFormInputEnabled,
                              listItems:
                                  formLoadData.containsKey("memberOptions")
                                      ? formLoadData["memberOptions"]
                                      : [],
                              selectedItem: memberId,
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
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  memberId = value;
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
                                if (value == "" || value == null) {
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
                                  accountId = value;
                                });
                              },
                            ),
                            amountTextInputField(
                                context: context,
                                labelText: currentLanguage == 'English'
                                    ? 'Enter Amount'
                                    : Provider.of<TranslationProvider>(context,
                                                listen: false)
                                            .translate('Enter Amount') ??
                                        'Enter Amount',
                                enabled: _isFormInputEnabled,
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
        ));
  }
}
