// import 'dart:math';

import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/dataTable.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ChamasoftLoanAmortization extends StatefulWidget {
  final String loanTypeId;
  final double loanAmount;
  final String repaymentPeriod;

  ChamasoftLoanAmortization(
      {this.loanTypeId, this.loanAmount, this.repaymentPeriod});

  @override
  _ChamasoftLoanAmortizationState createState() =>
      _ChamasoftLoanAmortizationState();
}

class _ChamasoftLoanAmortizationState extends State<ChamasoftLoanAmortization> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isInit = true;
  bool _isLoading = true;
  Map<String, dynamic> _loanCalculator;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  void didChangeDependencies() {
    // get the loan products
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  Future<void> _fetchLoanCalculator(BuildContext context) async {
    try {
      // get the loan calculator
      await Provider.of<ChamasoftLoans>(context, listen: false)
          .fetchLoanCalculator({
        "loan_type_id": widget.loanTypeId,
        "loan_amount": widget.loanAmount,
        "repayment_period": widget.repaymentPeriod
      }).then((value) {
        setState(() {
          _isInit = false;
          _isLoading = false;
          _loanCalculator = value;
        });
      });
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchLoanCalculator(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    // get the loan calculator.
    return _fetchLoanCalculator(context).then((value) => true);
  }

  @override
  Widget build(BuildContext context) {
    print("loanCalculator $_loanCalculator");

    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    LoanProduct _loanProduct = arguments['loanProduct'];
    Group groupObject = Provider.of<Groups>(context).getCurrentGroup();
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var dateTime = DateTime.parse(date.toIso8601String());
    var formate2 = "${dateTime.year}-${dateTime.month}-${dateTime.day}";

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
          _isLoading
              ? showLinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
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
                            "${groupObject.groupCurrency}${currencyFormat.format(_loanCalculator['amortizationTotals']['totalPayable'])}",
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
                          text: "${widget.repaymentPeriod} Month(s)",
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
            // width: double.infinity, _loanCalculator['breakdown']

            child: CustomDataTable(rowItems: generateTableRows()),
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

  List<DataRow> generateTableRows() {
    List<DataRow> rows = <DataRow>[];

    _loanCalculator['breakdown']
        .map((breakdown) => rows.add(DataRow(
              cells: <DataCell>[
                DataCell(Text(breakdown['dueDate'])),
                DataCell(Text(breakdown['amountPayable'].toString())),
                DataCell(Text(breakdown['principlePayable'].toString())),
                DataCell(Text(breakdown['interestPayable'].toString())),
                DataCell(Text(breakdown['balance'].toString()))
              ],
            )))
        .toList();

    return rows;
  }
}
