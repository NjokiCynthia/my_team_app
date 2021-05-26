import 'dart:async';

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/reports/filter-statements.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ContributionSummary extends StatefulWidget {
  @override
  _ContributionSummaryState createState() => _ContributionSummaryState();
}

class _ContributionSummaryState extends State<ContributionSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isLoading = true;
  bool _isInit = true;
  String defaultTitle = "Contributions";
  String appbarTitle = "Contribution Summary";
  int _statementType = 1;
  double _totalAmount = 0;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
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
  void initState() {
    // _scrollController = ScrollController();
    // _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  Future<bool> _fetchData() async {
    final summaryFlag = ModalRoute.of(context).settings.arguments;

    setState(() {
      _isLoading = true;
    });

    if (summaryFlag == FINE_STATEMENT) {
      appbarTitle = "Fine Summary";
      defaultTitle = "Fines";
      _statementType = 2;
      _totalAmount =
          Provider.of<Groups>(context, listen: false).groupTotalFinesSummary();
      _fetchGroupFineSummary(context).then((_) {
        setState(() {
          _isLoading = false;
          _totalAmount = Provider.of<Groups>(context, listen: false)
              .groupTotalFinesSummary();
        });
      });
    } else {
      _totalAmount = Provider.of<Groups>(context, listen: false)
          .groupTotalContributionSummary();
      _fetchGroupContributionSummary(context).then((_) {
        setState(() {
          _isLoading = false;
          _totalAmount = Provider.of<Groups>(context, listen: false)
              .groupTotalContributionSummary();
        });
      }).catchError((error) {
        print(error);
        StatusHandler().handleStatus(
            context: _scaffoldKey.currentContext,
            error: error,
            callback: () {
              _fetchGroupContributionSummary(context);
            });
      });
    }

    _isInit = false;
    return true;
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  Future<void> _fetchGroupContributionSummary(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .getGroupContributionSummary();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () => _fetchGroupContributionSummary(context),
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<void> _fetchGroupFineSummary(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).getGroupFinesSummary();
    } catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () => _fetchGroupFineSummary(context),
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
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
                              text: "Total " + defaultTitle,
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
//                            customTitle(
//                              text: "Total " + defaultTitle,
//                              color: Theme.of(context).textSelectionHandleColor,
//                              fontSize: 14.0,
//                              fontWeight: FontWeight.w700,
//                            ),
                            customTitle(
                              text: "${groupObject.groupSize} Members",
                              textAlign: TextAlign.start,
                              color: primaryColor,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          customTitle(
                            text: groupObject.groupCurrency,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                          heading2(
                            text: currencyFormat.format(_totalAmount),
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
//                  SizedBox(
//                    height: 8.0,
//                  ),
//                  subtitle2(
//                    text: "Statement as at",
//                    color: Theme.of(context).textSelectionHandleColor,
//                    textAlign: TextAlign.start,
//                  ),
//                  subtitle1(
//                    text: defaultDateFormat.format(DateTime.now()),
//                    color: Theme.of(context).textSelectionHandleColor,
//                    textAlign: TextAlign.start,
//                  ),
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
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 1,
                    child: subtitle1(
                        text: "Balance",
                        color: Theme.of(context).primaryColor,
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),
            _isLoading
                ? showLinearProgressIndicator()
                : SizedBox(
                    height: 0.0,
                  ),
            Expanded(
                child: _isLoading
                    ? ContributionSummaryBody(_statementType)
                    : ContributionSummaryBody(_statementType))
          ],
        ),
      ),
    );
  }
}
