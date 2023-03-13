import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class MemberContributionStatement extends StatefulWidget {
  final String memberName, memberId;

  const MemberContributionStatement({Key key, this.memberName, this.memberId})
      : super(key: key);

  @override
  _MemberContributionStatementState createState() =>
      _MemberContributionStatementState();
}

class _MemberContributionStatementState
    extends State<MemberContributionStatement> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isInit = true;
  bool _isLoading = true;
  double _totalContributions = 0;
  double _totalDue = 0;
  double _balance = 0;
  String _statementAsAt = '', _statementFrom = '', _statementTo = '';
  List<ContributionStatementRow> _statements = [];
  ContributionStatementModel _contributionStatementModel;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _fetchMemberStatement(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchMemberContributionStatement(memberId: widget.memberId);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchMemberStatement(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

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

    _fetchMemberStatement(context).then((_) {
      if (context != null) {
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
      }
    });

    _isInit = false;
    return true;
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
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
        key: _scaffoldKey,
        appBar: secondaryPageAppbar(
            context: context,
            title: "Member Statements",
            action: () => Navigator.of(context).pop(),
            elevation: _appBarElevation,
            leadingIcon: LineAwesomeIcons.arrow_left),
        backgroundColor: Theme.of(context).colorScheme.background,
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
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            subtitle1(
                                text: "Contribution Statement for:  ",
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionTheme.selectionHandleColor,
                                textAlign: TextAlign.start),
                            subtitle1(
                                text: widget.memberName,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionTheme.selectionHandleColor,
                                textAlign: TextAlign.start),
                            // customTitle(
                            //     text: widget.memberName,
                            //     color: Theme.of(context)
                            //         // ignore: deprecated_member_use
                            //         .textSelectionTheme.selectionHandleColor,
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w500,
                            //     textAlign: TextAlign.start),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    heading2(
                                        text: "Total Contibution",
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionTheme.selectionHandleColor,
                                        textAlign: TextAlign.start),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        subtitle2(
                                            text: "Total amount due ",
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionTheme.selectionHandleColor,
                                            textAlign: TextAlign.start),
                                        customTitle(
                                            text: groupObject.groupCurrency +
                                                " " +
                                                currencyFormat
                                                    .format(_totalDue),
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionTheme.selectionHandleColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.start)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        subtitle2(
                                            text: "Balance ",
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionTheme.selectionHandleColor,
                                            textAlign: TextAlign.start),
                                        customTitle(
                                          text: groupObject.groupCurrency +
                                              " " +
                                              currencyFormat.format(_balance),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionTheme.selectionHandleColor,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
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
                              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                              textAlign: TextAlign.start),
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
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                                textAlign: TextAlign.start,
                              ),
                              customTitle(
                                text: _statementAsAt,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionTheme.selectionHandleColor,
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
                                      .textSelectionTheme.selectionHandleColor,
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
                                      .textSelectionTheme.selectionHandleColor,
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
                _isLoading
                    ? showLinearProgressIndicator()
                    : SizedBox(
                        height: 0.0,
                      ),
                Expanded(
                    child: _statements.length > 0
                        ? ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              ContributionStatementRow row = _statements[index];
                              if (row.isHeader) {
                                return StatementHeader(row: row);
                              } else {
                                return StatementBody(row: row);
                              }
                            },
                            itemCount: _statements.length,
                          )
                        : emptyList(
                            color: Colors.blue[400],
                            iconData: LineAwesomeIcons.file,
                            text:
                                "There are no statements for ${widget.memberName}"))
              ],
            )));
  }
}
