import 'package:chamasoft/screens/chamasoft/reports/contribution-statement.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
    return Center(
      child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ReportButton(
                      icon: Feather.file_text,
                      text1: "CONTRIBUTION",
                      text2: "STATEMENT",
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ContributionStatement(),
                            settings: RouteSettings(arguments: 1)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ReportButton(
                      icon: LineAwesomeIcons.fax,
                      text1: "FINE",
                      text2: "STATEMENT",
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ContributionStatement(),
                            settings: RouteSettings(arguments: 2)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class ReportButton extends StatelessWidget {
  final IconData icon;
  final String text1, text2;
  final Function onPressed;

  const ReportButton({this.icon, this.text1, this.text2, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration(
          gradient: plainCardGradient(context), context: context),
      padding: const EdgeInsets.all(30.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              this.icon,
              size: 35.0,
              color: Colors.blue,
            ),
            SizedBox(
              height: 15.0,
            ),
            subtitle1(text: text1, color: Colors.blue, align: TextAlign.center),
            subtitle2(text: text2, color: Colors.blue, align: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
