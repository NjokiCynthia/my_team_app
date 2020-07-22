import 'package:chamasoft/screens/chamasoft/settings/setup-lists/fine-setup-list.dart';
import 'package:chamasoft/widgets/custom-dropdown-strings-only.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:flutter/material.dart';

class ContributionFineSettings extends StatefulWidget {
  @override
  _ContributionFineSettingsState createState() => _ContributionFineSettingsState();
}

class _ContributionFineSettingsState extends State<ContributionFineSettings> {
  bool fineSettingsEnabled = false;
  int fineTypeId;
  int fineFrequencyIid;
  int fineFrequencyChargedOnId;
  double fineAmount = 0;
  int fineForId;
  int fineLimitId;
  String fineChargeableOn;
  int percentageFineOptionId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Fines",
              style: TextStyle(color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "Select Fines for Late Members",
              style: TextStyle(color: Theme.of(context).bottomAppBarColor),
            ),
          ),
          SwitchListTile(
            title: Text(
              "Activate Fine Settings",
              style: TextStyle(color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w500),
            ),
            value: fineSettingsEnabled,
            onChanged: (bool value) {
              setState(() {
                fineSettingsEnabled = value;
              });
            },
          ),
          Visibility(
            visible: fineSettingsEnabled,
            child: Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: <Widget>[
                    CustomDropDownButton(
                      labelText: "Select Fine Type",
                      listItems: fineTypesList,
                      selectedItem: fineTypeId,
                      onChanged: (value) {
                        setState(() {
                          fineTypeId = value;
                        });
                      },
                    ),
                    Visibility(
                      visible: fineTypeId == 1,
                      child: amountTextInputField(
                        context: context,
                        labelText: 'Fixed Amount',
                        hintText: '1,500',
                        onChanged: (value) {
                          setState(() {
                            fineAmount = double.parse(value);
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: fineTypeId == 2,
                      child: amountTextInputField(
                        context: context,
                        labelText: 'Percentage Rate',
                        hintText: '',
                        onChanged: (value) {
                          setState(() {
                            fineAmount = double.parse(value);
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: fineTypeId == 2,
                      child: CustomDropDownButton(
                        labelText: "Select percentage fine option",
                        listItems: percentageFineOnOptions,
                        selectedItem: percentageFineOptionId,
                        onChanged: (value) {
                          setState(() {
                            percentageFineOptionId = value;
                          });
                        },
                      ),
                    ),
                    CustomDropDownStringOnlyButton(
                      labelText: "Select Fine Chargeable On",
                      listItems: fineChargeableOnOptions,
                      selectedItem: fineChargeableOn,
                      onChanged: (value) {
                        setState(() {
                          fineChargeableOn = value;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: "Select Fine For",
                      listItems: fineForList,
                      selectedItem: fineForId,
                      onChanged: (value) {
                        setState(() {
                          fineForId = value;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: "Select Fine Frequency",
                      listItems: fineFrequencyOptions,
                      selectedItem: fineFrequencyIid,
                      onChanged: (value) {
                        setState(() {
                          fineFrequencyIid = value;
                        });
                      },
                    ),
                    Visibility(
                      visible: fineForId == 1,
                      child: CustomDropDownButton(
                        labelText: "Select Fine Limit",
                        listItems: fineLimitOptions,
                        selectedItem: fineLimitId,
                        onChanged: (value) {
                          setState(() {
                            fineLimitId = value;
                          });
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              RaisedButton(
//                onPressed: () {
//                  if (_pageController.hasClients) {
//                    _pageController.animateToPage(
//                      1,
//                      duration: const Duration(milliseconds: 400),
//                      curve: Curves.easeInOut,
//                    );
//                  }
//
//                  setState(() {
//                    currentPage = 1;
//                  });
//                },
//                color: primaryColor,
//                child: Text(
//                  'Back',
//                  style: TextStyle(
//                    color: Colors.white,
//                  ),
//                ),
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(4.0),
//                ),
//              ),
//              RaisedButton(
//                onPressed: () {},
//                color: primaryColor,
//                child: Text(
//                  'Save',
//                  style: TextStyle(
//                    color: Colors.white,
//                  ),
//                ),
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(4.0),
//                ),
//              ),
//            ],
//          ),
        ],
      ),
    );
  }
}
