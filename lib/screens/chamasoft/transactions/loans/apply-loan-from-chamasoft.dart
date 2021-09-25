import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-type.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-chamasoft-form.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'loan-amortization.dart';

class ApplyLoanFromChamasoft extends StatefulWidget {
  // const ChamaSoftLoanDetail({ Key? key }) : super(key: key);

  @override
  _ApplyLoanFromChamasoftState createState() => _ApplyLoanFromChamasoftState();
}

class _ApplyLoanFromChamasoftState extends State<ApplyLoanFromChamasoft> {
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

  bool _isInit = true;
  bool _isLoading = true;
  List<LoanProduct> _loanProducts = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    // get the unreconciled deposits
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
      Provider.of<ChamasoftLoans>(context, listen: false)
          .fetchLoanProducts()
          .then((value) {
        setState(() {
          _isLoading = false;
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
    return _fetchLoanProducts(context).then((value) => true);
  }

  @override
  Widget build(BuildContext context) {
    //LoanType typeLoan;

    _loanProducts =
        Provider.of<ChamasoftLoans>(context, listen: false).getLoanProducts;

    return RefreshIndicator(
        backgroundColor: (themeChangeProvider.darkTheme)
            ? Colors.blueGrey[800]
            : Colors.white,
        onRefresh: () => _fetchData(),
        child: Container(
          decoration: primaryGradient(context),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.9,
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
              Expanded(
                child: _loanProducts.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: true,
                        itemCount: _loanProducts.length,
                        itemBuilder: (context, index) {
                          LoanProduct loanProduct = _loanProducts[index];
                          return Card(
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              borderOnForeground: false,
                              child: Container(
                                decoration: cardDecoration(
                                    gradient: plainCardGradient(context),
                                    context: context),
                                child: ListTile(
                                  title: Text(loanProduct.name),
                                  subtitle: Text(
                                      "${loanProduct.interestRate} % ${loanProduct.loanInterestRatePer} on ${loanProduct.interestType}"),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ApplyLoanFromChamasoftForm(),
                                            settings: RouteSettings(arguments: {
                                              'loanProduct': loanProduct,
                                            })));
                                  },
                                ),
                              ));
                        },
                      )
                    : emptyList(
                        color: Colors.blue[400],
                        iconData: LineAwesomeIcons.angle_double_down,
                        text: "There are no loan types to display"),
              ),
            ],
          ),
        ));
  }
}
