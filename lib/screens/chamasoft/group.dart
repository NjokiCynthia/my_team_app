import 'package:chamasoft/screens/chamasoft/bar_chart_sample4.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ChamasoftGroup extends StatefulWidget {
  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftGroupState createState() => _ChamasoftGroupState();

  ChamasoftGroup({this.appBarElevation});
}

class _ChamasoftGroupState extends State<ChamasoftGroup> {
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

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacementNamed(ChamasoftDashboard.namedRoute);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: cardDecoration(
                        gradient: plainCardGradient(context), context: context),
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
                          color: Theme.of(context).hintColor.withOpacity(0.1),
                          thickness: 2.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            customTitle(
                              text: "All Group Contributions",
                              textAlign: TextAlign.start,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
                            SizedBox(
                              height: 22,
                              child: cardAmountButton(
                                  currency: "Ksh",
                                  amount: "21,000",
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
                              text: "Group Expenses",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
                            SizedBox(
                              height: 22,
                              child: cardAmountButton(
                                  currency: "Ksh",
                                  amount: "2,350",
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
                              gradient: csCardGradient(), context: context),
                          child: accountBalance(
                            color: Colors.white,
                            cardIcon: Feather.globe,
                            cardAmount: "19,000,000",
                            currency: "Ksh",
                            accountName: "Total",
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Container(
                          width: 160.0,
                          padding: EdgeInsets.all(16.0),
                          decoration: cardDecoration(
                              gradient: plainCardGradient(context),
                              context: context),
                          child: accountBalance(
                            color: primaryColor,
                            cardIcon: Feather.credit_card,
                            cardAmount: "100,000",
                            currency: "Ksh",
                            accountName: "Finnlemm Bank Account",
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Container(
                          width: 160.0,
                          padding: EdgeInsets.all(16.0),
                          decoration: cardDecoration(
                              gradient: plainCardGradient(context),
                              context: context),
                          child: accountBalance(
                            color: primaryColor,
                            cardIcon: Feather.credit_card,
                            cardAmount: "10,000,000",
                            currency: "Ksh",
                            accountName: "E-Wall",
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: cardDecoration(
                        gradient: plainCardGradient(context), context: context),
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
                          color: Theme.of(context).hintColor.withOpacity(0.1),
                          thickness: 2.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            customTitle(
                              text: "Loaned Out",
                              textAlign: TextAlign.start,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
//                        Text(
//                          "Contributions",
//                          style: TextStyle(
//                            color: Theme.of(context)
//                                .textSelectionHandleColor
//                                .withOpacity(0.8),
//                            fontSize: 18.0,
//                            fontWeight: FontWeight.w800,
//                          ),
//                        ),
                            SizedBox(
                              height: 22,
                              child: cardAmountButton(
                                  currency: "Ksh",
                                  amount: "21,000",
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
                              text: "Total Repaid",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
                            SizedBox(
                              height: 22,
                              child: cardAmountButton(
                                  currency: "Ksh",
                                  amount: "2,350",
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
                                  currency: "Ksh",
                                  amount: "5,500",
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
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: Container(
                      height: 300,
                      padding: EdgeInsets.all(16.0),
                      decoration: cardDecoration(
                          gradient: plainCardGradient(context),
                          context: context),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Deposits vs Withdrawals",
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
                          BarChartSample4()
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
