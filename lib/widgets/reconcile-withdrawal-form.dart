import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/helpers/setting_helper.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";

class ReconcileWithdrawalForm extends StatefulWidget {
  final Function addReconciledWithdrawal;
  final Map<String, dynamic> formLoadData;
  const ReconcileWithdrawalForm(this.addReconciledWithdrawal, this.formLoadData,
      {Key key})
      : super(key: key);

  @override
  _ReconcileWithdrawalFormState createState() =>
      _ReconcileWithdrawalFormState();
}

class _ReconcileWithdrawalFormState extends State<ReconcileWithdrawalForm> {
  final _formKey = new GlobalKey<FormState>();
  // bool _isInit = true;
  //bool _isFormInputEnabled = true;

  // form values
  String stockName, description, moneyMarketInvestmentName, memberName;

  double amount, pricePerShare;

  int withdrawalTypeId,
      expenseCategoryId,
      assetId,
      memberId,
      loanId,
      numberOfShares,
      moneyMarketInvestmentId,
      contribId,
      bankLoanId,
      recipientAccountId,
      borrowerId;

  List<NamesListItem> groupMembers = [];
  List<NamesListItem> groupExpenseCategories = [];
  List<NamesListItem> groupContributions = [];
  List<NamesListItem> groupAccounts = [];
  List<NamesListItem> groupLoans = [];
  List<NamesListItem> groupBankLoans = [];
  List<NamesListItem> groupAssets = [];
  List<NamesListItem> groupMoneyMarketInvestments = [];
  List<NamesListItem> groupBorrowers = [];

