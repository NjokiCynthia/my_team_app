import 'package:chamasoft/providers/groups.dart';
// import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class DetailReciept extends StatefulWidget {
  final String date, name, depositor, narration, type, reconciliation, amount;
  const DetailReciept(this.date, this.amount, this.depositor, this.narration,
      this.type, this.reconciliation, this.name);

  //String name1 = NumberToWord().convert('en-in', int.parse(name));

  //const DetailReciept({ Key? key }) : super(key: key);

  @override
  _DetailRecieptState createState() => _DetailRecieptState();
}

class _DetailRecieptState extends State<DetailReciept> {
  //String name = NumberToWord().convert('en-in', int.parse(widget.name));
  @override
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context, listen: false).getCurrentGroup();

    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "Deposit Receipts",
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
                  height: 300.0,
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
                              text: 'Contribution Payment',
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context).textSelectionHandleColor),
                          Image.asset(
                            'assets/icon/main.png',
                            width: 80.0,
                            height: 90.0,
                          ),
                          customTitleWithWrap(
                            text: widget.narration,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              customTitleWithWrap(
                                text: 'Paid KES. ' + widget.depositor,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              customTitleWithWrap(
                                text: 'To: ' + group.groupName,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              customTitleWithWrap(
                                text: 'On: ' + widget.date,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              customTitleWithWrap(
                                text: 'Status: ' + widget.name,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              LineAwesomeIcons.share,
                            ),
                            iconSize: 20.0,
                            onPressed: () {
                              convertWidgetToImage();
                              //Share.shareFiles([convertWidgetToImage().path]);
                            },
                          ),
                          customTitleWithWrap(text: 'Share', fontSize: 12.0)
                        ],
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              LineAwesomeIcons.download,
                            ),
                            iconSize: 20.0,
                            onPressed: () {
                              convertWidgetToImage();
                              //Share.shareFiles([convertWidgetToImage().path]);
                            },
                          ),
                          customTitleWithWrap(text: 'Download', fontSize: 12.0)
                        ],
                      ),
                    ],
                  ),
                ],
              )
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
    //                                 // ignore: deprecated_member_use
    //                                 .textSelectionHandleColor,
    //                           ),
    //                           customTitle(
    //                             text: group.groupPhone,
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w400,
    //                             color: Theme.of(context)
    //                                 // ignore: deprecated_member_use
    //                                 .textSelectionHandleColor,
    //                           ),
    //                           customTitle(
    //                             text: group.groupEmail,
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w400,
    //                             color: Theme.of(context)
    //                                 // ignore: deprecated_member_use
    //                                 .textSelectionHandleColor,
    //                           ),
    //                           customTitle(
    //                             text: "Date: " + widget.date,
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w400,
    //                             color: Theme.of(context)
    //                                 // ignore: deprecated_member_use
    //                                 .textSelectionHandleColor,
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
    //                             // ignore: deprecated_member_use
    //                             .textSelectionHandleColor,
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
    //                             // ignore: deprecated_member_use
    //                             .textSelectionHandleColor,
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
    //                             // ignore: deprecated_member_use
    //                             .textSelectionHandleColor,
    //                         textAlign: TextAlign.left,
    //                       ),
    //                       SizedBox(
    //                         height: 10.0,
    //                       ),
    //                       customTitle(
    //                         text: "Payement For: " +
    //                             widget.type +
    //                             ' ; ' +
    //                             widget.name,
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.normal,
    //                         color: Theme.of(context)
    //                             // ignore: deprecated_member_use
    //                             .textSelectionHandleColor,
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
    //                             // ignore: deprecated_member_use
    //                             .textSelectionHandleColor,
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
    //             // ignore: deprecated_member_use
    //             Column(
    //               // ignore: deprecated_member_use
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 // ignore: deprecated_member_use

    //                 // ignore: deprecated_member_use
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
