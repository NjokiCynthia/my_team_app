import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class GroupLoanAmortization extends StatefulWidget {
  final String loanTypeId;
  final double loanAmount;
  final String repaymentPeriod;
  GroupLoanAmortization(
      {this.loanTypeId, this.loanAmount, this.repaymentPeriod});

  @override
  _GroupLoanAmortizationState createState() => _GroupLoanAmortizationState();
}

class _GroupLoanAmortizationState extends State<GroupLoanAmortization> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isInit = true;
  bool _isLoading = true;
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
      Provider.of<ChamasoftLoans>(context, listen: false).fetchLoanCalculator({
        "loan_type_id": widget.loanTypeId,
        "loan_amount": widget.loanAmount,
        "repayment_period": widget.repaymentPeriod
      }).then((value) {
        setState(() {
          _isInit = false;
          _isLoading = false;
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
        title: "Group Loan Terms & Amortization",
      ),
      backgroundColor: Theme.of(context).backgroundColor,

      body: Column(
        children: [
          _isLoading
              ? showLinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: <Widget>[
          //           Expanded(
          //             child: heading2(
          //                 text: 'Education Loan' /*widget.typeLoan.loanName*/,
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor,
          //                 textAlign: TextAlign.start),
          //           ),
          //           heading2(
          //               text: "Ksh 180,000",
          //               // ignore: deprecated_member_use
          //               color: Theme.of(context).textSelectionHandleColor,
          //               textAlign: TextAlign.start)
          //         ],
          //       ),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: <Widget>[
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: <Widget>[
          //               subtitle1(
          //                 text: "Interest Rate: ",
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor,
          //               ),
          //               customTitle(
          //                 textAlign: TextAlign.start,
          //                 text: "12%",
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ],
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: <Widget>[
          //               subtitle1(
          //                 text: "Repayment Period: ",
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor,
          //               ),
          //               customTitle(
          //                 textAlign: TextAlign.start,
          //                 text: "1 Month",
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ],
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: <Widget>[
          //               subtitle1(
          //                 text: "Application Date: ",
          //                 // ignore: depSSXrecated_member_use
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor,
          //               ),
          //               customTitle(
          //                 textAlign: TextAlign.start,
          //                 text: formate2,
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //       Column(
          //         //crossAxisAlignment: CrossAxisAlignment.,
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: <Widget>[],
          //       )
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Text("Working on it"),
          )
          // Padding(
          //   padding: const EdgeInsets.all(4.0),
          //   child: Container(
          //     width: double.infinity,
          //     child: DataTable(
          //       dataRowHeight: 25.0,
          //       showBottomBorder: true,
          //       headingRowColor: MaterialStateColor.resolveWith(
          //           (states) => Colors.cyanAccent),
          //       columns: const <DataColumn>[
          //         DataColumn(
          //           label: Text(
          //             'Date',
          //             style: TextStyle(fontStyle: FontStyle.italic),
          //             textAlign: TextAlign.start,
          //           ),
          //         ),
          //         DataColumn(
          //           label: Text(
          //             'Payement',
          //             style: TextStyle(fontStyle: FontStyle.italic),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //         DataColumn(
          //           label: Text(
          //             'Principle',
          //             style: TextStyle(fontStyle: FontStyle.italic),
          //             textAlign: TextAlign.end,
          //           ),
          //         ),
          //         DataColumn(
          //           label: Text(
          //             'Interest',
          //             style: TextStyle(fontStyle: FontStyle.italic),
          //             textAlign: TextAlign.end,
          //           ),
          //         ),
          //         DataColumn(
          //           label: Text(
          //             'Balance',
          //             style: TextStyle(fontStyle: FontStyle.italic),
          //             textAlign: TextAlign.end,
          //           ),
          //         ),
          //       ],
          //       rows: <DataRow>[
          //         DataRow(
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text:
          //                     "${dateTime.year}-${dateTime.month + 1}-${dateTime.day}",
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '1000',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '900',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           selected: true,
          //           cells: <DataCell>[
          //             // ignore: deprecated_member_use
          //             DataCell(subtitle1(
          //                 text:
          //                     "${dateTime.year}-${dateTime.month + 2}-${dateTime.day}",
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '900',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '800',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text:
          //                     "${dateTime.year}-${dateTime.month + 3}-${dateTime.day}",
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '800',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '700',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           selected: true,
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text: DateTime(now.year, now.month + 4, now.day)
          //                     .toString(),
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '700',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '600',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text: DateTime(now.year, now.month + 5, now.day)
          //                     .toString(),
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '600',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '500',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           selected: true,
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text: DateTime(now.year, now.month + 6, now.day)
          //                     .toString(),
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '500',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '400',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text: DateTime(now.year, now.month + 7, now.day)
          //                     .toString(),
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '400',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '300',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           selected: true,
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text: DateTime(now.year, now.month + 8, now.day)
          //                     .toString(),
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '300',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '200',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text: DateTime(now.year, now.month + 9, now.day)
          //                     .toString(),
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '200',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           selected: true,
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text: DateTime(now.year, now.month + 10, now.day)
          //                     .toString(),
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '100',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '0',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text: DateTime(now.year, now.month + 11, now.day)
          //                     .toString(),
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '0',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '0',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '0',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //         DataRow(
          //           selected: true,
          //           cells: <DataCell>[
          //             DataCell(subtitle1(
          //                 text: DateTime(now.year, now.month + 12, now.day)
          //                     .toString(),
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '0',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '0',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '10',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //             DataCell(subtitle1(
          //                 text: '0',
          //                 // ignore: deprecated_member_use
          //                 color: Theme.of(context).textSelectionHandleColor)),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
      // body: Column(
      //   children: <Widget>[
      //     Container(
      //       padding: EdgeInsets.all(20.0),
      //       color: (themeChangeProvider.darkTheme)
      //           ? Colors.blueGrey[800]
      //           : Color(0xffededfe),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Row(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: <Widget>[
      //               Expanded(
      //                 child: heading2(
      //                     text: 'Loan Name' /*widget.typeLoan.loanName*/,
      //                     // ignore: deprecated_member_use
      //                     color: Theme.of(context).textSelectionHandleColor,
      //                     textAlign: TextAlign.start),
      //               ),
      //               heading2(
      //                   text: "Ksh 180,000",
      //                   // ignore: deprecated_member_use
      //                   color: Theme.of(context).textSelectionHandleColor,
      //                   textAlign: TextAlign.start)
      //             ],
      //           ),
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: <Widget>[
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 children: <Widget>[
      //                   subtitle1(
      //                     text: "Interest Rate: ",
      //                     // ignore: deprecated_member_use
      //                     color: Theme.of(context).textSelectionHandleColor,
      //                   ),
      //                   customTitle(
      //                     textAlign: TextAlign.start,
      //                     text: "12%",
      //                     // ignore: deprecated_member_use
      //                     color: Theme.of(context).textSelectionHandleColor,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                 ],
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 children: <Widget>[
      //                   subtitle1(
      //                     text: "Repayment Period: ",
      //                     // ignore: deprecated_member_use
      //                     color: Theme.of(context).textSelectionHandleColor,
      //                   ),
      //                   customTitle(
      //                     textAlign: TextAlign.start,
      //                     text: "1 Month",
      //                     // ignore: deprecated_member_use
      //                     color: Theme.of(context).textSelectionHandleColor,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                 ],
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 children: <Widget>[
      //                   subtitle1(
      //                     text: "Application Date: ",
      //                     // ignore: deprecated_member_use
      //                     color: Theme.of(context).textSelectionHandleColor,
      //                   ),
      //                   customTitle(
      //                     textAlign: TextAlign.start,
      //                     text: "May 12, 2020",
      //                     // ignore: deprecated_member_use
      //                     color: Theme.of(context).textSelectionHandleColor,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //           Column(
      //             //crossAxisAlignment: CrossAxisAlignment.,
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: <Widget>[],
      //           )
      //         ],
      //       ),
      //     ),
      //     Expanded(
      //       child: ListView.builder(
      //         controller: _scrollController,
      //         shrinkWrap: true,
      //         itemBuilder: (context, index) {
      //           LoanInstallment installment = installments[index];
      //           return AmortizationBody(installment: installment);
      //         },
      //         itemCount: installments.length,
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
