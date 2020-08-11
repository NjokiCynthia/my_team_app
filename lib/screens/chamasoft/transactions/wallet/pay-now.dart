import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import "package:provider/provider.dart";
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chamasoft/providers/auth.dart';

// ignore: must_be_immutable
class PayNow extends StatefulWidget {
  //Function payNowFunction;
  PayNow(this.payNowFunction);
  final void Function(
      {int paymentFor,
      int paymentForId,
      double amount,
      String phoneNumber,
      String description}) payNowFunction;
  @override
  _PayNowState createState() => _PayNowState();
}

class _PayNowState extends State<PayNow> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  double amountInputValue;
  bool _isInit = true;
  Map<String, dynamic> formLoadData = {};
  List<NamesListItem> _dropdownItems = [];
  String _labelText = 'Select payment for first--';
  bool _paymentForEnabled = false;
  String _userPhoneNumber;
  String _description = "";

  static final List<NamesListItem> _paymentForOption = [
    NamesListItem(id: 1, name: "Contribution Payment"),
    NamesListItem(id: 2, name: "Fine Payment"),
    NamesListItem(id: 3, name: "Loan Repayment"),
    NamesListItem(id: 4, name: "Miscellaneous Payment"),
  ];

  final _formKey = new GlobalKey<FormState>();
  int _paymentFor;
  String _errorText;
  int _dropdownValue;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchDefaultValues(context);
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchDefaultValues(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
    formLoadData = await Provider.of<Groups>(context, listen: false)
        .loadInitialFormData(contr: true, fineOptions: true);
    setState(() {
      _isInit = false;
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  void payNow() {
    if (_userPhoneNumber == null) {
      _userPhoneNumber = Provider.of<Auth>(context, listen: false).phoneNumber;
    }
    Navigator.of(context).pop();
    widget.payNowFunction(
        paymentFor: _paymentFor,
        paymentForId: _dropdownValue,
        amount: amountInputValue,
        phoneNumber: _userPhoneNumber,
        description:_description);
  }

  void _populatePaymentFor() {
    if (_paymentFor == 1) {
      setState(() {
        _dropdownValue = null;
        _dropdownItems = formLoadData.containsKey("contributionOptions")
            ? formLoadData["contributionOptions"]
            : [];
        _paymentForEnabled = true;
        _labelText = "Select Contribution";
      });
    } else if (_paymentFor == 2) {
      setState(() {
        _dropdownValue = null;
        _dropdownItems = formLoadData.containsKey("finesOptions")
            ? formLoadData["finesOptions"]
            : [];
        _paymentForEnabled = true;
        _labelText = "Select Fine Type";
      });
    } else {
      setState(() {
        _dropdownValue = null;
        _dropdownItems = [];
        _paymentForEnabled = false;
        _labelText = "Select payment for first---";
      });
    }
  }

  Widget customDropDown(
      {int selectedItem,
      String labelText,
      Function onChanged,
      Function validator,
      List<NamesListItem> listItems,
      bool enabled}) {
    return new Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).cardColor,
      ),
      child: new DropdownButtonFormField(
        isExpanded: true,
        isDense: true,
        value: selectedItem,
        items: listItems.map((NamesListItem item) {
          return new DropdownMenuItem(
            value: item.id,
            child: new Text(
              item.name,
              style: inputTextStyle(),
            ),
          );
        }).toList(),
        decoration: InputDecoration(
            isDense: true,
            filled: false,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelStyle: inputTextStyle(),
            hintStyle: inputTextStyle(),
            errorStyle: inputTextStyle(),
            hintText: labelText,
            labelText: selectedItem == null ? labelText : labelText,
            enabled: enabled ?? true,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
              ),
            )),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  Widget buildDropDown() {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 7,
                child: customDropDown(
                    selectedItem: _paymentFor,
                    labelText: 'Select payment for',
                    onChanged: (int newValue) {
                      setState(() {
                        _paymentFor = newValue;
                        _populatePaymentFor();
                      });
                    },
                    validator: (newValue) {
                      if (newValue == null) {
                        return "Field is required";
                      }
                      return null;
                    },
                    listItems: _paymentForOption,
                    enabled: true),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(width: 10),
              ),
              Expanded(
                flex: 7,
                child: customDropDown(
                    selectedItem: _dropdownValue,
                    labelText: _labelText,
                    onChanged: (int newValue) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                    },
                    validator: (newValue) {
                      if (newValue == null) {
                        return "Field is required";
                      }
                      return null;
                    },
                    listItems: _dropdownItems,
                    enabled: _paymentForEnabled),
              ),

              // new InputDecorator(
              //   decoration: InputDecoration(
              //       enabled: false,
              //       labelStyle: inputTextStyle(),
              //       hintStyle: inputTextStyle(),
              //       errorStyle: inputTextStyle(),
              //       filled: false,
              //       hintText: 'Select payment for first--',
              //       labelText: _dropdownValue == null
              //           ? 'Select payment for first--'
              //           : 'Select payment for first--',
              //       errorText: _errorText,
              //       enabledBorder: UnderlineInputBorder(
              //           borderSide: BorderSide(
              //               color: Theme.of(context).hintColor, width: 1.0))),
              //   isEmpty: _dropdownValue == null,
              //   child: new Theme(
              //     data: Theme.of(context).copyWith(
              //       canvasColor: Theme.of(context).cardColor,
              //     ),
              //     child: new DropdownButton<String>(
              //       value: _dropdownValue,
              //       isDense: true,
              //       onChanged: (String newValue) {
              //         setState(() {
              //           _dropdownValue = newValue;
              //         });
              //       },
              //       items: _dropdownItems.map((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(
              //             value,
              //             style: inputTextStyle(),
              //           ),
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  void _numberToPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading2(
                  text: "Confirm Payment Number",
                  color: Theme.of(context).textSelectionHandleColor,
                  textAlign: TextAlign.start),
              SizedBox(
                height: 10,
              ),
              Text(
                "An M-Pesa STK Push will be initiated on this number. Stand by to confirm.",
                style: TextStyle(
                  color: Theme.of(context)
                      .hintColor, //Theme.of(context).textSelectionHandleColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          content: TextFormField(
            //controller: controller,
            style: inputTextStyle(),
            initialValue: Provider.of<Auth>(context).phoneNumber,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
              )),
              // hintText: 'Phone Number or Email Address',
              labelText: "M-Pesa Number",
            ),
            onChanged: (newValue) {
              _userPhoneNumber = newValue;
            },
          ),
          actions: <Widget>[
            negativeActionDialogButton(
                text: "Cancel",
                color: Theme.of(context).textSelectionHandleColor,
                action: () {
                  Navigator.of(context).pop();
                }),
            positiveActionDialogButton(
                text: "Pay Now",
                color: primaryColor,
                action: () {
                  payNow();
                }),
          ],
        );
      },
    );
  }

  void _validatePayNowForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    _numberToPrompt();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(
            top:10,
            left:10,
            right:10,
            bottom:MediaQuery.of(context).viewInsets.bottom+40,
          ),
          width: double.infinity,
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              Container(
                  height: 8,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .hintColor
                          .withOpacity(0.3), //Color(0xffededfe),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
              SizedBox(
                height: 7,
              ),
              heading2(
                  text: "Wallet Payment",
                  color: Theme.of(context).textSelectionHandleColor,
                  textAlign: TextAlign.start),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 16.0),
                      child: Column(
                        children: <Widget>[
                          buildDropDown(),
                          amountTextInputField(
                              context: context,
                              labelText: "Amount to pay",
                              onChanged: (value) {
                                setState(() {
                                  amountInputValue = double.parse(value);
                                });
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            color: primaryColor,
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                              child: Text("Pay Now"),
                            ),
                            textColor: Colors.white,
                            onPressed: () => _validatePayNowForm(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
