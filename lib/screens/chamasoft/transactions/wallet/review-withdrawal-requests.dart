import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/deposit.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal-request.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ReviewWithdrawalRequests extends StatefulWidget {
  @override
  _ReviewWithdrawalRequestsState createState() => _ReviewWithdrawalRequestsState();
}

class _ReviewWithdrawalRequestsState extends State<ReviewWithdrawalRequests> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<WithdrawalRequest> _withdrawalRequests = [];
  bool _isLoading = true;
  bool _isInit = true;
  List<int> statusApproval = [1, 2, 3];
  List<int> statusDisbursement = [14, 15, 16];

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
      await Provider.of<Groups>(context, listen: false).fetchWithdrawalRequests(statusApproval);
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

    _withdrawalRequests = Provider.of<Groups>(context, listen: false).getWithdrawalRequestList;
    _getWithdrawalRequests(context).then((_) {
      _withdrawalRequests = Provider.of<Groups>(context, listen: false).getWithdrawalRequestList;
      setState(() {
        _isLoading = false;
      });
    });

    _isInit = false;
    return true;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
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
    return Scaffold(
        key: _scaffoldKey,
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
                  heading2(color: primaryColor, text: "Review Withdrawal Requests"),
                ],
              ),
            ],
          ),
          elevation: 1,
          backgroundColor: Theme.of(context).backgroundColor,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
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
                  child: _withdrawalRequests.length > 0
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            WithdrawalRequest request = _withdrawalRequests[index];
                            return WithdrawalRequestCard(request: request);
                          },
                          itemCount: _withdrawalRequests.length,
                        )
                      : emptyList(
                          color: Colors.blue[400],
                          iconData: LineAwesomeIcons.angle_double_down,
                          text: "There are no withdrawal requests to display"),
                ),
              ],
            ),
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
    final groupObject = Provider.of<Groups>(context, listen: false).getCurrentGroup();

    IconData iconData = LineAwesomeIcons.info_circle;
    Color color = Colors.blueGrey;
    if (request.statusCode == 3) {
      //failed
      iconData = LineAwesomeIcons.close;
      color = Colors.red;
    } else if (request.statusCode == 5) {
      iconData = LineAwesomeIcons.check;
      color = Colors.green;
    } else if (request.statusCode == 6) {
      iconData = LineAwesomeIcons.close;
      color = Colors.red;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderOnForeground: false,
        child: Container(
            padding: EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
            decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
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
                          text: "${groupObject.groupCurrency} ",
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
                                text: "Requested On",
                                color: Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.start),
                            customTitleWithWrap(
                              text: request.requestDate,
                              fontSize: 12.0,
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
                                text: "Initiate By",
                                color: Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.end),
                            customTitleWithWrap(
                              text: request.name,
                              fontSize: 12.0,
                              color: Theme.of(context).textSelectionHandleColor,
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
                    text: "Recipient", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                customTitleWithWrap(
                  text: request.recipient,
                  fontSize: 12.0,
                  color: Theme.of(context).textSelectionHandleColor,
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
                          text: request.statusCode == 5 ? "Disbursed To" : "Disbursement Status",
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.start),
                      customTitleWithWrap(
                        text: request.description,
                        fontSize: 12.0,
                        color: Theme.of(context).textSelectionHandleColor,
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
                              color: Theme.of(context).textSelectionHandleColor,
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
                        text: request.isOwner == 1 ? "VIEW" : request.hasResponded == 0 ? "RESPOND" : "VIEW",
                        //TODO: Admin Restrictions
                        size: 16.0,
                        spacing: 2.0,
                        color: Theme.of(context).textSelectionHandleColor.withOpacity(.8),
                        action: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => ReviewWithdrawal(
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
