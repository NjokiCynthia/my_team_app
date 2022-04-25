import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:flutter/material.dart';

class GroupNotifications with ChangeNotifier {
  String _userId;
  String _currentGroupId;
  String _requestId = DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> _notifications;

  int _notificationCount = 0;
  int _unreconciledDepositCount = 0;
  int _unreconciledWithdrwalCount = 0;

  bool _isPartnerBankAccount = false;

  GroupNotifications(String _userId, String _currentGroupId,
      Map<String, dynamic> _notifications) {
    this._userId = _userId;
    this._currentGroupId = _currentGroupId;
    this._notifications = _notifications;

    if (_notifications.containsKey(_currentGroupId)) {
      if (_notifications[_currentGroupId].isNotEmpty) {
        _updateGroupNotificationsSummary(_currentGroupId);
      }
    }
  }

  Map<String, dynamic> get notifications {
    return _notifications;
  }

  int get notificationCount {
    return _notificationCount;
  }

  int get unreconciledDepositCount {
    return _unreconciledDepositCount;
  }

  int get unreconciledWithdrwalCount {
    return _unreconciledWithdrwalCount;
  }

  bool get isPartnerBankAccount {
    return _isPartnerBankAccount;
  }

  void _updateGroupNotificationsSummary(String groupId) async {
    var groupNotificationObject = _notifications[groupId];
    _notificationCount =
        int.tryParse(groupNotificationObject["notification_count"]) ?? 0;
    _unreconciledDepositCount =
        int.tryParse(groupNotificationObject["unreconciled_deposits_count"]) ??
            0;
    _unreconciledWithdrwalCount = int.tryParse(
            groupNotificationObject["unreconciled_withdrawals_count"]) ??
        0;
    _isPartnerBankAccount =
        (int.tryParse(["has_partner_bank"].toString())) == 1 ? true : false;
  }

  // /*********** Group Notification Summary APIs *********/
  Future<void> getGroupNotificationsSummary(String groupId) async {
    final url = EndpointUrl.GET_GROUP_NOTIFICATIONS_SUMMARY;
    try {
      final postRequest = json.encode({
        "request_id": _requestId,
        "user_id": _userId,
        "group_id": groupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _notifications[groupId] = response;
        _updateGroupNotificationsSummary(groupId);
      } on CustomException catch (error) {
        throw CustomException(
            message:
                "Error: We could not complete your request at the moment. Try again ");
        // throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      // throw CustomException(message: "Error: ${error.message}");
      // throw CustomException(message: error.message, status: error.status);
      throw CustomException(
          message:
              "Error: We could not complete your request at the moment. Try again ");
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }
}
