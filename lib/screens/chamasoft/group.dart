import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/deposits-v-withdrawals.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/meetings/meetings.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/svg-icons.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import 'models/group-model.dart';

class ChamasoftGroup extends StatefulWidget {
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

  void _scrollListener() {
    widget.appBarElevation(_scrollController.offset);
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

  @override
  Widget build(BuildContext context) {
    final dashboardData = Provider.of<Dashboard>(context);
    setState(() {
      _iteratableData = dashboardData.bankAccountDashboardSummary;
    });
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: RefreshIndicator(
          onRefresh: () => _getGroupDashboardData(true),
          child: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: !_isInit
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
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
                                          .textSelectionHandleColor,
                                    ),
                                    SizedBox(
                                      height: 22,
                                      child: cardAmountButton(
                                          currency: _groupCurrency,
                                          amount: currencyFormat.format(
                                              dashboardData
                                                  .groupContributionAmount),
                                          size: 16.0,
                                          color: Theme.of(context)
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
                                      text: "Total Fine Payments",
                                      textAlign: TextAlign.start,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                    ),
                                    SizedBox(
                                      height: 22,
                                      child: cardAmountButton(
                                          currency: _groupCurrency,
                                          amount: currencyFormat.format(
                                              dashboardData
                                                  .groupFinePaymentAmount),
                                          size: 16.0,
                                          color: Theme.of(context)
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
                                      text: "Group Expenses",
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
                                                  .groupExpensesAmount),
                                          size: 14.0,
                                          color: Colors.red[400],
                                          action: () {}),
                                    ),
                                  ],
                                ),
                              ],
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
                                  onPressed: () {})
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                          child: Container(
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
                                              gradient:
                                                  plainCardGradient(context),
                                              context: context),
                                          child: accountBalance(
                                            color: primaryColor,
                                            cardIcon: Feather.credit_card,
                                            cardAmount: currencyFormat.format(
                                                dashboardData.bankBalances),
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
                                              gradient:
                                                  plainCardGradient(context),
                                              context: context),
                                          child: accountBalance(
                                            color: primaryColor,
                                            cardIcon: Feather.credit_card,
                                            cardAmount: currencyFormat.format(
                                                dashboardData.cashBalances),
                                            currency: _groupCurrency,
                                            accountName: "Cash at Hand",
                                          ),
                                        )
                                      ]),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
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
                                          .textSelectionHandleColor,
                                    ),
                                    SizedBox(
                                      height: 22,
                                      child: cardAmountButton(
                                          currency: _groupCurrency,
                                          amount: currencyFormat.format(
                                              dashboardData.groupLoanedAmount),
                                          size: 16.0,
                                          color: Theme.of(context)
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
                                      text: "Total Repaid",
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
                                              dashboardData.groupLoanPaid),
                                          size: 14.0,
                                          color: Theme.of(context)
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
                                      text: "Pending Loan Balance",
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
                                                  .groupPendingLoanBalance),
                                          size: 14.0,
                                          color: Theme.of(context)
                                              .textSelectionHandleColor,
                                          action: () {}),
                                    ),
                                  ],
                                ),
                              ],
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
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: cardDecoration(
                              gradient: plainCardGradient(context),
                              context: context,
                            ),
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
                                  scrollDirection: Axis.horizontal,
                                  child: DepositsVWithdrawals(),
                                )
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
                                "Group Meetings",
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            16.0,
                            10.0,
                            16.0,
                            20.0,
                          ),
                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.0),
                              decoration: flatGradient(context),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    customIcons['no-data'],
                                    semanticsLabel: 'icon',
                                    height: 80.0,
                                  ),
                                  customTitleWithWrap(
                                    text: "Nothing to display!",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                    textAlign: TextAlign.center,
                                    color: Colors.blueGrey[400],
                                  ),
                                  customTitleWithWrap(
                                    text: "Your group hasn't had any meetings",
                                    //fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    textAlign: TextAlign.center,
                                    color: Colors.blueGrey[400],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  defaultButton(
                                    context: context,
                                    text: "Manage Meetings",
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Meetings(),
                                        settings: RouteSettings(arguments: 0),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    )
                  : chamasoftGroupLoadingData(context: context),
            ),
          ),
        ));
  }
}
