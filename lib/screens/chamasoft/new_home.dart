import 'package:carousel_slider/carousel_slider.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/svg-icons.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';
import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/screens/chamasoft/models/contribution.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/account-balances.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/contribution-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/contribution-statement.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/pay-now-sheet.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/widgets/annimationSlider.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/showCase.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:pie_chart/pie_chart.dart' as chart;
import 'package:shared_preferences/shared_preferences.dart';

class ChamasoftHome extends StatefulWidget {
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING_HOME =
      "PREFERENCES_IS_FIRST_LAUNCH_STRING_HOME";
  const ChamasoftHome(
      {Key key, this.appBarElevation, this.notificationCount, this.rateMyApp})
      : super(key: key);

  final ValueChanged<double> appBarElevation;
  final ValueChanged<double> notificationCount;
  final RateMyApp rateMyApp;

  @override
  State<ChamasoftHome> createState() => _ChamasoftHomeState();
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
  Dashboard dashboardData;
  List<BankAccountDashboardSummary> _iteratableData = [];

  List<ActiveLoan> _activeLoans = [];

  int _currentIndex = 0;

  List cardList = [
    Contrubutions(),
    Fines(),
    Balances(),
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  BuildContext homeContext;

  final meetingsBannarKey = GlobalKey();
  final totalBalanceKey = GlobalKey();
  final contributionSummayKey = GlobalKey();
  final recentTransactionKey = GlobalKey();
  final payNowButtonKey = GlobalKey();

  final contributionsSummaryKey = GlobalKey();
  final accountBalanceKey = GlobalKey();
  final groupLoanKey = GlobalKey();
  final withdrwalDepositKey = GlobalKey();
  BuildContext groupContext;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController _chartScrollController;

  void _scrollListener() {
    widget.appBarElevation(_scrollController.offset);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _scrollChartToEnd();
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
    _getMemberDashboardDataNew();
    // if (_isInit)
    //   WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    // _getMemberDashboardData();
    // _getGroupDashboardData();
    //}
    _groupCurrency = _currentGroup.groupCurrency;
    // _meetingsBannerStatus();
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacementNamed(MyGroups.namedRoute);
    return null;
  }

  Future<void> _getMemberDashboardDataNew([bool hardRefresh = false]) async {
    try {
      if (hardRefresh) {
        Provider.of<Dashboard>(context, listen: false)
            .resetMemberDashboardData(_currentGroup.groupId);

        Provider.of<Dashboard>(context, listen: false)
            .resetGroupDashboardData(_currentGroup.groupId);

        // Provider.of(context, listen: false).fetchMemberLoans();
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
            .getMemberDashboardData(_currentGroup.groupId)
            .then((_) => {
                  setState(() {
                    dashboardData =
                        Provider.of<Dashboard>(context, listen: false);
                    // WidgetsBinding.instance.addPostFrameCallback((_) => () {
                    print("inside here ${dashboardData.notificationCount}");
                    widget.notificationCount(dashboardData.notificationCount);
                    // });
                  })
                });
      }
      if (!Provider.of<Dashboard>(context, listen: false)
          .groupDataExists(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<Dashboard>(context, listen: false)
            .getGroupDashboardData(_currentGroup.groupId);
        getChartData();
      }

      // if(!Provider.of<Groups>(context, listen:false).fetchMemberLoans()){

      // }

      // if (!Provider.of<Groups>(context, listen: false).fetchMemberLoans()) {
      //   if (this.mounted) {
      //     if (_isInit == false) {
      //       setState(() {
      //         _isInit = true;
      //       });
      //     }
      //   }
      //   await Provider.of<Groups>(context, listen: false).fetchMemberLoans();

      //   _fetchData();
      // }
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getMemberDashboardDataNew();
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

  // Future<void> _getMemberLoan(BuildContext context,
  //     [bool hardRefresh = false]) async {
  //   try {
  //     await Provider.of(context, listen: false).fetchMemberLoans();
  //   } on CustomException catch (error) {
  //     StatusHandler().handleStatus(
  //         context: context,
  //         error: error,
  //         callback: () {
  //           _getMemberLoan(context);
  //         },
  //         scaffoldState: _scaffoldKey.currentState);
  //   }
  // }

  // Future<bool> _fetchData() async {
  //   _activeLoans = Provider.of<Groups>(context, listen: false).getMemberLoans;
  //   _getMemberLoan(context).then((_) {
  //     _activeLoans = Provider.of<Groups>(context, listen: false).getMemberLoans;
  //   });

  //   _isInit = false;
  //   return true;
  // }

  // Future<void> _getMemberDashboardData([bool hardRefresh = false]) async {
  //   try {
  //     if (hardRefresh) {
  //       Provider.of<Dashboard>(context, listen: false)
  //           .resetMemberDashboardData(_currentGroup.groupId);
  //     }
  //     if (!Provider.of<Dashboard>(context, listen: false)
  //         .memberGroupDataExists(_currentGroup.groupId)) {
  //       if (this.mounted) {
  //         if (_isInit == false) {
  //           setState(() {
  //             _isInit = true;
  //           });
  //         }
  //       }
  //       await Provider.of<Dashboard>(context, listen: false)
  //           .getMemberDashboardData(_currentGroup.groupId)
  //           .then((_) => {
  //                 setState(() {
  //                   dashboardData =
  //                       Provider.of<Dashboard>(context, listen: false);
  //                   // WidgetsBinding.instance.addPostFrameCallback((_) => () {
  //                   print("inside here ${dashboardData.notificationCount}");
  //                   widget.notificationCount(dashboardData.notificationCount);
  //                   // });
  //                 })
  //               });
  //     }
  //   } on CustomException catch (error) {
  //     StatusHandler().handleStatus(
  //         context: context,
  //         error: error,
  //         callback: () {
  //           _getMemberDashboardData();
  //         });
  //   } finally {
  //     if (this.mounted) {
  //       setState(() {
  //         _isInit = false;
  //         _onlineBankingEnabled = _currentGroup.onlineBankingEnabled;
  //       });
  //     }
  //   }
  // }

  //  Future<void> _getGroupDashboardData([bool hardRefresh = false]) async {
  //   try {
  //     if (hardRefresh) {
  //       Provider.of<Dashboard>(context, listen: false)
  //           .resetGroupDashboardData(_currentGroup.groupId);
  //     }
  //     if (!Provider.of<Dashboard>(context, listen: false)
  //         .groupDataExists(_currentGroup.groupId)) {
  //       if (this.mounted) {
  //         if (_isInit == false) {
  //           setState(() {
  //             _isInit = true;
  //           });
  //         }
  //       }
  //       await Provider.of<Dashboard>(context, listen: false)
  //           .getGroupDashboardData(_currentGroup.groupId);
  //       getChartData();
  //     }
  //   } on CustomException catch (error) {
  //     StatusHandler().handleStatus(
  //         context: context,
  //         error: error,
  //         callback: () {
  //           _getGroupDashboardData();
  //         });
  //   } finally {
  //     if (this.mounted) {
  //       setState(() {
  //         _isInit = false;
  //       });
  //     }
  //   }
  // }

  void _scrollChartToEnd() {
    _chartScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chartScrollController.animateTo(
        _chartScrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.ease,
      );
      //     .then((value) async {
      //   await Future.delayed(Duration(seconds: 2));
      //   _chartScrollController.animateTo(
      //     _chartScrollController.position.minScrollExtent,
      //     duration: Duration(seconds: 1),
      //     curve: Curves.ease,
      //   );
      // });
    });
  }

  Future<void> getChartData() async {
    try {
      await Provider.of<Dashboard>(context, listen: false)
          .getGroupDepositVWithdrawals(_currentGroup.groupId);
      _scrollChartToEnd();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            getChartData();
          });
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

  Iterable<Widget> get accountSummary sync* {
    for (var data in _iteratableData) {
      yield Row(
        children: <Widget>[
          Container(
            width: 160.0,
            height: 165.0,
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(0.0),
            decoration: cardDecoration(
                gradient: plainCardGradient(context), context: context),
            child: accountBalance(
              color: primaryColor,
              cardIcon: Feather.credit_card,
              cardAmount: currencyFormat.format(data.balance),
              currency: _groupCurrency,
              accountName: data.accountName,
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
        ],
      );
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

  @override
  Widget build(BuildContext context) {
    final dashboardData = Provider.of<Dashboard>(context);

    setState(() {
      _iteratableRecentTransactionSummary =
          dashboardData.recentMemberTransactions;
      _iteratableData = dashboardData.bankAccountDashboardSummary;
      _itableContributionSummary = dashboardData.memberContributionSummary;
      WidgetsBinding.instance.addPostFrameCallback((_) => () {
            widget.notificationCount(dashboardData.notificationCount);
          });
    });
    return WillPopScope(
        onWillPop: _onWillPop,
        child: RefreshIndicator(
          backgroundColor: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Colors.white,
          onRefresh: () => _getMemberDashboardDataNew(true),
          child: SafeArea(
              child: SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: !_isInit
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          "Make Payments",
                          style: TextStyle(
                            color: Colors.blueGrey[400],
                            fontFamily: 'SegoeUI',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (_onlineBankingEnabled)
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /*  Expanded(
                                child: */
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  circleIconButton(
                                    icon: Icons.import_export,
                                    backgroundColor:
                                        primaryColor /* rimaryColor.withOpacity(.3) */,
                                    color: Colors.white,
                                    iconSize: 24.0,
                                    padding: 0.0,
                                    onPressed: () => _openPayNowTray(context),
                                  ),
                                  SizedBox(height: 10),
                                  customTitle1(
                                    text: 'Make Payment',
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionHandleColor,
                                    textAlign: TextAlign.start,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              /*  ), */
                              // SizedBox(width: 100),
                              // Expanded(
                              //   child: Column(
                              //     children: [
                              //       circleIconButton(
                              //         icon: Icons.credit_card,
                              //         backgroundColor:
                              //             primaryColor /* rimaryColor.withOpacity(.3) */,
                              //         color: Colors.white,
                              //         iconSize: 24.0,
                              //         padding: 0.0,
                              //         onPressed:
                              //             () /*  =>
                              //               _showActions(context, incomeCategory) */
                              //             {},
                              //       ),
                              //       SizedBox(height: 10),
                              //       customTitle1(
                              //         text: 'Apply Loan',
                              //         color: Theme.of(context)
                              //             // ignore: deprecated_member_use
                              //             .textSelectionHandleColor,
                              //         textAlign: TextAlign.start,
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          "Transactional Summary",
                          style: TextStyle(
                            color: Colors.blueGrey[400],
                            fontFamily: 'SegoeUI',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: cardDecoration(
                            gradient: plainCardGradient(context),
                            context: context,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: 175.0,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 10),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 1000),
                                  autoPlayCurve: Curves.easeInCirc,
                                  pauseAutoPlayOnTouch: true,
                                  aspectRatio: 2.0,
                                  initialPage: 0,
                                  viewportFraction: 1.0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                ),
                                items: cardList.map((card) {
                                  return Builder(
                                      builder: (BuildContext context) {
                                    return Container(
                                      // height:
                                      //     MediaQuery.of(context).size.height *
                                      //         0.70,
                                      width: MediaQuery.of(context).size.width,
                                      // child: Card(
                                      child: card,
                                      //),
                                    );
                                  });
                                }).toList(),
                              ),

                              SizedBox(
                                height: 5,
                              ),
                              customSlider(
                                  context: context,
                                  count: cardList,
                                  index: _currentIndex)
                              // animationSlider(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Balances",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            plainButtonWithArrow(
                                text: "View All",
                                size: 16.0,
                                spacing: 2.0,
                                color: Colors.blue,
                                action: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AccountBalances()),
                                    ))
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 180.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            SizedBox(
                              width: 16.0,
                            ),
                            Container(
                              width: 160.0,
                              padding: EdgeInsets.all(16.0),
                              decoration: cardDecoration(
                                  gradient: csCardGradient(), context: context),
                              child: accountBalance(
                                color: Colors.white,
                                cardIcon: Feather.globe,
                                cardAmount: currencyFormat
                                    .format(dashboardData.totalBankBalances),
                                currency: _groupCurrency,
                                accountName: "Total",
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            _iteratableData.length > 0
                                ? Row(
                                    children: accountSummary.toList(),
                                  )
                                : Row(children: <Widget>[
                                    Container(
                                      width: 160.0,
                                      height: 165.0,
                                      padding: EdgeInsets.all(16.0),
                                      decoration: cardDecoration(
                                          gradient: plainCardGradient(context),
                                          context: context),
                                      child: accountBalance(
                                        color: primaryColor,
                                        cardIcon: Feather.credit_card,
                                        cardAmount: currencyFormat
                                            .format(dashboardData.bankBalances),
                                        currency: _groupCurrency,
                                        accountName: "Cash at Bank",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    Container(
                                      width: 160.0,
                                      height: 165.0,
                                      padding: EdgeInsets.all(16.0),
                                      decoration: cardDecoration(
                                          gradient: plainCardGradient(context),
                                          context: context),
                                      child: accountBalance(
                                        color: primaryColor,
                                        cardIcon: Feather.credit_card,
                                        cardAmount: currencyFormat
                                            .format(dashboardData.cashBalances),
                                        currency: _groupCurrency,
                                        accountName: "Cash at Hand",
                                      ),
                                    )
                                  ]),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Transactions",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            plainButtonWithArrow(
                                text: "View All",
                                size: 16.0,
                                spacing: 2.0,
                                color: Colors.blue,
                                action: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ContributionStatement()),
                                    ))
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      recentTransactionSummary.length > 0
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                              child: customShowCase(
                                key: recentTransactionKey,
                                title: 'Recent Summary',
                                description:
                                    'Scroll Horizontal to View all your recent Transactions',
                                textColor:
                                    // ignore: deprecated_member_use
                                    Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionHandleColor,
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
                : newHomePlaceHolder(context: context),
            // : homePlaceholder(context: context),
            // : dataLoadingEffect(
            //     context: context,
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height),
          )),
        ));
  }

  // customSlider({BuildContext context, count, index}) {}
}

class Contrubutions extends StatelessWidget {
  final List<ContributionsSummary> itableContributionSummary;
  const Contrubutions({this.itableContributionSummary, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dashboard dashboardData = Provider.of<Dashboard>(context);
    final currencyFormat = new NumberFormat("#,##0", "en_US");
    Group _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    print('Group Conribution is ${dashboardData.groupContributionAmount}');
    print('Group Dashboard Data is ${dashboardData.groupDashboardData}');
    print('Group Fine  is ${dashboardData.groupFinePaymentAmount}');
    print('Group Loaned Amount is ${dashboardData.groupLoanedAmount}');
    print('Group Loan Paid is ${dashboardData.groupLoanPaid}');

    print('Group Name is ${_currentGroup.groupName}');
    print('Group ID is ${_currentGroup.groupId}');

    // ContributionsSummary contributionsSummary;

    // List<ContributionsSummary> _itableContributionSummary = [];
    // _itableContributionSummary =
    //     Provider.of<Dashboard>(context, listen: true).memberContributionSummary;

    // ContributionsSummary contributionsSum =
    //     _itableContributionSummary[];

    // String contributionDate =
    //      dashboardData.memberDetails["next_contribution_date"].toString();

    // ContributionsSummary contributionsSummary =
    //     _itableContributionSummary as ContributionsSummary;

    // final data = dashboardData.memberContributionSummary.map((item) => [
    //       item.balance,
    //     ]);

    // final contributionsSummary = Provider.of<ContributionsSummary>(context);

    // final dueDates = _itableContributionSummary.singleWhere((i) => i == "dueDate");

    Map<String, double> dataMap = {
      "My Total Contribution": (_currentGroup.disableArrears
          ? dashboardData.memberContributionAmount.abs()
          : dashboardData.memberContributionArrears.abs()),
      "Group Total Contribution": dashboardData.groupContributionAmount.abs(),
    };

    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              chart.PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                initialAngleInDegree: 0,
                ringStrokeWidth: 32,
                legendOptions: chart.LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: chart.LegendPosition.right,
                  showLegends: false,
                  legendTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor),
                ),
                chartValuesOptions: chart.ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "My Total Contribution",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontFamily: 'SegoeUI',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      circleButton(
                        backgroundColor:
                            dashboardData.memberContributionAmount > 0
                                ? Colors.redAccent
                                : Colors
                                    .white /* rimaryColor.withOpacity(.3) */,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      customTitle1(
                        text: _currentGroup.disableArrears
                            ? _currentGroup.groupCurrency +
                                " " +
                                currencyFormat.format(
                                    dashboardData.memberContributionAmount)
                            : _currentGroup.groupCurrency +
                                " " +
                                currencyFormat.format(
                                    dashboardData.memberContributionArrears),
                        color: (dashboardData.memberContributionArrears) > 0
                            ? Colors.red[400]
                            : Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                        textAlign: TextAlign.start,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Group Total Contribution",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontFamily: 'SegoeUI',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(children: [
                    circleButton(
                      backgroundColor: dashboardData.groupPendingLoanBalance > 0
                          ? primaryColor
                          : Colors.white /* rimaryColor.withOpacity(.3) */,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    customTitle1(
                      color: Theme.of(context)
                          // ignore: deprecated_member_use
                          .textSelectionHandleColor,
                      text: _currentGroup.groupCurrency +
                          " " +
                          currencyFormat
                              .format(dashboardData.groupContributionAmount),
                      textAlign: TextAlign.start,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ])
                ],
              ),
            ],
          ),
          // DottedLine(
          //   direction: Axis.horizontal,
          //   lineLength: double.infinity,
          //   lineThickness: 0.5,
          //   dashLength: 2.0,
          //   dashColor: Colors.black45,
          //   dashRadius: 0.0,
          //   dashGapLength: 2.0,
          //   dashGapColor: Colors.transparent,
          //   dashGapRadius: 0.0,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     // Column(
          //     //   crossAxisAlignment: CrossAxisAlignment.start,
          //     //   children: [
          //     //     Text(
          //     //       "Next Conribution",
          //     //       style: TextStyle(
          //     //         color: Colors.blueGrey[400],
          //     //         fontFamily: 'SegoeUI',
          //     //         fontSize: 14.0,
          //     //         fontWeight: FontWeight.w800,
          //     //       ),
          //     //     ),
          //     //     Row(
          //     //       children: [
          //     //         customTitle1(
          //     //           text: "KES 100,000",
          //     //           textAlign: TextAlign.start,
          //     //           fontSize: 14,
          //     //           fontWeight: FontWeight.w400,
          //     //           color: Theme.of(context)
          //     //               // ignore: deprecated_member_use
          //     //               .textSelectionHandleColor,
          //     //         ),
          //     //         SizedBox(
          //     //           width: 20,
          //     //         ),
          //     //         customTitle1(
          //     //           text: contributionsSummary.dueDate,
          //     //           textAlign: TextAlign.start,
          //     //           fontSize: 14,
          //     //           fontWeight: FontWeight.w400,
          //     //           color: Theme.of(context)
          //     //               // ignore: deprecated_member_use
          //     //               .textSelectionHandleColor,
          //     //         ),
          //     //       ],
          //     //     )
          //     //   ],
          //     // ),
          //     buttonWithArrow(
          //         text: "Pay Now",
          //         size: 14.0,
          //         spacing: 2.0,
          //         color: Colors.white,
          //         action: () => _openPayNowTray(context))
          //   ],
          // ),
        ],
      ),
    );
  }
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

