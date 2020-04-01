import 'package:chamasoft/screens/chamasoft/models/expense-category.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ExpenseCategoriesList extends StatefulWidget {
  @override
  _ExpenseCategoriesListState createState() => _ExpenseCategoriesListState();
}

class _ExpenseCategoriesListState extends State<ExpenseCategoriesList> {
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

  final List<ExpenseCategory> list = [
    ExpenseCategory("1", "Audit Fees"),
    ExpenseCategory("1", "Annual Tax"),
    ExpenseCategory("1", "Subscription Fees"),
    ExpenseCategory("1", "Monthly Meeting Expenses"),
    ExpenseCategory("1", "Audit Fees"),
    ExpenseCategory("1", "Annual Tax"),
    ExpenseCategory("1", "Subscription Fees"),
    ExpenseCategory("1", "Monthly Meeting Expenses"),
    ExpenseCategory("1", "Audit Fees"),
    ExpenseCategory("1", "Annual Tax"),
    ExpenseCategory("1", "Subscription Fees"),
    ExpenseCategory("1", "Monthly Meeting Expenses"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: 1,
        leadingIcon: LineAwesomeIcons.close,
        title: "Select Expense Category",
      ),
      body: Container(
        //decoration: primaryGradient(context),
        color: Theme.of(context).backgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              margin: EdgeInsets.all(16.0),
              child: TextField(
                autocorrect: true,
                decoration: InputDecoration(
                  hintText: 'Search Category',
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  filled: false,
                  prefixIcon: Icon(
                    Feather.search,
                    size: 24,
                    color: Colors.blueGrey,
                  ),
                  fillColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ExpenseCategory category = list[index];
                  return Material(
                    color: Theme.of(context).backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              LineAwesomeIcons.file_text,
                              color: Colors.blueGrey,
                              size: 32,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            subtitle1(
                                text: category.name,
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                align: TextAlign.start),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                },
                itemCount: list.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
ListTile(
                        leading: Icon(
                          LineAwesomeIcons.file_text,
                          color: Colors.blueGrey,
                          size: 32,
                        ),
                        title: subtitle1(
                            text: category.name,
                            color: Theme.of(context).textSelectionHandleColor,
                            align: TextAlign.start),
                        onTap: () {},
                      )
 */
