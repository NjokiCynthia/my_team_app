import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatefulWidget {
  @override
  _ExpenseSummaryState createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  Future<void> _future;

  Future<void> _getExpenseSummary(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchExpenseSummary();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getExpenseSummary(context);
          });
    }
  }

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
    _future = _getExpenseSummary(context);
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
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: "Expense Summary",
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _getExpenseSummary(context),
                    child: Consumer<Groups>(builder: (context, data, child) {
                      List<SummaryRow> expenseList = data.expenseSummaryList.expenseSummary;
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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          heading2(
                                            text: "Total Expenses",
                                            color: Theme.of(context).textSelectionHandleColor,
                                          ),
                                          subtitle2(
                                            text: expenseList.length == 1 ? "1 Expense" : "${data.expenseSummaryList.expenseSummary.length} Expenses",
                                            color: Theme.of(context).textSelectionHandleColor,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        customTitle(
                                          text: "Ksh ",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.0,
                                          color: Theme.of(context).textSelectionHandleColor,
                                        ),
                                        heading2(
                                          text: currencyFormat.format(data.expenseSummaryList.totalExpenses),
                                          color: Theme.of(context).textSelectionHandleColor,
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
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
                                  child: Container(),
                                ),
                                subtitle1(text: "Paid", color: Theme.of(context).primaryColor, textAlign: TextAlign.end),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                SummaryRow row = expenseList[index];
                                return ExpenseBody(
                                  row: row,
                                  position: index % 2 == 0,
                                );
                              },
                              itemCount: expenseList.length,
                            ),
                          )
                        ],
                      );
                    }))));
  }
}
