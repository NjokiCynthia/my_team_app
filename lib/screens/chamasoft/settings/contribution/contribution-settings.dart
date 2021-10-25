import 'dart:developer';

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/contribution/validate-settings.dart';
import 'package:chamasoft/screens/chamasoft/settings/setup-lists/contribution-setup-list.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/date-picker.dart';
import 'package:chamasoft/helpers/report_helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContributionSettings extends StatefulWidget {
  final bool isEditMode;
  final dynamic contributionDetails;
  final Function(dynamic) onButtonPressed;

  ContributionSettings(
      {this.isEditMode,
      this.contributionDetails,
      @required this.onButtonPressed});

  @override
  _ContributionSettingsState createState() => _ContributionSettingsState();
}

class _ContributionSettingsState extends State<ContributionSettings> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormEnabled = true;
  var _isLoading = false;
  String contributionId;
  String requestId =
      ((DateTime.now().millisecondsSinceEpoch / 1000).truncate()).toString();
  String _contributionAmount;
  int startingMonthId;
  String _contributionName;
  int _contributionTypeId;
  int _daysOfTheMonth;
  int _weekDay = 0;
  DateTime now = DateTime.now();
  DateTime _invoiceDate = DateTime.now();
  DateTime _contributionDate = DateTime.now();
  final dateFormat = DateFormat('dd-MM-y');
  int _weekDayWeeklyId;
  int weekNumberId;
  int twoWeekdayId;
  int contributionFrequencyId;
  bool displayContributionArrears = false;

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
    formData["amount"] = _contributionAmount;
    formData["name"] = _contributionName;
    formData["type"] = _contributionTypeId;
    formData['contribution_frequency'] = contributionFrequencyId;
    formData["month_day_monthly"] = _daysOfTheMonth;
    formData['month_day_multiple'] = _daysOfTheMonth;
    formData["start_month_multiple"] = startingMonthId;
    formData["week_number_fortnight"] = weekNumberId;
    formData["week_day_multiple"] = _weekDay;
    formData["week_day_monthly"] = _weekDay;
    formData["week_day_fortnight"] = _weekDayWeeklyId;
    formData["week_day_weekly"] = _weekDayWeeklyId;
    formData["contribution_date"] = dateFormat.format(_contributionDate);
    formData["invoice_date"] = dateFormat.format(_invoiceDate);
    formData['regular_invoicing_active'] = 1;
    formData['one_time_invoicing_active'] = 1;
    formData['invoice_days'] = 1;
    formData['display_contribution_arrears_cumulatively'] =
        displayContributionArrears;
    // ignore: todo
    formData["id"] = contributionId; //TODO: Editing

    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .addContributionStepOne(formData, widget.isEditMode);
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
    log('${widget.contributionDetails}');
    dynamic settings =
        widget.contributionDetails['contribution_settings'] as dynamic;

    setState(() {
      contributionId = settings['id'].toString();
      _contributionAmount = settings['amount'].toString();
      _contributionName = settings['name'].toString();
      _contributionTypeId = int.tryParse(settings['type'].toString()) ?? null;
      contributionFrequencyId =
          int.tryParse(settings['contribution_frequency'].toString()) ?? null;
      _daysOfTheMonth =
          int.tryParse(settings['month_day_monthly'].toString()) ?? null;
      startingMonthId =
          int.tryParse(settings['start_month_multiple'].toString()) ?? null;
      weekNumberId =
          int.tryParse(settings['week_number_fortnight'].toString()) ?? null;
      _weekDay = int.tryParse(settings['week_day_monthly'].toString()) ?? null;
      _weekDayWeeklyId =
          int.tryParse(settings['week_day_weekly'].toString()) ?? null;

      int contributionTimestamp =
          ParseHelper.getIntFromJson(settings, "contribution_date");
      print('contributionTimestamp: $contributionTimestamp');
      int contributionDate = contributionTimestamp != 0
          ? contributionTimestamp
          : int.parse(requestId);
      int invoiceTimestamp =
          ParseHelper.getIntFromJson(settings, "invoice_date");
      int invoiceDate =
          invoiceTimestamp != 0 ? invoiceTimestamp : int.parse(requestId);
      _contributionDate =
          new DateTime.fromMillisecondsSinceEpoch(contributionDate * 1000);
      _invoiceDate =
          new DateTime.fromMillisecondsSinceEpoch(invoiceDate * 1000);
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
                  text: "Settings",
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              subtitle2(
                  text: "Configure the behaviour of your contribution",
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
                  textAlign: TextAlign.start),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  CustomDropDownButton(
                    labelText: "Select Contribution Type",
                    listItems: contributionTypeOptions,
                    selectedItem: _contributionTypeId,
                    onChanged: (value) {
                      setState(() {
                        _contributionTypeId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  Visibility(
                    visible: _contributionTypeId == 1,
                    child: Column(
                      children: <Widget>[
                        CustomDropDownButton(
                          labelText: "Select Frequency",
                          enabled: _isFormEnabled,
                          listItems: getContributionFrequencyOptions,
                          selectedItem: contributionFrequencyId,
                          onChanged: (value) {
                            setState(() {
                              contributionFrequencyId = value;
                            });
                          },
                          validator: (value) {
                            if (_contributionTypeId == 1) if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        Visibility(
                          visible: contributionFrequencyId == 1 ||
                              contributionFrequencyId == 2 ||
                              contributionFrequencyId == 3 ||
                              contributionFrequencyId == 4 ||
                              contributionFrequencyId == 5 ||
                              contributionFrequencyId == 9,
                          child: CustomDropDownButton(
                            labelText: "Select Day of Month",
                            listItems: getDaysOfTheMonth,
                            enabled: _isFormEnabled,
                            selectedItem: _daysOfTheMonth,
                            onChanged: (value) {
                              setState(() {
                                _daysOfTheMonth = value;
                              });
                            },
                            validator: (value) {
                              if (!ValidateSettings().validate(
                                  contributionType: _contributionTypeId,
                                  selectedFrequency: contributionFrequencyId,
                                  daysOfTheMonth: _daysOfTheMonth,
                                  weekDayWeekly: _weekDayWeeklyId,
                                  weekNumberFortnight: weekNumberId,
                                  startingMonth: startingMonthId)) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Visibility(
                          visible: (_daysOfTheMonth != null &&
                                  (_daysOfTheMonth < 5 ||
                                      _daysOfTheMonth == 32)) &&
                              (contributionFrequencyId != 6 &&
                                  contributionFrequencyId != 7 &&
                                  contributionFrequencyId != 8),
                          child: CustomDropDownButton(
                            labelText: "Select Day",
                            listItems: getMonthDays,
                            enabled: _isFormEnabled,
                            selectedItem: _weekDay,
                            onChanged: (value) {
                              setState(() {
                                _weekDay = value;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: contributionFrequencyId == 6 ||
                              contributionFrequencyId == 7,
                          child: CustomDropDownButton(
                            labelText: "Select Day of Week",
                            listItems: getWeekDays,
                            enabled: _isFormEnabled,
                            selectedItem: _weekDayWeeklyId,
                            onChanged: (value) {
                              setState(() {
                                _weekDayWeeklyId = value;
                              });
                            },
                            validator: (value) {
                              if (!ValidateSettings().validate(
                                  contributionType: _contributionTypeId,
                                  selectedFrequency: contributionFrequencyId,
                                  daysOfTheMonth: _daysOfTheMonth,
                                  weekDayWeekly: _weekDayWeeklyId,
                                  weekNumberFortnight: weekNumberId,
                                  startingMonth: startingMonthId)) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Visibility(
                          visible: contributionFrequencyId == 7,
                          child: CustomDropDownButton(
                            labelText: "Select Week",
                            listItems: getWeekNumbers,
                            enabled: _isFormEnabled,
                            selectedItem: weekNumberId,
                            onChanged: (value) {
                              setState(() {
                                weekNumberId = value;
                              });
                            },
                            validator: (_) {
                              if (!ValidateSettings().validate(
                                  contributionType: _contributionTypeId,
                                  selectedFrequency: contributionFrequencyId,
                                  daysOfTheMonth: _daysOfTheMonth,
                                  weekDayWeekly: _weekDayWeeklyId,
                                  weekNumberFortnight: weekNumberId,
                                  startingMonth: startingMonthId)) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Visibility(
                          visible: contributionFrequencyId == 2 ||
                              contributionFrequencyId == 3 ||
                              contributionFrequencyId == 4 ||
                              contributionFrequencyId == 5 ||
                              contributionFrequencyId == 9,
                          child: CustomDropDownButton(
                              labelText: "Starting Month",
                              listItems: getStartingMonths,
                              enabled: _isFormEnabled,
                              selectedItem: startingMonthId,
                              onChanged: (value) {
                                setState(() {
                                  startingMonthId = value;
                                });
                              },
                              validator: (value) {
                                if (!ValidateSettings().validate(
                                    contributionType: _contributionTypeId,
                                    selectedFrequency: contributionFrequencyId,
                                    daysOfTheMonth: _daysOfTheMonth,
                                    weekDayWeekly: _weekDayWeeklyId,
                                    weekNumberFortnight: weekNumberId,
                                    startingMonth: startingMonthId)) {
                                  return 'This field is required';
                                }
                                return null;
                              }),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contributionTypeId == 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: DatePicker(
                            labelText: "Select Invoice Date",
                            firstDate: DateTime.now(),
                            lastDate: new DateTime(2099),
                            selectedDate: _invoiceDate,
                            selectDate: (selectedDate) {
                              setState(() {
                                _invoiceDate = selectedDate;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: DatePicker(
                            labelText: "Select Contribution Date",
                            firstDate: DateTime.now(),
                            lastDate: new DateTime(2099),
                            selectedDate: _contributionDate,
                            selectDate: (selectedDate) {
                              setState(() {
                                _contributionDate = selectedDate;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    initialValue:
                        _contributionName != null ? _contributionName : '',
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(fontFamily: 'SegoeUI'),
                    enabled: _isFormEnabled,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).hintColor,
                                width: 1.0)),
                        labelText: "Contribution Name",
                        labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                    onChanged: (value) {
                      _contributionName = value;
                    },
                    validator: (value) {
                      if (value.trim() == '' || value.trim() == null) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue:
                        _contributionAmount != null ? _contributionAmount : '',
                    style: TextStyle(fontFamily: 'SegoeUI'),
                    enabled: _isFormEnabled,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).hintColor,
                                width: 1.0)),
                        labelText: "Contribution Amount",
                        labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                    onChanged: (value) {
                      _contributionAmount = value;
                    },
                    validator: (value) {
                      if (value.trim() == '' || value.trim() == null) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      customTitle(
                          text: "Disable contribution arrears",
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start),
                      Switch(
                        value: displayContributionArrears,
                        onChanged: (value) {
                          setState(() {
                            displayContributionArrears = value;
                          });
                        },
                      )
                    ],
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
                  },
                ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
