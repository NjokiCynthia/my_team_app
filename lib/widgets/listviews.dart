import 'package:chamasoft/screens/chamasoft/models/loan-installment.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-summary-row.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
  const LoanStatementBody({this.row, this.position});

  final LoanStatementRow row;
  final bool position;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: position ? Color(0xffF6F6FE) : Theme.of(context).backgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
            Expanded(
              flex: 1,
              child: subtitle1(
                  text: "Ksh " + currencyFormat.format(row.paid),
                  color: Theme.of(context).textSelectionHandleColor,
                  align: TextAlign.end),
            ),
            Expanded(
              flex: 1,
              child: subtitle1(
                  text: "Ksh " + currencyFormat.format(row.balance),
                  color: Theme.of(context).textSelectionHandleColor,
                  align: TextAlign.end),
            ),
          ],
        ),
      ),
    );
  }
}

class ContributionSummaryBody extends StatelessWidget {
  const ContributionSummaryBody({this.row, this.position});

  final SummaryRow row;
  final bool position;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: position ? Color(0xffF6F6FE) : Theme.of(context).backgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Feather.user,
                    color: Colors.blueGrey,
                    size: 32,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  subtitle1(
                      text: row.name,
                      color: Theme.of(context).textSelectionHandleColor,
                      align: TextAlign.start),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: subtitle1(
                  text: "Ksh " + currencyFormat.format(row.paid),
                  color: Theme.of(context).textSelectionHandleColor,
                  align: TextAlign.end),
            ),
            Expanded(
              flex: 1,
              child: subtitle1(
                  text: "Ksh " + currencyFormat.format(row.balance),
                  color: Theme.of(context).textSelectionHandleColor,
                  align: TextAlign.end),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountBody extends StatelessWidget {
  const AccountBody({
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
            Expanded(
              flex: 1,
              child: Row(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        customTitle(
                            text: row.title,
                            color: Theme.of(context).textSelectionHandleColor,
                            align: TextAlign.start),
                        subtitle2(
                            text: row.description,
                            color: Theme.of(context).textSelectionHandleColor,
                            align: TextAlign.start)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                customTitle(
                  text: "Ksh ",
                  color: Theme.of(context).primaryColor,
                  align: TextAlign.start,
                  fontWeight: FontWeight.w400,
                ),
                customTitle(
                    text: currencyFormat.format(amount),
                    color: Theme.of(context).primaryColor,
                    align: TextAlign.start,
                    fontSize: 18),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LoanSummaryBody extends StatelessWidget {
  const LoanSummaryBody({this.row, this.position});

  final LoanSummaryRow row;
  final bool position;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: position ? Color(0xffF6F6FE) : Theme.of(context).backgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  customTitle(
                      text: row.name,
                      color: Theme.of(context).textSelectionHandleColor,
                      fontSize: 13,
                      align: TextAlign.start),
                  customTitle(
                      text: DateFormat.yMMMMd().format(row.date),
                      color: Theme.of(context).textSelectionHandleColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      align: TextAlign.start)
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: customTitle(
                  text: "Ksh " + currencyFormat.format(row.amountDue),
                  color: Theme.of(context).textSelectionHandleColor,
                  fontSize: 13,
                  align: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: customTitle(
                  text: "Ksh " + currencyFormat.format(row.paid),
                  color: Theme.of(context).textSelectionHandleColor,
                  fontSize: 13,
                  align: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: customTitle(
                  text: "Ksh " + currencyFormat.format(row.balance),
                  color: Theme.of(context).textSelectionHandleColor,
                  fontSize: 13,
                  align: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
