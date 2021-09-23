import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/setting_helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/reconcile-withdrawal-list.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/reconcile-withdrawal-form.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ReconcileWithdrawal extends StatefulWidget {
  const ReconcileWithdrawal({Key key}) : super(key: key);

  @override
  _ReconcileWithdrawalState createState() => _ReconcileWithdrawalState();
}

class _ReconcileWithdrawalState extends State<ReconcileWithdrawal> {
  double _appBBarElevation = 0;
  ScrollController _scrollController;
  List _reconciledWithdrawals = [];
  BuildContext _bodyContext;

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
      _reconciledWithdrawals.add(formData);
    });
  }

  void _newReconcileWithdrawalDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ReconcileWithdrawalForm(addReconciledWithdrawal));
  }

  void _submit(UnreconciledWithdrawal withdrawal) async {
    double total = totalReconciled;
    final Group groupObject =
        Provider.of<Groups>(_bodyContext, listen: false).getCurrentGroup();
    if (withdrawal.amount == total) {
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
            .reconcileWithdrawalTransactionAlert(
                _reconciledWithdrawals, withdrawal.transactionAlertId);

        StatusHandler()
            .showSuccessSnackBar(_bodyContext, "Successfully reconciled");

        Future.delayed(const Duration(milliseconds: 2500), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => ReconcileWithdrawalList(
                    reconciledWithdrawalTransactionAlertId:
                        withdrawal.transactionAlertId,
                  )));
        });
      } on CustomException catch (error) {
        StatusHandler().showDialogWithAction(
            context: _bodyContext,
            message: error.toString(),
            function: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => ReconcileWithdrawalList())),
            dismissible: true);
      } finally {}
    } else {
      alertDialog(context,
          "You have reconciled ${groupObject.groupCurrency} $total out of ${groupObject.groupCurrency} ${withdrawal.amount} transacted.");
    }
  }

  void removeReconciledWithdrawal(index) {
    setState(() {
      _reconciledWithdrawals.removeAt(index);
    });
  }

  double get totalReconciled {
    double total = 0.0;
    if (_reconciledWithdrawals.length > 0) {
      for (var reconciledWithdrawal in _reconciledWithdrawals) {
        if (reconciledWithdrawal['amount'] != null) {
          total += reconciledWithdrawal['amount'];
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
            _submit(withdrawal);
          },
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
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
                          title: _reconciledWithdrawals[index]['member_id'] !=
                                  null
                              ? Text(
                                  "${getWithdrawalType(_reconciledWithdrawals[index]['withdrawal_for_type'])} - ${_reconciledWithdrawals[index]['member_name']}")
                              : Text(
                                  "${getWithdrawalType(_reconciledWithdrawals[index]['withdrawal_for_type'])}"),
                          subtitle: _reconciledWithdrawals[index]['amount'] !=
                                  null
                              ? Text(
                                  "${groupObject.groupCurrency} ${currencyFormat.format(_reconciledWithdrawals[index]['amount'])}")
                              : null,
                          trailing: IconButton(
                            onPressed: () => removeReconciledWithdrawal(index),
                            icon: Icon(Icons.close),
                            color: Theme.of(context).errorColor,
                          ),
                        );
                      },
                      itemCount: _reconciledWithdrawals.length,
                    ),
                  ),
                  Container(
                      padding: inputPagePadding,
                      child: ListTile(
                          title: subtitle1(
                              text: "Total amount reconciled",
                              textAlign: TextAlign.start,
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context).textSelectionHandleColor),
                          subtitle: subtitle2(
                              text:
                                  "${groupObject.groupCurrency} ${currencyFormat.format(totalReconciled)}",
                              textAlign: TextAlign.start,
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context).textSelectionHandleColor)))
                ],
              ),
            ),
          );
        }));
  }
}