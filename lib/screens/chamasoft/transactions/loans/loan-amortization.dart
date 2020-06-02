import 'package:chamasoft/screens/chamasoft/models/loan-installment.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class LoanAmortization extends StatefulWidget {
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
    final List<LoanInstallment> installments = [
      LoanInstallment(
          date: DateTime.now(), amount: '30,000', balance: '150,000'),
      LoanInstallment(
          date: DateTime.now(), amount: '30,000', balance: '120,000'),
      LoanInstallment(
          date: DateTime.now(), amount: '30,000', balance: '90,000'),
      LoanInstallment(
          date: DateTime.now(), amount: '30,000', balance: '60,000'),
      LoanInstallment(
          date: DateTime.now(), amount: '30,000', balance: '30,000'),
      LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '0'),
      LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '0'),
      LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '0'),
      LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '0'),
      LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '0'),
      LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '0'),
      LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '0'),
      LoanInstallment(
          date: DateTime.now(), amount: '30,000', balance: '30,000'),
    ];
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
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            color: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Color(0xffededfe),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: heading2(
                          text: "Emergency Loan for Corona Virus",
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.start),
                    ),
                    heading2(
                        text: "Ksh 180,000",
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
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        customTitle(
                          textAlign: TextAlign.start,
                          text: "12%",
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
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        customTitle(
                          textAlign: TextAlign.start,
                          text: "1 Month",
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
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        customTitle(
                          textAlign: TextAlign.start,
                          text: "May 12, 2020",
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
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                LoanInstallment installment = installments[index];
                return AmortizationBody(installment: installment);
              },
              itemCount: installments.length,
            ),
          )
        ],
      ),
    );
  }
}