class Fines extends StatelessWidget {
  const Fines({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Dashboard dashboardData = Provider.of<Dashboard>(context);

    final currencyFormat = new NumberFormat("#,##0", "en_US");
    Group _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    Map<String, double> dataMap = {
      "Your Fines": (_currentGroup.disableArrears
          ? dashboardData.memberFineAmount.abs()
          : dashboardData.memberFineArrears.abs()),
      "Group Fines": dashboardData.groupFinePaymentAmount.abs(),
    };
    return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(children: [
          Row(
            children: [
              chart.PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                initialAngleInDegree: 0,
                ringStrokeWidth: 32,
                legendOptions: chart.LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: chart.LegendPosition.right,
                  showLegends: false,
                  legendTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor),
                ),
                chartValuesOptions: chart.ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total Fines",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontFamily: 'SegoeUI',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      circleButton(
                        backgroundColor: dashboardData.memberFineArrears.abs() >
                                0
                            ? Colors.redAccent
                            : Colors.white /* rimaryColor.withOpacity(.3) */,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      customTitle1(
                        text: _currentGroup.disableArrears
                            ? _currentGroup.groupCurrency +
                                " " +
                                currencyFormat
                                    .format(dashboardData.memberFineAmount)
                            : _currentGroup.groupCurrency +
                                " " +
                                currencyFormat
                                    .format(dashboardData.memberFineArrears),
                        color: (dashboardData.memberFineArrears) > 0
                            ? Colors.red[400]
                            : Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                        textAlign: TextAlign.start,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Group Total Fines",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontFamily: 'SegoeUI',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      circleButton(
                        backgroundColor:
                            dashboardData.groupFinePaymentAmount > 0
                                ? primaryColor
                                : Colors.white
                        // backgroundColor:
                        /* rimaryColor.withOpacity(.3) */,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      customTitle1(
                        color: Theme.of(context)
                            // ignore: deprecated_member_use
                            .textSelectionHandleColor,
                        text: _currentGroup.groupCurrency +
                            " " +
                            currencyFormat
                                .format(dashboardData.groupFinePaymentAmount),
                        textAlign: TextAlign.start,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // DottedLine(
          //   direction: Axis.horizontal,
          //   lineLength: double.infinity,
          //   lineThickness: 0.5,
          //   dashLength: 2.0,
          //   dashColor: Colors.black45,
          //   dashRadius: 0.0,
          //   dashGapLength: 2.0,
          //   dashGapColor: Colors.transparent,
          //   dashGapRadius: 0.0,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     // Column(
          //     //   crossAxisAlignment: CrossAxisAlignment.start,
          //     //   children: [
          //     //     Text(
          //     //       "Pending Fines",
          //     //       style: TextStyle(
          //     //         color: Colors.blueGrey[400],
          //     //         fontFamily: 'SegoeUI',
          //     //         fontSize: 14.0,
          //     //         fontWeight: FontWeight.w800,
          //     //       ),
          //     //     ),
          //     //     Row(
          //     //       children: [
          //     //         customTitle1(
          //     //           text: "KES 500",
          //     //           textAlign: TextAlign.start,
          //     //           fontSize: 14,
          //     //           fontWeight: FontWeight.w400,
          //     //           color: Theme.of(context)
          //     //               // ignore: deprecated_member_use
          //     //               .textSelectionHandleColor,
          //     //         ),
          //     //         SizedBox(
          //     //           width: 20,
          //     //         ),
          //     //         customTitle1(
          //     //           text: "Due: 14TH May, 2022",
          //     //           textAlign: TextAlign.start,
          //     //           fontSize: 14,
          //     //           fontWeight: FontWeight.w400,
          //     //           color: Theme.of(context)
          //     //               // ignore: deprecated_member_use
          //     //               .textSelectionHandleColor,
          //     //         ),
          //     //       ],
          //     //     )
          //     //   ],
          //     // ),
          //     buttonWithArrow(
          //         text: "More Details",
          //         size: 14.0,
          //         spacing: 2.0,
          //         color: Colors.white,
          //         action: () => _openPayNowTray(context))
          //   ],
          // ),
        ]));
  }
}

class Balances extends StatelessWidget {
  final ActiveLoan loan;
  const Balances({Key key, this.loan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dashboard dashboardData = Provider.of<Dashboard>(context);

    final currencyFormat = new NumberFormat("#,##0", "en_US");

    Group _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    Map<String, double> dataMap = {
      "Your Loan Balances": (dashboardData.memberTotalLoanBalance.abs()),
      "Group Loan Balances": dashboardData.groupPendingLoanBalance.abs(),
    };

    return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(children: [
          Row(
            children: [
              chart.PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                initialAngleInDegree: 0,
                ringStrokeWidth: 32,
                legendOptions: chart.LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: chart.LegendPosition.right,
                  showLegends: false,
                  legendTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor),
                ),
                chartValuesOptions: chart.ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "My Loan Balances",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontFamily: 'SegoeUI',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      circleButton(
                        backgroundColor: dashboardData.memberTotalLoanBalance >
                                0
                            ? Colors.redAccent
                            : Colors.white /* rimaryColor.withOpacity(.3) */,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      customTitle1(
                        text: _currentGroup.disableArrears
                            ? _currentGroup.groupCurrency +
                                " " +
                                currencyFormat.format(
                                    dashboardData.memberTotalLoanBalance)
                            : _currentGroup.groupCurrency +
                                " " +
                                currencyFormat.format(
                                    dashboardData.memberTotalLoanBalance),
                        color: Theme.of(context)
                            // ignore: deprecated_member_use
                            .textSelectionHandleColor,
                        textAlign: TextAlign.start,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Group Loan Balances",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontFamily: 'SegoeUI',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      circleButton(
                        backgroundColor: dashboardData.groupPendingLoanBalance >
                                0
                            ? primaryColor
                            : Colors.white /* rimaryColor.withOpacity(.3) */,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      customTitle1(
                        color: Theme.of(context)
                            // ignore: deprecated_member_use
                            .textSelectionHandleColor,
                        text: _currentGroup.groupCurrency +
                            " " +
                            currencyFormat
                                .format(dashboardData.groupPendingLoanBalance),
                        textAlign: TextAlign.start,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // DottedLine(
          //   direction: Axis.horizontal,
          //   lineLength: double.infinity,
          //   lineThickness: 0.5,
          //   dashLength: 2.0,
          //   dashColor: Colors.black45,
          //   dashRadius: 0.0,
          //   dashGapLength: 2.0,
          //   dashGapColor: Colors.transparent,
          //   dashGapRadius: 0.0,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     // Column(
          //     //   crossAxisAlignment: CrossAxisAlignment.start,
          //     //   children: [
          //     //     Text(
          //     //       "Next Loan Repayment",
          //     //       style: TextStyle(
          //     //         color: Colors.blueGrey[400],
          //     //         fontFamily: 'SegoeUI',
          //     //         fontSize: 14.0,
          //     //         fontWeight: FontWeight.w800,
          //     //       ),
          //     //     ),
          //     //     Row(
          //     //       children: [
          //     //         customTitle1(
          //     //           text:dashboardData.member,
          //     //           textAlign: TextAlign.start,
          //     //           fontSize: 14,
          //     //           fontWeight: FontWeight.w400,
          //     //           color: Theme.of(context)
          //     //               // ignore: deprecated_member_use
          //     //               .textSelectionHandleColor,
          //     //         ),
          //     //         SizedBox(
          //     //           width: 20,
          //     //         ),
          //     //         customTitle1(
          //     //           text: "14TH May, 2022",
          //     //           textAlign: TextAlign.start,
          //     //           fontSize: 14,
          //     //           fontWeight: FontWeight.w400,
          //     //           color: Theme.of(context)
          //     //               // ignore: deprecated_member_use
          //     //               .textSelectionHandleColor,
          //     //         ),
          //     //       ],
          //     //     )
          //     //   ],
          //     // ),
          //     buttonWithArrow(
          //         text: "More Details",
          //         size: 14.0,
          //         spacing: 2.0,
          //         color: Colors.white,
          //         action: () => _openPayNowTray(context))
          //   ],
          // ),
        ]));
  }
}
