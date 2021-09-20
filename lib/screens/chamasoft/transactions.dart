import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/bank-loan-repayments.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/record-contribution-refund.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/record-expense.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/reconcile-deposit-list.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/reconcile-withdrawal-list.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-bank-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-contribution-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-fine-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-income.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-miscellaneous-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/account-to-account-transfer.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/fine-member.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/create-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/record-loan-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal-requests.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/withdrawal-purpose.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/svg-icons.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import 'reports/member/contribution-statement.dart';

class ChamasoftTransactions extends StatefulWidget {
  ChamasoftTransactions({
    this.appBarElevation,
  });

  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftTransactionsState createState() => _ChamasoftTransactionsState();
}

class _ChamasoftTransactionsState extends State<ChamasoftTransactions> {
  ScrollController _scrollController;
  List<Map> deposits = [];
  List<Map> withdrawals = [];

  void _scrollListener() {
    widget.appBarElevation(_scrollController.offset);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context)
        .pushReplacementNamed(ChamasoftDashboard.namedRoute);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context, listen: false).getCurrentGroup();

    final List<RecentTransactionSummary> recentTransactions =
        Provider.of<Dashboard>(context, listen: false).recentMemberTransactions;
    if (recentTransactions.length > 10) {
      recentTransactions.length = 10;
    }

    List<Widget> eWalletOptions = [
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['wallet'],
              title: 'CREATE',
              subtitle: 'WITHDRAWAL',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WithdrawalPurpose(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['couple'],
              title: 'REVIEW',
              subtitle: 'WITHDRAWALS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ReviewWithdrawalRequests(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
    ];

    List<Widget> loanOptions = [
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['money-bag'],
              title: 'RECORD',
              subtitle: 'MEMBER LOAN',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CreateMemberLoan(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['safe'],
              title: 'RECORD',
              subtitle: 'REPAYMENTS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => RecordLoanPayment(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['safe'],
              title: 'BANK LOAN',
              subtitle: 'REPAYMENTS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BankLoanRepayment(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
    ];

    List<Widget> paymentsOptions = [
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['money-bag'],
              title: 'RECONCILE',
              subtitle: 'DEPOSITS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext ctx) => ReconcileDeposits())),
              margin: 0,
              imageHeight: 100.0,
              notifications: 2)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['card-payment'],
              title: 'RECONCILE',
              subtitle: 'WITHDRAWALS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext ctx) => ReconcileWithdrawals())),
              margin: 0,
              imageHeight: 100.0,
              notifications: 2)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['cash-register'],
              title: 'CONTRIBUTION',
              subtitle: "PAYMENTS",
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RecordContributionPayment(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['refund'],
              title: 'FINE',
              subtitle: "PAYMENTS",
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => RecordFinePayment(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['cash-in-hand'],
              title: 'INCOME',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => RecordIncome(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['transaction'],
              title: 'MISCELLANEOUS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RecordMiscellaneousPayment(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['bank'],
              title: 'BANK LOANS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => RecordBankLoan(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
    ];

    List<Widget> expenditureOptions = [
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['invoice'],
              title: 'EXPENSES',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => RecordExpense(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['money-bag'],
              title: 'CONTRIBUTION',
              subtitle: 'REFUND',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => RecordContributionRefund(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
    ];

    List<Widget> invoicingOptions = [
//      SizedBox(
//        width: 16.0,
//      ),
//      Container(
//          width: 132.0,
//          child: svgGridButton(
//              context: context,
//              icon: customIcons['group'],
//              title: 'INVOICE',
//              subtitle: 'MEMBERS',
//              color: Colors.blue[400],
//              isHighlighted: false,
//              action: () => Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => CreateInvoice(), settings: RouteSettings(arguments: 0))),
//              margin: 0,
//              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['account'],
              title: 'FINE',
              subtitle: 'MEMBER',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => FineMember(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
//      SizedBox(
//        width: 16.0,
//      ),
//      Container(
//          width: 132.0,
//          child: svgGridButton(
//              context: context,
//              icon: customIcons['blockchain'],
//              title: 'CONTRIBUTION',
//              subtitle: 'TRANSFER',
//              color: Colors.blue[400],
//              isHighlighted: false,
//              action: () => Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => ContributionTransfer(), settings: RouteSettings(arguments: 0))),
//              margin: 0,
//              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['bank-cards'],
              title: 'ACCOUNT TO',
              subtitle: 'ACCOUNT TRANSFER',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AccountToAccountTransfer(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
    ];

    return new WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
            child: group.isGroupAdmin
                ? SingleChildScrollView(
                    // controller: _scrollController,
                    child: Column(
                      children: <Widget>[
                        if (group.onlineBankingEnabled)
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "E-Wallet",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontFamily: 'SegoeUI',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Feather.more_horizontal,
                                      color: Colors.blueGrey,
                                    ),
                                    onPressed: () {})
                              ],
                            ),
                          ),
                        if (group.onlineBankingEnabled)
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: Container(
                              height: 160.0,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    EdgeInsets.only(top: 5.0, bottom: 10.0),
                                physics: BouncingScrollPhysics(),
                                children: eWalletOptions,
                              ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Record Deposit",
                                style: TextStyle(
                                  color: Colors.blueGrey[400],
                                  fontFamily: 'SegoeUI',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Feather.more_horizontal,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () {})
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Container(
                            height: 160.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                              physics: BouncingScrollPhysics(),
                              children: paymentsOptions,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Record Withdrawal",
                                style: TextStyle(
                                  color: Colors.blueGrey[400],
                                  fontFamily: 'SegoeUI',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Feather.more_horizontal,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () {})
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Container(
                            height: 160.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                              physics: BouncingScrollPhysics(),
                              children: expenditureOptions,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Loans",
                                style: TextStyle(
                                  color: Colors.blueGrey[400],
                                  fontFamily: 'SegoeUI',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Feather.more_horizontal,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () {})
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Container(
                            height: 160.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                              physics: BouncingScrollPhysics(),
                              children: loanOptions,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Invoicing & Transfers",
                                style: TextStyle(
                                  color: Colors.blueGrey[400],
                                  fontFamily: 'SegoeUI',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Feather.more_horizontal,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () {})
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                          child: Container(
                            height: 160.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                              physics: BouncingScrollPhysics(),
                              children: invoicingOptions,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : recentTransactions.length > 0
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Column(
                            children: [
                              ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  RecentTransactionSummary transaction =
                                      recentTransactions[index];
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        16.0, 4.0, 16.0, 4.0),
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  Feather.bar_chart_2,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  size: 24.0,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      subtitle1(
                                                          text: transaction
                                                              .paymentTitle,
                                                          color: Theme.of(
                                                                  context)
                                                              // ignore: deprecated_member_use
                                                              .textSelectionHandleColor,
                                                          textAlign:
                                                              TextAlign.start),
                                                      subtitle2(
                                                          text: transaction
                                                              .description,
                                                          color: Theme.of(
                                                                  context)
                                                              // ignore: deprecated_member_use
                                                              .textSelectionHandleColor,
                                                          textAlign:
                                                              TextAlign.start),
                                                      subtitle2(
                                                          text: transaction
                                                                  .paymentMethod +
                                                              " Payment",
                                                          color: Theme.of(
                                                                  context)
                                                              // ignore: deprecated_member_use
                                                              .textSelectionHandleColor,
                                                          textAlign:
                                                              TextAlign.start)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              subtitle1(
                                                  text: group.groupCurrency +
                                                      " " +
                                                      currencyFormat.format(
                                                          transaction
                                                              .paymentAmount),
                                                  color: Theme.of(context)
                                                      // ignore: deprecated_member_use
                                                      .textSelectionHandleColor,
                                                  textAlign: TextAlign.start),
                                              subtitle2(
                                                  text: transaction.paymentDate,
                                                  color: Theme.of(context)
                                                      // ignore: deprecated_member_use
                                                      .textSelectionHandleColor,
                                                  textAlign: TextAlign.start),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: recentTransactions.length,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              //if (recentTransactions.length == 10)
                              defaultButton(
                                context: context,
                                text: "View More Transactions",
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ContributionStatement(
                                            statementFlag:
                                                CONTRIBUTION_STATEMENT),
                                    settings: RouteSettings(arguments: 0),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
                        child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  customIcons['no-data'],
                                  semanticsLabel: 'icon',
                                  height: 120.0,
                                ),
                                customTitleWithWrap(
                                    text: "Nothing to display!",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                    textAlign: TextAlign.center,
                                    color: Colors.blueGrey[400]),
                                customTitleWithWrap(
                                    text:
                                        "Sorry, you haven't made any transactions",
                                    //fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    textAlign: TextAlign.center,
                                    color: Colors.blueGrey[400])
                              ],
                            )),
                      )
            // Center(
            //     child: emptyList(
            //       color: Colors.blue[400],
            //       iconData: LineAwesomeIcons.angle_double_down,
            //       text: "Admin Users Only - Temporary"
            //     )
            //   )
            ));
  }
}
