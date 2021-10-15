import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/group-loan-amortizatioin.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ApplyLoanFromGroup extends StatefulWidget {
  final Map<String, dynamic> formLoadData;
  final List<LoanType> loanTypes;

  const ApplyLoanFromGroup({this.formLoadData, this.loanTypes, Key key})
      : super(key: key);

  @override
  _ApplyLoanFromGroupState createState() => _ApplyLoanFromGroupState();
}

class _ApplyLoanFromGroupState extends State<ApplyLoanFromGroup> {
  final _formKey = GlobalKey<FormState>();
  int _loanTypeId;
  int _groupLoanAmount;
  bool _isChecked = false;
  int _numOfGuarantors;
  // ignore: unused_field
  int _repaymentPeriod;
  // ignore: unused_field
  LoanType _loanType;
  List<int> _guarantors = [];
  List<int> _amounts = [];

  int get totalGuaranteed {
    int total = 0;

    total = _amounts.reduce((value, element) => value + element);

    return total;
  }

  void submitGroupLoan(
      bool isChecked, BuildContext context, LoanType loanType) {
    final Group groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    if (_formKey.currentState.validate()) {
      if (_numOfGuarantors != null) {
        if (totalGuaranteed == _groupLoanAmount) {
          // check guarantor duplicates
          bool duplicateGuarantor = false;

          for (var guarantorId in _guarantors) {
            int index = _guarantors.indexOf(guarantorId);
            if (_guarantors.sublist(index + 1).contains(guarantorId)) {
              duplicateGuarantor = true;
              break;
            }
            if (duplicateGuarantor == true) {
              // show error dialog
              StatusHandler().showErrorDialog(context,
                  "You cannot be guaranteed by one member more than once.");
            }
          }
          if (!isChecked) {
            StatusHandler().showErrorDialog(
                context, "You must the accept terms and conditions.");
          } else {
            // show confirmation dialog
            showConfirmDialog(context);
          }
        } else {
          // show error dialog
          StatusHandler().showErrorDialog(context,
              "You have guaranteed ${groupObject.groupCurrency} ${currencyFormat.format(totalGuaranteed)} out of ${groupObject.groupCurrency} ${currencyFormat.format(_groupLoanAmount)}.");
        }
      } else {
        if (!isChecked) {
          StatusHandler().showErrorDialog(
              context, "You must the accept terms and conditions.");
        } else {
          // show confirmation dialog
          showConfirmDialog(context);
        }
      }
    }
  }

