import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/svg-icons.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DepositsVWithdrawals extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DepositsVWithdrawalsState();
}

class DepositsVWithdrawalsState extends State<DepositsVWithdrawals> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = Provider.of<Dashboard>(context);
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Container(
      height: 280,
      margin: EdgeInsets.only(top: 24),
      child: dashboardData.chartYAxisParameters[0] > 1
          ? Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              width: 600,
              child: BarChart(
                BarChartData(
                  maxY: dashboardData.chartYAxisParameters[0] /
                      dashboardData.chartYAxisParameters[1],
                  barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: primaryColor,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            double value =
                                dashboardData.chartYAxisParameters[1] > 1
                                    ? rod.toY * 1000
                                    : rod.toY;
                            return BarTooltipItem(
                                "${groupObject.groupCurrency} ${currencyFormat.format(value)}",
                                TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'SegoeUI'));
                          })),
                  titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, titleMeta) {
                          if (dashboardData.getTransactionMonths.length > 0) {
                            List<String> months =
                                dashboardData.getTransactionMonths;
                            return Text(
                              months[value.toInt()],
                              style: TextStyle(
                                  // ignore: deprecated_member_use
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                  fontFamily: 'SegoeUI',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            );
                          } else {
                            return Text("");
                          }
                        },
                      )),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        interval: (dashboardData.chartYAxisParameters[0] /
                                dashboardData.chartYAxisParameters[1]) /
                            5,
                        getTitlesWidget: (value, titleMeta) {
                          return dashboardData.chartYAxisParameters[1] > 1
                              ? value.toInt() > 0
                                  ? Text(
                                      value.toInt().toString() + "k",
                                      style: TextStyle(
                                          // ignore: deprecated_member_use
                                          color: Theme.of(context)
                                              .textSelectionTheme
                                              .selectionHandleColor,
                                          fontFamily: 'SegoeUI',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    )
                                  : Text(
                                      value.toInt().toString(),
                                      style: TextStyle(
                                          // ignore: deprecated_member_use
                                          color: Theme.of(context)
                                              .textSelectionTheme
                                              .selectionHandleColor,
                                          fontFamily: 'SegoeUI',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    )
                              : Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                      // ignore: deprecated_member_use
                                      color: Theme.of(context)
                                          .textSelectionTheme
                                          .selectionHandleColor,
                                      fontFamily: 'SegoeUI',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                );
                        },
                      )),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: (dashboardData.chartYAxisParameters[0] /
                                      dashboardData.chartYAxisParameters[1]) /
                                  5,
                              getTitlesWidget: (value, titleMeta) {
                                return dashboardData.chartYAxisParameters[1] > 1
                                    ? Text(
                                        value.toInt().toString() + "k",
                                        style: TextStyle(
                                            color:
                                                // ignore: deprecated_member_use
                                                Theme.of(context)
                                                    .textSelectionTheme
                                                    .selectionHandleColor,
                                            fontFamily: 'SegoeUI',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )
                                    : Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                            color:
                                                // ignore: deprecated_member_use
                                                Theme.of(context)
                                                    .textSelectionTheme
                                                    .selectionHandleColor,
                                            fontFamily: 'SegoeUI',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      );
                              }))),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: dashboardData.depositsVWithdrawals,
                ),
              ),
            )
          : Column(
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
                    text: "Sorry, you don't have enough data to plot a chart.",
                    //fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    textAlign: TextAlign.center,
                    color: Colors.blueGrey[400])
              ],
            ),
    );
  }
}
