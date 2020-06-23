import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class CreateBankAccount extends StatefulWidget {
  @override
  _CreateBankAccountState createState() => _CreateBankAccountState();
}

class _CreateBankAccountState extends State<CreateBankAccount> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  TextEditingController bankTextController = TextEditingController();
  TextEditingController bankBranchTextController = TextEditingController();

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

  String accountNumber;
  int bankId;
  int bankBranchId;
  int selectedBankId = 0;
  int selectedBankBranchId = 0;
  String bankAccountName;
  String selectedBankName = '';
  String selectedBankBranchName = '';
  String bankFilter = "";
  String bankBranchFilter = "";

  Future<void> fetchBankBranchOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchBankBranchOptions(selectedBankId.toString());
    } on CustomException catch (error) {
      Navigator.pop(context);
    }
  }

  void _bankPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: heading2(
                text: "Select Bank",
                color: Theme.of(context).textSelectionHandleColor,
                textAlign: TextAlign.start),
            content: Container(
              //height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    style: inputTextStyle(),
                    initialValue: bankFilter,
                    onChanged: (value) {
                      setState(() {
                        bankFilter = value;
                      });
                    },
                    decoration: InputDecoration(
                      hasFloatingPlaceholder: true,
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).hintColor,
                        width: 1.0,
                      )),
                      // hintText: 'Phone Number or Email Address',
                      labelText: "Search",
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: Provider.of<Groups>(context, listen: false)
                              .bankOptions
                              .length,
                          itemBuilder: (context, index) {
                            Bank bank =
                                Provider.of<Groups>(context, listen: false)
                                    .bankOptions[index];

                            return bankFilter == null || bankFilter == ""
                                ? RadioListTile(
                                    activeColor: primaryColor,
                                    title: Text(
                                      bank.name,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textSelectionHandleColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: (value) async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          });
                                      await fetchBankBranchOptions(context);
                                      Navigator.pop(context);

                                      setState(() {
                                        selectedBankId = value;
                                        selectedBankName = bank.name;
                                        bankTextController.text =
                                            selectedBankName;
                                      });
                                    },
                                    value: bank.id,
                                    groupValue: selectedBankId,
                                  )
                                : bank.name
                                        .toLowerCase()
                                        .contains(bankFilter.toLowerCase())
                                    ? RadioListTile(
                                        activeColor: primaryColor,
                                        title: Text(
                                          bank.name,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionHandleColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onChanged: (value) async {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              });
                                          await fetchBankBranchOptions(context);
                                          Navigator.pop(context);

                                          setState(() {
                                            selectedBankId = value;
                                            selectedBankName = bank.name;
                                            bankTextController.text =
                                                selectedBankName;
                                          });
                                        },
                                        value: bank.id,
                                        groupValue: selectedBankId,
                                      )
                                    : new Container();
                          }),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "Cancel",
                  style: TextStyle(
                      color: Theme.of(context).textSelectionHandleColor,
                      fontFamily: 'SegoeUI'),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(
                  "Continue",
                  style:
                      new TextStyle(color: primaryColor, fontFamily: 'SegoeUI'),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _bankBranchPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: heading2(
                text: selectedBankId > 0
                    ? "Select Bank Branch"
                    : "Select Bank First",
                color: Theme.of(context).textSelectionHandleColor,
                textAlign: TextAlign.start),
            content: Container(
              //height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    style: inputTextStyle(),
                    initialValue: bankBranchFilter,
                    onChanged: (value) {
                      setState(() {
                        bankBranchFilter = value;
                      });
                    },
                    decoration: InputDecoration(
                      hasFloatingPlaceholder: true,
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).hintColor,
                        width: 1.0,
                      )),
                      // hintText: 'Phone Number or Email Address',
                      labelText: "Search",
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Consumer<Groups>(
                          builder: (context, groupData, child) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: groupData.bankBranchOptions.length,
                            itemBuilder: (context, index) {
                              BankBranch bankBranch =
                                  groupData.bankBranchOptions[index];

                              return bankBranchFilter == null ||
                                      bankBranchFilter == ""
                                  ? RadioListTile(
                                      activeColor: primaryColor,
                                      title: Text(
                                        bankBranch.name,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textSelectionHandleColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBankBranchId = value;
                                          selectedBankBranchName =
                                              bankBranch.name;
                                          bankBranchTextController.text =
                                              selectedBankBranchName;
                                        });
                                      },
                                      value: bankBranch.id,
                                      groupValue: selectedBankBranchId,
                                    )
                                  : bankBranch.name.toLowerCase().contains(
                                          bankBranchFilter.toLowerCase())
                                      ? RadioListTile(
                                          activeColor: primaryColor,
                                          title: Text(
                                            bankBranch.name,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedBankBranchId = value;
                                              selectedBankBranchName =
                                                  bankBranch.name;
                                              bankBranchTextController.text =
                                                  selectedBankBranchName;
                                            });
                                          },
                                          value: bankBranch.id,
                                          groupValue: selectedBankBranchId,
                                        )
                                      : new Container();
                            });
                      }),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "Cancel",
                  style: TextStyle(
                      color: Theme.of(context).textSelectionHandleColor,
                      fontFamily: 'SegoeUI'),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(
                  "Continue",
                  style:
                      new TextStyle(color: primaryColor, fontFamily: 'SegoeUI'),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Create Bank Account",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
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
                          hasFloatingPlaceholder: true,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                            width: 1.0,
                          )),
                          hintText: 'Select Bank',
                          labelText: 'Select Bank',
                        ),
                        onTap: () {
                          //show popup to select bank
                          _bankPrompt();
                        },
                      ),
                      TextFormField(
                        controller: bankBranchTextController,
                        readOnly: true,
                        style: inputTextStyle(),
                        decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
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
                        onTap: () {
                          //show popup to select bank
                          _bankBranchPrompt();
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
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      defaultButton(
                        context: context,
                        text: "CREATE ACCOUNT",
                        onPressed: () {
                          print('Account Name date: $bankAccountName');
                          print('Bank: $selectedBankName');
                          print('Bank Branch: $selectedBankBranchName');
                          print('Account Number: $accountNumber');
                        },
                      ),
                    ]),
              ),
            ],
          )),
    );
  }
}
