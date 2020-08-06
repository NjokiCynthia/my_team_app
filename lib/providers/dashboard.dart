import 'dart:convert';

import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/endpoint-url.dart';
import 'package:chamasoft/utilities/post-to-server.dart';
import 'package:flutter/cupertino.dart';

class BankAccountDashboardSummary{
    final String accountName;
    final double balance;
    
    BankAccountDashboardSummary({
      @required this.accountName,
      @required this.balance
    });
}

class RecentTransactionSummary{
    final String paymentTitle;
    final double paymentAmount;
    final String paymentDate;
    final String paymentMethod;
    final String description;
    RecentTransactionSummary({
      @required this.paymentTitle,
      @required this.paymentAmount,
      @required this.paymentDate,
      this.paymentMethod,
      this.description
    });
}

class ContributionsSummary{
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

class Dashboard with ChangeNotifier{
  String _userId;
  Map<String,Map<String,dynamic>> _memberDashboardData;
  Map<String,Map<String,dynamic>> _groupDashboardData;
  List<BankAccountDashboardSummary> _bankAccountDashboardSummary = [];
  List<RecentTransactionSummary> _recentTransactionSummary = [];
  List<ContributionsSummary> _memberContributionSummary = [];
  String _currentGroupId;

  Dashboard(String _userId,String _currentGroupId,Map<String,Map<String,dynamic>> _memberDashboardData,Map<String,Map<String,dynamic>> _groupDashboardData){
    this._memberDashboardData = _memberDashboardData;
    this._groupDashboardData = _groupDashboardData;
    this._userId = _userId;
    this._currentGroupId = _currentGroupId;
    if(_memberDashboardData.containsKey(_currentGroupId)){
      if(_memberDashboardData[_currentGroupId].isNotEmpty){
        _updateMemberDashboardData(_currentGroupId);
      }
    }
      
    if(_groupDashboardData.containsKey(_currentGroupId)){
      if(_groupDashboardData[_currentGroupId].isNotEmpty){
        _updateGroupDashboardData(_currentGroupId);
      }
    }
  }
  //***************member****************/
  double _memberContributionAmount = 0.0;
  double _memberFinesAmount = 0.0;
  double _memberContributionArrears = 0.0;
  double _memberFineArrears = 0.0;
  double _memberLoanArrears = 0.0;
  double _memberTotalLoanBalance = 0.0;


  //***************Group****************/

  double _cashBalances=0.0;
  double _bankBalances=0.0;
  double _groupContributionAmount = 0.0;
  double _groupExpenses = 0.0;
  double _groupPendingLoan = 0.0;
  double _groupFinePayments = 0.0;
  double _groupLoanedAmount = 0.0;
  double _groupLoanPaid = 0.0;

  Map<String,Map<String,dynamic>> get memberDashboardData{
    return _memberDashboardData;
  }

  Map<String,Map<String,dynamic>> get groupDashboardData{
    return _groupDashboardData;
  }

  double get memberContributionAmount{
    return _memberContributionAmount;
  }

  double get memberFineAmount{
    return _memberFinesAmount;
  }

  double get memberTotalLoanBalance{
    return _memberTotalLoanBalance;
  }

  double get memberLoanArrears{
    return _memberLoanArrears;
  }

  double get memberFineArrears{
    return _memberFineArrears;
  }

  double get memberContributionArrears{
    return _memberContributionArrears;
  }



  //********Group********/

  double get groupContributionAmount{
    return _groupContributionAmount;
  }

  double get groupExpensesAmount{
    return _groupExpenses;
  }

  double get groupFinePaymentAmount{
    return _groupFinePayments;
  }

  double get groupPendingLoanBalance{
    return _groupPendingLoan;
  }

  double get groupLoanedAmount{
    return _groupLoanedAmount;
  }

  double get groupLoanPaid{
    return _groupLoanPaid;
  }

  double get totalBankBalances{
    return _cashBalances+_bankBalances;
  }

  double get cashBalances{
    return _cashBalances;
  }

  double get bankBalances{
    return _bankBalances;
  }

  List<RecentTransactionSummary> get recentMemberTransactions{
    return [..._recentTransactionSummary];
  }

  List<BankAccountDashboardSummary> get bankAccountDashboardSummary{
    return [..._bankAccountDashboardSummary];
  }

  List<ContributionsSummary> get memberContributionSummary{
    return [..._memberContributionSummary];
  }

  bool memberGroupDataExists(String groupId){
    if(_memberDashboardData.containsKey(groupId)){
      if(_memberDashboardData[groupId].length<=0){
        return false;
      }{
        return true;
      }
    }else{
      return false;
    }
  }