  void showConfirmDialog(BuildContext context) {
    final Group groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: subtitle1(text: "Confirmation"),
              content: subtitle2(
                  text:
                      "Accept loan application of ${groupObject.groupCurrency} ${currencyFormat.format(_groupLoanAmount)}."),
              actions: [
                // ignore: deprecated_member_use
                negativeActionDialogButton(
                  text: ('CANCEL'),
                  color: Theme.of(context)
                      // ignore: deprecated_member_use
                      .textSelectionHandleColor,
                  action: () {
                    Navigator.of(context).pop();
                  },
                ),
                // ignore: deprecated_member_use
                positiveActionDialogButton(
                    text: ('PROCEED'),
                    color: primaryColor,
                    action: () {
                      // ignore: todo
                      // TODO: SEND TO SERVER FUNCTION
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }

  void toGroupAmmotization(BuildContext context) {
    if (_groupLoanAmount == null) {
      StatusHandler().showErrorDialog(context,
          "Loan Amount is required to proceed to Terms and Conditions.");
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => GroupLoanAmortization(
            loanAmount: _groupLoanAmount,
            loanTypeId: _loanTypeId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return (themeChangeProvider.darkTheme)
            ? Color(0xff00a9f0)
            : Color(0xff00a9f0);
      }
      return (themeChangeProvider.darkTheme)
          ? Color(0xff00a9f0)
          : Color(0xff00a9f0);
    }

    List<NamesListItem> loanTypeOptions =
        widget.formLoadData.containsKey('loanTypeOptions')
            ? widget.formLoadData['loanTypeOptions']
            : [];

    List<NamesListItem> memberOptions =
        widget.formLoadData.containsKey('memberOptions')
            ? widget.formLoadData['memberOptions']
            : [];

    return Builder(builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.82,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        toolTip(
                            context: context,
                            title: "Note that...",
                            message:
                                "Loan application process is totally depended on your group's constitution and your group\'s management."),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(children: [
                            CustomDropDownButton(
                              enabled: true,
                              labelText: "Select group loan type",
                              listItems: loanTypeOptions,
                              onChanged: (value) {
                                setState(() {
                                  _loanTypeId = value;
                                  _numOfGuarantors = int.tryParse(widget
                                      .loanTypes
                                      .firstWhere((loanType) =>
                                          loanType.id.toString() ==
                                          value.toString())
                                      .guarantors
                                      .replaceAll(new RegExp(r'[^0-9]'), ''));
                                  _repaymentPeriod = int.tryParse(widget
                                      .loanTypes
                                      .firstWhere((loanType) =>
                                          loanType.id.toString() ==
                                          value.toString())
                                      .repaymentPeriod
                                      .replaceAll(new RegExp(r'[^0-9]'), ''));
                                });
                              },
                              validator: (value) {
                                if (value == "" || value == null) {
                                  return "This field is required";
                                }
                                return null;
                              },
                            ),
                            amountTextInputField(
                                context: context,
                                validator: (value) {
                                  if (value == null || value == "") {
                                    return "The field is required";
                                  }
                                  return null;
                                },
                                labelText: "Amount applying for",
                                onChanged: (value) {
                                  setState(() {
                                    _groupLoanAmount = value != null
                                        ? int.tryParse(value)
                                        : 0.0;
                                  });
                                }),
                            if (_numOfGuarantors != null)
                              Container(
                                height: MediaQuery.of(context).size.height *
                                    (_numOfGuarantors >= 5
                                        ? (4 / 10)
                                        : (_numOfGuarantors / 10)),
                                child: ListView.builder(
                                  itemBuilder: (BuildContext context, index) {
                                    return addGuarantor(
                                        memberOptions, context, index);
                                  },
                                  itemCount: _numOfGuarantors,
                                ),
                              )
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Row(
                            children: [
                              Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: _isChecked,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isChecked = value;
                                    });
                                  }),
                              textWithExternalLinks(
                                  color: Colors.blueGrey,
                                  size: 12.0,
                                  textData: {
                                    'I agree to the ': {},
                                    'terms and conditions': {
                                      "url": () => toGroupAmmotization(context),
                                      "color": primaryColor,
                                      "weight": FontWeight.w500
                                    },
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        defaultButton(
                            context: context,
                            text: "Apply Now",
                            onPressed: () =>
                                submitGroupLoan(_isChecked, context, _loanType))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Row addGuarantor(
      List<NamesListItem> _memberOptions, BuildContext context, int index) {
    //_memberOptions.map((e) => guarantors);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: CustomDropDownButton(
            enabled: true,
            labelText: "Select guarantor",
            listItems: _memberOptions,
            onChanged: (value) {
              setState(() {
                if (_guarantors.asMap().containsKey(index)) {
                  _guarantors[index] = value;
                } else {
                  _guarantors.add(value);
                }
              });
            },
            validator: (value) {
              if (value == "" || value == null) {
                return "This field is required";
              }
              return null;
            },
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: amountTextInputField(
              context: context,
              validator: (value) {
                if (value == null || value == "") {
                  return "The field is required";
                }
                return null;
              },
              labelText: "Enter Amount",
              enabled: true,
              onChanged: (value) {
                setState(() {
                  if (_amounts.asMap().containsKey(index)) {
                    _amounts[index] = int.tryParse(value);
                  } else {
                    _amounts.add(int.tryParse(value));
                  }
                });
              }),
        ))
      ],
    );
  }
}
