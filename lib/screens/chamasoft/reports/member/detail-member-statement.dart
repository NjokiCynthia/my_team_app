import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class MemberDetailStatement extends StatefulWidget {
  final String groupName, groupEmail, groupPhone, date, title, description;
  final double singleBalance, payable, amount;
  final String memberName, recieptTitle;
  final Group group;
  //final double amount, payable;
  //singleBalance;
  const MemberDetailStatement(
      {Key key,
      this.groupName,
      this.groupEmail,
      this.groupPhone,
      this.payable,
      this.singleBalance,
      this.amount,
      this.date,
      this.title,
      this.group,
      this.recieptTitle,
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
  int fileName = DateTime.now().microsecondsSinceEpoch;

  final _screenshotController = ScreenshotController();

  //final _screenshotController = ScreenshotController();

  shareTransaction() {}

  void _takeScreenshot() async {
    final imageFile = await _screenshotController.capture();

    // Share.share(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tertiaryPageAppbar(
        context: context,
        title: "${widget.recieptTitle} Receipts",
        action: () => Navigator.of(context).pop(),
        elevation: 1,
        trailingAction: shareTransaction(),
        leadingIcon: LineAwesomeIcons
            .arrow_left, /* trailingIcon: LineAwesomeIcons.download */
      ),
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
                child: Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    width: 308.0,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: heading2(
                                  text: widget.title,
                                  color:
                                      // ignore: deprecated_member_use
                                      Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor),
                            ),
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
                                      currencyFormat.format(widget.amount),
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
                                  text: 'Due: ' +
                                      widget.group.groupCurrency +
                                      " " +
                                      currencyFormat.format(widget.payable),
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
                                  text: 'Bal: ' +
                                      widget.group.groupCurrency +
                                      " " +
                                      currencyFormat
                                          .format(widget.singleBalance),
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
                                  text: 'Date: ' + widget.date,
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
                                  text: "${widget.title.toLowerCase()}",
                                  fontSize: 14.0,
                                  color:
                                      // ignore: deprecated_member_use
                                      Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                  textAlign: TextAlign.center),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              LineAwesomeIcons.paper_plane,
                            ),
                            iconSize: 20.0,
                            onPressed: () async {
                              await Share.share(widget.memberName +
                                  " " +
                                  'paid ' +
                                  widget.group.groupCurrency +
                                  " " +
                                  currencyFormat.format(widget.amount) +
                                  " " +
                                  "on " +
                                  widget.date +
                                  " for " +
                                  widget.title.toLowerCase() +
                                  " to " +
                                  widget.groupName +
                                  "\n" +
                                  " https://bit.ly/3GkX3lM ");
                              //Share.shareFiles([convertWidgetToImage().path]);
                            },
                          ),
                          customTitleWithWrap(
                            text: 'Share',
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              LineAwesomeIcons.download,
                            ),
                            iconSize: 20.0,
                            onPressed: () {
                              // convertWidgetToImage();
                              //Share.shareFiles([convertWidgetToImage().path]);
                            },
                          ),
                          customTitleWithWrap(
                            text: 'Download',
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              LineAwesomeIcons.mobile,
                            ),
                            iconSize: 20.0,
                            onPressed: () {
                              _takeScreenshot();
                              //Share.shareFiles([convertWidgetToImage().path]);
                            },
                          ),
                          customTitleWithWrap(
                            text: 'Screenshot',
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
            ],
          )),
    );
  }
}
