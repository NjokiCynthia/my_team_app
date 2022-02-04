import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/transaction-statement-model.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/screens/pdfAPI.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class TransactionStatement extends StatefulWidget {
  @override
  _TransactionStatementState createState() => _TransactionStatementState();
}

class _TransactionStatementState extends State<TransactionStatement> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInit = true;
  bool _isLoading = true;
  TransactionStatementModel _transactionStatementModel;
  List<TransactionStatementRow> _transactions = [];
  double _totalBalance = 0;
  // double _deposits = 0;
  // double _withdrawals = 0;
  String _statementAsAt = '', _statementFrom = '', _statementTo = '';

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _getTransactionStatement(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchTransactionStatement();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getTransactionStatement(context);
          });
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _transactionStatementModel =
        Provider.of<Groups>(context, listen: false).transactionStatement;

    if (_transactionStatementModel != null) {
      _transactions = _transactionStatementModel.transactionStatements;
      _totalBalance = _transactionStatementModel.totalBalance;
      _statementFrom = _transactionStatementModel.statementPeriodFrom;
      _statementTo = _transactionStatementModel.statementPeriodTo;
      _statementAsAt = _transactionStatementModel.statementDate;
    }

    _getTransactionStatement(context).then((_) {
      _transactionStatementModel =
          Provider.of<Groups>(context, listen: false).transactionStatement;
      setState(() {
        _isLoading = false;
        if (_transactionStatementModel != null) {
          _transactions = _transactionStatementModel.transactionStatements;
          _totalBalance = _transactionStatementModel.totalBalance;
          _statementFrom = _transactionStatementModel.statementPeriodFrom;
          _statementTo = _transactionStatementModel.statementPeriodTo;
          _statementAsAt = _transactionStatementModel.statementDate;
        }
      });
    });

    _isInit = false;
    return true;
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  Future _downloadGroupTransactionStatement(
      BuildContext context, Group groupObject) async {
    final title = "Transaction Statement";
    final pdfFile = await PdfApi.generateGroupTransactionStatementPdf(
        _statementFrom,
        _transactions,
        _statementTo,
        _statementAsAt,
        title,
        groupObject,
        _totalBalance);
    PdfApi.openFile(pdfFile);
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
      appBar: tertiaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Transaction Statement",
        trailingIcon: LineAwesomeIcons.download,
        trailingAction: () =>
            _downloadGroupTransactionStatement(context, groupObject),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: RefreshIndicator(
        backgroundColor: (themeChangeProvider.darkTheme)
            ? Colors.blueGrey[800]
            : Colors.white,
        onRefresh: () => _fetchData(),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              color: (themeChangeProvider.darkTheme)
                  ? Colors.blueGrey[800]
                  : Color(0xffededfe),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              heading2(
                                  text: "Total Balance",
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  textAlign: TextAlign.start),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  subtitle2(
                                      text: "Deposits ",
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                      textAlign: TextAlign.start),
                                  subtitle1(
                                      text: "-",
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                      textAlign: TextAlign.start),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  subtitle2(
                                      text: "Withdrawals ",
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                      textAlign: TextAlign.start),
                                  subtitle1(
                                      text: "-",
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                      textAlign: TextAlign.start),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      heading2(
                          text: "${groupObject.groupCurrency} " +
                              currencyFormat.format(_totalBalance),
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.start)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          subtitle2(
                            text: "Statement as At",
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.start,
                          ),
                          customTitle(
                            text: _statementAsAt,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            subtitle2(
                              text: "Statement Period",
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionHandleColor,
                              textAlign: TextAlign.end,
                            ),
                            customTitle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              text: _statementFrom + " to " + _statementTo,
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionHandleColor,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            _isLoading
                ? showLinearProgressIndicator()
                : SizedBox(
                    height: 0.0,
                  ),
            Container(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: customTitle(
                        text: "Deposits",
                        fontSize: 13.0,
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.center),
                  ),
                  Expanded(
                    flex: 1,
                    child: customTitle(
                        text: "Withdrawals",
                        fontSize: 13.0,
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.center),
                  ),
                  Expanded(
                    flex: 1,
                    child: customTitle(
                        text: "Balance",
                        fontSize: 13.0,
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  TransactionStatementRow row = _transactions[index];
                  return TransactionStatementBody(
                    row: row,
                    position: index % 2 == 0,
                  );
                },
                itemCount: _transactions.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
