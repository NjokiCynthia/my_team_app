import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/setting_helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/reconcile-deposit-list.dart';
import 'package:chamasoft/widgets/appbars.dart';
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
  List _reconciledDeposits = [];
  BuildContext _bodyContext;

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
      _reconciledDeposits.add(formData);
    });
  }

  void _newReconcileDepositDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ReconcileDepositForm(addReconciledDeposit));
  }

  void _submit(UnreconciledDeposit deposit) async {
    // get the amount entered.
    double total = totalReconciled;
    final Group groupObject =
        Provider.of<Groups>(_bodyContext, listen: false).getCurrentGroup();
    if (total == deposit.amount) {
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
        await Provider.of<Groups>(_bodyContext, listen: false)
            .reconcileDepositTransactionAlert(
                _reconciledDeposits, deposit.transactionAlertId);
        StatusHandler().showSuccessSnackBar(_bodyContext, "Some message here");
      } on CustomException catch (error) {
        StatusHandler().handleStatus(
            context: context,
            error: error,
            callback: () {
              _submit(deposit);
            });
      } finally {
        Future.delayed(const Duration(milliseconds: 2500), () {
          Navigator.of(_bodyContext).pushReplacement(
              MaterialPageRoute(builder: (_) => ReconcileDepositList()));
        });
      }
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
      _reconciledDeposits.removeAt(index);
    });
  }

  double get totalReconciled {
    double total = 0.0;

    if (_reconciledDeposits.length > 0) {
      for (var reconciledDeposit in _reconciledDeposits) {
        // Amount
        if (reconciledDeposit['amount'] != null) {
          total += reconciledDeposit['amount'];
        }

        // For amount payable
        if (reconciledDeposit['amount_payable'] != null) {
          total += reconciledDeposit['amount_payable'];
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
            _submit(deposit);
          },
          child: Icon(Icons.check),
          backgroundColor: Theme.of(context).accentColor,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Builder(builder: (BuildContext context) {
          _bodyContext = context;
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
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
                          title: _reconciledDeposits[index]['member_id'] != null
                              ? Text(
                                  "${getDepositType(_reconciledDeposits[index]['deposit_for_type'])} - ${_reconciledDeposits[index]['member_name']}")
                              : _reconciledDeposits[index]['depositor_id'] !=
                                      null
                                  ? Text(
                                      "${getDepositType(_reconciledDeposits[index]['deposit_for_type'])} - ${_reconciledDeposits[index]['depositor_id']}")
                                  : _reconciledDeposits[index]['borrower_id'] !=
                                          null
                                      ? Text(
                                          "${getDepositType(_reconciledDeposits[index]['deposit_for_type'])} - ${_reconciledDeposits[index]['borrower_id']}")
                                      : Text(
                                          "${getDepositType(_reconciledDeposits[index]['deposit_for_type'])}"),
                          subtitle: _reconciledDeposits[index]['amount'] != null
                              ? Text(
                                  "${groupObject.groupCurrency} ${currencyFormat.format(_reconciledDeposits[index]['amount'])}")
                              : _reconciledDeposits[index]['amount_payable'] !=
                                      null
                                  ? Text(
                                      "${groupObject.groupCurrency} ${currencyFormat.format(_reconciledDeposits[index]['amount_payable'])}")
                                  : null,
                          trailing: IconButton(
                            onPressed: () => removeReconciledDeposit(index),
                            icon: Icon(Icons.close),
                            color: Theme.of(context).errorColor,
                          ),
                        );
                      },
                      itemCount: _reconciledDeposits.length,
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
