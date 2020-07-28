import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-accounts.dart';
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
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully added a Sacco Account",
      )));
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => ListAccounts()));
    } on CustomException catch (error) {
      Navigator.pop(context);

      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "Error Adding the Sacco Account. ${error.message} ",
      )));
    }
  }

  void _saccoPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: heading2(
                text: "Select Sacco",
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
                    initialValue: saccoFilter,
                    onChanged: (value) {
                      setState(() {
                        saccoFilter = value;
                      });
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                              .saccoOptions
                              .length,
                          itemBuilder: (context, index) {
                            Sacco sacco =
                                Provider.of<Groups>(context, listen: false)
                                    .saccoOptions[index];

                            return saccoFilter == null || saccoFilter == ""
                                ? RadioListTile(
                                    activeColor: primaryColor,
                                    title: Text(
                                      sacco.name,
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
                                      await fetchSaccoBranchOptions(context);
                                      Navigator.pop(context);

                                      setState(() {
                                        selectedSaccoId = value;
                                        selectedSaccoName = sacco.name;
                                        saccoTextController.text =
                                            selectedSaccoName;
                                      });
                                    },
                                    value: sacco.id,
                                    groupValue: selectedSaccoId,
                                  )
                                : sacco.name
                                        .toLowerCase()
                                        .contains(saccoFilter.toLowerCase())
                                    ? RadioListTile(
                                        activeColor: primaryColor,
                                        title: Text(
                                          sacco.name,
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
                                          await fetchSaccoBranchOptions(
                                              context);
                                          Navigator.pop(context);

                                          setState(() {
                                            selectedSaccoId = value;
                                            selectedSaccoName = sacco.name;
                                            saccoTextController.text =
                                                selectedSaccoName;
                                          });
                                        },
                                        value: sacco.id,
                                        groupValue: selectedSaccoId,
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

  void _saccoBranchPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: heading2(
                text: selectedSaccoId > 0
                    ? "Select Sacco Branch"
                    : "Select Sacco First",
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
                    initialValue: saccoBranchFilter,
                    onChanged: (value) {
                      setState(() {
                        saccoBranchFilter = value;
                      });
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                            itemCount: groupData.saccoBranchOptions.length,
                            itemBuilder: (context, index) {
                              SaccoBranch saccoBranch =
                                  groupData.saccoBranchOptions[index];

                              return saccoBranchFilter == null ||
                                      saccoBranchFilter == ""
                                  ? RadioListTile(
                                      activeColor: primaryColor,
                                      title: Text(
                                        saccoBranch.name,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textSelectionHandleColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedSaccoBranchId = value;
                                          selectedSaccoBranchName =
                                              saccoBranch.name;
                                          saccoBranchTextController.text =
                                              selectedSaccoBranchName;
                                        });
                                      },
                                      value: saccoBranch.id,
                                      groupValue: selectedSaccoBranchId,
                                    )
                                  : saccoBranch.name.toLowerCase().contains(
                                          saccoBranchFilter.toLowerCase())
                                      ? RadioListTile(
                                          activeColor: primaryColor,
                                          title: Text(
                                            saccoBranch.name,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedSaccoBranchId = value;
                                              selectedSaccoBranchName =
                                                  saccoBranch.name;
                                              saccoBranchTextController.text =
                                                  selectedSaccoBranchName;
                                            });
                                          },
                                          value: saccoBranch.id,
                                          groupValue: selectedSaccoBranchId,
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
                            onTap: () {
                              //show popup to select sacco
                              _saccoPrompt();
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
                            onTap: () {
                              //show popup to select sacco
                              _saccoBranchPrompt();
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
