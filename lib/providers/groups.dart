import 'dart:convert';

import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/endpoint-url.dart';
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


class Contribution {
  final String id;
  final String name;

  Contribution({
    @required this.id,
    @required this.name,
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
  final String  id;
  final String  name;
  final String  description;
  final String  repayment_period_type;
  final String  interest_type;
  final String  interest_rate;
  final String  loan_interest_rate_per;
  final String  loan_repayment_period_type;
  final String  minimum_repayment_period;
  final String  maximum_repayment_period;
  final String  fixed_repayment_period;
  final String  enable_loan_guarantors;
  final String  minimum_guarantors;
  final String  enable_loan_fines;
  final String  loan_fine_type;
  final String  fixed_fine_amount;
  final String  fixed_amount_fine_frequency;
  final String  fixed_amount_fine_frequency_on;
  final String  percentage_fine_rate;
  final String  percentage_fine_frequency;
  final String  percentage_fine_on;
  final String  one_off_fine_type;
  final String  one_off_fixed_amount;
  final String  one_off_percentage_rate;
  final String  one_off_percentage_rate_on;
  final String  enable_outstanding_loan_balance_fines;
  final String  outstanding_loan_balance_fine_type;
  final String  outstanding_loan_balance_fine_fixed_amount;
  final String  outstanding_loan_balance_fixed_fine_frequency;
  final String  outstanding_loan_balance_percentage_fine_rate;
  final String  outstanding_loan_balance_percentage_fine_frequency;
  final String  outstanding_loan_balance_percentage_fine_on;
  final String  outstanding_loan_balance_fine_one_off_amount;
  final String  enable_loan_processing_fee;
  final String  loan_processing_fee_type;
  final String  loan_processing_fee_fixed_amount;
  final String  loan_processing_fee_percentage_rate;
  final String  loan_processing_fee_percentage_charged_on;
  final String  loan_guarantors_type;

  LoanType({
    this.id,
    this.name,
    this.description,
    this.repayment_period_type,
    this.interest_type,
    this.interest_rate,
    this.loan_interest_rate_per,
    this.loan_repayment_period_type,
    this.minimum_repayment_period,
    this.maximum_repayment_period,
    this.fixed_repayment_period,
    this.enable_loan_guarantors,
    this.minimum_guarantors,
    this.enable_loan_fines,
    this.loan_fine_type,
    this.fixed_fine_amount,
    this.fixed_amount_fine_frequency,
    this.fixed_amount_fine_frequency_on,
    this.percentage_fine_rate,
    this.percentage_fine_frequency,
    this.percentage_fine_on,
    this.one_off_fine_type,
    this.one_off_fixed_amount,
    this.one_off_percentage_rate,
    this.one_off_percentage_rate_on,
    this.enable_outstanding_loan_balance_fines,
    this.outstanding_loan_balance_fine_type,
    this.outstanding_loan_balance_fine_fixed_amount,
    this.outstanding_loan_balance_fixed_fine_frequency,
    this.outstanding_loan_balance_percentage_fine_rate,
    this.outstanding_loan_balance_percentage_fine_frequency,
    this.outstanding_loan_balance_percentage_fine_on,
    this.outstanding_loan_balance_fine_one_off_amount,
    this.enable_loan_processing_fee,
    this.loan_processing_fee_type,
    this.loan_processing_fee_fixed_amount,
    this.loan_processing_fee_percentage_rate,
    this.loan_processing_fee_percentage_charged_on,
    this.loan_guarantors_type,
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

class AccountBalance {
  String name, accountNumber, balance;
  bool isHeader;
  String header;

  AccountBalance.header({this.isHeader, this.header});

  AccountBalance({this.isHeader, this.name, this.accountNumber, this.balance});
}

class AccountBalances {
  List<AccountBalance> accounts;
  String totalBalance;

  AccountBalances({this.accounts, this.totalBalance});
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
  AccountBalances accountBalances;

  List<Group> get item {
    return [..._items];
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

  void addAccounts(List<dynamic> groupBankAccounts, int accountType) {
    final List<Account> bankAccounts = [];
    if (groupBankAccounts.length > 0) {
      for (var bankAccountJSON in groupBankAccounts) {
        final newAccount = Account(id: bankAccountJSON['id']..toString(), name: bankAccountJSON['name']..toString(), typeId: accountType);
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
        final newContribution = Contribution(id: groupContributionJSON['id']..toString(), name: groupContributionJSON['name']..toString());
        _contributions.add(newContribution);
      }
    }
    notifyListeners();
  }

  void addExpenses(List<dynamic> groupExpenses) {
    if (groupExpenses.length > 0) {
      for (var groupExpensesJSON in groupExpenses) {
        final newExpense = Expense(position: groupExpensesJSON['position']..toString(), name: groupExpensesJSON['name']..toString(), amount: groupExpensesJSON['amount']..toString());
        _expenses.add(newExpense);
      }
    }
    notifyListeners();
  }

  void addFineTypes(List<dynamic> groupFineTypes) {
    if (groupFineTypes.length > 0) {
      for (var groupFineTypesJSON in groupFineTypes) {
        final newFineType = FineType(id: groupFineTypesJSON['id']..toString(), name: groupFineTypesJSON['name']..toString(), amount: groupFineTypesJSON['amount']..toString(), balance: groupFineTypesJSON['balance']..toString());
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
          description: groupLoanTypesJSON['description']..toString,
          repayment_period_type: groupLoanTypesJSON['repayment_period_type']..toString,
          interest_type: groupLoanTypesJSON['interest_type']..toString,
          interest_rate: groupLoanTypesJSON['interest_rate']..toString,
          loan_interest_rate_per: groupLoanTypesJSON['loan_interest_rate_per']..toString,
          loan_repayment_period_type: groupLoanTypesJSON['loan_repayment_period_type']..toString,
          minimum_repayment_period: groupLoanTypesJSON['minimum_repayment_period']..toString,
          maximum_repayment_period: groupLoanTypesJSON['maximum_repayment_period']..toString,
          fixed_repayment_period: groupLoanTypesJSON['fixed_repayment_period']..toString,
          enable_loan_guarantors: groupLoanTypesJSON['enable_loan_guarantors']..toString,
          minimum_guarantors: groupLoanTypesJSON['minimum_guarantors']..toString,
          enable_loan_fines: groupLoanTypesJSON['enable_loan_fines']..toString,
          loan_fine_type: groupLoanTypesJSON['loan_fine_type']..toString,
          fixed_fine_amount: groupLoanTypesJSON['fixed_fine_amount']..toString,
          fixed_amount_fine_frequency: groupLoanTypesJSON['fixed_amount_fine_frequency']..toString,
          fixed_amount_fine_frequency_on: groupLoanTypesJSON['fixed_amount_fine_frequency_on']..toString,
          percentage_fine_rate: groupLoanTypesJSON['percentage_fine_rate']..toString,
          percentage_fine_frequency: groupLoanTypesJSON['percentage_fine_frequency']..toString,
          percentage_fine_on: groupLoanTypesJSON['percentage_fine_on']..toString,
          one_off_fine_type: groupLoanTypesJSON['one_off_fine_type']..toString,
          one_off_fixed_amount: groupLoanTypesJSON['one_off_fixed_amount']..toString,
          one_off_percentage_rate: groupLoanTypesJSON['one_off_percentage_rate']..toString,
          one_off_percentage_rate_on: groupLoanTypesJSON['one_off_percentage_rate_on']..toString,
          enable_outstanding_loan_balance_fines: groupLoanTypesJSON['enable_outstanding_loan_balance_fines']..toString,
          outstanding_loan_balance_fine_type: groupLoanTypesJSON['outstanding_loan_balance_fine_type']..toString,
          outstanding_loan_balance_fine_fixed_amount: groupLoanTypesJSON['outstanding_loan_balance_fine_fixed_amount']..toString,
          outstanding_loan_balance_fixed_fine_frequency: groupLoanTypesJSON['outstanding_loan_balance_fixed_fine_frequency']..toString,
          outstanding_loan_balance_percentage_fine_rate: groupLoanTypesJSON['outstanding_loan_balance_percentage_fine_rate']..toString,
          outstanding_loan_balance_percentage_fine_frequency: groupLoanTypesJSON['outstanding_loan_balance_percentage_fine_frequency']..toString,
          outstanding_loan_balance_percentage_fine_on: groupLoanTypesJSON['outstanding_loan_balance_percentage_fine_on']..toString,
          outstanding_loan_balance_fine_one_off_amount: groupLoanTypesJSON['outstanding_loan_balance_fine_one_off_amount']..toString,
          enable_loan_processing_fee: groupLoanTypesJSON['enable_loan_processing_fee']..toString,
          loan_processing_fee_type: groupLoanTypesJSON['loan_processing_fee_type']..toString,
          loan_processing_fee_fixed_amount: groupLoanTypesJSON['loan_processing_fee_fixed_amount']..toString,
          loan_processing_fee_percentage_rate: groupLoanTypesJSON['loan_processing_fee_percentage_rate']..toString,
          loan_processing_fee_percentage_charged_on: groupLoanTypesJSON['loan_processing_fee_percentage_charged_on']..toString,
          loan_guarantors_type: groupLoanTypesJSON['loan_guarantors_type']..toString,
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
            id: groupMembersJSON['id']..toString(),
            name: groupMembersJSON['name']..toString(),
            userId: groupMembersJSON['user_id']..toString(),
            identity: groupMembersJSON['identity']..toString(),
            avatar: groupMembersJSON['avatar']..toString());
        _members.add(newMember);
      }
    }
    notifyListeners();
  }

  void addGroups(List<dynamic> groupObject) {
    final List<Group> loadedGroups = [];
    if (groupObject.length > 0) {
      for (var groupJSON in groupObject) {
        final newGroup =
        Group(groupId: groupJSON['id']
          ..toString(), groupName: groupJSON['name']
          ..toString(), groupSize: groupJSON['size']
          ..toString());
        loadedGroups.add(newGroup);
      }
    }
    _items = loadedGroups;
    notifyListeners();
  }

  void addAccountBalances(dynamic data) {
    final balances = data['balances'] as List<dynamic>;
    final List<AccountBalance> bankAccounts = [];
    if (balances.length > 0) {
      for (var balance in balances) {
        final name = balance['category_name'].toString();
        bankAccounts.add(AccountBalance.header(isHeader: true, header: name));
        final accounts = balance['account_balances'] as List<dynamic>;
        for (var account in accounts) {
          final accountBalance =
          AccountBalance(isHeader: false, name: account['account_name'].toString(), accountNumber: '10010012123', balance: account['account_balance'].toString());
          bankAccounts.add(accountBalance);
        }
      }
    }
    String totalBalance = data['grand_total_balance'].toString();
    accountBalances = AccountBalances(accounts: bankAccounts, totalBalance: totalBalance);
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
    const url = EndpointUrl.GET_GROUP_CONTRIBUTIONS_OPTIONS;
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
        final groupExpenses = response['expenses'] as List<dynamic>;
        addExpenses(groupExpenses);
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
    const url = EndpointUrl.GET_GROUP_LOAN_TYPE_OPTIONS;
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
