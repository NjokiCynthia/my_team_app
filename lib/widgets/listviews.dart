import 'package:chamasoft/screens/chamasoft/models/loan-installment.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'textstyles.dart';

class StatementBody extends StatelessWidget {
  const StatementBody({
    Key key,
    @required this.row,
  }) : super(key: key);

  final StatementRow row;

  @override
  Widget build(BuildContext context) {
    final amount = int.tryParse(row.amount) ?? 0;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.credit_card,
                  color: Theme.of(context).hintColor,
                  size: 24.0,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    subtitle1(
                        text: row.title,
                        color: Theme.of(context).textSelectionHandleColor,
                        align: TextAlign.start),
                    subtitle2(
                        text: row.description,
                        color: Theme.of(context).textSelectionHandleColor,
                        align: TextAlign.start)
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                subtitle1(
                    text: "Ksh " + currencyFormat.format(amount),
                    color: Theme.of(context).textSelectionHandleColor,
                    align: TextAlign.start),
                subtitle2(
                    text: DateFormat.yMMMMd().format(row.date),
                    color: Theme.of(context).textSelectionHandleColor,
                    align: TextAlign.start),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class StatementHeader extends StatelessWidget {
  const StatementHeader({
    Key key,
    @required this.row,
  }) : super(key: key);

  final StatementRow row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).backgroundColor,
        child: subtitle2(
            text: row.month,
            color: Theme.of(context).textSelectionHandleColor,
            align: TextAlign.start),
      ),
    );
  }
}

class AmortizationBody extends StatelessWidget {
  const AmortizationBody({
    Key key,
    @required this.installment,
  }) : super(key: key);

  final LoanInstallment installment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                subtitle1(
                    text: DateFormat.yMMMMd().format(installment.date),
                    color: Theme.of(context).textSelectionHandleColor,
                    align: TextAlign.start),
                subtitle2(
                    text: "Installment",
                    color: Theme.of(context).textSelectionHandleColor,
                    align: TextAlign.start),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                subtitle1(
                    text: "Ksh " + installment.amount,
                    color: Theme.of(context).textSelectionHandleColor,
                    align: TextAlign.end),
                subtitle2(
                    text: "Balance: Ksh " + installment.balance,
                    color: Theme.of(context).textSelectionHandleColor,
                    align: TextAlign.end),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LoanStatementBody extends StatelessWidget {
  const LoanStatementBody({this.row});

  final LoanStatementRow row;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).backgroundColor,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              subtitle1(
                  text: row.type,
                  color: Theme.of(context).textSelectionHandleColor,
                  align: TextAlign.start),
              subtitle2(
                  text: DateFormat.yMMMMd().format(row.date),
                  color: Theme.of(context).textSelectionHandleColor,
                  align: TextAlign.start),
            ],
          ),
          subtitle1(
              text: "Ksh " + currencyFormat.format(row.amountDue),
              color: Theme.of(context).textSelectionHandleColor,
              align: TextAlign.start),
          subtitle1(
              text: "Ksh " + currencyFormat.format(row.paid),
              color: Theme.of(context).textSelectionHandleColor,
              align: TextAlign.start),
          subtitle1(
              text: "Ksh " + currencyFormat.format(row.balance),
              color: Theme.of(context).textSelectionHandleColor,
              align: TextAlign.start),
        ],
      ),
    );
  }
}
