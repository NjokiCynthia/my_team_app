// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/reconcile-withdrawal-form.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ReconcileWithdrawalList extends StatefulWidget {
  final String reconciledWithdrawalTransactionAlertId;
  final bool isInit;
  final Map<String, dynamic> formData;
  final int requestId;

  ReconcileWithdrawalList(
      {this.reconciledWithdrawalTransactionAlertId,
      this.requestId,
      this.isInit = true,
      this.formData});
  @override
  _ReconcileWithdrawalListState createState() =>
      _ReconcileWithdrawalListState();
}

class _ReconcileWithdrawalListState extends State<ReconcileWithdrawalList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _appBarElevation = 0;
  Group groupObject;
  List<UnreconciledWithdrawal> _unreconciledWithdrawal;
  ScrollController _scrollController;
  bool _isInit = true;
  bool _isLoading = true;
  Map<String, dynamic> _formLoadData = {};
  int count = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    setState(() {
      _isInit = widget.isInit;
      if (!_isInit) {
        _formLoadData = widget.formData;
        _isLoading = false;
      }
    });
    super.initState();
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
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    } else {
      setState(() {
        // _isLoading = false;
        // _formLoadData = widget.formData;
      });
    }
    super.didChangeDependencies();
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    return _fetchUnreconcilledWithdrawals(context).then((value) => true);
  }

  Future<void> _fetchUnreconcilledWithdrawals(BuildContext context) async {
    try {
      setState(() {
        _isInit = false;
      });
      Provider.of<Groups>(context, listen: false)
          .loadInitialFormData(
        acc: true,
        bankLoans: true,
        borrowers: true,
        contr: true,
        depositor: true,
        exp: true,
        groupAssets: true,
        groupStocks: true,
        member: true,
        loanTypes: true,
      )
          .then((value) {
        Provider.of<Groups>(context, listen: false)
            .fetchGroupUnreconciledWithdrawals()
            .then((_) {
          setState(() {
            _isLoading = false;
            _formLoadData = value;
          });
        });
      });
    } catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchUnreconcilledWithdrawals(context);
          });
    } finally {
      // if (this.mounted) {
      //   if (_isInit == false) {
      //     setState(() {
      //       _isInit = true;
      //     });
      //   }
      // }
    }
  }

  // Provider.of<Groups>(context, listen: false).getCurrentGroup();
  @override
  Widget build(BuildContext context) {
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    groupObject = Provider.of<Groups>(context, listen: false).getCurrentGroup();
    _unreconciledWithdrawal =
        Provider.of<Groups>(context, listen: true).getUnreconciledWithdrawals;
    return Scaffold(
        key: _scaffoldKey,
        appBar: secondaryPageAppbar(
          context: context,
          action:
              () => /*Navigator.popUntil(
              context, (Route<dynamic> route) => route.isFirst)*/
                  widget.requestId == DEPOSIT_RECONSILE
                      ? Navigator.of(context).popUntil((_) => count++ >= 2)
                      : Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: currentLanguage == 'English'
              ? 'Reconcile Withdrawals'
              : Provider.of<TranslationProvider>(context, listen: false)
                      .translate('Reconcile Withdrawals') ??
                  'Reconcile Withdrawals',
        ),
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
                child: Column(children: <Widget>[
                  _isLoading
                      ? showLinearProgressIndicator()
                      : SizedBox(
                          height: 0.0,
                        ),
                  Expanded(
                    child: _unreconciledWithdrawal.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              UnreconciledWithdrawal withdrawal =
                                  _unreconciledWithdrawal[index];
                              return UnreconciledWithdrawalCard(withdrawal,
                                  groupObject, _formLoadData, index);
                            },
                            itemCount: _unreconciledWithdrawal.length,
                          )
                        : emptyList(
                            color: Colors.blue[400],
                            iconData: LineAwesomeIcons.angle_double_down,
                            text: currentLanguage == 'English'
                                ? 'There are no unreconciled withdrawals to display'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate(
                                            'There are no unreconciled withdrawals to display') ??
                                    'There are no unreconciled withdrawals to display',
                          ),
                  ),
                ]))));
  }
}

class UnreconciledWithdrawalCard extends StatefulWidget {
  final UnreconciledWithdrawal withdrawal;
  final Group groupObject;
  final Map<String, dynamic> formLoadData;
  final int cardPosition;

  UnreconciledWithdrawalCard(
      this.withdrawal, this.groupObject, this.formLoadData, this.cardPosition,
      {Key key})
      : super(key: key);

  @override
  _UnreconciledWithdrawalCardState createState() =>
      _UnreconciledWithdrawalCardState();
}

class _UnreconciledWithdrawalCardState
    extends State<UnreconciledWithdrawalCard> {
  Key key;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderOnForeground: false,
        child: Container(
          decoration: cardDecoration(
              gradient: plainCardGradient(context), context: context),
          child: Column(
            children: [
              ListTile(
                title: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: subtitle1(
                      text: widget.withdrawal.transactionDate,
                      textAlign: TextAlign.start),
                ),
                subtitle: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: double.infinity,
                        child: subtitle1(
                            text: widget.withdrawal.accountDetails,
                            textAlign: TextAlign.start),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            customTitle(
                              text: "${widget.groupObject.groupCurrency} ",
                              fontSize: 18.0,
                              // ignore: deprecated_member_use
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              fontWeight: FontWeight.w400,
                            ),
                            heading2(
                              text: currencyFormat
                                  .format(widget.withdrawal.amount),
                              // ignore: deprecated_member_use
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),

                        // subtitle2(
                        //     text: " ${widget.groupObject.groupCurrency} " +
                        //         " ${currencyFormat.format(widget.withdrawal.amount)}",
                        //     textAlign: TextAlign.start),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: double.infinity,
                        child: subtitle2(
                            text: widget.withdrawal.particulars,
                            textAlign: TextAlign.start),
                      ),
                    ),
                    _isExpanded
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: double.infinity,
                                  child: subtitle2(
                                      text:
                                          "Account number: ${widget.withdrawal.accountNumber}",
                                      textAlign: TextAlign.start),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: double.infinity,
                                  child: subtitle2(
                                      text:
                                          "TransactionId: ${widget.withdrawal.transactionId}",
                                      textAlign: TextAlign.start),
                                ),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    // ignore: deprecated_member_use
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                              _isExpanded
                                  ? currentLanguage == 'English'
                                      ? 'View less'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate('View less') ??
                                          'View less'
                                  : currentLanguage == 'English'
                                      ? 'View more'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate('View more') ??
                                          'View more',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                          Icon(
                            _isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    // ignore: deprecated_member_use
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder:
                                  (BuildContext ctx) =>
                                      ReconcileWithdrawal(widget.formLoadData),
                              settings: RouteSettings(arguments: {
                                "withdrawal": widget.withdrawal,
                                "position": widget.cardPosition
                              }))),
                      child: Row(
                        children: [
                          Text(
                            currentLanguage == 'English'
                                ? 'Reconcile'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate('Reconcile') ??
                                    'Reconcile',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          Icon(
                            Icons.arrow_right_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
