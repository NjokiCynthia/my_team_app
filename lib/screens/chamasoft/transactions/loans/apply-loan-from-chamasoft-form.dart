import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

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
  TextEditingController myController = TextEditingController();
  TextEditingController guarantor1Controller = TextEditingController();
  TextEditingController guarantor2Controller = TextEditingController();
  TextEditingController guarantor3Controller = TextEditingController();

  int result = 0, guarantor1 = 0, guarantor2 = 0, guarantor3 = 0;
  //int loanRepaymentAmount = result + 1000;

  sum() {
    setState(() {
      guarantor1 = int.parse(guarantor1Controller.text);
      guarantor2 = int.parse(guarantor2Controller.text);
      guarantor3 = int.parse(guarantor3Controller.text);
      result = guarantor1 + guarantor2 + guarantor3;
    });
  }

  int guarantorOneId, guarantorTwoId, guarantorThreeId;
  String guarantorOneName, guarantorTwoName, guarantorThreeName;

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final LoanProduct _loanProduct = arguments['loanProduct'];

    print("form options ${arguments['formLoadData']}");
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
                                      controller: myController,
                                      validator: (value) {
                                        if (value == null || value == "") {
                                          return "The field is required";
                                        }
                                        return null;
                                      },
                                      labelText: "Enter The Loan Amount",
                                      enabled: true,
                                      onChanged: (value) {
                                        setState(() {});
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
                                      controller: guarantor1Controller,
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
                                        setState(() {});
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
                                      controller: guarantor2Controller,
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
                                        setState(() {});
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
                                    labelText: "Select guarantor three",
                                    listItems: _memberOptions,
                                    selectedItem: guarantorThreeId,
                                    onChanged: (value) {
                                      setState(() {
                                        guarantorThreeId = value;
                                        guarantorThreeName = _memberOptions
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
                                      controller: guarantor3Controller,
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
                                        setState(() {});
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
                                onPressed: () {
                                  //sum();
                                  if (_formKey.currentState.validate()) {
                                    sum();
                                    if (result < int.parse(myController.text)) {
                                      guarantor3Controller.clear();
                                      guarantor2Controller.clear();
                                      guarantor1Controller.clear();
                                      Fluttertoast.showToast(
                                          msg:
                                              "Guarantors amount is less than the amount borrwed, Please Set new Amounts",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else if (result >
                                        int.parse(myController.text)) {
                                      guarantor3Controller.clear();
                                      guarantor2Controller.clear();
                                      guarantor1Controller.clear();
                                      Fluttertoast.showToast(
                                          msg:
                                              "Guarantors amount is Exceeds the amount borrwed",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else if (result ==
                                        int.parse(myController.text)) {
                                      print(result +
                                          int.parse(myController.text));
                                      Fluttertoast.showToast(
                                          msg:
                                              "OK to Proceed with the Application",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.greenAccent,
                                          textColor: Colors.white,
                                          fontSize: 16.0);

                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                title: heading2(
                                                    text:
                                                        "Confirm Application"),
                                                content: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Column(
                                                          // mainAxisAlignment:
                                                          //     MainAxisAlignment
                                                          //         .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            customTitleWithWrap(
                                                                text:
                                                                    "Loan Type :",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start),
                                                            SizedBox(
                                                              height: 15.0,
                                                            ),
                                                            customTitleWithWrap(
                                                              text:
                                                                  "Amount KES:",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            SizedBox(
                                                              height: 15.0,
                                                            ),
                                                            customTitleWithWrap(
                                                                text:
                                                                    "Refund KES:",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start),
                                                            SizedBox(
                                                              height: 15.0,
                                                            ),
                                                            customTitleWithWrap(
                                                                text:
                                                                    "Due Date:",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start)
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Column(
                                                          children: [
                                                            customTitleWithWrap(
                                                                text:
                                                                    _loanProduct
                                                                        .name,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end),
                                                            SizedBox(
                                                              height: 15.0,
                                                            ),
                                                            customTitleWithWrap(
                                                              text: myController
                                                                  .text,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            SizedBox(
                                                              height: 15.0,
                                                            ),
                                                            customTitleWithWrap(
                                                                text: (int.parse(myController
                                                                            .text) +
                                                                        1000)
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start),
                                                            SizedBox(
                                                              height: 15.0,
                                                            ),
                                                            customTitleWithWrap(
                                                                text: DateTime
                                                                        .now()
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end)
                                                          ],
                                                        )
                                                      ],
                                                    )
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  positiveActionDialogButton(
                                                      text: ('PROCEED'),
                                                      color: primaryColor,
                                                      action: () {}),
                                                ],
                                              ));
                                    } else {
                                      guarantor3Controller.clear();
                                      guarantor2Controller.clear();
                                      guarantor1Controller.clear();
                                      Fluttertoast.showToast(
                                          msg:
                                              "Something went wrong, Try again",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Something went wrong, Try again",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                  print(result);
                                  print(int.parse(myController.text));
                                },
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
