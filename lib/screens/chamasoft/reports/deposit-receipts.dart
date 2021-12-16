// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:typed_data';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/deposit.dart';
import 'package:chamasoft/screens/chamasoft/reports/deposit-reciepts-detail.dart';
import 'package:chamasoft/screens/chamasoft/reports/filter_container.dart';
import 'package:chamasoft/screens/chamasoft/reports/sort-container.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
//import 'package:share/share.dart';
import 'dart:ui' as ui;

class DepositReceipts extends StatefulWidget {
  @override
  _DepositReceiptsState createState() => _DepositReceiptsState();
}

class _DepositReceiptsState extends State<DepositReceipts> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Deposit> _deposits = [];
  bool _isLoading = true;
  bool _isInit = true;
  String _sortOption = "date_desc";
  int selectedRadioTile;
  List<int> _filterList = [];
  List<String> _memberList = [];
  bool _hasMoreData = false;
  bool _forceFetch = false;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _getDeposits(BuildContext context) async {
    try {
      int _length = _deposits.length;
      if (_forceFetch) _length = 0;
      await Provider.of<Groups>(context, listen: false)
          .fetchDeposits(_sortOption, _filterList, _memberList, _length);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getDeposits(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    // _deposits = Provider.of<Groups>(context, listen: false).getDeposits;
    _getDeposits(context).then((_) {
      if (context != null) {
        // _deposits = Provider.of<Groups>(context, listen: false).getDeposits;
        setState(() {
          if (_deposits.length < 20) {
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
    _forceFetch = true;
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
        filterType: 1,
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
    _deposits = Provider.of<Groups>(context, listen: true).getDeposits;
    print('Deposits are as:  ');
    print(_deposits);

    return Scaffold(
        key: _scaffoldKey,
        appBar: secondaryPageAppbar(
            context: context,
            title: "Deposit Receipts",
            action: () => Navigator.of(context).pop(),
            elevation: 1,
            leadingIcon: LineAwesomeIcons.arrow_left),
        backgroundColor: Theme.of(context).backgroundColor,
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
                                                .bottomAppBarColor,
                                            width: 0.5),
                                        bottom: BorderSide(
                                            color: Theme.of(context)
                                                .bottomAppBarColor,
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
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor),
                                        subtitle1(
                                            text: "Sort",
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor)
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
                                                .bottomAppBarColor,
                                            width: 0.5),
                                        bottom: BorderSide(
                                            color: Theme.of(context)
                                                .bottomAppBarColor,
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
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor),
                                        subtitle1(
                                            text: "Filter",
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor)
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
                      child: _deposits.length > 0
                          ? NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!_isLoading &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent &&
                                    _hasMoreData) {
                                  // ignore: todo
                                  //TODO check if has more data before fetching again
                                  _fetchData();
                                }
                                return true;
                              },
                              child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    Deposit deposit = _deposits[index];
                                    return DepositCard(
                                      deposit: deposit,
                                      position: index,
                                      bodyContext: context,
                                    );
                                  },
                                  itemCount: _deposits.length),
                            )
                          : emptyList(
                              color: Colors.blue[400],
                              iconData: LineAwesomeIcons.angle_double_down,
                              text: "There are no deposits to display"),
                    )
                  ],
                ))));
  }
}

// ignore: must_be_immutable
class DepositCard extends StatelessWidget {
  DepositCard(
      {Key key,
      @required this.deposit,
      @required this.bodyContext,
      @required this.position})
      : super(key: key);

  final Deposit deposit;
  final int position;
  BuildContext bodyContext;
  GlobalKey _containerKey = GlobalKey();

  void _voidTransaction(String id) async {
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
          .voidDepositTransaction(id, position, bodyContext);
      Navigator.of(bodyContext).pop();
      StatusHandler().showSuccessSnackBar(
          bodyContext, "Good news: Deposit successfully voided");
    } on CustomException catch (error) {
      Navigator.of(bodyContext).pop();
      StatusHandler().handleStatus(
          context: bodyContext,
          error: error,
          callback: () {
            _voidTransaction(id);
          });
    } finally {}
  }

  void convertWidgetToImage() async {
    try {
      //PermissionStatus permissionStatus = SimplePermissions

      RenderRepaintBoundary renderRepaintBoundary =
          _containerKey.currentContext.findRenderObject();

      if (renderRepaintBoundary.debugNeedsPaint) {
        Timer(Duration(seconds: 1), () => convertWidgetToImage());
        return null;
      }

      ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
      ByteData byteData =
          await boxImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List uInt8List = byteData.buffer.asUint8List();
      // if (byteData != null) {
      //   final result = await ImageGallerySaver.saveImage(
      //       Uint8List.fromList(uInt8List),
      //       quality: 90,
      //       name: 'screenshot-${DateTime.now()}');
      //   print(result);
      //   print('Screenshot Saved' + result);

      //   Share.shareFiles([result.path]);
      // }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              customTitle1(
                                text: deposit.type,
                                fontSize: 16.0,
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.start,
                              ),
                              subtitle2(
                                text: deposit.name,
                                textAlign: TextAlign.start,
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
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
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w400,
                            ),
                            heading2(
                              text: currencyFormat.format(deposit.amount),
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionHandleColor,
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
                                  text: "Paid By",
                                  color:
                                      // ignore: deprecated_member_use
                                      Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                  textAlign: TextAlign.start),
                              customTitle1(
                                  text: deposit.depositor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      // ignore: deprecated_member_use
                                      Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                  textAlign: TextAlign.start),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              subtitle2(
                                  text: "Paid On",
                                  color:
                                      // ignore: deprecated_member_use
                                      Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                  textAlign: TextAlign.end),
                              customTitle1(
                                  text: deposit.date,
                                  fontSize: 16,
                                  color:
                                      // ignore: deprecated_member_use
                                      Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                  textAlign: TextAlign.end)
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12.0, right: 12.0),
                    width: MediaQuery.of(context).size.width,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        subtitle2(
                            text: "Narration: ",
                            color:
                                // ignore: deprecated_member_use
                                Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
                            textAlign: TextAlign.start),
                        subtitle2(
                            text:
                                "${deposit.narration} -- ${deposit.reconciliation}",
                            fontSize: 12.0,
                            color:
                                // ignore: deprecated_member_use
                                Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor,
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
                                        text: "VOID",
                                        size: 14.0,
                                        spacing: 2.0,
                                        color: Colors.red,
                                        iconData: Icons.delete,
                                        action: () {
                                          twoButtonAlertDialog(
                                            action: () {
                                              _voidTransaction(deposit.id);
                                            },
                                            context: context,
                                            message:
                                                "Are you sure you want to void ${deposit.type} of ${groupObject.groupCurrency} ${currencyFormat.format(deposit.amount)} by ${deposit.depositor}?",
                                            title: "Confirm Action",
                                          );
                                        }),
                                  ],
                                )
                              : Container(),
                          Container(
                            child: Column(
                              children: <Widget>[
                                DottedLine(
                                  direction: Axis.vertical,
                                  lineLength: 45.0,
                                  lineThickness: 0.5,
                                  dashLength: 2.0,
                                  dashColor: Colors.black45,
                                  dashRadius: 0.0,
                                  dashGapLength: 2.0,
                                  dashGapColor: Colors.transparent,
                                  dashGapRadius: 0.0,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              plainButtonWithArrow(
                                  text: "VIEW",
                                  size: 14.0,
                                  spacing: 2.0,
                                  color: Colors.blue,
                                  action: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new DetailReciept(
                                                    deposit: deposit,
                                                    group: groupObject)));
                                  }),
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
