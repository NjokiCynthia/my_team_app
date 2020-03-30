import 'dart:math';

import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../dashboard.dart';

class ContributionStatement extends StatefulWidget {
  @override
  _ContributionStatementState createState() => _ContributionStatementState();
}

class _ContributionStatementState extends State<ContributionStatement> {
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

  final List<StatementRow> list = [
    StatementRow.header(true, "April"),
    StatementRow(false, "Monthly Savings", "Payment", "10000", DateTime.now()),
    StatementRow(false, "Welfare", "Payment", "500", DateTime.now()),
    StatementRow(false, "Monthly Savings", "Invoice", "10000", DateTime.now()),
    StatementRow(false, "Welfare", "Invoice", "500", DateTime.now()),
    StatementRow.header(true, "March"),
    StatementRow(false, "Monthly Savings", "Payment", "10000", DateTime.now()),
    StatementRow(false, "Welfare", "Payment", "500", DateTime.now()),
    StatementRow(false, "Monthly Savings", "Invoice", "10000", DateTime.now()),
    StatementRow(false, "Welfare", "Invoice", "500", DateTime.now()),
    StatementRow.header(true, "February"),
    StatementRow(false, "Monthly Savings", "Payment", "10000", DateTime.now()),
    StatementRow(false, "Welfare", "Payment", "500", DateTime.now()),
    StatementRow(false, "Monthly Savings", "Invoice", "10000", DateTime.now()),
    StatementRow(false, "Welfare", "Invoice", "500", DateTime.now()),
    StatementRow.header(true, "January"),
    StatementRow(false, "Monthly Savings", "Payment", "10000", DateTime.now()),
    StatementRow(false, "Welfare", "Payment", "500", DateTime.now()),
    StatementRow(false, "Monthly Savings", "Invoice", "10000", DateTime.now()),
    StatementRow(false, "Welfare", "Invoice", "500", DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            screenActionButton(
              icon: LineAwesomeIcons.arrow_left,
              backgroundColor: Colors.blue.withOpacity(0.1),
              textColor: Colors.blue,
              action: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChamasoftDashboard(),
                ),
              ),
            ),
            SizedBox(width: 20.0),
            heading2(color: Colors.blue, text: "Contribution Statement"),
          ],
        ),
        elevation: _appBarElevation,
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        color: Theme.of(context).backgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                color: (themeChangeProvider.darkTheme)
                    ? Colors.blueGrey[800]
                    : Color(0xffededfe),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading2(
                              text: "Total Contributions",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                          SizedBox(
                            height: 10,
                          ),
                          subtitle1(
                              text: "Total Due: Ksh 60,000",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                          subtitle1(
                              text: "Balance: Ksh 10,000",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                        ],
                      ),
                    ),
                    heading2(
                        text: "Ksh 50,000",
                        color: Theme.of(context).textSelectionHandleColor,
                        align: TextAlign.start)
                  ],
                ),
              ),
              Container(
                height: 500,
                //margin: EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    StatementRow row = list[index];
                    if (row.isHeader) {
                      return StatementHeader(row: row);
                    } else {
                      return StatementBody(row: row);
                    }
                  },
                  itemCount: list.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
