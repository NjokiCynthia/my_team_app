import 'dart:ui';

class ChartData {
  String month;
  int deposit, withdrawal;
  final Color depositColor = const Color(0xff56D9FE);
  final Color withdrawalColor = const Color(0xff00AAF0);

  ChartData({this.month, this.deposit, this.withdrawal});
}
