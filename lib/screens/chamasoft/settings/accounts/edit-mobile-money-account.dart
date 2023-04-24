import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class EditMobileMoneyAccount extends StatefulWidget {
  final int mobileMoneyAccountId;

  EditMobileMoneyAccount({this.mobileMoneyAccountId});

  @override
  _EditMobileMoneyAccountState createState() => _EditMobileMoneyAccountState();
}

class _EditMobileMoneyAccountState extends State<EditMobileMoneyAccount> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  TextEditingController mobileMoneyTextController = TextEditingController();
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
    fetchMobileMoneyAccount(context);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    mobileMoneyTextController?.dispose();
    super.dispose();
  }

  int mobileMoneyId;
  int selectedMobileProviderMoneyId = 0;
  double initialBalance = 0;

  String mobileMoneyAccountName = "";
  String accountNumber = "";
  String selectedMobileMoneyProviderName = '';

  String mobileMoneyFilter = "";
  bool pageLoaded = false;

  Future<bool> fetchMobileMoneyProviderOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchMobileMoneyProviderOptions();
      return true;
    } on CustomException catch (error) {
      print(error.message);
      return false;
    }
  }

  Future<void> fetchMobileMoneyAccount(BuildContext context) async {
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .fetchMobileMoneyAccount(widget.mobileMoneyAccountId);
      if (response != null) {
        await fetchMobileMoneyProviderOptions(context);

        this.setState(() {
          selectedMobileProviderMoneyId =
              int.parse(response['mobile_money_provider_id'].toString());

          mobileMoneyAccountName = response['account_name'].toString();
          accountNumber = response['account_number'].toString();

          selectedMobileMoneyProviderName =
              response['mobile_money_provider_name'].toString();

          accountNameTextController.text = mobileMoneyAccountName;
          accountNumberTextController.text = accountNumber;
          initialAmountTextController.text = initialBalance.toString();
          mobileMoneyTextController.text = selectedMobileMoneyProviderName;

          pageLoaded = true;
        });
      }
    } on CustomException catch (error) {
      print(error.message);
    }
  }

  Future<void> editMobileMoneyAccount(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await Provider.of<Groups>(context, listen: false).editMobileMoneyAccount(
        id: widget.mobileMoneyAccountId.toString(),
        accountName: mobileMoneyAccountName,
        accountNumber: accountNumber,
        mobileMoneyProviderId: selectedMobileProviderMoneyId.toString(),
        initialBalance: initialBalance.toString(),
      );

      Navigator.pop(context);
      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully updated the Mobile Money Account",
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
        "Error updating the Mobile Money Account. ${error.message} ",
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
                // ignore: deprecated_member_use
                color: Theme.of(context).textSelectionTheme.selectionHandleColor,
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
                                              // ignore: deprecated_member_use
                                              .textSelectionTheme.selectionHandleColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedMobileProviderMoneyId = value;
                                        selectedMobileMoneyProviderName =
                                            mobileMoneyProvider.name;
                                        mobileMoneyTextController.text =
                                            selectedMobileMoneyProviderName;
                                      });
                                    },
                                    value: mobileMoneyProvider.id,
                                    groupValue: selectedMobileProviderMoneyId,
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
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme.selectionHandleColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedMobileProviderMoneyId =
                                                value;
                                            selectedMobileMoneyProviderName =
                                                mobileMoneyProvider.name;
                                            mobileMoneyTextController.text =
                                                selectedMobileMoneyProviderName;
                                          });
                                        },
                                        value: mobileMoneyProvider.id,
                                        groupValue:
                                            selectedMobileProviderMoneyId,
                                      )
                                    : new Container();
                          }),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              ElevatedButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                    fontFamily: 'SegoeUI',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              // ignore: deprecated_member_use
              ElevatedButton(
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: primaryColor,
                    fontFamily: 'SegoeUI',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )

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
        title: "Edit Mobile Money Account",
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
                            message: "Edit Mobile Money account",
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
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Theme.of(context).hintColor,
                                      width: 1.0,
                                    )),
                                    hintText: 'Select Mobile Money provider',
                                    labelText: 'Select Mobile Money provider',
                                  ),
                                  onTap: () {
                                    //show popup to select mobileMoney
                                    _mobileMoneyPrompt();
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
                                      return 'Invalid MobileMoney account number';
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
                                        selectedMobileProviderMoneyId > 0) {
                                      await editMobileMoneyAccount(context);
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
