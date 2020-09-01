import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';

class ChartData {
  String month;
  double deposit, withdrawal, total;
  final Color depositColor = const Color(0xff56D9FE);
  final Color withdrawalColor = const Color(0xff00AAF0);

  ChartData({String month, double deposit, double withdrawal}) {
    this.month = month;
    this.deposit = deposit;
    this.withdrawal = withdrawal;
    this.total = deposit + withdrawal;
  }
}

class GroupedChartData {
  List<String> months;
  List<BarChartGroupData> transactions;
  double divider;


}
