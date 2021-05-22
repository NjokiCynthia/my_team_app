import 'dart:convert';
import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/meetings/meetings.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/pay-now-sheet.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/svg-icons.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class ChamasoftHome extends StatefulWidget {
  ChamasoftHome({
    this.appBarElevation,
  });

  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftHomeState createState() => _ChamasoftHomeState();
}

class _ChamasoftHomeState extends State<ChamasoftHome> {
  ScrollController _scrollController;
  Group _currentGroup;
  bool _onlineBankingEnabled = true;
  bool _isInit = true;
  String _groupCurrency = "Ksh";
  List<RecentTransactionSummary> _iteratableRecentTransactionSummary = [];
  List<ContributionsSummary> _itableContributionSummary = [];
  bool _showMeetingsBanner = false;

  void _scrollListener() {
    widget.appBarElevation(_scrollController.offset);
  }

  void _meetingsBannerStatus() async {
    dynamic _bannerDbStatus = [
      {
        'group_id': _currentGroup.groupId,
        'show_banner': true,
      },
    ];
    Map<String, dynamic> _banner = _bannerDbStatus[0];
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("meetings-banner")) {
      String bannerStatusObject = prefs.getString("meetings-banner");
      _bannerDbStatus = jsonDecode(bannerStatusObject);
    }
    List<dynamic> _filtered = _bannerDbStatus
        .where((s) => s['group_id'] == _currentGroup.groupId)
        .toList();
    if (_filtered.length == 1) _banner = _filtered[0];
    setState(() {
      if ((_currentGroup.isGroupAdmin) && (_banner['show_banner']))
        _showMeetingsBanner = true;
      else
        _showMeetingsBanner = false;
    });
  }

  void hideBanner() async {
    List<dynamic> _bannerDbStatus = [
      {
        'group_id': _currentGroup.groupId,
        'show_banner': false,
      },
    ];
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("meetings-banner")) {
      String bannerStatusObject = prefs.getString("meetings-banner");
      _bannerDbStatus = jsonDecode(bannerStatusObject);
      List<dynamic> _filtered = _bannerDbStatus
          .where((s) => s['group_id'] == _currentGroup.groupId)
          .toList();
      if (_bannerDbStatus.length > 0) {
        if (_filtered.length == 0) {
          _bannerDbStatus.add(
            {
              'group_id': _currentGroup.groupId,
              'show_banner': false,
            },
          );
        } else {
          int _idx = _bannerDbStatus
              .indexWhere((b) => b['group_id'] == _currentGroup.groupId);
          _bannerDbStatus.removeAt(_idx);
          _bannerDbStatus.add(
            {
              'group_id': _currentGroup.groupId,
              'show_banner': false,
            },
          );
        }
      }
    }
    await prefs.setString("meetings-banner", jsonEncode(_bannerDbStatus));
    setState(() {
      _showMeetingsBanner = false;
    });
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
    _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    //if(_isInit){
    _getMemberDashboardData();
    //}
    _groupCurrency = _currentGroup.groupCurrency;
    _meetingsBannerStatus();
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacementNamed(MyGroups.namedRoute);
    return null;
  }

  Future<void> _getMemberDashboardData([bool hardRefresh = false]) async {
    try {
      if (hardRefresh) {
        Provider.of<Dashboard>(context, listen: false)
            .resetMemberDashboardData(_currentGroup.groupId);
      }
      if (!Provider.of<Dashboard>(context, listen: false)
          .memberGroupDataExists(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<Dashboard>(context, listen: false)
            .getMemberDashboardData(_currentGroup.groupId);
      }
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getMemberDashboardData();
          });
    } finally {
      if (this.mounted) {
        setState(() {
          _isInit = false;
          _onlineBankingEnabled = _currentGroup.onlineBankingEnabled;
        });
      }
    }
  }

  Iterable<Widget> get recentTransactionSummary sync* {
    int i = 0;
    for (var data in _iteratableRecentTransactionSummary) {
      yield Row(
        children: <Widget>[
          SizedBox(
            width: 16.0,
          ),
          Container(
            width: 160.0,
            padding: EdgeInsets.all(16.0),
            decoration: cardDecoration(
                gradient: plainCardGradient(context), context: context),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: resetTransactions(
                    color: (i % 2 == 1) ? Colors.blueGrey : primaryColor,
                    paymentDescription: data.paymentTitle,
                    cardAmount: currencyFormat.format(data.paymentAmount),
                    currency: _groupCurrency,
                    cardIcon: Feather.pie_chart,
                    paymentDate: data.paymentDate,
                    paymentMethod: data.paymentMethod + " Payment",
                    contributionType: data.description)),
          ),
          SizedBox(
            width: ((i + 1) == _iteratableRecentTransactionSummary.length)
                ? 16.0
                : 0.0,
          ),
        ],
      );
      ++i;
    }
  }

  Iterable<Widget> get contributionsSummary sync* {
    int i = 0;
    print(_itableContributionSummary.length);
    for (var data in _itableContributionSummary) {
      yield Row(
        children: <Widget>[
          SizedBox(
            width: 16.0,
          ),
          Container(
            width: 160.0,
            padding: EdgeInsets.all(16.0),
            decoration: cardDecoration(
                gradient:
                    i == 0 ? csCardGradient() : plainCardGradient(context),
                context: context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: contributionSummary(
                color: i == 0
                    ? Colors.white
                    : i == 1
                        ? primaryColor
                        : Colors.blueGrey,
                cardIcon: i == 0 ? Feather.bar_chart_2 : Feather.bar_chart,
                amountDue: currencyFormat.format(data.balance),
                cardAmount: currencyFormat.format(data.amountPaid),
                currency: _groupCurrency,
                dueDate: data.dueDate,
                contributionName: data.contributionName,
              ),
            ),
          ),
          if (((i + 1) == _itableContributionSummary.length) &&
              _itableContributionSummary.length == 1)
            SizedBox(
              width: 16.0,
            ),
          if (((i + 1) == _itableContributionSummary.length) &&
              _itableContributionSummary.length == 1)
            Container(
              width: 160.0,
              padding: EdgeInsets.all(16.0),
              // decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SvgPicture.asset(
                  //   customIcons['no-data'],
                  //   semanticsLabel: 'icon',
                  //   height: 80.0,
                  // ),
                  Icon(
                    Feather.layers,
                    color: Colors.blueGrey[400].withOpacity(0.2),
                    size: 38.0,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  customTitleWithWrap(
                      text: "More contributions will be displayed here",
                      //fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      textAlign: TextAlign.center,
                      color: Colors.blueGrey[400].withOpacity(0.3))
                ],
              ),
            ),
          SizedBox(
            width: ((i + 1) == _itableContributionSummary.length) ? 16.0 : 0.0,
          ),
        ],
      );
      ++i;
    }
  }

  LineChartData eWalletTrend() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 5),
            FlSpot(1, 2),
            FlSpot(2, 6),
            FlSpot(3, 3),
            FlSpot(4, 4),
            FlSpot(5, 2),
            FlSpot(6, 4),
            FlSpot(7, 1),
            FlSpot(8, 3),
          ],
          isCurved: false,
          colors: [primaryColor],
          barWidth: 1,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            colors: [
              primaryColor.withOpacity(0.07),
              primaryColor.withOpacity(0.0),
            ],
            gradientColorStops: [0.5, 1.0],
            gradientFrom: const Offset(0, 0),
            gradientTo: const Offset(0, 1),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = Provider.of<Dashboard>(context);
    setState(() {
      _iteratableRecentTransactionSummary =
          dashboardData.recentMemberTransactions;
      _itableContributionSummary = dashboardData.memberContributionSummary;
    });

    return WillPopScope(
      onWillPop: _onWillPop,
      child: RefreshIndicator(
        backgroundColor: (themeChangeProvider.darkTheme)
            ? Colors.blueGrey[800]
            : Colors.white,
        onRefresh: () => _getMemberDashboardData(true),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: !_isInit
                ? Column(
                    children: <Widget>[
                      Visibility(
                        visible: _showMeetingsBanner,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            16.0,
                            16.0,
                            16.0,
                            16.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: cardDecoration(
                              gradient: plainCardGradient(context),
                              context: context,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Stack(
                                children: <Widget>[
                                  Image(
                                    image: AssetImage(
                                      'assets/meeting-minutes.jpg',
                                    ),
                                    width: double.infinity,
                                  ),
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      color: Colors.black.withOpacity(0.3),
                                      padding: EdgeInsets.only(
                                        right: 16.0,
                                        top: 6.0,
                                        bottom: 6.0,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Chamasoft Meetings",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'SegoeUI',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22.0,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              subtitle2(
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                                text:
                                                    "Manage group meetings, easily.",
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Meetings(),
                                              ),
                                            ),
                                            child: Text(
                                              "Get Started",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'SegoeUI',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => hideBanner(),
                                            child: Text(
                                              "Don't show this again",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontFamily: 'SegoeUI',
                                                fontWeight: FontWeight.w300,
                                                fontSize: 11.0,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          16.0,
                          16.0,
                          16.0,
                          0.0,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: cardDecoration(
                            gradient: plainCardGradient(context),
                            context: context,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  customTitle(
                                    text: _currentGroup.disableArrears
                                        ? "Total Deposits and Loan Balances"
                                        : "Total Balances",
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              Divider(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.1),
                                thickness: 2.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  customTitle(
                                    text: "Your Contribution Balance",
                                    textAlign: TextAlign.start,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                  ),
                                  SizedBox(
                                    height: 22,
                                    child: cardAmountButton(
                                        currency: _groupCurrency,
                                        amount: _currentGroup.disableArrears
                                            ? currencyFormat.format(
                                                dashboardData
                                                    .memberContributionAmount)
                                            : currencyFormat.format(
                                                dashboardData
                                                    .memberContributionArrears),
                                        size: 16.0,
                                        color: (dashboardData
                                                    .memberContributionArrears) >
                                                0
                                            ? Colors.red[400]
                                            : Theme.of(context)
                                                .textSelectionHandleColor,
                                        action: () {}),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  customTitle(
                                    text: "Fines",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                  ),
                                  SizedBox(
                                    height: 22,
                                    child: cardAmountButton(
                                        currency: _groupCurrency,
                                        amount: _currentGroup.disableArrears
                                            ? currencyFormat.format(
                                                dashboardData.memberFineAmount)
                                            : currencyFormat.format(
                                                dashboardData
                                                    .memberFineArrears),
                                        size: 14.0,
                                        color:
                                            (dashboardData.memberFineArrears) >
                                                    0
                                                ? Colors.red[400]
                                                : Theme.of(context)
                                                    .textSelectionHandleColor,
                                        action: () {}),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  customTitle(
                                    text: "Loans",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                  ),
                                  SizedBox(
                                    height: 22,
                                    child: cardAmountButton(
                                        currency: _groupCurrency,
                                        amount: currencyFormat.format(
                                            dashboardData
                                                .memberTotalLoanBalance),
                                        size: 14.0,
                                        color: (dashboardData
                                                    .memberTotalLoanBalance) >
                                                0
                                            ? Colors.red[400]
                                            : Theme.of(context)
                                                .textSelectionHandleColor,
                                        action: () {}),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  customTitle(
                                    text: "Pending Installment Balance",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                  ),
                                  SizedBox(
                                    height: 22,
                                    child: cardAmountButton(
                                        currency: _groupCurrency,
                                        amount: currencyFormat.format(
                                            dashboardData.memberLoanArrears),
                                        size: 14.0,
                                        color:
                                            (dashboardData.memberLoanArrears) >
                                                    0
                                                ? Colors.red[400]
                                                : Theme.of(context)
                                                    .textSelectionHandleColor,
                                        action: () {}),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(
                      //     20.0,
                      //     10.0,
                      //     16.0,
                      //     0.0,
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment:
                      //         MainAxisAlignment.spaceBetween,
                      //     children: <Widget>[
                      //       Text(
                      //         "E-Wallet",
                      //         style: TextStyle(
                      //           color: Colors.blueGrey[400],
                      //           fontFamily: 'SegoeUI',
                      //           fontSize: 16.0,
                      //           fontWeight: FontWeight.w800,
                      //         ),
                      //       ),
                      //       IconButton(
                      //         icon: Icon(
                      //           Feather.more_horizontal,
                      //           color: Colors.blueGrey,
                      //         ),
                      //         onPressed: () {},
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(
                      //     16.0,
                      //     20.0,
                      //     16.0,
                      //     0.0,
                      //   ),
                      //   child: Container(
                      //     padding: EdgeInsets.all(16.0),
                      //     decoration: cardDecoration(
                      //       gradient: plainCardGradient(context),
                      //       context: context,
                      //     ),
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: <Widget>[
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: <Widget>[
                      //             Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Text(
                      //                   "Wallet Balance",
                      //                   style: TextStyle(
                      //                     color: Colors.blueGrey[400],
                      //                     fontFamily: 'SegoeUI',
                      //                     fontSize: 16.0,
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                   textAlign: TextAlign.start,
                      //                 ),
                      //                 Row(
                      //                   children: [
                      //                     Text(
                      //                       "KES",
                      //                       style: TextStyle(
                      //                         color: Colors.blueGrey[400],
                      //                         fontFamily: 'SegoeUI',
                      //                         fontSize: 32.0,
                      //                         fontWeight: FontWeight.w300,
                      //                       ),
                      //                       textAlign: TextAlign.start,
                      //                     ),
                      //                     SizedBox(width: 6.0),
                      //                     Text(
                      //                       "12,390",
                      //                       style: TextStyle(
                      //                         color: Colors.blueGrey[400],
                      //                         fontFamily: 'SegoeUI',
                      //                         fontSize: 32.0,
                      //                         fontWeight: FontWeight.w600,
                      //                       ),
                      //                       textAlign: TextAlign.start,
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 SizedBox(height: 12.0),
                      //                 SizedBox(
                      //                   height: 32.0,
                      //                   child: LineChart(
                      //                     eWalletTrend(),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.end,
                      //               children: [
                      //                 Text(
                      //                   "Deposits",
                      //                   style: TextStyle(
                      //                     color: Colors.blueGrey[400],
                      //                     fontFamily: 'SegoeUI',
                      //                     fontSize: 12.0,
                      //                     fontWeight: FontWeight.w300,
                      //                   ),
                      //                   textAlign: TextAlign.start,
                      //                 ),
                      //                 Row(
                      //                   children: [
                      //                     Icon(
                      //                       Icons.arrow_drop_down_sharp,
                      //                       color: Colors.red,
                      //                     ),
                      //                     Text(
                      //                       "0.92%",
                      //                       style: TextStyle(
                      //                         color: Colors.blueGrey[400],
                      //                         fontFamily: 'SegoeUI',
                      //                         fontSize: 12.0,
                      //                         fontWeight: FontWeight.w600,
                      //                       ),
                      //                       textAlign: TextAlign.start,
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 SizedBox(height: 12.0),
                      //                 Text(
                      //                   "Withdrawals",
                      //                   style: TextStyle(
                      //                     color: Colors.blueGrey[400],
                      //                     fontFamily: 'SegoeUI',
                      //                     fontSize: 12.0,
                      //                     fontWeight: FontWeight.w300,
                      //                   ),
                      //                   textAlign: TextAlign.start,
                      //                 ),
                      //                 Row(
                      //                   children: [
                      //                     Icon(
                      //                       Icons.arrow_drop_up_sharp,
                      //                       color: Colors.green,
                      //                     ),
                      //                     Text(
                      //                       "1.2%",
                      //                       style: TextStyle(
                      //                         color: Colors.blueGrey[400],
                      //                         fontFamily: 'SegoeUI',
                      //                         fontSize: 12.0,
                      //                         fontWeight: FontWeight.w600,
                      //                       ),
                      //                       textAlign: TextAlign.start,
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          20.0,
                          20.0,
                          16.0,
                          0.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Contribution Summary",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Feather.more_horizontal,
                                color: Colors.blueGrey,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      (_itableContributionSummary.length > 0)
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0,
                                  _onlineBankingEnabled ? 10.0 : 0.0),
                              child: Container(
                                height: 180.0,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 10.0),
                                  physics: BouncingScrollPhysics(),
                                  children: _itableContributionSummary.length >
                                          0
                                      ? contributionsSummary.toList()
                                      : <Widget>[
                                          SizedBox(
                                            width: 16.0,
                                          ),
                                          Container(
                                            width: 160.0,
                                            padding: EdgeInsets.all(16.0),
                                            decoration: cardDecoration(
                                                gradient: csCardGradient(),
                                                context: context),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: contributionSummary(
                                                color: Colors.white,
                                                cardIcon: Feather.bar_chart_2,
                                                amountDue: "0",
                                                cardAmount: "0",
                                                currency: _groupCurrency,
                                                dueDate: "14 Apr 20",
                                                contributionName:
                                                    "Monthly Savings",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 26.0,
                                          ),
                                          Container(
                                            width: 160.0,
                                            padding: EdgeInsets.all(16.0),
                                            decoration: cardDecoration(
                                                gradient:
                                                    plainCardGradient(context),
                                                context: context),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: contributionSummary(
                                                color: primaryColor,
                                                cardIcon: Feather.bar_chart,
                                                amountDue: "0",
                                                cardAmount: "0",
                                                currency: _groupCurrency,
                                                dueDate: "4 Apr 20",
                                                contributionName: "Welfare",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 26.0,
                                          ),
                                          Container(
                                            width: 160.0,
                                            padding: EdgeInsets.all(16.0),
                                            decoration: cardDecoration(
                                                gradient:
                                                    plainCardGradient(context),
                                                context: context),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: contributionSummary(
                                                color: Colors.blueGrey,
                                                cardIcon: Feather.bar_chart_2,
                                                amountDue: "0",
                                                cardAmount: "0",
                                                currency: _groupCurrency,
                                                dueDate: "14 Apr 20",
                                                contributionName: "Insurance",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16.0,
                                          ),
                                        ],
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.0),
                                  decoration: flatGradient(context),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        customIcons['no-data'],
                                        semanticsLabel: 'icon',
                                        height: 120.0,
                                      ),
                                      customTitleWithWrap(
                                          text: "Nothing to display!",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.0,
                                          textAlign: TextAlign.center,
                                          color: Colors.blueGrey[400]),
                                      customTitleWithWrap(
                                          text:
                                              "Sorry, you haven't made any contributions",
                                          //fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                          textAlign: TextAlign.center,
                                          color: Colors.blueGrey[400])
                                    ],
                                  )),
                            ),
                      if (_onlineBankingEnabled)
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                          child: Container(
                            // width: 260, //TODO: Remove this when you uncomment the 'APPLY LOAD' button below
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            color: Theme.of(context).cardColor.withOpacity(0.1),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: paymentActionButton(
                                      color: primaryColor,
                                      textColor: primaryColor,
                                      icon: FontAwesome.chevron_right,
                                      isFlat: false,
                                      text: "PAY NOW",
                                      iconSize: 12.0,
                                      action: () => _openPayNowTray(context),
                                    ),
                                  ),
                                ),
                                // Expanded(
                                //   child: Padding(
                                //     padding: EdgeInsets.symmetric(
                                //       horizontal: 16.0,
                                //     ),
                                //     child: paymentActionButton(
                                //       color: primaryColor,
                                //       textColor: Colors.white,
                                //       icon: FontAwesome.chevron_right,
                                //       isFlat: true,
                                //       text: "APPLY LOAN",
                                //       iconSize: 12.0,
                                //       action: () => Navigator.of(context).push(
                                //         MaterialPageRoute(
                                //           builder: (BuildContext context) =>
                                //               ApplyLoan(),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          20.0,
                          0.0,
                          16.0,
                          0.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Recent Transactions",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Feather.more_horizontal,
                                  color: Colors.blueGrey,
                                ),
                                onPressed: () {})
                          ],
                        ),
                      ),
                      recentTransactionSummary.length > 0
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                              child: Container(
                                height: 180.0,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 10.0),
                                  physics: BouncingScrollPhysics(),
                                  children: recentTransactionSummary.toList(),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.0),
                                  decoration: flatGradient(context),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        customIcons['no-data'],
                                        semanticsLabel: 'icon',
                                        height: 120.0,
                                      ),
                                      customTitleWithWrap(
                                          text: "Nothing to display!",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.0,
                                          textAlign: TextAlign.center,
                                          color: Colors.blueGrey[400]),
                                      customTitleWithWrap(
                                          text:
                                              "Sorry, you haven't made any transactions",
                                          //fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                          textAlign: TextAlign.center,
                                          color: Colors.blueGrey[400])
                                    ],
                                  )),
                            ),
                    ],
                  )
                : chamasoftHomeLoadingData(context: context),
          ),
        ),
      ),
    );
  }

  void _openPayNowTray(BuildContext context) {
    Future<void> _initiatePayNow(
        {int paymentFor,
        int paymentForId,
        double amount,
        String phoneNumber,
        String description}) async {
      final Map<String, dynamic> _formData = {
        "payment_for": paymentFor,
        "contribution_id": paymentForId,
        "fine_category_id": paymentForId,
        "loan_id": paymentForId,
        "description": description,
        "amount": amount,
        "phone_number": phoneNumber
      };
      try {
        await Provider.of<Groups>(context, listen: false)
            .makeGroupPayment(_formData);
        Navigator.pop(context);
      } on CustomException catch (error) {
        Navigator.pop(context);
        StatusHandler().handleStatus(context: context, error: error);
      }
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: null,
            child: PayNowSheet(_initiatePayNow),
            behavior: HitTestBehavior.opaque,
          );
        });
  }
}
