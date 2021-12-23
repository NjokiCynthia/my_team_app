import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class MemberDetailStatement extends StatefulWidget {
  final String groupName,
      groupEmail,
      groupPhone,
      date,
      title,
      description,
      memberName;
  final Group group;
  //final double amount, payable;
  //singleBalance;
  const MemberDetailStatement(
      {Key key,
      this.groupName,
      this.groupEmail,
      this.groupPhone,
      //  this.amount,
      // this.payable,
      //   this.singleBalance,
      this.date,
      this.title,
      this.group,
      this.memberName,
      this.description})
      : super(key: key);

  @override
  _MemberDetailStatementState createState() => _MemberDetailStatementState();
}

class _MemberDetailStatementState extends State<MemberDetailStatement> {
  double singleBalance = 30000;
  double payable = 2100;
  double amount = 1000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "Contribution Receipts",
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: RefreshIndicator(
          backgroundColor: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Colors.white,
          // ignore: missing_return
          onRefresh: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 300.0,
                  // height: 400.0,
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    borderOnForeground: false,
                    child: Container(
                      decoration: cardDecoration(
                          gradient: plainCardGradient(context),
                          context: context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          // ignore: deprecated_member_use
                          heading2(
                              text: 'Kennedy Mwangi',
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context).textSelectionHandleColor),
                          Image.asset(
                            'assets/icon/main.png',
                            width: 80.0,
                            height: 90.0,
                          ),

                          customTitleWithWrap(
                            text: widget.memberName,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 0.5,
                            dashLength: 2.0,
                            dashColor: Colors.black45,
                            dashRadius: 0.0,
                            dashGapLength: 2.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              customTitleWithWrap(
                                text: widget.groupName,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              customTitleWithWrap(
                                text: widget.groupPhone != "null"
                                    ? widget.groupPhone
                                    : '--',
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              customTitleWithWrap(
                                text: widget.groupEmail != "null"
                                    ? widget.groupEmail
                                    : '--',
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                            ],
                          ),
                          DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 0.5,
                            dashLength: 2.0,
                            dashColor: Colors.black45,
                            dashRadius: 0.0,
                            dashGapLength: 2.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              customTitleWithWrap(
                                text: 'Paid: ' +
                                    widget.group.groupCurrency +
                                    " " +
                                    currencyFormat.format(3000),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              customTitleWithWrap(
                                text: 'Due: KES 750' +
                                    widget.group.groupCurrency +
                                    " " +
                                    currencyFormat.format(payable),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              customTitleWithWrap(
                                text: 'Paid: KES 5,000' +
                                    widget.group.groupCurrency +
                                    " " +
                                    currencyFormat.format(singleBalance.abs()),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              customTitleWithWrap(
                                text: 'Date: 12-19-2021',
                                //+ widget.date,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                            ],
                          ),

                          SizedBox(height: 5.0),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: subtitle2(
                                text: " ",
                                fontSize: 14.0,
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionHandleColor,
                                textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: [
              //         Row(
              //           children: [
              //             IconButton(
              //               icon: Icon(
              //                 LineAwesomeIcons.share,
              //               ),
              //               iconSize: 20.0,
              //               onPressed: () {
              //                 //Share.shareFiles([convertWidgetToImage().path]);
              //               },
              //             ),
              //             customTitleWithWrap(text: 'Share', fontSize: 12.0)
              //           ],
              //         ),
              //         SizedBox(
              //           width: 20.0,
              //         ),
              //         Row(
              //           children: [
              //             IconButton(
              //               icon: Icon(
              //                 LineAwesomeIcons.download,
              //               ),
              //               iconSize: 20.0,
              //               onPressed: () {
              //                 convertWidgetToImage();
              //                 //Share.shareFiles([convertWidgetToImage().path]);
              //               },
              //             ),
              //             customTitleWithWrap(text: 'Download', fontSize: 12.0)
              //           ],
              //         ),
              //       ],
              //     ),
              //   ],
              // )
            ],
          )),
    );
  }
}
