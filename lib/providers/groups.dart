import 'dart:convert';

import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/post-to-server.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Group {
  final String groupId;
  final String groupName;
  final String groupSize;

  Group({
    @required this.groupId,
    @required this.groupName,
    @required this.groupSize,
  });
}

class Account {
  final String id;
  final String name;
  final int typeId;

  Account({
    @required this.id,
    @required this.name,
    @required this.typeId,
  });
}

class Groups with ChangeNotifier {
  static const String selectedGroupId = "selectedGroupId";
  String currentGroupId = "";

  List<Group> _items = [];
  List<Account> _accounts = [];

  List<Group> get item {
    return [..._items];
  }

  List<Account> get accounts {
    return _accounts;
  }

  void addAccounts(List<dynamic> groupBankAccounts, int accountType) {
    final List<Account> bankAccounts = [];
    if (groupBankAccounts.length > 0) {
      for (var bankAccountJSON in groupBankAccounts) {
        final newAccount = Account(id: bankAccountJSON['id']..toString(), name: bankAccountJSON['name']..toString(), typeId: accountType);
        _accounts.add(newAccount);
      }
    }
    notifyListeners();
  }

  void addGroups(List<dynamic> groupObject) {
    final List<Group> loadedGroups = [];
    if (groupObject.length > 0) {
      for (var groupJSON in groupObject) {
        final newGroup =
            Group(groupId: groupJSON['id']..toString(), groupName: groupJSON['name']..toString(), groupSize: groupJSON['size']..toString());
        loadedGroups.add(newGroup);
      }
      _items = loadedGroups;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetUserGroups() async {
    const url = CustomHelper.baseUrl + CustomHelper.getCheckinData;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final userGroups = response['user_groups'] as List<dynamic>;
        addGroups(userGroups);
      } on HttpException catch (error) {
        throw HttpException(message: error.message, status: error.status);
      } catch (error) {
        throw HttpException(message: error.message);
      }
    } on HttpException catch (error) {
      throw HttpException(message: error.message, status: error.status);
    } catch (error) {
      print("error ${error.toString()}");
      throw (ERROR_MESSAGE);
    }
  }

  Future<void> fetchAccounts() async {
    const url = CustomHelper.baseUrl + "mobile/accounts/get_group_active_account_options";
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _accounts = []; //clear accounts
        final groupBankAccounts = response['accounts']['bank_accounts'] as List<dynamic>;
        addAccounts(groupBankAccounts, 1);
        final groupSaccoAccounts = response['accounts']['sacco_accounts'] as List<dynamic>;
        addAccounts(groupSaccoAccounts, 2);
        final groupMobileMoneyAccounts = response['accounts']['mobile_money_accounts'] as List<dynamic>;
        addAccounts(groupMobileMoneyAccounts, 3);
        final groupPettyCashAccountsAccounts = response['accounts']['petty_cash_accounts'] as List<dynamic>;
        addAccounts(groupPettyCashAccountsAccounts, 4);
      } on HttpException catch (error) {
        throw HttpException(message: error.message, status: error.status);
      } catch (error) {
        throw HttpException(message: error.message);
      }
    } on HttpException catch (error) {
      throw HttpException(message: error.message, status: error.status);
    } catch (error) {
      print("error ${error.toString()}");
      throw (ERROR_MESSAGE);
    }
  }

  setSelectedGroupId(String groupId) async {
    currentGroupId = groupId;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(selectedGroupId)) {
      prefs.remove(selectedGroupId);
    }
    prefs.setString(selectedGroupId, groupId);
  }

  getCurrentGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedGroupId);
  }

  Group getCurrentGroup() {
    Group group;
    bool groupFound = false;
    _items.forEach((element) {
      if (element.groupId == currentGroupId) {
        group = element;
        groupFound = true;
      }
    });

    if (groupFound) {
      return group;
    } else {
      return this._items[0];
    }
  }
}
