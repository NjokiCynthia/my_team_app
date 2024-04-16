import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
// ignore: unused_import
import 'package:chamasoft/screens/chamasoft/models/deposit.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class DetailRecieptWithdrawl extends StatefulWidget {
  final Withdrawal withdrawal;
  final Group group;
  const DetailRecieptWithdrawl({this.withdrawal, this.group});

  @override
  _DetailRecieptWithdrawlState createState() => _DetailRecieptWithdrawlState();
}

class _DetailRecieptWithdrawlState extends State<DetailRecieptWithdrawl> {
  //String name = NumberToWord().convert('en-in', int.parse(widget.name));
  @override
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "Withdrawal Receipts",
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
                         
                          heading2(
                              text: widget.withdrawal.name.toUpperCase(),
                              color:
                                 
                                  Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor),
                          Image.asset(
                            'assets/icon/main.png',
                            width: 80.0,
                            height: 90.0,
                          ),

                          customTitleWithWrap(
                            text: widget.withdrawal.recipient,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                               
                                .textSelectionTheme
                                .selectionHandleColor,
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
                                text: group.groupName,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                   
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              ),
                              customTitleWithWrap(
                                text: group.groupPhone != "null"
                                    ? group.groupPhone
                                    : '--',
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                   
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              ),
                              customTitleWithWrap(
                                text: group.groupEmail != "null"
                                    ? group.groupEmail
                                    : '--',
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                   
                                    .textSelectionTheme
                                    .selectionHandleColor,
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
                                    currencyFormat
                                        .format(widget.withdrawal.amount),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                   
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              customTitleWithWrap(
                                text: 'Date: ' + widget.withdrawal.recordedOn,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                   
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              customTitleWithWrap(
                                text: 'Status: ' +
                                    widget.withdrawal.reconciliation,
                                fontSize: 18,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                   
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              ),
                            ],
                          ),

                          SizedBox(height: 5.0),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: subtitle2(
                                text: "${widget.withdrawal.narration} ",
                                fontSize: 14.0,
                                color:
                                   
                                    Theme.of(context)
                                       
                                        .textSelectionTheme
                                        .selectionHandleColor,
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

    // return Scaffold(
    //   appBar: secondaryPageAppbar(
    //       context: context,
    //       title: "Deposit Receipts",
    //       action: () => Navigator.of(context).pop(),
    //       elevation: 1,
    //       leadingIcon: LineAwesomeIcons.arrow_left),
    //   backgroundColor: Theme.of(context).backgroundColor,
    //   body: RefreshIndicator(
    //     backgroundColor: (themeChangeProvider.darkTheme)
    //         ? Colors.blueGrey[800]
    //         : Colors.white,
    //     // ignore: missing_return
    //     onRefresh: () {},
    //     child: Container(
    //       decoration: primaryGradient(context),
    //       width: double.infinity,
    //       height: double.infinity,
    //       child: Padding(
    //         padding: const EdgeInsets.all(10.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Image.asset(
    //                         'assets/icon/main.png',
    //                         width: 70.0,
    //                       ),
    //                       Column(
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         crossAxisAlignment: CrossAxisAlignment.end,
    //                         children: [
    //                           customTitle(
    //                             //text: _currentGroup.groupName,
    //                             text: group.groupName,
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w400,
    //                             color: Theme.of(context)
    //                                
    //                                 .textSelectionTheme.selectionHandleColor,
    //                           ),
    //                           customTitle(
    //                             text: group.groupPhone,
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w400,
    //                             color: Theme.of(context)
    //                                
    //                                 .textSelectionTheme.selectionHandleColor,
    //                           ),
    //                           customTitle(
    //                             text: group.groupEmail,
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w400,
    //                             color: Theme.of(context)
    //                                
    //                                 .textSelectionTheme.selectionHandleColor,
    //                           ),
    //                           customTitle(
    //                             text: "Date: " + widget.date,
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w400,
    //                             color: Theme.of(context)
    //                                
    //                                 .textSelectionTheme.selectionHandleColor,
    //                           ),
    //                         ],
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: 20.0,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     crossAxisAlignment: CrossAxisAlignment.stretch,
    //                     children: [
    //                       customTitle(
    //                         text: "Deposit Reciept",
    //                         fontSize: 18,
    //                         fontWeight: FontWeight.normal,
    //                         color: Theme.of(context)
    //                            
    //                             .textSelectionTheme.selectionHandleColor,
    //                         textAlign: TextAlign.center,
    //                       ),
    //                       SizedBox(
    //                         height: 20.0,
    //                       ),
    //                       customTitle(
    //                         text: "Recieved From: " + widget.narration,
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.normal,
    //                         color: Theme.of(context)
    //                            
    //                             .textSelectionTheme.selectionHandleColor,
    //                         textAlign: TextAlign.left,
    //                       ),
    //                       SizedBox(
    //                         height: 10.0,
    //                       ),
    //                       customTitle(
    //                         text: "Amount Paid: " + widget.depositor + ' /-',
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.normal,
    //                         color: Theme.of(context)
    //                            
    //                             .textSelectionTheme.selectionHandleColor,
    //                         textAlign: TextAlign.left,
    //                       ),
    //                       SizedBox(
    //                         height: 10.0,
    //                       ),
    //                       customTitle(
    //                         text: "Payment For: " +
    //                             widget.type +
    //                             ' ; ' +
    //                             widget.name,
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.normal,
    //                         color: Theme.of(context)
    //                            
    //                             .textSelectionTheme.selectionHandleColor,
    //                         textAlign: TextAlign.left,
    //                       ),
    //                       SizedBox(
    //                         height: 10.0,
    //                       ),
    //                       customTitle(
    //                         text: "Amount : " + widget.depositor + ' /-',
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.normal,
    //                         color: Theme.of(context)
    //                            
    //                             .textSelectionTheme.selectionHandleColor,
    //                         textAlign: TextAlign.left,
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ),
    //             SizedBox(
    //               height: 20.0,
    //             ),
    //            
    //             Column(
    //              
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                

    //                
    //                 TextButton.icon(
    //                   style: TextButton.styleFrom(
    //                     textStyle: TextStyle(
    //                         color: Colors.black,
    //                         fontFamily: 'SegoeUI',
    //                         fontWeight: FontWeight.w700),
    //                     backgroundColor: primaryColor,
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(5.0),
    //                     ),
    //                   ),
    //                   onPressed: () => {},
    //                   icon: Icon(
    //                     LineAwesomeIcons.file_pdf_o,
    //                     color: Colors.white,
    //                   ),
    //                   label: Text(
    //                     'Generate PDF',
    //                     style: TextStyle(color: Colors.white),
    //                   ),
    //                 ),
    //               ],
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  void convertWidgetToImage() {}
}
