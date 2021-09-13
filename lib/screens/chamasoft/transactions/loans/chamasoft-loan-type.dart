import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'loan-amortization.dart';

class ChamaSoftLoanDetail extends StatefulWidget {
  final String loanName;
  final String dateTime;
  const ChamaSoftLoanDetail(this.loanName, this.dateTime);

  // const ChamaSoftLoanDetail({ Key? key }) : super(key: key);

  @override
  _ChamaSoftLoanDetailState createState() => _ChamaSoftLoanDetailState();
}

class _ChamaSoftLoanDetailState extends State<ChamaSoftLoanDetail> {
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

  var items = <String>[
    'Select Guarantor',
    'John Kim',
    'Sam Doe',
    'James Mandison',
    'Kim Liyan',
    'Victor Moses',
    'Peter Mayron'
  ];
  String dropdownvalue = 'Select Guarantor';

  var items1 = <String>[
    'Select Guarantor 1',
    'John Kim',
    'Sam Doe',
    'James Mandison',
    'Kim Liyan',
    'Victor Moses',
    'Peter Mayron'
  ];
  String dropdownvalue1 = 'Select Guarantor 1';

  var items2 = <String>[
    'Select Guarantor 2',
    'John Kim',
    'Sam Doe',
    'James Mandison',
    'Kim Liyan',
    'Victor Moses',
    'Peter Mayron'
  ];
  String dropdownvalue2 = 'Select Guarantor 2';

  @override
  Widget build(BuildContext context) {
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
              color: Theme.of(context).backgroundColor,
              //   // padding: EdgeInsets.all(0.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
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
                                    text: widget.loanName,
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
                                  // TextFormField(
                                  //   controller: myController,
                                  //   decoration: InputDecoration(
                                  //       floatingLabelBehavior:
                                  //           FloatingLabelBehavior.auto,
                                  //       border: OutlineInputBorder(),
                                  //       contentPadding: new EdgeInsets.symmetric(
                                  //           vertical: 10.0, horizontal: 10.0),
                                  //       labelText: 'Enter The Loan Amount',
                                  //       hintText: 'eg KES 5,000'),
                                  //   keyboardType: TextInputType.number,
                                  //   validator: (amount) {
                                  //     if (amount.isEmpty) {
                                  //       return 'Loan Amount is Required to Procees';
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Guarantors:"),
                            ),
                            Row(
                              children: <Widget>[
                                DropdownButton<String>(
                                  items: items.map((itemsname) {
                                    return DropdownMenuItem(
                                        value: itemsname,
                                        child: Text(itemsname));
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownvalue = newValue;
                                    });
                                  },
                                  value: dropdownvalue,
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: amountTextInputField(
                                      controller: guarantor1Controller,
                                      context: context,
                                      validator: (value) {
                                        if (value == null || value == "") {
                                          return "The field is required";
                                        }
                                        return null;
                                      },
                                      labelText: "Enter Amont",
                                      enabled: true,
                                      onChanged: (value) {
                                        setState(() {});
                                      }),
                                  // child: TextFormField(
                                  //   controller: guarantor1Controller,
                                  //   decoration: InputDecoration(
                                  //     border: OutlineInputBorder(),
                                  //     labelText: "Enter Amount",
                                  //     contentPadding: new EdgeInsets.symmetric(
                                  //         vertical: 10.0, horizontal: 10.0),
                                  //   ),
                                  //   keyboardType: TextInputType.number,
                                  //   validator: (amount) {
                                  //     if (amount.isEmpty) {
                                  //       return 'Amount is Required';
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
                                ))
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                DropdownButton<String>(
                                  items: items1.map((itemsname) {
                                    return DropdownMenuItem(
                                        value: itemsname,
                                        child: Text(itemsname));
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownvalue1 = newValue;
                                    });
                                  },
                                  value: dropdownvalue1,
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: amountTextInputField(
                                      controller: guarantor2Controller,
                                      context: context,
                                      validator: (value) {
                                        if (value == null || value == "") {
                                          return "The field is required";
                                        }
                                        return null;
                                      },
                                      labelText: "Enter Amont",
                                      enabled: true,
                                      onChanged: (value) {
                                        setState(() {});
                                      }),
                                  // child: TextFormField(
                                  //   controller: guarantor2Controller,
                                  //   decoration: InputDecoration(
                                  //     border: OutlineInputBorder(),
                                  //     labelText: "Enter Amount",
                                  //     contentPadding: new EdgeInsets.symmetric(
                                  //         vertical: 10.0, horizontal: 10.0),
                                  //   ),
                                  //   keyboardType: TextInputType.number,
                                  //   validator: (amount) {
                                  //     if (amount.isEmpty) {
                                  //       return 'Amount is Required';
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
                                ))
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                DropdownButton<String>(
                                  items: items2.map((itemsname) {
                                    return DropdownMenuItem(
                                        value: itemsname,
                                        child: Text(itemsname));
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownvalue2 = newValue;
                                    });
                                  },
                                  value: dropdownvalue2,
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: amountTextInputField(
                                      controller: guarantor3Controller,
                                      context: context,
                                      validator: (value) {
                                        if (value == null || value == "") {
                                          return "The field is required";
                                        }
                                        return null;
                                      },
                                      labelText: "Enter Amont",
                                      enabled: true,
                                      onChanged: (value) {
                                        setState(() {});
                                      }),
                                  // child: TextFormField(
                                  //   controller: guarantor3Controller,
                                  //   decoration: InputDecoration(
                                  //     border: OutlineInputBorder(),
                                  //     labelText: "Enter Amount",
                                  //     contentPadding: new EdgeInsets.symmetric(
                                  //         vertical: 7.0, horizontal: 10.0),
                                  //   ),
                                  //   keyboardType: TextInputType.number,
                                  //   validator: (amount) {
                                  //     if (amount.isEmpty) {
                                  //       return 'Amount is Required';
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
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
                                              builder: (BuildContext context) =>
                                                  LoanAmortization(),
                                            ),
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
                                                      children: [
                                                        Column(
                                                          // mainAxisAlignment:
                                                          //     MainAxisAlignment
                                                          //         .start,
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
                                                                text: widget
                                                                    .loanName,
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
                                                                text: widget
                                                                    .dateTime,
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
