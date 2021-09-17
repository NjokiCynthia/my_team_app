import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
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
        child: Container(
          decoration: primaryGradient(context),
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/icon/main.png',
                            width: 70.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              customTitle(
                                //text: _currentGroup.groupName,
                                text: group.groupName,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              customTitle(
                                text: group.groupPhone,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              customTitle(
                                text: group.groupEmail,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                              customTitle(
                                text: "Date: " + widget.date,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          customTitle(
                            text: "Deposit Reciept",
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          customTitle(
                            text: "Recieved From: " + widget.narration,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          customTitle(
                            text: "Amount Paid: " + widget.depositor + ' /-',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          customTitle(
                            text: "Payement For: " +
                                widget.type +
                                ' ; ' +
                                widget.name,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          customTitle(
                            text: "Amount : " + widget.depositor + ' /-',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                // ignore: deprecated_member_use
                Column(
                  // ignore: deprecated_member_use
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ignore: deprecated_member_use

                    // ignore: deprecated_member_use
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.w700),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () => {},
                      icon: Icon(
                        LineAwesomeIcons.file_pdf_o,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Generate PDF',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
