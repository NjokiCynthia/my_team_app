import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/reports/deposit-receipts.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/fine-member.dart';
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
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../select-member.dart';

class RecordContributionPayment extends StatefulWidget {
  @override
  _RecordContributionPaymentState createState() =>
      _RecordContributionPaymentState();
}

class _RecordContributionPaymentState extends State<RecordContributionPayment> {
  bool _isInit = true;
  bool _isLoading = false;
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [], memberOptions = [];
  int memberTypeId;
  final _formKey = new GlobalKey<FormState>();
  DateTime contributionDate = DateTime.now();
  final now = DateTime.now();
  int depositMethod;
  int contributionId;
  int accountId;
  String contributionAmount;
  Map<String, dynamic> _formData = {};
  String selectedContributionValue;
  String selectedAccountValue;
  String selectedMemberType;
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));
  Map<String, dynamic> _individualMemberContributions = {};
  bool _isFormInputEnabled = true;
  Map<String, dynamic> formLoadData = {};

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
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
        .loadInitialFormData(contr: true, acc: true);
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
    _formData['deposit_date'] = contributionDate.toString();
    _formData['deposit_method'] = depositMethod;
    _formData['contribution_id'] = contributionId;
    _formData['account_id'] = accountId;
    _formData['request_id'] = requestId;
    _formData['amount'] = contributionAmount;
    _formData['member_type_id'] = memberTypeId;
    _formData['individual_payments'] = _individualMemberContributions;
    // log(_formData.toString());
    try {
      String message = await Provider.of<Groups>(context, listen: false)
          .recordContributionPayments(_formData);
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
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchDefaultValues(context);
    }
    super.didChangeDependencies();
  }

  Iterable<Widget> get memberWidgets sync* {
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    for (MembersFilterEntry member in selectedMembersList) {
      yield ListTile(
        title: Container(
            width: 200,
            child: Text(member.name, style: TextStyle(fontSize: 17))),
        contentPadding: EdgeInsets.all(4.0),
        subtitle: Container(
            width: 200,
            child: Text(
              member.phoneNumber,
              style: TextStyle(fontSize: 12),
            )),
        trailing: Container(
          width: 220.0,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: amountTextInputField(
                      labelText: currentLanguage == 'English'
                          ? 'Enter Amount'
                          : Provider.of<TranslationProvider>(context,
                                      listen: false)
                                  .translate('Enter Amount') ??
                              'Enter Amount',
                      enabled: _isFormInputEnabled,
                      context: context,
                      onChanged: (value) {
                        _individualMemberContributions[member.memberId] = value;
                      },
                      validator: (value) {
                        if (value == null || value == "") {
                          return currentLanguage == 'English'
                              ? 'This field is required'
                              : Provider.of<TranslationProvider>(context,
                                          listen: false)
                                      .translate('This field is required') ??
                                  'This field is required';
                        }
                        return null;
                      })),
              Expanded(
                child: circleIconButton(
                    backgroundColor: Color(0xFFFFF2F2),
                    color: Color(0xFFE40000),
                    icon: Icons.close,
                    iconSize: 18,
                    onPressed: () {
                      setState(() {
                        selectedMembersList
                            .removeWhere((MembersFilterEntry entry) {
                          return entry.name == member.name;
                        });
                      });
                    }),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
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
            ? 'Record Contribution Payment'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Record Contribution Payment') ??
                'Record Contribution Payment',
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
                    toolTip(
                        context: context,
                        title: currentLanguage == 'English'
                            ? 'Manually record contribution payments'
                            : Provider.of<TranslationProvider>(context,
                                        listen: false)
                                    .translate(
                                        'Manually record contribution payments') ??
                                'Manually record contribution payments',
                        message: "",
                        showTitle: true),
                    Padding(
                      padding: inputPagePadding,
                      child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: DatePicker(
                                      labelText: currentLanguage == 'English'
                                          ? 'Manually record contribution payments'
                                          : Provider.of<TranslationProvider>(
                                                      context,
                                                      listen: false)
                                                  .translate(
                                                      'Manually record contribution payments') ??
                                              'Manually record contribution payments',
                                      lastDate: DateTime.now(),
                                      selectedDate: contributionDate == null
                                          ? new DateTime(now.year, now.month,
                                              now.day - 1, 6, 30)
                                          : contributionDate,
                                      selectDate: (selectedDate) {
                                        setState(() {
                                          contributionDate = selectedDate;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomDropDownButton(
                                      enabled: _isFormInputEnabled,
                                      labelText: currentLanguage == 'English'
                                          ? 'Select Deposit Method'
                                          : Provider.of<TranslationProvider>(
                                                      context,
                                                      listen: false)
                                                  .translate(
                                                      'Select Deposit Method') ??
                                              'Select Deposit Method',
                                      listItems: depositMethods,
                                      selectedItem: depositMethod,
                                      validator: (value) {
                                        if (value == null) {
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
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropDownButton(
                                labelText: currentLanguage == 'English'
                                    ? 'Select Contribution'
                                    : Provider.of<TranslationProvider>(context,
                                                listen: false)
                                            .translate('Select Contribution') ??
                                        'Select Contribution',
                                enabled: _isFormInputEnabled,
                                listItems: formLoadData
                                        .containsKey("contributionOptions")
                                    ? formLoadData["contributionOptions"]
                                    : [],
                                selectedItem: contributionId,
                                validator: (value) {
                                  if (value == null) {
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
                                    contributionId = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10,
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
                                onChanged: (value) {
                                  setState(() {
                                    accountId = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
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
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropDownButton(
                                labelText: currentLanguage == 'English'
                                    ? 'Select Member'
                                    : Provider.of<TranslationProvider>(context,
                                                listen: false)
                                            .translate('Select Member') ??
                                        'Select Member',
                                enabled: _isFormInputEnabled,
                                listItems: memberTypes,
                                selectedItem: memberTypeId,
                                onChanged: (selected) async {
                                  if (selected == 1) {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SelectMember(
                                                  initialMembersList:
                                                      selectedMembersList,
                                                  //membersList: memberOptions,
                                                ))).then((value) {
                                      setState(() {
                                        memberTypeId = selected;
                                        selectedMembersList = value;
                                      });
                                    });
                                  } else {
                                    setState(() {
                                      memberTypeId = selected;
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (value == null) {
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
                              ),
                              Visibility(
                                visible: memberTypeId == 1,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Column(
                                        children: memberWidgets.toList(),
                                      ),
                                 
                                      TextButton(
                                        onPressed: () async {
                                          //open select members dialog
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectMember(
                                                        initialMembersList:
                                                            selectedMembersList,
                                                        //membersList: memberOptions,
                                                      ))).then((value) {
                                            setState(() {
                                              selectedMembersList = value;
                                            });
                                          });
                                        },
                                        child: Text(
                                          currentLanguage == 'English'
                                              ? 'Select members'
                                              : Provider.of<TranslationProvider>(
                                                          context,
                                                          listen: false)
                                                      .translate(
                                                          'Select members') ??
                                                  'Select members',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: memberTypeId == 2,
                                child: amountTextInputField(
                                    enabled: _isFormInputEnabled,
                                    context: context,
                                    labelText: currentLanguage == 'English'
                                        ? 'Enter Amount for Each Member'
                                        : Provider.of<TranslationProvider>(
                                                    context,
                                                    listen: false)
                                                .translate(
                                                    'Enter Amount for Each Member') ??
                                            'Enter Amount for Each Member',
                                    onChanged: (value) {
                                      contributionAmount = value;
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
                                        _submit(context);
                                      },
                                    )
                            ]),
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
