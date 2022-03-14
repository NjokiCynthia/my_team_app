import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class EditFineType extends StatefulWidget {
  final int fineCategoryId;

  EditFineType({this.fineCategoryId});
  @override
  _EditFineTypeState createState() => _EditFineTypeState();
}

class _EditFineTypeState extends State<EditFineType> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController amountTextController = TextEditingController();
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
    fetchFineType(context);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  String fineTypeName = "";
  double amount = 0;
  int id;
  bool pageLoaded = false;

  Future<void> fetchFineType(BuildContext context) async {
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .fetchFineCategory(widget.fineCategoryId);
      if (response != null) {
        this.setState(() {
          id = int.parse(response['id'].toString());
          amount = double.parse(response['amount'].toString());
          fineTypeName = response['name'].toString();

          nameTextController.text = fineTypeName;
          amountTextController.text = amount.toString();

          pageLoaded = true;
        });
      }
    } on CustomException catch (error) {
      print(error.message);
    }
  }

  Future<void> editFineType(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).editFineCategory(
          name: fineTypeName, amount: amount.toString(), id: id.toString());

      Navigator.pop(context);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully updated the fine category",
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
        "Error updating the Fine Category. ${error.message} ",
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Edit Fine Category",
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
                            message: "Update Fine Category",
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
                                    labelText: 'Enter fine name',
                                    validator: (value) {
                                      Pattern pattern =
                                          r'^([A-Za-z0-9_ ]{2,})$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(value))
                                        return 'Invalid name';
                                      else
                                        return null;
                                    },
                                    onSaved: (value) => fineTypeName = value,
                                    controller: nameTextController,
                                    onChanged: (value) {
                                      setState(() {
                                        fineTypeName = value;
                                      });
                                    }),
                                SizedBox(
                                  height: 24,
                                ),
                                simpleTextInputField(
                                    context: context,
                                    labelText: 'Enter Amount',
                                    validator: (value) {
                                      /*  Pattern pattern =
                                          r'^([A-Za-z0-9_ ]{2,})$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(value))
                                        return 'Invalid name';
                                      else */
                                      return null;
                                    },
                                    onSaved: (value) => amount = value,
                                    controller: amountTextController,
                                    onChanged: (value) {
                                      setState(() {
                                        amount = value;
                                      });
                                    }),
                                // amountTextInputField(
                                //   context: context,
                                //   labelText: 'Enter amount',
                                //   controller: amountTextController,

                                //   onChanged: (value) {
                                //     setState(() {
                                //       amount = double.parse(value);
                                //     });
                                //   },
                                //   validator: (value) {
                                //     return null;
                                //   },
                                // ),
                                SizedBox(
                                  height: 24,
                                ),
                                defaultButton(
                                  context: context,
                                  text: "EDIT CATEGORY",
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      await editFineType(context);
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
