import 'package:chamasoft/screens/chamasoft/reports/contribution-statement.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

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
    return GridView.count(
      padding: EdgeInsets.all(16.0),
      crossAxisCount: 2,
      children: List.generate(2, (index) {
        String title1 = "CONTRIBUTION";
        String title2 = "STATEMENT";
        IconData icon = Feather.file_text;
        int statementFlag = 0;
        if (index == 1) {
          title1 = "FINE";
          icon = Feather.file_minus;
          statementFlag = 2;
        }

        return GridItem(
            title1: title1,
            title2: title2,
            icon: icon,
            onTapped: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ContributionStatement(),
                      settings: RouteSettings(arguments: statementFlag)),
                ));
      }),
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

class GridItem extends StatelessWidget {
  const GridItem(
      {Key key,
      @required this.title1,
      @required this.title2,
      @required this.icon,
      @required this.onTapped})
      : super(key: key);

  final String title1;
  final String title2;
  final IconData icon;
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Container(
        margin: EdgeInsets.all(16),
        height: 150,
        decoration: cardDecoration(
            gradient: plainCardGradient(context), context: context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 35.0,
              color: Colors.blue,
            ),
            SizedBox(
              height: 15.0,
            ),
            subtitle1(
                text: title1, color: Colors.blue, align: TextAlign.center),
            subtitle2(text: title2, color: Colors.blue, align: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
