import 'package:chamasoft/providers/withdrawals.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/reconcile-withdrawal-form.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ReconcileWithDrawal extends StatefulWidget {
  const ReconcileWithDrawal({Key key}) : super(key: key);

  @override
  _ReconcileWithDrawalState createState() => _ReconcileWithDrawalState();
}

class _ReconcileWithDrawalState extends State<ReconcileWithDrawal> {
  double _appBBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBBarElevation : 0;
    if (_appBBarElevation != newElevation) {
      setState(() {
        _appBBarElevation = newElevation;
      });
    }
  }

  void _newReconcileWithdrawalDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => ReconcileWithdrawalForm());
  }

  void _submit(BuildContext context, String withdrawalId, WithDrawal withdrawal,
      withdrawalProv) async {
    // get the amount entered.
    double total = withdrawalProv.totalReconciled;
    // compare it with the total amount transacted
    if (total == withdrawal.amountTransacted) {
      // reconcile the deposit.
      withdrawalProv.reconcileWithdrawal(withdrawalId);
      // reset formdata and formFields
      withdrawalProv.reset();
      // back to the reconciled deposits
      Navigator.pop(context);
    } else if (total > withdrawal.amountTransacted) {
      final snackBar = SnackBar(
          content:
              Text('The amount reconciled is greater than amount transacted'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar =
          SnackBar(content: Text('The amount transacted is not exhausted'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  @override
  Widget build(BuildContext context) {
    final withdrawalId = ModalRoute.of(context).settings.arguments as String;
    final withdrawalProv = Provider.of<Withdrawals>(context, listen: true);
    final withdrawal = withdrawalProv.withdrawal(withdrawalId);

    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          title: "Reconcile withdrawal",
          action: () {
            // reset the reconciled withdrawals.
            withdrawalProv.reset();
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
                  color: Theme.of(context).textSelectionHandleColor,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _submit(context, withdrawalId, withdrawal, withdrawalProv);
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
                  transactionToolTip(
                    title: withdrawal.transactionDets,
                    date:
                        "Date of transaction: ${DateFormat.yMEd().add_jms().format(withdrawal.dateOfTransaction).toString()}",
                    message:
                        "Amount to be reconciled: Kshs ${withdrawal.amountTransacted}",
                    context: context,
                  ),
                  Container(
                    padding: inputPagePadding,
                    height: MediaQuery.of(context).size.height * 0.64,
                    child: ListView.builder(
                      itemBuilder: (_, index) {
                        var entity =
                            withdrawalProv.reconciledWithdrawals[index];

                        return ListTile(
                          title: entity.memberId != null
                              ? Text(
                                  "${withdrawalProv.getWithdrawalType(entity.withdrawalTypeId)} - ${withdrawalProv.getMember(entity.memberId)}")
                              : Text(
                                  "${withdrawalProv.getWithdrawalType(entity.withdrawalTypeId)}"),
                          subtitle: entity.amount != null
                              ? Text("Kshs ${entity.amount}")
                              : null,
                          trailing: IconButton(
                            onPressed: () => withdrawalProv
                                .removeReconciledWithdrawal(index),
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                          ),
                        );
                      },
                      itemCount: withdrawalProv.reconciledWithdrawals.length,
                    ),
                  ),
                  Container(
                      padding: inputPagePadding,
                      child: ListTile(
                        title: Text(
                          'Total amount reconciled',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text("Kshs ${withdrawalProv.totalReconciled}"),
                      ))
                ],
              ),
            ),
          );
        }));
  }
}
