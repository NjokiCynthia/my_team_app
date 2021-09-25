// import 'package:chamasoft/providers/groups.dart';
// import 'package:chamasoft/screens/chamasoft/models/loan-type.dart';
// import 'package:chamasoft/screens/chamasoft/transactions/loans/chamasoft-loan-type.dart';
// import 'package:chamasoft/screens/chamasoft/transactions/loans/loan-amortization.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-chamasoft.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-group.dart';
// import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
// import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../../dashboard.dart';

class ApplyLoan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ApplyLoanState();
  }
}

class ApplyLoanState extends State<ApplyLoan> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  bool _isShow = true;
  bool _isHiden = false;
  bool _isInit = true;

  double amountInputValue;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  void _updateIsInit() {
    setState(() {
      _isInit = false;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // LoanType typeLoan;

    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ChamasoftDashboard(),
            ),
          ),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: "Apply Loan",
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          color: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Colors.white,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: FlutterToggleTab(
                          width: 55.0,
                          height: MediaQuery.of(context).size.height * 0.04,
                          borderRadius: 10.0,
                          labels: ['From Group', 'From ChamaSoft'],
                          initialIndex: 0,
                          selectedLabelIndex: (index) {
                            setState(() {
                              if (index == 0) {
                                _isShow = true;
                                _isHiden = false;
                              }
                              if (index == 1) {
                                _isShow = false;
                                _isHiden = true;
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
                        ),
                      )
                    ],
                  ),
                  //Group loans
                  Container(
                    child: Visibility(
                      visible: _isShow,
                      child: ApplyLoanFromGroup(),
                    ),
                  ),
                  //Chamasoft loans
                  Container(
                    child: Visibility(
                        visible: _isHiden,
                        child: ApplyLoanFromChamasoft(
                          isInit: _isInit,
                          updateIsInit: _updateIsInit,
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
