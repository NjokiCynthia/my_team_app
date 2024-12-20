import 'package:chamasoft/helpers/report_helper.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
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
      _totalBalance = _accountBalanceModel.totalBalance as double;
      _accountBalances = _accountBalanceModel.accounts;
    }

    _getAccountBalances(context).then((_) {
      _accountBalanceModel =
          Provider.of<Groups>(context, listen: false).accountBalances;
      setState(() {
        _isLoading = false;
        if (_accountBalanceModel != null) {
          _totalBalance = _accountBalanceModel.totalBalance as double;
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

  Future _downloadAccounBalancesPdf(
      BuildContext context, Group groupObject) async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = true;
      });
    });

    setState(() async {
      final title = "Account Balance Report";
      final pdfFile = await PdfApi.generateAccountBalancePdf(title);
      PdfApi.openFile(pdfFile);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    return Scaffold(
        key: _scaffoldKey,
        appBar: tertiaryPageAppbar(
            context: context,
            action: () => Navigator.of(context).pop(),
            elevation: _appBarElevation,
            leadingIcon: LineAwesomeIcons.arrow_left,
            title: currentLanguage == 'English'
                ? 'Account balances'
                : Provider.of<TranslationProvider>(context, listen: false)
                        .translate('Account Balances') ??
                    'Account Balances',
            //"Account Balances",
            //  trailingIcon: LineAwesomeIcons.download,
            trailingAction: () =>
                _downloadAccounBalancesPdf(context, groupObject)),
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
                              text: currentLanguage == 'English'
                                  ? 'Total'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate('Total') ??
                                      'Total',
                              //"Total ",
                             
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.start),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              subtitle2(
                                  text: currentLanguage == 'English'
                                      ? 'Account balances'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate('Account Balances') ??
                                          'Account Balances',
                                  //"Account balances",
                                  color: Theme.of(context)
                                      
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                  textAlign: TextAlign.start),
                            ],
                          ),
                        ],
                      ),
                    ),
                    heading2(
                        text: "${groupObject.groupCurrency} " +
                            currencyFormat.format(_totalBalance),
                        
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor,
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
