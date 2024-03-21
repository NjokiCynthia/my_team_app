import 'dart:developer';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/group-loan-amortizatioin.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
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
  //int _loanTypeId;
  int loanTypeId;
  int _groupLoanAmount;
  int _repaymentType;
  bool _isChecked = false;
  int _numOfGuarantors;

  int _repaymentPeriod;
  int _interestRate;
  String _groupLoanName;
  int _repaymentPeriodTypes;

  LoanType _loanType;
  List<int> _guarantors = [];
  List<int> _amounts = [];

  Map<String, dynamic> formLoadData = {};

  int get totalGuaranteed {
    int total = 0;

    total = _amounts.reduce((value, element) => value + element);

    return total;
  }

  Group _group;
  Auth _user;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchDefaultValues(context);
    }
    _group = Provider.of<Groups>(context, listen: false).getCurrentGroup();
    _user = Provider.of<Auth>(context, listen: false);

    super.didChangeDependencies();
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
          }

          if (duplicateGuarantor == true) {
            // show error dialog
            StatusHandler().showErrorDialog(context,
                "You cannot be guaranteed by one member more than once.");
          } else {
            if (!isChecked) {
              StatusHandler().showErrorDialog(
                  context, "You must the accept terms and conditions.");
            } else {
              // show confirmation dialog
              showConfirmDialog(context, loanType);
            }
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
          showConfirmDialog(context, loanType);
        }
      }
    }
  }

  void showConfirmDialog(BuildContext context, LoanType loanType) {
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
                negativeActionDialogButton(
                  text: ('CANCEL'),
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  action: () {
                    Navigator.of(context).pop();
                  },
                ),
                positiveActionDialogButton(
                    text: ('PROCEED'),
                    color: primaryColor,
                    action: () {
                      // ignore: todo
                      // TODO: SEND TO SERVER FUNCTION
                      Navigator.of(context).pop();

                      submitGroupLoanApplication(context, groupObject);
                    }),
              ],
            ));
  }

  void submitGroupLoanApplication(
      BuildContext context, Group groupObject) async {
    Map<String, dynamic> formData = {
      "user_id": _user.id,
      "group_id": _group.groupId,
      "member_id": _group.memberId,

      "loan_amount": _groupLoanAmount,
      "repayment_period": _repaymentPeriod,
      'loan_product_id': loanTypeId,
      // 'amount': _groupLoanAmount,
      // 'guarantors': _guarantors,
      // 'amounts': _amounts,
      // 'group_id': groupObject.groupId
    };

    print('form data is: $formData');
    // Show the loader
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });

    try {
      String response = await Provider.of<Groups>(context, listen: false)
          .submitLoanApplication(formData);

      StatusHandler().showSuccessSnackBar(context, "Good news: $response");

      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => ApplyLoan(
                  isFromAmt: false,
                  isFromAmtIndividual: false,
                  isFromGroupActive: true,
                )));
      });
    } on CustomException catch (error) {
      StatusHandler().showDialogWithAction(
          context: context,
          message: error.toString(),
          function: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => ApplyLoan(
                        isInit: false,
                      ))),
          dismissible: true);
    } finally {}
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
                loanTypeId: loanTypeId,
                repayementPeriod: _repaymentPeriod,
                loanInterestRate: _interestRate,
                groupLoanName: _groupLoanName,
                groupLoanType: loanTypeId),
            settings: RouteSettings(arguments: {
              'loanType': _loanType,
              'groupLoanAmount': _groupLoanAmount
            })),
      );
    }
  }

  bool _isFormInputEnabled = true;
  bool _isLoading = false;
  bool _isInit = true;
  Map<String, dynamic> _formData = {};
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
        .loadInitialFormData(acc: true, member: true, loanTypes: true);
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
    // _formData['disbursement_date'] = disbursementDate.toString();
    _formData['loan_type_id'] = loanTypeId;

    _formData['loan_amount'] = _groupLoanAmount;

    log(_formData.toString());
    try {
      String message = await Provider.of<Groups>(context, listen: false)
          .recordMemberLoan(_formData);
      StatusHandler().showSuccessSnackBar(context, message);

      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => ReviewLoan()));
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

    // List<NamesListItem> loanTypeOptions =
    //     widget.formLoadData.containsKey('loanTypeOptions')
    //         ? widget.formLoadData['loanTypeOptions']
    //         : [];
    // final arguments =
    //     ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    // LoanType _loanType = arguments['loanType'];
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (arguments != null && arguments.containsKey('loanType')) {
      LoanType _loanType = arguments['loanType'];
      print(_loanType.guarantors);
      // Now you can use _loanType or perform further operations
    } else {
      // Handle the case where 'loanType' is not found in arguments
      print('Error: Key "loanType" not found in arguments.');
    }

    List<NamesListItem> memberOptions =
        widget.formLoadData.containsKey('memberOptions')
            ? widget.formLoadData['memberOptions']
            : [];
    // int _numOfGuarantors = int.tryParse(_loanType.guarantors) != null
    //     ? int.tryParse(_loanType.guarantors)
    //     : 0;

    // String repaymentPeriod = _loanType.repaymentPeriod != ""
    //     ? _loanType.repaymentPeriod
    //     : _loanType.maximumRepaymentPeriod;

    return Builder(builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(children: [
              toolTip(
                  context: context,
                  title: "Note that...",
                  message:
                      "Loan application process is totally depended on your group's constitution and your group\'s management."),
              Container(
                child: SingleChildScrollView(
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(children: [
                              CustomDropDownButton(
                                labelText: "Select  Group Loan Type",
                                enabled: _isFormInputEnabled,
                                //listItems: loanTypeOptions,
                                listItems:
                                    formLoadData.containsKey("loanTypeOptions")
                                        ? formLoadData["loanTypeOptions"]
                                        : [],
                                selectedItem: loanTypeId,
                                validator: (value) {
                                  if (value == null) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    loanTypeId = value;
                                    print(loanTypeId);
                                    var matchingLoanType =
                                        widget.loanTypes.firstWhere(
                                      (loanType) =>
                                          loanType.id.toString() ==
                                          value.toString(),
                                      orElse: () => null,
                                    );

                                    _numOfGuarantors = matchingLoanType != null
                                        ? int.tryParse(matchingLoanType
                                            .guarantors
                                            .replaceAll(RegExp(r'[^0-9]'), ''))
                                        : 0;
                                    print('number of guarantors');
                                    print(_numOfGuarantors);
                                    _numOfGuarantors = matchingLoanType != null
                                        ? int.tryParse(matchingLoanType
                                            .guarantors
                                            .replaceAll(RegExp(r'[^0-9]'), ''))
                                        : 0;

                                    _repaymentPeriodTypes =
                                        matchingLoanType != null
                                            ? int.tryParse(matchingLoanType
                                                .repaymentPeriodType)
                                            //.replaceAll(RegExp(r'[^0-9]'), ''
                                            //))
                                            : 0;
                                    print('repayment period type');
                                    print(_repaymentPeriodTypes);
                                    _interestRate = matchingLoanType != null
                                        ? int.tryParse(matchingLoanType
                                            .interestRate
                                            .replaceAll(
                                                new RegExp(r'[^0-9]'), ''))
                                        : 0;
                                    print(_interestRate);
                                    _groupLoanName = matchingLoanType != null
                                        ? matchingLoanType.name
                                        : '';
                                    print(_groupLoanName);
                                  });
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
                          if (_repaymentPeriodTypes != null &&
                              _repaymentPeriodTypes == 2)
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    _repaymentType = value != null
                                        ? int.tryParse(value)
                                        : 0.0;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Enter loan repayment period",
                                ),
                                validator: (value) {
                                  if (value == "" || value == null) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                              ),
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
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
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
                                        "url": () =>
                                            toGroupAmmotization(context),
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
                              onPressed: () => submitGroupLoan(
                                  _isChecked, context, _loanType))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
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
