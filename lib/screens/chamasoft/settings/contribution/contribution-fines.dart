import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/contribution/validate-settings.dart';
import 'package:chamasoft/screens/chamasoft/settings/setup-lists/fine-setup-list.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/report_helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown-strings-only.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContributionFineSettings extends StatefulWidget {
  final dynamic responseData;
  final bool isEditMode;
  final dynamic contributionDetails;
  final Function(dynamic) onButtonPressed;

  ContributionFineSettings(
      {@required this.responseData,
      this.isEditMode,
      this.contributionDetails,
      @required this.onButtonPressed});

  @override
  _ContributionFineSettingsState createState() =>
      _ContributionFineSettingsState();
}

class _ContributionFineSettingsState extends State<ContributionFineSettings> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormEnabled = true;
  var _isLoading = false;

  String requestId =
      ((DateTime.now().millisecondsSinceEpoch / 1000).truncate()).toString();

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

    if (widget.isEditMode) {
      dynamic settings =
          widget.contributionDetails['contribution_settings'] as dynamic;
      final enableFines = ParseHelper.getIntFromJson(settings, 'enable_fines');
      if (enableFines == 1) {
        List<dynamic> list = widget
            .contributionDetails['contribution_fine_settings'] as List<dynamic>;
        if (list.length > 0) {
          dynamic fineSettings = list[0];
          setState(() {
            fineTypeId =
                int.tryParse(fineSettings["fine_type"].toString()) ?? null;

            if (fineTypeId == 1) {
              fineAmount =
                  double.tryParse(fineSettings["fixed_amount"].toString()) ??
                      null;
              fineForId =
                  int.tryParse(fineSettings["fixed_fine_mode"].toString()) ??
                      null;
              fineFrequencyId = int.tryParse(
                      fineSettings["fixed_fine_frequency"].toString()) ??
                  null;
              fineChargeableOn =
                  fineSettings["fixed_fine_chargeable_on"].toString();
            } else {
              fineAmount =
                  double.tryParse(fineSettings["percentage_rate"].toString()) ??
                      null;
              fineForId = int.tryParse(
                      fineSettings["percentage_fine_mode"].toString()) ??
                  null;
              fineFrequencyId = int.tryParse(
                      fineSettings["percentage_fine_frequency"].toString()) ??
                  null;
              fineChargeableOn =
                  fineSettings["percentage_fine_chargeable_on"].toString();
              percentageFineOptionId =
                  int.tryParse(fineSettings["percentage_fine_on"].toString()) ??
                      null;
            }

            fineLimitId =
                int.tryParse(fineSettings["fine_limit"].toString()) ?? null;
            fineSettingsEnabled = true;
          });
        }
      }
    }
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
      final response = await Provider.of<Groups>(context, listen: false)
          .addContributionStepThree(formData);
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
              customTitle(
                  text: "Fines",
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              subtitle2(
                  text: "Set Fines for Late Payments",
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                  textAlign: TextAlign.start),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              customTitle(
                  text: "Activate Fine Settings",
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionTheme.selectionHandleColor,
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
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
                          child: TextFormField(
                            initialValue:
                                fineAmount > 0.1 ? fineAmount.toString() : '',
                            style: TextStyle(fontFamily: 'SegoeUI'),
                            enabled: _isFormEnabled,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).hintColor,
                                        width: 1.0)),
                                labelText: fineTypeId == 1
                                    ? 'Fixed Amount'
                                    : "Percentage Rate",
                                labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                            onChanged: (value) {
                              fineAmount = double.tryParse(value) ?? 0;
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
