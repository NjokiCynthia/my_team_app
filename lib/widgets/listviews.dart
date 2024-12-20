import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-installment.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-summary-row.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';
import 'package:chamasoft/screens/chamasoft/models/transaction-statement-model.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import 'textstyles.dart';

class StatementBody extends StatelessWidget {
  const StatementBody({
    Key key,
    @required this.row,
  }) : super(key: key);

  final ContributionStatementRow row;

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
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
                        subtitle1(
                            text: row.title,
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
                            textAlign: TextAlign.start),
                        subtitle2(
                            text: row.description,
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
                            textAlign: TextAlign.start)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                subtitle1(
                    text: groupObject.groupCurrency +
                        " " +
                        currencyFormat.format(row.amount),
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                    textAlign: TextAlign.start),
                subtitle2(
                    text: row.date,
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                    textAlign: TextAlign.start),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MemberStatementBody extends StatelessWidget {
  final ContributionStatementRow row;
  const MemberStatementBody({
    Key key,
    @required this.row,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTitle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  text: row.date,
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                ),
                customTitle2(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    text: row.title,
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                    textAlign: TextAlign.start),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: customTitle(
                fontSize: 12,
                text: currencyFormat.format(row.payable),
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                textAlign: TextAlign.end),
          ),
          Expanded(
            flex: 1,
            child: customTitle(
                fontSize: 12,
                text: currencyFormat.format(row.amount),
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                textAlign: TextAlign.end),
          ),
          Expanded(
            flex: 1,
            child: customTitle(
                fontSize: 12,
                text: currencyFormat.format(row.balance),
                color: (row.balance > 0)
                    ? Colors.red
                    : (row.balance < 0
                        ? Colors.green
                        : Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

class StatementHeader extends StatelessWidget {
  const StatementHeader({
    Key key,
    @required this.row,
  }) : super(key: key);

  final ContributionStatementRow row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).backgroundColor,
        child: subtitle2(
            text: row.month,
            color: Theme.of(context).textSelectionTheme.selectionHandleColor,
            textAlign: TextAlign.start),
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
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
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
                    text: defaultDateFormat.format(installment.date),
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                    textAlign: TextAlign.start),
                subtitle2(
                    text: "Installment",
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                    textAlign: TextAlign.start),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                subtitle1(
                    text: groupObject.groupCurrency + " " + installment.amount,
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                    textAlign: TextAlign.end),
                subtitle2(
                    text: "Balance: ${groupObject.groupCurrency} " +
                        installment.balance,
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                    textAlign: TextAlign.end),
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
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Container(
      color: position
          ? (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Color(0xffededfe)
          : Theme.of(context).backgroundColor,
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
                      color: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                      textAlign: TextAlign.start),
                  subtitle2(
                      text: row.date,
                      color: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                      textAlign: TextAlign.start),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: subtitle1(
                  text: groupObject.groupCurrency +
                      " " +
                      currencyFormat.format(row.paid),
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  textAlign: TextAlign.end),
            ),
            Expanded(
              flex: 1,
              child: subtitle1(
                  text: groupObject.groupCurrency +
                      " " +
                      currencyFormat.format(row.balance),
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  textAlign: TextAlign.end),
            ),
          ],
        ),
      ),
    );
  }
}

class ContributionSummaryBody extends StatelessWidget {
  final int _statementType;

  ContributionSummaryBody(this._statementType);

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    final contributionSummary = _statementType == 1
        ? Provider.of<Groups>(context).groupContributionSummary
        : Provider.of<Groups>(context).groupFinesSummary;
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) => Container(
          color: (index % 2 == 0)
              ? (themeChangeProvider.darkTheme)
                  ? Colors.blueGrey[800]
                  : Color(0xffededfe)
              : Theme.of(context).backgroundColor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: InkWell(
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
                        Expanded(
                          child: subtitle1(
                              text: contributionSummary[index].memberName,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: subtitle1(
                        text: groupObject.groupCurrency +
                            " " +
                            currencyFormat
                                .format(contributionSummary[index].paidAmount),
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor,
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 1,
                    child: subtitle1(
                        text: groupObject.groupCurrency +
                            " " +
                            currencyFormat.format(
                                contributionSummary[index].balanceAmount),
                        color: (contributionSummary[index].balanceAmount > 0)
                            ? Colors.red
                            : (contributionSummary[index].balanceAmount < 0
                                ? Colors.green
                                : Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor),
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),
          ),
        ),
        itemCount: contributionSummary.length,
      ),
    );
  }
}

