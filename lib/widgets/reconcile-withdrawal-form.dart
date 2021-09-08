import 'package:chamasoft/providers/withdrawals.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ReconcileWithdrawalForm extends StatefulWidget {
  const ReconcileWithdrawalForm({Key key}) : super(key: key);

  @override
  _ReconcileWithdrawalFormState createState() =>
      _ReconcileWithdrawalFormState();
}

class _ReconcileWithdrawalFormState extends State<ReconcileWithdrawalForm> {
  final _formKey = new GlobalKey<FormState>();

  // form values
  String expenseDesc,
      assetPurchasePaymentDesc,
      stockName,
      moneyMktInvstName,
      moneyMktInvstDesc,
      moneyMktTopupDesc,
      bankLoanRepaymentDesc,
      fundsTransferDesc,
      dividendDesc;

  double amount, pricePerShare;

  int withdrawalTypeId,
      expenseCategoryId,
      assetId,
      memberId,
      loanId,
      numberOfShares,
      moneyMktInvstId,
      contribId,
      bankLoanId,
      recipientAccountId,
      borrowerId;

  void addReconciledWithdrawal(formData, addData) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    // send data to provider.
    addData(formData);
    // pop out the dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final withdrawalProv = Provider.of<Withdrawals>(context, listen: false);

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
                    listItems: withdrawalProv.withdrawalOptions,
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
                            listItems: withdrawalProv.expenseCategoryOptions,
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
                        simpleTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Expense description",
                          enabled: true,
                          onChanged: (value) {
                            setState(() {
                              expenseDesc = value;
                            });
                          },
                        ),
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
                            listItems: withdrawalProv.assetOptions,
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
                        simpleTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Asset purchase payment description",
                          enabled: true,
                          onChanged: (value) {
                            setState(() {
                              assetPurchasePaymentDesc = value;
                            });
                          },
                        ),
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
                            listItems: withdrawalProv.memberOptions,
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
                            listItems: withdrawalProv.loanOptions,
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
                              moneyMktInvstName = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        simpleTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Money market investment description",
                          enabled: true,
                          onChanged: (value) {
                            setState(() {
                              moneyMktInvstDesc = value;
                            });
                          },
                        ),
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
                            listItems:
                                withdrawalProv.moneyMarketInvestmentOptions,
                            selectedItem: moneyMktInvstId,
                            onChanged: (value) {
                              setState(() {
                                moneyMktInvstId = value;
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "This field is required";
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        simpleTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Money market top up description",
                          enabled: true,
                          onChanged: (value) {
                            setState(() {
                              moneyMktTopupDesc = value;
                            });
                          },
                        ),
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
                            listItems: withdrawalProv.memberOptions,
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
                            listItems: withdrawalProv.contributionOptions,
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
                            listItems: withdrawalProv.bankLoanOptions,
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
                        simpleTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Bank loan repayment description",
                          enabled: true,
                          onChanged: (value) {
                            setState(() {
                              bankLoanRepaymentDesc = value;
                            });
                          },
                        ),
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
                            listItems: withdrawalProv.accountOptions,
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
                        simpleTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Funds transfer description",
                          enabled: true,
                          onChanged: (value) {
                            setState(() {
                              fundsTransferDesc = value;
                            });
                          },
                        ),
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
                            listItems: withdrawalProv.borrowerOptions,
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
                            listItems: withdrawalProv.loanOptions,
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
                            listItems: withdrawalProv.memberOptions,
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
                        simpleTextInputField(
                          context: context,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: "Dividend description",
                          enabled: true,
                          onChanged: (value) {
                            setState(() {
                              dividendDesc = value;
                            });
                          },
                        ),
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
          onPressed: () => addReconciledWithdrawal(
              ReconciledWithdrawal(
                  amount: amount,
                  assetId: assetId,
                  assetPurchasePaymentDesc: assetPurchasePaymentDesc,
                  bankLoanId: bankLoanId,
                  bankLoanRepaymentDesc: bankLoanRepaymentDesc,
                  borrowerId: borrowerId,
                  contribId: contribId,
                  dividendDesc: dividendDesc,
                  expenseCategoryId: expenseCategoryId,
                  expenseDesc: expenseDesc,
                  fundsTransferDesc: fundsTransferDesc,
                  loanId: loanId,
                  memberId: memberId,
                  moneyMktInvstDesc: moneyMktInvstDesc,
                  moneyMktInvstId: moneyMktInvstId,
                  moneyMktInvstName: moneyMktInvstName,
                  moneyMktTopupDesc: moneyMktInvstDesc,
                  numberOfShares: numberOfShares,
                  pricePerShare: pricePerShare,
                  recipientAccountId: recipientAccountId,
                  stockName: stockName,
                  withdrawalTypeId: withdrawalTypeId),
              withdrawalProv.addReconciledWithdrawal),
        )
      ],
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
