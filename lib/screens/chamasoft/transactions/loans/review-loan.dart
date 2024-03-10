import 'package:chamasoft/screens/chamasoft/models/loan-application.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-signatory.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
  double _appBarElevation = 0;
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
              floatingLabelBehavior: FloatingLabelBehavior.auto,
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
           
            new TextButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                   
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
           
            new TextButton(
              child: new Text(
                "Save",
                style: new TextStyle(color: primaryColor),
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
    int flag = ModalRoute.of(context).settings.arguments;
    String appbarTitle = "Review Loan";
    if (flag == VIEW_APPLICATION_STATUS) {
      appbarTitle = "Loan Application Status";
    }
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.times,
        title: appbarTitle,
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Flex(
                  direction:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? Axis.vertical
                          : Axis.horizontal,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      width: double.infinity,
                      color: (themeChangeProvider.darkTheme)
                          ? Colors.blueGrey[800]
                          : Color(0xffededfe),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    heading2(
                                      text:
                                          "${widget.loanApplication.loanName}",
                                      color: Theme.of(context)
                                         
                                          .textSelectionTheme
                                          .selectionHandleColor,
                                      textAlign: TextAlign.start,
                                    ),
                                    Visibility(
                                        visible: flag == REVIEW_LOAN,
                                        child: customTitle(
                                          text:
                                              "Applied By ${widget.loanApplication.borrowerName}",
                                          fontSize: 12.0,
                                          color: primaryColor,
                                          textAlign: TextAlign.start,
                                        )),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  customTitle(
                                    text: "Ksh ",
                                    fontSize: 18.0,
                                    color: Theme.of(context)
                                       
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  heading2(
                                    text:
                                        "${numberFormat.format(widget.loanApplication.amount)}",
                                    color: Theme.of(context)
                                       
                                        .textSelectionTheme
                                        .selectionHandleColor,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              subtitle1(
                                text: "Interest Rate: ",
                                color:
                                   
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                              ),
                              customTitle(
                                textAlign: TextAlign.start,
                                text: "12%",
                                color:
                                   
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              subtitle1(
                                text: "Repayment Period: ",
                                color:
                                   
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                              ),
                              customTitle(
                                textAlign: TextAlign.start,
                                text: "1 Month",
                                color:
                                   
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              subtitle1(
                                text: "Applied On: ",
                                color:
                                   
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                              ),
                              customTitle(
                                textAlign: TextAlign.start,
                                text:
                                    "${dateFormat.format(widget.loanApplication.requestDate)}",
                                color:
                                   
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            heading2(
                                text: "Signatories",
                                color:
                                   
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                textAlign: TextAlign.start),
                            SizedBox(
                              height: 10,
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
                                      approvalStatus:
                                          loanSignatory.approvalStatus,
                                      isCurrentUser:
                                          loanSignatory.isCurrentUser,
                                      onPressed: () {},
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: flag == REVIEW_LOAN,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                   
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent.withOpacity(.2),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'APPROVE',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                   
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent.withOpacity(.2),
                      ),
                      onPressed: () {
                        _rejectActionPrompt();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'REJECT',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: flag == VIEW_APPLICATION_STATUS,
                child: Center(
                 
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(.2),
                    ),
                    onPressed: () {
                      //_rejectActionPrompt();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'CANCEL APPLICATION',
                        style:
                            TextStyle(color: Colors.red, fontFamily: 'SegoeUI'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
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
              subtitle1(
                text: isCurrentUser ? "$userName (You)" : "$userName",
               
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
              ),
              subtitle2(
                text: "$userRole",
                color:
                   
                    Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor
                        .withOpacity(0.5),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          statusChip(
              text:
                  "${approvalStatus <= (approvalStatuses.length - 1) ? approvalStatuses[this.approvalStatus] : ''}",
              textColor: approvalStatus == 2
                  ? primaryColor
                 
                  : Theme.of(context).textSelectionTheme.selectionHandleColor,
              backgroundColor: Theme.of(context).hintColor.withOpacity(0.1)),
        ],
      ),
    );
  }
}
