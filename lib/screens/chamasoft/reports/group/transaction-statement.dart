import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/transaction-statement-model.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class TransactionStatement extends StatefulWidget {
  @override
  _TransactionStatementState createState() => _TransactionStatementState();
}

class _TransactionStatementState extends State<TransactionStatement> {
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

  Future<void> _getTransactionStatement(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchTransactionStatement();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getTransactionStatement(context);
          });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _future = _getTransactionStatement(context);
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
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Transaction Statement",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _getTransactionStatement(context),
                child: Consumer<Groups>(builder: (context, data, child) {
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        color: (themeChangeProvider.darkTheme) ? Colors.blueGrey[800] : Color(0xffededfe),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        heading2(
                                            text: "Total Balance", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            subtitle2(
                                                text: "Deposits ", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                            subtitle1(text: "-", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            subtitle2(
                                                text: "Withdrawals ", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                            subtitle1(text: "-", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                heading2(
                                    text: "Ksh " + currencyFormat.format(data.transactionStatement.totalBalance),
                                    color: Theme.of(context).textSelectionHandleColor,
                                    textAlign: TextAlign.start)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    subtitle2(
                                      text: "Statement as At",
                                      color: Theme.of(context).textSelectionHandleColor,
                                      textAlign: TextAlign.start,
                                    ),
                                    customTitle(
                                      text: data.transactionStatement.statementDate,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).textSelectionHandleColor,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      subtitle2(
                                        text: "Statement Period",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.end,
                                      ),
                                      customTitle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        text: data.transactionStatement.statementPeriodFrom + " to " + data.transactionStatement.statementPeriodTo,
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: customTitle(
                                  text: "Deposits", fontSize: 13.0, color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.center),
                            ),
                            Expanded(
                              flex: 1,
                              child: customTitle(
                                  text: "Withdrawals",
                                  fontSize: 13.0,
                                  color: Theme.of(context).textSelectionHandleColor,
                                  textAlign: TextAlign.center),
                            ),
                            Expanded(
                              flex: 1,
                              child: customTitle(
                                  text: "Balance", fontSize: 13.0, color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            TransactionStatementRow row = data.transactionStatement.transactionStatements[index];
                            return TransactionStatementBody(
                              row: row,
                              position: index % 2 == 0,
                            );
                          },
                          itemCount: data.transactionStatement.transactionStatements.length,
                        ),
                      ),
                    ],
                  );
                }),
              ),
      ),
    );
  }
}
