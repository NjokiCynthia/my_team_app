import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal.dart';
import 'package:chamasoft/screens/chamasoft/reports/sort-container.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
// ignore: unused_import
import 'package:chamasoft/screens/chamasoft/reports/withdrawal-reciepts-detail.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'filter_container.dart';

class WithdrawalReceipts extends StatefulWidget {
  final int requestId;
  const WithdrawalReceipts({Key key, this.requestId}) : super(key: key);
  @override
  _WithdrawalReceiptsState createState() => _WithdrawalReceiptsState();
}

class _WithdrawalReceiptsState extends State<WithdrawalReceipts> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Withdrawal> _withdrawals = [];
  bool _isLoading = true;
  bool _isInit = true;
  String _sortOption = "date_desc";
  int selectedRadioTile;
  List<int> _filterList = [];
  List<String> _memberList = [];
  int count = 0;
  // Navigator.of(context).popUntil((_) => count++ >= 3);

  bool _hasMoreData = false;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _getWithdrawals(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchWithdrawals(
          _sortOption, _filterList, context, _memberList, _withdrawals.length);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getWithdrawals(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    _withdrawals = Provider.of<Groups>(context, listen: false).getWithdrawals;
    _getWithdrawals(context).then((_) {
      if (context != null) {
        _withdrawals =
            Provider.of<Groups>(context, listen: false).getWithdrawals;
        setState(() {
          if (_withdrawals.length < 20) {
            _hasMoreData = false;
          } else
            _hasMoreData = true;
          _isLoading = false;
        });
      }
    });

    _isInit = false;
    return true;
  }

  //   _withdrawals = Provider.of<Groups>(Buildcontext context, listen: false).getWithdrawals;
  //   _getWithdrawals(context).then((_) {
  //     if (context != null) {
  //       _withdrawals =
  //           Provider.of<Groups>(context, listen: false).getWithdrawals;
  //       setState(() {
  //         if (_withdrawals.length < 20) {
  //           _hasMoreData = false;
  //         } else
  //           _hasMoreData = true;
  //         _isLoading = false;
  //       });
  //     }
  //   });

  //   _isInit = false;
  //   return true;
  // }

  void showFilterOptions() async {
    List<dynamic> filters = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return FilterContainer(
        filterType: 2,
        currentFilters: _filterList,
        currentMembers: _memberList,
      );
    }));

    if (filters != null && filters.length == 2) {
      _filterList = filters[0];
      _memberList = filters[1];
      _fetchData(context);
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData(context));
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
    _fetchData(context);
  }

  void showSortBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => SortContainer(_sortOption, applySort));
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();

        return false; // Return false to prevent default back button behavior
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: secondaryPageAppbar(
              context: context,
              title: currentLanguage == 'English'
                  ? 'Withdrawals Receipts'
                  : Provider.of<TranslationProvider>(context, listen: false)
                          .translate('Withdrawals Receipts') ??
                      'Withdrawals Receipts',
              action: () => widget.requestId == WITHDRAWAL_REQUEST
                  ? Navigator.of(context).popUntil((_) => count++ >= 4)
                  : Navigator.of(context).pop(),
              elevation: 1,
              leadingIcon: LineAwesomeIcons.arrow_left),
          backgroundColor: Theme.of(context).backgroundColor,
          body: RefreshIndicator(
              backgroundColor: (themeChangeProvider.darkTheme)
                  ? Colors.blueGrey[800]
                  : Colors.white,
              onRefresh: () => _fetchData(context),
              child: Container(
                  decoration: primaryGradient(context),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Visibility(
                        visible: true,
                        child: Row(
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
                                              color: Theme.of(context)
                                                  .bottomAppBarTheme
                                                  .color,
                                              width: 0.5),
                                          bottom: BorderSide(
                                              color: Theme.of(context)
                                                  .bottomAppBarTheme
                                                  .color,
                                              width: 1.0))),
                                  child: Material(
                                    color: Theme.of(context).backgroundColor,
                                    child: InkWell(
                                      onTap: () => showSortBottomSheet(),
                                      splashColor:
                                          Colors.blueGrey.withOpacity(0.2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              color: Theme.of(context)
                                                  .bottomAppBarTheme
                                                  .color,
                                              width: 0.5),
                                          bottom: BorderSide(
                                              color: Theme.of(context)
                                                  .bottomAppBarTheme
                                                  .color,
                                              width: 1.0))),
                                  child: Material(
                                    color: Theme.of(context).backgroundColor,
                                    child: InkWell(
                                      splashColor:
                                          Colors.blueGrey.withOpacity(0.2),
                                      onTap: () => showFilterOptions(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                          .translate(
                                                              'Filter') ??
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
                      ),
                      _isLoading
                          ? showLinearProgressIndicator()
                          : SizedBox(
                              height: 0.0,
                            ),
                      Expanded(
                        child: _withdrawals.length > 0
                            ? NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (!_isLoading &&
                                      scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent &&
                                      _hasMoreData) {
                                    // ignore: todo
                                    //TODO check if has more data before fetching again
                                    _fetchData(context);
                                  }
                                  return true;
                                },
                                child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      Withdrawal withdrawal =
                                          _withdrawals[index];
                                      return WithdrawalCard(
                                        withdrawal: withdrawal,
                                        position: index,
                                        bodyContext: context,
                                        details: () {},
                                        voidItem: () {},
                                      );
                                    },
                                    itemCount: _withdrawals.length),
                              )
                            : emptyList(
                                color: Colors.blue[400],
                                iconData: LineAwesomeIcons.angle_double_up,
                                text: "There are no withdrawals to display"),
                      )
                    ],
                  )))),
    );
  }
}

