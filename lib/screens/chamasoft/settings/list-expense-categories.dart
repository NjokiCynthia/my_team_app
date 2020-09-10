import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'create-expense-category.dart';
import 'edit-expense-category.dart';

class ListExpenseCategories extends StatefulWidget {
  @override
  _ListExpenseCategoriesState createState() => _ListExpenseCategoriesState();
}

class _ListExpenseCategoriesState extends State<ListExpenseCategories> {
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
      backgroundColor: Colors.transparent,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Expenses Categories",
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateExpenseCategory(),
          ));
        },
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: primaryGradient(context),
          child: Consumer<Groups>(builder: (context, groupData, child) {
            return groupData.expenseCategories.length > 0
                ? ListView.separated(
                    padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
                    itemCount: groupData.expenseCategories.length,
                    itemBuilder: (context, index) {
                      ExpenseCategories expense = groupData.expenseCategories[index];
                      return ListTile(
                        dense: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.label,
                                        color: Colors.blueGrey,
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${expense.name}',
                                            style: TextStyle(
                                              color: Theme.of(context).textSelectionHandleColor,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: circleIconButton(
                                          icon: Icons.edit,
                                          backgroundColor: primaryColor.withOpacity(.3),
                                          color: primaryColor,
                                          iconSize: 18.0,
                                          padding: 0.0,
                                          onPressed: () async {
                                            await Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => EditExpenseCategory(
                                                expenseCategoryId: int.parse(expense.id),
                                              ),
                                            ));
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
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
                : betterEmptyList(message: "Sorry, you have not added any expense categories");
          })),
    );
  }
}
