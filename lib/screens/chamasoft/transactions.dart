import 'package:chamasoft/screens/chamasoft/models/transaction-menu.dart';
import 'package:chamasoft/screens/chamasoft/transactions/transaction-menu-details.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal-requests.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/withdrawal-purpose.dart';
import 'package:chamasoft/utilities/svg-icons.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';

class ChamasoftTransactions extends StatefulWidget {
  ChamasoftTransactions({
    this.appBarElevation,
  });

  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftTransactionsState createState() => _ChamasoftTransactionsState();
}

class _ChamasoftTransactionsState extends State<ChamasoftTransactions> {
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
    final List<TransactionMenuSvg> list = [
      TransactionMenuSvg("E-WALLET", customIcons['wallet']),
      // TransactionMenuSvg("LOANS", customIcons['transaction']),
      TransactionMenuSvg("RECORD PAYMENTS", customIcons['invoice']),
      TransactionMenuSvg("RECORD EXPENDITURE", customIcons['expense']),
      TransactionMenuSvg("INVOICING & TRANSFER", customIcons['transaction']),
    ];

    List<Widget> eWalletOptions = [
      SizedBox(
        width: 16.0,
      ),
      Container(
        width: 160.0,
        child: svgGridButton(
          context: context,
          icon: customIcons['wallet'],
          title: 'CREATE WITHDRAWAL REQUEST',
          color: Colors.blue[400],
          isHighlighted: false,
          action: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WithdrawalPurpose(),
              settings: RouteSettings(arguments: 0)
            )
          ),
          margin: 0
        )
      ),
      SizedBox(
        width: 26.0,
      ),
      Container(
        width: 160.0,
        child: svgGridButton(
          context: context,
          icon: customIcons['couple'],
          title: 'REVIEW WITHDRAWAL REQUESTS',
          color: Colors.blue[400],
          isHighlighted: false,
          action: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ReviewWithdrawalRequests(),
              settings: RouteSettings(arguments: 0)
            )
          ),
          margin: 0
        )
      ),
      SizedBox(
        width: 26.0,
      ),
    ];

    return new WillPopScope(
      onWillPop: _onWillPop ,
      child: SafeArea(
        child: SingleChildScrollView(
          // controller: _scrollController,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 16.0, 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "E-Wallet",
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontFamily: 'SegoeUI',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // IconButton(
                    //     icon: Icon(
                    //       Feather.more_horizontal,
                    //       color: Colors.blueGrey,
                    //     ),
                    //     onPressed: () {})
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
                    children: eWalletOptions,
                  ),
                ),
              ),
              
            ]
          )
        )
      )
    );
  }
}