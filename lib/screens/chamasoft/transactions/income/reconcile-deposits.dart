import 'package:chamasoft/providers/deposits.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
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
  bool _isLoading = true;
  List _deposits = [];
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
  void didChangeDependencies() {
    // get the unreconciled deposits
    _fetchUnreconciledDeposits(context);
    super.didChangeDependencies();
  }

  Future<void> _fetchUnreconciledDeposits(BuildContext context) async {
    List deposits = await Provider.of<Groups>(context, listen: true)
        .fetchGroupUnreconciledDeposits();

    setState(() {
      _deposits = deposits;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            _isLoading
                ? showLinearProgressIndicator()
                : SizedBox(
                    height: 0.0,
                  ),
            _deposits.length > 0
                ? Container(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        Deposit deposit = _deposits[index];
                        return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            child: UnreconciledDepositCard(deposit));
                      },
                      itemCount: _deposits.length,
                    ),
                  )
                : emptyList(
                    color: Colors.blue[400],
                    iconData: LineAwesomeIcons.angle_double_down,
                    text: "There are no reconciled deposits")
          ],
        ),
      ),
    );
  }
}

class UnreconciledDepositCard extends StatefulWidget {
  final Deposit deposit;

  UnreconciledDepositCard(this.deposit, {Key key}) : super(key: key);

  @override
  _UnreconciledDepositCardState createState() =>
      _UnreconciledDepositCardState();
}

class _UnreconciledDepositCardState extends State<UnreconciledDepositCard> {
  Key key;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      borderOnForeground: false,
      child: Container(
        decoration: cardDecoration(
            gradient: plainCardGradient(context), context: context),
        child: Column(
          children: [
            ListTile(
              title: Padding(
                padding: EdgeInsets.all(4.0),
                child: subtitle1(
                    text: widget.deposit.transactionDate,
                    textAlign: TextAlign.start),
              ),
              subtitle: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: double.infinity,
                      child: subtitle1(
                          text: widget.deposit.accountDetails,
                          textAlign: TextAlign.start),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: double.infinity,
                      child: subtitle2(
                          text: "Kshs ${widget.deposit.amount}",
                          textAlign: TextAlign.start),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: double.infinity,
                      child: subtitle2(
                          text: widget.deposit.particulars,
                          textAlign: TextAlign.start),
                    ),
                  ),
                  _isExpanded
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: double.infinity,
                                child: subtitle2(
                                    text:
                                        "Account number: ${widget.deposit.accountNumber}",
                                    textAlign: TextAlign.start),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: double.infinity,
                                child: subtitle2(
                                    text:
                                        "TransactionId: ${widget.deposit.transactionId}",
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
              // trailing: IconButton(
              //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              //       builder: (BuildContext ctx) => ReconcileDeposit(),
              //       settings: RouteSettings(
              //           arguments: deposits[index].transactionAlertId))),
              //   icon: Icon(Icons.send),
              //   color: Theme.of(context).accentColor,
              // ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(_isExpanded ? "View less" : "View more",
                        style: TextStyle(color: Theme.of(context).accentColor)),
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: () {},
                    child: Text(
                      "Reconcile",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
