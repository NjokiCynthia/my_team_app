import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/bank-loan-repayments.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/record-contribution-refund.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/record-expense.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-bank-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-contribution-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-fine-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-income.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-miscellaneous-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/account-to-account-transfer.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/contribution-transfer.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/create-invoice.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/fine-member.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal-requests.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/withdrawal-purpose.dart';
import 'package:chamasoft/utilities/svg-icons.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

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

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacementNamed(ChamasoftDashboard.namedRoute);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context, listen: false).getCurrentGroup();
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
              subtitle: 'WITHDRAWAL REQUEST',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WithdrawalPurpose(), settings: RouteSettings(arguments: 0))),
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
              subtitle: 'WITHDRAWAL REQUESTS',
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

    List<Widget> paymentsOptions = [
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['cash-register'],
              title: 'CONTRIBUTIONS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => RecordContributionPayment(),
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
              title: 'FINES',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => RecordFinePayment(), settings: RouteSettings(arguments: 0))),
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
                  builder: (BuildContext context) => RecordIncome(), settings: RouteSettings(arguments: 0))),
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
                  builder: (BuildContext context) => RecordMiscellaneousPayment(),
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
                  builder: (BuildContext context) => RecordBankLoan(), settings: RouteSettings(arguments: 0))),
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
                  builder: (BuildContext context) => RecordExpense(), settings: RouteSettings(arguments: 0))),
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
                  builder: (BuildContext context) => BankLoanRepayment(), settings: RouteSettings(arguments: 0))),
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
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['group'],
              title: 'INVOICE',
              subtitle: 'MEMBERS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CreateInvoice(), settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
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
                  builder: (BuildContext context) => FineMember(), settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['blockchain'],
              title: 'CONTRIBUTION',
              subtitle: 'TRANSFER',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ContributionTransfer(), settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Container(
                            height: 160.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
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
                                "Record Payments",
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
                                "Record Expenditure",
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
                : Center(
                    child: emptyList(
                        color: Colors.blue[400],
                        iconData: LineAwesomeIcons.angle_double_down,
                        text: "Admin Users Only - Temporary"))));
  }
}
