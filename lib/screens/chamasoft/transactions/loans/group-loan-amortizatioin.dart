// ignore_for_file: unused_local_variable

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/dataTable.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class GroupLoanAmortization extends StatefulWidget {
  final int loanTypeId;
  final int loanAmount;
  final int repayementPeriod;
  final int groupLoanType;
  final int loanInterestRate;
  final int groupLoanName;

  GroupLoanAmortization(
      {this.loanTypeId,
      this.loanAmount,
      this.repayementPeriod,
      this.groupLoanType,
      this.loanInterestRate,
      this.groupLoanName});

  @override
  _GroupLoanAmortizationState createState() => _GroupLoanAmortizationState();
}

class _GroupLoanAmortizationState extends State<GroupLoanAmortization> {
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

  Future<void> _fetchGroupLoanCalculator(BuildContext context) async {
    try {
      // get the loan calculator
      Provider.of<Groups>(context, listen: false).fetchGroupLoanCalculator({
        "loan_type_id": widget.loanTypeId,
        "loan_amount": widget.loanAmount,
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
            _fetchGroupLoanCalculator(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    // get the loan calculator.
    return _fetchGroupLoanCalculator(context).then((value) => true);
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    LoanType _loanType = arguments['loanType'];
    final generalAmount = arguments['groupLoanAmount'];
    Group groupObject = Provider.of<Groups>(context).getCurrentGroup();
    DateTime now = new DateTime.now();

    DateTime date = new DateTime(now.year, now.month, now.day);
    DateTime dateTime = DateTime.parse(date.toIso8601String());
    String formate2 = "${dateTime.day}/${dateTime.month}/${dateTime.year}";

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
                          text: widget.groupLoanName.toString(),
                          /*widget.typeLoan.loanName*/
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.start),
                      Spacer(),
                      subtitle2(
                          text:
                              "${groupObject.groupCurrency} ${currencyFormat.format(_loanCalculator['amortizationTotals']['totalPayable'])}",

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
                            text: widget.loanInterestRate.toString() + " %",
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
                            text: "${widget.repayementPeriod}  Month(s)",
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
            SingleChildScrollView(
              //scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Container(
                    // width: double.infinity, _loanCalculator['breakdown']

                    child: CustomDataTable(
                      rowItems: generateTableRows(),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => (themeChangeProvider.darkTheme)
                                  ? Colors.blueGrey[800]
                                  : Color(0xffededfe),
                            ),
                            columnSpacing: 45.0,
                            columns: [
                              DataColumn(label: subtitle2(text: 'Total:')),
                              DataColumn(
                                  label: subtitle2(
                                      text:
                                          "${currencyFormat.format(_loanCalculator['amortizationTotals']['totalPayable'])}")),
                              DataColumn(
                                  label: subtitle2(
                                      text:
                                          "${currencyFormat.format(_loanCalculator['amortizationTotals']['totalPrinciple'])}")), //totalPrinciple
                              DataColumn(
                                  label: subtitle2(
                                      text:
                                          "${currencyFormat.format(_loanCalculator['amortizationTotals']['totalInterest'])}")), //totalInterest
                              DataColumn(label: subtitle2(text: '0      '))
                            ],
                            rows: <DataRow>[]),
                      ],
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<DataRow> generateTableRows() {
    List<DataRow> rows = <DataRow>[];
//${currencyFormat.format(
    _loanCalculator['breakdown']
        .map((breakdown) => rows.add(DataRow(
              cells: <DataCell>[
                DataCell(subtitle2(
                  text: breakdown['dueDate'],
                )),
                DataCell(subtitle2(
                    text: currencyFormat.format(breakdown['amountPayable']),
                    textAlign: TextAlign.center)),
                DataCell(subtitle2(
                    text: currencyFormat.format(breakdown['principlePayable']),
                    textAlign: TextAlign.center)),
                DataCell(subtitle2(
                    text: currencyFormat.format(breakdown['interestPayable']),
                    textAlign: TextAlign.center)),
                DataCell(subtitle2(
                    text: currencyFormat.format(breakdown['balance']),
                    textAlign: TextAlign.center)),
              ],
            )))
        .toList();

    return rows;
  }
}
