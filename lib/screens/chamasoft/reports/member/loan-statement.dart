import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-statement-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class LoanStatement extends StatefulWidget {
  final ActiveLoan loan;

  LoanStatement({this.loan});

  @override
  _LoanStatementState createState() => _LoanStatementState();
}

class _LoanStatementState extends State<LoanStatement> {
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
    final List<LoanStatementRow> list = [
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
      LoanStatementRow(
          id: 1,
          type: "Payment",
          date: DateTime.now(),
          paid: 1000,
          balance: 14000),
    ];
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Loan Statement",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            color: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Color(0xffededfe),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${widget.loan.name}",
                        style: TextStyle(
                          color: Theme.of(context)
                              .textSelectionHandleColor
                              .withOpacity(0.8),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Ksh ",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${currencyFormat.format(widget.loan.amount)}",
                          style: TextStyle(
                            color: Theme.of(context).textSelectionHandleColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Amount Repaid: ",
                      style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionHandleColor
                            .withOpacity(0.8),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Ksh ${currencyFormat.format(widget.loan.repaid)}",
                      style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionHandleColor
                            .withOpacity(0.8),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Balance: ",
                      style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionHandleColor
                            .withOpacity(0.8),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Ksh ${currencyFormat.format(widget.loan.balance)}",
                      style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionHandleColor
                            .withOpacity(0.8),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Applied On: ",
                      style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionHandleColor
                            .withOpacity(0.8),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "${defaultDateFormat.format(widget.loan.applicationDate)}",
                      style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionHandleColor
                            .withOpacity(0.8),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: subtitle1(
                      text: "Paid",
                      color: Theme.of(context).primaryColor,
                      align: TextAlign.end),
                ),
                Expanded(
                  flex: 1,
                  child: subtitle1(
                      text: "Balance",
                      color: Theme.of(context).primaryColor,
                      align: TextAlign.end),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                LoanStatementRow row = list[index];
                return LoanStatementBody(
                  row: row,
                  position: index % 2 == 0,
                );
              },
              itemCount: list.length,
            ),
          )
        ],
      ),
    );
  }
}
