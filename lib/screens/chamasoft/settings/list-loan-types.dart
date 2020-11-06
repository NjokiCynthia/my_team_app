import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/loan-type/create-loan-type.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ListLoanTypes extends StatefulWidget {
  @override
  _ListLoanTypesState createState() => _ListLoanTypesState();
}

class _ListLoanTypesState extends State<ListLoanTypes> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _getLoanSettings(BuildContext context, String contributionId) async {
    try {
      final response = await Provider.of<Groups>(context, listen: false).getLoanDetails(contributionId);
      Navigator.pop(context);
      Navigator.pop(context); // pop bottom sheet
      final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateLoanType(isEditMode: true, loanDetails: response["data"]),
      ));

      print(result);
      if (result != null) {
        int status = int.tryParse(result.toString()) ?? 0;
        if (status == 1) {
          _refreshIndicatorKey.currentState.show();
          _fetchLoanTypes(context);
        }
      }
    } on CustomException catch (error) {
      Navigator.pop(context);
      Navigator.pop(context); // pop bottom sheet
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getLoanSettings(context, contributionId);
          });
    }
  }

  Future<void> _fetchLoanTypes(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchLoanTypes();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchLoanTypes(context);
          });
    }
  }

  showConfirmationDialog(BuildContext context, LoanType loanType, SettingActions settingAction) {
    String title = "";
    if (settingAction == SettingActions.actionHide) {
      title = "This will hide ${loanType.name}";
    } else if (settingAction == SettingActions.actionUnHide) {
      title = "This will un-hide ${loanType.name}";
    } else if (settingAction == SettingActions.actionDelete) {
      title = "This will delete ${loanType.name}";
    }

    twoButtonAlertDialog(
        context: context,
        message: "Are you sure you want to proceed?",
        yesText: "Yes",
        title: title,
        action: () async {
          Navigator.of(context).pop();
          updateLoanType(context, loanType, settingAction);
        });
  }

  Future<void> updateLoanType(BuildContext context, LoanType loanType, SettingActions settingAction) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).updateLoanType(id: loanType.id, action: settingAction);

      Navigator.pop(context);
      String message = "${loanType.name} has been hidden";
      if (settingAction == SettingActions.actionUnHide) {
        message = "${loanType.name} is now active";
      } else if (settingAction == SettingActions.actionDelete) {
        message = "${loanType.name} has been deleted";
      }

      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        message,
      )));
      _refreshIndicatorKey.currentState.show();
    } on CustomException catch (error) {
      Navigator.pop(context);
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            updateLoanType(context, loanType, settingAction);
          });
    }
  }

  void _showActions(BuildContext context, LoanType loanType) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Material(
                  color: Theme.of(context).backgroundColor,
                  child: InkWell(
                    splashColor: Colors.blueGrey.withOpacity(0.2),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                      await _getLoanSettings(context, loanType.id);
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Colors.blueGrey,
                      ),
                      title: customTitle(
                          text: "Edit Loan Type",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
                    ),
                  ),
                ),
                Material(
                  color: Theme.of(context).backgroundColor,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      showConfirmationDialog(context, loanType,
                          loanType.isHidden ? SettingActions.actionUnHide : SettingActions.actionHide);
                    },
                    splashColor: Colors.blueGrey.withOpacity(0.2),
                    child: ListTile(
                      leading: Icon(
                        loanType.isHidden ? Feather.eye : Feather.eye_off,
                        color: Colors.blueGrey,
                      ),
                      title: customTitle(
                          text: loanType.isHidden ? "UnHide" : "Hide",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
                    ),
                  ),
                ),
                Material(
                  color: Theme.of(context).backgroundColor,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      showConfirmationDialog(context, loanType, SettingActions.actionDelete);
                    },
                    splashColor: Colors.blueGrey.withOpacity(0.2),
                    child: ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: Colors.blueGrey,
                      ),
                      title: customTitle(
                          text: "Delete",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Loan Types",
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        onPressed: () async {
          final result = Navigator.of(_scaffoldKey.currentContext).push(MaterialPageRoute(
            builder: (_) => CreateLoanType(),
          ));
          if (result != null) {
            int status = int.tryParse(result.toString()) ?? 0;
            if (status == 1) {
              _refreshIndicatorKey.currentState.show();
              _fetchLoanTypes(_scaffoldKey.currentContext);
            }
          }
        },
      ),
      //backgroundColor: Theme.of(context).backgroundColor,
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (BuildContext context) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () => _fetchLoanTypes(_scaffoldKey.currentContext),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: primaryGradient(context),
                child: Consumer<Groups>(builder: (context, groupData, child) {
                  return groupData.loanTypes.length > 0
                      ? ListView.separated(
                          padding: EdgeInsets.only(bottom: 50.0),
                          itemCount: groupData.loanTypes.length,
                          itemBuilder: (context, index) {
                            LoanType loanType = groupData.loanTypes[index];
                            return ListTile(
                              contentPadding: EdgeInsets.all(12.0),
                              dense: true,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.label,
                                          color: Colors.blueGrey,
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              customTitleWithWrap(
                                                text: '${loanType.name}',
                                                textAlign: TextAlign.start,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16.0,
                                                color: Theme.of(context).textSelectionHandleColor,
                                              ),
                                              richTextWithWrap(
                                                title: 'Loan Amount: ',
                                                message: loanType.loanAmount,
                                                color: Theme.of(context).textSelectionHandleColor,
                                                fontSize: 12.0,
                                                textAlign: TextAlign.start,
                                              ),
                                              richTextWithWrap(
                                                title: 'Repayment Period: ',
                                                message: loanType.repaymentPeriod,
                                                color: Theme.of(context).textSelectionHandleColor,
                                                fontSize: 12.0,
                                                textAlign: TextAlign.start,
                                              ),
                                              richTextWithWrap(
                                                title: 'Interest Rate: ',
                                                message: loanType.interestRate,
                                                color: Theme.of(context).textSelectionHandleColor,
                                                fontSize: 12.0,
                                                textAlign: TextAlign.start,
                                              ),
                                              richTextWithWrap(
                                                title: 'Loan Processing: ',
                                                message: loanType.loanProcessing,
                                                color: Theme.of(context).textSelectionHandleColor,
                                                fontSize: 12.0,
                                                textAlign: TextAlign.start,
                                              ),
                                              richTextWithWrap(
                                                title: 'Guarantors: ',
                                                message: loanType.guarantors,
                                                color: Theme.of(context).textSelectionHandleColor,
                                                fontSize: 12.0,
                                                textAlign: TextAlign.start,
                                              ),
                                              richTextWithWrap(
                                                title: 'Late Payment Fines: ',
                                                message: loanType.latePaymentFines,
                                                color: Theme.of(context).textSelectionHandleColor,
                                                fontSize: 12.0,
                                                textAlign: TextAlign.start,
                                              ),
                                              richTextWithWrap(
                                                title: 'Outstanding Payment Fines: ',
                                                message: loanType.outstandingPaymentFines,
                                                color: Theme.of(context).textSelectionHandleColor,
                                                fontSize: 12.0,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: circleIconButton(
                                      icon: Icons.edit,
                                      backgroundColor: primaryColor.withOpacity(.3),
                                      color: primaryColor,
                                      iconSize: 16.0,
                                      padding: 0.0,
                                      onPressed: () => _showActions(context, loanType),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Theme.of(context).dividerColor,
                              height: 6.0,
                            );
                          },
                        )
                      : betterEmptyList(message: "Sorry, you have not added any loan types");
                })),
          );
        },
      ),
    );
  }
}