import 'dart:math';

import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/dataTable.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class LoanAmortization extends StatefulWidget {
  // final generalAmount;
  // LoanAmortization({this.generalAmount});

  // final LoanType amountToRefund;
  // LoanAmortization({this.amountToRefund});

  @override
  _LoanAmortizationState createState() => _LoanAmortizationState();
}

class _LoanAmortizationState extends State<LoanAmortization> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
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
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var dateTime = DateTime.parse(date.toIso8601String());
    var formate2 = "${dateTime.year}-${dateTime.month}-${dateTime.day}";

    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final LoanProduct _loanProduct = arguments['loanProduct'];
    final generalAmount = arguments['generalAmount'];

    final Group groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    String monthsOfRepayment = _loanProduct.fixedRepaymentPeriod != ""
        ? _loanProduct.fixedRepaymentPeriod
        : _loanProduct.maximumRepaymentPeriod;

    final interestRate = int.parse(_loanProduct.interestRate);

    // final payementPerMonth = ((generalAmount *
    //         interestRate *
    //         pow(1 + interestRate, int.parse(monthsOfRepayment))) /
    //     (pow(1 + interestRate, int.parse(monthsOfRepayment)) - 1));

    //final balance = (amountToRefund - payementPerMonth);

    final interest = interestRate / 100;
    final result =
        (1 - pow(1 + interest, int.parse(monthsOfRepayment) * -1)) / interest;
    final payment = double.parse((generalAmount / result).toStringAsFixed(2));

    final totalInterestAmount =
        generalAmount * interest * int.parse(monthsOfRepayment);

    final amountToRefund = generalAmount + totalInterestAmount;
    // ignore: unused_local_variable
    final interestAmount = amountToRefund - generalAmount;

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Loan Terms & Amortization",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: heading2(
                          text: _loanProduct.name /*widget.typeLoan.loanName*/,
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.start),
                    ),
                    heading2(
                        text:
                            "${groupObject.groupCurrency}${currencyFormat.format(amountToRefund)}",
                        //generalAmount.toString(),
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.start)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        subtitle1(
                          text: "Interest Rate: ",
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        customTitle(
                          textAlign: TextAlign.start,
                          text: _loanProduct.description,
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        subtitle1(
                          text: "Repayment Period: ",
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        customTitle(
                          textAlign: TextAlign.start,
                          text: monthsOfRepayment + " Month(s)",
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        subtitle1(
                          text: "Application Date: ",
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        customTitle(
                          textAlign: TextAlign.start,
                          text: formate2,
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            // width: double.infinity,
            child: CustomDataTable(
              rowItems: generateTableRows(
                  payment, generalAmount, interest, monthsOfRepayment, date),
            ),
          ),
          Container(
            color: Colors.cyanAccent,
            height: 56.0,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      subtitle1(text: 'Total'),
                      SizedBox(
                        width: 10.0,
                      ),
                      subtitle1(text: "--"),
                      SizedBox(
                        width: 20.0,
                      ),
                      subtitle1(text: "--"),
                      SizedBox(
                        width: 20.0,
                      ),
                      subtitle1(text: "--"),
                      SizedBox(
                        width: 15.0,
                      ),
                      subtitle1(text: 'Balance'),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DataRow> generateTableRows(double payment, generalAmount,
      double interest, String monthsOfRepayment, DateTime date) {
    List<DataRow> rows = <DataRow>[];
    double newInterest;
    double newCapital;
    double newRate = interest / 100 / 12;
    double newAmount = generalAmount;
    //DateTime date;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var dateTime = DateTime.parse(date.toIso8601String());
    //var formate2 = "${dateTime.year}-${dateTime.month}-${dateTime.day}";

    for (var i = 0; i < int.parse(monthsOfRepayment); i++) {
      newInterest = double.parse((newAmount * newRate).toStringAsFixed(2));
      newCapital = double.parse((payment - newInterest).toStringAsFixed(2));
      newAmount = double.parse((newAmount - newCapital).toStringAsFixed(2));
      DateTime date = new DateTime(now.year, now.month + (i + 1), now.day);
      var formate2 =
          "${dateTime.year}-${dateTime.month + (i + 1)}-${dateTime.day}";


      if (newAmount <= 0) newAmount = 0;
      rows.add(DataRow(
        cells: <DataCell>[
          DataCell(Text((i + 1).toString())),
          DataCell(Text("$formate2")),
          DataCell(Text(newInterest.toString())),
          DataCell(Text(newCapital.toString())),
          DataCell(Text(newAmount.toString()))
        ],
      ));
    }
    return rows;
  }
}
