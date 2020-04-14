import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/loan-statement.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/repay-loan.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class LoanSummary extends StatefulWidget {
  @override
  _LoanSummaryState createState() => _LoanSummaryState();
}

class _LoanSummaryState extends State<LoanSummary> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
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
    final List<ActiveLoan> list = [
      ActiveLoan(
          id: 1,
          status: 1,
          name: "Emergency Loan",
          amount: 2000,
          repaid: 1000,
          balance: 1000,
          applicationDate: DateTime.now()),
      ActiveLoan(
          id: 1,
          status: 3,
          name: "Education Loan",
          amount: 15000,
          repaid: 1000,
          balance: 1000,
          applicationDate: DateTime.now()),
      ActiveLoan(
          id: 1,
          status: 2,
          name: "Quick Loan",
          amount: 7000,
          repaid: 1000,
          balance: 1000,
          applicationDate: DateTime.now())
    ];
    return Scaffold(
        appBar: secondaryPageAppbar(
            context: context,
            title: "My Loans Summary",
            action: () => Navigator.of(context).pop(),
            elevation: _appBarElevation,
            leadingIcon: LineAwesomeIcons.arrow_left),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: primaryGradient(context),
          width: double.infinity,
          height: double.infinity,
          child: ListView.builder(
              itemBuilder: (context, index) {
                ActiveLoan loan = list[index];
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
              itemCount: list.length),
        ));
  }
}

class ActiveLoanCard extends StatelessWidget {
  const ActiveLoanCard(
      {Key key, @required this.loan, this.repay, this.statement})
      : super(key: key);

  final ActiveLoan loan;
  final Function repay, statement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderOnForeground: false,
        child: Container(
            decoration: cardDecoration(
                gradient: plainCardGradient(context), context: context),
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
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            subtitle2(
                                text: "Applied On",
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                align: TextAlign.start),
                            subtitle1(
                                text: DateFormat.yMMMMd()
                                    .format(loan.applicationDate),
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                align: TextAlign.start)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Ksh ",
                              style: TextStyle(
                                fontSize: 16.0,
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              currencyFormat.format(loan.amount),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 20.0,
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Theme.of(context).bottomAppBarColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: plainButton(
                          text: "REPAY NOW",
                          size: 16.0,
                          spacing: 2.0,
                          color: loan.status == 2
                              ? Theme.of(context).primaryColor.withOpacity(0.5)
                              : Theme.of(context).primaryColor,
                          action: loan.status == 2 ? null : repay),
                    ),
                    Expanded(
                      flex: 1,
                      child: plainButton(
                          text: "STATEMENT",
                          size: 16.0,
                          spacing: 2.0,
                          color: Colors.blueGrey,
                          action: statement),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget getStatus() {
    if (loan.status == 2) {
      return statusChip(
          text: "LOAN FULLY PAID",
          textColor: Colors.lightBlueAccent,
          backgroundColor: Colors.lightBlueAccent.withOpacity(.2));
    } else if (loan.status == 3) {
      return statusChip(
          text: "LOAN DEFAULTED",
          textColor: Colors.red,
          backgroundColor: Colors.red.withOpacity(.2));
    } else {
      return statusChip(
          text: "PAYMENT ONGOING",
          textColor: Colors.blueGrey,
          backgroundColor: Colors.blueGrey.withOpacity(.2));
    }
  }
}
