import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
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
  String _groupCurrency = "Ksh";
  List<RecentTransactionSummary> _iteratableRecentTransactionSummary = [];
  List<ContributionsSummary> _itableContributionSummary = [];

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
  void didChangeDependencies(){
    _currentGroup = Provider.of<Groups>(context,listen:false).getCurrentGroup();
    //if(_isInit){
      _getMemberDashboardData();
    //}   
    _groupCurrency = _currentGroup.groupCurrency;
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacementNamed(MyGroups.namedRoute);
    return null;
  }

  Future<void> _getMemberDashboardData([bool hardRefresh=false])async{
    try{
      if(hardRefresh){
        Provider.of<Dashboard>(context,listen:false).resetMemberDashboardData(_currentGroup.groupId);
      }
      if(!Provider.of<Dashboard>(context,listen:false).memberGroupDataExists(_currentGroup.groupId)){
        if(this.mounted){
          if(_isInit == false){
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<Dashboard>(context,listen:false).getMemberDashboardData(_currentGroup.groupId);
      }
    }on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getMemberDashboardData();
          });
    } finally {
      if(this.mounted){
        setState(() {
          _isInit = false;
          //_isLoading = false;
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
                gradient: plainCardGradient(context),
                context: context),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: resetTransactions(
                color: (i%2==1)?Colors.blueGrey:primaryColor,
                paymentDescription: data.paymentTitle,
                cardAmount: currencyFormat.format(data.paymentAmount),
                currency: _groupCurrency,
                cardIcon: Feather.pie_chart,
                paymentDate: data.paymentDate,
                paymentMethod: data.paymentMethod+" Payment",
                contributionType: data.description
              )
            ),
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
                gradient: i==0?csCardGradient():plainCardGradient(context), context: context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: contributionSummary(
                color: i==0?Colors.white:i==1?primaryColor:Colors.blueGrey,
                cardIcon: i==0?Feather.bar_chart_2:Feather.bar_chart,
                amountDue: currencyFormat.format(data.balance),
                cardAmount: currencyFormat.format(data.amountPaid),
                currency: _groupCurrency,
                dueDate: data.dueDate,
                contributionName: data.contributionName,
              ),
            ),
          ),
        ],
      );
      ++i;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = Provider.of<Dashboard>(context);
    setState(() {
      _iteratableRecentTransactionSummary = dashboardData.recentMemberTransactions;
      _itableContributionSummary = dashboardData.memberContributionSummary;
    });
    return WillPopScope(
        onWillPop: _onWillPop,
        child: RefreshIndicator(
          onRefresh: () =>_getMemberDashboardData(true),
          child: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: !_isInit ? Column(
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
                                    color: (dashboardData.memberContributionArrears)>0?
                                    Colors.red[400]
                                    :Theme.of(context)
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
                                    color: (dashboardData.memberFineArrears)>0?Colors.red[400]:Theme.of(context)
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
                                    color: (dashboardData.memberTotalLoanBalance)>0?Colors.red[400]:Theme.of(context)
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
                                text: "Pending Installment Balance",
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
                                    color: (dashboardData.memberLoanArrears)>0?Colors.red[400]:Theme.of(context)
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
                        children: _itableContributionSummary.length>0?contributionsSummary.toList():
                        <Widget>[
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
                                amountDue: "0",
                                cardAmount: "0",
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
                                gradient: plainCardGradient(context),
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
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Container(
                      width: 260, //TODO: Remove this when you uncomment the 'APPLY LOAD' button below
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      color: Theme.of(context).cardColor.withOpacity(0.1),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if(_onlineBankingEnabled)
                          Expanded(
                            child: 
                            Padding(
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
                  recentTransactionSummary.length > 0 ? Padding(
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
                  ) : SizedBox(),
                  recentTransactionSummary.length > 0 ? Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Container(
                      height: 180.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        physics: BouncingScrollPhysics(),
                        children: recentTransactionSummary.toList(),
                        
                        
                        
                        // <Widget>[
                        //   SizedBox(
                        //     width: 16.0,
                        //   ),
                        //   Container(
                        //     width: 160.0,
                        //     padding: EdgeInsets.all(16.0),
                        //     decoration: cardDecoration(
                        //         gradient: plainCardGradient(context),
                        //         context: context),
                        //     child: 
                            
                            
                            
                        //     Column(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: resetTransactions(
                        //         color: Colors.blueGrey,
                        //         paymentDescription: "Contribution Payment",
                        //         cardAmount: "1,500",
                        //         currency: _groupCurrency,
                        //         cardIcon: Feather.pie_chart,
                        //         paymentDate: "14 Apr 20",
                        //       )
                              
                              
                        //       // contributionSummary(
                        //       //   color: Colors.blueGrey,
                        //       //   cardIcon: Feather.pie_chart,
                        //       //   amountDue: "1,500",
                        //       //   cardAmount: "1,500",
                        //       //   currency: _groupCurrency,
                        //       //   dueDate: "14 Apr 20",
                        //       //   contributionName: "Contribution Payment",
                        //       // ),
                        //     ),
                        //   ),
                        //   SizedBox(
                        //     width: 26.0,
                        //   ),
                        //   Container(
                        //     width: 160.0,
                        //     padding: EdgeInsets.all(16.0),
                        //     decoration: cardDecoration(
                        //         gradient: plainCardGradient(context),
                        //         context: context),
                        //     child: Column(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: contributionSummary(
                        //         color: primaryColor,
                        //         cardIcon: Feather.bar_chart_2,
                        //         amountDue: "10,050",
                        //         cardAmount: "4,050",
                        //         currency: _groupCurrency,
                        //         dueDate: "4 Apr 20",
                        //         contributionName: "Loan Repayment",
                        //       ),
                        //     ),
                        //   ),
                        //   SizedBox(
                        //     width: 26.0,
                        //   ),
                        //   Container(
                        //     width: 160.0,
                        //     padding: EdgeInsets.all(16.0),
                        //     decoration: cardDecoration(
                        //         gradient: plainCardGradient(context),
                        //         context: context),
                        //     child: Column(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: contributionSummary(
                        //         color: Colors.blueGrey,
                        //         cardIcon: Feather.bar_chart_2,
                        //         amountDue: "10,050",
                        //         cardAmount: "4,050",
                        //         currency: _groupCurrency,
                        //         dueDate: "4 Apr 20",
                        //         contributionName: "Loan Repaymentfhghgh",
                        //       ),
                        //     ),
                        //   ),
                        //   SizedBox(
                        //     width: 16.0,
                        //   ),
                        // ],
                      ),
                    ),
                  ) : SizedBox(height: 10.0,),
                ],
              ) : chamasoftHomeLoadingData(context: context)
            )
          ),
        ));
  }

  void _openPayNowTray(BuildContext context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => PayNow(),
    //   ),
    // );
    void _applyFilter() {}
    showModalBottomSheet(context: context,isScrollControlled: true, builder: (_) => PayNow(_applyFilter));
  }
}
