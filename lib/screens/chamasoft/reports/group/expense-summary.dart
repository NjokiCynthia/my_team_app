import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ExpenseSummary extends StatefulWidget {
  @override
  _ExpenseSummaryState createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
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
    final List<SummaryRow> list = [
      SummaryRow(id: 1, name: "Audit Fees", paid: 1000),
      SummaryRow(
        id: 1,
        name: "Tax Man Edits",
        paid: 1000,
      ),
      SummaryRow(
        id: 1,
        name: "Annual Subscription",
        paid: 1000,
      ),
      SummaryRow(
        id: 1,
        name: "Benovelent Support",
        paid: 1000,
      ),
    ];
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Expense Summary",
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading2(
                            text: "Total Expenses",
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                          subtitle2(
                            text: "41 Expenses",
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
                          text: currencyFormat.format(2000000),
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
                subtitle1(
                    text: "Paid",
                    color: Theme.of(context).primaryColor,
                    textAlign: TextAlign.end),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                SummaryRow row = list[index];
                return ExpenseBody(
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
