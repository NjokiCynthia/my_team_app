import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/providers/groups.dart';
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
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
// ignore: unused_import
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

// ignore: unused_import
import 'loan-amortization.dart';

class ApplyLoanFromChamasoft extends StatefulWidget {
  final bool isInit;
  final Function updateIsInit;

  ApplyLoanFromChamasoft({this.isInit, this.updateIsInit});

  @override
  _ApplyLoanFromChamasoftState createState() => _ApplyLoanFromChamasoftState();
}

class _ApplyLoanFromChamasoftState extends State<ApplyLoanFromChamasoft> {
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

  bool _isInit = true;
  bool _isLoading = true;
  List<LoanProduct> _loanProducts = [];
  Map<String, dynamic> _formLoadData;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // get the loan products
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  Future<void> _fetchLoanProducts(BuildContext context) async {
    setState(() {
      _isInit = false;
    });

    try {
      // Load formdata values
      Provider.of<Groups>(context, listen: false)
          .loadInitialFormData(
        member: true,
      )
          .then((value) {
        // get the loan products
        Provider.of<ChamasoftLoans>(context, listen: false)
            .fetchLoanProducts()
            .then((_) {
          setState(() {
            _formLoadData = value;

            _isLoading = false;
          });
          // reset parent isInit
          widget.updateIsInit();
        });
      });
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchLoanProducts(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    // reset existing loan products
    Provider.of<ChamasoftLoans>(context, listen: false).resetLoanProducts();
    // fetch loan products
    return _fetchLoanProducts(context).then((value) => true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loanProducts =
        Provider.of<ChamasoftLoans>(context, listen: false).getLoanProducts;

    return RefreshIndicator(
        backgroundColor: (themeChangeProvider.darkTheme)
            ? Colors.blueGrey[800]
            : Colors.white,
        onRefresh: () => _fetchData(),
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              toolTip(
                  context: context,
                  title: "Note that...",
                  message:
                      "Apply quick loan from Chamasoft guaranteed by your savings and fellow group members."),
              _isLoading
                  ? showLinearProgressIndicator()
                  : SizedBox(
                      height: 0.0,
                    ),
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
                                formLoadData: _formLoadData);
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
        ));
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
                      .textSelectionHandleColor,
                  text: loanProduct.name,
                  textAlign: TextAlign.start),
              subtitle: subtitle2(
                  color: Theme.of(context)
                      // ignore: deprecated_member_use
                      .textSelectionHandleColor,
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
