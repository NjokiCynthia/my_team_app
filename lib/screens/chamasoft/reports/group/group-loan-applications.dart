import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-application.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class GroupLoanApplications extends StatefulWidget {
  @override
  _GroupLoanApplicationsState createState() => _GroupLoanApplicationsState();
}

class _GroupLoanApplicationsState extends State<GroupLoanApplications> {
  double _appBarElevation = 0;
  ScrollController _scrollController = ScrollController();

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  bool _isLoading = false;
  Future<void> fetchLoanApplications(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchGroupLoanApplications();
      setState(() {});
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch invoices'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchLoanApplications(context);
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
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchLoanApplications(context);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryPageAppbar(
            context: context,
            title: "Loan Applications",
            action: () => Navigator.of(context).pop(),
            elevation: _appBarElevation,
            leadingIcon: LineAwesomeIcons.arrow_left),
        backgroundColor: Colors.transparent,
        body: Container(
            decoration: primaryGradient(context),
            width: double.infinity,
            height: double.infinity,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Groups>(builder: (context, groupData, child) {
                    return groupData.loanApplications.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              //LoanApplications application = _loanApplications[index];
                              LoanApplications applications =
                                  groupData.loanApplications[index];
                              return GroupApplicationCard(
                                application: applications,
                                onPressed: () {
                                  print('This is pressed');
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (BuildContext context) =>
                                  //         ReviewLoan(
                                  //             loanApplication: applications),
                                  //     settings: RouteSettings(
                                  //         arguments: VIEW_APPLICATION_STATUS),
                                  //   ),
                                  // );
                                },
                              );
                            },
                            itemCount: groupData.loanApplications.length,
                          )
                        : betterEmptyList(
                            message:
                                "Sorry, you have not added any loan applications");
                  })));
  }
}

class GroupApplicationCard extends StatelessWidget {
  const GroupApplicationCard(
      {Key key, @required this.application, this.onPressed})
      : super(key: key);

  final LoanApplications application;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: InkWell(
        onTap: () {
          print('This is pressed here');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ReviewLoan(loanApplication: application),
              settings: RouteSettings(arguments: VIEW_APPLICATION_STATUS),
            ),
          );
        },
        child: Card(
          elevation: 0.0,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            customTitle(
                              text: application.applicationName ?? '',
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.start,
                            ),
                            subtitle2(
                                text:
                                    "Applied By ${application.applicationName}",
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                textAlign: TextAlign.start),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      getStatus()
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            subtitle2(
                                text: "Applied On",
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                textAlign: TextAlign.start),
                            subtitle1(

                                // final String nextInstallmentRepaymentDateFormatted =
                                //     formatter.format(nextInstallmentRepaymentDate);
                                text: '3 April 2024',
                                // formatter.format(
                                //     DateTime.parse(application.createdOn)),
                                // defaultDateFormat.format(
                                //     DateTime.parse(application.createdOn)),
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                textAlign: TextAlign.start)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            subtitle1(
                              text: "${groupObject.groupCurrency} ",
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                            ),
                            customTitle(
                              text: currencyFormat.format(
                                  double.tryParse(application.loanAmount)),
                              textAlign: TextAlign.end,
                              fontSize: 20.0,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
      ),
    );
  }

// {
//     "0" : "Pending Approval",
//     "1" : "Approved",
//     "2" : "Pending Guarantors Approval",
//     "3" : "Pending Signatories Approval",
//     "4" : "Pending Disbursement",
//     "5" : "Disbursing",
//     "6" : "Disbursed",
//     "7" : "Disbursement Failed",
//     "8" : "Declined"
// }
  Widget getStatus() {
    if (application.status == 0) {
      return statusChip(
          text: "PENDING",
          textColor: Colors.blueGrey,
          backgroundColor: Colors.blueGrey.withOpacity(.2));
    } else if (application.status == 1) {
      return statusChip(
          text: "APPROVED",
          textColor: Colors.lightBlueAccent,
          backgroundColor: Colors.lightBlueAccent.withOpacity(.2));
    } else if (application.status == 6) {
      return statusChip(
          text: "DISBURSED",
          textColor: Colors.lightBlueAccent,
          backgroundColor: Colors.lightBlueAccent.withOpacity(.2));
    } else if (application.status == 7) {
      return statusChip(
          text: "FAILED",
          textColor: Colors.red,
          backgroundColor: Colors.red.withOpacity(.2));
    } else if (application.status == 8) {
      return statusChip(
          text: "DECLINED",
          textColor: Colors.red,
          backgroundColor: Colors.red.withOpacity(.2));
    } else {
      return statusChip(
          text: "PENDING",
          textColor: Colors.blueGrey,
          backgroundColor: Colors.blueGrey.withOpacity(.2));
    }
  }
}
