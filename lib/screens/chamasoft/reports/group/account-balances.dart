import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _appBarElevation = 0;
  bool _isInit = true;
  double _totalBalance = 0;
  AccountBalanceModel _accountBalanceModel;
  List<AccountBalance> _accountBalances = [];
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

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _accountBalanceModel =
        Provider.of<Groups>(context, listen: false).accountBalances;

    if (_accountBalanceModel != null) {
      _totalBalance = _accountBalanceModel.totalBalance;
      _accountBalances = _accountBalanceModel.accounts;
    }

    _getAccountBalances(context).then((_) {
      _accountBalanceModel =
          Provider.of<Groups>(context, listen: false).accountBalances;
      setState(() {
        _isLoading = false;
        if (_accountBalanceModel != null) {
          _totalBalance = _accountBalanceModel.totalBalance;
          _accountBalances = _accountBalanceModel.accounts;
        }
      });
    });

    _isInit = false;
    return true;
  }

  Future<void> _getAccountBalances(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchReportAccountBalances();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {},
          scaffoldState: _scaffoldKey.currentState);
    } finally {
      _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
        key: _scaffoldKey,
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: "Account Balances",
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
                padding: EdgeInsets.all(20.0),
                color: (themeChangeProvider.darkTheme)
                    ? Colors.blueGrey[800]
                    : Color(0xffededfe),
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
                              text: "Total ",
                              color: Theme.of(context).textSelectionHandleColor,
                              textAlign: TextAlign.start),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              subtitle2(
                                  text: "Account balances",
                                  color: Theme.of(context)
                                      .textSelectionHandleColor,
                                  textAlign: TextAlign.start),
                            ],
                          ),
                        ],
                      ),
                    ),
                    heading2(
                        text: "${groupObject.groupCurrency} " +
                            currencyFormat.format(_totalBalance),
                        color: Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.start)
                  ],
                ),
              ),
              _isLoading
                  ? showLinearProgressIndicator()
                  : SizedBox(
                      height: 0.0,
                    ),
              Expanded(
                child: _accountBalances.length > 0
                    ? ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          AccountBalance balance = _accountBalances[index];
                          if (balance.isHeader) {
                            return AccountHeader(header: balance);
                          } else {
                            return AccountBody(account: balance);
                          }
                        },
                        itemCount: _accountBalances.length,
                      )
                    : emptyList(
                        color: Colors.blue[400],
                        iconData: LineAwesomeIcons.list,
                        text: "No Account balances available"),
              ),
            ],
          ),
        ));
  }
}