  Future<void> _fetchDefaultValues(BuildContext context) async {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   showDialog<String>(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (BuildContext context) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       });
    // });
    // setState(() {
    groupMembers = widget.formLoadData.containsKey("memberOptions")
        ? widget.formLoadData['memberOptions']
        : [];
    groupExpenseCategories =
        widget.formLoadData.containsKey("expenseCategories")
            ? widget.formLoadData['expenseCategories']
            : [];
    groupAccounts = widget.formLoadData.containsKey("accountOptions")
        ? widget.formLoadData['accountOptions']
        : [];
    groupContributions = widget.formLoadData.containsKey("contributionOptions")
        ? widget.formLoadData['contributionOptions']
        : [];
    groupLoans = widget.formLoadData.containsKey("loanTypeOptions")
        ? widget.formLoadData['loanTypeOptions']
        : [];
    groupBankLoans = widget.formLoadData.containsKey("bankLoansOptions")
        ? widget.formLoadData['bankLoansOptions']
        : [];
    groupAssets = widget.formLoadData.containsKey("groupAssetOptions")
        ? widget.formLoadData['groupAssetOptions']
        : [];
    groupMoneyMarketInvestments =
        widget.formLoadData.containsKey("moneyMarketInvestmentOptions")
            ? widget.formLoadData['moneyMarketInvestmentOptions']
            : [];
    groupBorrowers = widget.formLoadData.containsKey("borrowerOptions")
        ? widget.formLoadData['borrowerOptions']
        : [];
    // });
    // Navigator.of(context, rootNavigator: true).pop();
  }

  String getAlertText() {
    String _resp = "";
    if (groupMembers.length == 0) _resp = "There are no group members found";
    if (withdrawalTypeId == 1 && groupExpenseCategories.length == 0)
      _resp = "The group does not have any expense categories";
    if (withdrawalTypeId == 2 && groupAssets.length == 0)
      _resp = "The group does not have any assets";
    if (withdrawalTypeId == 3 && groupLoans.length == 0)
      _resp = "The group does not have any loan type";
    if (withdrawalTypeId == 6 && groupMoneyMarketInvestments.length == 0)
      _resp = "The group does not have any money market investment";
    if (withdrawalTypeId == 7 && groupContributions.length == 0)
      _resp = "The group does not have any contribution";
    if (withdrawalTypeId == 8 && groupBankLoans.length == 0)
      _resp = "The group does not have any bank loan";
    if (withdrawalTypeId == 9 && groupAccounts.length == 0)
      _resp = "The group does not have any account";
    if (withdrawalTypeId == 10 && groupLoans.length == 0)
      _resp = "The group does not have any loan type";
    return _resp != "" ? _resp + ", you cannot continue." : "";
  }

  void addReconciledWithdrawal(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    widget.addReconciledWithdrawal({
      "stock_name": stockName,
      "money_market_investment_name": moneyMarketInvestmentName,
      "description": description,
      "amount": amount,
      "price_per_share": pricePerShare,
      "withdrawal_for_type": withdrawalTypeId,
      "expense_category_id": expenseCategoryId,
      "asset_id": assetId,
      "member_id": memberId,
      'member_name': memberName,
      "loan_id": loanId,
      "number_of_shares": numberOfShares,
      "money_market_investment_id": moneyMarketInvestmentId,
      "contribution_id": contribId,
      "bank_loan_id": bankLoanId,
      "account_id": recipientAccountId,
      "debtor_id": borrowerId
    });
    // pop out the dialog
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    _fetchDefaultValues(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      title: heading2(
        text: 'Reconcile withdrawal',
        textAlign: TextAlign.start,
        // ignore: deprecated_member_use

        color: Theme.of(context).textSelectionTheme.selectionHandleColor,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  withdrawalTypeId != null && getAlertText() != ""
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
                    enabled: true,
                    labelText: "Select withdrawal for",
                    listItems: withdrawalTypeOptions,
                    selectedItem: withdrawalTypeId,
                    onChanged: (value) {
                      setState(() {
                        withdrawalTypeId = value;
                      });
                    },
                    validator: (value) {
                      if (value == "" || value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // For expense
                  if (withdrawalTypeId == 1)
                    Column(
                      children: [
                        // Selecting expense category
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select expense category",
                            listItems: groupExpenseCategories,
                            selectedItem: expenseCategoryId,
                            onChanged: (value) {
                              setState(() {
                                expenseCategoryId = value;
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "This field is required";
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        // enter desciption
                        enterDescription(context, "Expense description"),
                        SizedBox(height: 10),
                        // Amount
                        enterAmount(context, "Amount"),
                        SizedBox(height: 10)
                      ],
                    ),

                  // For asset purchase payment

                  if (withdrawalTypeId == 2)
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
                        // enter asset purchase payment description
                        enterDescription(
                            context, "Asset purchase payment description"),
                        SizedBox(height: 10),
                        enterAmount(context, "Amount")
                      ],
                    ),

                  // For loan disbursement
                  if (withdrawalTypeId == 3)
                    Column(
                      children: [
                        // select member
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select member",
                            listItems: groupMembers,
                            selectedItem: memberId,
                            onChanged: (value) {
                              setState(() {
                                memberId = value;
                                memberName = groupMembers
                                    .firstWhere((member) => member.id == value)
                                    .name;
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
                            labelText: "Select loan type",
                            listItems: groupLoans,
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
                      ],
                    ),

                  // For stock purchase

                  if (withdrawalTypeId == 4)
                    Column(
                      children: [
                        simpleTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Stock name",
                          enabled: true,
                          onChanged: (value) {
                            setState(() {
                              stockName = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        amountTextInputField(
                            context: context,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "The field is required";
                              }
                              return null;
                            },
                            labelText: "Number of shares",
                            enabled: true,
                            onChanged: (value) {
                              setState(() {
                                numberOfShares = value != null
                                    ? int.parse(value)
                                    : amount = 0;
                              });
                            }),
                        SizedBox(height: 10),
                        enterAmount(context, "Amount"),
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
                                    ? double.tryParse(value)
                                    : amount = 0;
                              });
                            }),
                        SizedBox(height: 10),
                      ],
                    ),

                  // For money market invst
                  if (withdrawalTypeId == 5)
                    Column(
                      children: [
                        simpleTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Money market investment name",
                          enabled: true,
                          onChanged: (value) {
                            setState(() {
                              moneyMarketInvestmentName = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        enterDescription(
                            context, "Money market investment description"),
                        SizedBox(height: 10),
                        enterAmount(context, "Amount"),
                        SizedBox(height: 10),
                      ],
                    ),

                  // For money market invst top up
                  if (withdrawalTypeId == 6)
                    Column(
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
                        enterDescription(
                            context, "Money market top up description"),
                        SizedBox(height: 10),
                        enterAmount(context, "Amount"),
                        SizedBox(height: 10),
                      ],
                    ),

                  // For contribution refund
                  if (withdrawalTypeId == 7)
                    Column(
                      children: [
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select member",
                            listItems: groupMembers,
                            selectedItem: memberId,
                            onChanged: (value) {
                              setState(() {
                                memberId = value;
                                memberName = groupMembers
                                    .firstWhere((member) => member.id == value)
                                    .name;
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
                            labelText: "Select contribution",
                            listItems: groupContributions,
                            selectedItem: contribId,
                            onChanged: (value) {
                              setState(() {
                                contribId = value;
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "This field is required";
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        enterAmount(context, "Amount"),
                        SizedBox(height: 10),
                      ],
                    ),

                  // For bank loan repayment
                  if (withdrawalTypeId == 8)
                    Column(
                      children: [
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select bank loan",
                            listItems: groupBankLoans,
                            selectedItem: bankLoanId,
                            onChanged: (value) {
                              setState(() {
                                bankLoanId = value;
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "This field is required";
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        enterDescription(
                            context, "Bank loan repayment description"),
                        SizedBox(height: 10),
                        enterAmount(context, "Amount"),
                      ],
                    ),

                  // For funds transfer
                  if (withdrawalTypeId == 9)
                    Column(
                      children: [
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select recipient account",
                            listItems: widget.formLoadData
                                    .containsKey("accountOptions")
                                ? widget.formLoadData['accountOptions']
                                : [],
                            selectedItem: recipientAccountId,
                            onChanged: (value) {
                              setState(() {
                                recipientAccountId = value;
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "This field is required";
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        enterDescription(context, "Funds transfer description"),
                        SizedBox(height: 10),
                        enterAmount(context, "Amount"),
                        SizedBox(height: 10)
                      ],
                    ),

                  // For external lending

                  if (withdrawalTypeId == 10)
                    Column(
                      children: [
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
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select loan",
                            listItems: groupLoans,
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
                        enterAmount(context, "Amount"),
                        SizedBox(height: 10)
                      ],
                    ),

                  // For dividend

                  if (withdrawalTypeId == 11)
                    Column(
                      children: [
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select member",
                            listItems: groupMembers,
                            selectedItem: memberId,
                            onChanged: (value) {
                              setState(() {
                                memberId = value;
                                memberName = groupMembers
                                    .firstWhere((member) => member.id == value)
                                    .name;
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "This field is required";
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        enterDescription(context, "Dividend description"),
                        SizedBox(height: 10),
                        enterAmount(context, "Amount"),
                        SizedBox(height: 10)
                      ],
                    ),
                ],
              )),
        ),
      ),
      actions: [
        negativeActionDialogButton(
            text: "Cancel",
            // ignore: deprecated_member_use
            color: Theme.of(context).textSelectionTheme.selectionHandleColor,
            action: () {
              Navigator.of(context).pop();
            }),
        // ignore: deprecated_member_use
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
          ),
          child: customTitle(
              text: "Save changes",
              color: primaryColor,
              fontWeight: FontWeight.w600),
          onPressed: () => addReconciledWithdrawal(context),
        )
      ],
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
            amount = value != null ? double.tryParse(value) : 0;
          });
        });
  }
}
