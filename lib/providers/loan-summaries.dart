import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:flutter/material.dart';

class LoanDashboardSummary with ChangeNotifier {
  String _userId;
  String _currentGroupId;
  String _requestId = DateTime.now().microsecondsSinceEpoch.toString();
  Map<String, Map<String, dynamic>> _loanData;
  Map<String, dynamic> _totalLoanBankBalance;

   LoanDashboardSummary(
    String _userId,
    String _currentGroupId,
    Map<String, Map<String, dynamic>> _loanData,
    Map<String, dynamic> _totalLoanBankBalance,
  ) {
    this._userId = _userId;
    this._currentGroupId = _currentGroupId;
    this._loanData = _loanData;
    this._totalLoanBankBalance = _totalLoanBankBalance;

    if (_loanData.containsKey(_currentGroupId)) {
      if (_loanData[_currentGroupId].isNotEmpty) {
        _updateLoanDashboardSummaries(_currentGroupId);
      }
    }

    if (_totalLoanBankBalance.containsKey(_currentGroupId)) {
      if (_totalLoanBankBalance[_currentGroupId].isNotEmpty) {
        _updateLoanDashboardSummaries(_currentGroupId);
      }
    }
  }

  String get userId {
    return _userId;
  }

  //***************Account Balances****************/
  double _loanBalance = 0.0;
  double _totalLoanAmount = 0.0;
  double _nextInstalmentAmount = 0.0;
  int  _nextInstalmentAmountInt = 0;
  int _nextInstalmentDate = 0;
  String _nexttoNextInstalmentDay = "";

  //***************Total****************/
    int _totalGroupLoanBalance = 0;

    
  Map<String, Map<String, dynamic>> get loanData {
    return _loanData;
  }
   double get loanBalance {
    return _loanBalance;
  }
   double get totalLoanAmount {
    return _totalLoanAmount;
  }
   double get nextInstalmentAmount {
    return _nextInstalmentAmount;
  }

  int get nextInstalmentAmountInt {
    return _nextInstalmentAmountInt;}
   int get nextInstalmentDate {
    return _nextInstalmentDate;
  }
   String get nexttoNextInstalmentDay {
    return _nexttoNextInstalmentDay;
  }

   Map<String,dynamic> get totalLoanBankBalance {
    return _totalLoanBankBalance;
  }
   int get totalGroupLoanBalance {
    return _totalGroupLoanBalance;
  }

  //TODO figure out how to use it
  bool loanSummaryExists(String groupId) {
    if (_loanData.containsKey(groupId)) {
      if (_loanData[groupId].length <= 0) {
        return false;
      }
      {
        return true;
      }
    } else {
      return false;
    }
  }

//TODO figure out how to use it
  void resetloanSummary(String groupId) {
    if (_loanData.containsKey(groupId)) {
      print(_loanData);
      _loanData.removeWhere((key, value) => key == groupId);
    }
  }

//TODO figure out how to use it
  bool grouploanExists(String groupId) {
    if (_totalLoanBankBalance.containsKey(groupId)) {
      if (_totalLoanBankBalance[groupId].length <= 0) {
        return false;
      }
      {
        return true;
      }
    } else {
      return false;
    }
  }

//TODO figure out how to use it
  void resetGroupLoanSummary(String groupId) {
    if (_totalLoanBankBalance.containsKey(groupId)) {
      print(_totalLoanBankBalance);
      _totalLoanBankBalance.removeWhere((key, value) => key == groupId);
    }
  }



  void _updateLoanDashboardSummaries(String groupId) {
    // if(_loanData[groupId].containsKey("member_loans_summary")) {
    var loanObject = _loanData[groupId];
    var groupLoanObject = _totalLoanBankBalance[groupId];
    // int groupLoanDetail =
    //     groupLoanObject["total_group_loan_balance"];
    var memberDetails = loanObject["member_loans_summary"]
        as Map<String, dynamic>;
    _totalGroupLoanBalance = int.tryParse(groupLoanObject["total_group_loan_balance"].toString()) ?? 0.0;
    _loanBalance =
        double.tryParse(memberDetails["loan_balances"].toString()) ?? 0.0;
    _totalLoanAmount =
        double.tryParse(memberDetails["total_loan_amount"].toString()) ??
            0.0;
    _nextInstalmentAmount =  double.tryParse(memberDetails["next_instalment_amount"].toString()) ?? 0.0;
    _nextInstalmentAmountInt = int.tryParse(memberDetails["next_instalment_amount"].toString()) ?? 0.0;
    _nextInstalmentDate =
        (memberDetails["next_instalment_date"]) ?? 0;
        _nexttoNextInstalmentDay =
        memberDetails["days_to_next_instalment"] ?? "--";
    // }notifyListeners();
  }

  // /*********** New Contributions APIs *********/
  Future<void> getDashboardLoanSummary(String groupId) async {
    final url = EndpointUrl.GET_GROUP_MEMBER_LOANS_SUMMARY;
    try {
      final postRequest = json.encode({
        "request_id": _requestId,
        "user_id": _userId,
        "group_id": groupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _loanData[groupId] = response;
        _totalLoanBankBalance[groupId] = response;
        _updateLoanDashboardSummaries(groupId);
        // final data = response['data'] as dynamic;
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

} 


