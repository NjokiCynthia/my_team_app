import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/setting_helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ReconcileDepositForm extends StatefulWidget {
  Function _addReconciledDeposit;

  ReconcileDepositForm(this._addReconciledDeposit, {Key key}) : super(key: key);

  @override
  _ReconcileDepositFormState createState() => _ReconcileDepositFormState();
}

class _ReconcileDepositFormState extends State<ReconcileDepositForm> {
  final _formKey = new GlobalKey<FormState>();
  bool _isInit = true;
  Map<String, dynamic> formLoadData = {};
  bool _isFormInputEnabled = true;

  // form values
  String description;

  double amount, amountPayable, amountDisbursed, pricePerShare;

  int depositTypeId,
      memberId,
      contributionId,
      fineCategoryId,
      depositorId,
      incomeCategoryId,
      loanId,
      accountId,
      stockId,
      assetId,
      moneyMarketInvestmentId,
      borrowerId,
      numberOfSharesSold;

  List<NamesListItem> groupMembers;
  List<NamesListItem> groupContributions;
  List<NamesListItem> groupFines;
  List<NamesListItem> groupDepositors;
  List<NamesListItem> groupIncomeCategories;
  List<NamesListItem> groupLoanTypes;
  List<NamesListItem> groupAccounts;
  List<NamesListItem> groupMoneyMarketInvestments;
  List<NamesListItem> groupStocks;
  List<NamesListItem> groupAssets;
  List<NamesListItem> groupBorrowers;

  void addReconciledDeposit(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    widget._addReconciledDeposit({
      "description": description,
      "amount": amount,
      "amountPayable": amountPayable,
      "amountDisbursed": amountDisbursed,
      "depositTypeId": depositTypeId,
      "memberId": memberId,
      "contributionId": contributionId,
      "fineCategoryId": fineCategoryId,
      "depositorId": depositorId,
      "incomeCategoryId": incomeCategoryId,
      "loanId": loanId,
      "accountId": accountId,
      "stockId": stockId,
      "assetId": assetId,
      "moneyMarketInvestmentId": moneyMarketInvestmentId,
      "borrowerId": borrowerId,
      "numberOfSharesSold": numberOfSharesSold
    });

    // pop out the dialog
    Navigator.of(context).pop();
  }

