import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 60.0),
      child: Column(
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
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
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
                      Text(
                        "Contributions",
                        style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor.withOpacity(0.8),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 22,
                        child: cardAmountButton(currency: "Ksh", amount: "21,000", size: 18.0,color: Theme.of(context).textSelectionHandleColor, action: (){}),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Fines",
                        style: TextStyle(
                          color: Colors.red[400],
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 22,
                        child: cardAmountButton(currency: "Ksh", amount: "2,350", size: 16.0,color: Colors.red[700], action: (){}),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Loans",
                        style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor.withOpacity(0.8),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 22,
                        child: cardAmountButton(currency: "Ksh", amount: "13,500", size: 16.0,color: Theme.of(context).textSelectionHandleColor, action: (){}),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Pending Loan Balance",
                        style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor.withOpacity(0.8),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 22,
                        child: cardAmountButton(currency: "Ksh", amount: "5,500", size: 16.0,color: Theme.of(context).textSelectionHandleColor, action: (){}),
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
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Feather.more_horizontal,
                    color: Colors.blueGrey,
                  ), 
                  onPressed: (){}
                )
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
                  SizedBox(width: 16.0,),
                  Container(
                    width: 160.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: cardDecoration(gradient: csCardGradient(), context: context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: contributionSummary(
                        color: Colors.white,
                        cardIcon: Feather.bar_chart_2,
                        amountDue: "7,500",
                        cardAmount: "10,050",
                        currency: "Ksh",
                        dueDate: "14 Apr 20",
                        contributionName: "Monthly Savings",
                      ),
                    ),
                  ),
                  SizedBox(width: 26.0,),
                  Container(
                    width: 160.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: contributionSummary(
                        color: Colors.blue,
                        cardIcon: Feather.bar_chart,
                        amountDue: "4,050",
                        cardAmount: "4,050",
                        currency: "Ksh",
                        dueDate: "4 Apr 20",
                        contributionName: "DVEA Welfare Contribution monthly group",
                      ),
                    ),
                  ),
                  SizedBox(width: 26.0,),
                  Container(
                    width: 160.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: contributionSummary(
                        color: Colors.blueGrey,
                        cardIcon: Feather.bar_chart_2,
                        amountDue: "7,500",
                        cardAmount: "10,050",
                        currency: "Ksh",
                        dueDate: "14 Apr 20",
                        contributionName: "Insuranceghhghgh",
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 16.0,),
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0,),
                      child: paymentActionButton(
                        color: Colors.blue,
                        textColor: Colors.blue,
                        icon: FontAwesome.chevron_right,
                        isFlat: false,
                        text: "PAY NOW",
                        iconSize: 12.0,
                        action: (){},
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0,),
                      child: paymentActionButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        icon: FontAwesome.chevron_right,
                        isFlat: true,
                        text: "APPLY LOAN",
                        iconSize: 12.0,
                        action: (){},
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
                  onPressed: (){}
                )
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
                  SizedBox(width: 16.0,),
                  Container(
                    width: 160.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: contributionSummary(
                        color: Colors.blueGrey,
                        cardIcon: Feather.pie_chart,
                        amountDue: "1,500",
                        cardAmount: "1,500",
                        currency: "Ksh",
                        dueDate: "14 Apr 20",
                        contributionName: "Contribution Payment",
                      ),
                    ),
                  ),
                  SizedBox(width: 26.0,),
                  Container(
                    width: 160.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: contributionSummary(
                        color: Colors.blue,
                        cardIcon: Feather.bar_chart_2,
                        amountDue: "10,050",
                        cardAmount: "4,050",
                        currency: "Ksh",
                        dueDate: "4 Apr 20",
                        contributionName: "Loan Repaymentfhghgh",
                      ),
                    ),
                  ),
                  SizedBox(width: 26.0,),
                  Container(
                    width: 160.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: contributionSummary(
                        color: Colors.blueGrey,
                        cardIcon: Feather.bar_chart_2,
                        amountDue: "10,050",
                        cardAmount: "4,050",
                        currency: "Ksh",
                        dueDate: "4 Apr 20",
                        contributionName: "Loan Repaymentfhghgh",
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 16.0,),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }

}