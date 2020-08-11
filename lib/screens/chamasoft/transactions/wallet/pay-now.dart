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
  Function payNow;

  PayNow(this.payNow);

  @override
  _PayNowState createState() => _PayNowState();
}

class _PayNowState extends State<PayNow> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  int depositMethod;

  double amountInputValue;

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

  void payNow() {
    widget.payNow();
    Navigator.of(context).pop();
  }

  static final List<String> _dropdownItems = <String>[
    'Monthly Savings',
    'Welfare'
  ];
  final formKey = new GlobalKey<FormState>();
  String _dropdownValue;
  String _errorText;

  Widget buildDropDown() {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new InputDecorator(
                decoration: InputDecoration(
                    labelStyle: inputTextStyle(),
                    hintStyle: inputTextStyle(),
                    errorStyle: inputTextStyle(),
                    filled: false,
                    hintText: 'Select Contribution',
                    labelText: _dropdownValue == null
                        ? 'Select Contribution'
                        : 'Select Contribution',
                    errorText: _errorText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor, width: 1.0))),
                isEmpty: _dropdownValue == null,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Theme.of(context).cardColor,
                  ),
                  child: new DropdownButton<String>(
                    value: _dropdownValue,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                    },
                    items: _dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: inputTextStyle(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: double.infinity,
            color: Theme.of(context).backgroundColor,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
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
                    text: "Contribution Payment",
                    color: Theme.of(context).textSelectionHandleColor,
                    textAlign: TextAlign.start),
                SizedBox(
                  height: 10,
                ),
                Column(
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
                              // validator: (value) {
                              //   if (!CustomHelper.validIdentity(value.trim())) {
                              //     return 'Enter valid phone or email';
                              //   }
                              //   return null;
                              // },
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
                            onPressed: () => _numberToPrompt(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // textWithExternalLinks(color: Theme.of(context).textSelectionHandleColor, size: 12.0, textData: {
                //   'By continuing you agree to our': {},
                //   'terms & conditions': {
                //     "url": () => launchURL('https://chamasoft.com/terms-and-conditions/'),
                //     "color": primaryColor,
                //     "weight": FontWeight.w500
                //   },
                //   'and': {},
                //   'privacy policy.': {
                //     "url": () => launchURL('https://chamasoft.com/terms-and-conditions/'),
                //     "color": primaryColor,
                //     "weight": FontWeight.w500
                //   },
                // }),
              ],
            )),
      ),
    );
  }
}
