import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'loan-amortization.dart';

class ApplyLoanFromChamasoftForm extends StatefulWidget {
  // const ChamaSoftLoanDetail({ Key? key }) : super(key: key);

  @override
  _ApplyLoanFromChamasoftFormState createState() =>
      _ApplyLoanFromChamasoftFormState();
}

class _ApplyLoanFromChamasoftFormState
    extends State<ApplyLoanFromChamasoftForm> {
  double _appBarElevation = 0;
  final _formKey = GlobalKey<FormState>();

  double generalAmount;
  double amountToRefund;
  double guarantorOneAmount, guarantorTwoAmount;
  int guarantorOneId, guarantorTwoId, guarantorThreeId;
  String guarantorOneName, guarantorTwoName, guarantorThreeName;

  double get totalGuaranteed {
    return guarantorOneAmount + guarantorTwoAmount;
  }

  void submit(LoanProduct loanProduct) {
    final Group groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    if (_formKey.currentState.validate()) {
      if (totalGuaranteed < generalAmount) {
        StatusHandler().showErrorDialog(context,
            "You have guaranteed ${groupObject.groupCurrency} ${currencyFormat.format(totalGuaranteed)} out of ${groupObject.groupCurrency} ${currencyFormat.format(generalAmount)}");
      } else if (totalGuaranteed > generalAmount) {
        StatusHandler().showErrorDialog(context,
            "You have guaranteed ${groupObject.groupCurrency} ${currencyFormat.format(totalGuaranteed)} out of ${groupObject.groupCurrency} ${currencyFormat.format(generalAmount)}");
      } else if (totalGuaranteed == generalAmount) {
        showConfirmationDialog(loanProduct, groupObject);
      } else {
        StatusHandler()
            .showErrorDialog(context, "Something went wrong, please try again");
      }
    }
  }

  void showConfirmationDialog(LoanProduct loanProduct, Group groupObject) {
    amountToRefund = generalAmount +
        (generalAmount * (int.tryParse(loanProduct.interestRate) / 100));

    String monthsOfRepayment = loanProduct.fixedRepaymentPeriod != ""
        ? loanProduct.fixedRepaymentPeriod
        : loanProduct.maximumRepaymentPeriod;

    DateTime currentDt = new DateTime.now();

    DateTime repaymentDt = new DateTime(currentDt.year,
        currentDt.month + int.parse(monthsOfRepayment), currentDt.day);

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: heading2(text: "Confirm Application"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      subtitle1(text: "Loan Type"),
                      Spacer(),
                      subtitle2(text: "${loanProduct.name}")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      subtitle1(text: "Amount"),
                      Spacer(),
                      subtitle2(
                          text:
                              "${groupObject.groupCurrency} ${currencyFormat.format(generalAmount)}")
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      subtitle1(text: "Loan processing fee"),
                      Spacer(),
                      subtitle2(
                          text:
                              "${groupObject.groupCurrency} ${currencyFormat.format(100)}")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      subtitle1(text: "Refund"),
                      Spacer(),
                      subtitle2(
                          text:
                              "${groupObject.groupCurrency} ${currencyFormat.format(amountToRefund)}")
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      subtitle1(text: "Due date"),
                      Spacer(),
                      subtitle2(text: DateFormat.yMMMEd().format(repaymentDt))
                    ],
                  ),
                ],
              ),
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
                    text: ('PROCEED'), color: primaryColor, action: () {}),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _generalAmount = new TextEditingController();
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final LoanProduct _loanProduct = arguments['loanProduct'];

    final List<NamesListItem> _memberOptions =
        arguments['formLoadData'].containsKey("memberOptions")
            ? arguments['formLoadData']['memberOptions']
            : [];

    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ApplyLoan(),
            ),
          ),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: "Apply Loan",
        ),
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              color: (themeChangeProvider.darkTheme)
                  ? Colors.blueGrey[800]
                  : Colors.white,
              //   // padding: EdgeInsets.all(0.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: primaryGradient(context),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  heading2(
                                    text: "From ChamaSoft:  ",
                                  ),
                                  heading2(
                                    text: _loanProduct.name,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  amountTextInputField(
                                      context: context,
                                      //controller: _generalAmount,
                                      validator: (value) {
                                        if (value == null || value == "") {
                                          return "The field is required";
                                        }
                                        return null;
                                      },
                                      labelText: "Enter The Loan Amount",
                                      enabled: true,
                                      onChanged: (value) {
                                        setState(() {
                                          generalAmount = value != null
                                              ? double.parse(value)
                                              : 0.0;
                                        });
                                      }),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: heading2(text: "Guarantors:"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: CustomDropDownButton(
                                    enabled: true,
                                    labelText: "Select guarantor one",
                                    listItems: _memberOptions,
                                    selectedItem: guarantorOneId,
                                    onChanged: (value) {
                                      setState(() {
                                        guarantorOneId = value;
                                        guarantorOneName = _memberOptions
                                            .firstWhere(
                                                (member) => member.id == value)
                                            .name;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == "" || value == null) {
                                        return "This field is required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 25.0,
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: amountTextInputField(
                                      context: context,
                                      validator: (value) {
                                        if (value == null || value == "") {
                                          return "The field is required";
                                        }
                                        return null;
                                      },
                                      labelText: "Enter Amount",
                                      enabled: true,
                                      onChanged: (value) {
                                        setState(() {
                                          guarantorOneAmount = value != null
                                              ? double.parse(value)
                                              : 0.0;
                                        });
                                      }),
                                ))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: CustomDropDownButton(
                                    enabled: true,
                                    labelText: "Select guarantor two",
                                    listItems: _memberOptions,
                                    selectedItem: guarantorTwoId,
                                    onChanged: (value) {
                                      setState(() {
                                        guarantorTwoId = value;
                                        guarantorTwoName = _memberOptions
                                            .firstWhere(
                                                (member) => member.id == value)
                                            .name;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == "" || value == null) {
                                        return "This field is required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: amountTextInputField(
                                      context: context,
                                      validator: (value) {
                                        if (value == null || value == "") {
                                          return "The field is required";
                                        }
                                        return null;
                                      },
                                      labelText: "Enter Amount",
                                      enabled: true,
                                      onChanged: (value) {
                                        setState(() {
                                          guarantorTwoAmount = value != null
                                              ? double.parse(value)
                                              : 0.0;
                                        });
                                      }),
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              child: textWithExternalLinks(
                                  color: Colors.blueGrey,
                                  size: 12.0,
                                  textData: {
                                    'By applying for this loan you agree to the ':
                                        {},
                                    'terms and conditions': {
                                      "url": () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        LoanAmortization(),
                                                settings:
                                                    RouteSettings(arguments: {
                                                  'loanProduct': _loanProduct,
                                                  'generalAmount':generalAmount,
                                                })),
                                          ),
                                      "color": primaryColor,
                                      "weight": FontWeight.w500
                                    },
                                  }),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Center(
                              child: defaultButton(
                                context: context,
                                text: "Apply Now",
                                onPressed: () => submit(_loanProduct),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
