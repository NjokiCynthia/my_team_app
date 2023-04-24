import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'list-institutions.dart';

class CreateSaccoAccount extends StatefulWidget {
  @override
  _CreateSaccoAccountState createState() => _CreateSaccoAccountState();
}

class _CreateSaccoAccountState extends State<CreateSaccoAccount> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  TextEditingController saccoTextController = TextEditingController();
  TextEditingController saccoBranchTextController = TextEditingController();
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
    saccoTextController?.dispose();
    saccoBranchTextController?.dispose();
    super.dispose();
  }

  int saccoId;
  int saccoBranchId;
  int selectedSaccoId = 0;
  int selectedSaccoBranchId = 0;
  double initialBalance = 0;

  String saccoAccountName;
  String accountNumber;
  String selectedSaccoName = '';
  String selectedSaccoBranchName = '';

  String saccoFilter = "";
  String saccoBranchFilter = "";

  Future<void> fetchSaccoBranchOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchSaccoBranchOptions(selectedSaccoId.toString());
    } on CustomException catch (error) {
      print(error.message);
      Navigator.pop(context);
    }
  }

  Future<void> createNewSaccoAccount(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).createSaccoAccount(
        accountName: saccoAccountName,
        accountNumber: accountNumber,
        saccoBranchId: selectedSaccoBranchId.toString(),
        saccoId: selectedSaccoId.toString(),
        initialBalance: initialBalance.toString(),
      );

      Navigator.pop(context);
      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully added a Sacco Account",
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
        "Error Adding the Sacco Account. ${error.message} ",
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Create Sacco Account",
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
                      message: "Create a new sacco account",
                      showTitle: false),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          simpleTextInputField(
                              context: context,
                              labelText: 'Enter account name',
                              validator: (value) {
                                Pattern pattern = r'^([A-Za-z0-9_ ]{2,})$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value))
                                  return 'Invalid sacco account name';
                                else
                                  return null;
                              },
                              onSaved: (value) => saccoAccountName = value,
                              onChanged: (value) {
                                setState(() {
                                  saccoAccountName = value;
                                });
                              }),
                          TextFormField(
                            controller: saccoTextController,
                            readOnly: true,
                            style: inputTextStyle(),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Theme.of(context).hintColor,
                                width: 1.0,
                              )),
                              hintText: 'Select Sacco',
                              labelText: 'Select Sacco',
                            ),
                            onTap: () async {
                              final arguments = await Navigator.pushNamed(
                                  context, ListInstitutions.namedRoute,
                                  arguments: InstitutionFlag.flagSaccos);
                              if (arguments != null) {
                                var details = arguments as InstitutionArguments;
                                setState(() {
                                  Sacco sacco = details.bank as Sacco;
                                  selectedSaccoId = sacco.id;
                                  selectedSaccoName = sacco.name;
                                  saccoTextController.text = selectedSaccoName;
                                });
                              }
                            },
                          ),
                          TextFormField(
                            controller: saccoBranchTextController,
                            readOnly: true,
                            style: inputTextStyle(),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Theme.of(context).hintColor,
                                width: 1.0,
                              )),
                              enabled: selectedSaccoId > 0,
                              hintText: selectedSaccoId > 0
                                  ? 'Select sacco branch'
                                  : 'Select sacco First',
                              labelText: selectedSaccoId > 0
                                  ? 'Select sacco branch'
                                  : 'Select sacco First',
                            ),
                            onTap: () async {
                              final arguments = await Navigator.pushNamed(
                                  context, ListInstitutions.namedRoute,
                                  arguments: InstitutionFlag.flagSaccoBranches);
                              if (arguments != null) {
                                var details = arguments as InstitutionArguments;
                                setState(() {
                                  SaccoBranch branch =
                                      details.bank as SaccoBranch;
                                  selectedSaccoBranchId = branch.id;
                                  selectedSaccoBranchName = branch.name;
                                  saccoBranchTextController.text =
                                      selectedSaccoBranchName;
                                });
                              }
                            },
                          ),
                          numberTextInputField(
                            context: context,
                            labelText: 'Enter account number',
                            onChanged: (value) {
                              setState(() {
                                accountNumber = value;
                              });
                            },
                            validator: (value) {
                              Pattern pattern = r'^([0-9]{8,20})$';
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(value))
                                return 'Invalid Sacco account number';
                              else
                                return null;
                            },
                            onSaved: (value) => accountNumber = value,
                          ),
                          amountTextInputField(
                            context: context,
                            labelText: 'Initial Balance',
                            onChanged: (value) {
                              setState(() {
                                initialBalance = double.parse(value);
                              });
                            },
                            validator: (value) {
                              return null;
                            },
                            onSaved: (value) =>
                                initialBalance = double.parse(value),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          defaultButton(
                            context: context,
                            text: "CREATE ACCOUNT",
                            onPressed: () async {
                              if (_formKey.currentState.validate() &&
                                  selectedSaccoId > 0 &&
                                  selectedSaccoBranchId > 0) {
                                await createNewSaccoAccount(context);
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
