import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:flutter/cupertino.dart';

class NewRecentTransactionSummary {
  final String paymentTitle;
  final double paymentAmount;
  final String paymentDate;
  final String paymentMethod;
  final String description;

  NewRecentTransactionSummary(
      {@required this.paymentTitle,
      @required this.paymentAmount,
      @required this.paymentDate,
      this.paymentMethod,
      this.description});
}

class MemberRecentTransaction with ChangeNotifier {
  String _userId;
  List<NewRecentTransactionSummary> _recentTransactions = [];
  String _currentGroupId;
  Map<String, Map<String, dynamic>> _recentTransactionData;
  String _requestId = DateTime.now().microsecondsSinceEpoch.toString();

  MemberRecentTransaction(String _userId, String _currentGroupId,
      Map<String, Map<String, dynamic>> _recentTransactionData) {
    this._currentGroupId = _currentGroupId;
    this._recentTransactionData = _recentTransactionData;
    this._userId = _userId;

    if (_recentTransactionData.containsKey(_currentGroupId)) {
      if (_recentTransactionData[_currentGroupId].isNotEmpty) {
        _updateRecentTransactions(_currentGroupId);
      }
    }
  }

  String get userId {
    return _userId;
  }

  List<NewRecentTransactionSummary> get recentTransactions {
    return [..._recentTransactions];
  }

  Map<String, Map<String, dynamic>> get recentTransactionData {
    return _recentTransactionData;
  }

  bool recentTransactionsExist(String groupId) {
    if (_recentTransactionData.containsKey(groupId)) {
      if (_recentTransactionData[groupId].length > 0) {
        return true;
      }else if(_recentTransactionData[groupId] == null){
        return false;
      }
      else
      {
        return false;
      }
    }else if(_recentTransactionData == null){
      return false;
    } else {
      return false;
    }
  }

  void resetRecentTransactions(String groupId) {
    if (_recentTransactionData.containsKey(groupId)) {
      print(_recentTransactionData);
      _recentTransactionData.removeWhere((key, value) => key == groupId);
    }
  }

  void _updateRecentTransactions(String groupId) {
    // if(_recentTransactionData[groupId].containsKey("recent_transactions")){
    var groupObject = _recentTransactionData[groupId];

    var recentTransactions = groupObject["recent_transactions"];
    _recentTransactions = [];

    if (recentTransactions.length > 0) {
      recentTransactions.map((summary) {
        var description = summary["description"].toString();
        var amount = double.tryParse(summary["amount"].toString()) ?? 0.0;
        var date = summary["date"].toString();
        var title = summary["type"].toString();
        var paymentMethod = summary["payment_method"].toString();
        if (amount > 1.0) {
          _recentTransactions.add(NewRecentTransactionSummary(
            paymentAmount: amount,
            description: description,
            paymentDate: date,
            paymentTitle: title,
            paymentMethod: paymentMethod,
          ));
        }
      }).toList();
    }
    // }notifyListeners();
  }

  // /*********** New  RecentTransactions APIs *********/
  Future<void> getRecentTransactionsSummary(String groupId) async {
    final url = EndpointUrl.GET_RECENT_MEMBER_TRANSACTIONS;
    var dt = DateTime.now();
    try {
      final postRequest = json.encode({
        "request_id": _requestId,
        "user_id": _userId,
        "group_id": groupId,
        "limit": "5"
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _recentTransactionData[groupId] = response;
        // log('getcontributionssummary'+ response + ' ' + dt.toString());
        _updateRecentTransactions(groupId);
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
