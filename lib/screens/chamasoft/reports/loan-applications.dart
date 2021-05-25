import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-application.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class LoanApplications extends StatefulWidget {
  @override
  _LoanApplicationsState createState() => _LoanApplicationsState();
}

class _LoanApplicationsState extends State<LoanApplications> {
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
    List<LoanApplication> list = [
      LoanApplication(
          loanApplicationId: 1,
          requestDate: DateTime.now(),
          amount: 2000,
          loanName: 'Emergency Loan',
          status: 1),
      LoanApplication(
          loanApplicationId: 2,
          requestDate: DateTime.now(),
          amount: 6000,
          loanName: 'Chama Loan',
          status: 2),
      LoanApplication(
          loanApplicationId: 3,
          requestDate: DateTime.now(),
          amount: 15000,
          loanName: 'Education Loan',
          status: 3),
      LoanApplication(
          loanApplicationId: 4,
          requestDate: DateTime.now(),
          amount: 6000,
          loanName: 'Shamba Loan',
          status: 1),
      LoanApplication(
          loanApplicationId: 5,
          requestDate: DateTime.now(),
          amount: 8000,
          loanName: 'Vacation Loan',
          status: 1),
    ];

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
        child: ListView.builder(
            itemBuilder: (context, index) {
              LoanApplication application = list[index];
              return MyLoansCard(
                application: application,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ReviewLoan(loanApplication: application),
                      settings:
                          RouteSettings(arguments: VIEW_APPLICATION_STATUS),
                    ),
                  );
                },
              );
            },
            itemCount: list.length),
      ),
    );
  }
}

class MyLoansCard extends StatelessWidget {
  const MyLoansCard({Key key, @required this.application, this.onPressed})
      : super(key: key);

  final LoanApplication application;
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
                          application.loanName,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
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
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.start),
                            subtitle1(
                                text: defaultDateFormat
                                    .format(application.requestDate),
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
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
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              currencyFormat.format(application.amount),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 20.0,
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
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
    if (application.status == 2) {
      return statusChip(
          text: "APPROVED",
          textColor: Colors.lightBlueAccent,
          backgroundColor: Colors.lightBlueAccent.withOpacity(.2));
    } else if (application.status == 3) {
      return statusChip(
          text: "REJECTED",
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
