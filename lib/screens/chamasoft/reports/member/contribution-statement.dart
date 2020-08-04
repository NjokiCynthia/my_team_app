import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/FilterContainer.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ContributionStatement extends StatefulWidget {
  final int statementFlag;

  ContributionStatement({this.statementFlag});

  @override
  _ContributionStatementState createState() => _ContributionStatementState();
}

class _ContributionStatementState extends State<ContributionStatement> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  Future<void> _future;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _getContributionStatement(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchContributionStatement(widget.statementFlag);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getContributionStatement(context);
          });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _future = _getContributionStatement(context);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void _applyFilter() {}

  void _showFilter(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) => FilterContainer(ModalRoute.of(context).settings.arguments, _applyFilter));
  }

  @override
  Widget build(BuildContext context) {
    String appbarTitle = "Contribution Statement";
    String defaultTitle = "Contributions";

    if (widget.statementFlag == FINE_STATEMENT) {
      appbarTitle = "Fine Statement";
      defaultTitle = "Fines Paid";
    }

    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          //trailingIcon: LineAwesomeIcons.filter,
          title: appbarTitle,
          //trailingAction: () => _showFilter(context),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _getContributionStatement(context),
                    child: Consumer<Groups>(builder: (context, data, child) {
                      if (data.getContributionStatements != null) {
                        List<ContributionStatementRow> statements = data.getContributionStatements.statements;
                        return Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(16.0),
                              color: (themeChangeProvider.darkTheme) ? Colors.blueGrey[800] : Color(0xffededfe),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        heading2(
                                            text: "Total " + defaultTitle,
                                            color: Theme.of(context).textSelectionHandleColor,
                                            textAlign: TextAlign.start),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            subtitle2(
                                                text: "Total amount due ",
                                                color: Theme.of(context).textSelectionHandleColor,
                                                textAlign: TextAlign.start),
                                            subtitle1(
                                                text: "Ksh " + currencyFormat.format(data.getContributionStatements.totalDue),
                                                color: Theme.of(context).textSelectionHandleColor,
                                                textAlign: TextAlign.start),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            subtitle2(
                                                text: "Balance ", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                            subtitle1(
                                                text: "Ksh " + currencyFormat.format(data.getContributionStatements.totalBalance),
                                                color: Theme.of(context).textSelectionHandleColor,
                                                textAlign: TextAlign.start),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  heading2(
                                      text: "Ksh " + currencyFormat.format(data.getContributionStatements.totalPaid),
                                      color: Theme.of(context).textSelectionHandleColor,
                                      textAlign: TextAlign.start)
                                ],
                              ),
                            ),
                            Expanded(
                              child: statements.length > 0
                                  ? ListView.builder(
                                      controller: _scrollController,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        ContributionStatementRow row = statements[index];
                                        if (row.isHeader) {
                                          return StatementHeader(row: row);
                                        } else {
                                          return StatementBody(row: row);
                                        }
                                      },
                                      itemCount: statements.length,
                                    )
                                  : emptyList(
                                      color: Colors.blue[400],
                                      iconData: LineAwesomeIcons.file_text,
                                      text: widget.statementFlag == FINE_STATEMENT
                                          ? "There are no fine statements to display"
                                          : "There are no contribution statements to display"),
                            ),
                          ],
                        );
                      } else
                        return Container(); //TODO: handle failed request
                    }))));
  }
}
