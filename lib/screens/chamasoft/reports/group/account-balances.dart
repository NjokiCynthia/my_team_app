import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class AccountBalances extends StatefulWidget {
  @override
  _AccountBalancesState createState() => _AccountBalancesState();
}

class _AccountBalancesState extends State<AccountBalances> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isLoading = true;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  void _getAccountBalances(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: true).fetchReportAccountBalances();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(context: context, error: error, callback: () {});
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    //_getAccountBalances(context);
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
    _getAccountBalances(context);

    final List<StatementRow> list = [
      StatementRow.header(true, "Bank Accounts"),
      StatementRow(false, "KCB Bank", "Account 1102132421424", "123000", DateTime.now()),
      StatementRow(false, "Equity Bank", "Account 12u3242433", "41000", DateTime.now()),
      StatementRow(false, "ABSA Bank", "Account 1109323212324", "90888", DateTime.now()),
      StatementRow.header(true, "Wallet Accounts"),
      StatementRow(false, "Chamasoft E.C.W", "Account 124031", "10000", DateTime.now()),
      StatementRow.header(true, "Sacco Accounts"),
      StatementRow(false, "Biashara Initiative Sacco", "Account 124124124956456", "22000", DateTime.now()),
      StatementRow(false, "Finnlemm Sacco", "Account 113345934534", "7000", DateTime.now()),
    ];
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Account Balances",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(builder: (BuildContext context) {
        //_getAccountBalances(context);
        return _isLoading
            ? Center(child: CircularProgressIndicator())
            : Consumer<Groups>(builder: (context, data, child) {
                List<AccountBalance> accountBalances = data.accountBalances.accounts;
                String totalBalance = data.accountBalances.totalBalance;
                return Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20.0),
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
                                heading2(text: "Total ", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    subtitle2(
                                        text: "Account balances", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          heading2(text: totalBalance, color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start)
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          StatementRow row = list[index];
                          if (row.isHeader) {
                            return StatementHeader(row: row);
                          } else {
                            return AccountBody(row: row);
                          }
                        },
                        itemCount: list.length,
                      ),
                    ),
                  ],
                );
              });
      }),
    );
  }
}
