import 'package:chamasoft/screens/chamasoft/models/bank.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<Bank> banksList = [
  Bank("1", "NCBA Bank", LineAwesomeIcons.bank),
  Bank("2", "KCB Bank", LineAwesomeIcons.bank),
  Bank("3", "Cooperative Bank", LineAwesomeIcons.bank),
  Bank("4", "ABSA Bank", LineAwesomeIcons.bank),
  Bank("5", "Wakurinu Fire Breathers an Demon Chasers Bank",
      LineAwesomeIcons.bank),
];

List<NamesListItem> bankBranchesList = [
  NamesListItem(id: 1, name: "Moi Avenue"),
  NamesListItem(id: 2, name: "Tom Mboya"),
  NamesListItem(id: 3, name: "Kenyatta Avenue"),
  NamesListItem(id: 4, name: "Upper Hill"),
  NamesListItem(id: 5, name: "Kilimani"),
  NamesListItem(id: 6, name: "Westlands"),
  NamesListItem(id: 7, name: "Head Office"),
  NamesListItem(id: 8, name: "Community"),
  NamesListItem(id: 9, name: "City Park"),
  NamesListItem(id: 10, name: "Queens Way"),
  NamesListItem(id: 11, name: "State House"),
  NamesListItem(id: 12, name: "Junction"),
  NamesListItem(id: 13, name: "Kasarani"),
  NamesListItem(id: 14, name: "Embakasi"),
  NamesListItem(
      id: 15,
      name: "Arab Kamwana Investment Committee Juja Branch Console Xbox"),
  NamesListItem(id: 16, name: "Kiambu"),
];

class CreateSaccoAccount extends StatefulWidget {
  @override
  _CreateSaccoAccountState createState() => _CreateSaccoAccountState();
}

class _CreateSaccoAccountState extends State<CreateSaccoAccount> {
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
  int selectedBankId;
  int selectedBankBranchId;
  String bankAccountName;
  String selectedBankName = '';
  String selectedBankBranchName = '';
  String bankFilter = "";
  String bankBranchFilter = "";

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
                          itemCount: banksList.length,
                          itemBuilder: (context, index) {
                            Bank bank = banksList[index];

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
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBankId = value;
                                        selectedBankName = bank.name;
                                        bankTextController.text =
                                            selectedBankName;
                                      });
                                    },
                                    value: int.parse(bank.id),
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
                                        onChanged: (value) {
                                          setState(() {
                                            selectedBankId = value;
                                            selectedBankName = bank.name;
                                            bankTextController.text =
                                                selectedBankName;
                                          });
                                        },
                                        value: int.parse(bank.id),
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
                text: "Select Bank Branch",
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
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: bankBranchesList.length,
                          itemBuilder: (context, index) {
                            NamesListItem bankBranch = bankBranchesList[index];

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
        title: "Create Sacco Account",
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
                          hintText: 'Select bank branch',
                          labelText: 'Select bank branch',
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
