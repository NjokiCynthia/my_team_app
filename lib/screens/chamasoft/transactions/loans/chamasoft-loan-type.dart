import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ChamaSoftLoanDetail extends StatefulWidget {
  // const ChamaSoftLoanDetail({ Key? key }) : super(key: key);

  @override
  _ChamaSoftLoanDetailState createState() => _ChamaSoftLoanDetailState();
}

class _ChamaSoftLoanDetailState extends State<ChamaSoftLoanDetail> {
  double _appBarElevation = 0;

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
              Column(
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
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              labelText: 'Enter The Loan Amount',
                              hintText: 'eg KES 5,000'),
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
                  )
                ],
              )

              //SizedBox(height: 10.0),
            ],
          ),
        ),

        // child: Container(
        //   color: Theme.of(context).backgroundColor,
        //   // padding: EdgeInsets.all(0.0),
        //   height: MediaQuery.of(context).size.height,
        //   // width: MediaQuery.of(context).size.width,
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.all(16.0),
        //         child: Column(
        //           children: [
        //             Center(
        //               child: const Text.rich(TextSpan(
        //                   text: "From chamaSoft:" + " ",
        //                   style: TextStyle(
        //                       color: (Colors.blueGrey),
        //                       fontFamily: 'SegoeUI',
        //                       fontSize: 18.0,
        //                       fontWeight: FontWeight.w700),
        //                   children: <TextSpan>[
        //                     TextSpan(
        //                         text: 'Business Loan',
        //                         style: TextStyle(fontSize: 16.0))
        //                   ])),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Row(
        //         children: [
        //           // const Text.rich(TextSpan(
        //           //   text: "Amount, KES:" + " ",
        //           //   style: TextStyle(
        //           //       color: (Colors.blueGrey),
        //           //       fontFamily: 'SegoeUI',
        //           //       fontSize: 18.0,
        //           //       fontWeight: FontWeight.w700),
        //           // )),
        //           // SizedBox(
        //           //   width: 20.0,
        //           // ),
        //           TextField(
        //             decoration: InputDecoration(
        //               floatingLabelBehavior: FloatingLabelBehavior.auto,
        //               border: OutlineInputBorder(),
        //               hintText: 'Amount!',
        //             ),
        //             // validator: (value) {
        //             //   if (value == null || value.isEmpty) {
        //             //     return 'Amount is required.';
        //             //   }
        //             //   return null;
        //             // },
        //           )
        //         ],
        //       )
        //     ],
        //   ),
        // ),
      ),
      // ),
    );
  }
}
