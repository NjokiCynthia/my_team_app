// ignore_for_file: unused_import

import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/bankBalancesSummary.dart';
import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/fine_summary.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/summaries.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/screens/login_password.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:chamasoft/config.dart';

class IntroScreen extends StatefulWidget {
  static const namedRoute = "intro-screen";
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  bool _loading = true;

  _dashNav() async {
    String currentGroupId = await getPreference("selectedGroupId");
    dynamic groups = Provider.of<Groups>(context, listen: false);
    // ignore: unused_local_variable
    dynamic groupData = Provider.of<Dashboard>(context, listen: false);
    await groups.fetchAndSetUserGroups();
    await groups.setSelectedGroupId(currentGroupId);
    // await groups.fetchMembers();
    // await groups.fetchContributions();
    // await groups.fetchPayContributions();
    // await groups.fetchLoanTypes();
    // await groups.fetchAccounts();
    // await groups.fetchFineTypes();
    // await groups.fetchGroupMembersOngoingLoans();

    // groups.fetchExpenses();
    // groups.fetchFineCategories();
    // groups.fetchExpenseCategory();
    // groups.fetchGroupNotifications();
    // groups.fetchReportAccountBalances();
    // groups.fetchTransactionStatement();
    // groups.getGroupContributionSummary();
    // groups.getGroupFinesSummary();
    // groups.fetchExpenseSummary();
    // groups.fetchLoansSummary();
    // groups.fetchContributionStatement();
    // groups.fetchMemberContributionStatement();
    // groups.fetchMemberFineStatement();
    // groups.fetchMemberLoans();
    // groups.fetchLoanStatement();
    // groups.fetchExpenseCategories();
    // groups.fetchIncomeCategories();
    // groups.getGroupMembersDetails();
    // await Provider.of<Groups>(context, listen: false).fetchExpenseSummary();
    // await Provider.of<DashboardContributionSummary>(context, listen: false)
    //     .getContributionsSummary(currentGroupId);
    // await Provider.of<DashboardContributionSummary>(context, listen: false)
    //     .getContributionsSummary(currentGroupId);
    // await Provider.of<DashboardFineSummary>(context, listen: false)
    //     .getFinesSummary(currentGroupId);
    // await Provider.of<DashboardFineSummary>(context, listen: false)
    //     .getFinesSummary(currentGroupId);
    // await Provider.of<BalancesDashboardSummary>(context, listen: false)
    //     .getAccountBalancesSummary(currentGroupId);
    // await Provider.of<LoanDashboardSummary>(context, listen: false)
    //     .getDashboardLoanSummary(currentGroupId);
    // await Provider.of<LoanDashboardSummary>(context, listen: false)
    //     .getDashboardLoanSummary(currentGroupId);

    // await groupData.getMemberDashboardData(currentGroupId);
    // await groupData.getGroupDashboardData(currentGroupId);
    // await groupData.getGroupDepositVWithdrawals(currentGroupId);

    Navigator.of(context)
        .pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => ChamasoftDashboard(),
      ),
    )
        .whenComplete(() {
      _loading = false;
    });
  }

  _isFirstTime() async {
    setPreference("currency", "Ksh");
    (await getPreference("isFirstTime") != '')
        ? (await getPreference("isLoggedIn") == 'true')
            ? await Provider.of<Auth>(context, listen: false)
                .setUserProfile()
                .then((_) async {
                (await getPreference("selectedGroupId") != '')
                    ? await _dashNav()
                    : Navigator.of(context)
                        .pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Config.appName.toLowerCase() == "chamasoft"
                                  ? MyGroups()
                                  : LoginPassword(),
                        ),
                      )
                        .whenComplete(() {
                        _loading = false;
                      });
              }).catchError(
                (err) => Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => Login()))
                    .whenComplete(() {
                  _loading = false;
                }),
              )
            : Navigator.of(context)
                .pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => Login()))
                .whenComplete(() {
                _loading = false;
              })
        : setState(() {
            _loading = false;
          });
  }

  @override
  void initState() {
    _isFirstTime();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onIntroEnd(context) {
    setPreference("isFirstTime", "true");
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
  }

  Widget _buildImage(String assetName) {
    return Align(
        child: Image.asset('assets/$assetName.png', width: 280.0),
        alignment: Alignment.bottomCenter);
  }

  @override
  Widget build(BuildContext context) {
    PageDecoration _pageDeco({Color pageColor}) {
      return PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        bodyTextStyle: TextStyle(fontSize: 16.0, color: Colors.white),
        //descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        titlePadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
        pageColor: pageColor,
        imagePadding: EdgeInsets.zero,
      );
    }

    Widget _pageLoading() {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
              SizedBox(height: 10.0),
              subtitle2(
                text: "Fetching data",
                // ignore: deprecated_member_use
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                textAlign: TextAlign.center,
              ),
              subtitle2(
                text: "This won't take long",
                color:
                    // ignore: deprecated_member_use
                    Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor
                        .withOpacity(0.6),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return _loading
        ? _pageLoading()
        : IntroductionScreen(
            key: introKey,
            pages: [
              PageViewModel(
                  titleWidget: heading1(
                      text: "A fix for your Group", color: Colors.white),
                  bodyWidget: subtitle1(
                      text:
                          "Leading book keeping tool for investment groups that handles all your financial administration as you focus on your investments.",
                      color: Colors.white),
                  image: _buildImage('onboarding_1'),
                  decoration: _pageDeco(
                    pageColor: primaryColor.withAlpha(120),
                  )),
              PageViewModel(
                  titleWidget: heading1(
                      text: "...it's easy to use & secure",
                      color: Colors.white),
                  bodyWidget: subtitle1(
                      text:
                          "Financial information stored on ${Config.appName} is only visible to authorized users. Communication with our servers is encrypted.",
                      color: Colors.white),
                  image: _buildImage('onboarding_2'),
                  decoration: _pageDeco(
                    pageColor: primaryColor.withAlpha(240),
                  )),
              PageViewModel(
                  titleWidget: heading1(
                      text: "...accessible everywhere, anytime!",
                      color: Colors.white),
                  bodyWidget: subtitle1(
                      text:
                          "${Config.appName} is available 24/7 from anywhere in the world through various platforms: USSD, Web, Android & iOS. Get started now.",
                      color: Colors.white),
                  image: _buildImage('onboarding_3'),
                  decoration: _pageDeco(
                    pageColor: primaryColor.withAlpha(120),
                  ))
            ],
            globalBackgroundColor: primaryColor.withAlpha(210),
            onDone: () => _onIntroEnd(context),
            //onSkip: () => _onIntroEnd(context),
            showSkipButton: true,
            skipOrBackFlex: 0,
            dotsFlex: 1,
            nextFlex: 0,
            skip: Text("Skip",
                style: TextStyle(
                    fontFamily: 'SegoeUI',
                    fontSize: 16.0,
                    color: Colors.white54)),
            next: Text("Next",
                style: TextStyle(
                    fontFamily: 'SegoeUI',
                    fontSize: 16.0,
                    color: Colors.white)),
            done: Text("Continue",
                style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'SegoeUI',
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            skipStyle: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
            ),
        doneStyle: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
        ),
        nextStyle: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
        ),
            dotsDecorator: DotsDecorator(
                size: Size(10.0, 10.0),
                color: Colors.white54,
                activeSize: Size(16.0, 10.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                activeColor: Colors.white));
  }
}
