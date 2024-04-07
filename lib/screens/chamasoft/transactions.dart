// ignore_for_file: unused_import, unused_field

import 'package:chamasoft/config.dart';
import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/notification_summary.dart';
import 'package:chamasoft/providers/recent-transactions.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/bank-loan-repayments.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/record-contribution-refund.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/record-expense.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/reconcile-deposit-list.dart';
import 'package:chamasoft/screens/chamasoft/transactions/expenditure/reconcile-withdrawal-list.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-bank-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-contribution-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-fine-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-income.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-miscellaneous-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/account-to-account-transfer.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/create-invoice.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/fine-member.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/send-to-mobile.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/create-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/record-loan-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan-applications.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal-requests.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review_withdrawal_request.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/withdrawal-purpose.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/svg-icons.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/showCase.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'reports/member/contribution-statement.dart';

class ChamasoftTransactions extends StatefulWidget {
  static String namedRoute = "/transactions";
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING_TRANSACTION =
      "PREFERENCES_IS_FIRST_LAUNCH_STRING_TRANSACTION";

  final int unreconciledDepositCountfromDepositList;

  ChamasoftTransactions({
    this.unreconciledDepositCountfromDepositList,
    this.appBarElevation,
  });

  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftTransactionsState createState() => _ChamasoftTransactionsState();
}

class _ChamasoftTransactionsState extends State<ChamasoftTransactions> {
  ScrollController _scrollController;
  List<Map> deposits = [];
  List<Map> withdrawals = [];
  final createWithdrawalKey = GlobalKey();
  final reviewWithdrawalKey = GlobalKey();
  final recordDepositSectionKey = GlobalKey();
  final reconcileWithdralKey = GlobalKey();
  final expensesKey = GlobalKey();
  final contributionRefundKey = GlobalKey();
  final recordMemberLoan = GlobalKey();
  final recordRepaymentKey = GlobalKey();
  final bankLoanRepaymentKey = GlobalKey();
  final loanApprovalKey = GlobalKey();
  final fineMemberKey = GlobalKey();
  final accountTransferKey = GlobalKey();
  final sendToMobileKey = GlobalKey();
  int _information = 0;

  BuildContext transactionsContext;

