import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/contribution-statement.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ContributionSummary extends StatefulWidget {
  @override
  _ContributionSummaryState createState() => _ContributionSummaryState();
}

class _ContributionSummaryState extends State<ContributionSummary> {
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
    final summaryFlag = ModalRoute.of(context).settings.arguments;
    String appbarTitle = "Contribution Statement";
    String defaultTitle = "Contributions";

    if (summaryFlag == FINE_STATEMENT) {
      appbarTitle = "Fine Statement";
      defaultTitle = "Fines";
    }
    final List<SummaryRow> list = [
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
      SummaryRow(
          id: 1, name: "Peter Kimutai", avatar: "", paid: 1000, balance: 14000),
    ];
    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: appbarTitle,
          actions: summaryFlag == CONTRIBUTION_STATEMENT
              ? [
                  FilterActionButton(
                    icon: LineAwesomeIcons.filter,
                    textColor: Colors.blueGrey,
                  ),
                ]
              : null),
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
                          Text(
                            "Total " + defaultTitle,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textSelectionHandleColor
                                  .withOpacity(0.8),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            "31 Members",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
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
                          currencyFormat.format(2000000),
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
                Text(
                  "Statement Period",
                  style: TextStyle(
                    color: Theme.of(context)
                        .textSelectionHandleColor
                        .withOpacity(0.8),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "12 October 2019 to 20 February 2021",
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
                SummaryRow row = list[index];
                return ContributionSummaryBody(
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
