import 'package:chamasoft/screens/chamasoft/models/transaction-statement-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class TransactionStatement extends StatefulWidget {
  @override
  _TransactionStatementState createState() => _TransactionStatementState();
}

class _TransactionStatementState extends State<TransactionStatement> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<TransactionStatementRow> list = [
      TransactionStatementRow(
        id: 1,
        date: DateTime.now(),
        deposit: 10000,
        withdrawal: 0,
        balance: 10000,
        description:
            "Contribution payment from Mike Will for Monthly Welfare to Chamasoft E-Wallet (Headoffice) - DVEA WELFARE ONLINE BANKING (10020009) : Payment transaction receipt number OD97DHZEJJ",
      ),
      TransactionStatementRow(
        id: 1,
        date: DateTime.now(),
        deposit: 10000,
        withdrawal: 0,
        balance: 10000,
        description:
            "Contribution payment from Peter Parker for Monthly Welfare to Chamasoft E-Wallet (Headoffice) - DVEA WELFARE ONLINE BANKING (10020009) : Payment transaction receipt number OD97DHZEJJ",
      ),
      TransactionStatementRow(
        id: 1,
        date: DateTime.now(),
        deposit: 10000,
        withdrawal: 0,
        balance: 30000,
        description:
            "Contribution payment from Natasha Romanoff for Monthly Welfare to Chamasoft E-Wallet (Headoffice) - DVEA WELFARE ONLINE BANKING (10020009) : Payment transaction receipt number OD97DHZEJJ",
      ),
      TransactionStatementRow(
        id: 1,
        date: DateTime.now(),
        deposit: 0,
        withdrawal: 14000,
        balance: 16000,
        description:
            "Expense for Bank Charges,withdrawn from Chamasoft E-Wallet (Headoffice) - DVEA WELFARE ONLINE BANKING (10020009) : 7212124212 - Tony Stark withdrawal charges : OAU0PG0Y8C-1",
      ),
    ];
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Transaction Statement",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            color: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Color(0xffededfe),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            heading2(
                                text: "Total Balance",
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                align: TextAlign.start),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                subtitle2(
                                    text: "Deposits ",
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    align: TextAlign.start),
                                subtitle1(
                                    text: "Ksh 60,000",
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    align: TextAlign.start),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                subtitle2(
                                    text: "Withdrawals ",
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    align: TextAlign.start),
                                subtitle1(
                                    text: "Ksh 10,000",
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    align: TextAlign.start),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    heading2(
                        text: "Ksh 50,000",
                        color: Theme.of(context).textSelectionHandleColor,
                        align: TextAlign.start)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        subtitle2(
                          text: "Statement as At",
                          color: Theme.of(context).textSelectionHandleColor,
                          align: TextAlign.start,
                        ),
                        customTitle(
                          text: "20 Feb 2021",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textSelectionHandleColor,
                          align: TextAlign.start,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          subtitle2(
                            text: "Statement Period",
                            color: Theme.of(context).textSelectionHandleColor,
                            align: TextAlign.end,
                          ),
                          customTitle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            text: "12 Oct 2019 to 20 Feb 2021",
                            color: Theme.of(context).textSelectionHandleColor,
                            align: TextAlign.end,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: customTitle(
                      text: "Deposits",
                      fontSize: 13.0,
                      color: Theme.of(context).textSelectionHandleColor,
                      align: TextAlign.center),
                ),
                Expanded(
                  flex: 1,
                  child: customTitle(
                      text: "Withdrawals",
                      fontSize: 13.0,
                      color: Theme.of(context).textSelectionHandleColor,
                      align: TextAlign.center),
                ),
                Expanded(
                  flex: 1,
                  child: customTitle(
                      text: "Balance",
                      fontSize: 13.0,
                      color: Theme.of(context).textSelectionHandleColor,
                      align: TextAlign.center),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                TransactionStatementRow row = list[index];
                return TransactionStatementBody(
                  row: row,
                  position: index % 2 == 0,
                );
              },
              itemCount: list.length,
            ),
          ),
        ],
      ),
    );
  }
}
