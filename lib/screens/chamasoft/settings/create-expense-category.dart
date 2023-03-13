import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CreateExpenseCategory extends StatefulWidget {
  @override
  _CreateExpenseCategoryState createState() => _CreateExpenseCategoryState();
}

class _CreateExpenseCategoryState extends State<CreateExpenseCategory> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final _formKey = GlobalKey<FormState>();

  int _formModified = 0;

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

  String categoryName = "";
  String description = "";

  Future<void> createCategory(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).createExpenseCategory(
        name: categoryName,
        description: description,
      );

      Navigator.pop(context);
      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully added an expense category",
      )));

      _formModified = 1;
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(context).pop(_formModified);
      });
    } on CustomException catch (error) {
      Navigator.pop(context);

      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Error Adding the Expense Category. ${error.message} ",
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Create Expense Category",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(builder: (context) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  toolTip(
                      context: context,
                      title: "",
                      message: "Create a new Category",
                      showTitle: false),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          simpleTextInputField(
                              context: context,
                              labelText: 'Enter category name',
                              validator: (value) {
                                Pattern pattern = r'^([A-Za-z0-9_ ]{2,})$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value))
                                  return 'Invalid  name';
                                else
                                  return null;
                              },
                              onSaved: (value) => categoryName = value,
                              onChanged: (value) {
                                setState(() {
                                  categoryName = value;
                                });
                              }),
                          SizedBox(
                            height: 24,
                          ),
                          simpleTextInputField(
                            context: context,
                            labelText: 'Enter Description',
                            onChanged: (value) {
                              setState(() {
                                description = value;
                              });
                            },
                            validator: (value) {
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          defaultButton(
                            context: context,
                            text: "CREATE CATEGORY",
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await createCategory(context);
                              }
                            },
                          ),
                        ]),
                  ),
                ],
              )),
        );
      }),
    );
  }
}
