import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class EditExpenseCategory extends StatefulWidget {
  final int expenseCategoryId;

  EditExpenseCategory({this.expenseCategoryId});
  @override
  _EditExpenseCategoryState createState() => _EditExpenseCategoryState();
}

class _EditExpenseCategoryState extends State<EditExpenseCategory> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
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
    fetchExpenseCategory(context);
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
  int id;
  bool pageLoaded = false;

  Future<void> fetchExpenseCategory(BuildContext context) async {
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .fetchExpenseCategory(widget.expenseCategoryId);
      if (response != null) {
        this.setState(() {
          id = int.parse(response['id'].toString());
          description = response['description'].toString();
          categoryName = response['name'].toString();

          nameTextController.text = categoryName;
          descriptionTextController.text = description.toString();

          pageLoaded = true;
        });
      }
    } on CustomException catch (error) {
      print(error.message);
    }
  }

  Future<void> editExpenseCategory(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).editExpenseCategory(
          name: categoryName,
          description: description.toString(),
          id: id.toString());

      Navigator.pop(context);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully updated the expense category",
      )));

      _formModified = 1;
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(context).pop(_formModified);
      });
    } on CustomException catch (error) {
      Navigator.pop(context);

      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "Error updating the Expense Category. ${error.message} ",
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Edit Expense Category",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(builder: (context) {
        return pageLoaded
            ? Form(
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
                            message: "Update Expense Category",
                            showTitle: false),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                simpleTextInputField(
                                    context: context,
                                    labelText: 'Enter expense name',
                                    validator: (value) {
                                      Pattern pattern =
                                          r'^([A-Za-z0-9_ ]{2,})$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(value))
                                        return 'Invalid name';
                                      else
                                        return null;
                                    },
                                    onSaved: (value) => categoryName = value,
                                    controller: nameTextController,
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
                                  labelText: 'Enter description',
                                  controller: descriptionTextController,
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
                                  text: "EDIT CATEGORY",
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      await editExpenseCategory(context);
                                    }
                                  },
                                ),
                              ]),
                        ),
                      ],
                    )),
              )
            : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
