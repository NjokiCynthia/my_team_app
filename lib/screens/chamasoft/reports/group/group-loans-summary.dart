import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-summary-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class GroupLoansSummary extends StatefulWidget {
  @override
  _GroupLoansSummaryState createState() => _GroupLoansSummaryState();
}

class _GroupLoansSummaryState extends State<GroupLoansSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInit = true;
  bool _isLoading = true;
  LoansSummaryList _loansSummary;
  List<LoanSummaryRow> _loanSummaryRows = [];
  double _totalLoanedOut = 0;
  double _payable = 0;
  double _paid = 0;
  double _balance = 0;
  double _activeLoans = 0;
  double _fullyPaid = 0;
  double _badLoans = 0;
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

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _loansSummary = Provider.of<Groups>(context, listen: false).getLoansSummaryList;

    if (_loansSummary != null) {
      _loanSummaryRows = _loansSummary.summaryList;
      _totalLoanedOut = _loansSummary.totalLoan;
      _payable = _loansSummary.totalPayable;
      _paid = _loansSummary.totalPaid;
      _balance = _loansSummary.totalBalance;
    }

    _getLoanSummary(context).then((_) {
      _loansSummary = Provider.of<Groups>(context, listen: false).getLoansSummaryList;
      setState(() {
        _isLoading = false;
        if (_loansSummary != null) {
          _loanSummaryRows = _loansSummary.summaryList;
          _totalLoanedOut = _loansSummary.totalLoan;
          _payable = _loansSummary.totalPayable;
          _paid = _loansSummary.totalPaid;
          _balance = _loansSummary.totalBalance;
        }
      });
    });

    _isInit = false;
    return true;
  }

  Future<void> _getLoanSummary(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchLoansSummary();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getLoanSummary(context);
          },
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
  void didChangeDependencies() {
    if (_isInit) WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupObject = Provider.of<Groups>(context, listen: false).getCurrentGroup();
    String appbarTitle = "Group Loans Summary";
    return Scaffold(
        key: _scaffoldKey,
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.close,
          title: appbarTitle,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: RefreshIndicator(
            onRefresh: () => _getLoanSummary(context),
            child: Column(
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
                                text: "Total Loaned Out",
                                color: Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.start),
                          ),
                          Row(
                            children: <Widget>[
                              customTitle(
                                text: "${groupObject.groupCurrency} ",
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                                color: Theme.of(context).textSelectionHandleColor,
                              ),
                              heading2(
                                text: currencyFormat.format(_totalLoanedOut),
                                color: Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.end,
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
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    subtitle2(
                                        text: "Payable: ${groupObject.groupCurrency} ",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.start),
                                    customTitle(
                                        text: currencyFormat.format(_payable),
                                        color: Theme.of(context).textSelectionHandleColor,
                                        fontSize: 12,
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    subtitle2(
                                        text: "Paid: ${groupObject.groupCurrency} ",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.start),
                                    customTitle(
                                        text: currencyFormat.format(_paid),
                                        color: Theme.of(context).textSelectionHandleColor,
                                        fontSize: 12,
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    subtitle2(
                                        text: "Balance: ${groupObject.groupCurrency} ",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.start),
                                    customTitle(
                                        text: currencyFormat.format(_balance),
                                        color: Theme.of(context).textSelectionHandleColor,
                                        fontSize: 12,
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                              ]),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    subtitle2(
                                        text: "Active Loans: ",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.start),
                                    customTitle(
                                        text: "-",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        fontSize: 12,
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    subtitle2(
                                        text: "Fully Paid: ",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.start),
                                    customTitle(
                                        text: "-",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        fontSize: 12,
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    subtitle2(
                                        text: "Bad Loans: ",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        textAlign: TextAlign.start),
                                    customTitle(
                                        text: "-",
                                        color: Theme.of(context).textSelectionHandleColor,
                                        fontSize: 12,
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                              ]),
                            ),
                          ]),
                    ],
                  ),
                ),
                _isLoading
                    ? LinearProgressIndicator(
                        backgroundColor: Colors.cyanAccent,
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                      )
                    : SizedBox(
                        height: 0.0,
                      ),
                _loanSummaryRows.length > 0
                    ? Container(
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
                                  text: "Due", color: Theme.of(context).primaryColor, textAlign: TextAlign.center),
                            ),
                            Expanded(
                              flex: 2,
                              child: subtitle1(
                                  text: "Paid", color: Theme.of(context).primaryColor, textAlign: TextAlign.center),
                            ),
                            Expanded(
                              flex: 2,
                              child: subtitle1(
                                  text: "Balance", color: Theme.of(context).primaryColor, textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Expanded(
                  child: _loanSummaryRows.length > 0
                      ? ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            LoanSummaryRow row = _loanSummaryRows[index];
                            return LoanSummaryBody(
                              row: row,
                              position: index % 2 == 0,
                            );
                          },
                          itemCount: _loanSummaryRows.length,
                        )
                      : emptyList(
                          color: Colors.blue[400],
                          iconData: LineAwesomeIcons.bar_chart,
                          text: "There are no loans to display"),
                )
              ],
            )));
  }
}
