import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/group-loan-amortizatioin.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ApplyLoanFromGroup extends StatefulWidget {
  const ApplyLoanFromGroup({Key key}) : super(key: key);

  @override
  _ApplyLoanFromGroupState createState() => _ApplyLoanFromGroupState();
}

class _ApplyLoanFromGroupState extends State<ApplyLoanFromGroup> {
  final _formKey = GlobalKey<FormState>();
  BuildContext _buildContext;
  static final List<String> _dropdownItems = <String>[
    'Emergency Loan',
    'Education Loan'
  ];
  String _dropdownValue;
  String _errorText;
  int groupLoanAmount;
  bool _isChecked = false;

  void submitGroupLoan(bool isChecked) {
    final Group groupObject =
        Provider.of<Groups>(_buildContext, listen: false).getCurrentGroup();

    if (_formKey.currentState.validate()) {
      if (!isChecked) {
        showDialog(
            context: _buildContext,
            builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: subtitle1(text: "Accept Terms and Conditions"),
                  content: subtitle2(
                      text:
                          "Kindly Accept Terms and Conditions before Proceeding"),
                  actions: [
                    // ignore: deprecated_member_use
                    // negativeActionDialogButton(
                    //   text: ('CANCEL'),
                    //   color: Theme.of(_buildContext)
                    //       // ignore: deprecated_member_use
                    //       .textSelectionHandleColor,
                    //   action: () {
                    //     Navigator.of(_buildContext).pop();
                    //   },
                    // ),
                    // ignore: deprecated_member_use
                    positiveActionDialogButton(
                        text: ('OK'),
                        color: primaryColor,
                        action: () {
                          Navigator.of(_buildContext).pop();
                        }),
                  ],
                ));
      }
    } else {
      showConfirmDialog(groupObject);
    }
  }

  void showConfirmDialog(Group groupObject) {
    showDialog(
        context: _buildContext,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: subtitle1(text: "Confirmation"),
              content: subtitle2(
                  text: "Accept loan application of ${(groupLoanAmount)}."),
              actions: [
                // ignore: deprecated_member_use
                negativeActionDialogButton(
                  text: ('CANCEL'),
                  color: Theme.of(_buildContext)
                      // ignore: deprecated_member_use
                      .textSelectionHandleColor,
                  action: () {
                    Navigator.of(_buildContext).pop();
                  },
                ),
                // ignore: deprecated_member_use
                positiveActionDialogButton(
                    text: ('PROCEED'),
                    color: primaryColor,
                    action: () {
                      Navigator.of(_buildContext).pop();
                    }),
              ],
            ));
  }

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

  void toGroupAmmotization() {
    if (groupLoanAmount == null) {
      StatusHandler().showErrorDialog(_buildContext,
          "Loan Amount is required to proceed to Terms and Conditions.");
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => GroupLoanAmortization(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return (themeChangeProvider.darkTheme)
            ? Color(0xff00a9f0)
            : Color(0xff00a9f0);
      }
      return (themeChangeProvider.darkTheme)
          ? Color(0xff00a9f0)
          : Color(0xff00a9f0);
    }

    return Column(
      children: [
        Container(
          child: Form(
            key: _formKey,
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
                        validator: (value) {
                          if (value == null || value == "") {
                            return "The field is required";
                          }
                          return null;
                        },
                        labelText: "Amount applying for",
                        onChanged: (value) {
                          setState(() {
                            groupLoanAmount =
                                value != null ? int.tryParse(value) : 0.0;
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
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
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
                            'I agree to the ': {},
                            'terms and conditions': {
                              "url": () => toGroupAmmotization(),
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
                    context: context,
                    text: "Apply Now",
                    onPressed: () => submitGroupLoan(_isChecked))
              ],
            ),
          ),
        )
      ],
    );
  }
}
