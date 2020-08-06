import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/repay-loan.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'loan-statement.dart';

class LoanSummary extends StatefulWidget {
  @override
  _LoanSummaryState createState() => _LoanSummaryState();
}

class _LoanSummaryState extends State<LoanSummary> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  Future<void> _future;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _getMemberLoans(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchMemberLoans();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getMemberLoans(context);
          });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _future = _getMemberLoans(context);
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
    return Scaffold(
        appBar: secondaryPageAppbar(
            context: context,
            title: "My Loans Summary",
            action: () => Navigator.of(context).pop(),
            elevation: _appBarElevation,
            leadingIcon: LineAwesomeIcons.arrow_left),
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _getMemberLoans(context),
                    child: Consumer<Groups>(builder: (context, data, child) {
                      List<ActiveLoan> activeLoans = data.getMemberLoans;
                      return Container(
                        decoration: primaryGradient(context),
                        width: double.infinity,
                        height: double.infinity,
                        child: activeLoans.length > 0
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  ActiveLoan loan = activeLoans[index];
                                  return ActiveLoanCard(
                                    loan: loan,
                                    repay: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => RepayLoan(
                                            loan: loan,
                                          ),
                                        ),
                                      );
                                    },
                                    statement: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => LoanStatement(
                                            loan: loan,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                itemCount: activeLoans.length)
                            : emptyList(color: Colors.blue[400], iconData: LineAwesomeIcons.pie_chart, text: "There are no loans to display"),
                      );
                    }))));
  }
}

class ActiveLoanCard extends StatelessWidget {
  const ActiveLoanCard({Key key, @required this.loan, this.repay, this.statement}) : super(key: key);

  final ActiveLoan loan;
  final Function repay, statement;

  @override
  Widget build(BuildContext context) {
    final groupObject = Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderOnForeground: false,
        child: Container(
            decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          loan.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.0, color: Theme.of(context).textSelectionHandleColor, fontFamily: 'SegoeUI'),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      getStatus()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        subtitle2(text: "Disbursed On", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                        subtitle1(text: loan.disbursementDate, color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        customTitle(
                          text: "${groupObject.groupCurrency} ",
                          fontSize: 18.0,
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w400,
                        ),
                        heading2(
                          text: currencyFormat.format(loan.amount),
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0),
                                  right: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 0.5))),
                          child: plainButton(
                              text: "REPAY NOW",
                              size: 16.0,
                              spacing: 2.0,
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                              // loan.status == 2 ? Theme.of(context).primaryColor.withOpacity(0.5) : Theme.of(context).primaryColor,
                              action: null) //loan.status == 2 ? null : repay),
                          ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0),
                                left: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 0.5))),
                        child: plainButton(text: "STATEMENT", size: 16.0, spacing: 2.0, color: Colors.blueGrey, action: statement),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget getStatus() {
    if (loan.status == 1) {
      return statusChip(text: "LOAN FULLY PAID", textColor: Colors.lightBlueAccent, backgroundColor: Colors.lightBlueAccent.withOpacity(.2));
    } else if (loan.status == 3) {
      return statusChip(text: "LOAN DEFAULTED", textColor: Colors.red, backgroundColor: Colors.red.withOpacity(.2));
    } else {
      return statusChip(text: "ONGOING", textColor: Colors.blueGrey, backgroundColor: Colors.blueGrey.withOpacity(.2));
    }
  }
}
