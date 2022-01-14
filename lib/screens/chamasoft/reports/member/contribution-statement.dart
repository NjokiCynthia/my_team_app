import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/reports/filter-statements.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ContributionStatement extends StatefulWidget {
  final int statementFlag;

  ContributionStatement({this.statementFlag});

  @override
  _ContributionStatementState createState() => _ContributionStatementState();
}

class _ContributionStatementState extends State<ContributionStatement> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _appBarElevation = 0;
  double _totalContributions = 0;
  double _totalDue = 0;
  double _balance = 0;
  String _statementAsAt = '', _statementFrom = '', _statementTo = '';
  List<ContributionStatementRow> _statements = [];
  ContributionStatementModel _contributionStatementModel;
  ScrollController _scrollController;
  bool _isLoading = true;
  bool _isInit = true;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    if (widget.statementFlag == FINE_STATEMENT) {
      _contributionStatementModel =
          Provider.of<Groups>(context, listen: false).getFineStatements;
    } else
      _contributionStatementModel =
          Provider.of<Groups>(context, listen: false).getContributionStatements;

    if (_contributionStatementModel != null) {
      _statements = _contributionStatementModel.statements;
      _totalContributions = _contributionStatementModel.totalPaid;
      _totalDue = _contributionStatementModel.totalDue;
      _balance = _contributionStatementModel.totalBalance;
      _statementAsAt = _contributionStatementModel.statementAsAt;
      _statementFrom = _contributionStatementModel.statementFrom;
      _statementTo = _contributionStatementModel.statementTo;
    }

    _getContributionStatement(context).then((_) {
      if (widget.statementFlag == FINE_STATEMENT) {
        _contributionStatementModel =
            Provider.of<Groups>(context, listen: false).getFineStatements;
      } else
        _contributionStatementModel =
            Provider.of<Groups>(context, listen: false)
                .getContributionStatements;

      setState(() {
        _isLoading = false;
        if (_contributionStatementModel != null) {
          _statements = _contributionStatementModel.statements;
          _totalContributions = _contributionStatementModel.totalPaid;
          _totalDue = _contributionStatementModel.totalDue;
          _balance = _contributionStatementModel.totalBalance;
          _statementAsAt = _contributionStatementModel.statementAsAt;
          _statementFrom = _contributionStatementModel.statementFrom;
          _statementTo = _contributionStatementModel.statementTo;
        }
      });
    });

    _isInit = false;
    return true;
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  Future<void> _getContributionStatement(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchContributionStatement(widget.statementFlag);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () => _fetchData(),
          scaffoldState: _scaffoldKey.currentState);
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

  void _applyFilter() {}

  // ignore: unused_element
  void _showFilter(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) => FilterStatements(
            ModalRoute.of(context).settings.arguments, _applyFilter));
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    String appbarTitle = "Contribution Statement";
    String defaultTitle = "Contributions";

    if (widget.statementFlag == FINE_STATEMENT) {
      appbarTitle = "Fine Statement";
      defaultTitle = "Fines Paid";
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          //trailingIcon: LineAwesomeIcons.filter,
          title: appbarTitle,
          //trailingAction: () => _showFilter(context),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: RefreshIndicator(
            backgroundColor: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Colors.white,
            onRefresh: () => _fetchData(),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: (themeChangeProvider.darkTheme)
                      ? Colors.blueGrey[800]
                      : Color(0xffededfe),
                  child: Column(
                    children: <Widget>[
                      Row(
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
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionHandleColor,
                                    textAlign: TextAlign.start),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    subtitle2(
                                        text: "Total amount due ",
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionHandleColor,
                                        textAlign: TextAlign.start),
                                    customTitle(
                                        text: groupObject.groupCurrency +
                                            " " +
                                            currencyFormat.format(_totalDue),
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionHandleColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.start)
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
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionHandleColor,
                                        textAlign: TextAlign.start),
                                    customTitle(
                                      text: groupObject.groupCurrency +
                                          " " +
                                          currencyFormat.format(_balance),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          heading2(
                              text: groupObject.groupCurrency +
                                  " " +
                                  currencyFormat.format(_totalContributions),
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionHandleColor,
                              textAlign: TextAlign.start)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                _isLoading
                    ? showLinearProgressIndicator()
                    : SizedBox(
                        height: 0.0,
                      ),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          subtitle2(
                            text: "Statement as At",
                            color:
                                // ignore: deprecated_member_use
                                Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.start,
                          ),
                          customTitle(
                            text: _statementAsAt,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                // ignore: deprecated_member_use
                                Theme.of(context).textSelectionHandleColor,
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
                              color: Theme.of(context)
                                  // ignore: deprecated_member_use
                                  .textSelectionHandleColor,
                              textAlign: TextAlign.end,
                            ),
                            customTitle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              text: _statementFrom.isNotEmpty
                                  ? "$_statementFrom to $_statementTo"
                                  : "",
                              color: Theme.of(context)
                                  // ignore: deprecated_member_use
                                  .textSelectionHandleColor,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 8.0, top: 0.0, right: 8.0, bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: subtitle3(
                            text: "Date",
                            color: Theme.of(context).primaryColor,
                            textAlign: TextAlign.start),
                      ),
                      Expanded(
                        flex: 1,
                        child: subtitle3(
                            text: 'Due (${groupObject.groupCurrency})',
                            color: Theme.of(context).primaryColor,
                            textAlign: TextAlign.end),
                      ),
                      Expanded(
                        flex: 1,
                        child: subtitle3(
                            text: 'Paid (${groupObject.groupCurrency})',
                            color: Theme.of(context).primaryColor,
                            textAlign: TextAlign.end),
                      ),
                      Expanded(
                        flex: 1,
                        child: subtitle3(
                            text: 'Bal (${groupObject.groupCurrency})',
                            color: Theme.of(context).primaryColor,
                            textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: _statements.length > 0
                        ? ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              ContributionStatementRow row = _statements[index];
                              return Container(
                                 color: (index % 2 == 0)
                                  ? (themeChangeProvider.darkTheme)
                                      ? Colors.blueGrey[800]
                                      : Color(0xffededfe)
                                  : Theme.of(context).backgroundColor,
                              padding: EdgeInsets.only(
                                  left: 0.0, top: 0.0, right: 0.0, bottom: 5.0),
                                  child: MemberStatementBody(row: row,),
                              );
                              // if (row.isHeader) {
                              //   return StatementHeader(row: row);
                              // } else {
                              //   return StatementBody(row: row);
                              // }
                            },
                            itemCount: _statements.length,
                          )
                        : emptyList(
                            color: Colors.blue[400],
                            iconData: LineAwesomeIcons.file_text,
                            text: "There are no statements for the period")),
                Container(
                  padding: EdgeInsets.only(
                      left: 8.0, top: 0.0, right: 8.0, bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: subtitle1(
                            text: "Total",
                            color: Theme.of(context).primaryColor,
                            textAlign: TextAlign.start),
                      ),
                      Expanded(
                        flex: 1,
                        child: subtitle3(
                            text: currencyFormat.format(_totalDue),
                            color: Theme.of(context).primaryColor,
                            textAlign: TextAlign.end),
                      ),
                      Expanded(
                        flex: 1,
                        child: subtitle3(
                            text: currencyFormat.format(_totalContributions),
                            color: Theme.of(context).primaryColor,
                            textAlign: TextAlign.end),
                      ),
                      Expanded(
                        flex: 1,
                        child: subtitle3(
                            text: currencyFormat.format(_balance),
                            color: (_balance > 0)
                                ? Colors.red
                                : (_balance < 0
                                    ? Colors.green
                                    // ignore: deprecated_member_use
                                    : Theme.of(context)
                                        .textSelectionHandleColor),
                            textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Center(
                        child: subtitle3(
                          text: _balance < 0
                              ? "You have an Overpayment of ${groupObject.groupCurrency + " " + currencyFormat.format(_balance.abs())}"
                              : "You have an Underpayment of ${groupObject.groupCurrency + " " + currencyFormat.format(_balance.abs())}",
                          textAlign: TextAlign.start,
                          // fontSize: 14.0,
                          // ignore: deprecated_member_use
                          color:
                              // ignore: deprecated_member_use
                              Theme.of(context).textSelectionHandleColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                )
              ],
            )));
  }
}
