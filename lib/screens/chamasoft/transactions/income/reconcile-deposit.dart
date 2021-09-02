import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:chamasoft/providers/deposits.dart';

class ReconcileDeposit extends StatefulWidget {
  const ReconcileDeposit({Key key}) : super(key: key);

  @override
  _ReconcileDepositState createState() => _ReconcileDepositState();
}

class _ReconcileDepositState extends State<ReconcileDeposit>
    with ChangeNotifier {
  double _appBBarElevation = 0;
  ScrollController _scrollController;
  final _formKey = new GlobalKey<FormState>();

  // form values
  String depositType,
      member,
      contributionType,
      fineCategory,
      paymentDescription,
      depositor,
      incomeCategory,
      loan,
      bankLoanDescription,
      account,
      transferDescription,
      stock,
      asset,
      moneyMarketInvestment,
      borrower;

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

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBBarElevation : 0;
    if (_appBBarElevation != newElevation) {
      setState(() {
        _appBBarElevation = newElevation;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, String depositId, depositDefaults) async {
    // Check the fields
    if (!_formKey.currentState.validate()) {
      return;
    }
    // reconcile the deposit.
    depositDefaults.reconcileDeposit(depositId);
    // back to the reconciled deposits
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final depositDefaults = Provider.of<Deposits>(context);
    final depositId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
        appBar: secondaryPageAppbar(
            context: context,
            title: "Reconcile deposit",
            action: () => Navigator.of(context).pop(),
            leadingIcon: LineAwesomeIcons.arrow_left,
            elevation: _appBBarElevation),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  toolTip(
                      title: "Manually reconcile a deposit",
                      message: "",
                      context: context,
                      showTitle: true),
                  Padding(
                    padding: inputPagePadding,
                    child: Form(
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
                                  selectField(depositDefaults.members,
                                      "Select Member", memberId),
                                  SizedBox(height: 10),
                                  // Selecting contribution
                                  selectField(depositDefaults.contributions,
                                      "Select contribution", contributionId),
                                  SizedBox(height: 10),
                                  // Amount
                                  enterAmount(context, "Amount", amount),
                                  SizedBox(height: 10)
                                ],
                              ),

                            // For fine payment
                            if (depositTypeId == 2)
                              Column(
                                children: [
                                  // Selecting member
                                  selectField(depositDefaults.members,
                                      "Select Member", memberId),
                                  SizedBox(height: 10),
                                  // Selecting fine category
                                  selectField(depositDefaults.fineCategories,
                                      "Select fine category", fineCategoryId),
                                  // Enter amount
                                  enterAmount(context, "Amount", amount),
                                  SizedBox(height: 10),
                                ],
                              ),

                            // For miscellaneous payment
                            if (depositTypeId == 3)
                              Column(
                                children: [
                                  // Selecting member
                                  selectField(depositDefaults.members,
                                      "Select Member", memberId),
                                  SizedBox(height: 10),
                                  // Entering payment description
                                  enterDesc(context, "Payment description",
                                      paymentDescription),
                                  SizedBox(height: 10),
                                  // Enter amount
                                  enterAmount(context, "Amount", amount),
                                  SizedBox(height: 10)
                                ],
                              ),

                            // For income
                            if (depositTypeId == 4)
                              Column(
                                children: [
                                  // select depositor
                                  selectField(depositDefaults.depositors,
                                      "Select depositor", depositorId),
                                  SizedBox(height: 10),
                                  // select income category
                                  selectField(
                                      depositDefaults.incomeCategories,
                                      "Select income category",
                                      incomeCategoryId),
                                  SizedBox(height: 10),
                                  // enter amount
                                  enterAmount(context, "Amount", amount),
                                  SizedBox(height: 10),
                                ],
                              ),

                            // For loan repayment
                            if (depositTypeId == 5)
                              Column(
                                children: [
                                  // select member
                                  selectField(depositDefaults.members,
                                      "Select member", memberId),
                                  SizedBox(height: 10),
                                  // select loan
                                  selectField(depositDefaults.loans,
                                      "Select Loan", loanId),
                                  SizedBox(height: 10),
                                  // enter amount
                                  enterAmount(context, "Amount", amount),
                                  SizedBox(height: 10)
                                ],
                              ),

                            // For bank loan disbursement
                            if (depositTypeId == 6)
                              Column(
                                children: [
                                  // Bank loan description
                                  enterDesc(context, "Bank loan description",
                                      bankLoanDescription),
                                  SizedBox(height: 10),
                                  // enter amount payable
                                  enterAmount(
                                      context, "Amount payable", amountPayable),
                                  SizedBox(height: 10),
                                  // enter amount disbursed
                                  enterAmount(context, "Amount disbursed",
                                      amountDisbursed),
                                  SizedBox(height: 10)
                                ],
                              ),

                            // For funds transfer
                            if (depositTypeId == 7)
                              Column(
                                children: [
                                  // Select from account
                                  selectField(depositDefaults.accounts,
                                      "Select from account", accountId),
                                  SizedBox(height: 10),
                                  // enter money transfer description
                                  enterDesc(
                                      context,
                                      "Money transfer description",
                                      transferDescription),
                                  SizedBox(height: 10),
                                  // enter amount transferred
                                  enterAmount(context, "Amount transferred",
                                      transferredAmount),
                                  SizedBox(height: 10)
                                ],
                              ),

                            // For stock sale
                            if (depositTypeId == 8)
                              Column(
                                  // Select stock
                                  children: [
                                    selectField(depositDefaults.stocks,
                                        "Select stock", stockId),
                                    SizedBox(height: 10),
                                    enterAmount(context, "Price per share",
                                        pricePerShare),
                                    SizedBox(height: 10),
                                    enterNumber(
                                        context,
                                        "Number of shares sold",
                                        numberOfSharesSold),
                                    SizedBox(height: 10),
                                    enterAmount(context, "Amount", amount),
                                    SizedBox(height: 10)
                                  ]),

                            // For asset sale
                            if (depositTypeId == 9)
                              Column(
                                children: [
                                  // select asset
                                  selectField(depositDefaults.assets,
                                      "Select asset", assetId),
                                  SizedBox(height: 10),
                                  // enter amount
                                  enterAmount(context, "Amount", amount),
                                  SizedBox(height: 10)
                                ],
                              ),

                            // For money market cash in
                            if (depositTypeId == 10)
                              Column(
                                  // select money market investment
                                  children: [
                                    // select money market investment
                                    selectField(
                                        depositDefaults.moneyMarketInvestments,
                                        "Select money market investment",
                                        moneyMarketInvstId),
                                    SizedBox(height: 10),
                                    // enter amount
                                    enterAmount(context, "Amount", amount),
                                    SizedBox(height: 10)
                                  ]),

                            // Loan processing income
                            if (depositTypeId == 11)
                              Column(
                                children: [
                                  // select member
                                  selectField(depositDefaults.members,
                                      "Select member", memberId),
                                  SizedBox(height: 10),
                                  // select loan
                                  selectField(depositDefaults.loans,
                                      "Select loan", loanId),
                                  SizedBox(height: 10),
                                  // enter amount
                                  enterAmount(context, "Amount", amount),
                                  SizedBox(height: 10)
                                ],
                              ),

                            // External loan repayment
                            if (depositTypeId == 12)
                              Column(
                                children: [
                                  // select borrower
                                  selectField(depositDefaults.borrowers,
                                      "Select borrower", borrowerId),
                                  SizedBox(height: 10),
                                  // select loan
                                  selectField(depositDefaults.loans,
                                      "Select loans", loanId),
                                  SizedBox(height: 10),
                                  // enter amount
                                  enterAmount(context, "Amount", amount),
                                  SizedBox(height: 10)
                                ],
                              ),

                            defaultButton(
                                context: context,
                                text: "Save",
                                onPressed: () {
                                  _submit(context, depositId, depositDefaults);
                                })
                            //defaultButton(context:context,text:"Save", onPressed:(){ _submit(context)})
                          ],
                        )),
                  )
                ],
              ),
            ),
          );
        }));
  }

  CustomDropDownButton selectField(
      List<NamesListItem> listItems, String label, int fieldValue) {
    return CustomDropDownButton(
      enabled: true,
      labelText: label,
      listItems: listItems,
      selectedItem: fieldValue,
      onChanged: (value) {
        setState(() {
          fieldValue = value;
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

  Widget enterDesc(BuildContext context, String label, String fieldValue) {
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
          fieldValue = value;
        });
      },
    );
  }

  Widget enterAmount(BuildContext context, String label, double field) {
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
