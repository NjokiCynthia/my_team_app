import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/helpers/setting_helper.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ReconcileWithdrawalForm extends StatefulWidget {
  final Function addReconciledWithdrawal;
  const ReconcileWithdrawalForm(this.addReconciledWithdrawal, {Key key})
      : super(key: key);

  @override
  _ReconcileWithdrawalFormState createState() =>
      _ReconcileWithdrawalFormState();
}

class _ReconcileWithdrawalFormState extends State<ReconcileWithdrawalForm> {
  final _formKey = new GlobalKey<FormState>();
  bool _isInit = true;
  Map<String, dynamic> formLoadData = {};
  //bool _isFormInputEnabled = true;

  // form values
  String stockName, description, moneyMarketInvestmentName;

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
        .loadInitialFormData(
            contr: true,
            acc: true,
            exp: true,
            member: true,
            loanTypes: true,
            bankLoans: true);
    setState(() {
      _isInit = false;
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  void addReconciledWithdrawal(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    widget.addReconciledWithdrawal({
      "stockName": stockName,
      "moneyMarketInvestmentName": moneyMarketInvestmentName,
      "description": description,
      "amount": amount,
      "pricePerShare": pricePerShare,
      "withdrawalTypeId": withdrawalTypeId,
      "expenseCategoryId": expenseCategoryId,
      "assetId": assetId,
      "memberId": memberId,
      "loanId": loanId,
      "numberOfShares": numberOfShares,
      "moneyMarketInvestmentId": moneyMarketInvestmentId,
      "contributionId": contribId,
      "bankLoanId": bankLoanId,
      "recipientAccountId": recipientAccountId,
      "borrowerId": borrowerId
    });
    // pop out the dialog
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchDefaultValues(context);
    }
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
          color: Theme.of(context).textSelectionHandleColor),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                            listItems:
                                formLoadData.containsKey("expenseCategories")
                                    ? formLoadData['expenseCategories']
                                    : [],
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
                            listItems: [],
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
                            listItems: formLoadData.containsKey("memberOptions")
                                ? formLoadData['memberOptions']
                                : [],
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
                            }),
                        SizedBox(height: 10),
                        // select loan
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select loan",
                            listItems:
                                formLoadData.containsKey("loanTypeOptions")
                                    ? formLoadData['loanTypeOptions']
                                    : [],
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
                                    ? double.parse(value)
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
                            listItems: [],
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
                            listItems: formLoadData.containsKey("memberOptions")
                                ? formLoadData['memberOptions']
                                : [],
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
                            }),
                        SizedBox(height: 10),
                        CustomDropDownButton(
                            enabled: true,
                            labelText: "Select contribution",
                            listItems: formLoadData.containsKey("contrOptions")
                                ? formLoadData['contrOptions']
                                : [],
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
                            listItems:
                                formLoadData.containsKey("bankLoansOptions")
                                    ? formLoadData['bankLoansOptions']
                                    : [],
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
                            listItems:
                                formLoadData.containsKey("accountOptions")
                                    ? formLoadData['accountOptions']
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
                            listItems: [],
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
                            listItems:
                                formLoadData.containsKey("loanTypeOptions")
                                    ? formLoadData['loanTypeOptions']
                                    : [],
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
                            listItems: formLoadData.containsKey("memberOptions")
                                ? formLoadData['memberOptions']
                                : [],
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
            color: Theme.of(context).textSelectionHandleColor,
            action: () {
              Navigator.of(context).pop();
            }),
        // ignore: deprecated_member_use
        FlatButton(
          padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
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
            amount = value != null ? double.parse(value) : amount = 0;
          });
        });
  }
}
