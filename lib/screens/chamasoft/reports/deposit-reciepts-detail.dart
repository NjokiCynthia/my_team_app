// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/screens/chamasoft/models/deposit.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/pdfAPI.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share/share.dart';

class DetailReciept extends StatefulWidget {
  final Deposit deposit;
  final Group group;
  const DetailReciept({this.deposit, this.group});

  @override
  _DetailRecieptState createState() => _DetailRecieptState();
}

class _DetailRecieptState extends State<DetailReciept> {
  //String name = NumberToWord().convert('en-in', int.parse(widget.name));

  final _screenshotController = ScreenshotController();

  Future _takeScreenshot(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/screenshot.png');
    image.writeAsBytesSync(bytes);

    final text =
        "Shared from Chamasoft Mobile. " + "\n" + "https://bit.ly/3GkX3lM";

    await Share.shareFiles([image.path], text: text);
  }

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
                child: Screenshot(
                  controller: _screenshotController,
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
                            heading2(
                                text: widget.deposit.type.toUpperCase(),
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor),
                            Image.asset(
                              'assets/icon/main.png',
                              width: 80.0,
                              height: 90.0,
                            ),
                            customTitleWithWrap(
                              text: widget.deposit.depositor,
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
                                          .format(widget.deposit.amount),
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
                                  text: 'Date: ' + widget.deposit.date,
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
                                      widget.deposit.reconciliation,
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
                                  text: "${widget.deposit.narration} ",
                                  fontSize: 14.0,
                                  color: Theme.of(context)
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
                      InkWell(
                        onTap: () async {
                          await Share.share(widget.deposit.depositor +
                              " " +
                              'deposited ' +
                              widget.deposit.narration +
                              " " +
                              "on " +
                              widget.deposit.date +
                              "\n" +
                              group.groupName +
                              "\n" +
                              "https://bit.ly/3GkX3lM ");
                        },
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                LineAwesomeIcons.paper_plane,
                              ),
                              iconSize: 20.0,
                              onPressed: () {},
                            ),
                            customTitleWithWrap(
                              text: 'Share',
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      InkWell(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  LineAwesomeIcons.download,
                                ),
                                iconSize: 20.0,
                                onPressed: () {},
                              ),
                              customTitleWithWrap(
                                text: 'Download',
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              ),
                            ],
                          ),
                          onTap: () async {
                            final pdfFile = await PdfApi.generateDepositPdf(
                                title: widget.deposit.type,
                                memberName: widget.deposit.depositor,
                                groupName: group.groupName,
                                groupCurrency: widget.group.groupCurrency,
                                depositAmount: currencyFormat
                                    .format(widget.deposit.amount),
                                depositDate: widget.deposit.date,
                                depositStatus: widget.deposit.reconciliation,
                                depositAbout: widget.deposit.narration);
                            PdfApi.openFile(pdfFile);
                          }),
                      SizedBox(
                        width: 20.0,
                      ),
                      InkWell(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  LineAwesomeIcons.phone,
                                ),
                                iconSize: 20.0,
                                onPressed: () {},
                              ),
                              customTitleWithWrap(
                                text: 'Screenshot',
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              ),
                            ],
                          ),
                          onTap: () async {
                            final imageFile =
                                await _screenshotController.capture();
                            _takeScreenshot(imageFile);
                          }),
                    ],
                  ),
                ],
              )),
            ],
          )),
    );
  }

  void convertWidgetToImage() {}
}
