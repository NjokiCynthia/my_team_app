import 'package:chamasoft/screens/chamasoft/models/loan-summary-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class GroupLoansSummary extends StatefulWidget {
  @override
  _GroupLoansSummaryState createState() => _GroupLoansSummaryState();
}

class _GroupLoansSummaryState extends State<GroupLoansSummary> {
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
    String appbarTitle = "Loan Summary";

    final List<LoanSummaryRow> list = [
      LoanSummaryRow(
          id: 1,
          name: "Peter Kimutai",
          amountDue: 2000,
          paid: 1000,
          balance: 14000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Billie Eilish",
          amountDue: 120000,
          paid: 80000,
          balance: 40000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Peter Kimutai",
          amountDue: 2000,
          paid: 1000,
          balance: 14000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Billie Eilish",
          amountDue: 120000,
          paid: 80000,
          balance: 40000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Peter Kimutai",
          amountDue: 2000,
          paid: 1000,
          balance: 14000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Billie Eilish",
          amountDue: 120000,
          paid: 80000,
          balance: 40000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Peter Kimutai",
          amountDue: 2000,
          paid: 1000,
          balance: 14000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Billie Eilish",
          amountDue: 120000,
          paid: 80000,
          balance: 40000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Peter Kimutai",
          amountDue: 2000,
          paid: 1000,
          balance: 14000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Billie Eilish",
          amountDue: 120000,
          paid: 80000,
          balance: 40000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Peter Kimutai",
          amountDue: 2000,
          paid: 1000,
          balance: 14000,
          date: DateTime.now()),
      LoanSummaryRow(
          id: 1,
          name: "Billie Eilish",
          amountDue: 120000,
          paid: 80000,
          balance: 40000,
          date: DateTime.now()),
    ];
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: appbarTitle,
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
                      child: heading2(
                          text: "Total Loaned Out",
                          color: Theme.of(context).textSelectionHandleColor,
                          align: TextAlign.start),
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
                          align: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  subtitle2(
                                      text: "Payable: Ksh ",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      align: TextAlign.start),
                                  customTitle(
                                      text: "2,000,000",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      fontSize: 12,
                                      align: TextAlign.start),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  subtitle2(
                                      text: "Paid: Ksh ",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      align: TextAlign.start),
                                  customTitle(
                                      text: "400,000",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      fontSize: 12,
                                      align: TextAlign.start),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  subtitle2(
                                      text: "Balance: Ksh ",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      align: TextAlign.start),
                                  customTitle(
                                      text: "1,600,000",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      fontSize: 12,
                                      align: TextAlign.start),
                                ],
                              ),
                            ]),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  subtitle2(
                                      text: "Active Loans: ",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      align: TextAlign.start),
                                  customTitle(
                                      text: "22",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      fontSize: 12,
                                      align: TextAlign.start),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  subtitle2(
                                      text: "Fully Paid: ",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      align: TextAlign.start),
                                  customTitle(
                                      text: "10",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      fontSize: 12,
                                      align: TextAlign.start),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  subtitle2(
                                      text: "Bad Loans: ",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      align: TextAlign.start),
                                  customTitle(
                                      text: "4",
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      fontSize: 12,
                                      align: TextAlign.start),
                                ],
                              ),
                            ]),
                      ),
                    ]),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
                Expanded(
                  flex: 2,
                  child: subtitle1(
                      text: "Due",
                      color: Theme.of(context).primaryColor,
                      align: TextAlign.center),
                ),
                Expanded(
                  flex: 2,
                  child: subtitle1(
                      text: "Paid",
                      color: Theme.of(context).primaryColor,
                      align: TextAlign.center),
                ),
                Expanded(
                  flex: 2,
                  child: subtitle1(
                      text: "Balance",
                      color: Theme.of(context).primaryColor,
                      align: TextAlign.center),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                LoanSummaryRow row = list[index];
                return LoanSummaryBody(
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
