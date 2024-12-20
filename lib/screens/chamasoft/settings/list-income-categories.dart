import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/create-income-category.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ListIncomeCategories extends StatefulWidget {
  @override
  _ListIncomeCategoriesState createState() => _ListIncomeCategoriesState();
}

class _ListIncomeCategoriesState extends State<ListIncomeCategories> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _fetchIncomeCategories(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchDetailedIncomeCategories();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchIncomeCategories(context);
          });
    }
  }

  Future<void> editIncomeCategory(BuildContext context,
      IncomeCategories incomeCategory, SettingActions settingAction) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).createIncomeCategory(
          name: incomeCategory.name,
          description: incomeCategory.description,
          id: incomeCategory.id,
          action: settingAction);

      Navigator.pop(context);
      String message = "${incomeCategory.name} has been hidden";
      if (settingAction == SettingActions.actionUnHide) {
        message = "${incomeCategory.name} is now active";
      } else if (settingAction == SettingActions.actionDelete) {
        message = "${incomeCategory.name} has been deleted";
      }

     
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            editIncomeCategory(context, incomeCategory, settingAction);
          });
    }
  }

  showConfirmationDialog(BuildContext context, IncomeCategories category,
      SettingActions settingAction) {
    String title = "";
    if (settingAction == SettingActions.actionHide) {
      title = "This will hide ${category.name}";
    } else if (settingAction == SettingActions.actionUnHide) {
      title = "This will un-hide ${category.name}";
    } else if (settingAction == SettingActions.actionDelete) {
      title = "This will delete ${category.name}";
    }

    twoButtonAlertDialog(
        context: context,
        message: "Are you sure you want to proceed?",
        yesText: "Yes",
        title: title,
        action: () async {
          Navigator.of(context).pop();
          editIncomeCategory(context, category, settingAction);
        });
  }

  void _showActions(BuildContext context, IncomeCategories incomeCategory) {
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
                      Navigator.pop(context);
                      final result =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateIncomeCategory(
                            isEdit: true, incomeCategory: incomeCategory),
                      ));

                      if (result != null) {
                        int status = int.tryParse(result.toString()) ?? 0;
                        if (status == 1) {
                          _refreshIndicatorKey.currentState.show();
//                          print("here22");
//                          _fetchIncomeCategories(context);
                        }
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Colors.blueGrey,
                      ),
                      title: customTitle(
                          text: "Edit",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                         
                          color: Theme.of(context).textSelectionTheme.selectionHandleColor),
                    ),
                  ),
                ),
                Material(
                  color: Theme.of(context).backgroundColor,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      showConfirmationDialog(
                          context,
                          incomeCategory,
                          incomeCategory.isHidden
                              ? SettingActions.actionUnHide
                              : SettingActions.actionHide);
                    },
                    splashColor: Colors.blueGrey.withOpacity(0.2),
                    child: ListTile(
                      leading: Icon(
                        incomeCategory.isHidden ? Feather.eye : Feather.eye_off,
                        color: Colors.blueGrey,
                      ),
                      title: customTitle(
                          text: incomeCategory.isHidden ? "UnHide" : "Hide",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                         
                          color: Theme.of(context).textSelectionTheme.selectionHandleColor),
                    ),
                  ),
                ),
                Material(
                  color: Theme.of(context).backgroundColor,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      showConfirmationDialog(
                          context, incomeCategory, SettingActions.actionDelete);
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
                         
                          color: Theme.of(context).textSelectionTheme.selectionHandleColor),
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
        title: "Income Categories",
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        onPressed: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateIncomeCategory(isEdit: false),
          ));

          if (result != null) {
            int status = int.tryParse(result.toString()) ?? 0;
            if (status == 1) {
              _refreshIndicatorKey.currentState.show();
//              print("here");
//              _fetchIncomeCategories(context);
            }
          }
        },
      ),
      //backgroundColor: Theme.of(context).backgroundColor,
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (BuildContext context) {
          return RefreshIndicator(
            backgroundColor: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Colors.white,
            key: _refreshIndicatorKey,
            onRefresh: () =>
                _fetchIncomeCategories(_scaffoldKey.currentContext),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: primaryGradient(context),
                child: Consumer<Groups>(builder: (context, groupData, child) {
                  return groupData.detailedIncomeCategories.length > 0
                      ? ListView.separated(
                          padding: EdgeInsets.only(bottom: 50.0, top: 10.0),
                          itemCount: groupData.detailedIncomeCategories.length,
                          itemBuilder: (context, index) {
                            IncomeCategories incomeCategory =
                                groupData.detailedIncomeCategories[index];
                            return ListTile(
                              contentPadding: EdgeInsets.all(12.0),
                              dense: true,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.label,
                                          color: Colors.blueGrey,
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              heading2(
                                                text: '${incomeCategory.name}',
                                                textAlign: TextAlign.start,
                                                color: Theme.of(context)
                                                   
                                                    .textSelectionTheme.selectionHandleColor,
                                              ),
                                              Visibility(
                                                visible: incomeCategory
                                                    .description.isNotEmpty,
                                                child: customTitleWithWrap(
                                                  text:
                                                      '${incomeCategory.description}',
                                                  color: Theme.of(context)
                                                     
                                                      .textSelectionTheme.selectionHandleColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.0,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              customTitleWithWrap(
                                                text:
                                                    '${incomeCategory.isHidden ? "Hidden" : "Active"}',
                                                color: Theme.of(context)
                                                   
                                                    .textSelectionTheme.selectionHandleColor,
                                                fontWeight: FontWeight.w400,
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
                                      backgroundColor:
                                          primaryColor.withOpacity(.3),
                                      color: primaryColor,
                                      iconSize: 16.0,
                                      padding: 0.0,
                                      onPressed: () =>
                                          _showActions(context, incomeCategory),
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
                      : betterEmptyList(
                          message:
                              "Sorry, you have not added any income categories");
                })),
          );
        },
      ),
    );
  }
}
