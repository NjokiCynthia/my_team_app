import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
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
                                Text(
                                  "From ChamaSoft:  ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'SegoeUI',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  widget.loanName,
                                  // style: TextStyle(
                                  //   fontFamily: 'SegoeUI',
                                  //   fontSize: 12.0,
                                  // ),
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
                                TextFormField(
                                  controller: myController,
                                  decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      border: OutlineInputBorder(),
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      labelText: 'Enter The Loan Amount',
                                      hintText: 'eg KES 5,000'),
                                  keyboardType: TextInputType.number,
                                  validator: (amount) {
                                    if (amount.isEmpty) {
                                      return 'Loan Amount is Required to Procees';
                                    }
                                    return null;
                                  },
                                ),
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
                                      value: itemsname, child: Text(itemsname));
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
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: guarantor1Controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter Amount",
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (amount) {
                                    if (amount.isEmpty) {
                                      return 'Amount is Required';
                                    }
                                    return null;
                                  },
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              DropdownButton<String>(
                                items: items1.map((itemsname) {
                                  return DropdownMenuItem(
                                      value: itemsname, child: Text(itemsname));
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
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: guarantor2Controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter Amount",
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (amount) {
                                    if (amount.isEmpty) {
                                      return 'Amount is Required';
                                    }
                                    return null;
                                  },
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              DropdownButton<String>(
                                items: items2.map((itemsname) {
                                  return DropdownMenuItem(
                                      value: itemsname, child: Text(itemsname));
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
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: guarantor3Controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter Amount",
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 7.0, horizontal: 10.0),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (amount) {
                                    if (amount.isEmpty) {
                                      return 'Amount is Required';
                                    }
                                    return null;
                                  },
                                ),
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
                                    print(
                                        result + int.parse(myController.text));
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
                                              title:
                                                  Text("Confirm Application"),
                                              content: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        // mainAxisAlignment:
                                                        //     MainAxisAlignment
                                                        //         .start,
                                                        children: [
                                                          Text("Loan Type :",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text(
                                                            "Amount KES:",
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text("Refund KES:",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text("Due Date:",
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
                                                          Text(widget.loanName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .end),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text(
                                                            myController.text,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text(
                                                              (int.parse(myController
                                                                          .text) +
                                                                      1000)
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text(widget.dateTime,
                                                              textAlign:
                                                                  TextAlign.end)
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
//  Text(' Loan Type: \t' +
//                                                       widget.loanName),
//                                                   Text(' Amount: KES \t' +
//                                                       myController.text),
//                                                   Text(' Refund: KES \t' +
//                                                       (int.parse(myController
//                                                                   .text) +
//                                                               1000)
//                                                           .toString()),
//                                                   Text(' Due Date: \t' +
//                                                       widget.dateTime),

                                              // content: RichText(
                                              //   text: TextSpan(
                                              //       text: 'Summary',
                                              //       children: const <TextSpan>[
                                              //         TextSpan(text: ' Loan Type: '),
                                              //         TextSpan(text: ' Amount: '),
                                              //         TextSpan(text: ' Refund: '),
                                              //         TextSpan(text: ' Due Date: '),
                                              //       ]),
                                              // ),
                                              actions: [
                                                // ignore: deprecated_member_use
                                                FlatButton(
                                                  // FlatButton widget is used to make a text to work like a button
                                                  textColor: Colors.black,
                                                  onPressed: () => Navigator.pop(
                                                      context,
                                                      false), // function used to perform after pressing the button
                                                  child: Text('CANCEL'),
                                                ),
                                                // ignore: deprecated_member_use
                                                FlatButton(
                                                  textColor: Colors.black,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ApplyLoan()),
                                                    );
                                                  },
                                                  child: Text('PROCEED'),
                                                ),
                                              ],
                                            ));
                                  } else {
                                    guarantor3Controller.clear();
                                    guarantor2Controller.clear();
                                    guarantor1Controller.clear();
                                    Fluttertoast.showToast(
                                        msg: "Something went wrong, Try again",
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
        ));
  }
}
