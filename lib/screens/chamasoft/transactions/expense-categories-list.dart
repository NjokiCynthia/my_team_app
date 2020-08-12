import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/expense-category.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/withdrawal-option.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ExpenseCategoriesList extends StatefulWidget {
  @override
  _ExpenseCategoriesListState createState() => _ExpenseCategoriesListState();
}

class _ExpenseCategoriesListState extends State<ExpenseCategoriesList> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<ExpenseCategories> list = [];
  TextEditingController _controller = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  String filter;

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

    _controller.addListener(() {
      setState(() {
        filter = _controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void descriptionDialog(ExpenseCategories category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
            text: "Description for ${category.name}",
            textAlign: TextAlign.start,
            color: Theme.of(context).textSelectionHandleColor,
          ),
          content: simpleTextInputField(
              context: context, controller: _descriptionController, labelText: 'Short description(optional)'),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(fontFamily: 'SegoeUI', color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Proceed",
                style: new TextStyle(
                  color: primaryColor,
                  fontFamily: 'SegoeUI',
                ),
              ),
              onPressed: () {
                print(_descriptionController.text);
//                Navigator.of(context)
//                    .push(MaterialPageRoute(builder: (BuildContext context) => WithdrawalOption()))
//                    .then((result) {
//                  Navigator.of(context).pop();
//                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<Groups>(context).expenseCategories;

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: 1,
        leadingIcon: LineAwesomeIcons.close,
        title: "Select Expense Category",
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        //decoration: primaryGradient(context),
        color: Theme.of(context).backgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Search Expense Category",
                prefixIcon: Icon(LineAwesomeIcons.search),
              ),
              controller: _controller,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ExpenseCategories category = list[index];
                  return filter == null || filter.isEmpty
                      ? buildListTile(context, category)
                      : category.name.toLowerCase().contains(filter.toLowerCase())
                          ? buildListTile(context, category)
                          : Visibility(visible: false, child: new Container());
                },
                itemCount: list.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Material buildListTile(BuildContext context, ExpenseCategories category) {
    return Material(
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
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
                  text: category.name, color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
            ],
          ),
        ),
        onTap: () => descriptionDialog(category),
      ),
    );
  }
}
