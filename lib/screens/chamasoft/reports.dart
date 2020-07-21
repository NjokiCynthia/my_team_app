import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/models/report-menu.dart';
import 'package:chamasoft/screens/chamasoft/reports/deposit-receipts.dart';
import 'package:chamasoft/screens/chamasoft/reports/group-reports-menu.dart';
import 'package:chamasoft/screens/chamasoft/reports/loan-applications.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/contribution-statement.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/loan-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/withdrawal_receipts.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ChamasoftReports extends StatefulWidget {
  ChamasoftReports({
    this.appBarElevation,
  });

  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftReportsState createState() => _ChamasoftReportsState();
}

class _ChamasoftReportsState extends State<ChamasoftReports> {
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
    final List<ReportMenu> list = [
      ReportMenu("CONTRIBUTION", "STATEMENT", LineAwesomeIcons.file_text),
      ReportMenu("FINE", "STATEMENT", LineAwesomeIcons.file),
      ReportMenu("LOAN", "APPLICATIONS", LineAwesomeIcons.bar_chart_o),
      ReportMenu("LOAN", "SUMMARY", LineAwesomeIcons.pie_chart),
      ReportMenu("DEPOSIT", "RECEIPTS", LineAwesomeIcons.angle_double_down),
      ReportMenu("WITHDRAWAL", "RECEIPTS", LineAwesomeIcons.angle_double_up),
      ReportMenu("MORE GROUP", "REPORTS", LineAwesomeIcons.arrow_right),
    ];

    return new WillPopScope(
        onWillPop: _onWillPop,
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.count(
              controller: _scrollController,
              padding: EdgeInsets.all(12.0),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              children: List.generate(list.length, (index) {
                ReportMenu menu = list[index];
                return gridButton(
                  context: context,
                  icon: menu.icon,
                  title: menu.title,
                  subtitle: menu.subtitle,
                  color: (index == 6) ? Colors.white : Colors.blue[400],
                  isHighlighted: (index == 6) ? true : false,
                  action: () => navigate(index),
                );
              }),
            );
          },
        ));
  }

  void navigate(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return ContributionStatement(
                statementFlag: CONTRIBUTION_STATEMENT,
              );
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return ContributionStatement(
                statementFlag: FINE_STATEMENT,
              );
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return LoanApplications();
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return LoanSummary();
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return DepositReceipts();
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return WithdrawalReceipts();
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return GroupReportsMenu();
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
    }
  }
}
