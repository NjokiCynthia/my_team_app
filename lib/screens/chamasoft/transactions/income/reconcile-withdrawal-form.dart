import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/helpers/setting_helper.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/reconcile-withdrawal-form.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ReconcileWithdrawal extends StatefulWidget {
  const ReconcileWithdrawal({Key key}) : super(key: key);

  @override
  _ReconcileWithdrawalState createState() => _ReconcileWithdrawalState();
}

class _ReconcileWithdrawalState extends State<ReconcileWithdrawal> {
  double _appBBarElevation = 0;
  ScrollController _scrollController;
  List<Member> _members = [];
  bool _isInit = true;
  bool _isLoading = true;
  List _withdrawalTypes = [];
  List _descriptions = [];
  List _stockNames = [];
  List _moneyMarketInvestmentNames = [];
  List _amounts = [];
  List _pricesPerShare = [];
  List _expenseCategoryIds = [];
  List _assetIds = [];
  List _memberIds = [];
  List _loanIds = [];
  List _numberOfShares = [];
  List _moneyMarketInvestmentIds = [];
  List _contributionIds = [];
  List _bankLoanIds = [];
  List _recipientAccountIds = [];
  List _borrowerIds = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBBarElevation : 0;
    if (_appBBarElevation != newElevation) {
      setState(() {
        _appBBarElevation = newElevation;
      });
    }
  }

  void addReconciledWithdrawal(formData) {
    setState(() {
      _withdrawalTypes.add(formData['withdrawalTypeId']);
      _descriptions.add(formData['description']);
      _stockNames.add(formData['stockName']);
      _moneyMarketInvestmentNames.add(formData['moneyMarketInvestmentName']);
      _amounts.add(formData['amount']);
      _pricesPerShare.add(formData['pricePerShare']);
      _expenseCategoryIds.add(formData['expenseCategoryId']);
      _assetIds.add(formData['assetId']);
      _memberIds.add(formData['memberId']);
      _loanIds.add(formData['loanId']);
      _numberOfShares.add(formData['numberOfShares']);
      _moneyMarketInvestmentIds.add(formData['moneyMarketInvestmentId']);
      _contributionIds.add(formData['contributionId']);
      _bankLoanIds.add(formData['bankLoanId']);
      _recipientAccountIds.add(formData['recipientAccountId']);
      _borrowerIds.add(formData['borrowerId']);
    });
  }

  void _newReconcileWithdrawalDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ReconcileWithdrawalForm(addReconciledWithdrawal));
  }

  void _submit(BuildContext context, UnreconciledWithdrawal withdrawal) async {
    double total = totalReconciled;
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    if (withdrawal.amount == total) {
      // Structure payload
      var payload = json.encode({
        "withdrawalTypes": _withdrawalTypes,
        "descriptions": _descriptions,
        "stockNames": _stockNames,
        "moneyMarketInvestmentNames": _moneyMarketInvestmentNames,
        "amounts": _amounts,
        "pricesPerShare": _pricesPerShare,
        "expenseCategoryIds": _expenseCategoryIds,
        "assetIds": _assetIds,
        "memberIds": _memberIds,
        "loanIds": _loanIds,
        "numberOfShares": _numberOfShares,
        "moneyMarketInvestmentIds": _moneyMarketInvestmentIds,
        "contributionIds": _contributionIds,
        "bankLoanIds": _bankLoanIds,
        "recipientAccountIds": _recipientAccountIds,
        "borrowerIds": _borrowerIds
      });

      print(payload);
      // Send request to server

      print("To be done");
    } else {
      alertDialog(context,
          "You have reconciled ${groupObject.groupCurrency} $total out of ${groupObject.groupCurrency} ${withdrawal.amount} transacted.");
    }
  }

  void removeReconciledWithdrawal(index) {
    setState(() {
      _withdrawalTypes.removeAt(index);
      _descriptions.removeAt(index);
      _stockNames.removeAt(index);
      _moneyMarketInvestmentNames.removeAt(index);
      _amounts.removeAt(index);
      _pricesPerShare.removeAt(index);
      _expenseCategoryIds.removeAt(index);
      _assetIds.removeAt(index);
      _memberIds.removeAt(index);
      _loanIds.removeAt(index);
      _numberOfShares.removeAt(index);
      _moneyMarketInvestmentIds.removeAt(index);
      _contributionIds.removeAt(index);
      _bankLoanIds.removeAt(index);
      _recipientAccountIds.removeAt(index);
      _borrowerIds.removeAt(index);
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
    final UnreconciledWithdrawal withdrawal =
        ModalRoute.of(context).settings.arguments;

    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          title: "Reconcile withdrawal",
          action: () {
            // back to the previous screen
            Navigator.of(context).pop();
          },
          leadingIcon: LineAwesomeIcons.close,
          elevation: _appBBarElevation,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () => _newReconcileWithdrawalDialog(),
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
            _submit(context, withdrawal);
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
                    title: withdrawal.particulars,
                    date: "Date of transaction: ${withdrawal.transactionDate}",
                    message:
                        "Amount to be reconciled: ${groupObject.groupCurrency} ${currencyFormat.format(withdrawal.amount)}",
                    context: context,
                  ),
                  Container(
                    padding: inputPagePadding,
                    height: MediaQuery.of(context).size.height * 0.64,
                    child: ListView.builder(
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: _memberIds[index] != null
                              ? Text(
                                  "${getWithdrawalType(_withdrawalTypes[index])} - ${getMember(_memberIds[index])}")
                              : Text(
                                  "${getWithdrawalType(_withdrawalTypes[index])}"),
                          subtitle: _amounts[index] != null
                              ? Text(
                                  "${groupObject.groupCurrency} ${currencyFormat.format(_amounts[index])}")
                              : null,
                          trailing: IconButton(
                            onPressed: () => removeReconciledWithdrawal(index),
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                          ),
                        );
                      },
                      itemCount: _withdrawalTypes.length,
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
                            "${groupObject.groupCurrency} ${currencyFormat.format(totalReconciled)} "),
                      ))
                ],
              ),
            ),
          );
        }));
  }
}
