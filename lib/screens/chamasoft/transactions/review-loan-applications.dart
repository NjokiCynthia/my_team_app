import 'package:chamasoft/screens/chamasoft/models/loan-application.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../dashboard.dart';

List<LoanApplication> loanApplications = [
  LoanApplication(
      loanApplicationId: 1,
      requestDate: DateTime.now(),
      amount: 2000,
      loanName: 'Emergency Loan',
      borrowerName: 'SAMUEL WAHOME'),
  LoanApplication(
      loanApplicationId: 2,
      requestDate: DateTime.now(),
      amount: 6000,
      loanName: 'Chama Loan',
      borrowerName: 'EDWIN KAPKEI'),
  LoanApplication(
      loanApplicationId: 3,
      requestDate: DateTime.now(),
      amount: 15000,
      loanName: 'Education Loan',
      borrowerName: 'MARTIN NZUKI'),
  LoanApplication(
      loanApplicationId: 4,
      requestDate: DateTime.now(),
      amount: 6000,
      loanName: 'Shamba Loan',
      borrowerName: 'PETER KIMUTAI'),
  LoanApplication(
      loanApplicationId: 5,
      requestDate: DateTime.now(),
      amount: 8000,
      loanName: 'Vacation Loan',
      borrowerName: 'BEN CARSON'),
];

class ReviewLoanApplications extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReviewLoanApplicationsState();
  }
}

class ReviewLoanApplicationsState extends State<ReviewLoanApplications> {
  var numberFormat = new NumberFormat("#,###.00");
  var dateFormat = new DateFormat("d MMMM y");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            screenActionButton(
              icon: LineAwesomeIcons.arrow_left,
              backgroundColor: Colors.blue.withOpacity(0.1),
              textColor: Colors.blue,
              action: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChamasoftDashboard(),
                ),
              ),
            ),
            SizedBox(width: 20.0),
            heading2(color: Colors.blue, text: "Review Loan Applications"),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).backgroundColor,
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: loanApplications.length,
            itemBuilder: (context, int index) {
              LoanApplication loanApplication = loanApplications[index];
              return LoanApplicationCard(
                loanName: loanApplication.loanName,
                amount: numberFormat.format(loanApplication.amount),
                borrowerName: loanApplication.borrowerName,
                requestDate: dateFormat.format(loanApplication.requestDate),
                onPressed: () {},
              );
            }),
      ),
    );
  }
}

class LoanApplicationCard extends StatelessWidget {
  final String loanName;
  final String amount;
  final String borrowerName;
  final String requestDate;
  final Function onPressed;

  const LoanApplicationCard({
    this.loanName,
    this.amount,
    this.borrowerName,
    this.requestDate,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      borderOnForeground: false,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: cardDecoration(
            gradient: plainCardGradient(context), context: context),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "$loanName",
                  style: TextStyle(
                    color: Theme.of(context)
                        .textSelectionHandleColor
                        .withOpacity(0.5),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Ksh ",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).textSelectionHandleColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "$amount",
                      style: TextStyle(
                        color: Theme.of(context).textSelectionHandleColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Applied By",
                  style: TextStyle(
                    color: Theme.of(context)
                        .textSelectionHandleColor
                        .withOpacity(0.5),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 22),
                Text(
                  "Applied On",
                  style: TextStyle(
                    color: Theme.of(context)
                        .textSelectionHandleColor
                        .withOpacity(0.5),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "$borrowerName",
                  style: TextStyle(
                    color: Theme.of(context)
                        .textSelectionHandleColor
                        .withOpacity(0.5),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 22),
                Text(
                  "$requestDate",
                  style: TextStyle(
                    color: Theme.of(context)
                        .textSelectionHandleColor
                        .withOpacity(0.5),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "",
                ),
                plainButton(
                    text: "Respond",
                    size: 16.0,
                    spacing: 2.0,
                    color: Theme.of(context)
                        .textSelectionHandleColor
                        .withOpacity(.5),
                    action: onPressed),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
