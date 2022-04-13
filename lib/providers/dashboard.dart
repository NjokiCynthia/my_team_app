import 'dart:convert';
import 'dart:developer';

// import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:chamasoft/helpers/report_helper.dart';
import 'package:chamasoft/screens/chamasoft/models/expense-category.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'groups.dart';

class BankAccountDashboardSummary {
  final String accountName;
  final double balance;

  BankAccountDashboardSummary(
      {@required this.accountName, @required this.balance});
}

class RecentTransactionSummary {
  final String paymentTitle;
  final double paymentAmount;
  final String paymentDate;
  final String paymentMethod;
  final String description;

  RecentTransactionSummary(
      {@required this.paymentTitle,
      @required this.paymentAmount,
      @required this.paymentDate,
      this.paymentMethod,
      this.description});
}

class ContributionsSummary {
  final String contributionName;
  final double amountPaid;
  final double balance;
  final String dueDate;

  ContributionsSummary({
    @required this.contributionName,
    @required this.amountPaid,
    this.balance,
    this.dueDate,
  });
}

class Dashboard with ChangeNotifier {
  String _userId;
  Map<String, Map<String, dynamic>> _memberDashboardData;
  Map<String, Map<String, dynamic>> _groupDashboardData;
  List<BankAccountDashboardSummary> _bankAccountDashboardSummary = [];
  List<RecentTransactionSummary> _recentTransactionSummary = [];
  List<BarChartGroupData> _depositsVWithdrawals = [];
  List<String> _months = [];
  List<int> _chartYAxisParameters = [1, 1];
  List<ContributionsSummary> _memberContributionSummary = [];
  ExpenseSummaryList _expenseSummaryList;
  List<Expense> _expenses = [];

  // ignore: unused_field
  String _currentGroupId;

  Dashboard(
      String _userId,
      String _currentGroupId,
      Map<String, Map<String, dynamic>> _memberDashboardData,
      Map<String, Map<String, dynamic>> _groupDashboardData) {
    this._memberDashboardData = _memberDashboardData;
    this._groupDashboardData = _groupDashboardData;
    this._userId = _userId;
    this._currentGroupId = _currentGroupId;
    if (_memberDashboardData.containsKey(_currentGroupId)) {
      if (_memberDashboardData[_currentGroupId].isNotEmpty) {
        _updateMemberDashboardData(_currentGroupId);
      }
    }

    if (_groupDashboardData.containsKey(_currentGroupId)) {
      if (_groupDashboardData[_currentGroupId].isNotEmpty) {
        _updateGroupDashboardData(_currentGroupId);
      }
    }
  }

  //***************member****************/
  double _notificationCount = 0.0;
  double _memberContributionAmount = 0.0;
  double _memberFinesAmount = 0.0;
  double _memberContributionArrears = 0.0;
  double _memberFineArrears = 0.0;
  double _memberLoanArrears = 0.0;
  double _memberTotalLoanBalance = 0.0;
  int _unreconciledDepositsCount = 0;
  int _unreconciledWithdrawalsCount = 0;
  bool _isPartnerBankAccount = false;
  String _contributionDateDaysleft = "";
  String _nextcontributionDate = "";

  //***************Group****************/

  double _cashBalances = 0.0;
  double _bankBalances = 0.0;
  double _groupContributionAmount = 0.0;
  double _groupExpenses = 0.0;
  double _groupPendingLoan = 0.0;
  double _groupFinePayments = 0.0;
  double _groupLoanedAmount = 0.0;
  double _groupLoanPaid = 0.0;

  Map<String, Map<String, dynamic>> get memberDashboardData {
    return _memberDashboardData;
  }

  Map<String, Map<String, dynamic>> get groupDashboardData {
    return _groupDashboardData;
  }

  double get memberContributionAmount {
    return _memberContributionAmount;
  }

  String get contributionDateDaysleft {
    return _contributionDateDaysleft;
  }

  String get nextcontributionDate {
    return _nextcontributionDate;
  }

  double get notificationCount {
    return _notificationCount;
  }

  double get memberFineAmount {
    return _memberFinesAmount;
  }

  double get memberTotalLoanBalance {
    return _memberTotalLoanBalance;
  }

  double get memberLoanArrears {
    return _memberLoanArrears;
  }

