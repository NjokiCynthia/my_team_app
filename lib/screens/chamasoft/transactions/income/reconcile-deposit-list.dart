// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/notification_summary.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/reconcile-deposit-form.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ReconcileDepositList extends StatefulWidget {
  final bool isInit;
  final Map<String, dynamic> formLoadData;
  final int requestId;

  ReconcileDepositList({this.requestId, this.isInit = true, this.formLoadData});
  @override
  _ReconcileDepositListState createState() => _ReconcileDepositListState();
}

class _ReconcileDepositListState extends State<ReconcileDepositList> {
  double _appBarElevation = 0;
  bool _isLoading = true;
  bool _isInit = true;
  Group _groupObject;
  List<UnreconciledDeposit> _unreconciledDeposits;
  Map<String, dynamic> _formLoadData;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int count = 0;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
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
    setState(() {
      _isInit = widget.isInit;
      if (_isInit == false) {
        _formLoadData = widget.formLoadData;
        _isLoading = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // get the unreconciled deposits
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  Future<void> _fetchUnreconciledDeposits(BuildContext context) async {
    setState(() {
      _isInit = false;
    });

    try {
      // Load formdata values
      Provider.of<Groups>(context, listen: false)
          .loadInitialFormData(
        contr: true,
        acc: true,
        member: true,
        fineOptions: true,
        depositor: true,
        incomeCats: true,
        loanTypes: true,
      )
          .then((value) {
        // Load unreconciled deposits
        Provider.of<Groups>(context, listen: false)
            .fetchGroupUnreconciledDeposits()
            .then((_) {
          setState(() {
            _isLoading = false;
            _formLoadData = value;
          });
        });
      });
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchUnreconciledDeposits(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    return _fetchUnreconciledDeposits(context).then((value) => true);
  }

  @override
  Widget build(BuildContext context) {
    _groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    _unreconciledDeposits =
        Provider.of<Groups>(context, listen: true).getUnreconciledDeposits;

    final int unreconciledDepositCountfromDepositList =
        Provider.of<GroupNotifications>(context, listen: true)
            .unreconciledDepositCount;
    final int unreconciledWithdrawalCountDepositList =
        Provider.of<GroupNotifications>(context, listen: true)
            .unreconciledWithdrwalCount;

    final bool _isPartnerBankAccountDepositList =
        Provider.of<GroupNotifications>(context, listen: true)
            .isPartnerBankAccount;

    print("Group Status is : $_isPartnerBankAccountDepositList");
    print(
        "Unreconciled Deposit Count is : $unreconciledDepositCountfromDepositList");
    print(
        "Unreconciled Withdrawal Count is : $unreconciledWithdrawalCountDepositList");

    return Scaffold(
        key: _scaffoldKey,
        appBar: secondaryPageAppbar(
          context: context,
          action: () => /* Navigator.of(context)
              .pop() */
              widget.requestId == DEPOSIT_RECONSILE
                  ? Navigator.of(context).popUntil((_) => count++ >= 2)
                  : Navigator.of(context)
                      .pop() /*  Navigator.popUntil(
              context, (Route<dynamic> route) => route.isFirst) */
          ,
          /*  Navigator.pop(
                      context, unreconciledDepositCountfromDepositList), */
          elevation: 1,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: "Reconcile deposits",
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
                _isLoading
                    ? showLinearProgressIndicator()
                    : SizedBox(
                        height: 0.0,
                      ),
                Expanded(
                  child: _unreconciledDeposits.length > 0
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            UnreconciledDeposit deposit =
                                _unreconciledDeposits[index];
                            return UnreconciledDepositCard(
                                deposit, _groupObject, _formLoadData, index);
                          },
                          itemCount: _unreconciledDeposits.length,
                        )
                      : emptyList(
                          color: Colors.blue[400],
                          iconData: LineAwesomeIcons.angle_double_down,
                          text:
                              "There are no unreconciled deposits to display"),
                ),
              ],
            ),
          ),
        ));
  }
}

class UnreconciledDepositCard extends StatefulWidget {
  final UnreconciledDeposit deposit;
  final Group groupObject;
  final Map<String, dynamic> formLoadData;
  final int index;

  UnreconciledDepositCard(
      this.deposit, this.groupObject, this.formLoadData, this.index,
      {Key key})
      : super(key: key);

  @override
  _UnreconciledDepositCardState createState() =>
      _UnreconciledDepositCardState();
}

class _UnreconciledDepositCardState extends State<UnreconciledDepositCard> {
  Key key;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
                      text: widget.deposit.transactionDate,
                      textAlign: TextAlign.start),
                ),
                subtitle: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: double.infinity,
                        child: subtitle1(
                            text: widget.deposit.accountDetails,
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
                              text:
                                  currencyFormat.format(widget.deposit.amount),
                              // ignore: deprecated_member_use
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: double.infinity,
                        child: subtitle2(
                            text: widget.deposit.particulars,
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
                                          "Account number: ${widget.deposit.accountNumber}",
                                      textAlign: TextAlign.start),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: double.infinity,
                                  child: subtitle2(
                                      text:
                                          "TransactionId: ${widget.deposit.transactionId}",
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
                          Text(_isExpanded ? "View less" : "View more",
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
                                      ReconcileDeposit(widget.formLoadData),
                              settings: RouteSettings(arguments: {
                                'deposit': widget.deposit,
                                'position': widget.index
                              }))),
                      child: Row(
                        children: [
                          Text(
                            "Reconcile",
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
