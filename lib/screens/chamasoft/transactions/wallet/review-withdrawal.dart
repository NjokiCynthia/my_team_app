import 'package:chamasoft/screens/chamasoft/models/loan-signatory.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal-request.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
import 'package:chamasoft/utilities/CustomScrollBehaviour.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ReviewWithdrawal extends StatefulWidget {
  final WithdrawalRequest withdrawalRequest;

  ReviewWithdrawal({this.withdrawalRequest});

  @override
  _ReviewWithdrawalState createState() => _ReviewWithdrawalState();
}

class _ReviewWithdrawalState extends State<ReviewWithdrawal> {
  final List<LoanSignatory> loanSignatories = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.close,
          title: "Review Withdrawal Request",
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          color: Theme.of(context).backgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                width: double.infinity,
                color: (themeChangeProvider.darkTheme)
                    ? Colors.blueGrey[800]
                    : Color(0xffededfe),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${widget.withdrawalRequest.purpose}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Theme.of(context)
                                      .textSelectionHandleColor,
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
//                            SizedBox(
//                              height: 10,
//                            ),
                              Text(
                                "Requested by Peter Parker",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Ksh ",
                              style: TextStyle(
                                fontSize: 18.0,
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            heading2(
                                text:
                                    "${currencyFormat.format(widget.withdrawalRequest.amount)}",
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                align: TextAlign.end),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Particulars: ",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionHandleColor
                                .withOpacity(0.8),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${widget.withdrawalRequest.particulars}",
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
                          "Recipient: ",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionHandleColor
                                .withOpacity(0.8),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Peter Parker - 0712000111",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textSelectionHandleColor
                                  .withOpacity(0.8),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Requested On: ",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionHandleColor
                                .withOpacity(0.8),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${DateFormat.yMMMMd().format(widget.withdrawalRequest.requestDate)}",
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
                          "Description: ",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionHandleColor
                                .withOpacity(0.8),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Lorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsum",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textSelectionHandleColor
                                  .withOpacity(0.8),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      heading2(
                          text: "Signatories",
                          color: Theme.of(context).textSelectionHandleColor,
                          align: TextAlign.start),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: CustomScrollBehavior(),
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            color: Colors.blueAccent.withOpacity(.2),
                            onPressed: () {},
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'APPROVE',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                          FlatButton(
                            color: Colors.redAccent.withOpacity(.2),
                            onPressed: () {
                              //_rejectActionPrompt();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'REJECT',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