  double get memberFineArrears {
    return _memberFineArrears;
  }

  double get memberContributionArrears {
    return _memberContributionArrears;
  }

  int get unreconciledDepositCount {
    return _unreconciledDepositsCount;
  }

  set unreconciledDepositCount(int value) {
    if (value > 0)
      ++_unreconciledDepositsCount;
    else
      --_unreconciledDepositsCount;
  }

  int get unreconciledWithdrawalCount {
    return _unreconciledWithdrawalsCount;
  }

  set unreconciledWithdrawalCount(int value) {
    if (value > 0)
      ++_unreconciledWithdrawalsCount;
    else
      --_unreconciledWithdrawalsCount;
  }

  bool get isPartnerBankAccount {
    return _isPartnerBankAccount;
  }

  //********Group********/

  double get groupContributionAmount {
    return _groupContributionAmount;
  }

  double get groupExpensesAmount {
    return _groupExpenses;
  }

  double get groupFinePaymentAmount {
    return _groupFinePayments;
  }

  double get groupPendingLoanBalance {
    return _groupPendingLoan;
  }

  double get groupLoanedAmount {
    return _groupLoanedAmount;
  }

  double get groupLoanPaid {
    return _groupLoanPaid;
  }

  double get totalBankBalances {
    return _cashBalances + _bankBalances;
  }

  double get cashBalances {
    return _cashBalances;
  }

  double get bankBalances {
    return _bankBalances;
  }

  List<RecentTransactionSummary> get recentMemberTransactions {
    return [..._recentTransactionSummary];
  }

  List<BarChartGroupData> get depositsVWithdrawals {
    return [..._depositsVWithdrawals];
  }

  List<String> get getTransactionMonths {
    return [..._months];
  }

  List<int> get chartYAxisParameters {
    return [..._chartYAxisParameters];
  }

  List<BankAccountDashboardSummary> get bankAccountDashboardSummary {
    return [..._bankAccountDashboardSummary];
  }

  List<ContributionsSummary> get memberContributionSummary {
    return [..._memberContributionSummary];
  }

  List<Expense> get expenses {
    return [..._expenses];
  }

  ExpenseSummaryList get expenseSummaryList {
    return _expenseSummaryList;
  }

  void addExpenseSummary(dynamic data) {
    _expenseSummaryList = getExpenseSummary(data);
    notifyListeners();
  }

  bool memberGroupDataExists(String groupId) {
    if (_memberDashboardData.containsKey(groupId)) {
      if (_memberDashboardData[groupId].length <= 0) {
        return false;
      }
      {
        return true;
      }
    } else {
      return false;
    }
  }

  void resetMemberDashboardData(String groupId) {
    if (_memberDashboardData.containsKey(groupId)) {
      print(_memberDashboardData);
      _memberDashboardData.removeWhere((key, value) => key == groupId);
    }
  }

