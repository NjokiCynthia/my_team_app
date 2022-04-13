import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DashboardFineSummary with ChangeNotifier {
  String _userId;
  String _currentGroupId;
  String _requestId = DateTime.now().microsecondsSinceEpoch.toString();
  Map<String, Map<String, dynamic>> _memberData;
  Map<String, dynamic> _totalGroupFineAmount;

  // DashboardFineSummary(String userId, String currentGroupId, Map map, Map map2);

  DashboardFineSummary(
    String _userId,
    String _currentGroupId,
    Map<String, Map<String, dynamic>> _memberData,
    Map<String, dynamic> _totalGroupFineAmount,
  ) {
    this._userId = _userId;
    this._currentGroupId = _currentGroupId;
    this._memberData = _memberData;
    this._totalGroupFineAmount = _totalGroupFineAmount;

    if (_memberData.containsKey(_currentGroupId)) {
      if (_memberData[_currentGroupId].isNotEmpty) {
        _updateMemberFineSummaries(_currentGroupId);
      }
    }

    if (_totalGroupFineAmount.containsKey(_currentGroupId)) {
      if (_totalGroupFineAmount[_currentGroupId].isNotEmpty) {
        _updateMemberFineSummaries(_currentGroupId);
      }
    }
  }

  //***************member****************/
  double _memberFinePaid = 0.0;
  double _memberFineArrears = 0.0;

  //***************Group****************/

  int _totalGroupFinePaid = 0;

  Map<String, Map<String, dynamic>> get memberData {
    return _memberData;
  }

  double get memberFinePaid {
    return _memberFinePaid;
  }

  double get memberFineArrears {
    return _memberFineArrears;
  }

  int get totalGroupFinePaid {
    return _totalGroupFinePaid;
  }

  Map<String, dynamic> get totalGroupFineAmount {
    return _totalGroupFineAmount;
  }

  //TODO figure out how to use it
  bool memberFineSummaryExists(String groupId) {
    if (_memberData.containsKey(groupId)) {
      if (_memberData[groupId].length <= 0) {
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
  void resetMemberFineSummary(String groupId) {
    if (_memberData.containsKey(groupId)) {
      print(_memberData);
      _memberData.removeWhere((key, value) => key == groupId);
    }
  }

//TODO figure out how to use it
  bool groupFineSummaryExists(String groupId) {
    if (_totalGroupFineAmount.containsKey(groupId)) {
      if (_totalGroupFineAmount[groupId].length <= 0) {
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
  void resetGroupFineSummary(String groupId) {
    if (_totalGroupFineAmount.containsKey(groupId)) {
      print(_totalGroupFineAmount);
      _totalGroupFineAmount.removeWhere((key, value) => key == groupId);
    }
  }

  void _updateMemberFineSummaries(String groupId) {
    var groupMemberObject = _memberData[groupId];
    var groupFineObject = _totalGroupFineAmount[groupId];
    var groupFineDetail = groupFineObject["total_group_fines_paid"];
    var memberDetails =
        groupMemberObject["member_fines_summary"] as Map<String, dynamic>;
    _totalGroupFinePaid = int.tryParse(groupFineDetail.toString()) ?? 0;
    _memberFinePaid =
        double.tryParse(memberDetails["fine_paid"].toString()) ?? 0.0;
    _memberFineArrears =
        double.tryParse(memberDetails["fine_arrears"].toString()) ?? 0.0;
  }

  /// *********New Fines APIs ************/
  Future<void> getFinesSummary(String groupId) async {
    final url = EndpointUrl.GET_FINES_SUMMARY;
    try {
      final postRequest = json.encode({
        "request_id": _requestId,
        "user_id": _userId,
        "group_id": groupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _memberData[groupId] = response;
        _totalGroupFineAmount[groupId] = response;
        _updateMemberFineSummaries(groupId);
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