  // final reconcileDepositKey = GlobalKey();
  // final contributionPayementKey = GlobalKey();
  // final finePayementKey = GlobalKey();
  // final incomeKey = GlobalKey();
  // final miscellaneousKey = GlobalKey();
  // final bankLoanKey = GlobalKey();

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
    //       ShowCaseWidget.of(transactionsContext).startShowCase([
    //         createWithdrawalKey,
    //         reviewWithdrawalKey,
    //         recordDepositSectionKey,
    //         expensesKey,
    //         contributionRefundKey,
    //         recordMemberLoan,
    //         recordRepaymentKey,
    //         bankLoanRepaymentKey,
    //         fineMemberKey,
    //         accountTransferKey,
    //         reconcileWithdralKey,
    //       ]);
    //   });
    // });
    super.initState();
  }

  // contributionPayementKey,
  // finePayementKey,
  // incomeKey,
  // miscellaneousKey,
  // bankLoanKey,
  // reconcileDepositKey,

  // ignore: unused_element
  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = sharedPreferences.getBool(ChamasoftTransactions
            .PREFERENCES_IS_FIRST_LAUNCH_STRING_TRANSACTION) ??
        true;

    if (isFirstLaunch)
      sharedPreferences.setBool(
          ChamasoftTransactions.PREFERENCES_IS_FIRST_LAUNCH_STRING_TRANSACTION,
          false);

    return isFirstLaunch;
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context)
        .pushReplacementNamed(ChamasoftDashboard.namedRoute);
    return null;
  }

  void updateInformation(int unreconciledDepositCountfromDepositList) {
    setState(() => _information = unreconciledDepositCountfromDepositList);
  }

  void _toUnreconciledDepositList(BuildContext context) async {
    final unreconciledDepositCountfromDepositList = Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext ctx) => ReconcileDepositList()));
    updateInformation(await unreconciledDepositCountfromDepositList);
  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context, listen: false).getCurrentGroup();

    /*  final List<RecentTransactionSummary> recentTransactions =
        Provider.of<Dashboard>(context, listen: false).recentMemberTransactions; */
    final List<NewRecentTransactionSummary> recentTransactions =
        Provider.of<MemberRecentTransaction>(context, listen: false)
            .recentTransactions;
    if (recentTransactions.length > 10) {
      recentTransactions.length = 10;
    }

    /*  final int unreconciledDepositCount =
        Provider.of<Dashboard>(context, listen: true).unreconciledDepositCount;

    final int unreconciledWithdrawalCount =
        Provider.of<Dashboard>(context, listen: true)
            .unreconciledWithdrawalCount; */

    /* final bool _isPartnerBankAccount =
        Provider.of<Dashboard>(context, listen: true).isPartnerBankAccount; */
    final int unreconciledDepositCount =
        Provider.of<GroupNotifications>(context, listen: true)
            .unreconciledDepositCount;
    final int unreconciledWithdrawalCount =
        Provider.of<GroupNotifications>(context, listen: true)
            .unreconciledWithdrwalCount;

    final bool _isPartnerBankAccount =
        Provider.of<GroupNotifications>(context, listen: true)
            .isPartnerBankAccount;

    print("Group Status is : $_isPartnerBankAccount");
    print("Unreconciled Deposit Count is : $unreconciledDepositCount");
    print("Unreconciled Withdrawal Count is : $unreconciledWithdrawalCount");

    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;

    return ShowCaseWidget(builder: Builder(
      builder: (context) {
        transactionsContext = context;
        List<Widget> eWalletOptions = [
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: createWithdrawalKey,
            description: currentLanguage == 'English'
                ? 'Create a withdrawal from from chamasoft ewalet to mpesa'
                : Provider.of<TranslationProvider>(context, listen: false)
                        .translate(
                            'Create a withdrawal from from chamasoft ewalet to mpesa') ??
                    'Create a withdrawal from from chamasoft ewalet to mpesa',
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['wallet'],
                    title: currentLanguage == 'English'
                        ? 'CREATE'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('CREATE') ??
                            'CREATE',
                    subtitle: currentLanguage == 'English'
                        ? 'WITHDRAWAL'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('WITHDRAWAL') ??
                            'WITHDRAWAL',
                    color: Colors.blue[400],
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            WithdrawalPurpose(groupId: group.groupId),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: reviewWithdrawalKey,
            description:
                "View all withdrawals made from your e-wallet to your members",
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['couple'],
                    title: currentLanguage == 'English'
                        ? 'REVIEW'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('REVIEW') ??
                            'REVIEW',
                    subtitle: currentLanguage == 'English'
                        ? 'WITHDRAWALS'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('WITHDRAWALS') ??
                            'WITHDRAWALS',
                    color: Colors.blue[400],
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ReviewWithdrawalRequest(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
        ];

        List<Widget> loanOptions = [
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: loanApprovalKey,
            description: currentLanguage == 'English'
                ? 'Approve loans applied by members'
                : Provider.of<TranslationProvider>(context, listen: false)
                        .translate('Approve loans applied by members') ??
                    'Approve loans applied by members',
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['couple'],
                    title: currentLanguage == 'English'
                        ? 'REVIEW'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('REVIEW') ??
                            'REVIEW',
                    subtitle: currentLanguage == 'English'
                        ? 'LOANS'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('LOANS') ??
                            'LOANS',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () 
                     => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ReviewLoanApplications(),
                        settings: RouteSettings(arguments: 0))),
                    //  => Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (BuildContext context) => BankLoanRepayment(),
                    //     settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: recordMemberLoan,
            description: currentLanguage == 'English'
                ? 'Manualy Record Loans given to members'
                : Provider.of<TranslationProvider>(context, listen: false)
                        .translate('Manualy Record Loans given to members') ??
                    'Manualy Record Loans given to members',
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['money-bag'],
                    title: currentLanguage == 'English'
                        ? 'RECORD'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('RECORD') ??
                            'RECORD',
                    subtitle: currentLanguage == 'English'
                        ? 'MEMBER LOAN'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('MEMBER LOAN') ??
                            'MEMBER LOAN',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => CreateMemberLoan(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: recordRepaymentKey,
            description: currentLanguage == 'English'
                ? 'Manualy Record Loan repayment by members'
                : Provider.of<TranslationProvider>(context, listen: false)
                        .translate(
                            'Manualy Record Loan repayment by members') ??
                    'Manualy Record Loan repayment by members',
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['safe'],
                    title: currentLanguage == 'English'
                        ? 'RECORD'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('RECORD') ??
                            'RECORD',
                    subtitle: currentLanguage == 'English'
                        ? 'REPAYMENTS'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('REPAYMENTS') ??
                            'REPAYMENTS',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => RecordLoanPayment(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: bankLoanRepaymentKey,
            description: currentLanguage == 'English'
                ? 'Manualy Record Bank Loan repayment by members'
                : Provider.of<TranslationProvider>(context, listen: false)
                        .translate(
                            'Manualy Record Bank Loan repayment by members') ??
                    'Manualy Record Bank Loan repayment by members',
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['safe'],
                    title: currentLanguage == 'English'
                        ? 'BANK LOAN'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('BANK LOAN') ??
                            'BANK LOAN',
                    subtitle: currentLanguage == 'English'
                        ? 'REPAYMENTS'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('REPAYMENTS') ??
                            'REPAYMENTS',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => BankLoanRepayment(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
        ];

        // List<Widget> paymentsOptions = [
        //   if (_isPartnerBankAccount)
        //     customShowCase(
        //       key: recordDepositSectionKey,
        //       description:
        //           "With this section, as an admin you can manualy record groups income and manual deposit reconsiliation",
        //       child: Row(
        //         children: [
        //           SizedBox(
        //             width: 16.0,
        //           ),
        //           customShowCase(
        //             key: reconcileDepositKey,
        //             description: "Reconcile Deposits made by your group mebers",
        //             child: Container(
        //                 width: 132.0,
        //                 child: svgGridButton(
        //                     context: context,
        //                     icon: customIcons['money-bag'],
        //                     title: 'RECONCILE',
        //                     subtitle: 'DEPOSITS',
        //                     color: Colors.blue[400],
        //                     isHighlighted: false,
        //                     action: () => Navigator.of(context).push(
        //                         MaterialPageRoute(
        //                             builder: (BuildContext ctx) =>
        //                                 ReconcileDepositList())),
        //                     margin: 0,
        //                     imageHeight: 100.0,
        //                     notifications: unreconciledDepositCount)),
        //           ),
        //         ],
        //       ),
        //     ),
        //   SizedBox(
        //     width: 16.0,
        //   ),
        //   customShowCase(
        //     key: contributionPayementKey,
        //     description: "Manualy Record Contributions made by members",
        //     child: Container(
        //         width: 132.0,
        //         child: svgGridButton(
        //             context: context,
        //             icon: customIcons['cash-register'],
        //             title: 'CONTRIBUTION',
        //             subtitle: "PAYMENTS",
        //             color: Colors.blue[400],
        //             isHighlighted: false,
        //             action: () => Navigator.of(context).push(MaterialPageRoute(
        //                 builder: (BuildContext context) =>
        //                     RecordContributionPayment(),
        //                 settings: RouteSettings(arguments: 0))),
        //             margin: 0,
        //             imageHeight: 100.0)),
        //   ),
        //   SizedBox(
        //     width: 16.0,
        //   ),
        //   customShowCase(
        //     key: finePayementKey,
        //     description: "Manualy Record Fine repayment by members",
        //     child: Container(
        //         width: 132.0,
        //         child: svgGridButton(
        //             context: context,
        //             icon: customIcons['refund'],
        //             title: 'FINE',
        //             subtitle: "PAYMENTS",
        //             color: Colors.blue[400],
        //             isHighlighted: false,
        //             action: () => Navigator.of(context).push(MaterialPageRoute(
        //                 builder: (BuildContext context) => RecordFinePayment(),
        //                 settings: RouteSettings(arguments: 0))),
        //             margin: 0,
        //             imageHeight: 100.0)),
        //   ),
        //   SizedBox(
        //     width: 16.0,
        //   ),
        //   customShowCase(
        //     key: incomeKey,
        //     description: "Manualy Record income made by members",
        //     child: Container(
        //         width: 132.0,
        //         child: svgGridButton(
        //             context: context,
        //             icon: customIcons['cash-in-hand'],
        //             title: 'INCOME',
        //             color: Colors.blue[400],
        //             isHighlighted: false,
        //             action: () => Navigator.of(context).push(MaterialPageRoute(
        //                 builder: (BuildContext context) => RecordIncome(),
        //                 settings: RouteSettings(arguments: 0))),
        //             margin: 0,
        //             imageHeight: 100.0)),
        //   ),
        //   SizedBox(
        //     width: 16.0,
        //   ),
        //   customShowCase(
        //     key: miscellaneousKey,
        //     description: "Manualy Record Miscellaneous repayment by members",
        //     child: Container(
        //         width: 132.0,
        //         child: svgGridButton(
        //             context: context,
        //             icon: customIcons['transaction'],
        //             title: 'MISCELLANEOUS',
        //             color: Colors.blue[400],
        //             isHighlighted: false,
        //             action: () => Navigator.of(context).push(MaterialPageRoute(
        //                 builder: (BuildContext context) =>
        //                     RecordMiscellaneousPayment(),
        //                 settings: RouteSettings(arguments: 0))),
        //             margin: 0,
        //             imageHeight: 100.0)),
        //   ),
        //   SizedBox(
        //     width: 16.0,
        //   ),
        //   customShowCase(
        //     key: bankLoanKey,
        //     description: "Manualy Record Bank Loan made to a members",
        //     child: Container(
        //         width: 132.0,
        //         child: svgGridButton(
        //             context: context,
        //             icon: customIcons['bank'],
        //             title: 'BANK LOANS',
        //             color: Colors.blue[400],
        //             isHighlighted: false,
        //             action: () => Navigator.of(context).push(MaterialPageRoute(
        //                 builder: (BuildContext context) => RecordBankLoan(),
        //                 settings: RouteSettings(arguments: 0))),
        //             margin: 0,
        //             imageHeight: 100.0)),
        //   ),
        //   SizedBox(
        //     width: 16.0,
        //   ),
        // ];

        List<Widget> paymentsOptions = [
          if (_isPartnerBankAccount)
            Row(
              children: [
                SizedBox(
                  width: 16.0,
                ),
                Container(
                    width: 132.0,
                    child: svgGridButton(
                        context: context,
                        icon: customIcons['money-bag'],
                        title: currentLanguage == 'English'
                            ? 'RECONCILE'
                            : Provider.of<TranslationProvider>(context,
                                        listen: false)
                                    .translate('RECONCILE') ??
                                'RECONCILE',
                        subtitle: currentLanguage == 'English'
                            ? 'DEPOSITS'
                            : Provider.of<TranslationProvider>(context,
                                        listen: false)
                                    .translate('DEPOSITS') ??
                                'DEPOSITS',
                        color: Config.appName.toLowerCase() == "chamasoft"
                            ? Colors.blue[400]
                            : Theme.of(context).primaryColor,
                        isHighlighted: false,
                        action: () => _toUnreconciledDepositList(context),
                        margin: 0,
                        imageHeight: 100.0,
                        notifications: unreconciledDepositCount)),
              ],
            ),
          SizedBox(
            width: 16.0,
          ),
          Container(
              width: 132.0,
              child: svgGridButton(
                  context: context,
                  icon: customIcons['cash-register'],
                  title: currentLanguage == 'English'
                      ? 'CONTRIBUTION'
                      : Provider.of<TranslationProvider>(context, listen: false)
                              .translate('CONTRIBUTION') ??
                          'CONTRIBUTION',
                  subtitle: currentLanguage == 'English'
                      ? 'PAYMENTS'
                      : Provider.of<TranslationProvider>(context, listen: false)
                              .translate('PAYMENTS') ??
                          'PAYMENTS',
                  color: Config.appName.toLowerCase() == "chamasoft"
                      ? Colors.blue[400]
                      : Theme.of(context).primaryColor,
                  isHighlighted: false,
                  action: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          RecordContributionPayment(),
                      settings: RouteSettings(arguments: 0))),
                  margin: 0,
                  imageHeight: 100.0)),
          SizedBox(
            width: 16.0,
          ),
          Container(
              width: 132.0,
              child: svgGridButton(
                  context: context,
                  icon: customIcons['refund'],
                  title: currentLanguage == 'English'
                      ? 'FINE'
                      : Provider.of<TranslationProvider>(context, listen: false)
                              .translate('FINE') ??
                          'FINE',
                  subtitle: currentLanguage == 'English'
                      ? 'PAYMENTS'
                      : Provider.of<TranslationProvider>(context, listen: false)
                              .translate('PAYMENTS') ??
                          'PAYMENTS',
                  color: Config.appName.toLowerCase() == "chamasoft"
                      ? Colors.blue[400]
                      : Theme.of(context).primaryColor,
                  isHighlighted: false,
                  action: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => RecordFinePayment(),
                      settings: RouteSettings(arguments: 0))),
                  margin: 0,
                  imageHeight: 100.0)),
          SizedBox(
            width: 16.0,
          ),
          Container(
              width: 132.0,
              child: svgGridButton(
                  context: context,
                  icon: customIcons['cash-in-hand'],
                  title: currentLanguage == 'English'
                      ? 'INCOME'
                      : Provider.of<TranslationProvider>(context, listen: false)
                              .translate('INCOME') ??
                          'INCOME',
                  color: Config.appName.toLowerCase() == "chamasoft"
                      ? Colors.blue[400]
                      : Theme.of(context).primaryColor,
                  isHighlighted: false,
                  action: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => RecordIncome(),
                      settings: RouteSettings(arguments: 0))),
                  margin: 0,
                  imageHeight: 100.0)),
          SizedBox(
            width: 16.0,
          ),
          Container(
              width: 132.0,
              child: svgGridButton(
                  context: context,
                  icon: customIcons['transaction'],
                  title: currentLanguage == 'English'
                      ? 'MISCELLANEOUS'
                      : Provider.of<TranslationProvider>(context, listen: false)
                              .translate('MISCELLANEOUS') ??
                          'MISCELLANEOUS',
                  color: Config.appName.toLowerCase() == "chamasoft"
                      ? Colors.blue[400]
                      : Theme.of(context).primaryColor,
                  isHighlighted: false,
                  action: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          RecordMiscellaneousPayment(),
                      settings: RouteSettings(arguments: 0))),
                  margin: 0,
                  imageHeight: 100.0)),
          SizedBox(
            width: 16.0,
          ),
          Container(
              width: 132.0,
              child: svgGridButton(
                  context: context,
                  icon: customIcons['bank'],
                  title: currentLanguage == 'English'
                      ? 'BANK LOANS'
                      : Provider.of<TranslationProvider>(context, listen: false)
                              .translate('BANK LOANS') ??
                          'BANK LOANS',
                  color: Config.appName.toLowerCase() == "chamasoft"
                      ? Colors.blue[400]
                      : Theme.of(context).primaryColor,
                  isHighlighted: false,
                  action: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => RecordBankLoan(),
                      settings: RouteSettings(arguments: 0))),
                  margin: 0,
                  imageHeight: 100.0)),
          SizedBox(
            width: 16.0,
          ),
        ];

        List<Widget> expenditureOptions = [
          if (_isPartnerBankAccount)
            Row(
              children: [
                SizedBox(
                  width: 16.0,
                ),
                customShowCase(
                  key: reconcileWithdralKey,
                  description: "Manualy Reconcile a withdrawal made to members",
                  child: Container(
                      width: 132.0,
                      child: svgGridButton(
                          context: context,
                          icon: customIcons['card-payment'],
                          title: currentLanguage == 'English'
                              ? 'RECONCILE'
                              : Provider.of<TranslationProvider>(context, listen: false)
                                      .translate('RECONCILE') ??
                                  'RECONCILE',
                          subtitle: currentLanguage == 'English'
                              ? 'WITHDRAWALS'
                              : Provider.of<TranslationProvider>(context, listen: false)
                                      .translate('WITHDRAWALS') ??
                                  'WITHDRAWALS',
                          color: Config.appName.toLowerCase() == "chamasoft"
                              ? Colors.blue[400]
                              : Theme.of(context).primaryColor,
                          isHighlighted: false,
                          action: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext ctx) => ReconcileWithdrawalList())),
                          margin: 0,
                          imageHeight: 100.0,
                          notifications: unreconciledWithdrawalCount)),
                )
              ],
            ),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: expensesKey,
            description: "Manualy Record Expenses withdrawal",
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['invoice'],
                    title: currentLanguage == 'English'
                        ? 'EXPENSES'
                        : Provider.of<TranslationProvider>(context,
                                    listen: false)
                                .translate('EXPENSES') ??
                            'EXPENSES',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => RecordExpense(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: contributionRefundKey,
            description: "Manualy Record Contribution Refund",
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['money-bag'],
                    title: currentLanguage == 'English'
                        ? 'CONTRIBUTION'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('CONTRIBUTION') ??
                            'CONTRIBUTION',
                    subtitle: currentLanguage == 'English'
                        ? 'REFUND'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('REFUND') ??
                            'REFUND',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RecordContributionRefund(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
        ];

        List<Widget> invoicingOptions = [
          SizedBox(
            width: 16.0,
          ),
          Container(
              width: 132.0,
              child: svgGridButton(
                  context: context,
                  icon: customIcons['group'],
                  title: 'INVOICE',
                  subtitle: 'MEMBERS',
                  color: Colors.blue[400],
                  isHighlighted: false,
                  action: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CreateInvoice(),
                      settings: RouteSettings(arguments: 0))),
                  margin: 0,
                  imageHeight: 100.0)),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: fineMemberKey,
            description: "Manualy Record Fine repayment by members",
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['account'],
                    title: currentLanguage == 'English'
                        ? 'FINE'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('FINE') ??
                            'FINE',
                    subtitle: currentLanguage == 'English'
                        ? 'MEMBER'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('MEMBER') ??
                            'MEMBER',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => FineMember(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
//      SizedBox(
//        width: 16.0,
//      ),
//      Container(
//          width: 132.0,
//          child: svgGridButton(
//              context: context,
//              icon: customIcons['blockchain'],
//              title: 'CONTRIBUTION',
//              subtitle: 'TRANSFER',
//              color: Colors.blue[400],
//              isHighlighted: false,
//              action: () => Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => ContributionTransfer(), settings: RouteSettings(arguments: 0))),
//              margin: 0,
//              imageHeight: 100.0)),
          SizedBox(
            width: 16.0,
          ),
          customShowCase(
            key: accountTransferKey,
            description:
                'Transfer Chama Money from One chama Account to another Account ',
            child: Container(
                width: 132.0,
                child: svgGridButton(
                    context: context,
                    icon: customIcons['bank-cards'],
                    title: currentLanguage == 'English'
                        ? 'ACCOUNT TO'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('ACCOUNT TO') ??
                            'ACCOUNT TO',
                    subtitle: currentLanguage == 'English'
                        ? 'ACCOUNT TRANSFER'
                        : Provider.of<TranslationProvider>(context, listen: false)
                                .translate('ACCOUNT TRANSFER') ??
                            'ACCOUNT TRANSFER',
                    color: Config.appName.toLowerCase() == "chamasoft"
                        ? Colors.blue[400]
                        : Theme.of(context).primaryColor,
                    isHighlighted: false,
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AccountToAccountTransfer(),
                        settings: RouteSettings(arguments: 0))),
                    margin: 0,
                    imageHeight: 100.0)),
          ),
          SizedBox(
            width: 16.0,
          ),
          // customShowCase(
          //   key: sendToMobileKey,
          //   description: 'Transfer Chama Money TO Your Phone Number ',
          //   child: Container(
          //       width: 132.0,
          //       child: svgGridButton(
          //           context: context,
          //           icon: customIcons['bank-cards'],
          //           title: 'SEND',
          //           subtitle: 'TO MOBILE',
          //           color: Config.appName.toLowerCase() == "chamasoft"
          //               ? Colors.blue[400]
          //               : Theme.of(context).primaryColor,
          //           isHighlighted: false,
          //           action: () => Navigator.of(context).push(MaterialPageRoute(
          //               builder: (BuildContext context) => SendToMobile(),
          //               settings: RouteSettings(arguments: 0))),
          //           margin: 0,
          //           imageHeight: 100.0)),
          // ),
        ];

        return new WillPopScope(
            onWillPop: _onWillPop,
            child: SafeArea(
                child: group.isGroupAdmin
                    ? SingleChildScrollView(
                        // controller: _scrollController,
                        child: Column(
                          children: <Widget>[
                            if (Config.appName.toLowerCase() == "chamasoft")
                              if (group.onlineBankingEnabled)
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        currentLanguage == 'English'
                                            ? 'E-Wallet'
                                            : Provider.of<TranslationProvider>(
                                                        context,
                                                        listen: false)
                                                    .translate('E-Wallet') ??
                                                'E-Wallet',
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
                            if (Config.appName.toLowerCase() == "chamasoft")
                              if (group.onlineBankingEnabled)
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                  child: Container(
                                    height: 160.0,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.only(
                                          top: 5.0, bottom: 10.0),
                                      physics: BouncingScrollPhysics(),
                                      children: eWalletOptions,
                                    ),
                                  ),
                                ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    currentLanguage == 'English'
                                        ? 'Record Deposit'
                                        : Provider.of<TranslationProvider>(
                                                    context,
                                                    listen: false)
                                                .translate('Record Deposit') ??
                                            'Record Deposit',
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
                                child: customShowCase(
                                  key: recordDepositSectionKey,
                                  description: currentLanguage == 'English'
                                      ? 'With this section, as an admin you can manualy record groups income and manual deposit reconsiliation'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate(
                                                  'With this section, as an admin you can manualy record groups income and manual deposit reconsiliation') ??
                                          'With this section, as an admin you can manualy record groups income and manual deposit reconsiliation',
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    padding:
                                        EdgeInsets.only(top: 5.0, bottom: 10.0),
                                    physics: BouncingScrollPhysics(),
                                    children: paymentsOptions,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    currentLanguage == 'English'
                                        ? 'Record Withdrawal'
                                        : Provider.of<TranslationProvider>(
                                                    context,
                                                    listen: false)
                                                .translate(
                                                    'Record Withdrawal') ??
                                            'Record Withdrawal',
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
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 10.0),
                                  physics: BouncingScrollPhysics(),
                                  children: expenditureOptions,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    currentLanguage == 'English'
                                        ? 'Loans'
                                        : Provider.of<TranslationProvider>(
                                                    context,
                                                    listen: false)
                                                .translate('Loans') ??
                                            'Loans',
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
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 10.0),
                                  physics: BouncingScrollPhysics(),
                                  children: loanOptions,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    currentLanguage == 'English'
                                        ? 'Invoicing & Transfers'
                                        : Provider.of<TranslationProvider>(
                                                    context,
                                                    listen: false)
                                                .translate(
                                                    'Invoicing & Transfers') ??
                                            'Invoicing & Transfers',
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
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                              child: Container(
                                height: 160.0,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 10.0),
                                  physics: BouncingScrollPhysics(),
                                  children: invoicingOptions,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : recentTransactions.length > 0
                        ? SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      /* RecentTransactionSummary */ NewRecentTransactionSummary
                                          transaction =
                                          recentTransactions[index];
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            16.0, 4.0, 16.0, 4.0),
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.transparent,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(
                                                      Feather.bar_chart_2,
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      size: 24.0,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          subtitle1(
                                                              text: transaction
                                                                  .paymentTitle,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textSelectionTheme
                                                                  .selectionHandleColor,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                          subtitle2(
                                                              text: transaction
                                                                  .description,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textSelectionTheme
                                                                  .selectionHandleColor,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                          subtitle2(
                                                              text: transaction
                                                                      .paymentMethod +
                                                                  " Payment",
                                                              color: Theme.of(
                                                                      context)
                                                                  .textSelectionTheme
                                                                  .selectionHandleColor,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  subtitle1(
                                                      text: group
                                                              .groupCurrency +
                                                          " " +
                                                          currencyFormat.format(
                                                              transaction
                                                                  .paymentAmount),
                                                      color: Theme.of(context)
                                                          .textSelectionTheme
                                                          .selectionHandleColor,
                                                      textAlign:
                                                          TextAlign.start),
                                                  subtitle2(
                                                      text: transaction
                                                          .paymentDate,
                                                      color: Theme.of(context)
                                                          .textSelectionTheme
                                                          .selectionHandleColor,
                                                      textAlign:
                                                          TextAlign.start),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: recentTransactions.length,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  //if (recentTransactions.length == 10)
                                  defaultButton(
                                    context: context,
                                    text: currentLanguage == 'English'
                                        ? 'View More Transactions'
                                        : Provider.of<TranslationProvider>(
                                                    context,
                                                    listen: false)
                                                .translate(
                                                    'View More Transactions') ??
                                            'View More Transactions',
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ContributionStatement(
                                                statementFlag:
                                                    CONTRIBUTION_STATEMENT),
                                        settings: RouteSettings(arguments: 0),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
                            child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      customIcons['no-data'],
                                      semanticsLabel: 'icon',
                                      height: 120.0,
                                    ),
                                    customTitleWithWrap(
                                        text: currentLanguage == 'English'
                                            ? 'Nothing to display!'
                                            : Provider.of<TranslationProvider>(
                                                        context,
                                                        listen: false)
                                                    .translate(
                                                        'Nothing to display!') ??
                                                'Nothing to display!',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.0,
                                        textAlign: TextAlign.center,
                                        color: Colors.blueGrey[400]),
                                    customTitleWithWrap(
                                        text: currentLanguage == 'English'
                                            ? "Sorry, you haven't made any transactions "
                                            : Provider.of<TranslationProvider>(
                                                        context,
                                                        listen: false)
                                                    .translate(
                                                        "Sorry, you haven't made any transactions ") ??
                                                "Sorry, you haven't made any transactions ",
                                        //fontWeight: FontWeight.w500,
                                        fontSize: 12.0,
                                        textAlign: TextAlign.center,
                                        color: Colors.blueGrey[400])
                                  ],
                                )),
                          )
                // Center(
                //     child: emptyList(
                //       color: Colors.blue[400],
                //       iconData: LineAwesomeIcons.angle_double_down,
                //       text: "Admin Users Only - Temporary"
                //     )
                //   )
                ));
      },
    ));
  }
}