  bool groupDataExists(String groupId) {
    if (_groupDashboardData.containsKey(groupId)) {
      if (_groupDashboardData[groupId].length <= 0) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  void resetGroupDashboardData(String groupId) {
    if (_groupDashboardData.containsKey(groupId)) {
      print(_groupDashboardData);
      _groupDashboardData.removeWhere((key, value) => key == groupId);
    }
  }

  void _updateMemberDashboardData(String groupId) async {
    if (_memberDashboardData[groupId].containsKey("member_details")) {
      var groupMemberObject = _memberDashboardData[groupId];
      var memberDetails =
          groupMemberObject["member_details"] as Map<String, dynamic>;
      _notificationCount =
          double.tryParse(groupMemberObject["notification_count"].toString()) ??
              0.0;
      _unreconciledDepositsCount = int.tryParse(
              groupMemberObject["unreconciled_deposits_count"].toString()) ??
          0.0;
      _unreconciledWithdrawalsCount = int.tryParse(
              groupMemberObject["unreconciled_withdrawals_count"].toString()) ??
          0.0;
      _isPartnerBankAccount =
          (int.tryParse(groupMemberObject["partner"].toString())) == 1
              ? true
              : false;

      print("count $_unreconciledWithdrawalsCount");
      _memberContributionAmount =
          double.tryParse(memberDetails["total_contributions"].toString()) ??
              0.0;
      _contributionDateDaysleft =
          memberDetails["contribution_date_days_left"] ?? "--";
      _nextcontributionDate = memberDetails["next_contribution_date"] ?? "--";
      _memberFinesAmount = double.tryParse(memberDetails["total_fines"].toString()) ??
              0.0;
      _memberContributionArrears =
          double.tryParse(memberDetails["contribution_arrears"].toString()) ??
              0.0;
      _memberFineArrears =
          double.tryParse(memberDetails["fine_arrears"].toString()) ?? 0.0;
      _memberLoanArrears =
          double.tryParse(memberDetails["loan_arrears"].toString()) ?? 0.0;
      _memberTotalLoanBalance =
          double.tryParse(memberDetails["total_loan_balances"].toString()) ??
              0.0;
      String contributionDate =
          memberDetails["next_contribution_date"].toString();
      var recentTransactions = memberDetails["recent_transactions"];
      _recentTransactionSummary = [];
      if (recentTransactions.length > 0) {
        recentTransactions.map((summary) {
          var description = summary["description"].toString();
          var amount = double.tryParse(summary["amount"].toString()) ?? 0.0;
          var date = summary["date"].toString();
          var title = summary["type"].toString();
          var paymentMethod = summary["payment_method"].toString();
          if (amount > 1.0) {
            _recentTransactionSummary.add(RecentTransactionSummary(
              paymentAmount: amount,
              description: description,
              paymentDate: date,
              paymentTitle: title,
              paymentMethod: paymentMethod,
            ));
          }
        }).toList();
      }
      var memberContributionSummary =
          memberDetails["member_contribution_summary"];
      _memberContributionSummary = [];
      if (memberContributionSummary.length > 0) {
        memberContributionSummary.map((summary) {
          var amountPaid = double.tryParse(summary["paid"].toString()) ?? 0.0;
          var balance = double.tryParse(summary["balance"].toString()) ?? 0.0;
          var contributionName = summary["name"].toString();
          _memberContributionSummary.add(ContributionsSummary(
            contributionName: contributionName,
            amountPaid: amountPaid,
            balance: balance,
            dueDate: contributionDate,
          ));
        }).toList();
      }
    }
    notifyListeners();
  }

  void _updateGroupDashboardData(String groupId,
      [bool addChartData = false]) async {
    if (!addChartData) {
      if (_groupDashboardData[groupId].containsKey("group_details")) {
        var groupDetails = _groupDashboardData[groupId]["group_details"]
            as Map<String, dynamic>;
        _cashBalances =
            double.tryParse(groupDetails["cash_balances"].toString()) ?? 0.0;
        _bankBalances =
            double.tryParse(groupDetails["bank_balances"].toString()) ?? 0.0;
        _groupContributionAmount =
            double.tryParse(groupDetails["total_contributions"].toString()) ??
                0.0;
        _groupExpenses = double.tryParse(
                groupDetails["total_expense_payments"].toString()) ??
            0.0;
        _groupPendingLoan =
            double.tryParse(groupDetails["total_loan_balances"].toString()) ??
                0.0;
        _groupFinePayments =
            double.tryParse(groupDetails["total_fines"].toString()) ?? 0.0;
        _groupLoanedAmount =
            double.tryParse(groupDetails["total_loaned_amount"].toString()) ??
                0.0;
        _groupLoanPaid =
            double.tryParse(groupDetails["total_loan_repaid"].toString()) ??
                0.0;

        var accountBalances = groupDetails["account_balances"];
        _bankAccountDashboardSummary = [];
        if (accountBalances.length > 0) {
          accountBalances.map((accountBalance) {
            var accountName = accountBalance["description"].toString();
            var balance =
                double.tryParse(accountBalance["balance"].toString()) ?? 0.0;
            //if(balance > 1.0){
            _bankAccountDashboardSummary.add(BankAccountDashboardSummary(
                accountName: accountName, balance: balance));
            //}
          }).toList();
        }
      }
    }

    if (_groupDashboardData[groupId].containsKey("chart_data")) {
      double maxY = 0;
      int divider = 1;
      var transactions = _groupDashboardData[groupId]["chart_data"]
          ["group_transactions"] as Map<String, dynamic>;
      var depositsMap = transactions["deposits"] as Map;
      var withdrawalsMap = transactions["withdrawals"] as Map;
      List<String> months = [];
      List<double> deposits = [];
      List<double> withdrawals = [];
      List<BarChartGroupData> groupedData = [];
      if (depositsMap != null) {
        for (final key in depositsMap.keys) {
          final deposit = double.tryParse(depositsMap[key].toString()) ?? 0;
          final withdrawal =
              double.tryParse(withdrawalsMap[key].toString()) ?? 0;
          final larger = deposit > withdrawal ? deposit : withdrawal;
          maxY = maxY < larger ? larger : maxY;
          months.add(key);
          deposits.add(deposit);
          withdrawals.add(withdrawal);
        }

//        for (final key in withdrawalsMap.keys) {
//          final value = withdrawalsMap[key].toString();
//          withdrawals.add(double.tryParse(value) ?? 0);
//        }

        if (maxY > 1000) {
          divider = 1000;
        }

        for (int i = 0; i < months.length; i++) {
          groupedData.add(makeGroupData(
              i, deposits[i] / divider, withdrawals[i] / divider));
        }
      }
      _chartYAxisParameters[0] =
          maxY.toInt() > 999 ? round(maxY.toInt(), 1000) : maxY;
      _chartYAxisParameters[1] = divider;
      _depositsVWithdrawals = groupedData;
      _months = months;
    }

    notifyListeners();
  }

  /// ***********************Expense Summary*****************************
  Future<void> fetchExpenseSummary() async {
    final url = EndpointUrl.GET_EXPENSES_SUMMARY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _expenses = []; //clear accounts
        final groupExpenses = response['data'] as dynamic;
        addExpenseSummary(groupExpenses);
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> getMemberDashboardData(String groupId) async {
    try {
      final url = EndpointUrl.GET_MEMBER_DASHBOARD_DATA;
      try {
        if (!memberGroupDataExists(groupId)) {
          final postRequest = json.encode({
            "user_id": _userId,
            "group_id": groupId,
          });
          final response = await PostToServer.post(postRequest, url);
          _memberDashboardData[groupId] = response;
          _updateMemberDashboardData(groupId);
        }
      } on CustomException catch (error) {
        throw CustomException(message: error.toString(), status: error.status);
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> getGroupDashboardData(String groupId) async {
    try {
      final url = EndpointUrl.GET_GROUP_DASHBOARD_DATA;
      try {
        if (!groupDataExists(groupId)) {
          final postRequest = json.encode({
            "user_id": _userId,
            "group_id": groupId,
          });
          final response = await PostToServer.post(postRequest, url);
          _groupDashboardData[groupId] = response;
          _updateGroupDashboardData(groupId);
        }
      } on CustomException catch (error) {
        print(error.toString());
        throw CustomException(message: error.toString(), status: error.status);
      } catch (error) {
        print(error.toString());
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      print(error.toString());
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      print(error.toString());
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> getGroupDepositVWithdrawals(String groupId) async {
    print("called");
    try {
      final url = EndpointUrl.GET_GROUP_CHART_DATA;
      try {
        if (groupDataExists(groupId)) {
          final postRequest = json.encode({
            "user_id": _userId,
            "group_id": groupId,
          });
          final response = await PostToServer.post(postRequest, url);
          log(response.toString());
          _groupDashboardData[groupId]["chart_data"] = response;
          _updateGroupDashboardData(groupId, true);
        }
      } on CustomException catch (error) {
        print(error.toString());
        throw CustomException(message: error.toString(), status: error.status);
      } catch (error) {
        print(error.toString());
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      print(error.toString());
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      print(error.toString());
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    const Color depositsBarColor = const Color(0xff00AAF0);
    const Color withdrawalsBarColor = Colors.red;
    const double width = 7;

    // return BarChartGroupData();

    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [depositsBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [withdrawalsBarColor],
        width: width,
      ),
    ]);
  }

  int round(int number, int multiple) {
    int result = multiple;

    if (number % multiple == 0) {
      return number.toInt();
    }

    //If not already multiple of given number

    if (number % multiple != 0) {
      double division = (number / multiple) + 1;

      result = division.toInt() * multiple;
    }

    return result;
  }
}
