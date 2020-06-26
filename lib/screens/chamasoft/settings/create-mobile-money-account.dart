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

class CreateMobileMoneyAccount extends StatefulWidget {
  @override
  _CreateMobileMoneyAccountState createState() =>
      _CreateMobileMoneyAccountState();
}

class _CreateMobileMoneyAccountState extends State<CreateMobileMoneyAccount> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  TextEditingController mobileMoneyTextController = TextEditingController();
  TextEditingController mobileMoneyBranchTextController =
      TextEditingController();
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
    mobileMoneyTextController?.dispose();
    mobileMoneyBranchTextController?.dispose();
    super.dispose();
  }

  int mobileMoneyId;
  int mobileMoneyBranchId;
  int selectedMobileMoneyProviderId = 0;
  double initialBalance = 0;

  String mobileMoneyAccountName;
  String accountNumber;
  String selectedMobileMoneyName = '';

  String mobileMoneyFilter = "";

  Future<void> createNewMobileMoneyAccount(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false)
          .createMobileMoneyAccount(
        accountName: mobileMoneyAccountName,
        accountNumber: accountNumber,
        mobileMoneyProviderId: selectedMobileMoneyProviderId.toString(),
        initialBalance: initialBalance.toString(),
        mobileLocalId: "0",
      );

      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully added a Mobile Money Account",
      )));
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => ListAccounts()));
    } on CustomException catch (error) {
      Navigator.pop(context);

      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "Error Adding the Mobile Money Account. ${error.message} ",
      )));
    }
  }

  void _mobileMoneyPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: heading2(
                text: "Select Mobile Money Provider",
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
                    initialValue: mobileMoneyFilter,
                    onChanged: (value) {
                      setState(() {
                        mobileMoneyFilter = value;
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
                              .mobileMoneyProviderOptions
                              .length,
                          itemBuilder: (context, index) {
                            MobileMoneyProvider mobileMoneyProvider =
                                Provider.of<Groups>(context, listen: false)
                                    .mobileMoneyProviderOptions[index];

                            return mobileMoneyFilter == null ||
                                    mobileMoneyFilter == ""
                                ? RadioListTile(
                                    activeColor: primaryColor,
                                    title: Text(
                                      mobileMoneyProvider.name,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textSelectionHandleColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: (value) async {
                                      setState(() {
                                        selectedMobileMoneyProviderId = value;
                                        selectedMobileMoneyName =
                                            mobileMoneyProvider.name;
                                        mobileMoneyTextController.text =
                                            selectedMobileMoneyName;
                                      });
                                    },
                                    value: mobileMoneyProvider.id,
                                    groupValue: selectedMobileMoneyProviderId,
                                  )
                                : mobileMoneyProvider.name
                                        .toLowerCase()
                                        .contains(
                                            mobileMoneyFilter.toLowerCase())
                                    ? RadioListTile(
                                        activeColor: primaryColor,
                                        title: Text(
                                          mobileMoneyProvider.name,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionHandleColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onChanged: (value) async {
                                          setState(() {
                                            selectedMobileMoneyProviderId =
                                                value;
                                            selectedMobileMoneyName =
                                                mobileMoneyProvider.name;
                                            mobileMoneyTextController.text =
                                                selectedMobileMoneyName;
                                          });
                                        },
                                        value: mobileMoneyProvider.id,
                                        groupValue:
                                            selectedMobileMoneyProviderId,
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
        title: "Create Mobile Money Account",
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
                      message: "Create a new mobile money account",
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
                                  return 'Invalid mobile money account name';
                                else
                                  return null;
                              },
                              onSaved: (value) =>
                                  mobileMoneyAccountName = value,
                              onChanged: (value) {
                                setState(() {
                                  mobileMoneyAccountName = value;
                                });
                              }),
                          TextFormField(
                            controller: mobileMoneyTextController,
                            readOnly: true,
                            style: inputTextStyle(),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Theme.of(context).hintColor,
                                width: 1.0,
                              )),
                              hintText: 'Select Mobile Money Provider',
                              labelText: 'Select Mobile Money Provider',
                            ),
                            onTap: () {
                              //show popup to select mobileMoney
                              _mobileMoneyPrompt();
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
                                return 'Invalid MobileMoney account number';
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
                                  selectedMobileMoneyProviderId > 0) {
                                await createNewMobileMoneyAccount(context);
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
