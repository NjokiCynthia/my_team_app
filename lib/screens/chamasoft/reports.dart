import 'package:chamasoft/screens/chamasoft/reports/contribution-statement.dart';
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
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.count(
          padding: EdgeInsets.all(12.0),
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          children: List.generate(2, (index) {
            String title1 = "CONTRIBUTION";
            String title2 = "STATEMENT";
            IconData icon = LineAwesomeIcons.file_text;
            int statementFlag = 0;
            if (index == 1) {
              title1 = "FINE";
              icon = LineAwesomeIcons.file;
              statementFlag = 2;
            }
            return gridButton(
              context: context,
              icon: icon,
              title: title1,
              subtitle: title2,
              color: Colors.blueGrey[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ContributionStatement(), settings: RouteSettings(arguments: statementFlag)),),
            );
          }),
        );
      },
    );
  }
}
