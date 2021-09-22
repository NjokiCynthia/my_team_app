import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/reconcile-withdrawal-form.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ReconcileWithdrawalList extends StatefulWidget {
  final String reconciledWithdrawalTransactionAlertId;

  ReconcileWithdrawalList({this.reconciledWithdrawalTransactionAlertId});
  @override
  _ReconcileWithdrawalListState createState() =>
      _ReconcileWithdrawalListState();
}

class _ReconcileWithdrawalListState extends State<ReconcileWithdrawalList> {
  double _appBarElevation = 0;
  bool _isLoading = true;
  bool _isInit = true;
  List<UnreconciledWithdrawal> _withdrawals = [];
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Future<void> _fetchUnreconciledWithdrawals(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchGroupUnreconciledWithdrawals();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchUnreconciledWithdrawals(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _withdrawals =
        Provider.of<Groups>(context, listen: false).getUnreconciledWithdrawals;
    _fetchUnreconciledWithdrawals(context).then((_) {
      _withdrawals = Provider.of<Groups>(context, listen: false)
          .getUnreconciledWithdrawals;
      setState(() {
        _isLoading = false;
      });
    });
    _isInit = false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    List<UnreconciledWithdrawal> unreconciledWithdrawals =
        widget.reconciledWithdrawalTransactionAlertId != null
            ? _withdrawals.where((withdrawal) =>
                withdrawal.transactionAlertId !=
                widget.reconciledWithdrawalTransactionAlertId)
            : _withdrawals;

    return Scaffold(
        key: _scaffoldKey,
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: "Reconcile withdrawals",
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
                  child: unreconciledWithdrawals.length > 0
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            UnreconciledWithdrawal withdrawal =
                                unreconciledWithdrawals[index];
                            return UnreconciledWithdrawalCard(
                                withdrawal, groupObject);
                          },
                          itemCount: unreconciledWithdrawals.length,
                        )
                      : emptyList(
                          color: Colors.blue[400],
                          iconData: LineAwesomeIcons.angle_double_down,
                          text:
                              "There are no unreconciled withdrawals to display"),
                ),
              ],
            ),
          ),
        ));
  }
}

class UnreconciledWithdrawalCard extends StatefulWidget {
  final UnreconciledWithdrawal withdrawal;
  final Group groupObject;

  UnreconciledWithdrawalCard(this.withdrawal, this.groupObject, {Key key})
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
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w400,
                            ),
                            heading2(
                              text: currencyFormat
                                  .format(widget.withdrawal.amount),
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionHandleColor,
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
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Row(
                        children: [
                          Text(_isExpanded ? "View less" : "View more",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor)),
                          Icon(
                            _isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Theme.of(context).accentColor,
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    // ignore: deprecated_member_use
                    FlatButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext ctx) =>
                                  ReconcileWithdrawal(),
                              settings:
                                  RouteSettings(arguments: widget.withdrawal))),
                      child: Row(
                        children: [
                          Text(
                            "Reconcile",
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                          Icon(
                            Icons.arrow_right_rounded,
                            color: Theme.of(context).accentColor,
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
