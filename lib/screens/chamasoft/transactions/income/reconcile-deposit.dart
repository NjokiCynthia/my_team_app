import 'package:chamasoft/providers/deposit-reconciliation.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:chamasoft/providers/deposits.dart';
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

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBBarElevation : 0;
    if (_appBBarElevation != newElevation) {
      setState(() {
        _appBBarElevation = newElevation;
      });
    }
  }

  void _submit(BuildContext context, String depositId, depositDefaults, deposit,
      depositReconciliation) async {
    // get the amount entered.
    double total = depositReconciliation.getTotalAmount();
    // compare it with the total amount transacted
    if (total == deposit.amountTransacted) {
      // reconcile the deposit.
      depositDefaults.reconcileDeposit(depositId);
      // reset formdata and formFields
      depositReconciliation.reset();
      // back to the reconciled deposits
      Navigator.pop(context);
    } else if (total > deposit.amountTransacted) {
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
    final depositDefaults = Provider.of<Deposits>(context);
    final depositId = ModalRoute.of(context).settings.arguments as String;
    final deposit = depositDefaults.deposit(depositId);
    final depositReconciliation =
        Provider.of<DepositReconciliation>(context, listen: true);

    return Scaffold(
        appBar: secondaryPageAppbar(
            context: context,
            title: "Reconcile deposit",
            action: () {
              // reset formdata and formFields
              depositReconciliation.reset();
              // back to the previous screen
              Navigator.of(context).pop();
            },
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
                  Container(
                      padding: inputPagePadding,
                      height: MediaQuery.of(context).size.height * 0.77,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                child: SingleChildScrollView(
                              child: Column(
                                children: depositReconciliation.formFields
                                    .map((field) {
                                  return ReconcileDepositForm(
                                    field.id,
                                    key: ValueKey(field.id),
                                  );
                                }).toList(),
                              ),
                            )),
                            // Save button
                            defaultButton(
                                context: context,
                                text: "Save",
                                onPressed: () {
                                  _submit(context, depositId, depositDefaults,
                                      deposit, depositReconciliation);
                                })
                          ]))
                ],
              ),
            ),
          );
        }));
  }
}
