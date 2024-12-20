// ignore_for_file: deprecated_member_use

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal-request.dart';
import 'package:chamasoft/screens/chamasoft/reports/filter_container.dart';
import 'package:chamasoft/screens/chamasoft/reports/sort-container.dart';
import 'package:chamasoft/screens/chamasoft/transactions.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ReviewWithdrawalRequest extends StatefulWidget {
  @override
  _ReviewWithdrawalRequestState createState() =>
      _ReviewWithdrawalRequestState();
}

class _ReviewWithdrawalRequestState extends State<ReviewWithdrawalRequest> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<WithdrawalRequest> _withdrawalRequests = [];
  bool _isLoading = true;
  bool _isInit = true;
  List<int> statusApproval = []; //[1, 2, 3];
  List<int> statusDisbursement = [14, 15, 16];
  int selectedRadioTile;
  String _sortOption = "date_desc";
  List<int> _filterList = [1];
  List<String> _memberList = [];
  int requestId;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _getWithdrawalRequests(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchWithdrawalRequests(
          _sortOption, _filterList, _memberList, _withdrawalRequests.length);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getWithdrawalRequests(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _withdrawalRequests =
        Provider.of<Groups>(context, listen: false).getWithdrawalRequestList;
    _getWithdrawalRequests(context).then((_) {
      _withdrawalRequests =
          Provider.of<Groups>(context, listen: false).getWithdrawalRequestList;
      setState(() {
        _isLoading = false;
      });
    });

    _isInit = false;
    return true;
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void applySort(String sort) {
    _sortOption = sort;
    _fetchData();
  }

  void showSortBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => SortContainer(_sortOption, applySort));
  }

  void showFilterOptions() async {
    List<dynamic> filters = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return FilterContainer(
        filterType: 3,
        currentFilters: _filterList,
        currentMembers: _memberList,
      );
    }));

    if (filters != null && filters.length == 2) {
      _filterList = filters[0];
      _memberList = filters[1];
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage; //get current language
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: secondaryPageAppbar(
            context: context,
            action: () {
              Navigator.of(context).pop();
            },

            //Navigator.of(context).pop(),
            elevation: 1,
            leadingIcon: LineAwesomeIcons.arrow_left,
            title: currentLanguage == 'English'
                ? 'Review Withdrawal Requests'
                : Provider.of<TranslationProvider>(context, listen: false)
                        .translate('Review Withdrawal Requests') ??
                    'Review Withdrawal Requests',
          ),
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            backgroundColor: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Colors.white,
            onRefresh: () => _fetchData(),
            child: Container(
              decoration: primaryGradient(context),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color:
                                            Theme.of(context).bottomAppBarColor,
                                        width: 0.5),
                                    bottom: BorderSide(
                                        color:
                                            Theme.of(context).bottomAppBarColor,
                                        width: 1.0))),
                            child: Material(
                              color: Theme.of(context).backgroundColor,
                              child: InkWell(
                                onTap: () => showSortBottomSheet(),
                                splashColor: Colors.blueGrey.withOpacity(0.2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LineAwesomeIcons.sort,
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionHandleColor),
                                    subtitle1(
                                        text: currentLanguage == 'English'
                                            ? 'Sort'
                                            : Provider.of<TranslationProvider>(
                                                        context,
                                                        listen: false)
                                                    .translate('Sort') ??
                                                'Sort',
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionHandleColor)
                                  ],
                                ),
                              ),
                            ) //loan.status == 2 ? null : repay),
                            ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color:
                                            Theme.of(context).bottomAppBarColor,
                                        width: 0.5),
                                    bottom: BorderSide(
                                        color:
                                            Theme.of(context).bottomAppBarColor,
                                        width: 1.0))),
                            child: Material(
                              color: Theme.of(context).backgroundColor,
                              child: InkWell(
                                splashColor: Colors.blueGrey.withOpacity(0.2),
                                onTap: () => showFilterOptions(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LineAwesomeIcons.filter,
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionHandleColor),
                                    subtitle1(
                                        text: currentLanguage == 'English'
                                            ? 'Filter'
                                            : Provider.of<TranslationProvider>(
                                                        context,
                                                        listen: false)
                                                    .translate('Filter') ??
                                                'Filter',
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionHandleColor)
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  _isLoading
                      ? showLinearProgressIndicator()
                      : SizedBox(
                          height: 0.0,
                        ),
                  Expanded(
                    child: _withdrawalRequests.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              WithdrawalRequest request =
                                  _withdrawalRequests[index];
                              return WithdrawalRequestCard(
                                request: request,
                                action: () async {
                                  final result = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ReviewWithdrawal(
                                                requestId: request.requestId,
                                              )));

                                  if (result != null && result) {
                                    _fetchData();
                                  }
                                },
                              );
                            },
                            itemCount: _withdrawalRequests.length,
                          )
                        : emptyList(
                            color: Colors.blue[400],
                            iconData: LineAwesomeIcons.angle_double_down,
                            text: currentLanguage == 'English'
                                ? 'There are no withdrawal requests to display'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate(
                                            'There are no withdrawal requests to display') ??
                                    'There are no withdrawal requests to display',
                          ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class WithdrawalRequestCard extends StatelessWidget {
  const WithdrawalRequestCard({Key key, @required this.request, this.action})
      : super(key: key);

  final WithdrawalRequest request;
  final Function action;

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    IconData iconData = LineAwesomeIcons.info_circle;
    Color color = Colors.blueGrey;
    if (request.statusCode == 3) {
      //failed
      iconData = LineAwesomeIcons.times;
      color = Colors.red;
    } else if (request.statusCode == 5) {
      iconData = LineAwesomeIcons.check;
      color = Colors.green;
    } else if (request.statusCode == 6) {
      iconData = LineAwesomeIcons.times;
      color = Colors.red;
    }
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage; //get current language
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Card(
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderOnForeground: false,
        child: Container(
            padding: EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
            decoration: cardDecoration(
                gradient: plainCardGradient(context), context: context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: customTitle(
                        text: request.withdrawalFor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        customTitle(
                          text: "${groupObject.groupCurrency} ",
                          fontSize: 16.0,
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor,
                        ),
                        customTitle(
                          text: currencyFormat.format(request.amount),
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            subtitle2(
                                text: currentLanguage == 'English'
                                    ? 'Requested On'
                                    : Provider.of<TranslationProvider>(context,
                                                listen: false)
                                            .translate('Requested On') ??
                                        'Requested On',
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                textAlign: TextAlign.start),
                            customTitleWithWrap(
                              text: request.requestDate,
                              fontSize: 12.0,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            subtitle2(
                                text: currentLanguage == 'English'
                                    ? 'Initiate By'
                                    : Provider.of<TranslationProvider>(context,
                                                listen: false)
                                            .translate('Initiate By') ??
                                        'Initiate By',
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                textAlign: TextAlign.end),
                            customTitleWithWrap(
                              text: request.name,
                              fontSize: 12.0,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                      ),
                    ]),
                SizedBox(
                  height: 5,
                ),
                subtitle2(
                    text: currentLanguage == 'English'
                        ? 'Recipient'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('Recipient') ??
                            'Recipient',
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                    textAlign: TextAlign.start),
                customTitleWithWrap(
                  text: request.recipient,
                  fontSize: 12.0,
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                  visible: request.statusCode == 5 || request.statusCode == 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subtitle2(
                          text: request.statusCode == 5
                              ? currentLanguage == 'English'
                                  ? 'Disbursed To'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate('Disbursed To') ??
                                      'Disbursed To'
                              : currentLanguage == 'English'
                                  ? 'Disbursement Status'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate('Disbursement Status') ??
                                      'Disbursement Status',
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor,
                          textAlign: TextAlign.start),
                      customTitleWithWrap(
                        text: request.description,
                        fontSize: 12.0,
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            iconData,
                            color: color,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: customTitleWithWrap(
                              text: request.status,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    plainButtonWithArrow(
                        text: request.isOwner == 1
                            ? currentLanguage == 'English'
                                ? 'VIEW'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate('VIEW') ??
                                    'VIEW'
                            : request.hasResponded == 0
                                ? currentLanguage == 'English'
                                    ? 'RESPOND'
                                    : Provider.of<TranslationProvider>(context,
                                                listen: false)
                                            .translate('RESPOND') ??
                                        'RESPOND'
                                : currentLanguage == 'English'
                                    ? 'VIEW'
                                    : Provider.of<TranslationProvider>(context,
                                                listen: false)
                                            .translate('VIEW') ??
                                        'VIEW',
                        // ignore: todo
                        //TODO: Admin Restrictions
                        size: 16.0,
                        spacing: 2.0,
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor
                            .withOpacity(.8),
                        action: action),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
