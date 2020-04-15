import 'package:chamasoft/screens/chamasoft/models/report-menu.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/contribution-summary.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class GroupReportsMenu extends StatefulWidget {
  @override
  _GroupReportsMenuState createState() => _GroupReportsMenuState();
}

class _GroupReportsMenuState extends State<GroupReportsMenu> {
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
      ReportMenu("CONTRIBUTION", "SUMMARY", LineAwesomeIcons.file_text),
      ReportMenu("FINE", "SUMMARY", LineAwesomeIcons.file),
      ReportMenu("LOAN", "SUMMARY", LineAwesomeIcons.bar_chart),
      ReportMenu("LOAN", "APPLICATIONS", LineAwesomeIcons.list),
      ReportMenu("EXPENSE", "SUMMARY", LineAwesomeIcons.pie_chart),
      ReportMenu("TRANSACTION", "STATEMENT", LineAwesomeIcons.list_ol),
    ];
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: 1,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Group Reports",
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: primaryGradient(context),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.count(
              padding: EdgeInsets.all(16.0),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              children: List.generate(list.length, (index) {
                ReportMenu menu = list[index];
                return gridButton(
                  context: context,
                  icon: menu.icon,
                  title: menu.title,
                  subtitle: menu.subtitle,
                  color: Colors.blue[400],
                  isHighlighted: false,
                  action: () => navigate(index),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  void navigate(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return ContributionSummary();
            },
            settings: RouteSettings(arguments: CONTRIBUTION_STATEMENT)));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return ContributionSummary();
            },
            settings: RouteSettings(arguments: FINE_STATEMENT)));
        break;
    }
  }
}
