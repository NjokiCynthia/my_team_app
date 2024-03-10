import 'package:chamasoft/providers/chamasoft-loans.dart';

import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-chamasoft-form.dart';

import 'package:chamasoft/widgets/backgrounds.dart';

import 'package:chamasoft/widgets/empty_screens.dart';

import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ApplyIndividualAmtLoan extends StatefulWidget {
  Map<String, dynamic> formLoadData;
  List<LoanProduct> loanProducts;
  ApplyIndividualAmtLoan({this.formLoadData, this.loanProducts});

  @override
  _ApplyIndividualAmtLoanState createState() => _ApplyIndividualAmtLoanState();
}

class _ApplyIndividualAmtLoanState extends State<ApplyIndividualAmtLoan> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          toolTip(
              context: context,
              title: "Note that...",
              message:
                  "Apply quick loan from Amt guaranteed by your savings and fellow group members."),
          SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.749,
                child:
                    //?
                    Text('AMT Individual loans')
                // : emptyList(
                //     color: Colors.blue[400],
                //     iconData: LineAwesomeIcons.angle_double_down,
                //     text: "There are no loan products to display"),
                ),
          ),
        ],
      ),
    );
  }
}

class ChamasoftLoanProductCard extends StatelessWidget {
  const ChamasoftLoanProductCard(
      {Key key, @required this.loanProduct, @required this.formLoadData})
      : super(key: key);

  final LoanProduct loanProduct;
  final Map<String, dynamic> formLoadData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          borderOnForeground: false,
          child: Container(
            decoration: cardDecoration(
                gradient: plainCardGradient(context), context: context),
            child: ListTile(
              title: subtitle1(
                  color: Theme.of(context)
                      
                      .textSelectionTheme
                      .selectionHandleColor,
                  text: loanProduct.name,
                  textAlign: TextAlign.start),
              subtitle: subtitle2(
                  color: Theme.of(context)
                      
                      .textSelectionTheme
                      .selectionHandleColor,
                  text: loanProduct.description,
                  textAlign: TextAlign.start),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ApplyLoanFromChamasoftForm(),
                        settings: RouteSettings(arguments: {
                          'loanProduct': loanProduct,
                          'formLoadData': formLoadData
                        })));
              },
            ),
          )),
    );
  }
}
