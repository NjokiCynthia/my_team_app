import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class CreateAssetCategory extends StatefulWidget {
  final bool isEdit;
  final IncomeCategories incomeCategory;

  CreateAssetCategory({@required this.isEdit, this.incomeCategory});

  @override
  _CreateAssetCategoryState createState() => _CreateAssetCategoryState();
}

class _CreateAssetCategoryState extends State<CreateAssetCategory> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final _formKey = GlobalKey<FormState>();
  int _formModified = 0;
  bool _isFormEnabled = true;
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();

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

    if (widget.isEdit) {
      _nameTextController.text = widget.incomeCategory.name;
      _descriptionTextController.text = widget.incomeCategory.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  Future<void> editAssetCategory(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      String id = widget.isEdit ? widget.incomeCategory.id : "";
      await Provider.of<Groups>(context, listen: false).createAssetCategory(
          name: _nameTextController.text,
          description: _descriptionTextController.text,
          action: widget.isEdit
              ? SettingActions.actionEdit
              : SettingActions.actionAdd,
          id: id);

      Navigator.pop(context);
      String message = "Asset category has been added";
      if (widget.isEdit) {
        message = "You have successfully updated the asset category";
      }
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        message,
      )));

      _formModified = 1;
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop(_formModified);
      });
    } on CustomException catch (error) {
      Navigator.pop(context);
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            editAssetCategory(context);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: widget.isEdit ? "Edit Asset Category" : "Add Asset Category",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(builder: (BuildContext context) {
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
                      message: widget.isEdit
                          ? "Update Asset Category"
                          : "Create Asset Category",
                      showTitle: false),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          simpleTextInputField(
                              controller: _nameTextController,
                              context: context,
                              labelText: 'Asset category name',
                              validator: (value) {
                                if (value == "" || value == null) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              enabled: _isFormEnabled),
                          SizedBox(
                            height: 24,
                          ),
                          simpleTextInputField(
                              controller: _descriptionTextController,
                              context: context,
                              labelText: 'Category description',
                              validator: (value) {
                                if (value == "" || value == null) {
                                  return "This field is required";
                                } else if (value.toString().length < 4) {
                                  return "Description is too short";
                                }
                                return null;
                              },
                              enabled: _isFormEnabled),
                          SizedBox(
                            height: 24,
                          ),
                          defaultButton(
                            context: context,
                            text: "SAVE",
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await editAssetCategory(context);
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
