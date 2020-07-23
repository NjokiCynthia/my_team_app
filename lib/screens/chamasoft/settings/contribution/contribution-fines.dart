import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/contribution/validate-settings.dart';
import 'package:chamasoft/screens/chamasoft/settings/setup-lists/fine-setup-list.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown-strings-only.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContributionFineSettings extends StatefulWidget {
  final dynamic responseData;
  final Function(dynamic) onButtonPressed;

  ContributionFineSettings({@required this.responseData, @required this.onButtonPressed});

  @override
  _ContributionFineSettingsState createState() => _ContributionFineSettingsState();
}

class _ContributionFineSettingsState extends State<ContributionFineSettings> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormEnabled = true;
  var _isLoading = false;

  String requestId = ((DateTime.now().millisecondsSinceEpoch / 1000).truncate()).toString();

  String contributionId;
  bool fineSettingsEnabled = false;
  int fineTypeId;
  int fineFrequencyId;
  int fineFrequencyChargedOnId;
  double fineAmount = 0;
  int fineForId;
  int fineLimitId;
  String fineChargeableOn = "1";
  int percentageFineOptionId;

  void _getFineSettings() {
    contributionId = widget.responseData['contribution_id'].toString();
  }

  void _submit(BuildContext context) async {
    if (fineSettingsEnabled) if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _isFormEnabled = false;
      _isLoading = true;
    });

    Map<String, dynamic> formData = {};
    formData["request_id"] = requestId;
    formData["contribution_id"] = contributionId;
    List<dynamic> fineArray = [];
    Map<String, dynamic> fineSettings = {};
    fineSettings["fine_type"] = fineTypeId;
    fineSettings["fixed_fine_frequency"] = fineFrequencyId;
    fineSettings["fixed_amount"] = fineAmount;
    fineSettings["fixed_fine_mode"] = fineForId;
    fineSettings["fixed_fine_chargeable_on"] = fineChargeableOn;
    fineSettings["fine_limit"] = fineLimitId;
    fineSettings["percentage_fine_mode"] = fineForId;
    fineSettings["percentage_rate"] = fineAmount;
    fineSettings["percentage_fine_on"] = percentageFineOptionId;
    fineSettings["percentage_fine_frequency"] = fineFrequencyId;
    fineSettings["percentage_fine_chargeable_on"] = fineChargeableOn;
    fineSettings["sms_notifications_enabled"] = "1";
    fineSettings["email_notifications_enabled"] = "1";
    fineArray.add(fineSettings);
    formData['fine_settings'] = fineArray;
    formData["enable_fines"] = fineSettingsEnabled ? 1 : 0;

    print(formData);

    try {
      final response = await Provider.of<Groups>(context, listen: false).addContributionStepThree(formData);
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
    super.initState();
    _getFineSettings();
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
              customTitle(text: "Fines", color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w400, textAlign: TextAlign.start),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              subtitle2(text: "Set Fines for Late Payments", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              customTitle(
                  text: "Activate Fine Settings",
                  color: Theme.of(context).textSelectionHandleColor,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start),
              Switch(
                value: fineSettingsEnabled,
                onChanged: (value) {
                  setState(() {
                    fineSettingsEnabled = value;
                  });
                },
              )
            ],
          ),
          Visibility(
            visible: fineSettingsEnabled,
            child: Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: <Widget>[
                    CustomDropDownButton(
                      labelText: "Select fine type",
                      listItems: fineTypesList,
                      selectedItem: fineTypeId,
                      enabled: _isFormEnabled,
                      onChanged: (value) {
                        setState(() {
                          fineTypeId = value;
                        });
                      },
                      validator: (_) {
                        if (fineSettingsEnabled && fineTypeId == null) {
                          return 'This field is required';
                        }

                        return null;
                      },
                    ),
                    Visibility(
                      visible: (fineTypeId == 1 || fineTypeId == 2),
                      child: amountTextInputField(
                        context: context,
                        enabled: _isFormEnabled,
                        labelText: fineTypeId == 1 ? 'Fixed Amount' : "Percentage Rate",
                        onChanged: (value) {
                          setState(() {
                            fineAmount = double.parse(value);
                          });
                        },
                        validator: (_) {
                          if (fineAmount == null) {
                            return 'This field is required';
                          } else if (fineAmount < 0.1) {
                            return 'This field is required';
                          }

                          return null;
                        },
                      ),
                    ),
                    Visibility(
                      visible: fineTypeId == 2,
                      child: CustomDropDownButton(
                        labelText: "Select percentage fine option",
                        listItems: percentageFineOnOptions,
                        enabled: _isFormEnabled,
                        selectedItem: percentageFineOptionId,
                        onChanged: (value) {
                          setState(() {
                            percentageFineOptionId = value;
                          });
                        },
                        validator: (_) {
                          if (!ValidateSettings().validateFines(
                              fineType: fineTypeId,
                              fineFor: fineForId,
                              fineChargeableOn: fineChargeableOn,
                              fineFrequency: fineFrequencyId,
                              fineLimit: fineLimitId,
                              percentageFineOn: percentageFineOptionId)) {
                            return 'This field is required';
                          }

                          return null;
                        },
                      ),
                    ),
                    CustomDropDownButton(
                      labelText: "Select Fine For",
                      listItems: fineForList,
                      selectedItem: fineForId,
                      enabled: _isFormEnabled,
                      onChanged: (value) {
                        setState(() {
                          fineForId = value;
                        });
                      },
                      validator: (_) {
                        if (!ValidateSettings().validateFines(
                            fineType: fineTypeId,
                            fineFor: fineForId,
                            fineChargeableOn: fineChargeableOn,
                            fineFrequency: fineFrequencyId,
                            fineLimit: fineLimitId,
                            percentageFineOn: percentageFineOptionId)) {
                          return 'This field is required';
                        }

                        return null;
                      },
                    ),
                    CustomDropDownStringOnlyButton(
                      labelText: "Select Fine Chargeable On",
                      listItems: fineChargeableOnOptions,
                      selectedItem: fineChargeableOn,
                      enabled: _isFormEnabled,
                      onChanged: (value) {
                        setState(() {
                          fineChargeableOn = value;
                        });
                      },
                      validator: (_) {
                        print('called');
                        if (!ValidateSettings().validateFines(
                            fineType: fineTypeId,
                            fineFor: fineForId,
                            fineChargeableOn: fineChargeableOn,
                            fineFrequency: fineFrequencyId,
                            fineLimit: fineLimitId,
                            percentageFineOn: percentageFineOptionId)) {
                          return 'This field is required';
                        }

                        return null;
                      },
                    ),
                    CustomDropDownButton(
                      labelText: "Select Fine Frequency",
                      listItems: fineFrequencyOptions,
                      enabled: _isFormEnabled,
                      selectedItem: fineFrequencyId,
                      onChanged: (value) {
                        setState(() {
                          fineFrequencyId = value;
                        });
                      },
                      validator: (_) {
                        if (!ValidateSettings().validateFines(
                            fineType: fineTypeId,
                            fineFor: fineForId,
                            fineChargeableOn: fineChargeableOn,
                            fineFrequency: fineFrequencyId,
                            fineLimit: fineLimitId,
                            percentageFineOn: percentageFineOptionId)) {
                          return 'This field is required';
                        }

                        return null;
                      },
                    ),
                    Visibility(
                      visible: fineForId == 1,
                      child: CustomDropDownButton(
                        labelText: "Select Fine Limit",
                        listItems: fineLimitOptions,
                        enabled: _isFormEnabled,
                        selectedItem: fineLimitId,
                        onChanged: (value) {
                          setState(() {
                            fineLimitId = value;
                          });
                        },
                        validator: (_) {
                          if (!ValidateSettings().validateFines(
                              fineType: fineTypeId,
                              fineFor: fineForId,
                              fineChargeableOn: fineChargeableOn,
                              fineFrequency: fineFrequencyId,
                              fineLimit: fineLimitId,
                              percentageFineOn: percentageFineOptionId)) {
                            return 'This field is required';
                          }

                          return null;
                        },
                      ),
                    ),
                  ]),
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
