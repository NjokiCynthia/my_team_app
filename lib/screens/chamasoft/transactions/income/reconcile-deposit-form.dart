import 'dart:convert';

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/helpers/setting_helper.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:chamasoft/widgets/reconcile-deposit-form.dart';

class ReconcileDeposit extends StatefulWidget {
  const ReconcileDeposit({Key key}) : super(key: key);

  @override
  _ReconcileDepositState createState() => _ReconcileDepositState();
}

class _ReconcileDepositState extends State<ReconcileDeposit>
    with ChangeNotifier {
  double _appBBarElevation = 0;
  ScrollController _scrollController;
  List<Member> _members = [];
  bool _isInit = true;
  bool _isLoading = true;
  List _depositTypes = [];
  List _descriptions = [];
  List _amounts = [];
  List _amountPayables = [];
  List _amountDisbursed = [];
  List _memberIds = [];
  List _contributionIds = [];
  List _fineCategoryIds = [];
  List _depositorIds = [];
  List _incomeCategoryIds = [];
  List _loanIds = [];
  List _accountIds = [];
  List _stockIds = [];
  List _moneyMarketInvestmentIds = [];
  List _borrowerIds = [];
  List _numberOfSharesSold = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBBarElevation : 0;
    if (_appBBarElevation != newElevation) {
      setState(() {
        _appBBarElevation = newElevation;
      });
    }
  }

  void addReconciledDeposit(formData) {
    setState(() {
      _depositTypes.add(formData['depositTypeId']);
      _descriptions.add(formData['description']);
      _amounts.add(formData['amount']);
      _amountPayables.add(formData['amountPayable']);
      _amountDisbursed.add(formData['amountDisbursed']);
      _memberIds.add(formData['memberId']);
      _contributionIds.add(formData['contributionId']);
      _fineCategoryIds.add(formData['fineCategoryId']);
      _depositorIds.add(formData['depositorId']);
      _incomeCategoryIds.add(formData['incomeCategoryId']);
      _loanIds.add(formData['loanId']);
      _accountIds.add(formData['accountId']);
      _stockIds.add(formData['stockId']);
      _moneyMarketInvestmentIds.add(formData['moneyMarketInvestmentId']);
      _borrowerIds.add(formData['borrowerId']);
      _numberOfSharesSold.add(formData['numberOfSharesSold']);
    });
  }

  void _newReconcileDepositDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ReconcileDepositForm(addReconciledDeposit));
  }

  void _submit(BuildContext context, UnreconciledDeposit deposit) async {
    // get the amount entered.
    double total = totalReconciled;
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    if (total == deposit.amount) {
      // Setting up the payload
      var payload = json.encode({
        "depositTypes": _depositTypes,
        "descriptions": _descriptions,
        "amounts": _amounts,
        "amountPayables": _amountPayables,
        "amountDisbursed": _amountDisbursed,
        "memberIds": _memberIds,
        "contributionIds": _contributionIds,
        "fineCategoryIds": _fineCategoryIds,
        "depositorIds": _depositorIds,
        "incomeCategoryIds": _incomeCategoryIds,
        "loanIds": _loanIds,
        "accountIds": _accountIds,
        "stockIds": _stockIds,
        "moneyMarketInvestmentIds": _moneyMarketInvestmentIds,
        "borrowerIds": _borrowerIds,
        "numberOfSharesSold": _numberOfSharesSold
      });

      print(payload);

      // Sending request to server.

      print("To be worked on!!");
    } else {
      alertDialog(context,
          "You have reconciled ${groupObject.groupCurrency} $total out of ${groupObject.groupCurrency} ${deposit.amount} transacted.");
    }
  }

  void reset(context) {
    Navigator.of(context).pop();
  }

  void removeReconciledDeposit(index) {
    setState(() {
      _depositTypes.removeAt(index);
      _descriptions.removeAt(index);
      _amounts.removeAt(index);
      _amountPayables.removeAt(index);
      _amountDisbursed.removeAt(index);
      _memberIds.removeAt(index);
      _contributionIds.removeAt(index);
      _fineCategoryIds.removeAt(index);
      _depositorIds.removeAt(index);
      _incomeCategoryIds.removeAt(index);
      _loanIds.removeAt(index);
      _accountIds.removeAt(index);
      _stockIds.removeAt(index);
      _moneyMarketInvestmentIds.removeAt(index);
      _borrowerIds.removeAt(index);
      _numberOfSharesSold.removeAt(index);
    });
  }

  double get totalReconciled {
    double total = 0.0;

    if (_amounts.length > 0) {
      for (var amount in _amounts) {
        if (amount != null) {
          total += amount;
        }
      }
    }

    if (_amountPayables.length > 0) {
      for (var amountPayable in _amountPayables) {
        if (amountPayable != null) {
          total += amountPayable;
        }
      }
    }

    if (_amountDisbursed.length > 0) {
      for (var amountDisbursed in _amountDisbursed) {
        if (amountDisbursed != null) {
          total += amountDisbursed;
        }
      }
    }

    return total;
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

  @override
  void didChangeDependencies() {
    // get the unreconciled deposits
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  Future<void> _fetchMembers(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchMembers();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchMembers(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    _members = Provider.of<Groups>(context, listen: false).members;
    _fetchMembers(context).then((_) {
      _members = Provider.of<Groups>(context, listen: false).members;
      setState(() {
        _isLoading = false;
      });
    });
    _isInit = false;
    return true;
  }

  String getMember(memberId) {
    return _members
        .firstWhere((member) => member.id == "$memberId", orElse: null)
        .name;
  }

  @override
  Widget build(BuildContext context) {
    final UnreconciledDeposit deposit =
        ModalRoute.of(context).settings.arguments;

    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          title: "Reconcile deposit",
          action: () => reset(context),
          leadingIcon: LineAwesomeIcons.close,
          elevation: _appBBarElevation,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () => _newReconcileDepositDialog(),
                icon: Icon(
                  Icons.add,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _submit(context, deposit);
          },
          child: Icon(Icons.check),
          backgroundColor: Theme.of(context).accentColor,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _isLoading
                      ? showLinearProgressIndicator()
                      : SizedBox(
                          height: 0.0,
                        ),
                  transactionToolTip(
                    title: deposit.particulars,
                    date: "Date of transaction: ${deposit.transactionDate}",
                    message:
                        "Amount to be reconciled: ${groupObject.groupCurrency}  ${currencyFormat.format(deposit.amount)}",
                    context: context,
                  ),
                  Container(
                    padding: inputPagePadding,
                    height: MediaQuery.of(context).size.height * 0.64,
                    child: ListView.builder(
                      itemBuilder: (_, index) {
                        // Will continue from here

                        return ListTile(
                          title: _memberIds[index] != null
                              ? Text(
                                  "${getDepositType(_depositTypes[index])} - ${getMember(_memberIds[index])}")
                              : _depositorIds[index] != null
                                  ? Text(
                                      "${getDepositType(_depositTypes[index])} - ${_depositorIds[index]}")
                                  : _borrowerIds[index] != null
                                      ? Text(
                                          "${getDepositType(_depositTypes[index])} - ${_borrowerIds[index]}")
                                      : Text(
                                          "${getDepositType(_depositTypes[index])}"),
                          subtitle: _amounts[index] != null
                              ? Text(
                                  "${groupObject.groupCurrency} ${currencyFormat.format(_amounts[index])}")
                              : _amountDisbursed[index] != null
                                  ? Text(
                                      "${groupObject.groupCurrency} ${currencyFormat.format(_amountDisbursed[index])}")
                                  : null,
                          trailing: IconButton(
                            onPressed: () => removeReconciledDeposit(index),
                            icon: Icon(Icons.close),
                            color: Theme.of(context).errorColor,
                          ),
                        );
                      },
                      itemCount: _depositTypes.length,
                    ),
                  ),
                  Container(
                      padding: inputPagePadding,
                      child: ListTile(
                        title: Text(
                          'Total amount reconciled',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            "${groupObject.groupCurrency} ${currencyFormat.format(totalReconciled)}"),
                      ))
                ],
              ),
            ),
          );
        }));
  }
}
