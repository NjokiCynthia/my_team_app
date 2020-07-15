import 'dart:convert';

import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/endpoint-url.dart';
import 'package:chamasoft/utilities/post-to-server.dart';
import 'package:flutter/cupertino.dart';

class Dashboard with ChangeNotifier{

  String _userId;
  Map<String,dynamic> _dashboardData;
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
    print("total ${_cashBalances+_bankBalances}");
    return _cashBalances+_bankBalances;
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
        print("total ${_cashBalances+_bankBalances}");
      }
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
        await _updateDashboardData();
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