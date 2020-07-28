import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'list-institutions.dart';

class EditBankAccount extends StatefulWidget {
  final int bankAccountId;

  EditBankAccount({this.bankAccountId});

  @override
  _EditBankAccountState createState() => _EditBankAccountState();
}

class _EditBankAccountState extends State<EditBankAccount> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  TextEditingController bankTextController = TextEditingController();
  TextEditingController bankBranchTextController = TextEditingController();
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
    fetchBankAccount(context);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    bankTextController?.dispose();
    bankBranchTextController?.dispose();
    super.dispose();
  }

  int bankId;
  int bankBranchId;
  int selectedBankId = 0;
  int selectedBankBranchId = 0;
  double initialBalance = 0;

  String bankAccountName = "";
  String accountNumber = "";
  String selectedBankName = '';
  String selectedBankBranchName = '';

  String bankFilter = "";
  String bankBranchFilter = "";
  bool pageLoaded = false;

  Future<bool> fetchBankOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchBankOptions();
      return true;
    } on CustomException catch (error) {
      print(error.message);
      return false;
    }
  }

  Future<void> fetchBankAccount(BuildContext context) async {
    try {
      final response = await Provider.of<Groups>(context, listen: false).fetchBankAccount(widget.bankAccountId);
      if (response != null) {
        await fetchBankOptions(context);

        this.setState(() {
          selectedBankId = int.parse(response['bank_id'].toString());
          selectedBankBranchId = int.parse(response['bank_branch_id'].toString());

          bankAccountName = response['account_name'].toString();
          accountNumber = response['account_number'].toString();

          selectedBankName = response['bank_name'].toString();
          selectedBankBranchName = response['bank_branch'].toString();

          accountNameTextController.text = bankAccountName;
          accountNumberTextController.text = accountNumber;
          initialAmountTextController.text = initialBalance.toString();
          bankTextController.text = selectedBankName;
          bankBranchTextController.text = selectedBankBranchName;

          pageLoaded = true;
        });

        await fetchBankBranchOptions(context);
      }
    } on CustomException catch (error) {
      print(error.message);
    }
  }

  Future<void> fetchBankBranchOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchBankBranchOptions(selectedBankId.toString());
    } on CustomException catch (error) {
      print(error.message);
      Navigator.pop(context);
    }
  }

  Future<void> editBankAccount(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).editBankAccount(
        id: widget.bankAccountId.toString(),
        accountName: bankAccountName,
        accountNumber: accountNumber,
        bankBranchId: selectedBankBranchId.toString(),
        bankId: selectedBankId.toString(),
        initialBalance: initialBalance.toString(),
      );

      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully updated the Bank Account",
      )));

      _formModified = 1;
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(context).pop(_formModified);
      });
    } on CustomException catch (error) {
      Navigator.pop(context);
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            editBankAccount(context);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Edit Bank Account",
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
                        toolTip(context: context, title: "", message: "Edit bank account", showTitle: false),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: <Widget>[
                            simpleTextInputField(
                                context: context,
                                labelText: 'Enter account name',
                                controller: accountNameTextController,
                                validator: (value) {
                                  Pattern pattern = r'^([A-Za-z0-9_ ]{2,})$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value))
                                    return 'Invalid bank account name';
                                  else
                                    return null;
                                },
                                onSaved: (value) => bankAccountName = value,
                                onChanged: (value) {
                                  setState(() {
                                    bankAccountName = value;
                                  });
                                }),
                            TextFormField(
                              controller: bankTextController,
                              readOnly: true,
                              style: inputTextStyle(),
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 1.0,
                                )),
                                hintText: 'Select Bank',
                                labelText: 'Select Bank',
                              ),
                              onTap: () async {
                                final arguments =
                                    await Navigator.pushNamed(context, ListInstitutions.namedRoute, arguments: InstitutionFlag.flagBanks);
                                if (arguments != null) {
                                  var details = arguments as InstitutionArguments;
                                  setState(() {
                                    Bank bank = details.bank as Bank;
                                    bankTextController.text = bank.name;
                                    selectedBankId = bank.id;
                                    selectedBankName = bank.name;

                                    selectedBankBranchId = 0;
                                    selectedBankBranchName = "";
                                    bankBranchTextController.text = selectedBankBranchName;
                                  });
                                }
                              },
                            ),
                            TextFormField(
                              controller: bankBranchTextController,
                              readOnly: true,
                              style: inputTextStyle(),
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 1.0,
                                )),
                                enabled: selectedBankId > 0,
                                hintText: selectedBankId > 0 ? 'Select bank branch' : 'Select bank First',
                                labelText: selectedBankId > 0 ? 'Select bank branch' : 'Select bank First',
                              ),
                              onTap: () async {
                                final arguments =
                                    await Navigator.pushNamed(context, ListInstitutions.namedRoute, arguments: InstitutionFlag.flagBankBranches);
                                if (arguments != null) {
                                  var details = arguments as InstitutionArguments;
                                  setState(() {
                                    BankBranch branch = details.bank as BankBranch;
                                    selectedBankBranchId = branch.id;
                                    selectedBankBranchName = branch.name;
                                    bankBranchTextController.text = selectedBankBranchName;
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
                                  return 'Invalid Bank account number';
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
                              onSaved: (value) => initialBalance = double.parse(value),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            defaultButton(
                              context: context,
                              text: "EDIT ACCOUNT",
                              onPressed: () async {
                                if (_formKey.currentState.validate() && selectedBankId > 0 && selectedBankBranchId > 0) {
                                  await editBankAccount(context);
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
