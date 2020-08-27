import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/create-income-category.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'contribution/create-contribution.dart';

class ListIncomeCategories extends StatefulWidget {
  @override
  _ListIncomeCategoriesState createState() => _ListIncomeCategoriesState();
}

class _ListIncomeCategoriesState extends State<ListIncomeCategories> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _fetchIncomeCategories(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchDetailedIncomeCategories();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchIncomeCategories(context);
          });
    }
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
                      final result = await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateIncomeCategory(isEdit: true, incomeCategory: incomeCategory),
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
                          text: "Edit Income Category",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
                    ),
                  ),
                ),
//                Material(
//                  color: Theme.of(context).backgroundColor,
//                  child: InkWell(
//                    onTap: () {},
//                    splashColor: Colors.blueGrey.withOpacity(0.2),
//                    child: ListTile(
//                      leading: Icon(
//                        Icons.delete,
//                        color: Colors.red.withOpacity(0.7),
//                      ),
//                      title: customTitle(
//                          text: "Delete Contribution",
//                          fontWeight: FontWeight.w600,
//                          textAlign: TextAlign.start,
//                          color: Theme.of(context).textSelectionHandleColor),
//                      onTap: () {
//                        Navigator.pop(context);
//                      },
//                    ),
//                  ),
//                ),
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
            key: _refreshIndicatorKey,
            onRefresh: () => _fetchIncomeCategories(_scaffoldKey.currentContext),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: primaryGradient(context),
                child: Consumer<Groups>(builder: (context, groupData, child) {
                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 50.0, top: 10.0),
                    itemCount: groupData.detailedIncomeCategories.length,
                    itemBuilder: (context, index) {
                      IncomeCategories incomeCategory = groupData.detailedIncomeCategories[index];
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
                                        heading2(
                                          text: '${incomeCategory.name}',
                                          textAlign: TextAlign.start,
                                          color: Theme.of(context).textSelectionHandleColor,
                                        ),
                                        Visibility(
                                          visible: incomeCategory.description.isNotEmpty,
                                          child: customTitleWithWrap(
                                            text: '${incomeCategory.description}',
                                            color: Theme.of(context).textSelectionHandleColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        customTitleWithWrap(
                                          text: '${incomeCategory.active ? "Active" : "Hidden"}',
                                          color: Theme.of(context).textSelectionHandleColor,
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
                                backgroundColor: primaryColor.withOpacity(.3),
                                color: primaryColor,
                                iconSize: 16.0,
                                padding: 0.0,
                                onPressed: () => _showActions(_scaffoldKey.currentContext, incomeCategory),
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
                  );
                })),
          );
        },
      ),
    );
  }
}
