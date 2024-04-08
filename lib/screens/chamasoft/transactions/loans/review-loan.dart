import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-application.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-signatory.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/screens/chamasoft/models/loan_requests.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ReviewLoan extends StatefulWidget {
  final LoanApplications loanApplication;

  ReviewLoan({this.loanApplication});

  @override
  State<StatefulWidget> createState() {
    return ReviewLoanState();
  }
}

class ReviewLoanState extends State<ReviewLoan> {
  double _appBarElevation = 0;
  var numberFormat = new NumberFormat("#,###.00");
  var dateFormat = new DateFormat("d MMMM y");
  String rejectReason = "";
  TextEditingController controller;

  bool _isLoading = false;
  Future<void> fetchApprovalRequests(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchApprovalRequests(id: widget.loanApplication.id);
      setState(() {});
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch invoices'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchApprovalRequests(context);
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    fetchApprovalRequests(context);
    super.initState();
  }

  Map<String, String> _formData = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> submit() async {
    setState(() {
      _isLoading = true;
    });

    _formData["loan_application_id"] = widget.loanApplication.id.toString();

    try {
      await Provider.of<Groups>(context, listen: false)
          .respondToLoanRequest(_formData);
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

  Future<void> reject() async {
    setState(() {
      _isLoading = true;
    });

    _formData["loan_application_id"] = widget.loanApplication.id.toString();
    _formData["action"] = "0";

    try {
      await Provider.of<Groups>(context, listen: false)
          .cancelLoanRequest(_formData);
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

  void approvalDialog(String currency) {
    String message =
        "Are you sure you want to approve ${widget.loanApplication.applicationName} loan of $currency ${currencyFormat.format(double.tryParse(widget.loanApplication.loanAmount))}";
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: customTitleWithWrap(
                  text: message, textAlign: TextAlign.start, maxLines: null),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              actions: <Widget>[
                negativeActionDialogButton(
                    text: "Cancel",
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                    action: () => Navigator.of(context).pop()),
                positiveActionDialogButton(
                    text: "Yes",
                    color: primaryColor,
                    action: () {
                      _formData["action"] = "1";
                      // Navigator.of(context).pop();
                      submit();
                      fetchApprovalRequests(context);
                    })
              ],
            ));
  }

  void _rejectActionPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Reason for Rejecting"),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.text,
            onChanged: (reason) {
              rejectReason = reason;
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 2.0,
              )),
              hintText: 'Reason for Rejecting the Loan Application',
              labelText: "Enter Reason",
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text(
                "Save",
                style: new TextStyle(color: primaryColor),
              ),
              onPressed: () async {
                await reject();
                fetchApprovalRequests(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    int flag = ModalRoute.of(context).settings.arguments;
    String appbarTitle = "Review Loan";
    if (flag == VIEW_APPLICATION_STATUS) {
      appbarTitle = "Loan Application Status";
    }

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.times,
        title: appbarTitle,
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Flex(
                  direction:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? Axis.vertical
                          : Axis.horizontal,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      width: double.infinity,
                      color: (themeChangeProvider.darkTheme)
                          ? Colors.blueGrey[800]
                          : Color(0xffededfe),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // heading2(
                                    //   text: "${widget.loanApplication.active}",
                                    //   color: Theme.of(context)
                                    //       .textSelectionTheme
                                    //       .selectionHandleColor,
                                    //   textAlign: TextAlign.start,
                                    // ),
                                    Visibility(
                                        visible: flag == REVIEW_LOAN,
                                        child: customTitle(
                                          text:
                                              "Applied By ${widget.loanApplication.applicantName}",
                                          fontSize: 12.0,
                                          color: primaryColor,
                                          textAlign: TextAlign.start,
                                        )),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  customTitle(
                                    text: "Ksh ",
                                    fontSize: 18.0,
                                    color: Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  heading2(
                                    text:
                                        "${numberFormat.format(double.tryParse(widget.loanApplication.loanAmount))}",
                                    color: Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: <Widget>[
                          //     subtitle1(
                          //       text: "Interest Rate: ",
                          //       color: Theme.of(context)
                          //           .textSelectionTheme
                          //           .selectionHandleColor,
                          //     ),
                          //     customTitle(
                          //       textAlign: TextAlign.start,
                          //       text: "12%",
                          //       color: Theme.of(context)
                          //           .textSelectionTheme
                          //           .selectionHandleColor,
                          //       fontWeight: FontWeight.w600,
                          //     ),
                          //   ],
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              subtitle1(
                                text: "Repayment Period: ",
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              ),
                              customTitle(
                                textAlign: TextAlign.start,
                                text:
                                    '${widget.loanApplication.repaymentPeriod} months',
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              subtitle1(
                                text: "Applied On: ",
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              ),
                              customTitle(
                                textAlign: TextAlign.start,
                                text: widget.loanApplication.createdOn,
                                // "${dateFormat.format(widget.loanApplication.create)}",
                                //'3 April 2024',
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            heading2(
                                text: "Signatories",
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                textAlign: TextAlign.start),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: _isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Consumer<Groups>(
                                      builder: (context, groupData, child) {
                                      return groupData
                                                  .loanApprovalrequests.length >
                                              0
                                          ? ListView.separated(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(),
                                              itemCount: groupData
                                                  .loanApprovalrequests.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                LoanApprovalRequests
                                                    approvalRequests = groupData
                                                            .loanApprovalrequests[
                                                        index];
//approvalRequests
                                                // .signatoryName,
                                                return Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          subtitle1(
                                                            text: approvalRequests
                                                                .signatoryName,
                                                            color: Theme.of(
                                                                    context)
                                                                .textSelectionTheme
                                                                .selectionHandleColor,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      statusChip(
                                                          text: approvalRequests
                                                                      .isDeclined ==
                                                                  "1"
                                                              ? 'Declined'
                                                              : approvalRequests
                                                                          .isApproved ==
                                                                      "1"
                                                                  ? 'Approved'
                                                                  : 'Pending',
                                                          textColor: approvalRequests
                                                                      .isApproved ==
                                                                  '1'
                                                              ? Colors.blue
                                                              : approvalRequests
                                                                          .isDeclined ==
                                                                      "1"
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .hintColor
                                                                  .withOpacity(
                                                                      0.1))
                                                    ],
                                                  ),
                                                );
                                              })
                                          : betterEmptyList(
                                              message: 'No loan approval');
                                    }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: flag == REVIEW_LOAN,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent.withOpacity(.2),
                      ),
                      onPressed: () {
                        approvalDialog(groupObject.groupCurrency);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'APPROVE',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent.withOpacity(.2),
                      ),
                      onPressed: () {
                        _rejectActionPrompt();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'REJECT',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: flag == VIEW_APPLICATION_STATUS,
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(.2),
                    ),
                    onPressed: () {
                      //_rejectActionPrompt();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'CANCEL APPLICATION',
                        style:
                            TextStyle(color: Colors.red, fontFamily: 'SegoeUI'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
