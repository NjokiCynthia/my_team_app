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
import 'package:chamasoft/widgets/empty_screens.dart';
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
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    LoanProduct _loanProduct = arguments['loanProduct'];
    final generalAmount = arguments['generalAmount'];
    Group groupObject = Provider.of<Groups>(context).getCurrentGroup();
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    DateTime dateTime = DateTime.parse(date.toIso8601String());
    String formate2 = "${dateTime.year}-${dateTime.month}-${dateTime.day}";

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
          _isLoading ? showLinearProgressIndicator() : SizedBox(height: 0.0),
          if (!_isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      subtitle1(
                          text: _loanProduct.name /*widget.typeLoan.loanName*/,
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.start),
                      Spacer(),
                      subtitle2(
                          text:
                              "${groupObject.groupCurrency} ${currencyFormat.format(_loanCalculator['amortizationTotals']['totalPayable'])}",
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
                          subtitle2(
                            textAlign: TextAlign.start,
                            text: _loanProduct.description,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
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
                          subtitle2(
                            textAlign: TextAlign.start,
                            text: "${widget.repaymentPeriod} Month(s)",
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
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
                          subtitle2(
                            textAlign: TextAlign.start,
                            text: formate2,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
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
          if (!_isLoading)
            Column(
              children: [
                Container(
                  // width: double.infinity, _loanCalculator['breakdown']

                  child: CustomDataTable(
                    rowItems: generateTableRows(),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => (themeChangeProvider.darkTheme)
                                  ? Colors.blueGrey[800]
                                  : Color(0xffededfe),
                            ),
                            columnSpacing: 20.0,
                            columns: [
                              DataColumn(label: subtitle2(text: 'Total')),
                              DataColumn(
                                  label: subtitle2(
                                      text:
                                          "${groupObject.groupCurrency} ${currencyFormat.format(_loanCalculator['amortizationTotals']['totalPayable'])}")),
                              DataColumn(
                                  label: subtitle2(
                                      text:
                                          "${groupObject.groupCurrency} ${currencyFormat.format(_loanCalculator['amortizationTotals']['totalInterest'])}")),
                              DataColumn(
                                  label: subtitle2(
                                      text:
                                          "${groupObject.groupCurrency} ${currencyFormat.format(generalAmount)}")),
                              DataColumn(label: subtitle2(text: '0'))
                            ],
                            rows: <DataRow>[]),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
