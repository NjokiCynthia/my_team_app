import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/accounts/list-institutions.dart';
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

class CreateBankAccount extends StatefulWidget {
  static const String namedRoute = 'create-bank-account';

  @override
  _CreateBankAccountState createState() => _CreateBankAccountState();
}

class _CreateBankAccountState extends State<CreateBankAccount> {
  bool shouldPopInstead = false;
  double _appBarElevation = 0;
  ScrollController _scrollController;
  TextEditingController bankTextController = TextEditingController();
  TextEditingController bankBranchTextController = TextEditingController();
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
    bankTextController?.dispose();
    bankBranchTextController?.dispose();
    super.dispose();
  }

  int bankId;
  int bankBranchId;
  int selectedBankId = 0;
  int selectedBankBranchId = 0;
  double initialBalance = 0;

  String bankAccountName;
  String accountNumber;
  String selectedBankName = '';
  String selectedBankBranchName = '';

  String bankFilter = "";
  String bankBranchFilter = "";

  Future<void> fetchBankBranchOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchBankBranchOptions(selectedBankId.toString());
    } on CustomException catch (error) {
      print(error.message);
      Navigator.pop(context);
    }
  }

  Future<void> createNewBankAccount(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).createBankAccount(
        accountName: bankAccountName,
        accountNumber: accountNumber,
        bankBranchId: selectedBankBranchId.toString(),
        bankId: selectedBankId.toString(),
        initialBalance: initialBalance.toString(),
      );

      Navigator.pop(context);
      if (shouldPopInstead != null && shouldPopInstead) {
        Navigator.of(context).pop(true);
      } else {
        // ignore: deprecated_member_use
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "You have successfully added a Bank Account",
        )));

        _formModified = 1;
        Future.delayed(const Duration(seconds: 4), () {
          Navigator.of(context).pop(_formModified);
        });
      }
    } on CustomException catch (error) {
      Navigator.pop(context);

      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Error Adding the Bank Account. ${error.message} ",
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    shouldPopInstead = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Create Bank Account",
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
                      message: "Create a new bank account",
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
                              final arguments = await Navigator.pushNamed(
                                  context, ListInstitutions.namedRoute,
                                  arguments: InstitutionFlag.flagBanks);
                              if (arguments != null) {
                                var details = arguments as InstitutionArguments;
                                setState(() {
                                  Bank bank = details.bank as Bank;
                                  bankTextController.text = bank.name;
                                  selectedBankId = bank.id;
                                  selectedBankName = bank.name;
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
                              hintText: selectedBankId > 0
                                  ? 'Select bank branch'
                                  : 'Select bank First',
                              labelText: selectedBankId > 0
                                  ? 'Select bank branch'
                                  : 'Select bank First',
                            ),
                            onTap: () async {
                              final arguments = await Navigator.pushNamed(
                                  context, ListInstitutions.namedRoute,
                                  arguments: InstitutionFlag.flagBankBranches);
                              if (arguments != null) {
                                var details = arguments as InstitutionArguments;
                                setState(() {
                                  BankBranch branch =
                                      details.bank as BankBranch;
                                  selectedBankBranchId = branch.id;
                                  selectedBankBranchName = branch.name;
                                  bankBranchTextController.text =
                                      selectedBankBranchName;
                                });
                              }
                            },
                          ),
                          simpleTextInputField(
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
                                return 'Invalid Bank account number';
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
                                  selectedBankId > 0 &&
                                  selectedBankBranchId > 0) {
                                await createNewBankAccount(context);
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
