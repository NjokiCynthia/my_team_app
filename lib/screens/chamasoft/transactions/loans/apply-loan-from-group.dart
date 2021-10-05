import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/group-loan-amortizatioin.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";

class ApplyLoanFromGroup extends StatefulWidget {
  const ApplyLoanFromGroup({Key key}) : super(key: key);

  @override
  _ApplyLoanFromGroupState createState() => _ApplyLoanFromGroupState();
}

class _ApplyLoanFromGroupState extends State<ApplyLoanFromGroup> {
  static final List<String> _dropdownItems = <String>[
    'Emergency Loan',
    'Education Loan'
  ];
  String _dropdownValue;
  String _errorText;
  double amountInputValue;
  bool _isChecked = false;

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
                    hintText: 'Select Loan Type',
                    labelText: _dropdownValue == null
                        ? 'Select Loan Type'
                        : 'Select Loan Type',
                    errorText: _errorText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor, width: 1.0))),
                isEmpty: _dropdownValue == null,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: (themeChangeProvider.darkTheme)
                        ? Colors.blueGrey[800]
                        : Colors.white,
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

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return (themeChangeProvider.darkTheme)
            ? Colors.blueGrey[800]
            : Colors.white;
      }
      return (themeChangeProvider.darkTheme)
          ? Colors.blueGrey[800]
          : Colors.white;
    }

    return Column(
      children: [
        Container(
          child: Column(
            children: <Widget>[
              toolTip(
                  context: context,
                  title: "Note that...",
                  message:
                      "Loan application process is totally depended on your group's constitution and your group\'s management."),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [
                  buildDropDown(),
                  amountTextInputField(
                      context: context,
                      labelText: "Amount applying for",
                      onChanged: (value) {
                        setState(() {
                          amountInputValue = double.parse(value);
                        });
                      }),
                ]),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Row(
                  children: [
                    Checkbox(
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: _isChecked,
                        onChanged: (bool value) {
                          setState(() {
                            _isChecked = value;
                          });
                        }),
                    textWithExternalLinks(
                        color: Colors.blueGrey,
                        size: 12.0,
                        textData: {
                          'You agree to the ': {},
                          'terms and conditions': {
                            "url": () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        GroupLoanAmortization(),
                                  ),
                                ),
                            "color": primaryColor,
                            "weight": FontWeight.w500
                          },
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              defaultButton(
                  context: context, text: "Apply Now", onPressed: () {})
            ],
          ),
        )
      ],
    );
  }
}
