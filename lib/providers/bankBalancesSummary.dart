import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:flutter/material.dart';

class AccountBalancesDashboardSummary {
  final String accountName;
  final double balance;

  AccountBalancesDashboardSummary(
      {@required this.accountName, @required this.balance});
}

class BalancesDashboardSummary with ChangeNotifier {
  List<AccountBalancesDashboardSummary> _accountBalancesDashboardSummary = [];
  String _userId;
  String _currentGroupId;
  String _requestId = DateTime.now().microsecondsSinceEpoch.toString();
  Map<String, Map<String, dynamic>> _accountData;
  Map<String, dynamic> _totalBankBalance;

  BalancesDashboardSummary(
    String _userId,
    String _currentGroupId,
    Map<String, Map<String, dynamic>> _accountData,
    Map<String, dynamic> _totalBankBalance,
  ) {
    this._userId = _userId;
    this._currentGroupId = _currentGroupId;
    this._accountData = _accountData;
    this._totalBankBalance = _totalBankBalance;

    if (_accountData.containsKey(_currentGroupId)) {
      if (_accountData[_currentGroupId].isNotEmpty) {
        _updateBalancesDashboardSummary(_currentGroupId);
      }
    }

    if (_totalBankBalance.containsKey(_currentGroupId)) {
      if (_totalBankBalance[_currentGroupId].isNotEmpty) {
        _updateBalancesDashboardSummary(_currentGroupId);
      }
    }
  }

  //***************account****************/
  double _bankAccountBalance = 0.0;
  double _cashAccounBalance = 0.0;

  //***************Bank****************/

  double _totalBackBalanceAccount = 0.0;

  Map<String, Map<String, dynamic>> get accountData {
    return _accountData;
  }

  double get bankAccountBalance {
    return _bankAccountBalance;
  }

  double get cashAccounBalance {
    return _cashAccounBalance;
  }

  double get totalBackBalanceAccount {
    return _totalBackBalanceAccount;
  }

  Map<String, dynamic> get totalBankBalance {
    return _totalBankBalance;
  }

 
  bool accountBalanceSummaryExists(String groupId) {
    if (_accountData.containsKey(groupId)) {
      if (_accountData[groupId].length <= 0) {
        return false;
      }
      {
        return true;
      }
    } else {
      return false;
    }
  }


  void resetAccountBalanceSummary(String groupId) {
    if (_accountData.containsKey(groupId)) {
      print(_accountData);
      _accountData.removeWhere((key, value) => key == groupId);
    }
  }


  bool totalBankBalanceSummaryExists(String groupId) {
    if (_totalBankBalance.containsKey(groupId)) {
      if (_totalBankBalance[groupId].length <= 0) {
        return false;
      }
      {
        return true;
      }
    } else {
      return false;
    }
  }


  void resetTotalBankBalanceSummary(String groupId) {
    if (_totalBankBalance.containsKey(groupId)) {
      print(_totalBankBalance);
      _totalBankBalance.removeWhere((key, value) => key == groupId);
    }
  }

  void _updateBalancesDashboardSummary(String groupId) {
    var accountObject = _accountData[groupId];
    var totalBankBalanceObject = _totalBankBalance[groupId];
    var groupFineDetail = totalBankBalanceObject["total_bank_balance"];
    var accountDetails =
        accountObject["account_balances"] as Map<String, dynamic>;
    _totalBackBalanceAccount =
        double.tryParse(groupFineDetail.toString()) ?? 0.0;
    _bankAccountBalance =
        double.tryParse(accountDetails["bank_account_balance"].toString()) ??
            0.0;
    _cashAccounBalance =
        double.tryParse(accountDetails["cash_account_balance"].toString()) ??
            0.0;
  }

  /// *********New Account Balances Apis************/
  Future<void> getAccountBalancesSummary(String groupId) async {
    final url = EndpointUrl.ACCOUNT_BALANCE_SUMMARY;
    try {
      final postRequest = json.encode({
        "request_id": _requestId,
        "user_id": _userId,
        "group_id": groupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _accountData[groupId] = response;
        _totalBankBalance[groupId] = response;
        _updateBalancesDashboardSummary(groupId);
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
