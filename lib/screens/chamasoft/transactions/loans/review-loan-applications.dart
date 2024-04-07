import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-application.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ReviewLoanApplications extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReviewLoanApplicationsState();
  }
}

class ReviewLoanApplicationsState extends State<ReviewLoanApplications> {
  double _appBarElevation = 0;
  var numberFormat = new NumberFormat("#,###.00");
  var dateFormat = new DateFormat("d MMMM y");

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

  Auth user;
  @override
  void initState() {
    fetchLoanApplications(context);
    user = Provider.of<Auth>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Review Loan Applications",
      ),
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
                // Filter loan applications based on created_by field
                List<LoanApplications> filteredApplications = groupData
                    .loanApplications
                    .where((application) => application.createdBy != user.id)
                    .toList();

                return filteredApplications.length > 0
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          LoanApplications application =
                              filteredApplications[index];
                          return GroupApplicationCard(
                            application: application,
                            onPressed: () {
                              print('This is pressed');
                            },
                          );
                        },
                        itemCount: filteredApplications.length,
                      )
                    : betterEmptyList(
                        message:
                            "Sorry, you have not added any loan applications");
              }),
      ),
    );
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
              settings: RouteSettings(arguments: REVIEW_LOAN),
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
                              text: application.repaymentPeriod ?? '',
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.start,
                            ),
                            subtitle2(
                                text: "Applied By ${application.createdBy}",
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
                                text: '3 April 2024',
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
