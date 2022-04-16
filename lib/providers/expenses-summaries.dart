import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:flutter/material.dart';

class NewExpensesSummariesList {
  final String expenseName;
  final double expenseAmount;

  NewExpensesSummariesList({
    this.expenseName,
    this.expenseAmount,
  });
}

class NewExpensesSummaries with ChangeNotifier {
  List<NewExpensesSummariesList> _newExpensesSummariesList;
  String _userId;
  String _currentGroupId;
  Map<String, Map<String, dynamic>> _expensesSummariesData;
  Map<String, Map<String, dynamic>> _expensesSummariesTotalData;

  int _totalExpensesSummaries = 0;

  NewExpensesSummaries(
      String _userId,
      String _currentGroupId,
      Map<String, Map<String, dynamic>> _expensesSummariesData,
      Map<String, Map<String, dynamic>> _expensesSummariesTotalData) {
    this._userId = _userId;
    this._currentGroupId = _currentGroupId;
    this._expensesSummariesData = _expensesSummariesData;
    this._expensesSummariesTotalData = _expensesSummariesTotalData;

    if (_expensesSummariesData.containsKey(_currentGroupId)) {
      if (_expensesSummariesData[_currentGroupId].isNotEmpty) {
        _updateExpensesSummariesList(_currentGroupId);
      }
    }

    if (_expensesSummariesTotalData.containsKey(_currentGroupId)) {
      if (_expensesSummariesTotalData[_currentGroupId].isNotEmpty) {
        _updateExpensesSummariesList(_currentGroupId);
      }
    }
  }

  String get userId {
    return _userId;
  }

  List<NewExpensesSummariesList> get newExpensesSummariesList {
    if(_newExpensesSummariesList == null) {
      return [];
    }else {
      return [..._newExpensesSummariesList];
    }
    // return [..._newExpensesSummariesList];
  }

  Map<String, Map<String, dynamic>> get expensesSummariesData {
    return this._expensesSummariesData;
  }

  Map<String, Map<String, dynamic>> get expensesSummariesTotalData {
    return this._expensesSummariesTotalData;
  }

  bool expensesSummariesExists(String groupId) {
    if (_expensesSummariesData.containsKey(groupId)) {
      if (_expensesSummariesData[groupId].length > 0) {
        return true;
      }
      {
        return false;
      }
    }
    return false;
  }

  bool expensesSummariesTotalExists(String groupId) {
    if (_expensesSummariesTotalData.containsKey(groupId)) {
      if (_expensesSummariesTotalData[groupId].length > 0) {
        return true;
      }
      {
        return false;
      }
    }
    return false;
  }

  void resetExpensesSummaries(String groupId) {
    if (_expensesSummariesData.containsKey(groupId)) {
      _expensesSummariesData.removeWhere((key, value) => key == groupId);
    }
  }

  void resetExpensesTotalSummaries(String groupId) {
    if (_expensesSummariesData.containsKey(groupId)) {
      _expensesSummariesTotalData.removeWhere((key, value) => key == groupId);
    }
  }

  int get totalExpensesSummaries {
    return _totalExpensesSummaries;
  }

  void _updateExpensesSummariesList(String groupId) {
    var groupObject = _expensesSummariesData[groupId]['data'];
    var expenseSummaries = groupObject["expenses"];
    _newExpensesSummariesList = [];

    var expensesTotalSummaries = groupObject["total_expenses"];
    _totalExpensesSummaries = expensesTotalSummaries ?? 0;

    if (expenseSummaries.length > 0) {
      expenseSummaries.map((expense) {
        var name = expense["expense_name"].toString();
        var amount = expense["amount"];

        if (name != null && name != "" && amount != null && amount != "") {
          _newExpensesSummariesList.add(NewExpensesSummariesList(
            expenseName: name,
            expenseAmount: double.tryParse(amount) ?? 0.0,
          ));
        }
      }).toList();
    }
  }

  Future<void> fetchExpenses(String groupId) async {
    final url = EndpointUrl.GET_EXPENSES_SUMMARY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": groupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _expensesSummariesData[groupId] = response;
        _updateExpensesSummariesList(groupId);
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
