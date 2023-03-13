// ignore_for_file: missing_return

import 'dart:io';
import 'dart:typed_data';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-summary-row.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';
import 'package:chamasoft/screens/chamasoft/models/transaction-statement-model.dart';
import 'package:flutter/services.dart';
//import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';

class PdfApi {
  static Future<File> generateMemberLoanStatementPdf(
    ActiveLoan loan,
  ) async {}
  static Future<File> generateGroupTransactionStatementPdf(
      String statementFrom,
      List<TransactionStatementRow> transactions,
      String statementTo,
      String statementAsAt,
      String title,
      Group groupObject,
      double totalBalance) async {
    final pdf = Document();
    final header = [
      'Date',
      'Description',
      'Deposit(${groupObject.groupCurrency})',
      'Withdrwal(${groupObject.groupCurrency})',
      'Balance(${groupObject.groupCurrency})'
    ];

    final data = transactions
        .map((item) => [
              item.date,
              item.description,
              item.deposit,
              item.withdrawal,
              item.balance
            ])
        .toList();

    final imageSvg =
        (await rootBundle.load('assets/logofull.png')).buffer.asUint8List();

    final pageTheme = PageTheme(
        pageFormat: PdfPageFormat.a3,
        orientation: PageOrientation.landscape,
        buildBackground: (context) {
          if (context.pageNumber == 1) {
            return FullPage(ignoreMargins: true);
          } else {
            return Container();
          }
        });

    pdf.addPage(MultiPage(
        pageTheme: pageTheme,
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (context) => [
              Container(
                child: Center(
                  child: builderHearder(imageSvg),
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Center(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: PdfColors.cyanAccent700)),
                ),
              ),
              Divider(),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group: ${groupObject.groupName}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      Text(
                          "Total Balance: ${groupObject.groupCurrency} $totalBalance",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                    ]),
              ),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              transactionalStatementInfo(
                  statementFrom, statementAsAt, statementTo),
              SizedBox(height: 0.5 * PdfPageFormat.mm),
              Divider(),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Table.fromTextArray(
                  headers: header,
                  data: data,
                  border: null,
                  headerStyle: TextStyle(fontWeight: FontWeight.bold),
                  headerDecoration: BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 30,
                  cellAlignments: {
                    0: Alignment.centerLeft,
                    1: Alignment.centerLeft,
                    2: Alignment.centerRight,
                    3: Alignment.centerRight,
                    4: Alignment.centerRight
                  }),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Divider(),
              signOff(imageSvg)
            ]));
    return saveDocument(
        name: '${groupObject.groupName}-Transaction Statement.pdf', pdf: pdf);
  }

  static Future<File> generateExpensesPdf(
      List<SummaryRow> expenseRows, String title, Group groupObject,
      [double totalExpenses]) async {
    final pdf = Document();
    final header = [
      'Expense title',
      'Paid(${groupObject.groupCurrency})',
    ];

    final data = expenseRows.map((item) => [item.name, item.paid]).toList();

    final imageSvg =
        (await rootBundle.load('assets/logofull.png')).buffer.asUint8List();

    final pageTheme = PageTheme(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        buildBackground: (context) {
          if (context.pageNumber == 1) {
            return FullPage(ignoreMargins: true);
          } else {
            return Container();
          }
        });

    pdf.addPage(MultiPage(
        pageTheme: pageTheme,
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (context) => [
              Container(
                child: Center(
                  child: builderHearder(imageSvg),
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Center(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: PdfColors.cyanAccent700)),
                ),
              ),
              Divider(),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group: ${groupObject.groupName}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      SizedBox(height: 1 * PdfPageFormat.mm),
                      Text(
                          "Total Expenses: ${groupObject.groupCurrency} $totalExpenses",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      SizedBox(height: 1 * PdfPageFormat.mm),
                      Text(
                          ((expenseRows.length) > 1)
                              ? "${expenseRows.length} Expenses"
                              : ("1 Expense"),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                    ]),
              ),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              SizedBox(height: 0.5 * PdfPageFormat.mm),
              Divider(),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Table.fromTextArray(
                  headers: header,
                  data: data,
                  border: null,
                  headerStyle: TextStyle(fontWeight: FontWeight.bold),
                  headerDecoration: BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 30,
                  cellAlignments: {
                    0: Alignment.centerLeft,
                    1: Alignment.centerRight,
                    2: Alignment.centerRight,
                    3: Alignment.centerRight,
                    4: Alignment.centerRight,
                    5: Alignment.centerRight
                  }),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Divider(),
              signOff(imageSvg)
            ]));
    return saveDocument(
        name: '${groupObject.groupName}-Expense Summary.pdf', pdf: pdf);
  }

  /* Group Loan Summary */

  static Future<File> generateLoanSummaryPdf(
    String title,
    Group groupObject,
    double totalLoanedOut,
    double payable,
    double paid,
    double balance,
    List<LoanSummaryRow> loanSummaryRows,
  ) async {
    final pdf = Document();
    final header = [
      'Name',
      'Due(${groupObject.groupCurrency})',
      'Paid(${groupObject.groupCurrency})',
      'Balance(${groupObject.groupCurrency})'
    ];

    final data = loanSummaryRows
        .map((item) => [
              item.name,
              currencyFormat.format(item.amountDue),
              currencyFormat.format(item.paid),
              currencyFormat.format(item.balance)
            ])
        .toList();

    final imageSvg =
        (await rootBundle.load('assets/logofull.png')).buffer.asUint8List();

    final pageTheme = PageTheme(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        buildBackground: (context) {
          if (context.pageNumber == 1) {
            return FullPage(ignoreMargins: true);
          } else {
            return Container();
          }
        });

    pdf.addPage(MultiPage(
        pageTheme: pageTheme,
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (context) => [
              Container(
                child: Center(
                  child: builderHearder(imageSvg),
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Center(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: PdfColors.cyanAccent700)),
                ),
              ),
              Divider(),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group: ${groupObject.groupName}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      SizedBox(height: 1 * PdfPageFormat.mm),
                      Text(
                          "Total Loaned Out: ${groupObject.groupCurrency} $totalLoanedOut",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      SizedBox(height: 1 * PdfPageFormat.mm),
                      Text("Payable: ${groupObject.groupCurrency} $payable",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      SizedBox(height: 1 * PdfPageFormat.mm),
                      Text("Balance: ${groupObject.groupCurrency} $balance",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ))
                    ]),
              ),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              Divider(),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Table.fromTextArray(
                  headers: header,
                  data: data,
                  border: null,
                  headerStyle: TextStyle(fontWeight: FontWeight.bold),
                  headerDecoration: BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 30,
                  cellAlignments: {
                    0: Alignment.centerLeft,
                    1: Alignment.centerRight,
                    2: Alignment.centerRight,
                    3: Alignment.centerRight,
                    4: Alignment.centerRight,
                    5: Alignment.centerRight
                  }),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              Divider(),
              signOff(imageSvg)
            ]));
    return saveDocument(
        name: '${groupObject.groupName}-Loan Summary.pdf', pdf: pdf);
  }

