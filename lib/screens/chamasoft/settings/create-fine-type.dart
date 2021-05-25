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

class CreateFineType extends StatefulWidget {
  @override
  _CreateFineTypeState createState() => _CreateFineTypeState();
}

class _CreateFineTypeState extends State<CreateFineType> {
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

  String fineTypeName = "";
  double amount = 0;

  Future<void> createFineType(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).createFineCategory(
        name: fineTypeName,
        amount: amount.toString(),
      );

      Navigator.pop(context);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully added a fine category",
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
        "Error Adding the Fine Category. ${error.message} ",
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Create Fine Category",
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
                      message: "Create a new Fine Category",
                      showTitle: false),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          simpleTextInputField(
                              context: context,
                              labelText: 'Enter fine name',
                              validator: (value) {
                                Pattern pattern = r'^([A-Za-z0-9_ ]{2,})$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value))
                                  return 'Invalid name';
                                else
                                  return null;
                              },
                              onSaved: (value) => fineTypeName = value,
                              onChanged: (value) {
                                setState(() {
                                  fineTypeName = value;
                                });
                              }),
                          SizedBox(
                            height: 24,
                          ),
                          amountTextInputField(
                            context: context,
                            labelText: 'Enter amount',
                            onChanged: (value) {
                              setState(() {
                                amount = double.parse(value);
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
                                await createFineType(context);
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
