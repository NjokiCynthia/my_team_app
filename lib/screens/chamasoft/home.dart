import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/pay-now.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'dart:async';

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
  bool _isLoading = true;
  String _groupCurrency = "Ksh";

  void _scrollListener() {
    widget.appBarElevation(_scrollController.offset);
  }

  void _doneLoading(){
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 3), _doneLoading);
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
  void didChangeDependencies(){
    _currentGroup = Provider.of<Groups>(context,listen:false).getCurrentGroup();
    if(_isInit){
      _getMemberDashboardData(_currentGroup.groupId);
    }
    setState(() {
      _onlineBankingEnabled = _currentGroup.onlineBankingEnabled;
    });    
    _groupCurrency = _currentGroup.groupCurrency;
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacementNamed(MyGroups.namedRoute);
    return null;
  }

  void _getMemberDashboardData(String currentGroupId)async{
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
    try{
      await Provider.of<Dashboard>(context,listen:false).getMemberDashboardData(currentGroupId);
    }on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getMemberDashboardData(currentGroupId);
          });
    } finally {
      setState(() {
        _isInit = false;
      });
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = Provider.of<Dashboard>(context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: !_isLoading ? Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Total Balances",
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
                          color: Theme.of(context).hintColor.withOpacity(0.1),
                          thickness: 2.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            customTitle(
                              text: "Contributions",
                              textAlign: TextAlign.start,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
                            SizedBox(
                              height: 22,
                              child: cardAmountButton(
                                  currency: _groupCurrency,
                                  amount: currencyFormat.format(dashboardData.memberContributionArrears),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            customTitle(
                              text: "Fines",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
                            SizedBox(
                              height: 22,
                              child: cardAmountButton(
                                  currency: _groupCurrency,
                                  amount: currencyFormat.format(dashboardData.memberFineArrears),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            customTitle(
                              text: "Loans",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
                            SizedBox(
                              height: 22,
                              child: cardAmountButton(
                                  currency: _groupCurrency,
                                  amount: currencyFormat.format(dashboardData.memberTotalLoanBalance),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            customTitle(
                              text: "Pending Loan Balance",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
                            SizedBox(
                              height: 22,
                              child: cardAmountButton(
                                  currency: _groupCurrency,
                                  amount: currencyFormat.format(dashboardData.memberLoanArrears),
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
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 16.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Contribution Summary",
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
                              gradient: csCardGradient(), context: context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: contributionSummary(
                              color: Colors.white,
                              cardIcon: Feather.bar_chart_2,
                              amountDue: "7,500",
                              cardAmount: "10,050",
                              currency: _groupCurrency,
                              dueDate: "14 Apr 20",
                              contributionName: "Monthly Savings",
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
                              gradient: plainCardGradient(context),
                              context: context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: contributionSummary(
                              color: primaryColor,
                              cardIcon: Feather.bar_chart,
                              amountDue: "4,050",
                              cardAmount: "4,050",
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
                              gradient: plainCardGradient(context),
                              context: context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: contributionSummary(
                              color: Colors.blueGrey,
                              cardIcon: Feather.bar_chart_2,
                              amountDue: "7,500",
                              cardAmount: "10,050",
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
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    color: Theme.of(context).cardColor.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if(_onlineBankingEnabled)
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
                              action: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => PayNow(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: paymentActionButton(
                              color: primaryColor,
                              textColor: Colors.white,
                              icon: FontAwesome.chevron_right,
                              isFlat: true,
                              text: "APPLY LOAN",
                              iconSize: 12.0,
                              action: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ApplyLoan(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
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
                              gradient: plainCardGradient(context),
                              context: context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: contributionSummary(
                              color: Colors.blueGrey,
                              cardIcon: Feather.pie_chart,
                              amountDue: "1,500",
                              cardAmount: "1,500",
                              currency: _groupCurrency,
                              dueDate: "14 Apr 20",
                              contributionName: "Contribution Payment",
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
                              gradient: plainCardGradient(context),
                              context: context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: contributionSummary(
                              color: primaryColor,
                              cardIcon: Feather.bar_chart_2,
                              amountDue: "10,050",
                              cardAmount: "4,050",
                              currency: _groupCurrency,
                              dueDate: "4 Apr 20",
                              contributionName: "Loan Repayment",
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
                              gradient: plainCardGradient(context),
                              context: context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: contributionSummary(
                              color: Colors.blueGrey,
                              cardIcon: Feather.bar_chart_2,
                              amountDue: "10,050",
                              cardAmount: "4,050",
                              currency: _groupCurrency,
                              dueDate: "4 Apr 20",
                              contributionName: "Loan Repaymentfhghgh",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ) : chamasoftHomeLoadingData(context: context)
          )
        ));
  }
}
