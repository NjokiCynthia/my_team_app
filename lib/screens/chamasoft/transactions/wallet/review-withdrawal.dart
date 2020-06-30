import 'package:chamasoft/screens/chamasoft/models/loan-signatory.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal-request.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-scroll-behaviour.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
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

  void rejectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
            text: "Reason for Rejecting",
            textAlign: TextAlign.start,
            color: Theme.of(context).textSelectionHandleColor,
          ),
          content: TextFormField(
            //controller: controller,
            keyboardType: TextInputType.text,
            style: inputTextStyle(),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
              )),
              // hintText: 'Phone Number or Email Address',
              labelText: "Enter Reason",
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    fontFamily: 'SegoeUI',
                    color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Proceed",
                style: new TextStyle(
                  color: primaryColor,
                  fontFamily: 'SegoeUI',
                ),
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
                              heading2(
                                text: "${widget.withdrawalRequest.purpose}",
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.start,
                              ),
                              customTitle(
                                text: "Requested by Peter Parker",
                                fontSize: 12.0,
                                color: primaryColor,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            customTitle(
                              text: "Ksh ",
                              fontSize: 18.0,
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w400,
                            ),
                            heading2(
                              text:
                                  "${currencyFormat.format(widget.withdrawalRequest.amount)}",
                              color: Theme.of(context).textSelectionHandleColor,
                              textAlign: TextAlign.end,
                            ),
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
                        subtitle1(
                          text: "Particulars: ",
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        customTitle(
                          textAlign: TextAlign.start,
                          text: "${widget.withdrawalRequest.particulars}",
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        subtitle1(
                          text: "Recipient: ",
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        Expanded(
                            child: customTitle(
                          textAlign: TextAlign.start,
                          text: "Peter Parker - 0712000111",
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w600,
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        subtitle1(
                          text: "Requested On: ",
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        Expanded(
                            child: customTitle(
                          textAlign: TextAlign.start,
                          text:
                              "${defaultDateFormat.format(widget.withdrawalRequest.requestDate)}",
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w600,
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        subtitle1(
                          text: "Description: ",
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        Expanded(
                          child: customTitle(
                            textAlign: TextAlign.start,
                            text:
                                "Lorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsum",
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w600,
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
                          textAlign: TextAlign.start),
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
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: 'SegoeUI',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          FlatButton(
                            color: Colors.redAccent.withOpacity(.2),
                            onPressed: () {
                              rejectDialog();
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
