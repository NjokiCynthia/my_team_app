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

class Dashboard with ChangeNotifier{
  String _userId;
  Map<String,dynamic> _memberDashboardData;
  Map<String,dynamic> _groupDashboardData;
  List<BankAccountDashboardSummary> _bankAccountDashboardSummary = [];
  //final String _currentGroupId;

  Dashboard(String _userId,Map<String,dynamic> _memberDashboardData,Map<String,dynamic> _groupDashboardData){
    this._memberDashboardData = _memberDashboardData;
    this._groupDashboardData = _groupDashboardData;
    this._userId = _userId;
    if(_memberDashboardData.isNotEmpty){
      _updateMemberDashboardData();
    }
    if(_groupDashboardData.isNotEmpty){
      _updateGroupDashboardData();
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

  Map<String,dynamic> get memberDashboardData{
    return _memberDashboardData;
  }

  Map<String,dynamic> get groupDashboardData{
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

  List<BankAccountDashboardSummary> get bankAccountDashboardSummary{
    return [..._bankAccountDashboardSummary];
  }

  void _updateMemberDashboardData()async{
    if(_memberDashboardData.containsKey("member_details")){
      var memberDetails = _memberDashboardData["member_details"] as Map<String,dynamic>;
      _memberContributionAmount = double.tryParse(memberDetails["total_contributions"].toString())??0.0;
      _memberContributionArrears = double.tryParse(memberDetails["contribution_arrears"].toString())??0.0;
      _memberFineArrears = double.tryParse(memberDetails["fine_arrears"].toString())??0.0;
      _memberLoanArrears = double.tryParse(memberDetails["loan_arrears"].toString())??0.0;
      _memberTotalLoanBalance = double.tryParse(memberDetails["total_loan_balances"].toString())??0.0;
    }
    notifyListeners();
  }

  void _updateGroupDashboardData()async{
    if(_groupDashboardData.containsKey("group_details")){
      var groupDetails = _groupDashboardData["group_details"] as Map<String,dynamic>;
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
          if(balance > 1.0){
            _bankAccountDashboardSummary.add(BankAccountDashboardSummary(accountName: accountName,balance: balance));
          }
        }).toList();
      }
    }
    notifyListeners();
  }

  Future<void> getMemberDashboardData(String groupId)async{
    try{
      const url = EndpointUrl.GET_MEMBER_DASHBOARD_DATA;
      try {
        final postRequest = json.encode({
          "user_id" : _userId,
          "group_id" : groupId,
        });
        final response = await PostToServer.post(postRequest, url);
        _memberDashboardData = response;
        _updateMemberDashboardData();
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

  Future<void> getGroupDashboardData(String groupId)async{
    try{
      const url = EndpointUrl.GET_GROUP_DASHBOARD_DATA;
      try {
        final postRequest = json.encode({
          "user_id" : _userId,
          "group_id" : groupId,
        });
        final response = await PostToServer.post(postRequest, url);
        _groupDashboardData = response;
        _updateGroupDashboardData();
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