import 'package:chamasoft/screens/chamasoft/models/loan-application.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-signatory.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<String> approvalStatuses = ['UNKNOWN', 'WAITING RESPONSE', 'APPROVED'];

List<LoanSignatory> loanSignatories = [
  LoanSignatory(
    userId: 1,
    approvalStatus: 1,
    isCurrentUser: true,
    userName: 'John Doe',
    userRole: 'Chairman',
  ),
  LoanSignatory(
    userId: 4,
    approvalStatus: 2,
    isCurrentUser: false,
    userName: 'Peter Kimutai',
    userRole: 'Vice Chairman',
  ),
  LoanSignatory(
    userId: 2,
    approvalStatus: 2,
    isCurrentUser: false,
    userName: 'Jane Doe',
    userRole: 'Secretary',
  ),
  LoanSignatory(
    userId: 3,
    approvalStatus: 2,
    isCurrentUser: false,
    userName: 'Martin Nzuki',
    userRole: 'Treasurer',
  ),
];

class ReviewLoan extends StatefulWidget {
  final LoanApplication loanApplication;
  ReviewLoan({this.loanApplication});

  @override
  State<StatefulWidget> createState() {
    return ReviewLoanState();
  }
}

class ReviewLoanState extends State<ReviewLoan> {
  var numberFormat = new NumberFormat("#,###.00");
  var dateFormat = new DateFormat("d MMMM y");
  String rejectReason = "";
  TextEditingController controller;
  void _rejectActionPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Reason for Rejecting"),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.text,
            onChanged: (reason) {
              rejectReason = reason;
            },
            decoration: InputDecoration(
              hasFloatingPlaceholder: true,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 2.0,
              )),
              hintText: 'Reason for Rejecting the Loan Application',
              labelText: "Enter Reason",
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Save",
                style: new TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            screenActionButton(
              icon: LineAwesomeIcons.close,
              backgroundColor: Colors.blue.withOpacity(0.1),
              textColor: Colors.blue,
              action: () => Navigator.of(context).pop(),
            ),
            SizedBox(width: 20.0),
            heading2(color: Colors.blue, text: "Review Loan"),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: primaryGradient(context),
            padding: EdgeInsets.only(top: 10.0),
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 15,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${widget.loanApplication.loanName}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Ksh ",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "${numberFormat.format(widget.loanApplication.amount)}",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
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
                        Text(
                          "Applied By ${widget.loanApplication.borrowerName}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionHandleColor
                                .withOpacity(0.8),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Interest  Rate: ",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "12%",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Repayment Period: ",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "1 Month",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Applied On: ",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "${dateFormat.format(widget.loanApplication.requestDate)}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    color: Theme.of(context).backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Signatories',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textSelectionHandleColor
                                  .withOpacity(0.8),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemCount: loanSignatories.length,
                              itemBuilder: (context, int index) {
                                LoanSignatory loanSignatory =
                                    loanSignatories[index];
                                return LoanSignatoryCard(
                                  userName: loanSignatory.userName,
                                  userRole: loanSignatory.userRole,
                                  approvalStatus: loanSignatory.approvalStatus,
                                  isCurrentUser: loanSignatory.isCurrentUser,
                                  onPressed: () {},
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 50,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: Theme.of(context).backgroundColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.blueAccent.withOpacity(.2),
                          onPressed: () {},
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text(
                              'APPROVE',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        FlatButton(
                          color: Colors.redAccent.withOpacity(.2),
                          onPressed: () {
                            _rejectActionPrompt();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text(
                              'REJECT',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoanSignatoryCard extends StatelessWidget {
  final String userName;
  final String userRole;
  final int approvalStatus;
  final bool isCurrentUser;
  final Function onPressed;

  const LoanSignatoryCard({
    this.userName,
    this.userRole,
    this.approvalStatus,
    this.isCurrentUser,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                isCurrentUser ? "$userName (You)" : "$userName",
                style: TextStyle(
                  color: Theme.of(context)
                      .textSelectionHandleColor
                      .withOpacity(0.8),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "$userRole",
                style: TextStyle(
                  color: Theme.of(context)
                      .textSelectionHandleColor
                      .withOpacity(0.5),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            color: Theme.of(context).hintColor.withOpacity(0.1),
            child: Text(
              "${approvalStatus <= (approvalStatuses.length - 1) ? approvalStatuses[this.approvalStatus] : ''}",
              style: TextStyle(
                fontSize: 16.0,
                color: approvalStatus == 2
                    ? Colors.blue
                    : Theme.of(context).textSelectionHandleColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
