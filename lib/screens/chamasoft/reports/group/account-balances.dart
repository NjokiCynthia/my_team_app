import 'package:chamasoft/providers/groups.dart';
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
  Future<void> _future;
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

  Future<void> _getAccountBalances(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchReportAccountBalances();
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
    _future = _getAccountBalances(context);
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
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Account Balances",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => _getAccountBalances(context),
                  child: Consumer<Groups>(builder: (context, data, child) {
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
                              heading2(
                                  text: "Ksh " + currencyFormat.format(int.tryParse(totalBalance) ?? 0),
                                  color: Theme.of(context).textSelectionHandleColor,
                                  textAlign: TextAlign.start)
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              AccountBalance balance = accountBalances[index];
                              if (balance.isHeader) {
                                return AccountHeader(header: balance);
                              } else {
                                return AccountBody(account: balance);
                              }
                            },
                            itemCount: accountBalances.length,
                          ),
                        ),
                      ],
                    );
                  }),
                )),
    );
  }
}
