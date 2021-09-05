import 'package:chamasoft/providers/deposit-reconciliation.dart';
import 'package:chamasoft/providers/deposits.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ReconcileDepositForm extends StatefulWidget {
  final String id;

  ReconcileDepositForm(this.id, {Key key}) : super(key: key);

  @override
  _ReconcileDepositFormState createState() => _ReconcileDepositFormState();
}

class _ReconcileDepositFormState extends State<ReconcileDepositForm> {
  final _formKey = new GlobalKey<FormState>();

  // form values
  String paymentDescription,
      bankLoanDescription,
      transferDescription,
      action = "add";

  double amount,
      amountPayable,
      amountDisbursed,
      transferredAmount,
      pricePerShare;

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
      moneyMarketInvstId,
      borrowerId,
      numberOfSharesSold;

  void handleAddFormField(formData, id, addFormField) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    // send data to provider.
    addFormField(formData, id);
    // change the action to delete
    setState(() {
      action = "delete";
    });
  }

  void handleRemoveFormField(id, removeFormField) {
    // send data to provider
    removeFormField(id);
  }

  @override
  Widget build(BuildContext context) {
    final depositDefaults = Provider.of<Deposits>(context, listen: false);
    final depositReconciliation =
        Provider.of<DepositReconciliation>(context, listen: true);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomDropDownButton(
            enabled: true,
            labelText: "Select deposit for",
            listItems: depositDefaults.depositTypes,
            selectedItem: depositTypeId,
            onChanged: (value) {
              setState(() {
                depositTypeId = value;
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

          // For contribution payment
          if (depositTypeId == 1)
            Column(
              children: [
                // Selecting member
                selectMember(depositDefaults.members, "Select Member"),
                SizedBox(height: 10),
                // Selecting contribution
                CustomDropDownButton(
                    enabled: true,
                    labelText: "Select contribution",
                    listItems: depositDefaults.contributions,
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
                selectMember(depositDefaults.members, "Select Member"),
                SizedBox(height: 10),
                // Selecting fine category
                CustomDropDownButton(
                    enabled: true,
                    labelText: "Select fine category",
                    listItems: depositDefaults.fineCategories,
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
                selectMember(depositDefaults.members, "Select Member"),
                SizedBox(height: 10),
                // Entering payment description
                simpleTextInputField(
                  context: context,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Field is required";
                    }
                    return null;
                  },
                  labelText: "Payment description",
                  enabled: true,
                  onChanged: (value) {
                    setState(() {
                      paymentDescription = value;
                    });
                  },
                ),
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
                    listItems: depositDefaults.depositors,
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
                    listItems: depositDefaults.incomeCategories,
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
                selectMember(depositDefaults.members, "Select member"),
                SizedBox(height: 10),
                // select loan
                CustomDropDownButton(
                    enabled: true,
                    labelText: "Select Loan",
                    listItems: depositDefaults.loans,
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
                simpleTextInputField(
                  context: context,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Field is required";
                    }
                    return null;
                  },
                  labelText: "Bank loan description",
                  enabled: true,
                  onChanged: (value) {
                    setState(() {
                      bankLoanDescription = value;
                    });
                  },
                ),
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
                        amountPayable = value;
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
                      amountDisbursed = value;
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
                    listItems: depositDefaults.accounts,
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
                simpleTextInputField(
                  context: context,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Field is required";
                    }
                    return null;
                  },
                  labelText: "Money transfer description",
                  enabled: true,
                  onChanged: (value) {
                    setState(() {
                      transferDescription = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                // enter amount transferred
                amountTextInputField(
                    context: context,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "The field is required";
                      }
                      return null;
                    },
                    labelText: "Amount transferred",
                    enabled: true,
                    onChanged: (value) {
                      setState(() {
                        transferredAmount = value;
                      });
                    }),
                SizedBox(height: 10)
              ],
            ),

          // For stock sale
          if (depositTypeId == 8)
            Column(
                // Select stock
                children: [
                  CustomDropDownButton(
                      enabled: true,
                      labelText: "Select stock",
                      listItems: depositDefaults.stocks,
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
                          pricePerShare = value;
                        });
                      }),
                  SizedBox(height: 10),
                  enterNumber(
                      context, "Number of shares sold", numberOfSharesSold),
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
                    listItems: depositDefaults.assets,
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
                      listItems: depositDefaults.moneyMarketInvestments,
                      selectedItem: moneyMarketInvstId,
                      onChanged: (value) {
                        setState(() {
                          moneyMarketInvstId = value;
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
                selectMember(depositDefaults.members, "Select member"),
                SizedBox(height: 10),
                // select loan
                CustomDropDownButton(
                    enabled: true,
                    labelText: "Select loan",
                    listItems: depositDefaults.loans,
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
                    listItems: depositDefaults.borrowers,
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
                    listItems: depositDefaults.loans,
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

          action == "add"
              ? IconButton(
                  //context: context,
                  icon: Icon(
                    Icons.add,
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () => handleAddFormField({
                        "paymentDescription": paymentDescription,
                        "bankLoanDescription": bankLoanDescription,
                        "transferDescription": transferDescription,
                        "amount": amount,
                        "amountPayable": amountPayable,
                        "amountDisbursed": amountDisbursed,
                        "transferredAmount": transferredAmount,
                        "pricePerShare": pricePerShare,
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
                        "moneyMarketInvstId": moneyMarketInvstId,
                        "borrowerId": borrowerId,
                        "numberOfSharesSold": numberOfSharesSold
                      }, widget.id, depositReconciliation.addFormFields))
              : IconButton(
                  onPressed: () => handleRemoveFormField(
                      widget.id, depositReconciliation.removeFormFields),
                  icon: Icon(Icons.delete))
        ],
      ),
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
            field = value;
          });
        });
  }
}