  void resetMemberDashboardData(String groupId){
     if(_memberDashboardData.containsKey(groupId)){
       print(_memberDashboardData);
       _memberDashboardData.removeWhere((key, value) => key==groupId);
    }
  }

  bool groupDataExists(String groupId){
    if(_groupDashboardData.containsKey(groupId)){
      if(_groupDashboardData[groupId].length<=0){
        return false;
      }else{
        return true;
      }
    }else{
      return false;
    }
  }

  void resetGroupDashboardData(String groupId){
     if(_groupDashboardData.containsKey(groupId)){
       print(_groupDashboardData);
       _groupDashboardData.removeWhere((key, value) => key==groupId);
    }
  }

  void _updateMemberDashboardData(String groupId)async{
    if(_memberDashboardData[groupId].containsKey("member_details")){
      var memberDetails = _memberDashboardData[groupId]["member_details"] as Map<String,dynamic>;
      _memberContributionAmount = double.tryParse(memberDetails["total_contributions"].toString())??0.0;
      _memberContributionArrears = double.tryParse(memberDetails["contribution_arrears"].toString())??0.0;
      _memberFineArrears = double.tryParse(memberDetails["fine_arrears"].toString())??0.0;
      _memberLoanArrears = double.tryParse(memberDetails["loan_arrears"].toString())??0.0;
      _memberTotalLoanBalance = double.tryParse(memberDetails["total_loan_balances"].toString())??0.0;
      String contributionDate = memberDetails["next_contribution_date"].toString();
      var recentTransactions = memberDetails["recent_transactions"];
      _recentTransactionSummary = [];
      if(recentTransactions.length>0){
        recentTransactions.map((summary){
          var description = summary["description"].toString();
          var amount = double.tryParse(summary["amount"].toString())??0.0;
          var date = summary["date"].toString();
          var title = summary["type"].toString();
          var paymentMethod = summary["payment_method"].toString();
          if(amount > 1.0){
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
      var memberContributionSummary = memberDetails["member_contribution_summary"];
      _memberContributionSummary = [];
      if(memberContributionSummary.length > 0){
        memberContributionSummary.map((summary){
          var amountPaid = double.tryParse(summary["paid"].toString())??0.0;
          var balance = double.tryParse(summary["balance"].toString())??0.0;
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

  void _updateGroupDashboardData(String groupId)async{
    if(_groupDashboardData[groupId].containsKey("group_details")){
      var groupDetails = _groupDashboardData[groupId]["group_details"] as Map<String,dynamic>;
      _cashBalances = double.tryParse(groupDetails["cash_balances"].toString())??0.0;
      _bankBalances = double.tryParse(groupDetails["bank_balances"].toString())??0.0;
      _groupContributionAmount = double.tryParse(groupDetails["total_contributions"].toString())??0.0;
      _groupExpenses = double.tryParse(groupDetails["total_expense_payments"].toString())??0.0;
      _groupPendingLoan = double.tryParse(groupDetails["total_loan_balances"].toString())??0.0;
      _groupFinePayments = double.tryParse(groupDetails["total_fines"].toString())??0.0;
      _groupLoanedAmount = double.tryParse(groupDetails["total_loaned_amount"].toString())??0.0;
      _groupLoanPaid = double.tryParse(groupDetails["total_loan_repaid"].toString())??0.0;

      var accountBalances = groupDetails["account_balances"];
      _bankAccountDashboardSummary = [];
      if(accountBalances.length>0){
        accountBalances.map((accountBalance){
          var accountName = accountBalance["description"].toString();
          var balance = double.tryParse(accountBalance["balance"].toString())??0.0;
          //if(balance > 1.0){
            _bankAccountDashboardSummary.add(BankAccountDashboardSummary(accountName: accountName,balance: balance));
          //}
        }).toList();
      }
    }
    notifyListeners();
  }

  Future<void> getMemberDashboardData(String groupId)async{
    try{
      const url = EndpointUrl.GET_MEMBER_DASHBOARD_DATA;
      try {
        if(!memberGroupDataExists(groupId)){
          final postRequest = json.encode({
            "user_id" : _userId,
            "group_id" : groupId,
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

  Future<void> getGroupDashboardData(String groupId)async{
    try{
      const url = EndpointUrl.GET_GROUP_DASHBOARD_DATA;
      try {
        if(!groupDataExists(groupId)){
          final postRequest = json.encode({
            "user_id" : _userId,
            "group_id" : groupId,
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

}