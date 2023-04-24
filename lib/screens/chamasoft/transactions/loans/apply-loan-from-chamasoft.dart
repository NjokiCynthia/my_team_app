import 'package:chamasoft/providers/chamasoft-loans.dart';
// ignore: unused_import
import 'package:chamasoft/screens/chamasoft/models/loan-type.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-chamasoft-form.dart';
// ignore: unused_import
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan.dart';
// ignore: unused_import
import 'package:chamasoft/helpers/theme.dart';
// ignore: unused_import
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
// ignore: unused_import
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
// ignore: unused_import
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// ignore: must_be_immutable
class ApplyLoanFromChamasoft extends StatefulWidget {
  Map<String, dynamic> formLoadData;
  List<LoanProduct> loanProducts;
  ApplyLoanFromChamasoft({this.formLoadData, this.loanProducts});

  @override
  _ApplyLoanFromChamasoftState createState() => _ApplyLoanFromChamasoftState();
}

class _ApplyLoanFromChamasoftState extends State<ApplyLoanFromChamasoft> {
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
    List<LoanProduct> _loanProducts = widget.loanProducts;
    print('loanProducts $_loanProducts');

    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          toolTip(
              context: context,
              title: "Note that...",
              message:
                  "Apply quick loan from Chamasoft guaranteed by your savings and fellow group members."),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.749,
              child: _loanProducts.length > 0
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: true,
                      itemCount: _loanProducts.length,
                      itemBuilder: (context, index) {
                        LoanProduct loanProduct = _loanProducts[index];
                        return ChamasoftLoanProductCard(
                            loanProduct: loanProduct,
                            formLoadData: widget.formLoadData);
                      },
                    )
                  : emptyList(
                      color: Colors.blue[400],
                      iconData: LineAwesomeIcons.angle_double_down,
                      text: "There are no loan products to display"),
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
                      // ignore: deprecated_member_use
                      .textSelectionTheme
                      .selectionHandleColor,
                  text: loanProduct.name,
                  textAlign: TextAlign.start),
              subtitle: subtitle2(
                  color: Theme.of(context)
                      // ignore: deprecated_member_use
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
