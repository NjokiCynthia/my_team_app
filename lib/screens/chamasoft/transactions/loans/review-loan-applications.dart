import 'package:chamasoft/screens/chamasoft/models/loan-application.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

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
  double _appBarElevation = 0;
  var numberFormat = new NumberFormat("#,###.00");
  var dateFormat = new DateFormat("d MMMM y");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Review Loan Applications",
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: primaryGradient(context),
        width: double.infinity,
        height: double.infinity,
        child: loanApplications.length > 0
            ? ListView.builder(
                itemCount: loanApplications.length,
                itemBuilder: (context, int index) {
                  LoanApplication loanApplication = loanApplications[index];
                  return LoanApplicationCard(
                    loanName: loanApplication.loanName,
                    amount: numberFormat.format(loanApplication.amount),
                    borrowerName: loanApplication.borrowerName,
                    requestDate: dateFormat.format(loanApplication.requestDate),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ReviewLoan(loanApplication: loanApplication),
                          settings: RouteSettings(arguments: REVIEW_LOAN),
                        ),
                      );
                    },
                  );
                })
            : Center(child: Text('No Loans at the moment')),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Card(
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
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
                  customTitle(
                    text: "$loanName",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionHandleColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Row(
                    children: <Widget>[
                      customTitle(
                        text: "Ksh ",
                        fontSize: 16.0,
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor,
                      ),
                      customTitle(
                        text: "$amount",
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.start,
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
                  subtitle2(
                      text: "Applied By",
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor,
                      textAlign: TextAlign.start),
                  SizedBox(height: 22),
                  subtitle2(
                      text: "Applied On",
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor,
                      textAlign: TextAlign.start),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "$borrowerName",
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionHandleColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 22),
                  customTitle(
                    text: "$requestDate",
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionHandleColor,
                    textAlign: TextAlign.start,
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
                  plainButtonWithArrow(
                      text: "Respond",
                      size: 16.0,
                      spacing: 2.0,
                      color: Theme.of(context)
                          // ignore: deprecated_member_use
                          .textSelectionHandleColor
                          .withOpacity(.8),
                      action: onPressed),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
