import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class WithdrawalPurpose extends StatefulWidget {
  @override
  _WithdrawalPurposeState createState() => _WithdrawalPurposeState();
}

class _WithdrawalPurposeState extends State<WithdrawalPurpose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                screenActionButton(
                  icon: LineAwesomeIcons.arrow_left,
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  textColor: Colors.blue,
                  action: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 20.0),
                heading2(color: Colors.blue, text: "Purpose of Withdrawal"),
              ],
            ),
          ],
        ),
        elevation: 1,
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(4, (index) {
            String title = "Expense Payment";

            if (index == 1) {
              title = "Contribution Refund";
            } else if (index == 2) {
              title = "Loan DisbursementDisbursement ";
            } else if (index == 3) {
              title = "Miscellanous Payment";
            }

            return InkWell(
              child: Container(
                margin: EdgeInsets.all(16),
                height: 150,
                decoration: cardDecoration(
                    gradient: plainCardGradient(context), context: context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Feather.credit_card,
                      size: 35.0,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    subtitle1(
                        text: title,
                        color: Colors.blue,
                        align: TextAlign.center),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