  Future<void> _fetchDefaultValues() async {
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
    try {
      formLoadData =
          await Provider.of<Groups>(context, listen: false).loadInitialFormData(
        contr: true,
        acc: true,
        member: true,
        fineOptions: true,
        depositor: true,
        incomeCats: true,
        loanTypes: true,
        groupStocks: true,
        groupAssets: true,
        moneyMarketInvestments: true,
        // ignore: todo
        // TODO: add groupBorrowers
      );
    } catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchDefaultValues();
          });
    } finally {
      setState(() {
        _isInit = false;
        groupMembers = formLoadData.containsKey("memberOptions")
            ? formLoadData['memberOptions']
            : [];
        groupContributions = formLoadData.containsKey("contributionOptions")
            ? formLoadData['contributionOptions']
            : [];
        groupFines = formLoadData.containsKey("finesOptions")
            ? formLoadData['finesOptions']
            : [];
        groupDepositors = formLoadData.containsKey("depositorOptions")
            ? formLoadData['depositorOptions']
            : [];
        groupIncomeCategories =
            formLoadData.containsKey("incomeCategoryOptions")
                ? formLoadData['incomeCategoryOptions']
                : [];
        groupLoanTypes = formLoadData.containsKey("loanTypeOptions")
            ? formLoadData['loanTypeOptions']
            : [];
        groupAccounts = formLoadData.containsKey("accountOptions")
            ? formLoadData['accountOptions']
            : [];
        groupMoneyMarketInvestments =
            formLoadData.containsKey("moneyMarketInvestmentOptions")
                ? formLoadData['moneyMarketInvestmentOptions']
                : [];
        groupStocks = formLoadData.containsKey("groupStockOptions")
            ? formLoadData['groupStockOptions']
            : [];
        groupAssets = formLoadData.containsKey("groupAssetOptions")
            ? formLoadData['groupAssetOptions']
            : [];
        // ignore: todo
        // TODO: ADD BORROWER OPTIONS
        groupBorrowers = formLoadData.containsKey("groupBorrowerOptions")
            ? formLoadData['groupBorrowerOptions']
            : [];
      });
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  String getAlertText() {
    String _resp = "";
    if (groupMembers.length == 0) _resp = "There are no group members found";
    if (depositTypeId == 1 && groupContributions.length == 0)
      _resp = "There are no group contributions found";
    if (depositTypeId == 2 && groupFines.length == 0)
      _resp = "There are no group fines found";
    if (depositTypeId == 4 && groupDepositors.length == 0)
      _resp = "There are no group depositors found";
    if (depositTypeId == 4 && groupIncomeCategories.length == 0)
      _resp = "There are no group income categories found";
    if (depositTypeId == 5 && groupLoanTypes.length == 0)
      _resp = "There are no group loans found";
    if (depositTypeId == 7 && groupAccounts.length == 0)
      _resp = "There are no group accounts found";
    if (depositTypeId == 8 && groupStocks.length == 0)
      _resp = "There are no group stocks found";
    if (depositTypeId == 9 && groupAssets.length == 0)
      _resp = "There are no group assets found";
    if (depositTypeId == 10 && groupMoneyMarketInvestments.length == 0)
      _resp = "There are no group money market investments found";
    if (depositTypeId == 11 && groupLoanTypes.length == 0)
      _resp = "There are no group loans found";
    if (depositTypeId == 12 && groupBorrowers.length == 0)
      _resp = "There are no group borrowers found";
    if (depositTypeId == 12 && groupLoanTypes.length == 0)
      _resp = "There are no group loans found";
    return _resp != "" ? _resp + ", you cannot continue." : "";
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchDefaultValues();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      title: heading2(
          text: 'Reconcile deposit',
          textAlign: TextAlign.start,
          // ignore: deprecated_member_use
          color: Theme.of(context).textSelectionHandleColor),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                depositTypeId != null && getAlertText() != ""
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                          color: Colors.red.withOpacity(0.15),
                        ),
                        padding: EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: [
                            Text(
                              getAlertText(),
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                CustomDropDownButton(
                  labelText: 'Select deposit for',
                  enabled: _isFormInputEnabled,
                  listItems: depositTypeOptions,
                  selectedItem: depositTypeId,
                  onChanged: (selected) {
                    setState(() {
                      depositTypeId = selected;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // For contribution payment
                if (depositTypeId == 1)
                  Column(
                    children: [
                      // Selecting member
                      selectMember(groupMembers, "Select Member"),
                      SizedBox(height: 10),
                      // Selecting contribution
                      CustomDropDownButton(
                          enabled: true,
                          labelText: "Select contribution",
                          listItems: groupContributions,
                          selectedItem: contributionId,
                          onChanged: (value) {
                            setState(() {
                              contributionId = value;
                            });
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                      SizedBox(height: 10),
                      // Amount
                      enterAmount(context, "Amount"),
                      SizedBox(height: 10)
                    ],
                  ),

                // For fine payment
                if (depositTypeId == 2)
                  Column(
                    children: [
                      // Selecting member
                      selectMember(groupMembers, "Select Member"),
                      SizedBox(height: 10),
                      // Selecting fine category
                      CustomDropDownButton(
                          enabled: true,
                          labelText: "Select fine category",
                          listItems: groupFines,
                          selectedItem: fineCategoryId,
                          onChanged: (value) {
                            setState(() {
                              fineCategoryId = value;
                            });
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                      // Enter amount
                      enterAmount(context, "Amount"),
                      SizedBox(height: 10),
                    ],
                  ),

                // For miscellaneous payment
                if (depositTypeId == 3)
                  Column(
                    children: [
                      // Selecting member
                      selectMember(groupMembers, "Select Member"),
                      SizedBox(height: 10),
                      // Entering payment description
                      enterDescription(context, "Payment description"),
                      SizedBox(height: 10),
                      // Enter amount
                      enterAmount(context, "Amount"),
                      SizedBox(height: 10)
                    ],
                  ),

                // For income
                if (depositTypeId == 4)
                  Column(
                    children: [
                      CustomDropDownButton(
                          enabled: true,
                          labelText: "Select depositor",
                          listItems: groupDepositors,
                          selectedItem: depositorId,
                          onChanged: (value) {
                            setState(() {
                              depositorId = value;
                            });
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                      SizedBox(height: 10),
                      CustomDropDownButton(
                          enabled: true,
                          labelText: "Select income category",
                          listItems: groupIncomeCategories,
                          selectedItem: incomeCategoryId,
                          onChanged: (value) {
                            setState(() {
                              incomeCategoryId = value;
                            });
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                      SizedBox(height: 10),
                      // enter amount
                      enterAmount(context, "Amount"),
                      SizedBox(height: 10),
                    ],
                  ),

                // For loan repayment
                if (depositTypeId == 5)
                  Column(
                    children: [
                      // select member
                      selectMember(groupMembers, "Select member"),
                      SizedBox(height: 10),
                      // select loan
                      CustomDropDownButton(
                          enabled: true,
                          labelText: "Select Loan",
                          listItems: groupLoanTypes,
                          selectedItem: loanId,
                          onChanged: (value) {
                            setState(() {
                              loanId = value;
                            });
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                      SizedBox(height: 10),
                      // enter amount
                      enterAmount(context, "Amount"),
                      SizedBox(height: 10)
                    ],
                  ),

                // For bank loan disbursement
                if (depositTypeId == 6)
                  Column(
                    children: [
                      // Bank loan description
                      enterDescription(context, "Bank loan description"),
                      SizedBox(height: 10),
                      // enter amount payable
                      amountTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "The field is required";
                            }
                            return null;
                          },
                          labelText: "Amount payable",
                          enabled: true,
                          onChanged: (value) {
                            setState(() {
                              amountPayable = value != null
                                  ? double.parse(value)
                                  : amount = 0;
                            });
                          }),
                      SizedBox(height: 10),
                      // enter amount disbursed
                      amountTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "The field is required";
                            }
                            return null;
                          },
                          labelText: "Amount disbursed",
                          enabled: true,
                          onChanged: (value) {
                            amountDisbursed = value != null
                                ? double.parse(value)
                                : amount = 0;
                          }),
                      SizedBox(height: 10)
                    ],
                  ),

                // For funds transfer
                if (depositTypeId == 7)
                  Column(
                    children: [
                      // Select from account
                      CustomDropDownButton(
                          enabled: true,
                          labelText: "Select from account",
                          listItems: groupAccounts,
                          selectedItem: accountId,
                          onChanged: (value) {
                            setState(() {
                              accountId = value;
                            });
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                      SizedBox(height: 10),
                      // enter money transfer description
                      enterDescription(context, "Money transfer description"),
                      SizedBox(height: 10),
                      // enter amount transferred
                      enterAmount(context, "Amount transferred"),
                      SizedBox(height: 10)
                    ],
                  ),

                // For stock sale
                if (depositTypeId == 8)
                  Column(
                      // Select stock
                      // Todo:
                      children: [
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select stock",
                            listItems: groupStocks,
                            selectedItem: stockId,
                            onChanged: (value) {
                              setState(() {
                                stockId = value;
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "This field is required";
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        amountTextInputField(
                            context: context,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "The field is required";
                              }
                              return null;
                            },
                            labelText: "Price per share",
                            enabled: true,
                            onChanged: (value) {
                              setState(() {
                                pricePerShare = value != null
                                    ? double.parse(value)
                                    : amount = 0;
                              });
                            }),
                        SizedBox(height: 10),
                        enterNumber(context, "Number of shares sold",
                            numberOfSharesSold),
                        SizedBox(height: 10),
                        enterAmount(context, "Amount"),
                        SizedBox(height: 10)
                      ]),

                // For asset sale
                if (depositTypeId == 9)
                  Column(
                    children: [
                      // select asset
                      CustomDropDownButton(
                          enabled: true,
                          labelText: "Select asset",
                          listItems: groupAssets,
                          selectedItem: assetId,
                          onChanged: (value) {
                            setState(() {
                              assetId = value;
                            });
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                      SizedBox(height: 10),
                      // enter amount
                      enterAmount(context, "Amount"),
                      SizedBox(height: 10)
                    ],
                  ),

                // For money market cash in
                if (depositTypeId == 10)
                  Column(
                      // select money market investment
                      children: [
                        // select money market investment
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select money market investment",
                            listItems: groupMoneyMarketInvestments,
                            selectedItem: moneyMarketInvestmentId,
                            onChanged: (value) {
                              setState(() {
                                moneyMarketInvestmentId = value;
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "This field is required";
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        // enter amount
                        enterAmount(context, "Amount"),
                        SizedBox(height: 10)
                      ]),

                // Loan processing income
                if (depositTypeId == 11)
                  Column(
                    children: [
                      // select member
                      selectMember(groupMembers, "Select member"),
                      SizedBox(height: 10),
                      // select loan
                      CustomDropDownButton(
                          enabled: true,
                          labelText: "Select loan",
                          listItems: groupLoanTypes,
                          selectedItem: loanId,
                          onChanged: (value) {
                            setState(() {
                              loanId = value;
                            });
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                      SizedBox(height: 10),
                      // enter amount
                      enterAmount(context, "Amount"),
                      SizedBox(height: 10)
                    ],
                  ),

                // External loan repayment
                if (depositTypeId == 12)
                  Column(
                    children: [
                      // select borrower
                      CustomDropDownButton(
                          enabled: true,
                          labelText: "Select borrower",
                          listItems: groupBorrowers,
                          selectedItem: borrowerId,
                          onChanged: (value) {
                            setState(() {
                              borrowerId = value;
                            });
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                      SizedBox(height: 10),
                      // select loan
                      CustomDropDownButton(
                          enabled: true,
                          labelText: "Select loans",
                          listItems: groupLoanTypes,
                          selectedItem: loanId,
                          onChanged: (value) {
                            setState(() {
                              loanId = value;
                            });
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "This field is required";
                            }
                            return null;
                          }),
                      SizedBox(height: 10),
                      // enter amount
                      enterAmount(context, "Amount"),
                      SizedBox(height: 10)
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        negativeActionDialogButton(
            text: "Cancel",
            // ignore: deprecated_member_use
            color: Theme.of(context).textSelectionHandleColor,
            action: () {
              Navigator.of(context).pop();
            }),
        // ignore: deprecated_member_use
        FlatButton(
          padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
          child: customTitle(
              text: "Save Changes",
              color: primaryColor,
              fontWeight: FontWeight.w600),
          onPressed: () => addReconciledDeposit(context),
        )
      ],
    );
  }

  CustomDropDownButton selectMember(
      List<NamesListItem> listItems, String label) {
    return CustomDropDownButton(
      enabled: true,
      labelText: label,
      listItems: listItems,
      selectedItem: memberId,
      onChanged: (value) {
        setState(() {
          memberId = value;
        });
      },
      validator: (value) {
        if (value == "" || value == null) {
          return "This field is required";
        }
        return null;
      },
    );
  }

  Widget enterDescription(BuildContext context, String label) {
    return simpleTextInputField(
      context: context,
      validator: (value) {
        if (value == null || value == "") {
          return "Field is required";
        }
        return null;
      },
      labelText: label,
      enabled: true,
      onChanged: (value) {
        setState(() {
          description = value;
        });
      },
    );
  }

  Widget enterAmount(BuildContext context, String label) {
    return amountTextInputField(
        context: context,
        validator: (value) {
          if (value == null || value == "") {
            return "The field is required";
          }
          return null;
        },
        labelText: label,
        enabled: true,
        onChanged: (value) {
          setState(() {
            amount = value != null ? double.parse(value) : amount = 0;
          });
        });
  }

  Widget enterNumber(BuildContext context, String label, int field) {
    return amountTextInputField(
        context: context,
        validator: (value) {
          if (value == null || value == "") {
            return "The field is required";
          }
          return null;
        },
        labelText: label,
        enabled: true,
        onChanged: (value) {
          setState(() {
            field = value != null ? int.parse(value) : amount = 0;
          });
        });
  }
}
