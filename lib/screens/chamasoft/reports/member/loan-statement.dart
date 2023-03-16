import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-statement-row.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
// ignore: unused_import
import 'package:chamasoft/screens/pdfAPI.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class LoanStatement extends StatefulWidget {
  final ActiveLoan loan;

  LoanStatement({this.loan});

  @override
  _LoanStatementState createState() => _LoanStatementState();
}

class _LoanStatementState extends State<LoanStatement> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _appBarElevation = 0;
  ScrollController _scrollController;
  // ignore: unused_field
  bool _isInit = true;
  Future<void> _future;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _getLoanStatements(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchLoanStatement(widget.loan.id);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getLoanStatements(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }

    _isInit = false;
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _future = _getLoanStatements(context);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  // ignore: unused_element
  Future _downloadMemberLoanStatement(
      BuildContext context, Group groupObject) async {
//           LoanStatementModel statementModel =
//                               data.getLoanStatements;
//  List<LoanStatementRow> statementRows =
//                                 data.getLoanStatements.statementRows;
//     final title = "Transaction Statement";
//     final pdfFile = await PdfApi.generateMemberLoanStatementPdf(
//         widget.loan,
//         statementRows,
//         title,
//         groupObject,);
//     PdfApi.openFile(pdfFile);
  }
  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.times,
          title: "Loan Statement",
          // trailingIcon: LineAwesomeIcons.download,
          // trailingAction: () =>
          // _downloadMemberLoanStatement(context, groupObject),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Builder(
          builder: (BuildContext context) {
            return FutureBuilder(
                future: _future,
                builder: (_, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        backgroundColor: (themeChangeProvider.darkTheme)
                            ? Colors.blueGrey[800]
                            : Colors.white,
                        onRefresh: () => _getLoanStatements(context),
                        child:
                            Consumer<Groups>(builder: (context, data, child) {
                          LoanStatementModel statementModel =
                              data.getLoanStatements;
                          if (statementModel != null) {
                            List<LoanStatementRow> statementRows =
                                data.getLoanStatements.statementRows;
                            return Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(16.0),
                                  width: double.infinity,
                                  color: (themeChangeProvider.darkTheme)
                                      ? Colors.blueGrey[800]
                                      : Color(0xffededfe),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: heading2(
                                              text: "${widget.loan.name}",
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme.selectionHandleColor,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              customTitle(
                                                text:
                                                    "${groupObject.groupCurrency} ",
                                                fontSize: 18.0,
                                                color: Theme.of(context)
                                                    // ignore: deprecated_member_use
                                                    .textSelectionTheme.selectionHandleColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              heading2(
                                                text:
                                                    "${currencyFormat.format(widget.loan.amount)}",
                                                color: Theme.of(context)
                                                    // ignore: deprecated_member_use
                                                    .textSelectionTheme.selectionHandleColor,
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
//                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  children: <Widget>[
//                                    subtitle2(
//                                        text: "Loan + Interest: ", color: Theme.of(context).textSelectionTheme.selectionHandleColor, textAlign: TextAlign.start),
//                                    customTitle(
//                                        text: "Ksh ${currencyFormat.format(data.getLoanStatements.lumpSum)}",
//                                        color: Theme.of(context).textSelectionTheme.selectionHandleColor,
//                                        fontSize: 12,
//                                        textAlign: TextAlign.start),
//                                  ],
//                                ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          subtitle2(
                                              text: "Amount Repaid ",
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme.selectionHandleColor,
                                              textAlign: TextAlign.start),
                                          subtitle1(
                                              text:
                                                  "${groupObject.groupCurrency} ${currencyFormat.format(data.getLoanStatements.paid)}",
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme.selectionHandleColor,
                                              textAlign: TextAlign.start),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          subtitle2(
                                              text: "Balance ",
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme.selectionHandleColor,
                                              textAlign: TextAlign.start),
                                          subtitle1(
                                              text:
                                                  "${groupObject.groupCurrency} ${currencyFormat.format(data.getLoanStatements.balance)}",
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme.selectionHandleColor,
                                              textAlign: TextAlign.start),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          subtitle2(
                                              text: "Disbursed On ",
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme.selectionHandleColor,
                                              textAlign: TextAlign.start),
                                          subtitle1(
                                              text:
                                                  widget.loan.disbursementDate,
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme.selectionHandleColor,
                                              textAlign: TextAlign.start),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                statementRows.length > 0
                                    ? Container(
                                        padding: EdgeInsets.fromLTRB(
                                            16.0, 8.0, 16.0, 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Container(),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: subtitle1(
                                                  text: "Paid",
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  textAlign: TextAlign.end),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: subtitle1(
                                                  text: "Balance",
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  textAlign: TextAlign.end),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                Expanded(
                                  child: statementRows.length > 0
                                      ? ListView.builder(
                                          controller: _scrollController,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            LoanStatementRow row =
                                                statementRows[index];
                                            return LoanStatementBody(
                                              row: row,
                                              position: index % 2 == 0,
                                            );
                                          },
                                          itemCount: statementRows.length,
                                        )
                                      : emptyList(
                                          color: Colors.blue[400],
                                          iconData: LineAwesomeIcons.file,
                                          text:
                                              "There are no statements to display"),
                                )
                              ],
                            );
                          } else {
                            return Center(
                              child: emptyList(
                                  color: Colors.blue[400],
                                  iconData: LineAwesomeIcons.pie_chart,
                                  text:
                                      "There are no loan statements to display"),
                            );
                          }
                        })));
          },
        ));
  }
}
