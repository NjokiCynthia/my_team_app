// import 'package:chamasoft/providers/groups.dart';
// import 'package:chamasoft/screens/chamasoft/models/loan-type.dart';
// import 'package:chamasoft/screens/chamasoft/transactions/loans/chamasoft-loan-type.dart';
// import 'package:chamasoft/screens/chamasoft/transactions/loans/loan-amortization.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-for-individual-amt-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-amt.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-chamasoft.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-group.dart';
// import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
// import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ApplyLoan extends StatefulWidget {
  final bool isInit;
  final bool isFromGroupActive;
  final bool isFromChamasoftActive;

  ApplyLoan(
      {this.isInit = true,
      this.isFromChamasoftActive = false,
      this.isFromGroupActive = true});
  @override
  State<StatefulWidget> createState() {
    return ApplyLoanState();
  }
}

class ApplyLoanState extends State<ApplyLoan> {
  double _appBarElevation = 0;
  ScrollController _scrollController = ScrollController();

  bool _isFromGroupActive = true;
  bool _isFromAmt = false;
  bool _isFromAmtIndividual = false;
  bool _isInit = true;
  bool _isLoading = true;

  double amountInputValue;
  Map<String, dynamic> _formLoadData = {};
  List<LoanProduct> _loanProducts = [];
  List<LoanType> _loanTypes = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    setState(() {
      _isInit = widget.isInit;
      _isFromAmt = widget.isFromChamasoftActive;
      _isFromGroupActive = widget.isFromGroupActive;
      if (!_isInit) {
        _isLoading = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     _fetchDefaultValues(context);
  //   }
  //   super.didChangeDependencies();
  // }
  // @override
  // void didChangeDependencies() {
  //   // get the loan products
  //   if (_isInit)
  //     WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  //   super.didChangeDependencies();
  // }

  // fetch loan products
  // Future<void> _fetchLoanProducts(BuildContext context) async {
  //   try {
  //     // get the form data
  //     Provider.of<Groups>(context, listen: false)
  //         .loadInitialFormData(member: true, loanTypes: true)
  //         .then((value) {
  //       // get the loan products
  //       Provider.of<ChamasoftLoans>(context, listen: false)
  //           .fetchLoanProducts()
  //           .then((loanProducts) {
  //         setState(() {
  //           _loanProducts = loanProducts;
  //           _formLoadData = value;
  //           _isInit = false;
  //           _isLoading = false;
  //           _loanTypes = Provider.of<Groups>(context, listen: false).loanTypes;
  //         });
  //       });
  //     });
  //   } on CustomException catch (error) {
  //     StatusHandler().handleStatus(
  //         context: context,
  //         error: error,
  //         callback: () {
  //           _fetchLoanProducts(context);
  //         },
  //         scaffoldState: _scaffoldKey.currentState);
  //   }
  // }

  // Future<bool> _fetchData() async {
  //   // fetch loan products
  //   return _fetchLoanProducts(context).then((value) => true);
  // }

  final formKey = new GlobalKey<FormState>();

  final ValueNotifier<int> _tabIndexBasicToggle = ValueNotifier(1);
  @override
  Widget build(BuildContext context) {
    // LoanType typeLoan;

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context)
            .popUntil((Route<dynamic> route) => route.isFirst),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Apply Loan",
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          color: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Colors.white,
          height: MediaQuery.of(context).size.height * 0.9,
          child: RefreshIndicator(
            backgroundColor: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Colors.white,
            //onRefresh: () => _fetchData(),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: EdgeInsets.all(0.0),
                width: MediaQuery.of(context).size.width,
                decoration: primaryGradient(context),
                //Switches
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _isLoading
                            ? showLinearProgressIndicator()
                            : SizedBox(
                                height: 0.0,
                              ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                          child: ValueListenableBuilder(
                              valueListenable: _tabIndexBasicToggle,
                              builder: (context, currentIndex, _) {
                                return FlutterToggleTab(
                                  //width: 55.0,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  borderRadius: 10.0,

                                  labels: [
                                    'From Group',
                                    'From AMT',
                                    'AMT Individual Loans'
                                  ],
                                  selectedIndex: _tabIndexBasicToggle.value,
                                  selectedLabelIndex: (index) {
                                    _tabIndexBasicToggle.value = index;
                                    setState(() {
                                      if (index == 0) {
                                        _isFromGroupActive = true;
                                        _isFromAmt = false;
                                        _isFromAmtIndividual = false;
                                      }
                                      if (index == 1) {
                                        _isFromAmt = true;
                                        _isFromGroupActive = false;
                                        _isFromAmtIndividual = false;
                                      }
                                      if (index == 2) {
                                        _isFromAmtIndividual = true;
                                        _isFromAmt = false;
                                        _isFromGroupActive = false;
                                      }
                                    });
                                  },
                                  selectedBackgroundColors: [Colors.grey],
                                  unSelectedBackgroundColors: [Colors.white70],
                                  selectedTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                  unSelectedTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400),
                                );
                              }),
                        )
                      ],
                    ),
//                     Padding(
//   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//   child: isAdmin
//       ? FlutterToggleTab(
//           width: 55.0,
//           height: MediaQuery.of(context).size.height * 0.04,
//           borderRadius: 10.0,
//           labels: ['From Group', 'From AMT'],
//           selectedIndex: 0,
//           selectedLabelIndex: (index) {
//             setState(() {
//               if (index == 0) {
//                 _isFromGroupActive = true;
//                 _isFromChamasoftActive = false;
//               }
//               if (index == 1) {
//                 _isFromChamasoftActive = true;
//                 _isFromGroupActive = false;
//               }
//             });
//           },
//           selectedBackgroundColors: [Colors.grey],
//           unSelectedBackgroundColors: [Colors.white70],
//           selectedTextStyle: TextStyle(
//               color: Colors.white,
//               fontSize: 12.0,
//               fontWeight: FontWeight.w600),
//           unSelectedTextStyle: TextStyle(
//               color: Colors.black,
//               fontSize: 10.0,
//               fontWeight: FontWeight.w400),
//         )
//       : FlutterToggleTab(
//           width: 55.0,
//           height: MediaQuery.of(context).size.height * 0.04,
//           borderRadius: 10.0,
//           labels: ['From AMT'],
//           selectedIndex: 0,
//           selectedLabelIndex: (index) {
//             setState(() {
//               // Handle selected index for members
//             });
//           },
//           selectedBackgroundColors: [Colors.grey],
//           unSelectedBackgroundColors: [Colors.white70],
//           selectedTextStyle: TextStyle(
//               color: Colors.white,
//               fontSize: 12.0,
//               fontWeight: FontWeight.w600),
//           unSelectedTextStyle: TextStyle(
//               color: Colors.black,
//               fontSize: 10.0,
//               fontWeight: FontWeight.w400),
//         ),
// ),

                    //Group loans
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Visibility(
                          visible: _isFromGroupActive,
                          child: ApplyLoanFromGroup(
                              formLoadData: _formLoadData,
                              loanTypes: _loanTypes),
                        ),
                      ),
                    ),
                    //AMt loans
                    Container(
                      child: Visibility(
                          visible: _isFromAmt, child: ApplyLoanFromAmt()),
                    ),
                    Container(
                      child: Visibility(
                          visible: _isFromAmtIndividual,
                          child: ApplyIndividualAmtLoan()),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
