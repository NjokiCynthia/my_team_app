import 'package:chamasoft/config.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/reports/deposit-receipts.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/group-loan-applications.dart';
import 'package:chamasoft/screens/chamasoft/reports/loan-applications.dart';
import 'package:chamasoft/screens/chamasoft/reports/member-statement.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/contribution-statement.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/loan-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/withdrawal_receipts.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/svg-icons.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/list-invoices.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/showCase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/contribution-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/expense-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/group-loans-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/transaction-statement.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/account-balances.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class ChamasoftReports extends StatefulWidget {
  ChamasoftReports({
    this.appBarElevation,
  });
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING_REPORTS =
      "PREFERENCES_IS_FIRST_LAUNCH_STRING_REPORTS";

  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftReportsState createState() => _ChamasoftReportsState();
}

class _ChamasoftReportsState extends State<ChamasoftReports> {
  ScrollController _scrollController;

  final contributionStatementKey = GlobalKey();
  final fineStatementKey = GlobalKey();
  final loansummaryKey = GlobalKey();
  final loanapplicationkey = GlobalKey();
  final depositRecieptKey = GlobalKey();
  final withdrawalRecieptKey = GlobalKey();
  final groupReortKey = GlobalKey();
  final memberStatementKey = GlobalKey();

  BuildContext reportContext;

  void _scrollListener() {
    widget.appBarElevation(_scrollController.offset);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _isFirstLaunch().then((result) {
    //     if (result)
    //       ShowCaseWidget.of(reportContext).startShowCase([
    //         contributionStatementKey,
    //         fineStatementKey,
    //         loansummaryKey,
    //         depositRecieptKey,
    //         withdrawalRecieptKey,
    //         groupReortKey,
    //         memberStatementKey,
    //       ]);
    //   });
    // });

    super.initState();
  }

  // ignore: unused_element
  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = sharedPreferences.getBool(
            ChamasoftReports.PREFERENCES_IS_FIRST_LAUNCH_STRING_REPORTS) ??
        true;

    if (isFirstLaunch)
      sharedPreferences.setBool(
          ChamasoftReports.PREFERENCES_IS_FIRST_LAUNCH_STRING_REPORTS, false);

    return isFirstLaunch;
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context)
        .pushReplacementNamed(ChamasoftDashboard.namedRoute);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context, listen: false).getCurrentGroup();
    // final groupObject =
    //     Provider.of<Groups>(context, listen: false).getCurrentGroup();
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;

