import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/setup-lists/contribution-setup-list.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/date-picker.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class AddContributionDialog extends StatefulWidget {
  static const String namedRoute = '/add-contribution-dialog';

  @override
  _AddContributionDialogState createState() => _AddContributionDialogState();
}

class _AddContributionDialogState extends State<AddContributionDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormEnabled = true;
  bool _isSelectDayEnabled = true;
  var _isLoading = false;

  String requestId =
      ((DateTime.now().millisecondsSinceEpoch / 1000).truncate()).toString();

  int _contributionTypeId;
  int _daysOfTheMonth;
  int _weekDay = 0;
  DateTime now = DateTime.now();
  DateTime _invoiceDate = DateTime.now();
  DateTime _contributionDate = DateTime.now();
  String _contributionName;
  String _contributionAmount;
  final dateFormat = DateFormat('dd-MM-y');

  void _saveContribution(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _isFormEnabled = false;
      _isSelectDayEnabled = false;
      _isLoading = true;
    });

    Map<String, dynamic> formData = {};
    formData['request_id'] = requestId;
    formData['amount'] = _contributionAmount;
    formData['name'] = _contributionName;
    formData['type'] = _contributionTypeId;
    formData['month_day_monthly'] = _daysOfTheMonth;
    formData['month_day_multiple'] = _daysOfTheMonth;
    formData['week_day_multiple'] = _weekDay;
    formData['week_day_monthly'] = _weekDay;
    formData['contribution_date'] = dateFormat.format(_contributionDate);
    formData["invoice_date"] = dateFormat.format(_invoiceDate);
    formData['contribution_frequency'] = 1;
    formData['regular_invoicing_active'] = 1;
    formData['one_time_invoicing_active'] = 1;
    formData['invoice_days'] = 1;

    try {
      await Provider.of<Groups>(context, listen: false)
          .addContributionStepOne(formData, false);
      requestId = null;
      Navigator.of(context).pop(true);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _saveContribution(context);
          });
    } finally {
      setState(() {
        _isLoading = false;
        _isFormEnabled = true;
        _isSelectDayEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_brace_in_string_interps
    print('Request: ${requestId}');
    print('Now: ${(DateTime.now().millisecondsSinceEpoch / 1000).truncate()}');
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Add Group Contribution",
        leadingIcon: LineAwesomeIcons.times,
        elevation: 1.0,
        action: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomDropDownButton(
                    labelText: "Select Frequency",
                    enabled: _isFormEnabled,
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
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _contributionTypeId == 1,
                    child: Column(
                      children: <Widget>[
                        CustomDropDownButton(
                          labelText: "Select Day",
                          enabled: _isFormEnabled,
                          listItems: getDaysOfTheMonth,
                          selectedItem: _daysOfTheMonth,
                          onChanged: (value) {
                            setState(() {
                              _daysOfTheMonth = value;
                              if (value < 5 || value == 32) {
                                _isSelectDayEnabled = true;
                              } else {
                                _weekDay = 0;
                                _isSelectDayEnabled = false;
                              }
                            });
                          },
                          validator: (value) {
                            if (_contributionTypeId == 1) if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomDropDownButton(
                          labelText: "Select Day of Month",
                          enabled: _isSelectDayEnabled,
                          listItems: getMonthDays,
                          selectedItem: _weekDay,
                          onChanged: (value) {
                            setState(() {
                              _weekDay = value;
                            });
                          },
                          validator: (value) {
                            if (_contributionTypeId == 1) if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 5,
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
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
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
                  SizedBox(
                    height: 5,
                  ),
                  amountTextInputField(
                      enabled: _isFormEnabled,
                      context: context,
                      labelText: 'Contribution Amount',
                      onChanged: (value) {
                        _contributionAmount = value;
                      },
                      validator: (value) {
                        if (value == null || value.trim() == '') {
                          return "This field is required";
                        }
                        return null;
                      }),
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
                          text: "Save",
                          onPressed: () {
                            _saveContribution(context);
                          },
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
