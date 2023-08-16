// ignore_for_file: unused_field, null_aware_before_operator, deprecated_member_use, duplicate_ignore, unused_local_variable, unused_element

import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chamasoft/config.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/get_path.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/svg-icons.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/bankBalancesSummary.dart';
import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/expenses-summaries.dart';
import 'package:chamasoft/providers/fine_summary.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/loan-summaries.dart';
import 'package:chamasoft/providers/notification_summary.dart';
import 'package:chamasoft/providers/recent-transactions.dart';
import 'package:chamasoft/providers/summaries.dart';
import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/screens/chamasoft/models/expense-category.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/account-balances.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/contribution-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/expense-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/group-loans-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/contribution-statement.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/pay-now-sheet.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/widgets/annimationSlider.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
// import 'package:chamasoft/widgets/dialogs.dart';
// import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/showCase.dart';
import 'package:chamasoft/widgets/textstyles.dart';
//import 'package:date_time_picker/date_time_picker.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:pie_chart/pie_chart.dart' as chart;
import 'package:shared_preferences/shared_preferences.dart';

import 'meetings/meetings.dart';

class ChamasoftHome extends StatefulWidget {
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING_HOME =
      "PREFERENCES_IS_FIRST_LAUNCH_STRING_HOME";

  const ChamasoftHome(
      {Key key, this.appBarElevation, this.notificationCount, this.rateMyApp})
      : super(key: key);

  final ValueChanged<double> appBarElevation;
  final ValueChanged<double> notificationCount;
  final RateMyApp rateMyApp;

  @override
  State<ChamasoftHome> createState() => _ChamasoftHomeState();
}

class _ChamasoftHomeState extends State<ChamasoftHome> {
  ScrollController _scrollController;
  Group _currentGroup;
  bool _onlineBankingEnabled = true;
  bool _isInit = true;
  String _groupCurrency = "Ksh";

  // List<RecentTransactionSummary> _iteratableRecentTransactionSummary = [];
  List<ContributionsSummary> _itableContributionSummary = [];
  Dashboard dashboardData;

  // List<BankAccountDashboardSummary> _iteratableData = [];
  List<NewRecentTransactionSummary> _iteratableRecentTransactionSummary = [];

  ExpenseSummaryList _expenseSummaryList;
  double _totalExpenses = 0;
  List<SummaryRow> _expenseRows = [];

  int _currentIndex = 0;
  bool _showMeetingsBanner = true;
  // List cardList = [
  //   Contrubutions(),
  //   Fines(),
  //   Balances(),
  // ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  BuildContext homeContext;

  final meetingsBannarKey = GlobalKey();
  final totalBalanceKey = GlobalKey();
  final contributionSummayKey = GlobalKey();
  final recentTransactionKey = GlobalKey();
  final payNowButtonKey = GlobalKey();

  final contributionsSummaryKey = GlobalKey();
  final accountBalanceKey = GlobalKey();
  final groupLoanKey = GlobalKey();
  final withdrwalDepositKey = GlobalKey();
  BuildContext groupContext;

  ScrollController _chartScrollController;

  void _scrollListener() {
    widget.appBarElevation(_scrollController.offset);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    // _scrollChartToEnd();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    //if(_isInit){
    _getMemberDashboardDataNew();
    // if (_isInit)
    //   WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    // _getMemberDashboardData();
    // _getGroupDashboardData();
    //}
    _groupCurrency = _currentGroup.groupCurrency;
    _meetingsBannerStatus();
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacementNamed(MyGroups.namedRoute);
    return null;
  }

  /* Future<void> readFileData() async {
    // Map<String, dynamic> _formData = {};
    // BuildContext context;
    final _dirPath = await getDirPath();
    final logfilePath = File('$_dirPath/data.txt');
    final logDataSaved = await logfilePath.readAsString(encoding: utf8);
    final _myFile = File('$_dirPath/data.txt');
    print("File size is : ${await _myFile.length()}");
    if (await _myFile.length() >= 1000) {
      print("Hello, its more than 10kb, below is the data.");
      print(logDataSaved);
      // _formData['data'] = logDataSaved;
      // try {
      //   await Provider.of<Groups>(context, listen: false)
      //       .recordLogAPIs(logdata: logDataSaved);
      // } on CustomException catch (error) {
      //   StatusHandler().handleStatus(
      //       context: context,
      //       error: error,
      //       callback: () {
      //         readFileData();
      //       });
      // }
      print("Data saved to the server");
      await _myFile.delete();
      // readFileData();

    } else {
      print("Hello, its less than 10kb");
      // readFileData();
    }
  }*/

  /* Future<void> _getExpenseSummary(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchExpenseSummary();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getExpenseSummary(context);
          });
    }
  }*/

  Future<void> _getMemberDashboardDataNew([bool hardRefresh = false]) async {
    try {
      if (hardRefresh) {
        _currentIndex = 0;
        readFileData();
        // Provider.of<Dashboard>(context, listen: false)
        //     .resetMemberDashboardData(_currentGroup.groupId);
        //
        // Provider.of<Dashboard>(context, listen: false)
        //     .resetGroupDashboardData(_currentGroup.groupId);

        Provider.of<DashboardContributionSummary>(context, listen: false)
            .resetMemberContributionSummary(_currentGroup.groupId);
        Provider.of<DashboardContributionSummary>(context, listen: false)
            .resetGroupContributionSummary(_currentGroup.groupId);

        Provider.of<DashboardFineSummary>(context, listen: false)
            .resetMemberFineSummary(_currentGroup.groupId);
        Provider.of<DashboardFineSummary>(context, listen: false)
            .resetGroupFineSummary(_currentGroup.groupId);
        Provider.of<BalancesDashboardSummary>(context, listen: false)
            .resetAccountBalanceSummary(_currentGroup.groupId);
        Provider.of<BalancesDashboardSummary>(context, listen: false)
            .resetTotalBankBalanceSummary(_currentGroup.groupId);

        Provider.of<LoanDashboardSummary>(context, listen: false)
            .resetloanSummary(_currentGroup.groupId);
        Provider.of<LoanDashboardSummary>(context, listen: false)
            .resetGroupLoanSummary(_currentGroup.groupId);

        // Provider.of(context, listen: false).fetchMemberLoans();
      }
      // if (!Provider.of<Dashboard>(context, listen: false)
      //     .memberGroupDataExists(_currentGroup.groupId)) {
      //   if (this.mounted) {
      //     if (_isInit == false) {
      //       setState(() {
      //         _isInit = true;
      //         _currentIndex = 0;
      //       });
      //     }
      //   }
      //   await Provider.of<Dashboard>(context, listen: false)
      //       .getMemberDashboardData(_currentGroup.groupId)
      //       .then((_) => {
      //             setState(() {
      //               dashboardData =
      //                   Provider.of<Dashboard>(context, listen: false);
      //               // WidgetsBinding.instance.addPostFrameCallback((_) => () {
      //               print("inside here ${dashboardData.notificationCount}");
      //               widget.notificationCount(dashboardData.notificationCount);
      //               // });
      //             })
      //           });
      // }
      // if (!Provider.of<Dashboard>(context, listen: false)
      //     .groupDataExists(_currentGroup.groupId)) {
      //   if (this.mounted) {
      //     if (_isInit == false) {
      //       setState(() {
      //         _isInit = true;
      //       });
      //     }
      //   }
      //   // await Provider.of<Dashboard>(context, listen: false)
      //   //     .getGroupDashboardData(
      //   //         _currentGroup.groupId);
      //   // getChartData();
      //   await Provider.of<Groups>(context, listen: false).fetchExpenseSummary();
      // }

      // await Provider.of<DashboardContributionSummary>(context, listen: false)
      //     .getContributionsSummary(_currentGroup.groupId);

      // if (!Provider.of<Groups>(context, listen: false).expenseListExists()) {
      //   print("We have no expenses, fetching them");
      //   if (this.mounted) {
      //     if (_isInit == false) {
      //       setState(() {
      //         _isInit = true;
      //       });
      //     }
      //   }
      //   await Provider.of<Groups>(context, listen: false).fetchExpenseSummary();
      // }

      // await Provider.of<Dashboard>(context, listen: false)
      //     .getMemberDashboardData(_currentGroup.groupId);

      /* if (!Provider.of<DashboardContributionSummary>(context, listen: false)
          .memberContributionSummaryExists(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<DashboardContributionSummary>(context, listen: false)
            .getContributionsSummary(_currentGroup.groupId);
      }*/

      // if(!Provider.of<Groups>(context, listen: false).groupExpensesExists(_currentGroup.groupId)){
      //   if (this.mounted) {
      //     if (_isInit == false) {
      //       setState(() {
      //         _isInit = true;
      //       });
      //     }
      //   }
      //await Provider.of<Groups>(context, listen: false).fetchExpenseSummary();
      // }

      // if (_expenseSummaryList != null) {
      //   // _expenseRows = _expenseSummaryList.expenseSummary;
      //   // _totalExpenses = _expenseSummaryList.totalExpenses;
      // }else{
      //   await Provider.of<Groups>(context, listen: false).fetchExpenseSummary();
      // }

      /* if (!Provider.of<DashboardFineSummary>(context, listen: false)
          .memberFineSummaryExists(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<DashboardFineSummary>(context, listen: false)
            .getFinesSummary(_currentGroup.groupId);
      }*/

      // if (!Provider.of<DashboardFineSummary>(context, listen: false)
      //     .groupFineSummaryExists(_currentGroup.groupId)) {
      //   if (this.mounted) {
      //     if (_isInit == false) {
      //       setState(() {
      //         _isInit = true;
      //       });
      //     }
      //   }
      //   await Provider.of<DashboardFineSummary>(context, listen: false)
      //       .getFinesSummary(_currentGroup.groupId);
      // }

      if (!Provider.of<BalancesDashboardSummary>(context, listen: false)
          .accountBalanceSummaryExists(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<BalancesDashboardSummary>(context, listen: false)
            .getAccountBalancesSummary(_currentGroup.groupId);
        await Provider.of<NewExpensesSummaries>(context, listen: false)
            .fetchExpenses(_currentGroup.groupId);
      }

      if (!Provider.of<GroupNotifications>(context, listen: false)
          .isPartnerBankAccount) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<GroupNotifications>(context, listen: false)
            .getGroupNotificationsSummary(_currentGroup.groupId);
      }

      /*    await Provider.of<GroupNotifications>(context, listen: false)
          .getGroupNotificationsSummary(_currentGroup.groupId); */
// ignore: todo
//TODO
      /*   if (!Provider.of<DashboardContributionSummary>(context, listen: false)
          .groupContributionSummaryExists(_currentGroup.groupId)) {
        // if (this.mounted) {
        if (_isInit == false) {
          setState(() {
            _isInit = true;
          });
        }
        // }
        await Provider.of<DashboardContributionSummary>(context, listen: false)
            .getContributionsSummary(_currentGroup.groupId);
      }
 */
      /* if (!Provider.of<NewExpensesSummaries>(context, listen: false)
          .expensesSummariesTotalExists(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
              // _getExpensesSummary(context);
            });
          }
        }
        await Provider.of<NewExpensesSummaries>(context, listen: false)
            .fetchExpenses(_currentGroup.groupId);
      }*/

      // if (!Provider.of<NewExpensesSummaries>(context, listen: false)
      //     .expensesSummariesTotalExists(_currentGroup.groupId)) {
      //   if (this.mounted) {
      //     if (_isInit == false) {
      //       setState(() {
      //         _isInit = true;
      //         // _getExpensesSummary(context);
      //       });
      //     }
      //   }
      //   await Provider.of<NewExpensesSummaries>(context, listen: false)
      //       .fetchExpenses(_currentGroup.groupId);
      // }

      // await Provider.of<DashboardContributionSummary>(context, listen: false)
      //     .getContributionsSummary(_currentGroup.groupId);
      // await Provider.of<Groups>(context, listen: false).fetchExpenseSummary();

      if (!Provider.of<MemberRecentTransaction>(context, listen: false)
          .recentTransactionsExist(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<MemberRecentTransaction>(context, listen: false)
            .getRecentTransactionsSummary(_currentGroup.groupId);
      }

      /* Future<void> _getExpensesSummary(BuildContext context) async {
        try {
          await Provider.of<NewExpensesSummaries>(context, listen: false)
              .fetchExpenses(_currentGroup.groupId);
        } on CustomException catch (error) {
          StatusHandler().handleStatus(
              context: context,
              error: error,
              callback: () {
                _getExpensesSummary(context);
              });
        }
      }*/

      // await Provider.of<Dashboard>(context, listen: false)
      //     .getMemberDashboardData(_currentGroup.groupId);

      /*  if (!Provider.of<BalancesDashboardSummary>(context, listen: false)
          .totalBankBalanceSummaryExists(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<BalancesDashboardSummary>(context, listen: false)
            .getAccountBalancesSummary(_currentGroup.groupId);
      }*/
// ignore: todo
//TODO
      /*  if (!Provider.of<LoanDashboardSummary>(context, listen: false)
          .grouploanExists(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<LoanDashboardSummary>(context, listen: false)
            .getDashboardLoanSummary(_currentGroup.groupId);
      }
 */
//todo
      /*  if (!Provider.of<DashboardFineSummary>(context, listen: false)
          .groupFineSummaryExists(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<DashboardFineSummary>(context, listen: false)
            .getFinesSummary(_currentGroup.groupId);
        await Provider.of<NewExpensesSummaries>(context, listen: false)
            .fetchExpenses(_currentGroup.groupId);
      } */
      /*if (!Provider.of<LoanDashboardSummary>(context, listen: false)
          .grouploanExists(_currentGroup.groupId)) {
        if (this.mounted) {
          if (_isInit == false) {
            setState(() {
              _isInit = true;
            });
          }
        }
        await Provider.of<LoanDashboardSummary>(context, listen: false)
            .getDashboardLoanSummary(_currentGroup.groupId);
      }*/
      // await Provider.of<Groups>(context, listen: false).fetchExpenseSummary();
      readFileData();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getMemberDashboardDataNew();
          });
    } finally {
      if (this.mounted) {
        setState(() {
          _isInit = false;
          _onlineBankingEnabled = _currentGroup.onlineBankingEnabled;
        });
      }
    }
  }

  Future<void> readFileData() async {
    // Map<String, dynamic> _formData = {};
    // BuildContext context;
    final _dirPath = await getDirPath();
    final logfilePath = File('$_dirPath/data.txt');
    final logDataSaved = await logfilePath.readAsString(encoding: utf8);
    /*  print("saved data on the file is $logDataSaved");
    log(logDataSaved); */

    final _myFile = File('$_dirPath/data.txt');

    print("File size is : ${await _myFile.length()}");

    if (await logfilePath.length() >= 10000) {
      print("Hello, its more than 10kb");

      // _formData['data'] = logDataSaved;
      try {
        await Provider.of<Groups>(context, listen: false)
            .recordLogAPIs(logdata: logDataSaved);
      } on CustomException catch (error) {
        StatusHandler()
            .handleStatus(context: context, error: error, callback: () {});
      }
      print("Data saved to the server");
      await _myFile.delete();
      // readFileData();
    } else {
      print("Hello, its less than 10kb");
      // readFileData();
    }
  }