class AccountHeader extends StatelessWidget {
  const AccountHeader({
    Key key,
    @required this.header,
  }) : super(key: key);

  final AccountBalance header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).backgroundColor,
        child: subtitle2(
            text: header.header,
            color: Theme.of(context).textSelectionTheme.selectionHandleColor,
            textAlign: TextAlign.start),
      ),
    );
  }
}

class AccountBody extends StatelessWidget {
  const AccountBody({
    Key key,
    @required this.account,
  }) : super(key: key);

  final AccountBalance account;

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    final amount = double.tryParse(account.balance) ?? 0;
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
                        customTitleWithWrap(
                            text: account.name,
                            maxLines: 2,
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
                            textAlign: TextAlign.start),
                        if (account.accountNumber != "0")
                          subtitle2(
                              text: account.accountNumber,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.start)
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
                  text: groupObject.groupCurrency + " ",
                  color: Theme.of(context).primaryColor,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w400,
                ),
                customTitle(
                    text: currencyFormat.format(amount),
                    color: Theme.of(context).primaryColor,
                    textAlign: TextAlign.start,
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
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Container(
      color: position
          ? (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Color(0xffededfe)
          : Theme.of(context).backgroundColor,
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
                  customTitleWithWrap(
                      text: row.name,
                      color: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                      fontSize: 13,
                      textAlign: TextAlign.start),
                  customTitle(
                      text: defaultDateFormat.format(row.date),
                      color: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.start)
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: customTitle(
                  text: groupObject.groupCurrency +
                      " " +
                      currencyFormat.format(row.amountDue),
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  fontSize: 13,
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: customTitle(
                  text: groupObject.groupCurrency +
                      " " +
                      currencyFormat.format(row.paid),
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  fontSize: 13,
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: customTitle(
                  text: groupObject.groupCurrency +
                      " " +
                      currencyFormat.format(row.balance),
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  fontSize: 13,
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseBody extends StatelessWidget {
  const ExpenseBody({this.row, this.position});

  final SummaryRow row;
  final bool position;

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Container(
      color: position
          ? (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Color(0xffededfe)
          : Theme.of(context).backgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
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
                  Expanded(
                      child: customTitleWithWrap(
                          text: row.name,
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor,
                          textAlign: TextAlign.start)),
                ],
              ),
            ),
            customTitle(
                text: groupObject.groupCurrency +
                    " " +
                    currencyFormat.format(row.paid),
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.end),
          ],
        ),
      ),
    );
  }
}

class TransactionStatementBody extends StatelessWidget {
  const TransactionStatementBody({this.row, this.position});

  final TransactionStatementRow row;
  final bool position;

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Container(
      color: position
          ? (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Color(0xffededfe)
          : Theme.of(context).backgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: customTitle(
                      text: row.date,
                      color: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                      fontSize: 13,
                      textAlign: TextAlign.start),
                ),
                Expanded(
                  flex: 1,
                  child: customTitle(
                      text: groupObject.groupCurrency +
                          " " +
                          currencyFormat.format(row.deposit),
                      color: row.deposit == 0
                          ? Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor
                          : Colors.green,
                      fontSize: 13,
                      textAlign: TextAlign.center),
                ),
                Expanded(
                  flex: 1,
                  child: customTitle(
                      text: groupObject.groupCurrency +
                          " " +
                          currencyFormat.format(row.withdrawal),
                      color: row.withdrawal == 0
                          ? Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor
                          : Colors.red,
                      fontSize: 13,
                      textAlign: TextAlign.center),
                ),
                // Expanded(
                //   flex: 1,
                //   child: customTitle(
                //       text: groupObject.groupCurrency +
                //           " " +
                //           currencyFormat.format(row.balance),
                //       color: Theme.of(context).primaryColor,
                //       fontSize: 13,
                //       textAlign: TextAlign.center),
                // ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            subtitle2(
              text: row.description,
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('Balance:      '),
                Text(
                  groupObject.groupCurrency +
                      " " +
                      currencyFormat.format(row.balance),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
