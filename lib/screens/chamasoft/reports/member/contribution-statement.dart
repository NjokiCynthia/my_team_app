import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

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
    final statementFlag = ModalRoute.of(context).settings.arguments;
    String appbarTitle = "Contribution Statement";
    String defaultTitle = "Contributions";

    if (statementFlag == FINE_STATEMENT) {
      appbarTitle = "Fine Statement";
      defaultTitle = "Fines";
    }

    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: appbarTitle,
          actions: [
            FilterActionButton(
              icon: LineAwesomeIcons.filter,
              textColor: Colors.blueGrey,
            ),
          ]),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
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
                          text: "Total " + defaultTitle,
                          color: Theme.of(context).textSelectionHandleColor,
                          align: TextAlign.start),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          subtitle2(
                              text: "Total amount due ",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                          subtitle1(
                              text: "Ksh 60,000",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          subtitle2(
                              text: "Balance ",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                          subtitle1(
                              text: "Ksh 10,000",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                        ],
                      ),
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
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
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
          ),
        ],
      ),
    );
  }
}

class FilterActionButton extends StatelessWidget {
  const FilterActionButton(
      {Key key, @required this.icon, @required this.textColor})
      : super(key: key);
  final IconData icon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final statementFlag = ModalRoute.of(context).settings.arguments;
    String defaultTitle = "Contributions";
    String single = "Contribution";

    if (statementFlag == 2) {
      defaultTitle = "Fines";
      single = "Fine";
    }

    return Container(
      width: 42.0,
      height: 22.0,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: Icon(
          icon,
          size: 22.0,
        ),
        onPressed: () {
          showBottomSheet(
              context: context,
              elevation: 10,
              builder: (context) => Container(
                    height: 250,
                    padding: EdgeInsets.all(10.0),
                    width: double.infinity,
                    color: Theme.of(context).backgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Color(0xffededfe),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        SizedBox(
                          height: 5,
                        ),
                        subtitle1(
                            text: "Filter " + defaultTitle,
                            color: Theme.of(context).textSelectionHandleColor,
                            align: TextAlign.start),
                        SizedBox(
                          height: 5,
                        ),
                        subtitle2(
                            text: "Select " + single,
                            color: Theme.of(context).textSelectionHandleColor,
                            align: TextAlign.start),
                        FilterButton(
                          text: "All " + defaultTitle,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        subtitle2(
                            text: "Statement Period",
                            color: Theme.of(context).textSelectionHandleColor,
                            align: TextAlign.start),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FilterButton(
                              text: "12/03/2020",
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: subtitle2(
                                  text: "to",
                                  color: Theme.of(context)
                                      .textSelectionHandleColor,
                                  align: TextAlign.start),
                            ),
                            FilterButton(
                              text: "12/04/2020",
                            ),
                          ],
                        ),
                        RaisedButton(
                          color: primaryColor,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            child: Text("Apply Filter"),
                          ),
                          textColor: Colors.white,
                          onPressed: () {},
                        )
                      ],
                    ),
                  ));
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        textColor: textColor,
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return new OutlineButton(
        child:
            subtitle1(text: text, color: primaryColor, align: TextAlign.center),
        onPressed: null,
        color: primaryColor,
        highlightedBorderColor: primaryColor.withOpacity(0.5),
        disabledBorderColor: primaryColor.withOpacity(0.5),
        borderSide: BorderSide(
          width: 2.0,
          color: primaryColor.withOpacity(0.5),
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)));
  }
}
