import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-signatory.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal-request.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/custom-scroll-behaviour.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ReviewWithdrawal extends StatefulWidget {
  final WithdrawalRequest withdrawalRequest;

  ReviewWithdrawal({this.withdrawalRequest});

  @override
  _ReviewWithdrawalState createState() => _ReviewWithdrawalState();
}

class _ReviewWithdrawalState extends State<ReviewWithdrawal> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  WithdrawalRequestDetails _withdrawalDetails;
  bool _isLoading = true;
  bool _isInit = true;

  Future<void> _getWithdrawalRequestDetails(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchWithdrawalRequestDetails(widget.withdrawalRequest.requestId);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getWithdrawalRequestDetails(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _getWithdrawalRequestDetails(context).then((_) {
      _withdrawalDetails = Provider.of<Groups>(context, listen: false).getWithdrawalRequestDetails;
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

  void rejectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
            text: "Reason for Rejecting",
            textAlign: TextAlign.start,
            color: Theme.of(context).textSelectionHandleColor,
          ),
          content: TextFormField(
            //controller: controller,
            keyboardType: TextInputType.text,
            style: inputTextStyle(),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
              )),
              // hintText: 'Phone Number or Email Address',
              labelText: "Enter Reason",
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(fontFamily: 'SegoeUI', color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Proceed",
                style: new TextStyle(
                  color: primaryColor,
                  fontFamily: 'SegoeUI',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupObject = Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
        key: _scaffoldKey,
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.close,
          title: "Review Withdrawal Request",
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          color: Theme.of(context).backgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                width: double.infinity,
                color: (themeChangeProvider.darkTheme) ? Colors.blueGrey[800] : Color(0xffededfe),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: heading2(
                            text: "${widget.withdrawalRequest.withdrawalFor}",
                            color: Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            customTitle(
                              text: "${groupObject.groupCurrency} ",
                              fontSize: 18.0,
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w400,
                            ),
                            heading2(
                              text: "${currencyFormat.format(widget.withdrawalRequest.amount)}",
                              color: Theme.of(context).textSelectionHandleColor,
                              textAlign: TextAlign.end,
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
                                  text: widget.withdrawalRequest.requestDate,
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
                                    text: "Initiated By",
                                    color: Theme.of(context).textSelectionHandleColor,
                                    textAlign: TextAlign.end),
                                customTitleWithWrap(
                                  text: widget.withdrawalRequest.name,
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
                        text: "Recipient",
                        color: Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.start),
                    customTitleWithWrap(
                      text: widget.withdrawalRequest.recipient,
                      fontSize: 12.0,
                      color: Theme.of(context).textSelectionHandleColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    subtitle2(
                        text: "Description",
                        color: Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.start),
                    customTitleWithWrap(
                        textAlign: TextAlign.start,
                        fontSize: 12.0,
                        text: _withdrawalDetails != null ? _withdrawalDetails.description : "--",
                        color: Theme.of(context).textSelectionHandleColor,
                        maxLines: null),
                    SizedBox(
                      height: 5,
                    ),
                    subtitle2(
                        text: "Status", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
                    customTitleWithWrap(
                      text: _withdrawalDetails != null ? _withdrawalDetails.approvalStatus : "--",
                      fontSize: 12.0,
                      color: Theme.of(context).textSelectionHandleColor,
                      textAlign: TextAlign.start,
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
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: _withdrawalDetails != null,
                        child: heading2(
                            text: "Signatories",
                            color: Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.start),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: CustomScrollBehavior(),
                          child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder: (BuildContext context, int index) => const Divider(),
                              itemCount: _withdrawalDetails != null ? _withdrawalDetails.signatories.length : 0,
                              itemBuilder: (context, int index) {
                                if (_withdrawalDetails != null) {
                                  StatusModel statusModel = _withdrawalDetails.signatories[index];
                                  return WalletSignatoryCard(
                                    status: statusModel,
                                  );
                                } else
                                  return Container();
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: _withdrawalDetails != null &&
                            _withdrawalDetails.hasResponded != 1 &&
                            _withdrawalDetails.isOwner != 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FlatButton(
                              color: Colors.blueAccent.withOpacity(.2),
                              onPressed: () {},
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'APPROVE',
                                  style: TextStyle(
                                      color: primaryColor, fontFamily: 'SegoeUI', fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            FlatButton(
                              color: Colors.redAccent.withOpacity(.2),
                              onPressed: () {
                                rejectDialog();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'REJECT',
                                  style:
                                      TextStyle(color: Colors.red, fontFamily: 'SegoeUI', fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _withdrawalDetails != null &&
                            _withdrawalDetails.hasResponded != 1 &&
                            _withdrawalDetails.isOwner == 1,
                        child: Center(
                          child: FlatButton(
                            color: Colors.redAccent.withOpacity(.2),
                            onPressed: () {
                              //rejectDialog();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'CANCEL WITHDRAWAL REQUEST',
                                style: TextStyle(color: Colors.red, fontFamily: 'SegoeUI', fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class WalletSignatoryCard extends StatelessWidget {
  final StatusModel status;

  const WalletSignatoryCard({this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              subtitle1(
                text: status.name,
                color: Theme.of(context).textSelectionHandleColor,
              ),
//              subtitle2(
//                text: "$userRole",
//                color: Theme.of(context).textSelectionHandleColor.withOpacity(0.5),
//              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          statusChip(
              text: status.status,
              textColor: status.status == "APPROVED"
                  ? primaryColor
                  : status.status == "PENDING" ? Theme.of(context).textSelectionHandleColor : Colors.red,
              backgroundColor: Theme.of(context).hintColor.withOpacity(0.1)),
        ],
      ),
    );
  }
}