/* 
  void _scrollChartToEnd() {
    _chartScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chartScrollController.animateTo(
        _chartScrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.ease,
      );
      //     .then((value) async {
      //   await Future.delayed(Duration(seconds: 2));
      //   _chartScrollController.animateTo(
      //     _chartScrollController.position.minScrollExtent,
      //     duration: Duration(seconds: 1),
      //     curve: Curves.ease,
      //   );
      // });
    });
  } */

  Future<void> getChartData() async {
    try {
      await Provider.of<Dashboard>(context, listen: false)
          .getGroupDepositVWithdrawals(_currentGroup.groupId);
      // _scrollChartToEnd();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            getChartData();
          });
    }
  }

  Iterable<Widget> get recentTransactionSummary sync* {
    int i = 0;
    for (var data in _iteratableRecentTransactionSummary) {
      yield Row(
        children: <Widget>[
          SizedBox(
            width: 16.0,
          ),
          InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap:
                () {} /* => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RecentTransactionReciept(data: data)),
            ) */
            ,
            child: Container(
              width: 160.0,
              padding: EdgeInsets.all(16.0),
              decoration: cardDecoration(
                  gradient: plainCardGradient(context), context: context),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: resetTransactions(
                      color: (i % 2 == 1) ? Colors.blueGrey : primaryColor,
                      paymentDescription: data.paymentTitle,
                      cardAmount: currencyFormat.format(data.paymentAmount),
                      currency: _groupCurrency,
                      cardIcon: Feather.pie_chart,
                      paymentDate: data.paymentDate,
                      paymentMethod: data.paymentMethod + " Payment",
                      contributionType: data.description)),
            ),
          ),
          SizedBox(
            width: ((i + 1) == _iteratableRecentTransactionSummary.length)
                ? 16.0
                : 0.0,
          ),
        ],
      );
      ++i;
    }
  }

  Iterable<Widget> get contributionsSummary sync* {
    int i = 0;
    print(_itableContributionSummary.length);
    for (var data in _itableContributionSummary) {
      yield Row(
        children: <Widget>[
          SizedBox(
            width: 16.0,
          ),
          Container(
            width: 160.0,
            padding: EdgeInsets.all(16.0),
            decoration: cardDecoration(
                gradient:
                    i == 0 ? csCardGradient() : plainCardGradient(context),
                context: context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: contributionSummary(
                color: i == 0
                    ? Colors.white
                    : i == 1
                        ? primaryColor
                        : Colors.blueGrey,
                cardIcon: i == 0 ? Feather.bar_chart_2 : Feather.bar_chart,
                amountDue: currencyFormat.format(data.balance),
                cardAmount: currencyFormat.format(data.amountPaid),
                currency: _groupCurrency,
                dueDate: data.dueDate,
                contributionName: data.contributionName,
              ),
            ),
          ),
          if (((i + 1) == _itableContributionSummary.length) &&
              _itableContributionSummary.length == 1)
            SizedBox(
              width: 16.0,
            ),
          if (((i + 1) == _itableContributionSummary.length) &&
              _itableContributionSummary.length == 1)
            Container(
              width: 160.0,
              padding: EdgeInsets.all(16.0),
              // decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SvgPicture.asset(
                  //   customIcons['no-data'],
                  //   semanticsLabel: 'icon',
                  //   height: 80.0,
                  // ),
                  Icon(
                    Feather.layers,
                    color: Colors.blueGrey[400].withOpacity(0.2),
                    size: 38.0,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  customTitleWithWrap(
                      text: "More contributions will be displayed here",
                      //fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      textAlign: TextAlign.center,
                      color: Colors.blueGrey[400].withOpacity(0.3))
                ],
              ),
            ),
          SizedBox(
            width: ((i + 1) == _itableContributionSummary.length) ? 16.0 : 0.0,
          ),
        ],
      );
      ++i;
    }
  }

  List cardList = [
    Contrubutions(),
    Fines(),
    Balances(),
    Expenses(),
  ];

  // Iterable<Widget> get accountSummary sync* {
  //   for (var data in _iteratableData) {
  //     yield Row(
  //       children: <Widget>[
  //         InkWell(
  //           onTap: () => Navigator.of(context).push(
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) =>
  //                     AccounBalancesReciept(data: data)),
  //           ),
  //           child: Container(
  //             width: 160.0,
  //             height: 165.0,
  //             padding: EdgeInsets.all(16.0),
  //             margin: EdgeInsets.all(0.0),
  //             decoration: cardDecoration(
  //                 gradient: plainCardGradient(context), context: context),
  //             child: accountBalance(
  //               color: primaryColor,
  //               cardIcon: Feather.credit_card,
  //               cardAmount: currencyFormat.format(data.balance),
  //               currency: _groupCurrency,
  //               accountName: data.accountName,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           width: 16.0,
  //         ),
  //       ],
  //     );
  //   }
  // }

  LineChartData eWalletTrend() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 5),
            FlSpot(1, 2),
            FlSpot(2, 6),
            FlSpot(3, 3),
            FlSpot(4, 4),
            FlSpot(5, 2),
            FlSpot(6, 4),
            FlSpot(7, 1),
            FlSpot(8, 3),
          ],
          isCurved: false,
          color: primaryColor,
          barWidth: 1,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color:
                //[
                primaryColor.withOpacity(0.07),
            //primaryColor.withOpacity(0.0),
            //  ],
            // gradientColorStops: [0.5, 1.0],
            // gradient: const Offset(0, 0),
            // gradientTo: const Offset(0, 1),
          ),
        ),
      ],
    );
  }

  void _openPayNowTray(BuildContext context) {
    Future<void> _initiatePayNow(
        {int paymentFor,
        int paymentForId,
        double amount,
        String phoneNumber,
        String description}) async {
      final Map<String, dynamic> _formData = {
        "payment_for": paymentFor,
        "contribution_id": paymentForId,
        "fine_category_id": paymentForId,
        "loan_id": paymentForId,
        "description": description,
        "amount": amount,
        "phone_number": phoneNumber
      };
      try {
        await Provider.of<Groups>(context, listen: false)
            .makeGroupPayment(_formData);
        Navigator.pop(context);
      } on CustomException catch (error) {
        Navigator.pop(context);
        StatusHandler().handleStatus(context: context, error: error);
      }
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: null,
            child: PayNowSheet(_initiatePayNow),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = Provider.of<Dashboard>(context);
    final memberRecentTransaction =
        Provider.of<MemberRecentTransaction>(context);
    final balancesDashboardSummary =
        Provider.of<BalancesDashboardSummary>(context);

    setState(() {
      _iteratableRecentTransactionSummary =
          /* dashboardData.recentMemberTransactions; */
          memberRecentTransaction.recentTransactions;
      // _iteratableData = dashboardData.bankAccountDashboardSummary;
      // _itableContributionSummary = dashboardData.memberContributionSummary;
      WidgetsBinding.instance.addPostFrameCallback((_) => () {
            widget.notificationCount(dashboardData.notificationCount);
          });
    });
    return WillPopScope(
        onWillPop: _onWillPop,
        child: RefreshIndicator(
          backgroundColor: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Colors.white,
          onRefresh: () => _getMemberDashboardDataNew(true),
          child: SafeArea(
              child: SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: !_isInit
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: false,
                        // _showMeetingsBanner,
                        // visible: _currentGroup.isGroupAdmin,
                        child: customShowCase(
                          key: meetingsBannarKey,
                          title: "Chamasoft Meetings Banner",
                          description:
                              "Schedule,View and Manage Chama Meetings",
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              16.0,
                              16.0,
                              16.0,
                              16.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: cardDecoration(
                                gradient: plainCardGradient(context),
                                context: context,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Stack(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                        'assets/meeting-minutes.jpg',
                                      ),
                                      width: double.infinity,
                                    ),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        color: Colors.black.withOpacity(0.3),
                                        padding: EdgeInsets.only(
                                          right: 16.0,
                                          top: 6.0,
                                          bottom: 16.0,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "${Config.appName} Meetings",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'SegoeUI',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22.0,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                                subtitle2(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  text:
                                                      "Manage group meetings, easily.",
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () =>
                                                  Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Meetings(),
                                                ),
                                              ),
                                              child: Text(
                                                "Get Started",
                                                // "Our meetings",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'SegoeUI',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                print("dont show 1");
                                                hideBanner();
                                                print("dont show 2");
                                              },
                                              child: Text(
                                                "Don't show this again",
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontFamily: 'SegoeUI',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 11.0,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Balances",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            plainButtonWithArrow(
                                text: "View All",
                                size: 16.0,
                                spacing: 2.0,
                                color: Colors.blue,
                                action: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AccountBalances()),
                                    ))
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 180.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            SizedBox(
                              width: 16.0,
                            ),
                            InkWell(
                              onTap: () {},
                              /*=> Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TotalAccountBalanceReciept(
                                            totalBalance: */ /*dashboardData
                                                .totalBankBalances*/ /*balancesDashboardSummary
                                                .totalBackBalanceAccount)),
                              ),*/
                              child: Container(
                                width: 160.0,
                                padding: EdgeInsets.all(16.0),
                                decoration: cardDecoration(
                                    gradient: csCardGradient(),
                                    context: context),
                                child: accountBalance(
                                  color: Colors.white,
                                  cardIcon: Feather.globe,
                                  cardAmount: currencyFormat.format(
                                      /* dashboardData.totalBankBalances */
                                      balancesDashboardSummary
                                          .totalBackBalanceAccount),
                                  currency: _groupCurrency,
                                  accountName: "Total",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            /* _iteratableData.length > 0
                                ? Row(
                                    children: accountSummary.toList(),
                                  )
                                :  */
                            Row(children: <Widget>[
                              Container(
                                width: 160.0,
                                height: 165.0,
                                padding: EdgeInsets.all(16.0),
                                decoration: cardDecoration(
                                    gradient: plainCardGradient(context),
                                    context: context),
                                child: accountBalance(
                                  color: primaryColor,
                                  cardIcon: Feather.credit_card,
                                  cardAmount: currencyFormat.format(
                                      /* dashboardData.bankBalances */
                                      balancesDashboardSummary
                                          .bankAccountBalance),
                                  currency: _groupCurrency,
                                  accountName: "Cash at Bank",
                                ),
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Container(
                                width: 160.0,
                                height: 165.0,
                                padding: EdgeInsets.all(16.0),
                                decoration: cardDecoration(
                                    gradient: plainCardGradient(context),
                                    context: context),
                                child: accountBalance(
                                  color: primaryColor,
                                  cardIcon: Feather.credit_card,
                                  cardAmount: currencyFormat.format(
                                      /* dashboardData.cashBalances */
                                      balancesDashboardSummary
                                          .cashAccounBalance),
                                  currency: _groupCurrency,
                                  accountName: "Cash at Hand",
                                ),
                              )
                            ]),
                          ],
                        ),
                      ),
                      SizedBox(height: 0),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _currentIndex == 0
                                  ? "Contribution Summary"
                                  : _currentIndex == 1
                                      ? "Fine Summary"
                                      : _currentIndex == 2
                                          ? "Loan Summary"
                                          : "Expenses Summary",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            plainButtonWithArrow(
                                text: "View All",
                                size: 16.0,
                                spacing: 2.0,
                                color: Colors.blue,
                                action: () => _currentIndex == 0
                                    ? Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ContributionSummary(),
                                            settings: RouteSettings(
                                                arguments:
                                                    CONTRIBUTION_STATEMENT)))
                                    : _currentIndex == 1
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ContributionSummary(),
                                                settings: RouteSettings(
                                                    arguments: FINE_STATEMENT)))
                                        : _currentIndex == 2
                                            ? Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        GroupLoansSummary()),
                                              )
                                            : Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ExpenseSummary()),
                                              ))
                          ],
                        ),
                        /* child: Text(
                          "Transactional Summary",
                          style: TextStyle(
                            color: Colors.blueGrey[400],
                            fontFamily: 'SegoeUI',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ), */
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: cardDecoration(
                            gradient: plainCardGradient(context),
                            context: context,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Center(
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    height: 195.0,
                                    // ignore: todo
                                    //TODO enable autoplay
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 10),
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 1000),
                                    autoPlayCurve: Curves.easeInCirc,
                                    pauseAutoPlayOnTouch: true,
                                    aspectRatio: 2.0,
                                    initialPage: 0,
                                    viewportFraction: 1.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _currentIndex = index;
                                      });
                                    },
                                  ),
                                  items: cardList.map((card) {
                                    return Builder(
                                        builder: (BuildContext context) {
                                      return Container(
                                        // height:
                                        //     MediaQuery.of(context).size.height *
                                        //         0.70,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // child: Card(
                                        child: card,
                                        //),
                                      );
                                    });
                                  }).toList(),
                                ),
                              ),

                              SizedBox(
                                height: 5,
                              ),
                              customSlider(
                                  context: context,
                                  count: cardList,
                                  index: _currentIndex)
                              // animationSlider(),
                            ],
                          ),
                        ),
                      ),
                      if (Config.appName.toLowerCase() == "chamasoft")
                        if (_onlineBankingEnabled)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Make Payments",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
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

                            /* child: Text(
                          "Make Payments",
                          style: TextStyle(
                            color: Colors.blueGrey[400],
                            fontFamily: 'SegoeUI',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ), */
                          ),
                      if (Config.appName.toLowerCase() == "chamasoft")
                        if (_onlineBankingEnabled)
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: paymentActionButton(
                                      color: primaryColor,
                                      textColor: primaryColor,
                                      icon: FontAwesome.chevron_right,
                                      isFlat: false,
                                      text: "PAY NOW",
                                      iconSize: 12.0,
                                      action: () => _openPayNowTray(context),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                  child: Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: paymentActionButton(
                                          color: primaryColor,
                                          textColor: Colors.white,
                                          icon: FontAwesome.chevron_right,
                                          isFlat: true,
                                          text: "APPLY LOAN",
                                          iconSize: 12.0,
                                          action:
                                              () {} /* => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              /* ApplyLoan */(){},
                                        ),
                                      ), */
                                          ),
                                    ),
                                  ),
                                ),
                                // /*  Expanded(
                                //   child: */
                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     circleIconButton(
                                //       icon: Icons.import_export,
                                //       backgroundColor:
                                //           primaryColor /* rimaryColor.withOpacity(.3) */,
                                //       color: Colors.white,
                                //       iconSize: 24.0,
                                //       padding: 0.0,
                                //       onPressed: () => _openPayNowTray(context),
                                //     ),
                                //     SizedBox(height: 10),
                                //     customTitle1(
                                //       text: 'Make Payment',
                                //       color: Theme.of(context)
                                //           // ignore: deprecated_member_use
                                //           .textSelectionHandleColor,
                                //       textAlign: TextAlign.start,
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w600,
                                //     ),
                                //   ],
                                // ),
                                /*  ), */
                                // SizedBox(width: 100),
                                // Expanded(
                                //   child: Column(
                                //     children: [
                                //       circleIconButton(
                                //         icon: Icons.credit_card,
                                //         backgroundColor:
                                //             primaryColor /* rimaryColor.withOpacity(.3) */,
                                //         color: Colors.white,
                                //         iconSize: 24.0,
                                //         padding: 0.0,
                                //         onPressed:
                                //             () /*  =>
                                //               _showActions(context, incomeCategory) */
                                //             {},
                                //       ),
                                //       SizedBox(height: 10),
                                //       customTitle1(
                                //         text: 'Apply Loan',
                                //         color: Theme.of(context)
                                //             // ignore: deprecated_member_use
                                //             .textSelectionHandleColor,
                                //         textAlign: TextAlign.start,
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Transactions",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontFamily: 'SegoeUI',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            plainButtonWithArrow(
                                text: "View All",
                                size: 16.0,
                                spacing: 2.0,
                                color: Colors.blue,
                                action: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ContributionStatement()),
                                    ))
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      recentTransactionSummary?.length > 0
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                              child: customShowCase(
                                key: recentTransactionKey,
                                title: 'Recent Summary',
                                description:
                                    'Scroll Horizontal to View all your recent Transactions',
                                textColor:
                                    // ignore: deprecated_member_use
                                    Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                child: Container(
                                  height: 180.0,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    padding:
                                        EdgeInsets.only(top: 5.0, bottom: 10.0),
                                    physics: BouncingScrollPhysics(),
                                    children: recentTransactionSummary.toList(),
                                  ),
                                ),
                              ),
                            )
                          : recentTransactionSummary == null
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      16.0, 10.0, 16.0, 20.0),
                                  child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(16.0),
                                      decoration: flatGradient(context),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            customIcons['no-data'],
                                            semanticsLabel: 'icon',
                                            height: 120.0,
                                          ),
                                          customTitleWithWrap(
                                              text: "Nothing to display!",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.0,
                                              textAlign: TextAlign.center,
                                              color: Colors.blueGrey[400]),
                                          customTitleWithWrap(
                                              text:
                                                  "Sorry, you haven't made any transactions",
                                              //fontWeight: FontWeight.w500,
                                              fontSize: 12.0,
                                              textAlign: TextAlign.center,
                                              color: Colors.blueGrey[400])
                                        ],
                                      )),
                                )
                              : Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      16.0, 10.0, 16.0, 20.0),
                                  child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(16.0),
                                      decoration: flatGradient(context),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            customIcons['no-data'],
                                            semanticsLabel: 'icon',
                                            height: 120.0,
                                          ),
                                          customTitleWithWrap(
                                              text: "Nothing to display!",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.0,
                                              textAlign: TextAlign.center,
                                              color: Colors.blueGrey[400]),
                                          customTitleWithWrap(
                                              text:
                                                  "Sorry, you haven't made any transactions",
                                              //fontWeight: FontWeight.w500,
                                              fontSize: 12.0,
                                              textAlign: TextAlign.center,
                                              color: Colors.blueGrey[400])
                                        ],
                                      )),
                                ),
                    ],
                  )
                : newHomePlaceHolder(context: context),
            // : homePlaceholder(context: context),
            // : dataLoadingEffect(
            //     context: context,
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height),
          )),
        ));
  }

  void _meetingsBannerStatus() async {
    dynamic _bannerDbStatus = [
      {
        'group_id': _currentGroup.groupId,
        'show_banner': true,
      },
    ];
    Map<String, dynamic> _banner = _bannerDbStatus[0];
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("meetings-banner")) {
      String bannerStatusObject = prefs.getString("meetings-banner");
      _bannerDbStatus = jsonDecode(bannerStatusObject);
    }
    List<dynamic> _filtered = _bannerDbStatus
        .where((s) => s['group_id'] == _currentGroup.groupId)
        .toList();
    if (_filtered.length == 1) _banner = _filtered[0];
    setState(() {
      if ((_currentGroup.isGroupAdmin) && (_banner['show_banner']))
        _showMeetingsBanner = true;
      else
        _showMeetingsBanner = false;
    });
  }

  void hideBanner() async {
    List<dynamic> _bannerDbStatus = [
      {
        'group_id': _currentGroup.groupId,
        'show_banner': false,
      },
    ];
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("meetings-banner")) {
      String bannerStatusObject = prefs.getString("meetings-banner");
      _bannerDbStatus = jsonDecode(bannerStatusObject);
      List<dynamic> _filtered = _bannerDbStatus
          .where((s) => s['group_id'] == _currentGroup.groupId)
          .toList();
      if (_bannerDbStatus.length > 0) {
        if (_filtered.length == 0) {
          _bannerDbStatus.add(
            {
              'group_id': _currentGroup.groupId,
              'show_banner': false,
            },
          );
        } else {
          int _idx = _bannerDbStatus
              .indexWhere((b) => b['group_id'] == _currentGroup.groupId);
          _bannerDbStatus.removeAt(_idx);
          _bannerDbStatus.add(
            {
              'group_id': _currentGroup.groupId,
              'show_banner': false,
            },
          );
        }
      }
    }
    await prefs.setString("meetings-banner", jsonEncode(_bannerDbStatus));
    setState(() {
      _showMeetingsBanner = false;
    });
  }

