import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:chamasoft/providers/dashboard.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';

class DashboardContributionSummary with ChangeNotifier {
  String _userId;
  String _currentGroupId;
  String _requestId = DateTime.now().microsecondsSinceEpoch.toString();
  Map<String, Map<String, dynamic>> _memberData;
  Map<String, dynamic> _totalGroupContributionAmount;

  List<String> _month = [];
  List<ContributionsSummary> _memberContributionSummary = [];

  DashboardContributionSummary(
    String _userId,
    String _currentGroupId,
    Map<String, Map<String, dynamic>> _memberData,
    Map<String, dynamic> _totalGroupContributionAmount,
  ) {
    this._userId = _userId;
    this._currentGroupId = _currentGroupId;
    this._memberData = _memberData;
    this._totalGroupContributionAmount = _totalGroupContributionAmount;

    if (_memberData.containsKey(_currentGroupId)) {
      if (_memberData[_currentGroupId].isNotEmpty) {
        _updateMemberContributionSummaries(_currentGroupId);
      }
    }

    if (_totalGroupContributionAmount.containsKey(_currentGroupId)) {
      if (_totalGroupContributionAmount[_currentGroupId].isNotEmpty) {
        _updateMemberContributionSummaries(_currentGroupId);
      }
    }
  }

  String get userId {
    return _userId;
  }

  //***************member****************/
  double _memberContributionAmount = 0.0;
  double _memberContributionArrears = 0.0;
  int _nextcontributionDate = 0;
  String _contributionDateDaysleft = "";

  //***************Group****************/
  int _groupContributionAmount = 0;

  Map<String, Map<String, dynamic>> get memberData {
    return _memberData;
  }

  double get memberContributionAmount {
    return _memberContributionAmount;
  }

  String get contributionDateDaysleft {
    return _contributionDateDaysleft;
  }

  int get nextcontributionDate {
    return _nextcontributionDate;
  }

  double get memberContributionArrears {
    return _memberContributionArrears;
  }

  //********Group********/

  Map<String, dynamic> get totalGroupContributionAmount {
    return _totalGroupContributionAmount;
  }

  int get groupContributionAmount {
    return _groupContributionAmount;
  }

//TODO figure out how to use it
  bool memberContributionSummaryExists(String groupId) {
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
  void resetMemberContributionSummary(String groupId) {
    if (_memberData.containsKey(groupId)) {
      print(_memberData);
      _memberData.removeWhere((key, value) => key == groupId);
    }
  }

//TODO figure out how to use it
  bool groupContributionSummaryExists(String groupId) {
    if (_totalGroupContributionAmount.containsKey(groupId)) {
      if (_totalGroupContributionAmount[groupId].length <= 0) {
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
  void resetGroupContributionSummary(String groupId) {
    if (_totalGroupContributionAmount.containsKey(groupId)) {
      print(_totalGroupContributionAmount);
      _totalGroupContributionAmount.removeWhere((key, value) => key == groupId);
    }
  }

  void _updateMemberContributionSummaries(String groupId) async {
    // if(_memberData[groupId].containsKey("member_contribution_summary")) {
      var groupMemberObject = _memberData[groupId];
      var groupContributionObject = _totalGroupContributionAmount[groupId];
      var groupContributionDetail =
      groupContributionObject["total_group_contribution"];
      var memberDetails = groupMemberObject["member_contribution_summary"]
      as Map<String, dynamic>;
      _groupContributionAmount = int.tryParse(groupContributionDetail) ?? 0.0;
      _memberContributionAmount =
          double.tryParse(memberDetails["contribution_paid"].toString()) ?? 0.0;
      _memberContributionArrears =
          double.tryParse(memberDetails["contribution_arrears"].toString()) ??
              0.0;
      _nextcontributionDate =
          int.tryParse(memberDetails["next_contribution_date"].toString()) ?? 0;
      _contributionDateDaysleft =
          memberDetails["days_to_next_contribution"] ?? "--";
    // }notifyListeners();
  }

  // /*********** New Contributions APIs *********/
  Future<void> getContributionsSummary(String groupId) async {
    final url = EndpointUrl.GET_MEMBER_CONTRIBUTION_SUMMARY;
    var dt = DateTime.now();
    try {
      final postRequest = json.encode({
        "request_id": _requestId,
        "user_id": _userId,
        "group_id": groupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _memberData[groupId] = response;
        // log('getcontributionssummary'+ response + ' ' + dt.toString());
        _totalGroupContributionAmount[groupId] = response;
        _updateMemberContributionSummaries(groupId);
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
