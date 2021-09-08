import 'package:chamasoft/providers/withdrawals.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/reconcile-withDrawal.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
// import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReconcileWithdrawals extends StatefulWidget {
  @override
  _ReconcileWithdrawalsState createState() => _ReconcileWithdrawalsState();
}

class _ReconcileWithdrawalsState extends State<ReconcileWithdrawals> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
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

  @override
  Widget build(BuildContext context) {
    final withdrawals =
        Provider.of<Withdrawals>(context, listen: true).withdrawals;

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Reconcile withdrawals",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        decoration: primaryGradient(context),
        width: double.infinity,
        height: double.infinity,
        child: withdrawals.length > 0
            ? Container(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    WithDrawal withdrawal = withdrawals[index];
                    return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: reconcileWithdrawalCard(
                            context, withdrawal, withdrawals, index));
                  },
                  itemCount: withdrawals.length,
                ),
              )
            : emptyList(
                color: Colors.blue[400],
                iconData: LineAwesomeIcons.angle_double_down,
                text: "There are no withdrawals to reconcile"),
      ),
    );
  }

  Card reconcileWithdrawalCard(BuildContext context, WithDrawal withdrawal,
      List<WithDrawal> withdrawals, int index) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      borderOnForeground: false,
      child: Container(
        decoration: cardDecoration(
            gradient: plainCardGradient(context), context: context),
        child: ListTile(
          title: Padding(
            padding: EdgeInsets.all(4.0),
            child: subtitle1(
                text: DateFormat.yMEd()
                    .add_jms()
                    .format(withdrawal.dateOfTransaction)
                    .toString(),
                textAlign: TextAlign.start),
          ),
          subtitle: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: subtitle1(
                    text: withdrawal.account, textAlign: TextAlign.start),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: subtitle2(
                    text: withdrawal.transactionDets,
                    textAlign: TextAlign.start),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext ctx) => ReconcileWithDrawal(),
                settings: RouteSettings(arguments: withdrawals[index].id))),
            icon: Icon(Icons.send),
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
