import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/account_balances.dart';
import 'package:chamasoft/screens/chamasoft/deposits-v-withdrawals.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/account-balances.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/contribution-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/expense-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/group-loans-summary.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
// import 'package:chamasoft/helpers/svg-icons.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/screens/chamasoft/total_account_balance.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/showCase.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'models/group-model.dart';

class ChamasoftGroup extends StatefulWidget {
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING_GROUP =
      "PREFERENCES_IS_FIRST_LAUNCH_STRING_GROUP";
  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftGroupState createState() => _ChamasoftGroupState();
  ChamasoftGroup({this.appBarElevation});
}

class _ChamasoftGroupState extends State<ChamasoftGroup> {
  ScrollController _scrollController;
  ScrollController _chartScrollController;
  List<BankAccountDashboardSummary> _iteratableData = [];
  String _groupCurrency = "Ksh";
  Group _currentGroup;
  bool _isInit = true;

  final contributionsSummaryKey = GlobalKey();
  final accountBalanceKey = GlobalKey();
  final groupLoanKey = GlobalKey();
  final withdrwalDepositKey = GlobalKey();
  BuildContext groupContext;

  void _scrollListener() {
    widget.appBarElevation(_scrollController.offset);
  }

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

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _scrollChartToEnd();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _isFirstLaunch().then((result) {
    //     if (result)
    //       ShowCaseWidget.of(groupContext).startShowCase([
    //         contributionsSummaryKey,
    //         accountBalanceKey,
    //         groupLoanKey,
    //         withdrwalDepositKey
    //       ]);
    //   });
    // });

    super.initState();
  }

  // ignore: unused_element
  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = sharedPreferences
            .getBool(ChamasoftGroup.PREFERENCES_IS_FIRST_LAUNCH_STRING_GROUP) ??
        true;

    if (isFirstLaunch)
      sharedPreferences.setBool(
          ChamasoftGroup.PREFERENCES_IS_FIRST_LAUNCH_STRING_GROUP, false);

    return isFirstLaunch;
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    _chartScrollController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    //if(_isInit){
    _getGroupDashboardData();
    //}
    _groupCurrency = _currentGroup.groupCurrency;
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context)
        .pushReplacementNamed(ChamasoftDashboard.namedRoute);
    return null;
  }

  Future<void> _getGroupDashboardData([bool hardRefresh = false]) async {
    try {
      if (hardRefresh) {
        Provider.of<Dashboard>(context, listen: false)
            .resetGroupDashboardData(_currentGroup.groupId);
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
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getGroupDashboardData();
          });
    } finally {
      if (this.mounted) {
        setState(() {
          _isInit = false;
        });
      }
    }
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

  Iterable<Widget> get accountSummary sync* {
    for (var data in _iteratableData) {
      yield Row(
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AccounBalancesReciept(data: data)),
            ),
            child: Container(
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
          ),
          SizedBox(
            width: 16.0,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = Provider.of<Dashboard>(context);
    setState(() {
      _iteratableData = dashboardData.bankAccountDashboardSummary;
    });

    return ShowCaseWidget(builder: Builder(builder: (context) {
      groupContext = context;

      return new WillPopScope(
          onWillPop: _onWillPop,
          child: RefreshIndicator(
            backgroundColor: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Colors.white,
            onRefresh: () => _getGroupDashboardData(true),
            child: SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                child: !_isInit
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                            child: customShowCase(
                              key: contributionsSummaryKey,
                              description:
                                  "View Group contributions and expenses summary here",
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: cardDecoration(
                                    gradient: plainCardGradient(context),
                                    context: context),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        customTitle(
                                          text: "Contributions & Expenses",
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
                                          text: "All Group Contributions",
                                          textAlign: TextAlign.start,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor,
                                        ),
                                        SizedBox(
                                          height: 22,
                                          child: cardAmountButton(
                                            currency: _groupCurrency,
                                            amount: currencyFormat.format(
                                                dashboardData
                                                    .groupContributionAmount),
                                            size: 14.0,
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor,
                                            action: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ContributionSummary(),
                                                    settings: RouteSettings(
                                                        arguments:
                                                            CONTRIBUTION_STATEMENT))),
                                          ),
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
                                          text: "Total Fine Payments",
                                          textAlign: TextAlign.start,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor,
                                        ),
                                        SizedBox(
                                          height: 22,
                                          child: cardAmountButton(
                                              currency: _groupCurrency,
                                              amount: currencyFormat.format(
                                                  dashboardData
                                                      .groupFinePaymentAmount),
                                              size: 14.0,
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionHandleColor,
                                              action: () => Navigator.of(
                                                      context)
                                                  .push(MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ContributionSummary(),
                                                      settings: RouteSettings(
                                                          arguments:
                                                              FINE_STATEMENT)))),
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
                                          text: "Group Expenses",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor,
                                        ),
                                        SizedBox(
                                          height: 22,
                                          child: cardAmountButton(
                                            currency: _groupCurrency,
                                            amount: currencyFormat.format(
                                                dashboardData
                                                    .groupExpensesAmount),
                                            size: 14.0,
                                            color: Colors.red[400],
                                            action: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ExpenseSummary())),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 10.0, 16.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Account Balances",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Feather.more_horizontal,
                                      color: Colors.blueGrey,
                                    ),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AccountBalances(),
                                            settings:
                                                RouteSettings(arguments: 0))))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                            child: customShowCase(
                              key: accountBalanceKey,
                              description:
                                  "View accurate balances in your groups accounts.",
                              child: Container(
                                height: 180.0,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 10.0),
                                  physics: BouncingScrollPhysics(),
                                  children: <Widget>[
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    InkWell(
                                      onTap: () {}/*=> Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                TotalAccountBalanceReciept(
                                                    totalBalance: dashboardData
                                                        .totalBankBalances)),
                                      )*/,
                                      child: Container(
                                        width: 160.0,
                                        padding: EdgeInsets.all(16.0),
                                        decoration: cardDecoration(
                                            gradient: csCardGradient(),
                                            context: context),
                                        child: accountBalance(
                                          color: Colors.white,
                                          cardIcon: Feather.globe,
                                          cardAmount: currencyFormat.format(
                                              dashboardData.totalBankBalances),
                                          currency: _groupCurrency,
                                          accountName: "Total",
                                        ),
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
                                                  gradient: plainCardGradient(
                                                      context),
                                                  context: context),
                                              child: accountBalance(
                                                color: primaryColor,
                                                cardIcon: Feather.credit_card,
                                                cardAmount: currencyFormat
                                                    .format(dashboardData
                                                        .bankBalances),
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
                                                  gradient: plainCardGradient(
                                                      context),
                                                  context: context),
                                              child: accountBalance(
                                                color: primaryColor,
                                                cardIcon: Feather.credit_card,
                                                cardAmount: currencyFormat
                                                    .format(dashboardData
                                                        .cashBalances),
                                                currency: _groupCurrency,
                                                accountName: "Cash at Hand",
                                              ),
                                            )
                                          ]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                            child: customShowCase(
                              key: groupLoanKey,
                              description:
                                  "View Group Loans summary for loaned out cash, total repaid and pending loans",
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: cardDecoration(
                                    gradient: plainCardGradient(context),
                                    context: context),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Loan Balances",
                                          style: TextStyle(
                                            color: Colors.blueGrey[400],
                                            fontFamily: 'SegoeUI',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
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
                                          text: "Loaned Out",
                                          textAlign: TextAlign.start,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor,
                                        ),
                                        SizedBox(
                                          height: 22,
                                          child: cardAmountButton(
                                              currency: _groupCurrency,
                                              amount: currencyFormat.format(
                                                  dashboardData
                                                      .groupLoanedAmount),
                                              size: 16.0,
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionHandleColor,
                                              action: () => Navigator.of(
                                                      context)
                                                  .push(MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          GroupLoansSummary()))),
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
                                          text: "Total Repaid",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor,
                                        ),
                                        SizedBox(
                                          height: 22,
                                          child: cardAmountButton(
                                              currency: _groupCurrency,
                                              amount: currencyFormat.format(
                                                  dashboardData.groupLoanPaid),
                                              size: 16.0,
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionHandleColor,
                                              action: () => Navigator.of(
                                                      context)
                                                  .push(MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          GroupLoansSummary()))),
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
                                          text: "Pending Loan Balance",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor,
                                        ),
                                        SizedBox(
                                          height: 22,
                                          child: cardAmountButton(
                                              currency: _groupCurrency,
                                              amount: currencyFormat.format(
                                                  dashboardData
                                                      .groupPendingLoanBalance),
                                              size: 16.0,
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionHandleColor,
                                              action: () => Navigator.of(
                                                      context)
                                                  .push(MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          GroupLoansSummary()))),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              16.0,
                              16.0,
                              16.0,
                              16.0,
                            ),
                            child: customShowCase(
                              key: withdrwalDepositKey,
                              description:
                                  "Comparison of Groups deposits and withdrawals",
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: flatGradient(context),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Deposits Vs Withdrawals",
                                          style: TextStyle(
                                            color: Colors.blueGrey[400],
                                            fontFamily: 'SegoeUI',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
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
                                    SingleChildScrollView(
                                      controller: _chartScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: DepositsVWithdrawals(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : groupPlaceholder(context: context),
                // : dataLoadingEffect(
                //     context: context,
                //     width: MediaQuery.of(context).size.width,
                //     height: MediaQuery.of(context).size.height),

                // chamasoftGroupLoadingData(context: context),
              ),
            ),
          ));
    }));
  }
}
