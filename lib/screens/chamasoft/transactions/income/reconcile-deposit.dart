import 'package:chamasoft/widgets/appbars.dart';
import "package:flutter/material.dart";
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ReconcileDeposit extends StatefulWidget {
  const ReconcileDeposit({Key key}) : super(key: key);

  @override
  _ReconcileDepositState createState() => _ReconcileDepositState();
}

class _ReconcileDepositState extends State<ReconcileDeposit> {
  @override
  Widget build(BuildContext context) {
    final depositId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "Reconcile deposit",
          action: () => Navigator.of(context).pop(),
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Text("Reconcile deposit form for $depositId"),
      ),
    );
  }
}
