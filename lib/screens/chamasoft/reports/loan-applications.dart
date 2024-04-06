import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-application.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ListLoanApplications extends StatefulWidget {
  @override
  _ListLoanApplicationsState createState() => _ListLoanApplicationsState();
}

class _ListLoanApplicationsState extends State<ListLoanApplications> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
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
    fetchLoanApplications(context);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  Group _currentGroup;

  Future<void> fetchLoanApplications(BuildContext context) async {
    _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchMemberLoanApplications(memberId: _currentGroup.memberId);
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryPageAppbar(
            context: context,
            title: "My Loan Applications",
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
                            LoanApplications applications =
                                groupData.loanApplications[index];

                            return MyLoansCard(
                              application: applications,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ReviewLoan(
                                            loanApplication: applications),
                                    settings: RouteSettings(
                                        arguments: VIEW_APPLICATION_STATUS),
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: groupData.loanApplications.length,
                        )
                      : betterEmptyList(
                          message:
                              "Sorry, you have not added any loan applications");
                }),
        ));
  }
}

class MyLoansCard extends StatelessWidget {
  const MyLoansCard({Key key, @required this.application, this.onPressed})
      : super(key: key);

  final LoanApplications application;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: InkWell(
        onTap: onPressed,
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
                        child: Text(
                          application.applicationName,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                                text: application.createdOn,
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
                            Text(
                              "${groupObject.groupCurrency} ",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              currencyFormat.format(
                                  double.tryParse(application.loanAmount)),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                fontWeight: FontWeight.w700,
                              ),
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