/* Group Contribution Summary */
  static Future<File> generateContributionSammary(double _totalAmount,
      String title2, int _statementType, String title, Group groupObject,
      [List<GroupContributionSummary> contributionSummary]) async {
    final pdf = Document();

    final header = [
      'Name',
      'Paid(${groupObject.groupCurrency})',
      'Balance(${groupObject.groupCurrency})',
    ];

    final data = contributionSummary
        .map((item) => [
              item.memberName,
              currencyFormat.format(item.paidAmount),
              currencyFormat.format(item.balanceAmount.abs())
            ])
        .toList();

    final imageSvg =
        (await rootBundle.load('assets/logofull.png')).buffer.asUint8List();

    final pageTheme = PageTheme(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        buildBackground: (context) {
          if (context.pageNumber == 1) {
            return FullPage(ignoreMargins: true);
          } else {
            return Container();
          }
        });

    pdf.addPage(MultiPage(
        pageTheme: pageTheme,
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (context) => [
              Container(
                child: Center(
                  child: builderHearder(imageSvg),
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Center(
                  child: Text(_statementType == 1 ? title : title2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: PdfColors.cyanAccent700)),
                ),
              ),
              Divider(),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group Name: ${groupObject.groupName}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      Text("Group Size: ${groupObject.groupSize} Members ",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      Text(
                          "Total Fine : ${groupObject.groupCurrency} ${currencyFormat.format(_totalAmount)} ",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                    ]),
              ),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              SizedBox(height: 0.5 * PdfPageFormat.mm),
              Divider(),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              Table.fromTextArray(
                  headers: header,
                  data: data,
                  border: null,
                  headerStyle: TextStyle(fontWeight: FontWeight.bold),
                  headerDecoration: BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 30,
                  cellAlignments: {
                    0: Alignment.centerLeft,
                    1: Alignment.centerRight,
                    2: Alignment.centerRight,
                    3: Alignment.centerRight,
                    4: Alignment.centerRight
                  }),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Divider(),
              signOff(imageSvg)
            ]));
    return saveDocument(name: '${groupObject.groupName}.pdf', pdf: pdf);
  }

  /* Member Fine Statement */
  static Future<File> generateFineStatementPdf(
      List<ContributionStatementRow> _statements,
      ContributionStatementModel _contributionStatementModel,
      Group groupObject,
      String title) async {
    final pdf = Document();
    final header = [
      'Date',
      'Description',
      'Paid(${groupObject.groupCurrency})',
      'Balance(${groupObject.groupCurrency})'
    ];
    final header1 = [
      'Total',
      '                                    ',
      '${currencyFormat.format(_contributionStatementModel.totalPaid)}',
      '${currencyFormat.format(_contributionStatementModel.totalBalance)}'
    ];

    _statements = _contributionStatementModel.statements;
    final _memberName = _contributionStatementModel.memberName;
    final _memberPhone = _contributionStatementModel.phone;
    final _memberRole = _contributionStatementModel.role;
    // ignore: unused_local_variable
    final _totalPaid = _contributionStatementModel.totalPaid;
    final statementAsAt = _contributionStatementModel.statementAsAt;
    final _statementFrom = _contributionStatementModel.statementFrom;
    final _statementTo = _contributionStatementModel.statementTo;
    final data = _statements
        .map((item) => [
              item.date,
              item.title,
              currencyFormat.format(item.amount),
              currencyFormat.format(item.balance.abs()),
            ])
        .toList();

    final imageSvg =
        (await rootBundle.load('assets/logofull.png')).buffer.asUint8List();

    final pageTheme = PageTheme(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.landscape,
        buildBackground: (context) {
          if (context.pageNumber == 1) {
            return FullPage(ignoreMargins: true);
          } else {
            return Container();
          }
        });

    pdf.addPage(MultiPage(
        pageTheme: pageTheme,
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (context) => [
              Container(
                child: Center(
                  child: builderHearder(imageSvg),
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Center(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: PdfColors.cyanAccent700)),
                ),
              ),
              Divider(),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group: ${groupObject.groupName}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      Text("Member: $_memberName",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      Text("Member Phone: $_memberPhone",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      Text("Member Role: $_memberRole",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ))
                    ]),
              ),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              fineStatementInfo(_statementFrom, statementAsAt, _statementTo),
              SizedBox(height: 0.5 * PdfPageFormat.mm),
              Divider(),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Table.fromTextArray(
                  headers: header,
                  data: data,
                  border: null,
                  headerStyle: TextStyle(fontWeight: FontWeight.bold),
                  headerDecoration: BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 30,
                  cellAlignments: {
                    0: Alignment.centerLeft,
                    1: Alignment.centerRight,
                    2: Alignment.centerRight,
                    3: Alignment.centerRight,
                    4: Alignment.centerRight,
                    5: Alignment.centerRight
                  }),
              Table.fromTextArray(
                  headers: header1,
                  data: [],
                  border: null,
                  headerStyle: TextStyle(fontWeight: FontWeight.bold),
                  headerDecoration: BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 30,
                  cellAlignments: {
                    0: Alignment.centerLeft,
                    1: Alignment.centerRight,
                    2: Alignment.centerRight,
                    3: Alignment.centerRight,
                    4: Alignment.centerRight,
                    5: Alignment.centerRight
                  }),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Divider(),
              signOff(imageSvg)
            ]));
    return saveDocument(
        name: '$_memberName-${groupObject.groupName} Fine.pdf', pdf: pdf);
  }

  static Future<File> generateAccountBalancePdf(String title) async {
    // ignore: unused_local_variable
    final pdf = Document();
  }

  /* Member Contribution Statement */

  static Future<File> generateContributionStatementPdf(
      List<ContributionStatementRow> _statements,
      ContributionStatementModel _contributionStatementModel,
      Group groupObject,
      String title) async {
    final pdf = Document();
    final header = [
      'Date',
      'Description',
      'Amount(${groupObject.groupCurrency})',
      'Clossing(${groupObject.groupCurrency})'
    ];

    _statements = _contributionStatementModel.statements;
    final _memberName = _contributionStatementModel.memberName;
    final _memberPhone = _contributionStatementModel.phone;
    final _memberRole = _contributionStatementModel.role;
    final _totalPaid = _contributionStatementModel.totalPaid;
    final statementAsAt = _contributionStatementModel.statementAsAt;
    final _statementFrom = _contributionStatementModel.statementFrom;
    final _statementTo = _contributionStatementModel.statementTo;
    final data = _statements
        .map((item) => [
              item.date,
              item.title,
              currencyFormat.format(item.amount),
              currencyFormat.format(item.balance.abs()),
            ])
        .toList();

    final imageSvg =
        (await rootBundle.load('assets/logofull.png')).buffer.asUint8List();

    final pageTheme = PageTheme(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        buildBackground: (context) {
          if (context.pageNumber == 1) {
            return FullPage(ignoreMargins: true);
          } else {
            return Container();
          }
        });

    pdf.addPage(MultiPage(
        pageTheme: pageTheme,
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (context) => [
              Container(
                child: Center(
                  child: builderHearder(imageSvg),
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Center(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: PdfColors.cyanAccent700)),
                ),
              ),
              Divider(),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group: ${groupObject.groupName}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      Text("Member: $_memberName",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      Text("Member Phone: $_memberPhone",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      Text("Member Role: $_memberRole",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ))
                    ]),
              ),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              statementInfo(_statementFrom, statementAsAt, _statementTo),
              SizedBox(height: 0.5 * PdfPageFormat.mm),
              Divider(),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Total Member Investment: ${groupObject.groupCurrency} $_totalPaid",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                    ]),
              ),
              SizedBox(height: 0.5 * PdfPageFormat.mm),
              Divider(),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Table.fromTextArray(
                  headers: header,
                  data: data,
                  border: null,
                  headerStyle: TextStyle(fontWeight: FontWeight.bold),
                  headerDecoration: BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 30,
                  cellAlignments: {
                    0: Alignment.centerLeft,
                    1: Alignment.centerRight,
                    2: Alignment.centerRight,
                    3: Alignment.centerRight,
                    4: Alignment.centerRight
                  }),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Divider(),
              signOff(imageSvg)
            ]));
    return saveDocument(
        name: '$_memberName-${groupObject.groupName}-Contribution.pdf',
        pdf: pdf);
  }

  /* Member Deposit Reciept */
  static Future<File> generateDepositPdf({
    String title,
    String memberName,
    String groupName,
    String groupCurrency,
    String depositAmount,
    String depositDate,
    String depositStatus,
    String depositAbout,
  }) async {
    final pdf = Document();

    final imageSvg =
        (await rootBundle.load('assets/logofull.png')).buffer.asUint8List();

    final pageTheme = PageTheme(
        pageFormat: PdfPageFormat.a4,
        buildBackground: (context) {
          if (context.pageNumber == 1) {
            return FullPage(ignoreMargins: true);
          } else {
            return Container();
          }
        });
    pdf.addPage(MultiPage(
        pageTheme: pageTheme,
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (context) => [
              Container(
                child: Center(
                  child: builderHearder(imageSvg),
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Center(
                  child: depositTitle(title),
                ),
              ),
              Divider(),
              depositBody(memberName, groupName, groupCurrency, depositDate,
                  depositStatus, depositAbout, depositAmount),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Text(depositAbout,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  )),
              SizedBox(height: 1 * PdfPageFormat.mm),
              Divider(),
              SizedBox(height: 2 * PdfPageFormat.mm),
              signOff(imageSvg)
            ]));
    return saveDocument(
        name: '$memberName-$groupName-Deposit Reciept.pdf', pdf: pdf);
  }

  static Future<File> generateRecentTranasactionalPdf({
    String title,
    String memberName,
    String groupName,
    String groupCurrency,
    double paidAmount,
    String dateofTranasaction,
  }) async {
    final pdf = Document();

    final imageSvg =
        (await rootBundle.load('assets/logofull.png')).buffer.asUint8List();

    final pageTheme = PageTheme(
        pageFormat: PdfPageFormat.a4,
        buildBackground: (context) {
          if (context.pageNumber == 1) {
            return FullPage(ignoreMargins: true);
          } else {
            return Container();
          }
        });
    pdf.addPage(MultiPage(
        pageTheme: pageTheme,
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (context) => [
              Container(
                child: Center(
                  child: builderHearder(imageSvg),
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Center(
                  child: buildTitle(title),
                ),
              ),
              Divider(),
              buildInvoice(memberName, groupName, groupCurrency, paidAmount,
                  dateofTranasaction),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Divider(),
              SizedBox(height: 2 * PdfPageFormat.mm),
              signOff(imageSvg)
            ]));
    return saveDocument(
        name: '$memberName-$groupName Recent Transaction Reciept .pdf',
        pdf: pdf);
  }

  static Future<File> generateTranasactionalPdf({
    String title,
    String memberName,
    String groupName,
    String groupCurrency,
    double paidAmount,
    double dueAmount,
    String dateofTranasaction,
  }) async {
    final pdf = Document();

    final imageSvg =
        (await rootBundle.load('assets/logofull.png')).buffer.asUint8List();

    final pageTheme = PageTheme(
        pageFormat: PdfPageFormat.a4,
        buildBackground: (context) {
          if (context.pageNumber == 1) {
            return FullPage(ignoreMargins: true);
          } else {
            return Container();
          }
        });
    pdf.addPage(MultiPage(
        pageTheme: pageTheme,
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (context) => [
              Container(
                child: Center(
                  child: builderHearder(imageSvg),
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Center(
                  child: buildTitle(title),
                ),
              ),
              Divider(),
              buildInvoice(memberName, groupName, groupCurrency, paidAmount,
                  dateofTranasaction),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Divider(),
              SizedBox(height: 2 * PdfPageFormat.mm),
              signOff(imageSvg)
            ]));
    return saveDocument(
        name: '$memberName-$groupName Transaction Reciept .pdf', pdf: pdf);
  }

  static builderHearder(Uint8List imageSvg) => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Image(MemoryImage(imageSvg))]);

  static buildTitle(String title) => Column(children: [
        Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: PdfColors.cyanAccent700))
      ]);

  static buildInvoice(String memberName, String groupName, String groupCurrency,
          double paidAmount, String dateofTranasaction) =>
      Column(children: [
        SizedBox(height: 3 * PdfPageFormat.cm),
        Row(children: [
          Container(
            decoration: BoxDecoration(
              color: PdfColors.cyanAccent700,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            width: 150,
            height: 150,
            child: Center(
              child: Text("$groupCurrency ${currencyFormat.format(paidAmount)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.white)),
            ),
          ),
          SizedBox(width: 2 * PdfPageFormat.cm),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $memberName',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    )),
                SizedBox(height: 1 * PdfPageFormat.cm),
                Text('Transaction Date: $dateofTranasaction',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    )),
                SizedBox(height: 1 * PdfPageFormat.cm),
                Text('To: $groupName',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.normal,
                    )),
                SizedBox(height: 1 * PdfPageFormat.cm),
                Text('',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ])
        ])
      ]);

  // static buildTotal(/* Uint8List imagefb, Uint8List imagetwt */) =>
  //     Row(children: [
  //       Container(width: 70),
  //       Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Text('Ralph Bunche Road, Elgon Court Block D1, Upperhill,',
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.normal,
  //                 )),
  //             Text('P.O. BOX 104230 - 00101, Nairobi, Kenya',
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.normal,
  //                 )),
  //             Text('+254 733 366 240',
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 )),
  //             Text('info@chamasoft.com',
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 )),
  //           ]),
  //       // Container(
  //       //     child: Center(
  //       //         child: Row(children: [
  //       //   Column(children: [
  //       //     Image(MemoryImage(imagefb)),
  //       //     Text('@ChamaSoft',
  //       //         textAlign: TextAlign.center,
  //       //         style: TextStyle(
  //       //           fontSize: 18,
  //       //           fontWeight: FontWeight.normal,
  //       //         )),
  //       //   ]),
  //       //   Column(children: [
  //       //     Image(MemoryImage(imagetwt)),
  //       //     Text('@ChamaSoft',
  //       //         textAlign: TextAlign.center,
  //       //         style: TextStyle(
  //       //           fontSize: 18,
  //       //           fontWeight: FontWeight.normal,
  //       //         )),
  //       //   ])
  //       // ])))
  //     ]);

  static Future<File> saveDocument({String name, Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    // await PDFDocument.fromFile(file);
    await OpenFile.open(url);
  }

  static depositTitle(String title) => Column(children: [
        Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: PdfColors.cyanAccent700))
      ]);

  static depositBody(
          String memberName,
          String groupName,
          String groupCurrency,
          String depositDate,
          String depositStatus,
          String depositAbout,
          String depositAmount) =>
      Column(children: [
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(children: [
          Container(
            decoration: BoxDecoration(
              color: PdfColors.cyanAccent700,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            width: 150,
            height: 150,
            child: Center(
              child: Text("$groupCurrency $depositAmount",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.white)),
            ),
          ),
          SizedBox(width: 2 * PdfPageFormat.cm),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $memberName',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    )),
                SizedBox(height: 0.5 * PdfPageFormat.cm),
                Text('Transaction Date: $depositDate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    )),
                SizedBox(height: 0.5 * PdfPageFormat.cm),
                Text('To: $groupName',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.normal,
                    )),
                SizedBox(height: 0.5 * PdfPageFormat.cm),
                Text('Status: $depositStatus',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    )),
              ])
        ])
      ]);

  static contibutionTotal(double totalPaid, Group groupObject) {
    return Container(
        alignment: Alignment.centerRight,
        child: Row(children: [
          Spacer(flex: 8),
          Expanded(
              flex: 2,
              child: Column(children: [
                Text(
                    '${groupObject.groupCurrency} ${currencyFormat.format(totalPaid)} ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400)
              ]))
        ]));
  }

  static statementInfo(
      String statementFrom, String statementAsAt, String statementTo) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Statement as At ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  )),
              Text(statementAsAt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  )),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Statement Period ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    )),
                Text(
                    statementFrom.isNotEmpty
                        ? "$statementFrom to $statementTo"
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  static signOff(Uint8List imageSvg) {
    return Center(
        child: Column(children: [
      Text(
          '© ${DateTime.now().year} . This statement was issued with no alteration',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          )),
      SizedBox(height: 2 * PdfPageFormat.cm),
      Text('Powered by ',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: PdfColors.cyanAccent700)),
      Image(MemoryImage(imageSvg))
    ]));
  }

  static fineStatementInfo(
      String statementFrom, String statementAsAt, String statementTo) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Fine Statement as At ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  )),
              Text(statementAsAt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  )),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Statement Period ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    )),
                Text(
                    statementFrom.isNotEmpty
                        ? "$statementFrom to $statementTo"
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  static transactionalStatementInfo(
      String statementFrom, String statementAsAt, String statementTo) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Transaction Statement as At ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  )),
              Text(statementAsAt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  )),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Statement Period ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    )),
                Text(
                    statementFrom.isNotEmpty
                        ? "$statementFrom to $statementTo"
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