// customSlider({BuildContext context, count, index}) {}
}

class Contrubutions extends StatefulWidget {
  @override
  State<Contrubutions> createState() => _ContrubutionsState();
}

class _ContrubutionsState extends State<Contrubutions> {
  List<ContributionStatementRow> _contributionStatements = [];
  ContributionStatementModel _contributionStatementModel;
  double _totalContribution = 0;
  // bool _isInit = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  Future<void> _fetchContributionBreakDownData() async {
    _contributionStatementModel =
        Provider.of<Groups>(context, listen: false).getContributionStatements;

    if (_contributionStatementModel != null) {
      _contributionStatements = _contributionStatementModel.statements;
      _totalContribution = _contributionStatementModel.totalPaid;
      // _totalPaid = _contributionStatementModel.totalPaid;
    }

    await Provider.of<Groups>(context, listen: false)
        .fetchContributionStatement(CONTRIBUTION_STATEMENT)
        .then((_) {
      _contributionStatementModel =
          Provider.of<Groups>(context, listen: false).getContributionStatements;
      if (_contributionStatementModel != null) {
        _contributionStatements = _contributionStatementModel.statements;
        _totalContribution = _contributionStatementModel.totalPaid;
        // _totalPaid = _contributionStatementModel.totalPaid;
      }
    });
  }

  void _contributionSummaryAlertDialog() async {
    Group _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text("Contribution Summary"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: customTitle1(
                      text: "Ok",
                      fontSize: 14,
                      color: Theme.of(context).primaryColor))
            ],
            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: subtitle3(
                              text: "Date",
                              color: Theme.of(context).primaryColor,
                              textAlign: TextAlign.start),
                        ),
                        Expanded(
                          flex: 1,
                          child: subtitle3(
                              text: 'Paid (${_currentGroup.groupCurrency})',
                              color: Theme.of(context).primaryColor,
                              textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Container(
                        child: _contributionStatements.length > 0
                            ? Container(
                                // height:
                                //     400,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _contributionStatements.length,
                                    itemBuilder: (context, index) {
                                      ContributionStatementRow row =
                                          _contributionStatements[index];
                                      return Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5.0),
                                                child: Text(
                                                  '\u2022',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    customTitle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      text: row.date,
                                                      color: Theme.of(context)
                                                          .textSelectionTheme
                                                          .selectionHandleColor,
                                                    ),
                                                    customTitle2(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        text: row.title,
                                                        color: Theme.of(context)
                                                            .textSelectionTheme
                                                            .selectionHandleColor,
                                                        textAlign:
                                                            TextAlign.start),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.black,
                                                thickness: 2,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: customTitle(
                                                    fontSize: 14,
                                                    text: currencyFormat
                                                        .format(row.amount),
                                                    color: Theme.of(context)
                                                        .textSelectionTheme
                                                        .selectionHandleColor,
                                                    textAlign: TextAlign.end),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            : customTitle(
                                text: "No Contributions yet",
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTitle1(
                              text: "Total Amount",
                              fontSize: 14,
                              textAlign: TextAlign.start),
                          customTitle1(
                              text: _currentGroup.groupCurrency +
                                  " " +
                                  currencyFormat.format(_totalContribution),
                              fontSize: 16,
                              textAlign: TextAlign.end)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _displayContributionSummaryDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    customTitle1(text: "Loading", fontSize: 14)
                  ],
                )),
          );
        });

    await _fetchContributionBreakDownData();
    Navigator.of(context).pop();
    _contributionSummaryAlertDialog();
  }

  Future<void> _getContributionStatement(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchContributionStatement(CONTRIBUTION_STATEMENT);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () => _fetchContributionBreakDownData(),
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dashboard dashboardData = Provider.of<Dashboard>(context);
    //  Dashboard dashboardData = Provider.of<Dashboard>(context);
    DashboardContributionSummary dashboardContributionSummary =
        Provider.of<DashboardContributionSummary>(context);
    final currencyFormat = new NumberFormat("#,##0", "en_US");
    Group _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    // bool _isLoading = false;

    Future<void> _getContributionsSummary(BuildContext context) async {
      try {
        // await Provider.of<DashboardFineSummary>(context, listen: false)
        //     .getFinesSummary(_currentGroup.groupId);
        setState(() {
          _isLoading = true;
        });

        await Provider.of<DashboardContributionSummary>(context, listen: true)
            .getContributionsSummary(_currentGroup.groupId);

        setState(() {
          _isLoading = false;
        });
      } on CustomException catch (error) {
        StatusHandler().handleStatus(
            context: context,
            error: error,
            callback: () {
              _getContributionsSummary(context);
            });
      } finally {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    if (!Provider.of<DashboardContributionSummary>(context, listen: false)
        .groupContributionSummaryExists(_currentGroup.groupId)) {
      _getContributionsSummary(context);
    }

    var nextContributionDate = DateTime.fromMillisecondsSinceEpoch(
        dashboardContributionSummary.nextcontributionDate * 1000);

    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String nextContributionDateFormatted =
        formatter.format(nextContributionDate);
    print("formatted $nextContributionDateFormatted");
    print("nextContributionDate $nextContributionDate");

    final groupTotalContribution =
        dashboardContributionSummary.groupContributionAmount -
            dashboardContributionSummary.memberContributionAmount;

    Map<String, double> dataMap = {
      "Your Total Contribution":
          (/* dashboardData.memberContributionAmount
                  .abs() */
              dashboardContributionSummary.memberContributionAmount.abs()),
      "Group Total Contribution": /* dashboardData.groupContributionAmount.abs() */ /*dashboardContributionSummary
          .groupContributionAmount*/
          groupTotalContribution.abs(),
    };

    final List<Color> color = <Color>[];
    color.addAll(
      [Color(0xff8f2c21), Color(0xff561913)],
    );

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final List<Color> colorList = <Color>[];
    colorList.addAll(color);

    final gradientList = <List<Color>>[
      // [Colors.red[200], Colors.red[200]],
      [primaryColor.withOpacity(.3), primaryColor.withOpacity(.3)],
      [Color(0xFF00ABF2), Color(/* 0xFF008CC5 */ 0xFF00ABF2)],
    ];

    print("Current state is $_isLoading ");

    return /* dashboardContributionSummary.groupContributionAmount.abs() > 0 */ !_isLoading
        ? Container(
            child: dashboardContributionSummary.groupContributionAmount.abs() >
                    0
                ? Container(
                    color: Theme.of(context).backgroundColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              chart.PieChart(
                                dataMap: dataMap,
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 3.2,
                                initialAngleInDegree: 0,
                                ringStrokeWidth: 32,
                                // colorList: [Colors.red[300], primaryColor],
                                gradientList: gradientList,
                                // gradientList: [colorMain, color],
                                // centerTextStyle:
                                //     TextStyle(fontFamily: 'SegoeUI', fontSize: 36.0),
                                legendOptions: chart.LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: chart.LegendPosition.bottom,
                                  showLegends: false,
                                  legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      // ignore: deprecated_member_use
                                      color: Theme.of(context)
                                          .textSelectionTheme
                                          .selectionHandleColor),
                                ),
                                chartValuesOptions: chart.ChartValuesOptions(
                                  showChartValueBackground: false,
                                  showChartValues: true,
                                  showChartValuesInPercentage: true,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 0,
                                  chartValueStyle: TextStyle(
                                    fontFamily: 'SegoeUI',
                                    fontSize: 14.0,
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionTheme
                                        .selectionColor,
                                    fontWeight: FontWeight.w500,
                                    // ignore: deprecated_member_use
                                    /* color: Colors.black */
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  customTitle(
                                    text: "Your Total Contribution",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                  ),
                                  /* dashboardData.memberContributionAmount */
                                  dashboardContributionSummary
                                              .memberContributionAmount
                                              .abs() >
                                          0
                                      ? Row(
                                          children: [
                                            circleButton(
                                              backgroundColor: /* dashboardData
                                                  .memberContributionAmount >
                                              0
                                          ?  */
                                                  // Colors.red[300]
                                                  primaryColor.withOpacity(.3)
                                              /* : Colors
                                              .white */ /* rimaryColor.withOpacity(.3) */,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            customTitle1(
                                              text: /* _currentGroup.disableArrears
                                                                                  ? */
                                                  _currentGroup.groupCurrency +
                                                      " " +
                                                      currencyFormat.format(
                                                          /* dashboardData
                                                  .memberContributionAmount */
                                                          dashboardContributionSummary
                                                              .memberContributionAmount
                                                              .abs())
                                              /*  : _currentGroup.groupCurrency +
                                              " " +
                                              currencyFormat.format(dashboardData
                                                  .memberContributionArrears) */
                                              ,
                                              color: /* (dashboardData
                                                  .memberContributionArrears) >
                                              0
                                                                                  ? Colors.red[400]
                                                                                  : */
                                                  Theme.of(context)
                                                      // ignore: deprecated_member_use
                                                      .textSelectionTheme
                                                      .selectionHandleColor,
                                              textAlign: TextAlign.start,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        )
                                      : customTitle1(
                                          text: /* _currentGroup.disableArrears
                                      ? */
                                              _currentGroup.groupCurrency +
                                                  " " +
                                                  currencyFormat.format(
                                                      /* dashboardData
                                              .memberContributionAmount */
                                                      dashboardContributionSummary
                                                          .memberContributionAmount
                                                          .abs())
                                          /*  : _currentGroup.groupCurrency +
                                          " " +
                                          currencyFormat.format(dashboardData
                                              .memberContributionArrears) */
                                          ,
                                          color:
                                              /* (dashboardData.memberContributionArrears) >
                                              0
                                          ? Colors.red[400]
                                          : */
                                              Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme
                                                  .selectionHandleColor,
                                          textAlign: TextAlign.start,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  customTitle(
                                    text: "Group Total Contribution",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                  ),
                                  dashboardContributionSummary
                                              .groupContributionAmount >
                                          0
                                      ? Row(children: [
                                          circleButton(
                                            backgroundColor: /*  dashboardData
                                          .groupPendingLoanBalance >
                                      0
                                  ? */
                                                primaryColor
                                            /*  : Colors
                                      .white  */ /* rimaryColor.withOpacity(.3) */,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          customTitle1(
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionTheme
                                                .selectionHandleColor,
                                            text: _currentGroup.groupCurrency +
                                                " " +
                                                currencyFormat.format(
                                                    /* dashboardData
                                            .groupContributionAmount */
                                                    dashboardContributionSummary
                                                        .groupContributionAmount
                                                        .abs()),
                                            textAlign: TextAlign.start,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ])
                                      : Row(
                                          children: [
                                            //   circleButton(
                                            //     backgroundColor: /*  dashboardData
                                            //         .groupPendingLoanBalance >
                                            //     0
                                            // ? */
                                            //         primaryColor
                                            //     /*  : Colors
                                            //     .white  */ /* rimaryColor.withOpacity(.3) */,
                                            //   ),
                                            //   SizedBox(
                                            //     width: 10,
                                            //   ),
                                            customTitle1(
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme
                                                  .selectionHandleColor,
                                              text: _currentGroup
                                                      .groupCurrency +
                                                  " " +
                                                  currencyFormat.format(
                                                      /* dashboardData
                                              .groupContributionAmount */
                                                      dashboardContributionSummary
                                                          .groupContributionAmount
                                                          .abs()),
                                              textAlign: TextAlign.start,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _displayContributionSummaryDialog(
                                          context);
                                    },
                                    child: customTitle(
                                        text: "View your Contributions",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.green),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 0.5,
                            dashLength: 2.0,
                            dashColor: Colors.black45,
                            dashRadius: 0.0,
                            dashGapLength: 2.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customTitle(
                                          text: (/* dashboardData.memberContributionArrears */ dashboardContributionSummary
                                                      .memberContributionArrears) <
                                                  0
                                              ? "Your Contribution overpayment"
                                              : "Your Contribution Arrears",
                                          fontSize: 12,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionTheme
                                              .selectionHandleColor,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        customTitle1(
                                          text: /*  _currentGroup.disableArrears
                                          ?
                                          _currentGroup.groupCurrency +
                                              " " +
                                              currencyFormat.format(dashboardData
                                                  .memberContributionAmount)
                                       : */
                                              _currentGroup.groupCurrency +
                                                  " " +
                                                  currencyFormat.format(
                                                      /* dashboardData
                                              .memberContributionArrears
                                              .abs() */
                                                      dashboardContributionSummary
                                                          .memberContributionArrears
                                                          .abs()),
                                          color:
                                              (/* dashboardData
                                              .memberContributionArrears */
                                                          dashboardContributionSummary
                                                              .memberContributionArrears) >
                                                      0
                                                  ? Colors.red[400]
                                                  : (/* dashboardData
                                                  .memberContributionArrears */
                                                              dashboardContributionSummary
                                                                  .memberContributionArrears) <
                                                          0
                                                      ? Colors.green
                                                      : Theme.of(context)
                                                          // ignore: deprecated_member_use
                                                          .textSelectionTheme
                                                          .selectionHandleColor,
                                          textAlign: TextAlign.start,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTitle(
                                        text: "Next Contribution Date",
                                        fontSize: 12,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionTheme
                                            .selectionHandleColor,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          customTitle1(
                                            text:
                                                // "${DateFormat('MM-dd-yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.tryParse(dashboardContributionSummary.nextcontributionDate)))} (${dashboardContributionSummary.contributionDateDaysleft == "0 days" ? "today" : dashboardContributionSummary.contributionDateDaysleft != null ? "${dashboardContributionSummary.contributionDateDaysleft} left" : "--"})",

                                                "${/* defaultDateFormat.format */ (nextContributionDateFormatted)} (${dashboardContributionSummary.contributionDateDaysleft == "0 days" ? "today" : dashboardContributionSummary.contributionDateDaysleft != null ? "${dashboardContributionSummary.contributionDateDaysleft} left" : "--"})",
                                            // "${dashboardData.nextcontributionDate} (${(dashboardData.contributionDateDaysleft == "0 days" ? "today" : dashboardData.contributionDateDaysleft != null ? '${dashboardData.contributionDateDaysleft} left' : "--")})",
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionTheme
                                                .selectionHandleColor,
                                            textAlign: TextAlign.start,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: flatGradient(context),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              customIcons['no-data'],
                              semanticsLabel: 'icon',
                              height: 120.0,
                            ),
                            customTitleWithWrap(
                                text: "Nothing to display!",
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0,
                                textAlign: TextAlign.center,
                                color: Colors.blueGrey[400]),
                            customTitleWithWrap(
                                text:
                                    "Sorry, There are no contibutions available",
                                //fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                                textAlign: TextAlign.center,
                                color: Colors.blueGrey[400])
                          ],
                        )),
                  ))
        : Container(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: flatGradient(context),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      customIcons['no-data'],
                      semanticsLabel: 'icon',
                      height: 120.0,
                    ),
                    customTitleWithWrap(
                        text: "Fetching Data!",
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        textAlign: TextAlign.center,
                        color: Colors.blueGrey[400]),
                    customTitleWithWrap(
                        text: "Fetching Contribution Summary, Please wait...",
                        //fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        textAlign: TextAlign.center,
                        color: Colors.blueGrey[400])
                  ],
                )),
          );
  }
}

// ignore: unused_element
void _openPayNowTray(BuildContext context) {
  Future<void> _initiatePayNow(
      {int paymentFor,
      int paymentForId,
      double amount,
      String phoneNumber,
      String description}) async {
    final Map<String, dynamic> _formData = {
      "payment_for": paymentFor,
      "contribution_id": paymentForId,
      "fine_category_id": paymentForId,
      "loan_id": paymentForId,
      "description": description,
      "amount": amount,
      "phone_number": phoneNumber
    };
    try {
      await Provider.of<Groups>(context, listen: false)
          .makeGroupPayment(_formData);
      Navigator.pop(context);
    } on CustomException catch (error) {
      Navigator.pop(context);
      StatusHandler().handleStatus(context: context, error: error);
    }
  }

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: null,
          child: PayNowSheet(_initiatePayNow),
          behavior: HitTestBehavior.opaque,
        );
      });
}

class Fines extends StatefulWidget {
  const Fines({Key key}) : super(key: key);

  @override
  State<Fines> createState() => _FinesState();
}

class _FinesState extends State<Fines> {
  @override
  Widget build(BuildContext context) {
    // Dashboard dashboardData = Provider.of<Dashboard>(context);
    DashboardFineSummary dashboardFineSummary =
        Provider.of<DashboardFineSummary>(context);

    final currencyFormat = new NumberFormat("#,##0", "en_US");
    Group _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    bool _isInit = true;
    LoanDashboardSummary loanDashboardSummary =
        Provider.of<LoanDashboardSummary>(context);

    bool _isLoading = false;

    Future<void> _getFinesSummary(BuildContext context) async {
      try {
        // await Provider.of<DashboardFineSummary>(context, listen: false)
        //     .getFinesSummary(_currentGroup.groupId);
        setState(() {
          _isLoading = true;
        });

        await Provider.of<DashboardFineSummary>(context, listen: false)
            .getFinesSummary(_currentGroup.groupId);

        setState(() {
          _isLoading = false;
        });
      } on CustomException catch (error) {
        StatusHandler().handleStatus(
            context: context,
            error: error,
            callback: () {
              _getFinesSummary(context);
            });
      } finally {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    if (!Provider.of<DashboardFineSummary>(context, listen: false)
        .groupFineSummaryExists(_currentGroup.groupId)) {
      _getFinesSummary(context);
    }

    final groupTotalFine = dashboardFineSummary.totalGroupFinePaid -
        dashboardFineSummary.memberFinePaid;
    Map<String, double> dataMap = {
      "Your Total Fines":
          (/* dashboardData.memberFineAmount */ dashboardFineSummary
              .memberFinePaid
              .abs()),
      "Group Total Fines": groupTotalFine,
      // "Group Total; Fines": /* dashboardData.groupFinePaymentAmount */ double.tryParse(dashboardFineSummary
      //     .totalGroupFinePaid
      //     .abs().toString()),
    };
    final gradientList = <List<Color>>[
      // [Colors.red[200], Colors.red[200]],
      [primaryColor.withOpacity(.3), primaryColor.withOpacity(.3)],

      [Color(0xFF00ABF2), Color(0xFF00ABF2)],
    ];
    return !_isLoading
        ? Container(
            child: dashboardFineSummary.totalGroupFinePaid > 0
                ? Container(
                    color: Theme.of(context).backgroundColor,
                    child: Column(children: [
                      Row(
                        children: [
                          chart.PieChart(
                            dataMap: dataMap,
                            animationDuration: Duration(milliseconds: 800),
                            chartLegendSpacing: 32,
                            chartRadius:
                                MediaQuery.of(context).size.width / 3.2,
                            initialAngleInDegree: 0,
                            ringStrokeWidth: 32,
                            // colorList: [Colors.red[300], primaryColor],
                            gradientList: gradientList,
                            legendOptions: chart.LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: chart.LegendPosition.right,
                              showLegends: false,
                              legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  // ignore: deprecated_member_use
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor),
                            ),
                            chartValuesOptions: chart.ChartValuesOptions(
                                showChartValueBackground: false,
                                showChartValues: true,
                                showChartValuesInPercentage: true,
                                showChartValuesOutside: false,
                                decimalPlaces: 0,
                                chartValueStyle: TextStyle(
                                    fontFamily: 'SegoeUI',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    // ignore: deprecated_member_use
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionTheme
                                        .selectionHandleColor)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              customTitle(
                                text: "Your Total Fines Paid",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionTheme
                                    .selectionColor,
                              ),
                              /* dashboardData.memberFineAmount */ dashboardFineSummary
                                          .memberFinePaid
                                          .abs() >
                                      0
                                  ? Row(
                                      children: [
                                        circleButton(
                                          backgroundColor: /*  dashboardData.memberFineArrears
                                        .abs() >
                                    0
                                ? */
                                              // Colors.red[300]

                                              primaryColor.withOpacity(
                                                  .3) /* : Colors
                                    .white */ /* rimaryColor.withOpacity(.3) */,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        customTitle1(
                                          text: /* _currentGroup.disableArrears
                                      ?  */
                                              _currentGroup.groupCurrency +
                                                  " " +
                                                  currencyFormat.format(
                                                      /* dashboardData.memberFineAmount */
                                                      dashboardFineSummary
                                                          .memberFinePaid)
                                          /* : _currentGroup.groupCurrency +
                                          " " +
                                          currencyFormat.format(
                                              dashboardData.memberFineArrears) */
                                          ,
                                          color: /*  (dashboardData.memberFineArrears) > 0
                                      ? Colors.red[400]
                                      : */
                                              Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme
                                                  .selectionHandleColor,
                                          textAlign: TextAlign.start,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    )
                                  : customTitle1(
                                      text: /* _currentGroup.disableArrears
                                  ?  */
                                          _currentGroup.groupCurrency +
                                              " " +
                                              currencyFormat.format(
                                                  /* dashboardData.memberFineAmount */
                                                  dashboardFineSummary
                                                      .memberFinePaid)
                                      /* : _currentGroup.groupCurrency +
                                      " " +
                                      currencyFormat.format(
                                          dashboardData.memberFineArrears) */
                                      ,
                                      color: /* (dashboardData.memberFineArrears) > 0
                                  ? Colors.red[400]
                                  :  */
                                          Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionTheme
                                              .selectionHandleColor,
                                      textAlign: TextAlign.start,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                              customTitle(
                                text: "Group Total Fines Paid",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionTheme
                                    .selectionHandleColor,
                              ),
                              dashboardFineSummary.totalGroupFinePaid > 0
                                  ? Row(
                                      children: [
                                        circleButton(
                                          backgroundColor: primaryColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        customTitle1(
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionTheme
                                              .selectionHandleColor,
                                          text: _currentGroup.groupCurrency +
                                              " " +
                                              currencyFormat.format(
                                                  /* dashboardData.groupFinePaymentAmount */
                                                  dashboardFineSummary
                                                      .totalGroupFinePaid),
                                          textAlign: TextAlign.start,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    )
                                  : customTitle1(
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionTheme
                                          .selectionHandleColor,
                                      text: _currentGroup.groupCurrency +
                                          " " +
                                          currencyFormat.format(
                                              /* dashboardData.groupFinePaymentAmount */
                                              dashboardFineSummary
                                                  .totalGroupFinePaid),
                                      textAlign: TextAlign.start,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                            ],
                          ),
                        ],
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 0.5,
                        dashLength: 2.0,
                        dashColor: Colors.black45,
                        dashRadius: 0.0,
                        dashGapLength: 2.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {},
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customTitle(
                                      text:
                                          (/* dashboardData.memberFineArrears */ dashboardFineSummary
                                                      .memberFineArrears) <
                                                  0
                                              ? "Your Fine overpayment"
                                              : "Your Fine Arrears",
                                      fontSize: 15,
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionTheme
                                          .selectionHandleColor,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    customTitle1(
                                      text: /*  _currentGroup.disableArrears
                                        ?
                                        _currentGroup.groupCurrency +
                                            " " +
                                            currencyFormat.format(dashboardData
                                                .memberContributionAmount)
                                     : */
                                          _currentGroup.groupCurrency +
                                              " " +
                                              currencyFormat.format(
                                                  /* dashboardData
                                          .memberFineArrears */
                                                  dashboardFineSummary
                                                      .memberFineArrears
                                                      .abs()),
                                      color: (/* dashboardData.memberFineArrears */ dashboardFineSummary
                                                  .memberFineArrears) >
                                              0
                                          ? Colors.red[400]
                                          : (/* dashboardData.memberFineArrears */ dashboardFineSummary
                                                      .memberFineArrears) <
                                                  0
                                              ? Colors.green
                                              : Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme
                                                  .selectionHandleColor,
                                      textAlign: TextAlign.start,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      )
                    ]))
                : Container(
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: flatGradient(context),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              customIcons['no-data'],
                              semanticsLabel: 'icon',
                              height: 120.0,
                            ),
                            customTitleWithWrap(
                                text: "Nothing to display!",
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0,
                                textAlign: TextAlign.center,
                                color: Colors.blueGrey[400]),
                            customTitleWithWrap(
                                text: "Sorry, There are no Fines available",
                                //fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                                textAlign: TextAlign.center,
                                color: Colors.blueGrey[400])
                          ],
                        )),
                  ),
          )
        : Container(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: flatGradient(context),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      customIcons['no-data'],
                      semanticsLabel: 'icon',
                      height: 120.0,
                    ),
                    customTitleWithWrap(
                        text: "Fetching Data!",
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        textAlign: TextAlign.center,
                        color: Colors.blueGrey[400]),
                    customTitleWithWrap(
                        text: "Fetching Fine Summary, Please wait...",
                        //fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        textAlign: TextAlign.center,
                        color: Colors.blueGrey[400])
                  ],
                )),
          );
  }
}

class Balances extends StatefulWidget {
  final ActiveLoan loan;

  const Balances({Key key, this.loan}) : super(key: key);

  @override
  State<Balances> createState() => _BalancesState();
}

class _BalancesState extends State<Balances> {
  @override
  Widget build(BuildContext context) {
    // Dashboard dashboardData = Provider.of<Dashboard>(context);
    LoanDashboardSummary loanDashboardSummary =
        Provider.of<LoanDashboardSummary>(context);

    final currencyFormat = new NumberFormat("#,##0", "en_US");

    Group _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    bool _isLoading = false;

    Future<void> _getLoanBalancesSummary(BuildContext context) async {
      try {
        // await Provider.of<DashboardFineSummary>(context, listen: false)
        //     .getFinesSummary(_currentGroup.groupId);
        setState(() {
          _isLoading = true;
        });

        await Provider.of<LoanDashboardSummary>(context, listen: false)
            .getDashboardLoanSummary(_currentGroup.groupId);

        setState(() {
          _isLoading = false;
        });
      } on CustomException catch (error) {
        StatusHandler().handleStatus(
            context: context,
            error: error,
            callback: () {
              _getLoanBalancesSummary(context);
            });
      } finally {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    if (!Provider.of<LoanDashboardSummary>(context, listen: false)
        .grouploanExists(_currentGroup.groupId)) {
      _getLoanBalancesSummary(context);
    }

    print(
        "Total Loan Balance ${loanDashboardSummary.totalGroupLoanBalanceDouble.abs()}");

    var nextInstallmentRepaymentDate = DateTime.fromMillisecondsSinceEpoch(
        loanDashboardSummary.nextInstalmentDate * 1000);

    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String nextInstallmentRepaymentDateFormatted =
        formatter.format(nextInstallmentRepaymentDate);
    print("formatted $nextInstallmentRepaymentDateFormatted");
    print("nextContributionDate $nextInstallmentRepaymentDate");

    Map<String, double> dataMap = {
      "Your Loan Balances":
          (/* dashboardData.memberTotalLoanBalance.abs() */ loanDashboardSummary
              .totalLoanAmount
              .abs()),
      "Group Loan Balances":
          (loanDashboardSummary.totalGroupLoanBalanceDouble.abs())
    };
    final gradientList = <List<Color>>[
      // [Colors.red[200], Colors.red[200]],
      [primaryColor.withOpacity(.3), primaryColor.withOpacity(.3)],

      [Color(0xFF00ABF2), Color(0xFF00ABF2)],
    ];

    return !_isLoading
        ? Container(
            child: /* loanDashboardSummary.totalGroupLoanBalance?? */
                loanDashboardSummary.totalGroupLoanBalanceDouble > 0
                    ? Container(
                        color: Theme.of(context).backgroundColor,
                        child: Column(children: [
                          Row(
                            children: [
                              chart.PieChart(
                                dataMap: dataMap,
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 3.2,
                                initialAngleInDegree: 0,
                                ringStrokeWidth: 32,
                                // colorList: [Colors.red[300], primaryColor],
                                gradientList: gradientList,
                                legendOptions: chart.LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: chart.LegendPosition.right,
                                  showLegends: false,
                                  legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      // ignore: deprecated_member_use
                                      color: Theme.of(context)
                                          .textSelectionTheme
                                          .selectionHandleColor),
                                ),
                                chartValuesOptions: chart.ChartValuesOptions(
                                    showChartValueBackground: false,
                                    showChartValues: true,
                                    showChartValuesInPercentage: true,
                                    showChartValuesOutside: false,
                                    decimalPlaces: 0,
                                    chartValueStyle: TextStyle(
                                        fontFamily: 'SegoeUI',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        // ignore: deprecated_member_use
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionTheme
                                            .selectionColor)),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  customTitle(
                                    text: "Your Total Loan",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                  ),
                                  // Text(
                                  //   "My Loan Balances",
                                  //   style: TextStyle(
                                  //     color: Colors.blueGrey[400],
                                  //     fontFamily: 'SegoeUI',
                                  //     fontSize: 14.0,
                                  //     fontWeight: FontWeight.w800,
                                  //   ),
                                  // ),
                                  /* dashboardData.memberTotalLoanBalance */
                                  loanDashboardSummary.totalLoanAmount > 0
                                      ? Row(
                                          children: [
                                            circleButton(
                                              backgroundColor: /* : dashboardData
                                        .memberTotalLoanBalance >
                                    0
                                ? */
                                                  primaryColor.withOpacity(.3)
                                              /*  : Colors
                                    .white */ /* rimaryColor.withOpacity(.3) */,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            customTitle1(
                                              text: /* _currentGroup.disableArrears
                                      ? _currentGroup.groupCurrency +
                                          " " +
                                          currencyFormat.format(dashboardData
                                              .memberTotalLoanBalance)
                                      : _currentGroup.groupCurrency +
                                          " " +
                                          currencyFormat.format(dashboardData
                                              .memberTotalLoanBalance) */
                                                  _currentGroup.groupCurrency +
                                                      " " +
                                                      currencyFormat.format(
                                                          loanDashboardSummary
                                                              .totalLoanAmount),
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme
                                                  .selectionHandleColor,
                                              textAlign: TextAlign.start,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        )
                                      : customTitle1(
                                          text: _currentGroup.disableArrears
                                              ? _currentGroup.groupCurrency +
                                                  " " +
                                                  currencyFormat.format(
                                                      /* dashboardData.memberTotalLoanBalance */
                                                      loanDashboardSummary
                                                          .totalLoanAmount)
                                              : _currentGroup.groupCurrency +
                                                  " " +
                                                  currencyFormat.format(
                                                      /* dashboardData.memberTotalLoanBalance */
                                                      loanDashboardSummary
                                                          .totalLoanAmount),
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionTheme
                                              .selectionHandleColor,
                                          textAlign: TextAlign.start,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  customTitle(
                                    text: "Group Loan Balances",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                  ),

                                  /* dashboardData.groupLoanedAmount */
                                  loanDashboardSummary
                                              .totalGroupLoanBalanceDouble >
                                          0
                                      ? Row(
                                          children: [
                                            circleButton(
                                              backgroundColor: /*  dashboardData
                                        .groupPendingLoanBalance >
                                    0
                                ?  */
                                                  primaryColor
                                              /*  : Colors
                                    .white  */ /* rimaryColor.withOpacity(.3) */,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            customTitle1(
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme
                                                  .selectionHandleColor,
                                              text: _currentGroup
                                                      .groupCurrency +
                                                  " " +
                                                  currencyFormat.format(
                                                      /* dashboardData.groupLoanedAmount */
                                                      loanDashboardSummary
                                                          .totalGroupLoanBalanceDouble),
                                              textAlign: TextAlign.start,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        )
                                      : customTitle1(
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionTheme
                                              .selectionHandleColor,
                                          text: _currentGroup.groupCurrency +
                                              " " +
                                              currencyFormat.format(
                                                  /* dashboardData.groupLoanedAmount */
                                                  loanDashboardSummary
                                                      .totalGroupLoanBalance),
                                          textAlign: TextAlign.start,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                ],
                              ),
                            ],
                          ),
                          DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 0.5,
                            dashLength: 2.0,
                            dashColor: Colors.black45,
                            dashRadius: 0.0,
                            dashGapLength: 2.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customTitle(
                                          text:
                                              /*(*/ /* dashboardData.memberLoanArrears */ /* loanDashboardSummary
                                              .loanBalance) <
                                          0
                                      ?*/
                                              "Your Loan Balance",
                                          /*: "Your Loan Overpayment",*/
                                          fontSize: 12,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionTheme
                                              .selectionHandleColor,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        customTitle1(
                                          text: /*  _currentGroup.disableArrears
                                        ?
                                        _currentGroup.groupCurrency +
                                            " " +
                                            currencyFormat.format(dashboardData
                                                .memberContributionAmount)
                                     : */
                                              // _currentGroup.groupCurrency +
                                              //     " " +
                                              //     currencyFormat.format(dashboardData
                                              //         .memberContributionArrears
                                              //         .abs()),
                                              _currentGroup.groupCurrency +
                                                  " " +
                                                  currencyFormat.format(
                                                      loanDashboardSummary
                                                          .loanBalance),
                                          color: (loanDashboardSummary
                                                      .loanBalance) >
                                                  0
                                              ? Colors.red[400]
                                              : (/* dashboardData.memberContributionArrears */ loanDashboardSummary
                                                          .loanBalance) <
                                                      0
                                                  ? Colors.green
                                                  : Theme.of(context)
                                                      // ignore: deprecated_member_use
                                                      .textSelectionTheme
                                                      .selectionHandleColor,
                                          textAlign: TextAlign.start,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTitle(
                                        text: "Next instalment",
                                        fontSize: 12,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionTheme
                                            .selectionHandleColor,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          customTitle1(
                                            text: _currentGroup.groupCurrency +
                                                " " +
                                                currencyFormat.format(
                                                    loanDashboardSummary
                                                            .nextInstalmentAmount
                                                            .abs() ??
                                                        loanDashboardSummary
                                                            .nextInstalmentAmount
                                                            .abs()),
                                            // "${dashboardData.nextcontributionDate} (${(dashboardData.contributionDateDaysleft == "0 days" ? "today" : dashboardData.contributionDateDaysleft != null ? '${dashboardData.contributionDateDaysleft} left' : "--")})",
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionTheme
                                                .selectionHandleColor,
                                            textAlign: TextAlign.start,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTitle(
                                        text: "Next Repayment Date",
                                        fontSize: 12,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionTheme
                                            .selectionHandleColor,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          customTitle1(
                                            text:
                                                "${/*defaultDateFormat.format*/ (nextInstallmentRepaymentDateFormatted)} (${loanDashboardSummary.nexttoNextInstalmentDay == "0 days" ? "today" : loanDashboardSummary.nexttoNextInstalmentDay != null ? "${loanDashboardSummary.nexttoNextInstalmentDay} left" : "--"})",

                                            // "${dashboardData.nextcontributionDate} (${(dashboardData.contributionDateDaysleft == "0 days" ? "today" : dashboardData.contributionDateDaysleft != null ? '${dashboardData.contributionDateDaysleft} left' : "--")})",
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionTheme
                                                .selectionHandleColor,
                                            textAlign: TextAlign.start,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ]),
                          )
                        ]))
                    : Container(
                        child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.0),
                            decoration: flatGradient(context),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  customIcons['no-data'],
                                  semanticsLabel: 'icon',
                                  height: 120.0,
                                ),
                                customTitleWithWrap(
                                    text: "Nothing to display!",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                    textAlign: TextAlign.center,
                                    color: Colors.blueGrey[400]),
                                customTitleWithWrap(
                                    text: "Sorry, There are no Loans available",
                                    //fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    textAlign: TextAlign.center,
                                    color: Colors.blueGrey[400])
                              ],
                            )),
                      ),
          )
        : Container(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: flatGradient(context),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      customIcons['no-data'],
                      semanticsLabel: 'icon',
                      height: 120.0,
                    ),
                    customTitleWithWrap(
                        text: "Fetching Data!",
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        textAlign: TextAlign.center,
                        color: Colors.blueGrey[400]),
                    customTitleWithWrap(
                        text: "Fetching Loan Summary, Please wait...",
                        //fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        textAlign: TextAlign.center,
                        color: Colors.blueGrey[400])
                  ],
                )),
          );
  }
}

class Expenses extends StatefulWidget {
  const Expenses({Key key}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    Dashboard dashboardData = Provider.of<Dashboard>(context);

    // ExpenseSummaryList _expenseSummaryList;
    // double _totalExpenses = 0;
    // List<SummaryRow> _expenseRows = [];
    // var otherExpenses;

    //NewExpensesSummariesList _expenseSummaryList;

    final currencyFormat = new NumberFormat("#,##0", "en_US");
    bool _isInit = true;
    Group _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    // _expenseSummaryList =
    //     Provider.of<NewExpensesSummariesList>(context, listen: false);
    NewExpensesSummaries _expenseSummary =
        Provider.of<NewExpensesSummaries>(context);
    bool _isLoading = true;
    /* Future<void> _getExpensesSummaries(BuildContext context) async {
      try {
        // await Provider.of<DashboardFineSummary>(context, listen: false)
        //     .getFinesSummary(_currentGroup.groupId);
        setState(() {
          _isLoading = true;
        });

        await Provider.of<NewExpensesSummaries>(context, listen: false)
            .fetchExpenses(_currentGroup.groupId);

        setState(() {
          _isLoading = false;
        });
      } on CustomException catch (error) {
        StatusHandler().handleStatus(
            context: context,
            error: error,
            callback: () {
              _getExpensesSummaries(context);
            });
      } finally {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    if (!Provider.of<NewExpensesSummaries>(context)
        .expensesSummariesTotalExists(_currentGroup.groupId)) {
      _getExpensesSummaries(context);
    }
 */
    final sumOfThreeItems = (_expenseSummary.newExpensesSummariesList.length > 2
            ? _expenseSummary.newExpensesSummariesList[2].expenseAmount
            : 0) +
        (_expenseSummary.newExpensesSummariesList.length > 1
            ? _expenseSummary.newExpensesSummariesList[1].expenseAmount
            : 0) +
        (_expenseSummary.newExpensesSummariesList.length > 0
            ? _expenseSummary.newExpensesSummariesList[0].expenseAmount
            : 0);

    final newOtherExpenses =
        _expenseSummary.totalExpensesSummaries - sumOfThreeItems;

    final otherExpenses = _expenseSummary.totalExpensesSummaries -
        (_expenseSummary.newExpensesSummariesList.length > 2
            ? _expenseSummary.newExpensesSummariesList[2].expenseAmount
            : 0) +
        (_expenseSummary.newExpensesSummariesList.length > 1
            ? _expenseSummary.newExpensesSummariesList[1].expenseAmount
            : 0) +
        (_expenseSummary.newExpensesSummariesList.length > 0
            ? _expenseSummary.newExpensesSummariesList[0].expenseAmount
            : 0);

    // (_expenseSummary.newExpensesSummariesList[2].expenseAmount)
    //     (_expenseSummary.newExpensesSummariesList.length> 1 ? _expenseSummary.newExpensesSummariesList[1].expenseAmount : 0) +
    //     (_expenseSummary.newExpensesSummariesList.length> 0 ? _expenseSummary.newExpensesSummariesList[0].expenseAmount : 0)

    // final otherExpenses = /*dashboardData.groupExpensesAmount*/ _totalExpenses -
    //     (
    //         // _expenseRows[3].paid ?? 0 +
    //         (_expenseRows?.length > 2 ? _expenseRows[2].paid : 0) +
    //             (_expenseRows?.length > 1 ? _expenseRows[1].paid : 0) +
    //             (_expenseRows?.length > 0 ? _expenseRows[0].paid : 0)
    //     /*_expenseRows[1].paid ?? 0  +
    //     _expenseRows[0].paid ?? 0*/
    //     );

    print("Total Expenses will be ${_expenseSummary.totalExpensesSummaries}");
    print("Some of the three items will be $sumOfThreeItems");
    print("object Other Expenses will be $otherExpenses");
    print("new other Expenses amount will be $newOtherExpenses");
    print(
        "Item1 will be ${(_expenseSummary.newExpensesSummariesList.length > 0 ? _expenseSummary.newExpensesSummariesList[0].expenseAmount : 0)}");
    print(
        "Item2 will be ${(_expenseSummary.newExpensesSummariesList.length > 1 ? _expenseSummary.newExpensesSummariesList[1].expenseAmount : 0)}");
    print(
        "Item3 will be ${(_expenseSummary.newExpensesSummariesList.length > 2 ? _expenseSummary.newExpensesSummariesList[2].expenseAmount : 0)}");

    /*Map<String, double> dataMaptest = {
      "Item1": (_expenseRows?.length > 0 ? _expenseRows[0].paid : 0),
      "Item2": (_expenseRows?.length > 1 ? _expenseRows[1].paid : 0),
      "Item3": (_expenseRows?.length > 2 ? _expenseRows[2].paid : 0),
      // "Item3": _expenseRows[2].paid  ?? 0,
      // "Item3": _expenseRows[2].paid  ?? 0,
      // "Item4": _expenseRows[3].paid??0,
      "Others": otherExpenses ?? 0,
    };*/

    Map<String, double> dataMaptest = {
      "Item1": (_expenseSummary.newExpensesSummariesList.length > 0
          ? _expenseSummary.newExpensesSummariesList[0].expenseAmount
          : 0),
      "Item2": (_expenseSummary.newExpensesSummariesList.length > 1
          ? _expenseSummary.newExpensesSummariesList[1].expenseAmount
          : 0),
      "Item3": (_expenseSummary.newExpensesSummariesList.length > 2
          ? _expenseSummary.newExpensesSummariesList[2].expenseAmount
          : 0),
      "Others": double.tryParse(newOtherExpenses.toString()) ?? 0,
    };
    final gradientList = <List<Color>>[
      [primaryColor.withOpacity(.3), primaryColor.withOpacity(.3)],
      [primaryColor.withOpacity(.5), primaryColor.withOpacity(.5)],
      [primaryColor.withOpacity(.7), primaryColor.withOpacity(.7)],
      // [primaryColor.withOpacity(.8), primaryColor.withOpacity(.8)],
      // [primaryColor.withOpacity(1.0), primaryColor.withOpacity(1.0)],
      [Color(0xFF00ABF2), Color(0xFF00ABF2)],
    ];

    /* return _expenseRows != null && _expenseRows.length > 0*/

    return /* !_isLoading
        ? Container(
            child: */
        _expenseSummary.newExpensesSummariesList != null &&
                _expenseSummary.newExpensesSummariesList.length > 0
            ? Container(
                color: Theme.of(context).backgroundColor,
                child: Column(children: [
                  Row(
                    children: [
                      chart.PieChart(
                        dataMap: dataMaptest,
                        animationDuration: Duration(milliseconds: 800),
                        chartLegendSpacing: 32,
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                        initialAngleInDegree: 0,
                        ringStrokeWidth: 32,
                        colorList: [Colors.red[300], primaryColor],
                        gradientList: gradientList,
                        legendOptions: chart.LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: chart.LegendPosition.right,
                          showLegends: false,
                          legendTextStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              // ignore: deprecated_member_use
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor),
                        ),
                        chartValuesOptions: chart.ChartValuesOptions(
                            showChartValueBackground: false,
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                            chartValueStyle: TextStyle(
                                fontFamily: 'SegoeUI',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                // ignore: deprecated_member_use
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionTheme
                                    .selectionColor)),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          customTitle(
                            text: /* (_expenseRows?.length > 0
                            ? _expenseRows[0].name
                            : ' ')*/
                                (_expenseSummary
                                            .newExpensesSummariesList.length >
                                        0
                                    ? _expenseSummary
                                        .newExpensesSummariesList[0].expenseName
                                    : " "),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionTheme
                                .selectionHandleColor,
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              circleButton(
                                backgroundColor: /* : dashboardData
                                        .memberTotalLoanBalance >
                                    0
                                ? */
                                    primaryColor.withOpacity(.3)
                                /*  : Colors
                                    .white */ /* rimaryColor.withOpacity(.3) */,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              customTitle1(
                                text: /*_currentGroup.groupCurrency +
                                " " +
                                currencyFormat.format((_expenseRows?.length > 0
                                    ? _expenseRows[0].paid
                                    : 0)) +
                                " " +
                                ("(${(((_expenseRows?.length > 0 ? _expenseRows[0].paid : 0) / _totalExpenses) * 100).toStringAsFixed(1) + "%"}) "),*/
                                    _currentGroup.groupCurrency +
                                        " " +
                                        currencyFormat.format(_expenseSummary
                                                    .newExpensesSummariesList
                                                    .length >
                                                0
                                            ? _expenseSummary
                                                .newExpensesSummariesList[0]
                                                .expenseAmount
                                            : 0) +
                                        " " +
                                        ("(${(((_expenseSummary.newExpensesSummariesList.length > 0 ? _expenseSummary.newExpensesSummariesList[0].expenseAmount : 0) / _expenseSummary.totalExpensesSummaries) * 100).toStringAsFixed(1) + "%"}) "),
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionTheme
                                    .selectionHandleColor,
                                textAlign: TextAlign.start,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          /*(_expenseRows?.length > 1 ? _expenseRows[1].paid : 0) > 0*/
                          ((_expenseSummary.newExpensesSummariesList.length > 1
                                      ? _expenseSummary
                                          .newExpensesSummariesList[1]
                                          .expenseAmount
                                      : 0) >
                                  0)
                              ? customTitle(
                                  text: /*(_expenseRows?.length > 1
                                  ? _expenseRows[1].name
                                  : 0)*/
                                      (_expenseSummary.newExpensesSummariesList
                                                  .length >
                                              1
                                          ? _expenseSummary
                                              .newExpensesSummariesList[1]
                                              .expenseName
                                          : " "),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                )
                              : SizedBox(height: 0),
                          SizedBox(height: 5),
                          /*(_expenseRows?.length > 1 ? _expenseRows[1].paid : 0) > 0*/
                          ((_expenseSummary.newExpensesSummariesList.length > 1
                                      ? _expenseSummary
                                          .newExpensesSummariesList[1]
                                          .expenseAmount
                                      : 0) >
                                  0)
                              ? Row(
                                  children: [
                                    circleButton(
                                      backgroundColor: /*  dashboardData
                                        .groupPendingLoanBalance >
                                    0
                                ?  */
                                          // primaryColor
                                          /* Colors.blue[100] */ primaryColor
                                              .withOpacity(.5)
                                      /*  : Colors
                                    .white  */ /* rimaryColor.withOpacity(.3) */,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    customTitle1(
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionTheme
                                          .selectionHandleColor,
                                      text: _currentGroup.groupCurrency +
                                          " " +
                                          /* currencyFormat.format(
                                          (_expenseRows?.length > 1
                                              ? _expenseRows[1].paid
                                              : 0)) +
                                      " " +
                                      ("(${(((_expenseRows?.length > 1 ? _expenseRows[1].paid : 0) / _totalExpenses) * 100).toStringAsFixed(1) + "%"}) ")*/
                                          currencyFormat.format((_expenseSummary
                                                      .newExpensesSummariesList
                                                      .length >
                                                  1
                                              ? _expenseSummary
                                                  .newExpensesSummariesList[1]
                                                  .expenseAmount
                                              : 0)) +
                                          " " +
                                          ("(${(((_expenseSummary.newExpensesSummariesList.length > 1 ? _expenseSummary.newExpensesSummariesList[1].expenseAmount : 0) / _expenseSummary.totalExpensesSummaries) * 100).toStringAsFixed(1) + "%"}) "),
                                      textAlign: TextAlign.start,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                )
                              : SizedBox(height: 0),
                          SizedBox(height: 5),
                          /*(_expenseRows?.length > 2 ? _expenseRows[2].paid : 0) > 0*/
                          ((_expenseSummary.newExpensesSummariesList.length > 2
                                      ? _expenseSummary
                                          .newExpensesSummariesList[2]
                                          .expenseAmount
                                      : 0) >
                                  0)
                              ? customTitle(
                                  text: /*_expenseRows[2].name*/ /*(_expenseRows
                                          ?.length >
                                      2
                                  ? _expenseRows[2].name
                                  : "")*/
                                      _expenseSummary.newExpensesSummariesList
                                                  .length >
                                              2
                                          ? _expenseSummary
                                              .newExpensesSummariesList[2]
                                              .expenseName
                                          : " ",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                )
                              : SizedBox(height: 0),
                          SizedBox(height: 5),
                          /*(_expenseRows?.length > 2 ? _expenseRows[2].paid : 0) > 0*/
                          ((_expenseSummary.newExpensesSummariesList.length > 2
                                      ? _expenseSummary
                                          .newExpensesSummariesList[2]
                                          .expenseAmount
                                      : 0) >
                                  0)
                              ? Row(
                                  children: [
                                    circleButton(
                                        backgroundColor: primaryColor.withOpacity(
                                            .7) /*  dashboardData
                                        .groupPendingLoanBalance >
                                    0
                                ?  */
                                        // primaryColor
                                        /*  : Colors
                                    .white  */ /* rimaryColor.withOpacity(.3) */
                                        ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    customTitle1(
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionTheme
                                          .selectionHandleColor,
                                      text: _currentGroup.groupCurrency +
                                          " " +
                                          /*currencyFormat.format(
                                          */ /*_expenseRows[2].paid*/ /* (_expenseRows
                                                      ?.length >
                                                  2
                                              ? _expenseRows[2].paid
                                              : 0)) +
                                      " " +
                                      ("(${((*/ /*_expenseRows[2].paid*/ /* (_expenseRows?.length > 2 ? _expenseRows[2].paid : 0) / _totalExpenses) * 100).toStringAsFixed(1) + "%"}) "),*/
                                          currencyFormat.format(_expenseSummary
                                                      .newExpensesSummariesList
                                                      .length >
                                                  2
                                              ? _expenseSummary
                                                  .newExpensesSummariesList[2]
                                                  .expenseAmount
                                              : 0) +
                                          " " +
                                          ("(${(((_expenseSummary.newExpensesSummariesList.length > 2 ? _expenseSummary.newExpensesSummariesList[2].expenseAmount : 0) / _expenseSummary.totalExpensesSummaries) * 100).toStringAsFixed(1) + "%"}) "),
                                      textAlign: TextAlign.start,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                )
                              : SizedBox(height: 0),
                          // customTitle(
                          //   text: _expenseRows[3].name,
                          //   fontSize: 13,
                          //   fontWeight: FontWeight.w400,
                          //   color: Theme.of(context)
                          //       // ignore: deprecated_member_use
                          //       .textSelectionHandleColor,
                          // ),
                          // SizedBox(height: 5),
                          // Row(
                          //   children: [
                          //     circleButton(
                          //         backgroundColor: primaryColor.withOpacity(
                          //             .8) /*  dashboardData
                          //                   .groupPendingLoanBalance >
                          //               0
                          //           ?  */
                          //         // primaryColor
                          //         /*  : Colors
                          //               .white  */ /* rimaryColor.withOpacity(.3) */
                          //         ),
                          //     SizedBox(
                          //       width: 5,
                          //     ),
                          //     customTitle1(
                          //       color: Theme.of(context)
                          //           // ignore: deprecated_member_use
                          //           .textSelectionHandleColor,
                          //       text: _currentGroup.groupCurrency +
                          //           " " +
                          //           currencyFormat.format(
                          //               _expenseRows[3].paid),
                          //       textAlign: TextAlign.start,
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.w600,
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: 5),
                          /*otherExpenses < 0
                          ?*/

                          newOtherExpenses > 0
                              ? customTitle(
                                  text: "Others",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                )
                              : SizedBox(height: 0),
                          /* : Container(),*/
                          SizedBox(height: 5),
                          /*otherExpenses < 0
                          ?*/
                          newOtherExpenses > 0
                              ? Row(
                                  children: [
                                    circleButton(
                                      backgroundColor: /*  dashboardData
                                        .groupPendingLoanBalance >
                                    0
                                ?  */
                                          primaryColor
                                      /*  : Colors
                                    .white  */ /* rimaryColor.withOpacity(.3) */,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    customTitle1(
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionTheme
                                          .selectionHandleColor,
                                      text: _currentGroup.groupCurrency +
                                          " " +
                                          currencyFormat
                                              .format(newOtherExpenses) +
                                          " " +
                                          ("(${((newOtherExpenses / _expenseSummary.totalExpensesSummaries) * 100).toStringAsFixed(1) + "%"}) "),
                                      textAlign: TextAlign.start,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                )
                              : SizedBox(height: 0),
                        ],
                      ),
                    ],
                  ),
                ]))
            : Container(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: flatGradient(context),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          customIcons['no-data'],
                          semanticsLabel: 'icon',
                          height: 120.0,
                        ),
                        customTitleWithWrap(
                            text: "Nothing to display!",
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                            textAlign: TextAlign.center,
                            color: Colors.blueGrey[400]),
                        customTitleWithWrap(
                            text: "Sorry, there are no expenses to display",
                            //fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            textAlign: TextAlign.center,
                            color: Colors.blueGrey[400])
                      ],
                    )),
              );
    /*   );
        : Container(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: flatGradient(context),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      customIcons['no-data'],
                      semanticsLabel: 'icon',
                      height: 120.0,
                    ),
                    customTitleWithWrap(
                        text: "Fetching Data!",
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        textAlign: TextAlign.center,
                        color: Colors.blueGrey[400]),
                    customTitleWithWrap(
                        text: "Fetching Expenses Summary, Please wait...",
                        //fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        textAlign: TextAlign.center,
                        color: Colors.blueGrey[400])
                  ],
                )),
          ); */
  }
}
