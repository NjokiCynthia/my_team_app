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
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _responseSubmitted = false;
  bool _requestCancelled = false;
  Color color;
  Map<String, String> _formData = {};
  TextEditingController _controller = new TextEditingController();

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
      if (_withdrawalDetails.approvalStatus.contains("Approved")) {
        color = Colors.green;
      } else if (_withdrawalDetails.approvalStatus.contains("Declined")) {
        color = Colors.red;
        _requestCancelled = true;
      }
      setState(() {
        _isLoading = false;
      });
    });

    _isInit = false;
    return true;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
      color = Theme.of(context).textSelectionHandleColor;
    }
    super.didChangeDependencies();
  }

  Future<void> submit() async {
    setState(() {
      _isLoading = true;
    });

    _formData["id"] = widget.withdrawalRequest.requestId.toString();
    try {
      await Provider.of<Groups>(context, listen: false).respondToWithdrawalRequest(_formData);
      _responseSubmitted = true;
      _fetchData();
    } on CustomException catch (error) {
      setState(() {
        _isLoading = false;
      });
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            submit();
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<void> cancelRequest() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, String> formData = {};
    formData["id"] = widget.withdrawalRequest.requestId.toString();
    formData["reason"] = _controller.text;

    try {
      await Provider.of<Groups>(context, listen: false).cancelWithdrawalRequest(formData);
      _responseSubmitted = true;
      _requestCancelled = true;
      _fetchData();
    } on CustomException catch (error) {
      setState(() {
        _isLoading = false;
      });
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            cancelRequest();
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  void approvalDialog(String currency) {
    String message =
        "Are you sure you want to approve ${widget.withdrawalRequest.withdrawalFor} withdrawal request of  $currency ${currencyFormat.format(widget.withdrawalRequest.amount)} made by ${widget.withdrawalRequest.name}";
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: customTitleWithWrap(text: message, textAlign: TextAlign.start, maxLines: null),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              actions: <Widget>[
                negativeActionDialogButton(
                    text: "Cancel",
                    color: Theme.of(context).textSelectionHandleColor,
                    action: () => Navigator.of(context).pop()),
                positiveActionDialogButton(
                    text: "Yes",
                    color: primaryColor,
                    action: () {
                      _formData["approve"] = "1";
                      Navigator.of(context).pop();
                      submit();
                    })
              ],
            ));
  }

  void rejectDialog(int flag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
            text: "Reason for ${flag == 1 ? "Rejecting" : "Cancelling"}",
            textAlign: TextAlign.start,
            color: Theme.of(context).textSelectionHandleColor,
          ),
          content: TextFormField(
            controller: _controller,
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
            negativeActionDialogButton(
                text: "Cancel",
                color: Theme.of(context).textSelectionHandleColor,
                action: () {
                  Navigator.of(context).pop();
                }),
            positiveActionDialogButton(
                text: "Proceed",
                color: primaryColor,
                action: () {
                  if (flag == 1) {
                    _formData["decline"] = "1";
                    _formData["reason"] = _controller.text;
                    Navigator.of(context).pop();
                    submit();
                  } else {
                    Navigator.of(context).pop();
                    cancelRequest();
                  }
                })
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
          action: () => Navigator.of(context).pop(_responseSubmitted),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.close,
          title: "Review Withdrawal Request",
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
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
                      color: color,
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
                            _withdrawalDetails.isOwner != 1 &&
                            _isLoading != true,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FlatButton(
                              color: Colors.blueAccent.withOpacity(.2),
                              onPressed: () => approvalDialog(groupObject.groupCurrency),
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
                                rejectDialog(1);
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
                            _withdrawalDetails.isOwner == 1 &&
                            widget.withdrawalRequest.statusCode == 1 &&
                            !_requestCancelled &&
                            _isLoading != true,
                        child: Center(
                          child: FlatButton(
                            color: Colors.redAccent.withOpacity(.2),
                            onPressed: () {
                              rejectDialog(2);
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                customTitleWithWrap(
                  text: status.name,
                  textAlign: TextAlign.start,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
//              subtitle2(
//                text: "$userRole",
//                color: Theme.of(context).textSelectionHandleColor.withOpacity(0.5),
//              ),
              ],
            ),
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
