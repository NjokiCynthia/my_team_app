import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'loan-amortization.dart';

class ChamaSoftLoanDetail extends StatefulWidget {
  // const ChamaSoftLoanDetail({ Key? key }) : super(key: key);

  @override
  _ChamaSoftLoanDetailState createState() => _ChamaSoftLoanDetailState();
}

class _ChamaSoftLoanDetailState extends State<ChamaSoftLoanDetail> {
  double _appBarElevation = 0;

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
      body:
          /*GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child:*/
          SingleChildScrollView(
        child: Container(
          color: Theme.of(context).backgroundColor,
          //   // padding: EdgeInsets.all(0.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("From Chama Soft:  "),
                          Text("Business Loan"),
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
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                labelText: 'Enter The Loan Amount',
                                hintText: 'eg KES 5,000'),
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Amount",
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                            ),
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Amount",
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                            ),
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Amount",
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 7.0, horizontal: 10.0),
                            ),
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
                            'By applying for this loan you agree to the ': {},
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
                          onPressed: () {}),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
