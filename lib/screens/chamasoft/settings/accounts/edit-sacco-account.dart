import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'list-institutions.dart';

class EditSaccoAccount extends StatefulWidget {
  final int saccoAccountId;

  EditSaccoAccount({this.saccoAccountId});

  @override
  _EditSaccoAccountState createState() => _EditSaccoAccountState();
}

class _EditSaccoAccountState extends State<EditSaccoAccount> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  TextEditingController saccoTextController = TextEditingController();
  TextEditingController saccoBranchTextController = TextEditingController();
  TextEditingController accountNameTextController = TextEditingController();
  TextEditingController accountNumberTextController = TextEditingController();
  TextEditingController initialAmountTextController = TextEditingController();

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
    fetchSaccoAccount(context);
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

  String saccoAccountName = "";
  String accountNumber = "";
  String selectedSaccoName = '';
  String selectedSaccoBranchName = '';

  String saccoFilter = "";
  String saccoBranchFilter = "";
  bool pageLoaded = false;

  Future<bool> fetchSaccoOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchSaccoOptions();
      return true;
    } on CustomException catch (error) {
      print(error.message);
      return false;
    }
  }

  Future<void> fetchSaccoAccount(BuildContext context) async {
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .fetchSaccoAccount(widget.saccoAccountId);
      if (response != null) {
        await fetchSaccoOptions(context);
        await fetchSaccoBranchOptions(context);

        this.setState(() {
          selectedSaccoId = int.parse(response['sacco_id'].toString());
          selectedSaccoBranchId =
              int.parse(response['sacco_branch_id'].toString());

          saccoAccountName = response['account_name'].toString();
          accountNumber = response['account_number'].toString();

          selectedSaccoName = response['sacco_name'].toString();
          selectedSaccoBranchName = response['sacco_branch'].toString();

          accountNameTextController.text = saccoAccountName;
          accountNumberTextController.text = accountNumber;
          initialAmountTextController.text = initialBalance.toString();
          saccoTextController.text = selectedSaccoName;
          saccoBranchTextController.text = selectedSaccoBranchName;

          pageLoaded = true;
        });
      }
    } on CustomException catch (error) {
      print(error.message);
    }
  }

  Future<void> fetchSaccoBranchOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchSaccoBranchOptions(selectedSaccoId.toString());
    } on CustomException catch (error) {
      print(error.message);
      Navigator.pop(context);
    }
  }

  Future<void> editSaccoAccount(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).editSaccoAccount(
        id: widget.saccoAccountId.toString(),
        accountName: saccoAccountName,
        accountNumber: accountNumber,
        saccoBranchId: selectedSaccoBranchId.toString(),
        saccoId: selectedSaccoId.toString(),
        initialBalance: initialBalance.toString(),
      );

      Navigator.pop(context);
     
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully updated the Sacco Account",
      )));
      _formModified = 1;
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(context).pop(_formModified);
      });
    } on CustomException catch (error) {
      Navigator.pop(context);

     
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Error updating the Sacco Account. ${error.message} ",
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Edit Sacco Account",
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
                            message: "Edit sacco account",
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
                                    labelText: 'Enter account name',
                                    controller: accountNameTextController,
                                    validator: (value) {
                                      Pattern pattern =
                                          r'^([A-Za-z0-9_ ]{2,})$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(value))
                                        return 'Invalid sacco account name';
                                      else
                                        return null;
                                    },
                                    onSaved: (value) =>
                                        saccoAccountName = value,
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
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
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
                                      var details =
                                          arguments as InstitutionArguments;
                                      setState(() {
                                        Sacco sacco = details.bank as Sacco;
                                        selectedSaccoId = sacco.id;
                                        selectedSaccoName = sacco.name;
                                        saccoTextController.text =
                                            selectedSaccoName;
                                      });
                                    }
                                  },
                                ),
                                TextFormField(
                                  controller: saccoBranchTextController,
                                  readOnly: true,
                                  style: inputTextStyle(),
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
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
                                        arguments:
                                            InstitutionFlag.flagSaccoBranches);
                                    if (arguments != null) {
                                      var details =
                                          arguments as InstitutionArguments;
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
                                  controller: accountNumberTextController,
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
                                  controller: initialAmountTextController,
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
                                  text: "EDIT ACCOUNT",
                                  onPressed: () async {
                                    if (_formKey.currentState.validate() &&
                                        selectedSaccoId > 0 &&
                                        selectedSaccoBranchId > 0) {
                                      await editSaccoAccount(context);
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