// ignore: must_be_immutable
class WithdrawalCard extends StatelessWidget {
  WithdrawalCard(
      {Key key,
      @required this.withdrawal,
      this.details,
      this.voidItem,
      @required this.bodyContext,
      @required this.position})
      : super(key: key);

  final Withdrawal withdrawal;
  final Function details, voidItem;
  BuildContext bodyContext;
  final int position;
  GlobalKey _containerKey = GlobalKey();

  void _voidWithdrawalTransaction(String id) async {
    String currentLanguage =
        Provider.of<TranslationProvider>(bodyContext, listen: false)
            .currentLanguage;
    Navigator.of(bodyContext).pop();
    showDialog<String>(
        context: bodyContext,
        barrierDismissible: true,
        builder: (_) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await Provider.of<Groups>(bodyContext, listen: false)
          .voidWithdrawlTransaction(id, position, bodyContext);
      Navigator.of(bodyContext).pop();
      StatusHandler().showSuccessSnackBar(
        bodyContext,
        currentLanguage == 'English'
            ? 'Good news: Transaction successfully voided'
            : Provider.of<TranslationProvider>(bodyContext, listen: false)
                    .translate('Good news: Transaction successfully voided') ??
                'Good news: Transaction successfully voided',
      );
    } on CustomException catch (error) {
      Navigator.of(bodyContext).pop();
      StatusHandler().handleStatus(
          context: bodyContext,
          error: error,
          callback: () {
            _voidWithdrawalTransaction(id);
          });
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: RepaintBoundary(
        key: _containerKey,
        child: Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          borderOnForeground: false,
          child: Container(
              decoration: cardDecoration(
                  gradient: plainCardGradient(context), context: context),
              child: Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              customTitle(
                                text: withdrawal.type,
                                fontSize: 16.0,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                textAlign: TextAlign.start,
                              ),
                              subtitle2(
                                text: withdrawal.name,
                                textAlign: TextAlign.start,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            customTitle(
                              text: "${groupObject.groupCurrency} ",
                              fontSize: 18.0,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              fontWeight: FontWeight.w400,
                            ),
                            heading2(
                              text: currencyFormat.format(withdrawal.amount),
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              subtitle2(
                                  text: currentLanguage == 'English'
                                      ? 'Recipient By'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate('Recipient By') ??
                                          'Recipient By',
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                  textAlign: TextAlign.start),
                              customTitle1(
                                  text: withdrawal.recipient,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                  textAlign: TextAlign.start),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              subtitle2(
                                  text: currentLanguage == 'English'
                                      ? 'Withdrawn On'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate('Withdrawn On') ??
                                          'Withdrawn On',
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                  textAlign: TextAlign.end),
                              customTitle1(
                                  text: withdrawal.recordedOn,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                  textAlign: TextAlign.end)
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12.0, right: 12.0),
                    width: MediaQuery.of(context).size.width,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        subtitle2(
                            text: currentLanguage == 'English'
                                ? 'Narration:'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate('Narration:') ??
                                    'Narration:',
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
                            textAlign: TextAlign.start),
                        subtitle2(
                            text:
                                "${withdrawal.type} -- ${withdrawal.reconciliation}",
                            fontSize: 12.0,
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 0.5,
                    dashLength: 2.0,
                    dashColor: Colors.black45,
                    dashRadius: 0.0,
                    dashGapLength: 2.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          groupObject.isGroupAdmin
                              ? Row(
                                  children: <Widget>[
                                    plainButtonWithIcon(
                                        text: "    ",
                                        size: 14.0,
                                        spacing: 2.0,
                                        color: Colors.red,
                                        //iconData: Icons.delete,
                                        action: () {
                                          // twoButtonAlertDialog(
                                          //   action: () {
                                          //     _voidWithdrawalTransaction(
                                          //         withdrawal.id);
                                          //   },
                                          //   context: context,
                                          //   message:
                                          //       "Are you sure you want to void ${withdrawal.type} of ${groupObject.groupCurrency} ${currencyFormat.format(withdrawal.amount)} by ${withdrawal.recipient}?",
                                          //   title: "Confirm Action",
                                          // );
                                        }),
                                  ],
                                )
                              : Container(),
                          Row(
                            children: <Widget>[
                              groupObject.isGroupAdmin
                                  ? plainButtonWithIcon(
                                      text: currentLanguage == 'English'
                                          ? 'VOID'
                                          : Provider.of<TranslationProvider>(
                                                      context,
                                                      listen: false)
                                                  .translate('VOID') ??
                                              'VOID',
                                      size: 14.0,
                                      spacing: 2.0,
                                      color: Colors.red,
                                      iconData: Icons.delete,
                                      action: () {
                                        twoButtonAlertDialog(
                                          action: () {
                                            _voidWithdrawalTransaction(
                                                withdrawal.id);
                                          },
                                          context: context,
                                          message:
                                              "Are you sure you want to void ${withdrawal.type} of ${groupObject.groupCurrency} ${currencyFormat.format(withdrawal.amount)} by ${withdrawal.recipient}?",
                                          title: currentLanguage == 'English'
                                              ? 'Confirm Action'
                                              : Provider.of<TranslationProvider>(
                                                          context,
                                                          listen: false)
                                                      .translate(
                                                          'Confirm Action') ??
                                                  'Confirm Action',
                                        );
                                      })
                                  : Container(),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              plainButtonWithArrow(
                                  text: "    ",
                                  size: 14.0,
                                  spacing: 2.0,
                                  color: Colors.blue,
                                  action: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             new DetailRecieptWithdrawl(
                                    //                 withdrawal: withdrawal,
                                    //                 group: groupObject)));
                                  }),
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
//                Row(0...
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Expanded(
//                      flex: 1,
//                      child: Container(
//                          decoration: BoxDecoration(
//                              border: Border(
//                                  top: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0),
//                                  right: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 0.5))),
//                          child: plainButton(
//                              text: "SHOW DETAILS",
//                              size: 16.0,
//                              spacing: 2.0,
//                              color: Theme.of(context).primaryColor.withOpacity(0.5),
//                              // loan.status == 2 ? Theme.of(context).primaryColor.withOpacity(0.5) : Theme.of(context).primaryColor,
//                              action: details) //loan.status == 2 ? null : repay),
//                          ),
//                    ),
//                    Expanded(
//                      flex: 1,
//                      child: Container(
//                        decoration: BoxDecoration(
//                            border: Border(
//                                top: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0),
//                                left: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 0.5))),
//                        child: plainButton(text: "VOID", size: 16.0, spacing: 2.0, color: Colors.blueGrey, action: voidItem),
//                      ),
//                    ),
//                  ],
//                )
                ],
              )),
        ),
      ),
    );
  }
}
