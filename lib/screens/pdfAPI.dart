import 'dart:io';
import 'dart:typed_data';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class User {
  final String name;
  final int age;
  const User({this.name, this.age});
}

class PdfApi {
  static Future<File> generateContributionStatementPdf(
      List<ContributionStatementRow> _statements,
      ContributionStatementModel _contributionStatementModel,
      Group groupObject) async {
    final pdf = Document();
    final header = [
      'Date',
      'Description',
      'Paid(${groupObject.groupCurrency})'
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
            ])
        .toList();

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
        build: (context) => [
              Container(
                child: Center(
                  child: builderHearder(imageSvg),
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                child: Center(
                  child: Text("Contribution Statement",
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
                    1: Alignment.center,
                    2: Alignment.centerRight
                  }),
              Divider(),
              contibutionTotal(_totalPaid, groupObject),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Divider(),
              signOff(imageSvg)
            ]));
    return saveDocument(name: 'Chammasoft.pdf', pdf: pdf);
  }

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
              //buildTitle(),
              Divider(),
              depositBody(memberName, groupName, groupCurrency, depositDate,
                  depositStatus, depositAbout, depositAmount),

              SizedBox(height: 2 * PdfPageFormat.cm),
              Text(depositAbout,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  )),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Divider(),
              SizedBox(height: 2 * PdfPageFormat.cm),
              buildTotal(/* imagefb, imagetwt */),
            ]));
    return saveDocument(name: 'Chammasoft.pdf', pdf: pdf);
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

    // final imagefb =
    //     (await rootBundle.load('assets/fb.png')).buffer.asUint8List();
    // final imagetwt =
    //     (await rootBundle.load('assets/twt.png')).buffer.asUint8List();

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
              //buildTitle(),
              Divider(),
              buildInvoice(memberName, groupName, groupCurrency, paidAmount,
                  dateofTranasaction),
              SizedBox(height: 3 * PdfPageFormat.cm),

              Divider(),
              SizedBox(height: 2 * PdfPageFormat.cm),
              buildTotal(/* imagefb, imagetwt */),
            ]));
    return saveDocument(name: 'Chammasoft.pdf', pdf: pdf);
  }

  static builderHearder(Uint8List imageSvg) => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Image(MemoryImage(imageSvg))]);

  // static buildTitle(String title) {
  //   heading2(text: title, fontSize: 28);
  // }

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
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 1 * PdfPageFormat.cm),
                Text('Transaction Date: $dateofTranasaction',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 1 * PdfPageFormat.cm),
                Text('To: $groupName',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
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

  static buildTotal(/* Uint8List imagefb, Uint8List imagetwt */) =>
      Row(children: [
        Container(width: 70),
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Ralph Bunche Road, Elgon Court Block D1, Upperhill,',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  )),
              Text('P.O. BOX 104230 - 00101, Nairobi, Kenya',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  )),
              Text('+254 733 366 240',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
              Text('info@chamasoft.com',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
        // Container(
        //     child: Center(
        //         child: Row(children: [
        //   Column(children: [
        //     Image(MemoryImage(imagefb)),
        //     Text('@ChamaSoft',
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: 18,
        //           fontWeight: FontWeight.normal,
        //         )),
        //   ]),
        //   Column(children: [
        //     Image(MemoryImage(imagetwt)),
        //     Text('@ChamaSoft',
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: 18,
        //           fontWeight: FontWeight.normal,
        //         )),
        //   ])
        // ])))
      ]);

  static Future<File> saveDocument({String name, Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    //await PDFDocument.fromFile(file);
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
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 0.5 * PdfPageFormat.cm),
                Text('Transaction Date: $depositDate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 0.5 * PdfPageFormat.cm),
                Text('To: $groupName',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 0.5 * PdfPageFormat.cm),
                Text('Status: $depositStatus',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
      Text('Powered by ',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: PdfColors.cyanAccent700)),
      Image(MemoryImage(imageSvg))
    ]));
  }
}
