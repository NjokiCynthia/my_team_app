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

class RecordContributionRefund extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecordContributionRefundState();
  }
}

class RecordContributionRefundState extends State<RecordContributionRefund> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  DateTime refundDate = DateTime.now();
  int withdrawalMethod;
  int contributionId;
  int groupMemberId;
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
        .loadInitialFormData(acc: true, member: true, contr: true);
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
    _formData['refund_date'] = refundDate.toString();
    _formData["contribution_id"] = contributionId;
    _formData["refund_method"] = withdrawalMethod;
    _formData["member_id"] = groupMemberId;
    _formData["amount"] = amount;
    _formData["account_id"] = accountId;
    _formData["description"] = description;
    _formData["request_id"] = requestId;
    try {
      String message = await Provider.of<Groups>(context, listen: false)
          .recordContributionRefund(_formData);

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
        leadingIcon: LineAwesomeIcons.times,
        title: currentLanguage == 'English'
            ? 'Record Contribution Refund'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Record Contribution Refund') ??
                'Record Contribution Refund',
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
                        ? 'Manually record contribution refund'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate(
                                    'Manually record contribution refund') ??
                            'Manually record contribution refund',
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: DatePicker(
                                  labelText: currentLanguage == 'English'
                                      ? 'Select Refund Date'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate(
                                                  'Select Refund Date') ??
                                          'Select Refund Date',
                                  lastDate: now,
                                  selectedDate: refundDate == null
                                      ? new DateTime(now.year, now.month,
                                          now.day - 1, 6, 30)
                                      : refundDate,
                                  selectDate: (selectedDate) {
                                    setState(() {
                                      refundDate = selectedDate;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                child: CustomDropDownButton(
                                  labelText: currentLanguage == 'English'
                                      ? 'Select Refund Method'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate(
                                                  'Select Refund Method') ??
                                          'Select Refund Method',
                                  enabled: _isFormInputEnabled,
                                  listItems: withdrawalMethods,
                                  selectedItem: withdrawalMethod,
                                  validator: (value) {
                                    if (value.toString().isEmpty ||
                                        value == null) {
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
                                ? 'Select Contribution to refund from'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate(
                                            'Select Contribution to refund from') ??
                                    'Select Contribution to refund from',
                            enabled: _isFormInputEnabled,
                            listItems:
                                formLoadData.containsKey("contributionOptions")
                                    ? formLoadData["contributionOptions"]
                                    : [],
                            selectedItem: contributionId,
                            validator: (value) {
                              if (value.toString().isEmpty || value == null) {
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
                                contributionId = value;
                              });
                            },
                          ),
                          CustomDropDownButton(
                            labelText: currentLanguage == 'English'
                                ? 'Select account to refund from'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate(
                                            'Select account to refund from') ??
                                    'Select account to refund from',
                            enabled: _isFormInputEnabled,
                            listItems:
                                formLoadData.containsKey("accountOptions")
                                    ? formLoadData["accountOptions"]
                                    : [],
                            selectedItem: accountId,
                            validator: (value) {
                              if (value.toString().isEmpty || value == null) {
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
                          CustomDropDownButton(
                            labelText: currentLanguage == 'English'
                                ? 'Select Member to refund'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate('Select Member to refund') ??
                                    'Select Member to refund',
                            enabled: _isFormInputEnabled,
                            listItems: formLoadData.containsKey("memberOptions")
                                ? formLoadData["memberOptions"]
                                : [],
                            selectedItem: groupMemberId,
                            validator: (value) {
                              if (value.toString().isEmpty || value == null) {
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
                                groupMemberId = value;
                              });
                            },
                          ),
                          amountTextInputField(
                              context: context,
                              enabled: _isFormInputEnabled,
                              labelText: currentLanguage == 'English'
                                  ? 'Enter Amount refunded'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate('Enter Amount refunded') ??
                                      'Enter Amount refunded',
                              validator: (value) {
                                if (value.toString().isEmpty || value == null) {
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
      ),
    );
  }
}
