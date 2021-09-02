import 'package:chamasoft/providers/deposits.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/reconcile-deposit.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
// import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ReconcileDeposits extends StatefulWidget {
  @override
  _ReconcileDepositsState createState() => _ReconcileDepositsState();
}

class _ReconcileDepositsState extends State<ReconcileDeposits> {
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
    final deposits = Provider.of<Deposits>(context, listen: true).deposits;

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Reconcile deposits",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        decoration: primaryGradient(context),
        width: double.infinity,
        height: double.infinity,
        child: deposits.length > 0
            ? Container(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    Deposit deposit = deposits[index];
                    return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          borderOnForeground: false,
                          child: Container(
                            decoration: cardDecoration(
                                gradient: plainCardGradient(context),
                                context: context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.all(6.0),
                                    child: customTitle(
                                        text: deposit.account,
                                        fontSize: 13.0,
                                        color: Theme.of(context)
                                            .textSelectionHandleColor,
                                        textAlign: TextAlign.start)),
                                Container(
                                    padding: EdgeInsets.all(6.0),
                                    child: subtitle1(
                                        text:
                                            "Kshs ${deposit.amountTransacted}",
                                        //fontSize: 10.0,
                                        color: Theme.of(context)
                                            .textSelectionHandleColor,
                                        textAlign: TextAlign.start)),
                                Container(
                                    padding: EdgeInsets.all(6.0),
                                    child: subtitle2(
                                        text: "${deposit.transactionDets}.",
                                        //fontSize: 10.0,
                                        color: Theme.of(context)
                                            .textSelectionHandleColor,
                                        textAlign: TextAlign.start)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: defaultButton(
                                          context: context,
                                          text: "Reconcile",
                                          onPressed: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (BuildContext ctx) =>
                                                      ReconcileDeposit(),
                                                  settings: RouteSettings(
                                                      arguments: deposits[index]
                                                          .id)))),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                  itemCount: deposits.length,
                ),
              )
            : emptyList(
                color: Colors.blue[400],
                iconData: LineAwesomeIcons.angle_double_down,
                text: "There are no reconciled deposits"),
      ),
    );
  }
}