    return ShowCaseWidget(builder: Builder(
      builder: (context) {
        reportContext = context;
        List<Widget> memberOptions = [
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: contributionStatementKey,
            description: "View and Download your Transaction summary from here",
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['transaction'],
                    title: currentLanguage == 'English'
                        ? 'CONTRIBUTION'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('CONTRIBUTION') ??
                            'CONTRIBUTION',
                    // 'CONTRIBUTION',
                    subtitle: currentLanguage == 'English'
                        ? 'STATEMENT'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('STATEMENT') ??
                            'STATEMENT',
                    //'STATEMENT',
                    color: Colors.white,
                    isHighlighted: true,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ContributionStatement(
                                statementFlag: CONTRIBUTION_STATEMENT),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: fineStatementKey,
            description: "View and Download your Fine summary from here",
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['invoice'],
                    title: currentLanguage == 'English'
                        ? 'FINE'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('FINE') ??
                            'FINE',
                    //'FINE',
                    subtitle: currentLanguage == 'English'
                        ? 'STATEMENT'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('STATEMENT') ??
                            'STATEMENT',
                    //'STATEMENT',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ContributionStatement(statementFlag: FINE_STATEMENT),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: loansummaryKey,
            description: "View, Download and Share your Loan summary from here",
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['expense'],
                    title: currentLanguage == 'English'
                        ? 'LOAN'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('LOAN') ??
                            'LOAN',
                    //'LOAN',
                    subtitle: currentLanguage == 'English'
                        ? 'SUMMARY'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('SUMMARY') ??
                            'SUMMARY',
                    //'SUMMARY',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => LoanSummary(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
          Visibility(
            visible: false,
            child: customShowCase(
              key: loanapplicationkey,
              description:
                  "View, Download and Share your Loan applications from here",
              child: Container(
                  width: 132.0,
                  child: svgGridButton(
                      context: context,
                      icon: customIcons['refund'],
                      title: currentLanguage == 'English'
                          ? 'LOAN'
                          : Provider.of<TranslationProvider>(context,
                                      listen: false)
                                  .translate('LOAN') ??
                              'LOAN',
                      //'LOAN',
                      subtitle: currentLanguage == 'English'
                          ? 'APPLICATIONS'
                          : Provider.of<TranslationProvider>(context,
                                      listen: false)
                                  .translate('APPLICATIONS') ??
                              'APPLICATIONS',
                      //'SUMMARY',
                      color: Config.appName.toLowerCase() == "chamasoft"
                          ? Colors.blue[400]
                          : Theme.of(context).primaryColor,
                      isHighlighted: false,
                      action: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoanApplications(),
                              settings: RouteSettings(arguments: 0))),
                      margin: 0,
                      imageHeight: 100.0)),
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
        ];

        List<Widget> transactionOptions = [
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: depositRecieptKey,
            description:
                "View, Download and Share your Deposit Reciept from here",
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['cash-in-hand'],
                    title: 'DEPOSIT',
                    subtitle: 'RECEIPTS',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => DepositReceipts(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: withdrawalRecieptKey,
            description:
                "View, Download and Share your Withdrwal Reciept from here",
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['cash-register'],
                    title: 'WITHDRAWAL',
                    subtitle: 'RECEIPTS',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => WithdrawalReceipts(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
        ];

        List<Widget> groupOptions = [
          SizedBox(
            width: 16.0,
          ),
          Container(
              width: 132.0,
              child: svgGridButton(
                  context: context,
                  icon: customIcons['bank-cards'],
                  title: currentLanguage == 'English'
                      ? 'ACCOUNT'
                      : Provider.of<TranslationProvider>(context, listen: false)
                              .translate('ACCOUNT') ??
                          'ACCOUNT',
                  //'ACCOUNT',
                  subtitle: currentLanguage == 'English'
                      ? 'BALANCES'
                      : Provider.of<TranslationProvider>(context, listen: false)
                              .translate('BALANCES') ??
                          'BALANCES',
                  //'BALANCES',
                  color: Config.appName.toLowerCase() == "chamasoft"
                      ? Colors.blue[400]
                      : Theme.of(context).primaryColor,
                  isHighlighted: false,
                  action: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AccountBalances(),
                      settings: RouteSettings(arguments: 0))),
                  margin: 0,
                  imageHeight: 100.0)),
          SizedBox(
            width: 16.0,
          ),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['money-bag'],
                    title: currentLanguage == 'English'
                        ? 'CONTRIBUTION'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('CONTRIBUTION') ??
                            'CONTRIBUTION',
                    //'CONTRIBUTION',
                    subtitle: currentLanguage == 'English'
                        ? 'SUMMARY'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('SUMMARY') ??
                            'SUMMARY',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ContributionSummary(),
                        settings:
                            RouteSettings(arguments: CONTRIBUTION_STATEMENT))),
                    margin: 0,
                    imageHeight: 100.0)),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            SizedBox(
              width: 16.0,
            ),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['expense'],
                    title: currentLanguage == 'English'
                        ? 'FINE'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('FINE') ??
                            'FINE',
                    subtitle: currentLanguage == 'English'
                        ? 'SUMMARY'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('SUMMARY') ??
                            'SUMMARY',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ContributionSummary(),
                        settings: RouteSettings(arguments: FINE_STATEMENT))),
                    margin: 0,
                    imageHeight: 100.0)),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            SizedBox(
              width: 16.0,
            ),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['transaction'],
                    title: currentLanguage == 'English'
                        ? 'LOAN'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('LOAN') ??
                            'LOAN',
                    subtitle: currentLanguage == 'English'
                        ? 'SUMMARY'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('SUMMARY') ??
                            'SUMMARY',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => GroupLoansSummary())),
                    margin: 0,
                    imageHeight: 100.0)),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            SizedBox(
              width: 16.0,
            ),
          Container(
              width: 132.0,
              child: svgGridButton(
                  context: context,
                  icon: customIcons['card-payment'],
                  title: 'EXPENSE',
                  subtitle: currentLanguage == 'English'
                      ? 'SUMMARY'
                      : Provider.of<TranslationProvider>(context, listen: false)
                              .translate('SUMMARY') ??
                          'SUMMARY',
                  color: Config.appName.toLowerCase() == "chamasoft"
                      ? Colors.blue[400]
                      : Theme.of(context).primaryColor,
                  isHighlighted: false,
                  action: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ExpenseSummary())),
                  margin: 0,
                  imageHeight: 100.0)),
          SizedBox(
            width: 16.0,
          ),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['invoice'],
                    title: 'TRANSACTION',
                    subtitle: currentLanguage == 'English'
                        ? 'STATEMENT'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('STATEMENT') ??
                            'STATEMENT',
                    //'STATEMENT',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TransactionStatement())),
                    margin: 0,
                    imageHeight: 100.0)),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            SizedBox(
              width: 16.0,
            ),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            Visibility(
              visible: false,
              child: Container(
                  width: 132.0,
                  child: svgGridButton(
                      context: context,
                      icon: customIcons['refund'],
                      title: 'LOAN',
                      subtitle: currentLanguage == 'English'
                          ? 'APPLICATIONS'
                          : Provider.of<TranslationProvider>(context,
                                      listen: false)
                                  .translate('APPLICATIONS') ??
                              'APPLICATIONS',
                      //'STATEMENT',
                      color: Config.appName.toLowerCase() == "chamasoft"
                          ? Colors.blue[400]
                          : Theme.of(context).primaryColor,
                      isHighlighted: false,
                      action: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  GroupLoanApplications())),
                      margin: 0,
                      imageHeight: 100.0)),
            ),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            SizedBox(
              width: 16.0,
            ),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['group'],
                    title: 'MEMBER',
                    subtitle: currentLanguage == 'English'
                        ? 'INVOICES'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('INVOICES') ??
                            'INVOICES',
                    //'STATEMENT',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ListInvoices())),
                    margin: 0,
                    imageHeight: 100.0)),
          if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
            SizedBox(
              width: 16.0,
            ),
        ];

        List<Widget> statementOptions = [
          SizedBox(
            width: 16.0,
          ),
          group.isGroupAdmin
              ? customShowCase(
                  key: memberStatementKey,
                  description:
                      "View, Download and Share your members Transaction statements and Fine statements",
                  child: Container(
                      width: 132.0,
                      child: svgGridButton(
                          context: context,
                          icon: customIcons['transaction'],
                          title: 'MEMBER',
                          subtitle: currentLanguage == 'English'
                              ? 'STATETMENTS'
                              : Provider.of<TranslationProvider>(context,
                                          listen: false)
                                      .translate('STATEMENT') ??
                                  'STATEMENT',
                          // 'STATEMENTS',
                          color: Config.appName.toLowerCase() == "chamasoft"
                              ? Colors.blue[400]
                              : Theme.of(context).primaryColor,
                          isHighlighted: false,
                          action: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MemeberSatement())),
                          margin: 0,
                          imageHeight: 100.0)),
                )
              : SizedBox(
                  width: 16.0,
                ),
        ];

        return new WillPopScope(
            onWillPop: _onWillPop,
            child: SafeArea(
                child: SingleChildScrollView(
                    // controller: _scrollController,
                    child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Your Reports",
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontFamily: 'SegoeUI',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Feather.more_horizontal,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {})
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Container(
                  height: 160.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                    physics: BouncingScrollPhysics(),
                    children: memberOptions,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Transaction Reports",
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontFamily: 'SegoeUI',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Feather.more_horizontal,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {})
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Container(
                  height: 160.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                    physics: BouncingScrollPhysics(),
                    children: transactionOptions,
                  ),
                ),
              ),
              Visibility(
                visible: group.isGroupAdmin ||
                    !group.isGroupAdmin &&
                        !group.enablehidegroupbalancestoMembers,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Group Reports",
                        style: TextStyle(
                          color: Colors.blueGrey[400],
                          fontFamily: 'SegoeUI',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Feather.more_horizontal,
                            color: Colors.blueGrey,
                          ),
                          onPressed: () {})
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Container(
                  height: 160.0,
                  child: customShowCase(
                    key: groupReortKey,
                    description:
                        "View, Download and Share group Account Balances, Contribution Summary, fine Summary,Loan Summary, Expenses Summary and Transaction Statements from here",
                    child: Visibility(
                      visible: group.isGroupAdmin ||
                          !group.isGroupAdmin &&
                              !group.enablehidegroupbalancestoMembers,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        physics: BouncingScrollPhysics(),
                        children: groupOptions,
                      ),
                    ),
                  ),
                ),
              ),
              group.isGroupAdmin
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            currentLanguage == 'English'
                                ? 'Statements'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate('Statements') ??
                                    'Statements',
                            //  "Statements",
                            style: TextStyle(
                              color: Colors.blueGrey[400],
                              fontFamily: 'SegoeUI',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Feather.more_horizontal,
                                color: Colors.blueGrey,
                              ),
                              onPressed: () {})
                        ],
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Container(
                  height: 160.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                    physics: BouncingScrollPhysics(),
                    children: statementOptions,
                  ),
                ),
              ),
            ])))
            // child: OrientationBuilder(
            //   builder: (context, orientation) {
            //     return GridView.count(
            //       controller: _scrollController,
            //       padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
            //       crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
            //       children: List.generate(list.length, (index) {
            //         ReportMenuSvg menu = list[index];
            //         return svgGridButton(
            //             context: context,
            //             icon: menu.icon,
            //             title: menu.title,
            //             subtitle: menu.subtitle,
            //             color: (index == list.length - 1) ? Colors.white : Colors.blue[400],
            //             isHighlighted: (index == list.length - 1) ? true : false,
            //             action: () => navigate(index),
            //             margin: 12);
            //       }),
            //     );
            //   },
            // )
            );
      },
    ));
  }
}
