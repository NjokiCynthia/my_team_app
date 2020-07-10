import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class WithdrawalReceipts extends StatefulWidget {
  @override
  _WithdrawalReceiptsState createState() => _WithdrawalReceiptsState();
}

class _WithdrawalReceiptsState extends State<WithdrawalReceipts> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  Future<void> _future;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _getWithdrawals(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchWithdrawals();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getWithdrawals(context);
          });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _future = _getWithdrawals(context);
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
    return Scaffold(
        appBar: secondaryPageAppbar(
            context: context,
            title: "Withdrawals Receipts",
            action: () => Navigator.of(context).pop(),
            elevation: _appBarElevation,
            leadingIcon: LineAwesomeIcons.arrow_left),
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _getWithdrawals(context),
                    child: Consumer<Groups>(builder: (context, data, child) {
                      if (data.getWithdrawals != null) {
                        List<Withdrawal> withdrawals = data.getWithdrawals;
                        return Container(
                          decoration: primaryGradient(context),
                          width: double.infinity,
                          height: double.infinity,
                          child: withdrawals.length > 0
                              ? ListView.builder(
                                  itemBuilder: (context, index) {
                                    Withdrawal withdrawal = withdrawals[index];
                                    return WithdrawalCard(
                                      withdrawal: withdrawal,
                                      details: () {},
                                      voidItem: () {},
                                    );
                                  },
                                  itemCount: withdrawals.length)
                              : emptyList(
                                  color: Colors.blue[400], iconData: LineAwesomeIcons.angle_double_up, text: "There are no withdrawals to display"),
                        );
                      } else
                        return Container();
                    }))));
  }
}

class WithdrawalCard extends StatelessWidget {
  const WithdrawalCard({Key key, @required this.withdrawal, this.details, this.voidItem}) : super(key: key);

  final Withdrawal withdrawal;
  final Function details, voidItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderOnForeground: false,
        child: Container(
            decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            customTitle(
                              text: withdrawal.type,
                              fontSize: 16.0,
                              color: Theme.of(context).textSelectionHandleColor,
                              textAlign: TextAlign.start,
                            ),
                            subtitle2(
                              text: withdrawal.name,
                              textAlign: TextAlign.start,
                              color: Theme.of(context).textSelectionHandleColor,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          customTitle(
                            text: "Ksh ",
                            fontSize: 18.0,
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w400,
                          ),
                          heading2(
                            text: currencyFormat.format(withdrawal.amount),
                            color: Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        subtitle2(text: "Recipient", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                        subtitle1(text: withdrawal.recipient, color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        subtitle2(text: "Withdrawal Date", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.end),
                        subtitle1(text: withdrawal.withdrawalDate, color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.end)
                      ],
                    ),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Expanded(
//                      flex: 1,
//                      child: Container(
//                          decoration: BoxDecoration(
//                              border: Border(
//                                  top: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0),
//                                  right: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 0.5))),
//                          child: plainButton(
//                              text: "SHOW DETAILS",
//                              size: 16.0,
//                              spacing: 2.0,
//                              color: Theme.of(context).primaryColor.withOpacity(0.5),
//                              // loan.status == 2 ? Theme.of(context).primaryColor.withOpacity(0.5) : Theme.of(context).primaryColor,
//                              action: details) //loan.status == 2 ? null : repay),
//                          ),
//                    ),
//                    Expanded(
//                      flex: 1,
//                      child: Container(
//                        decoration: BoxDecoration(
//                            border: Border(
//                                top: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0),
//                                left: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 0.5))),
//                        child: plainButton(text: "VOID", size: 16.0, spacing: 2.0, color: Colors.blueGrey, action: voidItem),
//                      ),
//                    ),
//                  ],
//                )
              ],
            )),
      ),
    );
  }
}