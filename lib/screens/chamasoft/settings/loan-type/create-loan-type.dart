import 'package:chamasoft/screens/chamasoft/settings/loan-type/loan-fees-and-guarantors.dart';
import 'package:chamasoft/screens/chamasoft/settings/loan-type/loan-type-fines.dart';
import 'package:chamasoft/screens/chamasoft/settings/loan-type/loan-type-settings.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class CreateLoanType extends StatefulWidget {
  @override
  _CreateLoanTypeState createState() => _CreateLoanTypeState();
}

class _CreateLoanTypeState extends State<CreateLoanType>
    with SingleTickerProviderStateMixin {
  double _appBarElevation = 0;
  PageController _pageController;

  //Loan Details
  String loanTypeName = '';
  int loanAmountTypeId;
  double minimumLoanAmount;
  double maximumLoanAmount;
  double timesNumberOfSavings;

  int interestTypeId;
  bool enableLoanReducingBalanceRecalculation = false;
  double loanInterestRate;
  int loanInterestRatePerId;
  int loanRepaymentTypeId;
  double fixedRepaymentPeriod;
  double minimumRepaymentPeriod;
  double maximumRepaymentPeriod;

  //Fines
  bool enableLateLoanRepaymentFines = false;
  int lateLoanPaymentFineTypeId;

  int oneOffFineTypeId;
  double oneOffFixedAmount;
  double oneOffPercentage;
  int oneOffPercentageOnId;

  double fixedFineAmount;
  int fixedFineFrequencyId;
  int fixedFineAmountFrequencyOnId;

  double percentageFineRate;
  int percentageFineFrequencyId;
  int percentageFineOnId;

  bool enableFinesForOutstandingBalances = false;
  int outstandingBalanceFineTypeId;

  double outstandingLoanBalanceOneOffFineAmount;

  double outstandingLoanBalanceFixedFineAmount;
  int outstandingLoanBalanceFixedFineFrequencyId;

  double outstandingLoanBalancePercentageFineRate;
  int outstandingLoanBalancePercentageFineFrequencyId;
  int outstandingLoanBalancePercentageFineChargedOnId;

  //General Details
  bool enableLoanGuarantors = false;

  int guarantorOptionId;
  int minimumAllowedGuarantors;

  bool chargeLoanProcessingFee = false;

  int loanProcessingFeeTypeId;

  double loanProcessingFeeAmount;
  double loanProcessingFeePercentage;
  int loanProcessingFeePercentageChargedOnId;

  int currentPage = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageTabbedAppbar(
        context: context,
        title: "Create Loan Type",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Divider(
                        thickness: 5.0,
                        indent: 10,
                        endIndent: 10,
                        color:
                            currentPage == 0 ? primaryColor : Color(0xFFAEAEAE),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Divider(
                        thickness: 5.0,
                        indent: 10,
                        endIndent: 10,
                        color:
                            currentPage == 1 ? primaryColor : Color(0xFFAEAEAE),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Divider(
                        thickness: 5.0,
                        indent: 10,
                        endIndent: 10,
                        color:
                            currentPage == 2 ? primaryColor : Color(0xFFAEAEAE),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  new LoanTypeSettings(
                    onButtonPressed: () {
                      print("Triggered");
                      if (_pageController.hasClients) {
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                      setState(() {
                        currentPage = 1;
                      });
                    },
                  ),
                  new LoanTypeFines(onButtonPressed: () {
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }

                    setState(() {
                      currentPage = 2;
                    });
                  }),
                  new LoanFeesAndGuarantors(onButtonPressed: () {})
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
