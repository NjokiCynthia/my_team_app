import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Wallet extends StatefulWidget {
  Wallet({
    this.appBarElevation,
  });

  final ValueChanged<double> appBarElevation;
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
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

  LineChartData eWalletTrend() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      // clipToBorder: true,
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
            FlSpot(3, 4),
            FlSpot(4, 4),
            FlSpot(5, 1.8),
            FlSpot(6, 4),
            FlSpot(7, 1),
            FlSpot(8, 3),
            FlSpot(9, 3),
            FlSpot(10, 3),
            FlSpot(11, 3),
            FlSpot(12, 4),
            FlSpot(13, 1),
          ],
          isCurved: false,
          color: primaryColor,
          barWidth: 1,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: primaryColor.withOpacity(0.07),
            //primaryColor.withOpacity(0.0),

            // gradientColorStops: [0.5, 1.0],
            // gradientFrom: const Offset(0, 0),
            // gradientTo: const Offset(0, 1),
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(1, 1.7),
            FlSpot(2, 4),
            FlSpot(3, 2),
            FlSpot(4, 5),
            FlSpot(5, 2.2),
            FlSpot(6, 3.5),
            FlSpot(7, 0.8),
            FlSpot(8, 3.4),
            FlSpot(9, 2.5),
            FlSpot(10, 3),
            FlSpot(11, 2.8),
            FlSpot(12, 5),
            FlSpot(13, 3),
          ],
          isCurved: false,
          color: Colors.red,
          barWidth: 1,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.red.withOpacity(0.07),
            // Colors.red.withOpacity(0.0),

            // gradientColorStops: [0.5, 1.0],
            // gradientFrom: const Offset(0, 0),
            // gradientTo: const Offset(0, 1),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Wallet",
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
        child: Column(
          children: [
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      16.0,
                      20.0,
                      16.0,
                      0.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Wallet Balance",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              children: [
                                Text(
                                  "KES",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  "12,390",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Deposits",
                                      style: TextStyle(
                                        color: Colors.blueGrey[400],
                                        fontFamily: 'SegoeUI',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_drop_down_sharp,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          "0.92%",
                                          style: TextStyle(
                                            color: Colors.blueGrey[400],
                                            fontFamily: 'SegoeUI',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.0),
                                Column(
                                  children: [
                                    SizedBox(height: 12.0),
                                    Text(
                                      "Withdrawals",
                                      style: TextStyle(
                                        color: Colors.blueGrey[400],
                                        fontFamily: 'SegoeUI',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_drop_up_sharp,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          "1.2%",
                                          style: TextStyle(
                                            color: Colors.blueGrey[400],
                                            fontFamily: 'SegoeUI',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.0),
                  SizedBox(
                    height: 100.0,
                    width: double.infinity,
                    child: LineChart(
                      eWalletTrend(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                0.0,
                0.0,
                0.0,
                10.0,
              ),
              child: Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        // ignore: deprecated_member_use
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            backgroundColor: primaryColor,
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Icon(
                              //   FontAwesome.arrow_up,
                              //   color: Colors.white,
                              //   size: 12.0,
                              // ),
                              // SizedBox(width: 10.0),
                              customTitle(
                                text: "DEPOSIT",
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                              ),
                            ],
                          ),

                          // color: primaryColor,
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        // ignore: deprecated_member_use
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              width: 2.0,
                              color: primaryColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),

                            //highlightColor: primaryColor.withOpacity(0.1),
                            // highlightedBorderColor: primaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Icon(
                              //   FontAwesome.arrow_down,
                              //   color: primaryColor,
                              //   size: 12.0,
                              // ),
                              // SizedBox(width: 10.0),
                              customTitle(
                                text: "WITHDRAW",
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                              ),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
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
                    "Transactions",
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
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.0,
                0.0,
                16.0,
                0.0,
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(6.0, 8.0, 8.0, 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // === Start: Single transaction
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "5 May, 2021",
                              style: TextStyle(
                                color: Colors.blueGrey[400].withOpacity(0.7),
                                fontFamily: 'SegoeUI',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              children: [
                                Text(
                                  "KES",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  "1,000",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Deposit via M-Pesa",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "+254728908916",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Divider(
                      color: Theme.of(context).hintColor.withOpacity(0.5),
                    ),
                    // === End: Single transaction

                    // // === Start: Single transaction
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "4 May, 2021",
                              style: TextStyle(
                                color: Colors.blueGrey[400].withOpacity(0.7),
                                fontFamily: 'SegoeUI',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              children: [
                                Text(
                                  "KES",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  "730",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Deposit via M-Pesa",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "+254728908916",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Divider(
                      color: Theme.of(context).hintColor.withOpacity(0.5),
                    ),
                    // === End: Single transaction

                    // // === Start: Single transaction
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "3 May, 2021",
                              style: TextStyle(
                                color: Colors.blueGrey[400].withOpacity(0.7),
                                fontFamily: 'SegoeUI',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              children: [
                                Text(
                                  "KES",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  "1,200",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Deposit via M-Pesa",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "+254728908916",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    // Divider(
                    //   color: Theme.of(context).hintColor.withOpacity(0.5),
                    // ),
                    // === End: Single transaction
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
