import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/expense-category.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/screens/pdfAPI.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatefulWidget {
  @override
  _ExpenseSummaryState createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInit = true;
  bool _isLoading = true;
  double _appBarElevation = 0;
  ScrollController _scrollController;

  ExpenseSummaryList _expenseSummaryList;
  double _totalExpenses = 0;
  List<SummaryRow> _expenseRows = [];

  Future<void> _getExpenseSummary(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchExpenseSummary();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getExpenseSummary(context);
          });
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _expenseSummaryList =
        Provider.of<Groups>(context, listen: false).expenseSummaryList;

    if (_expenseSummaryList != null) {
      _expenseRows = _expenseSummaryList.expenseSummary;
      _totalExpenses = _expenseSummaryList.totalExpenses;
    }

    _getExpenseSummary(context).then((_) {
      _expenseSummaryList =
          Provider.of<Groups>(context, listen: false).expenseSummaryList;
      setState(() {
        _isLoading = false;
        if (_expenseSummaryList != null) {
          _expenseRows = _expenseSummaryList.expenseSummary;
          _totalExpenses = _expenseSummaryList.totalExpenses;
        }
      });
    });

    _isInit = false;
    return true;
  }

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

  Future _downoadExpensesSummaryPdf(
      BuildContext context, Group groupObject) async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = true;
      });
    });

    setState(() async {
      final title = "Expenses Summary";
    final pdfFile = await PdfApi.generateExpensesPdf(
        _expenseRows, title, groupObject, _totalExpenses);
    PdfApi.openFile(pdfFile);
      _isLoading = false;
    });
  }

  // Future _downoadExpensesSummaryPdf(
  //     BuildContext context, Group groupObject) async {
  //   final title = "Expenses Summary";
  //   final pdfFile = await PdfApi.generateExpensesPdf(
  //       _expenseRows, title, groupObject, _totalExpenses);
  //   PdfApi.openFile(pdfFile);
  // }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
        appBar: tertiaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: "Expense Summary",
          trailingIcon: LineAwesomeIcons.download,
          trailingAction: () =>
              _downoadExpensesSummaryPdf(context, groupObject),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: RefreshIndicator(
            backgroundColor: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Colors.white,
            onRefresh: () => _fetchData(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    color: (themeChangeProvider.darkTheme)
                        ? Colors.blueGrey[800]
                        : Color(0xffededfe),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  heading2(
                                    text: "Total Expenses",
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionTheme.selectionHandleColor,
                                  ),
                                  subtitle2(
                                    text: _expenseRows.length == 1
                                        ? "1 Expense"
                                        : "${_expenseRows.length} Expenses",
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionTheme.selectionHandleColor,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                customTitle(
                                  text: "${groupObject.groupCurrency} ",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.0,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionTheme.selectionHandleColor,
                                ),
                                heading2(
                                  text: currencyFormat.format(_totalExpenses),
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionTheme.selectionHandleColor,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _isLoading
                      ? showLinearProgressIndicator()
                      : SizedBox(
                          height: 0.0,
                        ),
                  _expenseRows.length > 0
                      ? Container(
                          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              subtitle1(
                                  text: "Paid",
                                  color: Theme.of(context).primaryColor,
                                  textAlign: TextAlign.end),
                            ],
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: _expenseRows.length > 0
                        ? ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              SummaryRow row = _expenseRows[index];
                              return ExpenseBody(
                                row: row,
                                position: index % 2 == 0,
                              );
                            },
                            itemCount: _expenseRows.length,
                          )
                        : emptyList(
                            color: Colors.blue[400],
                            iconData: LineAwesomeIcons.pie_chart,
                            text: "There are no expenses to display"),
                  )
                ],
              ),
            )));
  }
}
