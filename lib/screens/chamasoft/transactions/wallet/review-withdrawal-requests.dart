import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/deposit.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal-request.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ReviewWithdrawalRequests extends StatefulWidget {
  @override
  _ReviewWithdrawalRequestsState createState() =>
      _ReviewWithdrawalRequestsState();
}

class _ReviewWithdrawalRequestsState extends State<ReviewWithdrawalRequests> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Deposit> _deposits = [];
  bool _isLoading = true;
  bool _isInit = true;

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
      await Provider.of<Groups>(context, listen: false).fetchDeposits();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getDeposits(context);
          });
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _deposits = Provider.of<Groups>(context, listen: false).getDeposits;
    _getDeposits(context).then((_) {
      _deposits = Provider.of<Groups>(context, listen: false).getDeposits;
      setState(() {
        _isLoading = false;
      });
    });

    _isInit = false;
    return true;
  }

  @override
  void didChangeDependencies() {
    //if (_isInit) WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
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

  @override
  Widget build(BuildContext context) {
    final List<WithdrawalRequest> list = [
      WithdrawalRequest(
          1, DateTime.now(), "Expense Payment", "Audit Fees", 12000),
      WithdrawalRequest(
          1, DateTime.now(), "Contribution Refund", "Peter Kimutai", 16000),
      WithdrawalRequest(
          1, DateTime.now(), "Merry Go Round", "Geoffrey Githaiga", 1000),
      WithdrawalRequest(
          1, DateTime.now(), "Loan Disbursement", "Aggrey Koros", 22000),
      WithdrawalRequest(
          1, DateTime.now(), "Expense Payment", "Audit Fees", 4210),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  screenActionButton(
                    icon: LineAwesomeIcons.arrow_left,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    textColor: primaryColor,
                    action: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 20.0),
                  heading2(
                      color: primaryColor, text: "Review Withdrawal Requests"),
                ],
              ),
            ],
          ),
          elevation: 1,
          backgroundColor: Theme.of(context).backgroundColor,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: primaryGradient(context),
          width: double.infinity,
          height: double.infinity,
          child: ListView.builder(
            itemBuilder: (context, index) {
              WithdrawalRequest request = list[index];
              return WithdrawalRequestCard(request: request);
            },
            itemCount: list.length,
          ),
        ));
  }
}

class WithdrawalRequestCard extends StatelessWidget {
  const WithdrawalRequestCard({
    Key key,
    @required this.request,
  }) : super(key: key);

  final WithdrawalRequest request;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Card(
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderOnForeground: false,
        child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: cardDecoration(
                gradient: plainCardGradient(context), context: context),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: customTitle(
                        text: request.purpose,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        color: Theme.of(context).textSelectionHandleColor,
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
                          text: "Ksh ",
                          fontSize: 16.0,
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        customTitle(
                          text: currencyFormat.format(request.amount),
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                                text: "Particulars",
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.start),
                            customTitle(
                              text: request.particulars,
                              color: Theme.of(context).textSelectionHandleColor,
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
                                text: "Requested On",
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.end),
                            customTitle(
                              text:
                                  defaultDateFormat.format(request.requestDate),
                              color: Theme.of(context).textSelectionHandleColor,
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "",
                    ),
                    plainButtonWithArrow(
                        text: "Respond",
                        size: 16.0,
                        spacing: 2.0,
                        color: Theme.of(context)
                            .textSelectionHandleColor
                            .withOpacity(.8),
                        action: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ReviewWithdrawal(
                                      withdrawalRequest: request,
                                    )))),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
