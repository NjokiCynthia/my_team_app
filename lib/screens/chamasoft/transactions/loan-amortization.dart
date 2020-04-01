import 'package:chamasoft/screens/chamasoft/models/loan-installment.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'apply-loan.dart';

class LoanAmortization extends StatefulWidget {
  @override
  _LoanAmortizationState createState() => _LoanAmortizationState();
}

class _LoanAmortizationState extends State<LoanAmortization> {
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

  final List<LoanInstallment> installments = [
    LoanInstallment(
        date: DateTime.now(), amount: '30,000', balance: '150,000'),
    LoanInstallment(
        date: DateTime.now(), amount: '30,000', balance: '120,000'),
    LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '90,000'),
    LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '60,000'),
    LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '30,000'),
    LoanInstallment(date: DateTime.now(), amount: '30,000', balance: '0'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ApplyLoan(),
          ),
        ),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Loan Terms & Amortization",
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                color: (themeChangeProvider.darkTheme)
                    ? Colors.blueGrey[800]
                    : Color(0xffededfe),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading2(
                              text: "Emergency Loan for Corona Virus",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                          SizedBox(
                            height: 10,
                          ),
                          subtitle2(
                              text: "Interest Rate: 12%",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                          subtitle2(
                              text: "Repayment Period: 2 Months",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                          subtitle2(
                              text: "Application Date: May 12, 2020",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start),
                        ],
                      ),
                    ),
                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        heading2(
                            text: "Ksh 180,000",
                            color: Theme.of(context).textSelectionHandleColor,
                            align: TextAlign.start)
                      ],
                    )
                  ],
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Theme.of(context).backgroundColor,
                  child: Container(
                    height: 300,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        LoanInstallment installment = installments[index];
                        return AmortizationBody(installment: installment);
                      },
                      itemCount: installments.length,
                    ),
                  ))
            ],
          )),
    );
  }
}
