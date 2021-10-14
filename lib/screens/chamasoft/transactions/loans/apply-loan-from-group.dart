import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/group-loan-amortizatioin.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ApplyLoanFromGroup extends StatefulWidget {
  final Map<String, dynamic> formLoadData;
  final List<LoanType> loanTypes;

  const ApplyLoanFromGroup({this.formLoadData, this.loanTypes, Key key})
      : super(key: key);

  @override
  _ApplyLoanFromGroupState createState() => _ApplyLoanFromGroupState();
}

class _ApplyLoanFromGroupState extends State<ApplyLoanFromGroup> {
  final _formKey = GlobalKey<FormState>();
  int _loanTypeId;
  int _groupLoanAmount;
  bool _isChecked = false;
  LoanType _loanType;

  void submitGroupLoan(bool isChecked, BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (!isChecked) {
        StatusHandler().showErrorDialog(
            context, "Kindly accept Terms and Conditions before proceeding.");
      } else {
        showConfirmDialog(context);
      }
    }
  }

  void showConfirmDialog(BuildContext context) {
    final Group groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: subtitle1(text: "Confirmation"),
              content: subtitle2(
                  text:
                      "Accept loan application of ${groupObject.groupCurrency} ${currencyFormat.format(_groupLoanAmount)}."),
              actions: [
                // ignore: deprecated_member_use
                negativeActionDialogButton(
                  text: ('CANCEL'),
                  color: Theme.of(context)
                      // ignore: deprecated_member_use
                      .textSelectionHandleColor,
                  action: () {
                    Navigator.of(context).pop();
                  },
                ),
                // ignore: deprecated_member_use
                positiveActionDialogButton(
                    text: ('PROCEED'),
                    color: primaryColor,
                    action: () {
                      // ignore: todo
                      // TODO: SEND TO SERVER FUNCTION
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }

  void toGroupAmmotization(BuildContext context) {
    if (_groupLoanAmount == null) {
      StatusHandler().showErrorDialog(context,
          "Loan Amount is required to proceed to Terms and Conditions.");
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => GroupLoanAmortization(
            loanAmount: _groupLoanAmount,
            loanTypeId: _loanTypeId,
          ),
        ),
      );
    }
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
            ? Color(0xff00a9f0)
            : Color(0xff00a9f0);
      }
      return (themeChangeProvider.darkTheme)
          ? Color(0xff00a9f0)
          : Color(0xff00a9f0);
    }

    List<NamesListItem> loanTypeOptions =
        widget.formLoadData.containsKey('loanTypeOptions')
            ? widget.formLoadData['loanTypeOptions']
            : [];
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
                    CustomDropDownButton(
                      enabled: true,
                      labelText: "Select group loan type",
                      listItems: loanTypeOptions,
                      onChanged: (value) {
                        setState(() {
                          _loanTypeId = value;
                          _loanType = widget.loanTypes.firstWhere(
                              (loanType) =>
                                  loanType.id.toString() == value.toString(),
                              orElse: () => null);
                        });
                      },
                      validator: (value) {
                        if (value == "" || value == null) {
                          return "This field is required";
                        }
                        return null;
                      },
                    ),
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
                            _groupLoanAmount =
                                value != null ? int.tryParse(value) : 0.0;
                          });
                        }),
                    if (_loanType != null && _loanType.guarantors == "1")
                      Container(
                        child: Text("The guarantors section will be here"),
                      )
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
                              "url": () => toGroupAmmotization(context),
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
                    onPressed: () => submitGroupLoan(_isChecked, context))
              ],
            ),
          ),
        )
      ],
    );
  }
}
