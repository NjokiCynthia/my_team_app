import 'package:chamasoft/screens/chamasoft/transactions/review-loan-applications.dart';
import 'package:chamasoft/screens/chamasoft/transactions/withdrawal-purpose.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ChamasoftTransactions extends StatefulWidget {
  @override
  _ChamasoftTransactionsState createState() => _ChamasoftTransactionsState();
}

class _ChamasoftTransactionsState extends State<ChamasoftTransactions> {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ReportButton(
                  icon: Feather.file_text,
                  text: "REVIEW LOAN\n APPLICATIONS",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ReviewLoanApplications()));
                  },
                ),
                ReportButton(
                  icon: Feather.file_plus,
                  text: "RECORD LOAN\n REPAYMENYS",
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ReportButton(
                  icon: Feather.file_text,
                  text: "CREATE WITHDRAWAL\n REQUEST",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            WithdrawalPurpose()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReportButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;

  const ReportButton({this.icon, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.transparent,
      padding: EdgeInsets.all(0.0),
      textColor: Colors.blue,
      child: Container(
        decoration: cardDecoration(
            gradient: plainCardGradient(context), context: context),
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              this.icon,
              size: 35.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
