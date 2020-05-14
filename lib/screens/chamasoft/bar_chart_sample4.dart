import 'package:chamasoft/screens/chamasoft/models/chart-data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample4 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  final Color deposits = const Color(0xff56D9FE);
  final Color withdrawals = const Color(0xff00AAF0);

  List<ChartData> depositsVsWithdrawals = [
    ChartData(month: "Apr", deposit: 10000, withdrawal: 4000),
    ChartData(month: "May", deposit: 14000, withdrawal: 10000),
    ChartData(month: "Jun", deposit: 22000, withdrawal: 11000),
    ChartData(month: "Jul", deposit: 49000, withdrawal: 22000),
    ChartData(month: "Aug", deposit: 11000, withdrawal: 40000),
    ChartData(month: "Sep", deposit: 30000, withdrawal: 14700),
  ];

  List<BarChartGroupData> get data {
    return List.generate(depositsVsWithdrawals.length, (index) {
      ChartData data = depositsVsWithdrawals[index];
      return BarChartGroupData(x: index, barsSpace: 4, barRods: [
        BarChartRodData(
            y: data.total,
            rodStackItem: [
              BarChartRodStackItem(0, data.deposit, data.depositColor),
              BarChartRodStackItem(data.deposit, data.total, data.depositColor)
            ],
            borderRadius: const BorderRadius.all(Radius.zero))
      ]);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: 35,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  textStyle:
                      const TextStyle(color: Color(0xff939393), fontSize: 10),
                  margin: 10,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Apr';
                      case 1:
                        return 'May';
                      case 2:
                        return 'Jun';
                      case 3:
                        return 'Jul';
                      case 4:
                        return 'Aug';
                      case 5:
                        return 'Aug';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  textStyle: const TextStyle(
                      color: Color(
                        0xff939393,
                      ),
                      fontSize: 10),
                  getTitles: (double value) {
                    return value.toInt().toString();
                  },
                  interval: 10,
                  margin: 0,
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 10 == 0,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: const Color(0xffe7e8ec),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              //groupsSpace: 4,
              barGroups: data,
            ),
          ),
        ),
      ),
    );
  }
}
