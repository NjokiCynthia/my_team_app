import 'dart:convert';

import 'package:chamasoft/providers/helpers/report_helper.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/endpoint-url.dart';
import 'package:chamasoft/utilities/post-to-server.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

class Group {
  final String groupId;
  final String groupName;
  final String groupSize;
  final String groupCountryId;
  final List<GroupRoles> groupRoles;

  Group({
    @required this.groupId,
    @required this.groupName,
    @required this.groupSize,
    @required this.groupCountryId,
    this.groupRoles,
  });
}

class GroupRoles{
  String roleId;
  String roleName;

  GroupRoles({
    @required this.roleId,
    @required this.roleName,
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

class Contribution {
  final String id;
  final String name;
  final String amount;
  final String type;
  final String contributionType;
  final String frequency;
  final String invoiceDate;
  final String contributionDate;
  final String oneTimeContributionSetting;
  final String isHidden;
  final String active;

  Contribution({
    @required this.id,
    @required this.name,
    @required this.amount,
    this.type,
    this.contributionType,
    this.frequency,
    this.invoiceDate,
    this.contributionDate,
    this.oneTimeContributionSetting,
    this.isHidden,
    this.active,
  });
}

class Expense {
  final String position;
  final String name;
  final String amount;

  Expense({
    @required this.position,
    @required this.name,
    @required this.amount,
  });
}

class FineType {
  final String id;
  final String name;
  final String amount;
  final String balance;

  FineType({
    @required this.id,
    @required this.name,
    @required this.amount,
    @required this.balance,
  });
}

class LoanType {
  final String id;
  final String name;
  final String repaymentPeriod;
  final String loanAmount;
  final String interestRate;
  final String loanProcessing;
  final String disbursementDate;
  final String guarantors;
  final String latePaymentFines;
  final String outstandingPaymentFines;
  final String isHidden;

  LoanType({
    this.id,
    this.name,
    this.repaymentPeriod,
    this.loanAmount,
    this.interestRate,
    this.loanProcessing,
    this.disbursementDate,
    this.guarantors,
    this.latePaymentFines,
    this.outstandingPaymentFines,
    this.isHidden,
  });
}

class Member {
  final String id;
  final String name;
  final String userId;
  final String avatar;
  final String identity;

  Member({
    @required this.id,
    @required this.name,
    @required this.userId,
    @required this.avatar,
    @required this.identity,
  });
}

class GroupContributionSummary {
  final String memberId;
  final String memberName;
  final double paidAmount;
  final double balanceAmount;

  GroupContributionSummary({
    @required this.memberId,
    @required this.memberName,
    @required this.paidAmount,
    @required this.balanceAmount,
  });
}

class Groups with ChangeNotifier {
  static const String selectedGroupId = "selectedGroupId";
  String currentGroupId = "";

  List<Group> _items = [];
  List<Account> _accounts = [];
  List<Contribution> _contributions = [];
  List<Expense> _expenses = [];
  List<FineType> _fineTypes = [];
  List<LoanType> _loanTypes = [];
  List<Member> _members = [];
  List<List<Account>> _allAccounts = [];
  AccountBalances _accountBalances;
  TransactionStatement _transactionStatement;
  ExpenseSummaryList _expenseSummaryList;
  List<GroupContributionSummary> _groupcontributionSummary = [];

  List<Group> get item {
    return _items;
  }

  List<Account> get accounts {
    return _accounts;
  }

  List<Contribution> get contributions {
    return _contributions;
  }

  List<Expense> get expenses {
    return _expenses;
  }

  List<FineType> get fineTypes {
    return _fineTypes;
  }

  List<LoanType> get loanTypes {
    return _loanTypes;
  }

  List<Member> get members {
    return _members;
  }

  List<List<Account>> get allAccounts {
    return _allAccounts;
  }

  AccountBalances get accountBalances {
    return _accountBalances;
  }

  TransactionStatement get transactionStatement {
    return _transactionStatement;
  }

  ExpenseSummaryList get expenseSummaryList {
    return _expenseSummaryList;
  }

  List<GroupContributionSummary> get groupContributionSummary {
    return _groupcontributionSummary;
  }



  /// ********************Group Objects************/

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

  void addGroups(List<dynamic> groupObject) {
    final List<Group> loadedGroups = [];
    if (groupObject.length > 0) {
      for (var groupJSON in groupObject) {
        final newGroup = Group(
          groupId: groupJSON['id'].toString(), 
          groupName: groupJSON['name'].toString(), 
          groupSize: groupJSON['size'].toString(),
          groupCountryId: groupJSON['country_id'].toString(),
        );
        loadedGroups.add(newGroup);
      }
    }
    _items = loadedGroups;
    notifyListeners();
  }

/// ********************End Group Objects************/

  void addAccounts(List<dynamic> groupBankAccounts, int accountType) {
    final List<Account> bankAccounts = [];
    if (groupBankAccounts.length > 0) {
      for (var bankAccountJSON in groupBankAccounts) {
        final newAccount = Account(id: bankAccountJSON['id'].toString(), name: bankAccountJSON['name'].toString(), typeId: accountType);
        bankAccounts.add(newAccount);
        _accounts.add(newAccount);
      }
    }
    _allAccounts.add(bankAccounts);
    notifyListeners();
  }

  void addContributions(List<dynamic> groupContributions) {
    if (groupContributions.length > 0) {
      for (var groupContributionJSON in groupContributions) {
        final newContribution = Contribution(
          id: groupContributionJSON['id'].toString(),
          name: groupContributionJSON['name'].toString(),
          amount: groupContributionJSON['amount'].toString(),
          type: groupContributionJSON['type'].toString(),
          contributionType: groupContributionJSON['contribution_type'].toString(),
          frequency: groupContributionJSON['frequency'].toString(),
          invoiceDate: groupContributionJSON['invoice_date'].toString(),
          contributionDate: groupContributionJSON['contribution_date'].toString(),
          oneTimeContributionSetting: groupContributionJSON['one_time_contribution_setting'].toString(),
          isHidden: groupContributionJSON['is_hidden'].toString(),
          active: groupContributionJSON['active'].toString(),
        );
        _contributions.add(newContribution);
      }
    }
    notifyListeners();
  }

  void addExpenses(List<dynamic> groupExpenses) {
    if (groupExpenses.length > 0) {
      for (var groupExpensesJSON in groupExpenses) {
        final newExpense = Expense(
            position: groupExpensesJSON['position'].toString(),
            name: groupExpensesJSON['expense_name'].toString(),
            amount: groupExpensesJSON['amount'].toString());
        _expenses.add(newExpense);
      }
    }
    notifyListeners();
  }

  void addFineTypes(List<dynamic> groupFineTypes) {
    if (groupFineTypes.length > 0) {
      for (var groupFineTypesJSON in groupFineTypes) {
        final newFineType = FineType(
            id: groupFineTypesJSON['id'].toString(),
            name: groupFineTypesJSON['name'].toString(),
            amount: groupFineTypesJSON['amount'].toString(),
            balance: groupFineTypesJSON['balance'].toString());
        _fineTypes.add(newFineType);
      }
    }
    notifyListeners();
  }

  void addLoanTypes(List<dynamic> groupLoanTypes) {
    if (groupLoanTypes.length > 0) {
      for (var groupLoanTypesJSON in groupLoanTypes) {
        final newLoanType = LoanType(
          id: groupLoanTypesJSON['id']..toString,
          name: groupLoanTypesJSON['name']..toString,
          repaymentPeriod: groupLoanTypesJSON['repayment_period']..toString,
          loanAmount: groupLoanTypesJSON['loan_amount']..toString,
          interestRate: groupLoanTypesJSON['interest_rate']..toString,
          loanProcessing: groupLoanTypesJSON['loan_processing']..toString,
          disbursementDate: groupLoanTypesJSON['disbursement_date']..toString,
          guarantors: groupLoanTypesJSON['guarantors']..toString,
          latePaymentFines: groupLoanTypesJSON['late_payment_fines']..toString,
          outstandingPaymentFines: groupLoanTypesJSON['outstanding_payment_fines']..toString,
          isHidden: groupLoanTypesJSON['is_hidden']..toString,
        );
        _loanTypes.add(newLoanType);
      }
    }
    notifyListeners();
  }

  void addMembers(List<dynamic> groupMembers) {
    if (groupMembers.length > 0) {
      for (var groupMembersJSON in groupMembers) {
        final newMember = Member(
            id: groupMembersJSON['id'].toString(),
            name: groupMembersJSON['name'].toString(),
            userId: groupMembersJSON['user_id'].toString(),
            identity: groupMembersJSON['identity'].toString(),
            avatar: groupMembersJSON['avatar'].toString());
        _members.add(newMember);
      }
    }
    notifyListeners();
  }


  void addAccountBalances(dynamic data) {
    _accountBalances = getAccountBalances(data);
    notifyListeners();
  }

  void addTransactionStatements(dynamic data) {
    _transactionStatement = getTransactionStatement(data);
    notifyListeners();
  }

  void addExpenseSummary(dynamic data) {
    _expenseSummaryList = getExpenseSummary(data);
    notifyListeners();
  }

  void addContributionSummary(List<dynamic> contributionSummaryList) {
    final List<GroupContributionSummary> contributionSummary = [];
    if (contributionSummaryList.length > 0) {
      for (var object in contributionSummaryList) {
        final newData = GroupContributionSummary(
            memberId: object['member_id'].toString(),
            memberName: object['name'].toString(),
            paidAmount: double.parse(object['paid'].toString()),
            balanceAmount: double.parse(object['arrears'].toString()));
        contributionSummary.add(newData);
      }
    }
    _groupcontributionSummary = contributionSummary;
    notifyListeners();
  }

  Future<void> fetchAndSetUserGroups() async {
    const url = EndpointUrl.GET_GROUPS;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final userGroups = response['user_groups'] as List<dynamic>;
        addGroups(userGroups);
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        throw CustomException(message: error.message);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      print("error ${error.toString()}");
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchAccounts() async {
    const url = EndpointUrl.GET_GROUP_ACCOUNT_OPTIONS;
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

  Future<void> fetchContributions() async {
    const url = EndpointUrl.GET_GROUP_CONTRIBUTIONS;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _contributions = []; //clear
        final groupContributions = response['contributions'] as List<dynamic>;
        addContributions(groupContributions);
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print(error.toString());
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchExpenses() async {
    const url = EndpointUrl.GET_EXPENSES_SUMMARY;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _expenses = []; //clear accounts
        final groupExpenses = response['data']['expenses'] as List<dynamic>;
        addExpenses(groupExpenses);
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print(error.toString());
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchFineTypes() async {
    const url = EndpointUrl.GET_GROUP_FINE_OPTIONS;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _fineTypes = []; //clear accounts
        final groupFineTypes = response['fine_category_options'] as List<dynamic>;
        addFineTypes(groupFineTypes);
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

  Future<void> fetchLoanTypes() async {
    const url = EndpointUrl.GET_GROUP_LOAN_TYPES;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _loanTypes = []; //clear
        final groupLoanTypes = response['loan_types'] as List<dynamic>;
        addLoanTypes(groupLoanTypes);
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

  Future<void> fetchMembers() async {
    const url = EndpointUrl.GET_GROUP_MEMBERS;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _members = []; //clear
        final groupMembers = response['members'] as List<dynamic>;
        addMembers(groupMembers);
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

  Future<void> fetchReportAccountBalances() async {
    const url = EndpointUrl.GET_ACCOUNT_BALANCES;

    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });

      try {
        final response = await PostToServer.post(postRequest, url);

        final data = response['data'] as dynamic;
        addAccountBalances(data);
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print(error);
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchTransactionStatement() async {
    const url = EndpointUrl.GET_TRANSACTION_STATEMENT;

    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final data = response['data'] as dynamic;
        addTransactionStatements(data);
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print(error);
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  /*************************Contributions Summary*****************************/

  Future<dynamic> getGroupContributionSummary() async {
    _groupcontributionSummary = [];
    notifyListeners();
    const url = EndpointUrl.GET_CONTRIBUTION_SUMMARY;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        try {
          final contributionBalances = response["balances"];
          addContributionSummary(contributionBalances);
        } catch (error) {
          throw CustomException(message: ERROR_MESSAGE);
        }
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

  /// ***********************Expense Summary*****************************
  Future<void> fetchExpenseSummary() async {
    const url = EndpointUrl.GET_EXPENSES_SUMMARY;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _expenses = []; //clear accounts
        final groupExpenses = response['data'] as dynamic;
        addExpenseSummary(groupExpenses);
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print(error.toString());
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }
}
