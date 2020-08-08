import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import "package:provider/provider.dart";
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/providers/helpers/setting_helper.dart';
import 'package:chamasoft/providers/auth.dart';

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
          title: heading2(
              text: "Confirm Number to Pay From",
              color: Theme.of(context).textSelectionHandleColor,
              textAlign: TextAlign.start),
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
              labelText: "Mpesa Number",
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
                "Pay Now",
                style:
                    new TextStyle(color: primaryColor, fontFamily: 'SegoeUI'),
              ),
              onPressed: () {
                payNow();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        padding: EdgeInsets.all(10.0),
        width: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Container(
                height: 10,
                width: 100,
                decoration: BoxDecoration(
                    color: Color(0xffededfe),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(5)))),
            SizedBox(
              height: 5,
            ),
            subtitle1(
                text: "Pay Contribution",
                color: Theme.of(context).textSelectionHandleColor,
                textAlign: TextAlign.start),
            SizedBox(
              height: 5,
            ),
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16.0),
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
                        height: 10,
                      ),
                      RaisedButton(
                        color: primaryColor,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
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
          ],
        ));
  }
}
