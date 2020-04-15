import 'package:chamasoft/screens/chamasoft/models/report-menu.dart';
import 'package:chamasoft/screens/chamasoft/reports/group-reports-menu.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/contribution-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/loan-applications.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/contribution-statement.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/loan-summary.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ChamasoftReports extends StatefulWidget {
  @override
  _ChamasoftReportsState createState() => _ChamasoftReportsState();
}

class _ChamasoftReportsState extends State<ChamasoftReports> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ReportMenu> list = [
      ReportMenu("CONTRIBUTION", "STATEMENT", LineAwesomeIcons.file_text),
      ReportMenu("FINE", "STATEMENT", LineAwesomeIcons.file),
      ReportMenu("LOAN", "APPLICATIONS", LineAwesomeIcons.bar_chart_o),
      ReportMenu("LOAN", "SUMMARY", LineAwesomeIcons.pie_chart),
      ReportMenu("CONTRIBUTION", "SUMMARY", LineAwesomeIcons.list),
      ReportMenu("MORE GROUP", "REPORTS", LineAwesomeIcons.arrow_right),
    ];

    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.count(
          padding: EdgeInsets.all(12.0),
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          children: List.generate(list.length, (index) {
            ReportMenu menu = list[index];
            return gridButton(
              context: context,
              icon: menu.icon,
              title: menu.title,
              subtitle: menu.subtitle,
              color: (index == 5) ? Colors.white : Colors.blueGrey[400],
              isHighlighted: (index == 5) ? true : false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return navigate(index);
                  },
                  settings: RouteSettings(arguments: index + 1))),
            );
          }),
        );
      },
    );
  }

  Widget navigate(int index) {
    Widget target = ContributionStatement();
    switch (index) {
      case 0:
      case 1:
        target = ContributionStatement();
        break;
      case 2:
        target = LoanApplications();
        break;
      case 3:
        target = LoanSummary();
        break;
      case 4:
        target = ContributionSummary();
        break;
      case 5:
        target = GroupReportsMenu();
        break;
    }
    return target;
  }
}
