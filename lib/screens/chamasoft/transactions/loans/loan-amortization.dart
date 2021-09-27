import 'package:chamasoft/screens/chamasoft/models/loan-installment.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-type.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class LoanAmortization extends StatefulWidget {
  final LoanType typeLoan;
  LoanAmortization({this.typeLoan});

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
                          text: 'Education Loan' /*widget.typeLoan.loanName*/,
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.start),
                    ),
                    heading2(
                        text: "Ksh 180,000",
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
                          text: "12%",
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
                          text: "1 Month",
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
                          text: "May 12, 2020",
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
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: double.infinity,
              child: DataTable(
                dataRowHeight: 25.0,
                showBottomBorder: true,
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.cyanAccent),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Date',
                      style: TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Payement',
                      style: TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Principle',
                      style: TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Interest',
                      style: TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Balance',
                      style: TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
                rows: const <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('10/26/2021')),
                      DataCell(Text('100')),
                      DataCell(Text('1000')),
                      DataCell(Text('10')),
                      DataCell(Text('900')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('11/26/2021')),
                      DataCell(Text('100')),
                      DataCell(Text('900')),
                      DataCell(Text('10')),
                      DataCell(Text('800')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('12/26/2021')),
                      DataCell(Text('100')),
                      DataCell(Text('800')),
                      DataCell(Text('10')),
                      DataCell(Text('700')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('01/26/2022')),
                      DataCell(Text('100')),
                      DataCell(Text('700')),
                      DataCell(Text('10')),
                      DataCell(Text('600')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('02/26/2022')),
                      DataCell(Text('100')),
                      DataCell(Text('600')),
                      DataCell(Text('10')),
                      DataCell(Text('500')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('03/26/2022')),
                      DataCell(Text('100')),
                      DataCell(Text('500')),
                      DataCell(Text('10')),
                      DataCell(Text('400')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('04/26/2022')),
                      DataCell(Text('100')),
                      DataCell(Text('400')),
                      DataCell(Text('10')),
                      DataCell(Text('300')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('05/26/2022')),
                      DataCell(Text('100')),
                      DataCell(Text('300')),
                      DataCell(Text('10')),
                      DataCell(Text('200')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('06/26/2022')),
                      DataCell(Text('100')),
                      DataCell(Text('200')),
                      DataCell(Text('10')),
                      DataCell(Text('100')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('07/26/2022')),
                      DataCell(Text('100')),
                      DataCell(Text('100')),
                      DataCell(Text('10')),
                      DataCell(Text('0')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('08/26/2022')),
                      DataCell(Text('0')),
                      DataCell(Text('0')),
                      DataCell(Text('10')),
                      DataCell(Text('0')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('09/26/2022')),
                      DataCell(Text('0')),
                      DataCell(Text('0')),
                      DataCell(Text('10')),
                      DataCell(Text('0')),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
