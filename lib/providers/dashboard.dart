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
  Map<String,dynamic> _dashboardData;
  List<BankAccountDashboardSummary> _bankAccountDashboardSummary = [];
  //final String _currentGroupId;

  Dashboard(String _userId,Map<String,dynamic> _dashboardData){
    this._dashboardData = _dashboardData;
    this._userId = _userId;
    print("Passed data userId : $_userId and data: $_dashboardData");
    if(_dashboardData.isNotEmpty){
      _updateDashboardData();
    }
  }

  double _memberContributionAmount = 0.0;
  double _memberFinesAmount = 0.0;
  double _memberLoansAmount = 0.0;
  double _memberLoanBalanceAmount = 0.0;

  double _cashBalances=0.0;
  double _bankBalances=0.0;

  Map<String,dynamic> get dashboardData{
    return _dashboardData;
  }

  double get memberContributionAmount{
    return _memberContributionAmount;
  }

  double get totalBankBalances{
    return _cashBalances+_bankBalances;
  }

  List<BankAccountDashboardSummary> get bankAccountDashboardSummary{
    return [..._bankAccountDashboardSummary];
  }

  void _updateDashboardData()async{
    if(_dashboardData.containsKey("member_details")){
      var memberDetails = _dashboardData["member_details"] as Map<String,dynamic>;
      _memberContributionAmount = double.tryParse(memberDetails["total_contributions"].toString());
    }
    if(_dashboardData.containsKey("group_details")){
      var groupDetails = _dashboardData["group_details"] as Map<String,dynamic>;
      _cashBalances = double.tryParse(groupDetails["cash_balances"].toString());
      _bankBalances = double.tryParse(groupDetails["bank_balances"].toString());
      
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

  Future<void> getGroupDashboardData(String groupId)async{
    try{
      const url = EndpointUrl.GET_MEMBER_DASHBOARD;
      try {
        final postRequest = json.encode({
          "user_id" : _userId,
          "group_id" : groupId,
        });
        final response = await PostToServer.post(postRequest, url);
        _dashboardData = response;
        _updateDashboardData();
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