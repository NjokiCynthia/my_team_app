import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                          align: TextAlign.start,
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
                              color: Theme.of(context).textSelectionHandleColor,
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
                          align: TextAlign.start,
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
                              color: Theme.of(context).textSelectionHandleColor,
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
                              color: Theme.of(context).textSelectionHandleColor,
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
                              color: Theme.of(context).textSelectionHandleColor,
                              action: () {}),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
