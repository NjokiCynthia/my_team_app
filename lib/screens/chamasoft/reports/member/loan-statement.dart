import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-statement-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class LoanStatement extends StatefulWidget {
  final ActiveLoan loan;

  LoanStatement({this.loan});

  @override
  _LoanStatementState createState() => _LoanStatementState();
}

class _LoanStatementState extends State<LoanStatement> {
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

  Future<void> _getLoanStatements(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchLoanStatement(widget.loan.id);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getLoanStatements(context);
          });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _future = _getLoanStatements(context);
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
          title: "Loan Statement",
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _getLoanStatements(context),
                    child: Consumer<Groups>(builder: (context, data, child) {
                      return Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16.0),
                            width: double.infinity,
                            color: (themeChangeProvider.darkTheme) ? Colors.blueGrey[800] : Color(0xffededfe),
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
                                      child: heading2(
                                        text: "${widget.loan.name}",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        customTitle(
                                          text: "Ksh ",
                                          fontSize: 18.0,
                                          color: Theme.of(context).textSelectionHandleColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        heading2(
                                          text: "${currencyFormat.format(widget.loan.amount)}",
                                          color: Theme.of(context).textSelectionHandleColor,
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
//                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  children: <Widget>[
//                                    subtitle2(
//                                        text: "Loan + Interest: ", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
//                                    customTitle(
//                                        text: "Ksh ${currencyFormat.format(data.getLoanStatements.lumpSum)}",
//                                        color: Theme.of(context).textSelectionHandleColor,
//                                        fontSize: 12,
//                                        textAlign: TextAlign.start),
//                                  ],
//                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    subtitle2(text: "Amount Repaid ", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                    subtitle1(
                                        text: "Ksh ${currencyFormat.format(data.getLoanStatements.paid)}",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    subtitle2(text: "Balance ", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                    subtitle1(
                                        text: "Ksh ${currencyFormat.format(data.getLoanStatements.balance)}",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    subtitle2(text: "Disbursed On ", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                    subtitle1(
                                        text: widget.loan.disbursementDate,
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.start),
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
                                  child: subtitle1(text: "Paid", color: Theme.of(context).primaryColor, textAlign: TextAlign.end),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: subtitle1(text: "Balance", color: Theme.of(context).primaryColor, textAlign: TextAlign.end),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                LoanStatementRow row = data.getLoanStatements.statementRows[index];
                                return LoanStatementBody(
                                  row: row,
                                  position: index % 2 == 0,
                                );
                              },
                              itemCount: data.getLoanStatements.statementRows.length,
                            ),
                          )
                        ],
                      );
                    }))));
  }
}
