// import 'package:chamasoft/providers/groups.dart';
// import 'package:chamasoft/screens/chamasoft/models/loan-type.dart';
// import 'package:chamasoft/screens/chamasoft/transactions/loans/chamasoft-loan-type.dart';
// import 'package:chamasoft/screens/chamasoft/transactions/loans/loan-amortization.dart';
import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/access_token.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-for-individual-amt-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-amt.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-group.dart';
// import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
// import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ApplyLoan extends StatefulWidget {
  final bool isInit;
  final bool isFromGroupActive;
  final bool isFromAmt;
  final bool isFromAmtIndividual;

  ApplyLoan(
      {this.isInit = true,
      this.isFromAmt = false,
      this.isFromAmtIndividual = false,
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
  //bool _isLoading = true;

  double amountInputValue;
  Map<String, dynamic> _formLoadData = {};

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

  bool _isLoading = true;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    setState(() {
      _isInit = widget.isInit;
      _isFromAmt = widget.isFromAmt;
      _isFromGroupActive = widget.isFromGroupActive;
      _isFromAmtIndividual = widget.isFromAmtIndividual;
      if (!_isInit) {
        _isLoading = false;
      }
    });
    super.initState();
    _fetchData();
    amtAuth();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // get the loan types
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  Future<Map<String, dynamic>> amtAuth() async {
    print('I am here');
    final url = 'https://api-accounts.sandbox.co.ke:8627/api/users/login';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    try {
      final postRequest =
          json.encode({"phone": "254797181989", "password": "p@ssword_5"});

      final response =
          await http.post(Uri.parse(url), headers: headers, body: postRequest);
      print('I want to see my resposne');
      print(response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Handle the response data according to your needs\\
        print('I want to see my response data');

        print(responseData);

        final accessToken = responseData['user']['access_token'];

        // Update access token using Provider
        Provider.of<AccessTokenProvider>(context, listen: false)
            .updateAccessToken(accessToken);

        print('access token');

        return responseData;
      } else {
        throw Exception(
            'Failed to authenticate. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error during authentication: $error');
    }
  }

  Future<void> _fetchLoanTypes(BuildContext context) async {
    try {
      // get the form data
      Provider.of<Groups>(context, listen: false)
          .loadInitialFormData(member: true, loanTypes: true)
          .then((value) {
        // get the loan types
        Provider.of<ChamasoftLoans>(context, listen: false)
            .fetchLoanTypes()
            .then((loanTypes) {
          setState(() {
            _formLoadData = value;
            _isInit = false;
            _isLoading = false;
            _loanTypes = Provider.of<Groups>(context, listen: false).loanTypes;
          });
        });
      });
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchLoanTypes(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    // fetch loan types
    return _fetchLoanTypes(context).then((value) => true);
  }

  final formKey = new GlobalKey<FormState>();

  final ValueNotifier<int> _tabIndexBasicToggle = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    // LoanType typeLoan;

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.pop(context),
        // Navigator.of(context)
        //     .popUntil((Route<dynamic> route) => route.isFirst),
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
          // child: RefreshIndicator(
          // backgroundColor: (themeChangeProvider.darkTheme)
          //     ? Colors.blueGrey[800]
          //     : Colors.white,
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
                  Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                    // _isLoading
                    //     ? showLinearProgressIndicator()
                    //     : SizedBox(
                    //         height: 0.0,
                    //       ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                        child:
                            // ValueListenableBuilder(
                            //     valueListenable: _tabIndexBasicToggle,
                            //     builder: (context, currentIndex, _) {
                            //       return
                            FlutterToggleTab(
                          //width: 55.0,
                          height: MediaQuery.of(context).size.height * 0.04,
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
                        )
                        //  }
                        ),
                  ]),

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
                            formLoadData: _formLoadData, loanTypes: _loanTypes),
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
      //  ),
    );
  }
}
