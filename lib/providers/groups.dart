import 'dart:convert';
import 'dart:io' as io;

import 'package:chamasoft/providers/helpers/setting_helper.dart';
import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';
import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/screens/chamasoft/models/deposit.dart';
import 'package:chamasoft/screens/chamasoft/models/expense-category.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-summary-row.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/transaction-statement-model.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/endpoint-url.dart';
import 'package:chamasoft/utilities/post-to-server.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/report_helper.dart';

class Account {
  final String id;
  final String name;
  final int typeId;
  final int uniqueId;

  Account({
    @required this.id,
    @required this.name,
    @required this.typeId,
    @required this.uniqueId,
  });
}

class Country {
  final int id;
  final String name;

  Country({
    @required this.id,
    @required this.name,
  });
}

class Currency {
  final int id;
  final String name;

  Currency({
    @required this.id,
    @required this.name,
  });
}

class Bank {
  final int id;
  final String name;
  final String logo;

  Bank({
    @required this.id,
    @required this.name,
    this.logo,
  });
}

class BankBranch {
  final int id;
  final String name;

  BankBranch({
    @required this.id,
    @required this.name,
  });
}

class MobileMoneyProvider {
  final int id;
  final String name;
  final String logo;

  MobileMoneyProvider({
    @required this.id,
    @required this.name,
    this.logo,
  });
}

class Sacco {
  final int id;
  final String name;
  final String logo;

  Sacco({
    @required this.id,
    @required this.name,
    this.logo,
  });
}

class SaccoBranch {
  final int id;
  final String name;

  SaccoBranch({
    @required this.id,
    @required this.name,
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

class IncomeCategories {
  @required
  final String id;
  @required
  final String name;
  final String description;
  final bool ishidden;

  IncomeCategories({
    this.id,
    this.name,
    this.description,
    this.ishidden,
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

class Depositor {
  final String id;
  final String name;
  final String email;
  final String phone;

  Depositor({this.id, this.name, this.email, this.phone});
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

  List<Account> _accounts = [];
  List<Contribution> _contributions = [];
  List<Expense> _expenses = [];
  List<FineType> _fineTypes = [];
  List<IncomeCategories> _incomeCategories = [];
  List<LoanType> _loanTypes = [];
  List<Member> _members = [];
  List<Depositor> _depositors = [];
  List<List<Account>> _allAccounts = [];
  List<Country> _countryOptions = [];
  List<Currency> _currencyOptions = [];
  List<Bank> _bankOptions = [];
  List<BankBranch> _bankBranchOptions = [];
  List<MobileMoneyProvider> _mobileMoneyProviderOptions = [];
  List<Sacco> _saccoOptions = [];
  List<SaccoBranch> _saccoBranchOptions = [];

  AccountBalanceModel _accountBalances;
  TransactionStatementModel _transactionStatement;
  ExpenseSummaryList _expenseSummaryList;
  LoansSummaryList _loansSummaryList;
  ContributionStatementModel _contributionStatement;
  LoanStatementModel _loanStatements;
  List<GroupContributionSummary> _groupContributionSummary = [];
  List<GroupContributionSummary> _groupFinesSummary = [];
  List<Deposit> _depositList = [];
  List<Withdrawal> _withdrawalList = [];
  List<ActiveLoan> _memberLoanList = [];
  double _totalGroupContributionSummary = 0, _totalGroupFinesSummary = 0;
  List<CategorisedAccount> _categorisedAccounts = [];
  GroupRolesStatusAndCurrentMemberStatus
      _groupRolesStatusAndCurrentMemberStatus;

  String _userId;
  String _identity;
  List<Group> _groups = [];
  String _currentGroupId;

  Groups(List<Group> _groups, String _userId, String _identity,
      String _currentGroupId) {
    this._groups = _groups;
    this._userId = _userId;
    this._identity = _identity;
    this._currentGroupId = _currentGroupId;
    print(
        " currentGroupId $currentGroupId and length ${_groups.length} userid: $_userId and identity $_identity");
  }

  List<Group> get item {
    return _groups;
  }

  String get currentGroupId {
    return _currentGroupId;
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

  List<Country> get countryOptions {
    return _countryOptions;
  }

  List<Bank> get bankOptions {
    return _bankOptions;
  }

  List<BankBranch> get bankBranchOptions {
    return _bankBranchOptions;
  }

  List<MobileMoneyProvider> get mobileMoneyProviderOptions {
    return _mobileMoneyProviderOptions;
  }

  List<Sacco> get saccoOptions {
    return _saccoOptions;
  }

  List<SaccoBranch> get saccoBranchOptions {
    return _saccoBranchOptions;
  }

  List<Currency> get currencyOptions {
    return _currencyOptions;
  }

  List<List<Account>> get allAccounts {
    return _allAccounts;
  }

  AccountBalanceModel get accountBalances {
    return _accountBalances;
  }

  TransactionStatementModel get transactionStatement {
    return _transactionStatement;
  }

  ExpenseSummaryList get expenseSummaryList {
    return _expenseSummaryList;
  }

  List<GroupContributionSummary> get groupContributionSummary {
    return _groupContributionSummary;
  }

  List<GroupContributionSummary> get groupFinesSummary {
    return _groupFinesSummary;
  }

  LoansSummaryList get getLoansSummaryList {
    return _loansSummaryList;
  }

  ContributionStatementModel get getContributionStatements {
    return _contributionStatement;
  }

  List<ActiveLoan> get getMemberLoans {
    return _memberLoanList;
  }

  LoanStatementModel get getLoanStatements {
    return _loanStatements;
  }

  List<Deposit> get getDeposits {
    return _depositList;
  }

  List<Withdrawal> get getWithdrawals {
    return _withdrawalList;
  }

  double groupTotalContributionSummary() {
    return _totalGroupContributionSummary;
  }

  double groupTotalFinesSummary() {
    return _totalGroupFinesSummary;
  }

  List<CategorisedAccount> get getAllCategorisedAccounts {
    return _categorisedAccounts;
  }

  GroupRolesStatusAndCurrentMemberStatus
      get getGroupRolesAndCurrentMemberStatus {
    return _groupRolesStatusAndCurrentMemberStatus;
  }

  /// ********************Group Objects************/
  setSelectedGroupId(String groupId) async {
    _switchGroupValuesToDefault();
    _currentGroupId = groupId;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(selectedGroupId)) {
      prefs.remove(selectedGroupId);
    }
    prefs.setString(selectedGroupId, groupId);
  }

  void _switchGroupValuesToDefault() {
    _groupContributionSummary = [];
    _groupFinesSummary = [];
    _totalGroupFinesSummary = 0;
    _totalGroupContributionSummary = 0;
    _accounts = [];
    _members = [];
    _allAccounts = [];
    _contributions = [];
    _countryOptions = [];
    _currencyOptions = [];
    _bankOptions = [];
    _bankBranchOptions = [];
    _mobileMoneyProviderOptions = [];
    _saccoOptions = [];
    _saccoBranchOptions = [];
  }

  getCurrentGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedGroupId);
  }

  Group getCurrentGroup() {
    Group group;
    bool groupFound = false;
    _groups.forEach((element) {
      if (element.groupId == _currentGroupId) {
        group = element;
        groupFound = true;
      }
    });
    if (groupFound) {
      return group;
    } else {
      return this._groups[0];
    }
  }

  String getCurrentGroupDisplayAvatar() {
    final avatar = getCurrentGroup().avatar;

    var result = (avatar != null && avatar != 'null' && avatar != '')
        ? CustomHelper.imageUrl + avatar
        : null;
    return result;
  }

  Future<void> addGroups(List<dynamic> groupObject,
      [bool replace = false, int position = 0, bool isNewGroup = false]) async {
    final List<Group> loadedGroups = [];
    Group loadedNewGroup;
    if (groupObject.length > 0) {
      for (var groupJSON in groupObject) {
        var group = parseSingleGroup(groupJSON);
        final newGroup = group;

        loadedGroups.add(newGroup);
        loadedNewGroup = newGroup;
      }
    }
    if (replace) {
      _groups.removeAt(position);
      _groups.insert(position, loadedNewGroup);
    } else if (isNewGroup) {
      _groups.add(loadedNewGroup);
      setSelectedGroupId(loadedNewGroup.groupId);
    } else {
      _groups = loadedGroups;
    }
    print("Groups : ${_groups.length}");
    notifyListeners();
  }

  Future<void> updateGroupAvatar(io.File avatar) async {
    const url = EndpointUrl.EDIT_NEW_GROUP_PHOTO;
    try {
      final resizedImage = await CustomHelper.resizeFileImage(avatar, 300);
      try {
        final newAvatar = base64Encode(resizedImage.readAsBytesSync());
        final postRequest = json.encode({
          "avatar": newAvatar,
          "user_id": _userId,
          "group_id": _currentGroupId,
        });
        await PostToServer.post(postRequest, url);
        await updateGroupProfile();
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> updateGroupProfile() async {
    const url = EndpointUrl.GET_GROUP_DATA;
    final postRequest = json.encode({
      "user_id": _userId,
      "group_id": _currentGroupId,
    });
    try {
      final response = await PostToServer.post(postRequest, url);
      final group = response['user_groups'];
      if (group.length > 0) {
        int i = 0;
        int position = 0;
        _groups.forEach((groupItem) {
          if (groupItem.groupId == currentGroupId) {
            position = i;
          }
          ++i;
        });
        addGroups(group, true, position);
      }
      notifyListeners();
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  /// ********************End Group Objects************/

  int addAccounts(List<dynamic> groupBankAccounts, int accountType,
      [int position = 0]) {
    final List<Account> bankAccounts = [];
    if (groupBankAccounts.length > 0) {
      for (var bankAccountJSON in groupBankAccounts) {
        ++position;
        final newAccount = Account(
            id: bankAccountJSON['id'].toString(),
            name: bankAccountJSON['name'].toString(),
            uniqueId: position,
            typeId: accountType);
        bankAccounts.add(newAccount);
        _accounts.add(newAccount);
      }
    }
    _allAccounts.add(bankAccounts);
    notifyListeners();
    return position;
  }

  String _getAccountFormId(int position) {
    for (var accountOption in _allAccounts) {
      for (var account in accountOption) {
        if (position == account.uniqueId) {
          if (account.typeId == 1) {
            return "bank-${account.id}";
          } else if (account.typeId == 2) {
            return "sacco-${account.id}";
          } else if (account.typeId == 3) {
            return "mobile-${account.id}";
          } else {
            return "petty-${account.id}";
          }
        }
      }
    }
  }

  void addContributions(List<dynamic> groupContributions) {
    if (groupContributions.length > 0) {
      for (var groupContributionJSON in groupContributions) {
        final newContribution = Contribution(
          id: groupContributionJSON['id'].toString(),
          name: groupContributionJSON['name'].toString(),
          amount: groupContributionJSON['amount'].toString(),
          type: groupContributionJSON['type'].toString(),
          contributionType:
              groupContributionJSON['contribution_type'].toString(),
          frequency: groupContributionJSON['frequency'].toString(),
          invoiceDate: groupContributionJSON['invoice_date'].toString(),
          contributionDate:
              groupContributionJSON['contribution_date'].toString(),
          oneTimeContributionSetting:
              groupContributionJSON['one_time_contribution_setting'].toString(),
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

  void addIncomeCategoriesTypes(List<dynamic> incomeCategories) {
    if (incomeCategories.length > 0) {
      for (var incomeCategoryJson in incomeCategories) {
        final income = IncomeCategories(
          id: incomeCategoryJson['id'].toString(),
          name: incomeCategoryJson['name'].toString(),
          description: "",
          ishidden: false,
        );
        _incomeCategories.add(income);
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
          outstandingPaymentFines:
              groupLoanTypesJSON['outstanding_payment_fines']..toString,
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

  void addDepositors(List<dynamic> groupDepositors) {
    if (groupDepositors.length > 0) {
      for (var groupDepositorsJSON in groupDepositors) {
        final newDepositor = Depositor(
          id: groupDepositorsJSON['id'].toString(),
          name: groupDepositorsJSON['name'].toString(),
        );
        _depositors.add(newDepositor);
      }
    }
    notifyListeners();
  }

  void addUnAssignedRoles(dynamic data) {
    int memberStatus = data["member_has_role"];
    final Map<String, int> groupRoles = {};
    data["roles_status"].forEach((key, value) {
      groupRoles[key.toString()] = value;
    });
    _groupRolesStatusAndCurrentMemberStatus =
        GroupRolesStatusAndCurrentMemberStatus(
            currentMemberStatus: memberStatus, roleStatus: groupRoles);
    notifyListeners();
  }

  void addCountryOptions(List<dynamic> countries) {
    if (countries.length > 0) {
      for (var countryJSON in countries) {
        final newCountry = Country(
            id: countryJSON['id'].toInt(),
            name: countryJSON['name'].toString());
        _countryOptions.add(newCountry);
      }
    }
    notifyListeners();
  }

  void addCurrencyOptions(List<dynamic> currencies) {
    if (currencies.length > 0) {
      for (var currencyJSON in currencies) {
        final newCurrency = Currency(
            id: currencyJSON['id'].toInt(),
            name: currencyJSON['name'].toString());
        _currencyOptions.add(newCurrency);
      }
    }
    notifyListeners();
  }

  void addBankOptions(List<dynamic> banks) {
    if (banks.length > 0) {
      for (var bankJSON in banks) {
        final newBank = Bank(
            id: int.parse(bankJSON['id']),
            logo: bankJSON['logo'].toString(),
            name: bankJSON['name'].toString());
        _bankOptions.add(newBank);
      }
      notifyListeners();
    }
  }

  void addBankBranchOptions(List<dynamic> bankBranches) {
    if (bankBranches.length > 0) {
      for (var bankBranchJSON in bankBranches) {
        final newBankBranch = BankBranch(
            id: bankBranchJSON['id'], name: bankBranchJSON['name'].toString());
        _bankBranchOptions.add(newBankBranch);
      }
      notifyListeners();
    }
  }

  void addMobileMoneyProviderOptions(List<dynamic> mobileMoneyProviderOptions) {
    if (mobileMoneyProviderOptions.length > 0) {
      for (var mobileMoneyProviderJSON in mobileMoneyProviderOptions) {
        final newMobileMoneyProviderJSON = MobileMoneyProvider(
            id: int.parse(mobileMoneyProviderJSON['id']),
            logo: mobileMoneyProviderJSON['logo'].toString(),
            name: mobileMoneyProviderJSON['name'].toString());
        _mobileMoneyProviderOptions.add(newMobileMoneyProviderJSON);
        notifyListeners();
      }
    }
  }

  void addSaccoOptions(List<dynamic> saccos) {
    if (saccos.length > 0) {
      for (var saccoJSON in saccos) {
        final newSacco = Sacco(
            id: int.parse(saccoJSON['id']),
            logo: saccoJSON['logo'].toString(),
            name: saccoJSON['name'].toString());
        _saccoOptions.add(newSacco);
        notifyListeners();
      }
    }
  }

  void addSaccoBranchOptions(List<dynamic> saccoBranches) {
    if (saccoBranches.length > 0) {
      for (var saccoBranchJSON in saccoBranches) {
        final newSaccoBranch = SaccoBranch(
            id: int.parse(saccoBranchJSON['id']),
            name: saccoBranchJSON['name'].toString());
        _saccoBranchOptions.add(newSaccoBranch);
        notifyListeners();
      }
    }
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

  void addLoansSummary(dynamic data) {
    _loansSummaryList = getLoanSummaryList(data);
    notifyListeners();
  }

  void addContributionStatement(dynamic data) {
    _contributionStatement = getContributionStatement(data);
    notifyListeners();
  }

  void addMemberLoans(List<dynamic> data) {
    _memberLoanList = getMemberLoanList(data);
    notifyListeners();
  }

  void addLoanStatements(dynamic data) {
    _loanStatements = getLoanStatementModel(data);
    notifyListeners();
  }

  void addDepositList(List<dynamic> data) {
    _depositList = getDepositList(data);
    notifyListeners();
  }

  void addWithdrawalList(List<dynamic> data) {
    _withdrawalList = getWithdrawalList(data);
    notifyListeners();
  }

  void addCategorisedAccounts(dynamic data) {
    _categorisedAccounts = getCategorisedAccounts(data);
    notifyListeners();
  }

  void addContributionSummary(List<dynamic> contributionSummaryList) {
    final List<GroupContributionSummary> contributionSummary = [];
    double total = 0.0;
    if (contributionSummaryList.length > 0) {
      for (var object in contributionSummaryList) {
        double amountpaid = double.tryParse(object['paid'].toString()) ?? 0.0;
        final newData = GroupContributionSummary(
                memberId: object['member_id'].toString(),
                memberName: object['name'].toString(),
                paidAmount: amountpaid,
                balanceAmount: double.tryParse(object['arrears'].toString())) ??
            0.0;
        contributionSummary.add(newData);
        total += amountpaid;
      }
    }
    _totalGroupContributionSummary = total;
    _groupContributionSummary = contributionSummary;
    notifyListeners();
  }

  void addFinesSummary(List<dynamic> finesSummaryList) {
    final List<GroupContributionSummary> finesSummary = [];
    double total = 0;
    if (finesSummaryList.length > 0) {
      for (var object in finesSummaryList) {
        double amountpaid = double.tryParse(object['paid'].toString()) ?? 0.0;
        final newData = GroupContributionSummary(
                memberId: object['member_id'].toString(),
                memberName: object['name'].toString(),
                paidAmount: amountpaid,
                balanceAmount: double.tryParse(object['arrears'].toString())) ??
            0.0;
        finesSummary.add(newData);
        total += amountpaid;
      }
    }
    _totalGroupFinesSummary = total;
    _groupFinesSummary = finesSummary;
    notifyListeners();
  }

  Future<void> fetchAndSetUserGroups() async {
    const url = EndpointUrl.GET_GROUPS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
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
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> createGroup(
      {String groupName, int countryId, dynamic avatar}) async {
    const url = EndpointUrl.CREATE_GROUP;

    try {
      String newAvatar;
      if (avatar != null) {
        print("Avatar available");
        final resizedImage = await CustomHelper.resizeFileImage(avatar, 300);
        newAvatar = base64Encode(resizedImage.readAsBytesSync());
      }

      final postRequest = json.encode({
        "user_id": _userId,
        "group_name": groupName,
        "country_id": countryId,
        "avatar": newAvatar
      });
      print("Request: $postRequest");
      try {
        final response = await PostToServer.post(postRequest, url);
        final userGroups = response["user_groups"] as List<dynamic>;
        addGroups(userGroups, false, 0, true);
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        throw CustomException(message: error.message);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchAccounts() async {
    const url = EndpointUrl.GET_GROUP_ACCOUNT_OPTIONS;
    int position = 0;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _accounts = []; //clear accounts

        _allAccounts = []; //clear all accounts
        final groupBankAccounts =
            response['accounts']['bank_accounts'] as List<dynamic>;
        position = addAccounts(groupBankAccounts, 1, position);
        final groupSaccoAccounts =
            response['accounts']['sacco_accounts'] as List<dynamic>;
        position = addAccounts(groupSaccoAccounts, 2, position);
        final groupMobileMoneyAccounts =
            response['accounts']['mobile_money_accounts'] as List<dynamic>;
        position = addAccounts(groupMobileMoneyAccounts, 3, position);
        final groupPettyCashAccountsAccounts =
            response['accounts']['petty_cash_accounts'] as List<dynamic>;
        position = addAccounts(groupPettyCashAccountsAccounts, 4, position);
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

  Future<dynamic> fetchBankAccount(int bankAccountId) async {
    const url = EndpointUrl.GET_BANK_ACCOUNTS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final groupBankAccounts = response['banks'] as List<dynamic>;
        for (int i = 0; i < groupBankAccounts.length; i++) {
          if (groupBankAccounts[i]['id'].toString() ==
              bankAccountId.toString()) {
            return groupBankAccounts[i];
          }
        }
        return null;
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print(error.message);
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<dynamic> fetchSaccoAccount(int saccoAccountId) async {
    const url = EndpointUrl.GET_SACCO_ACCOUNTS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final groupSaccoAccounts = response['saccos'] as List<dynamic>;
        for (int i = 0; i < groupSaccoAccounts.length; i++) {
          if (groupSaccoAccounts[i]['id'].toString() ==
              saccoAccountId.toString()) {
            return groupSaccoAccounts[i];
          }
        }
        return null;
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print(error.message);
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<dynamic> fetchMobileMoneyAccount(int mobileMoneyAccountId) async {
    const url = EndpointUrl.GET_MOBILE_MONEY_ACCOUNTS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final groupMobileMoneyAccounts =
            response['mobile_money_accounts'] as List<dynamic>;
        for (int i = 0; i < groupMobileMoneyAccounts.length; i++) {
          if (groupMobileMoneyAccounts[i]['id'].toString() ==
              mobileMoneyAccountId.toString()) {
            return groupMobileMoneyAccounts[i];
          }
        }
        return null;
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print(error.message);
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<dynamic> fetchPettyCashAccount(int pettyCashAccountId) async {
    const url = EndpointUrl.GET_PETTY_CASH_ACCOUNTS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final groupPettyCashAccounts =
            response['petty_accounts'] as List<dynamic>;
        for (int i = 0; i < groupPettyCashAccounts.length; i++) {
          if (groupPettyCashAccounts[i]['id'].toString() ==
              pettyCashAccountId.toString()) {
            return groupPettyCashAccounts[i];
          }
        }
        return null;
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print(error.message);
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
        "user_id": _userId,
        "group_id": _currentGroupId,
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
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _expenses = []; //clear accounts
        final groupExpenses = response['data']['expenses'] as List<dynamic>;
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
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _fineTypes = []; //clear accounts
        final groupFineTypes =
            response['fine_category_options'] as List<dynamic>;
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

  Future<void> fetchIncomeCategories() async {
    const url = EndpointUrl.GET_GROUP_INCOME_CATEGORIES;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        print(response);
        _incomeCategories = []; //clear accounts
        final incomeCategoriesTypes =
            response['income_categories'] as List<dynamic>;
        addIncomeCategoriesTypes(incomeCategoriesTypes);
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
        "user_id": _userId,
        "group_id": _currentGroupId,
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
        "user_id": _userId,
        "group_id": _currentGroupId,
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

  Future<void> fetchGroupDepositors() async {
    const url = EndpointUrl.GET_GROUP_DEPOSITOR_OPTIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _depositors = []; //clear
        final groupDepositors = response['depositors'] as List<dynamic>;
        addDepositors(groupDepositors);
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

  Future<void> fetchUnAssignedGroupRoles() async {
    const url = EndpointUrl.GET_GROUP_UNASSIGNED_ROLES;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        addUnAssignedRoles(response);
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

  Future<void> addGroupMembers(List<Map<String, String>> members) async {
    const url = EndpointUrl.ADD_MEMBERS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "members": members
      });

      print("PostRequest: " + postRequest);
      try {
        final response = await PostToServer.post(postRequest, url);
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

  Future<void> fetchCountryOptions() async {
    const url = EndpointUrl.GET_COUNTRY_LIST;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _countryOptions = []; //clear
        final countries = response['countries'] as List<dynamic>;
        addCountryOptions(countries);
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

  Future<void> fetchCurrencyOptions() async {
    const url = EndpointUrl.GET_CURRENCY_LIST;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _currencyOptions = []; //clear
        final currencies = response['currencies'] as List<dynamic>;
        addCurrencyOptions(currencies);
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

  Future<dynamic> updateGroupName(String name) async {
    const url = EndpointUrl.UPDATE_GROUP_NAME;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "name": name,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        if (response['status'] == 1) {
          await updateGroupProfile();
        }
        return response;
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

  Future<dynamic> updateGroupEmail(String email) async {
    const url = EndpointUrl.UPDATE_GROUP_EMAIL;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "email": email,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        if (response['status'] == 1) {
          await updateGroupProfile();
        }
        return response;
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

  Future<dynamic> updateGroupPhoneNumber(String phone) async {
    const url = EndpointUrl.UPDATE_GROUP_PHONE_NUMBER;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "phone": phone,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        if (response['status'] == 1) {
          await updateGroupProfile();
        }
        return response;
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

  Future<dynamic> updateGroupCountry(int countryId) async {
    const url = EndpointUrl.UPDATE_GROUP_COUNTRY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "country_id": countryId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        //final name = response['name'];
        //final countryId = response['country_id'];
        if (response['status'] == 1) {
          await updateGroupProfile();
        }
        return response;
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

  Future<dynamic> updateGroupCurrency(int currencyId) async {
    const url = EndpointUrl.UPDATE_GROUP_CURRENCY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "currency_id": currencyId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        //final currencyId = response['currencyId'];
        //final currency = response['currency'];
        if (response['status'] == 1) {
          await updateGroupProfile();
        }
        return response;
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

  Future<void> updateGroupSettings({
    String orderMembersBy,
    String memberListingOrderBy,
    String enableMemberInformationPrivacy,
    String disableIgnoreContributionTransfers,
    String disableArrears,
    String enableSendMonthlyEmailStatements,
    String disableMemberEditProfile,
    String enableAbsoluteLoanRecalculation,
  }) async {
    const url = EndpointUrl.UPDATE_GROUP_SETTINGS;

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "order_members_by": orderMembersBy,
        "member_listing_order_by": memberListingOrderBy,
        "enable_member_information_privacy": enableMemberInformationPrivacy,
        "disable_ignore_contribution_transfers":
            disableIgnoreContributionTransfers,
        "disable_arrears": disableArrears,
        "enable_send_monthly_email_statements":
            enableSendMonthlyEmailStatements,
        "disable_member_edit_profile": disableMemberEditProfile,
        "enable_absolute_loan_recalculation": enableAbsoluteLoanRecalculation,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        if (response['status'] == 1) {
          await updateGroupProfile();
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

  Future<void> fetchBankOptions() async {
    const url = EndpointUrl.GET_BANKS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _bankOptions = []; //clear
        final banks = response['banks'] as List<dynamic>;
        addBankOptions(banks);
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

  Future<void> fetchBankBranchOptions(String bankId) async {
    const url = EndpointUrl.GET_BANK_BRANCHES;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "bank_id": bankId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _bankBranchOptions = []; //clear
        final bankBranches = response['bank_branches'] as List<dynamic>;
        addBankBranchOptions(bankBranches);
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

  Future<void> fetchMobileMoneyProviderOptions() async {
    const url = EndpointUrl.GE_MOBILE_PROVIDERS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _mobileMoneyProviderOptions = []; //clear
        final mobileMoneyProviderOptions =
            response['mobile_money_providers'] as List<dynamic>;
        addMobileMoneyProviderOptions(mobileMoneyProviderOptions);
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

  Future<void> fetchSaccoOptions() async {
    const url = EndpointUrl.GET_SACCOS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _saccoOptions = []; //clear
        final saccoOptions = response['saccos'] as List<dynamic>;
        addSaccoOptions(saccoOptions);
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

  Future<void> fetchSaccoBranchOptions(String saccoId) async {
    const url = EndpointUrl.GET_SACCO_BRANCHES;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "sacco_id": saccoId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _saccoBranchOptions = []; //clear
        final saccoBranchOptions = response['sacco_branches'] as List<dynamic>;
        addSaccoBranchOptions(saccoBranchOptions);
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

  Future<void> createBankAccount({
    String accountName,
    String accountNumber,
    String bankBranchId,
    String bankId,
    String initialBalance,
  }) async {
    const url = EndpointUrl.ADD_BANK_ACCOUNT;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "account_name": accountName,
        "account_number": accountNumber,
        "bank_branch_id": bankBranchId,
        "bank_id": bankId,
        "initial_balance": initialBalance
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchAccounts();
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

  Future<void> editBankAccount({
    String id,
    String accountName,
    String accountNumber,
    String bankBranchId,
    String bankId,
    String initialBalance,
  }) async {
    const url = EndpointUrl.EDIT_BANK_ACCOUNT;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": id,
        "account_name": accountName,
        "account_number": accountNumber,
        "bank_branch_id": bankBranchId,
        "bank_id": bankId,
        "initial_balance": initialBalance
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchAccounts();
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

  Future<void> createSaccoAccount({
    String accountType,
    String accountName,
    String accountNumber,
    String saccoBranchId,
    String saccoId,
    String initialBalance,
  }) async {
    const url = EndpointUrl.ADD_SACCO_ACCOUNT;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "type": accountType,
        "account_name": accountName,
        "account_number": accountNumber,
        "sacco_branch_id": saccoBranchId,
        "sacco_id": saccoId,
        "initial_balance": initialBalance
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchAccounts();
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

  Future<void> editSaccoAccount({
    String id,
    String accountType,
    String accountName,
    String accountNumber,
    String saccoBranchId,
    String saccoId,
    String initialBalance,
  }) async {
    const url = EndpointUrl.EDIT_SACCO_ACCOUNT;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": id,
        "type": accountType,
        "account_name": accountName,
        "account_number": accountNumber,
        "sacco_branch_id": saccoBranchId,
        "sacco_id": saccoId,
        "initial_balance": initialBalance
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchAccounts();
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

  Future<void> createMobileMoneyAccount({
    String accountName,
    String accountNumber,
    String bankBranchId,
    String bankId,
    String initialBalance,
    String mobileMoneyProviderId,
  }) async {
    const url = EndpointUrl.ADD_MOBILE_MONEY_ACCOUNT;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": "",
        "account_name": accountName,
        "account_number": accountNumber,
        "mobile_money_provider_id": mobileMoneyProviderId,
        "initial_balance": initialBalance
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchAccounts();
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

  Future<void> editMobileMoneyAccount({
    String id,
    String accountName,
    String accountNumber,
    String bankBranchId,
    String bankId,
    String initialBalance,
    String mobileMoneyProviderId,
  }) async {
    const url = EndpointUrl.EDIT_MOBILE_MONEY_ACCOUNT;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": id,
        "account_name": accountName,
        "account_number": accountNumber,
        "mobile_money_provider_id": mobileMoneyProviderId,
        "initial_balance": initialBalance
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchAccounts();
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

  Future<void> createPettyCashAccount({
    String accountName,
  }) async {
    const url = EndpointUrl.ADD_PETTY_CASH_ACCOUNT;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": "",
        "account_name": accountName,
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchAccounts();
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

  Future<void> editPettyCashAccount({
    String id,
    String accountName,
  }) async {
    const url = EndpointUrl.EDIT_PETTY_CASH_ACCOUNT;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": id,
        "account_name": accountName,
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchAccounts();
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

  Future<void> createContributionSetting(
      {String name,
      String amount,
      String oneTimeInvoicingActive,
      String accountType,
      String regularInvoicingActive,
      String weekNumberFortnight,
      String weekDayMultiple,
      String weekDayFortninght,
      String weekDayWeekly,
      String weekDayMonthly,
      String monthDayMonthly,
      String invoiceDays,
      String contributionFrequency,
      String contributionDate,
      String invoiceDate}) async {
    const url = EndpointUrl.CREATE_CONTRIBUTION_SETTING;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "request_id": "1558508602_13678_0712234345",
        "amount": amount,
        "start_month_multiple": 0,
        "month_day_multiple": 10,
        "name": name,
        "one_time_invoicing_active": oneTimeInvoicingActive,
        "type": accountType,
        "regular_invoicing_active": regularInvoicingActive,
        "week_number_fortnight": weekNumberFortnight,
        "week_day_multiple": weekDayMultiple,
        "week_day_fortnight": weekDayFortninght,
        "week_day_weekly": weekDayWeekly,
        "week_day_monthly": weekDayMonthly,
        "month_day_monthly": monthDayMonthly,
        "invoice_days": invoiceDays,
        "contribution_frequency": contributionFrequency,
        "contribution_date": contributionDate,
        "invoice_date": invoiceDate
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchContributions();
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

  Future<void> editContributionSetting(
      {String id,
      String name,
      String amount,
      String oneTimeInvoicingActive,
      String accountType,
      String regularInvoicingActive,
      String weekNumberFortnight,
      String weekDayMultiple,
      String weekDayFortninght,
      String weekDayWeekly,
      String weekDayMonthly,
      String monthDayMonthly,
      String invoiceDays,
      String contributionFrequency,
      String contributionDate,
      String invoiceDate}) async {
    const url = EndpointUrl.EDIT_CONTRIBUTION_SETTING;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": id,
        "request_id": "1558508602_13678_0712234345",
        "amount": amount,
        "start_month_multiple": 0,
        "month_day_multiple": 10,
        "name": name,
        "one_time_invoicing_active": oneTimeInvoicingActive,
        "type": accountType,
        "regular_invoicing_active": regularInvoicingActive,
        "week_number_fortnight": weekNumberFortnight,
        "week_day_multiple": weekDayMultiple,
        "week_day_fortnight": weekDayFortninght,
        "week_day_weekly": weekDayWeekly,
        "week_day_monthly": weekDayMonthly,
        "month_day_monthly": monthDayMonthly,
        "invoice_days": invoiceDays,
        "contribution_frequency": contributionFrequency,
        "contribution_date": contributionDate,
        "invoice_date": invoiceDate
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchContributions();
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
        "user_id": _userId,
        "group_id": _currentGroupId,
      });

      try {
        final response = await PostToServer.post(postRequest, url);

        final data = response['data'] as dynamic;
        addAccountBalances(data);
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

  Future<void> fetchTransactionStatement() async {
    const url = EndpointUrl.GET_TRANSACTION_STATEMENT;

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final data = response['data'] as dynamic;
        addTransactionStatements(data);
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

  /*************************Contributions Summary and Fines Summary*****************************/

  Future<dynamic> getGroupContributionSummary() async {
    const url = EndpointUrl.GET_CONTRIBUTION_SUMMARY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        try {
          final contributionBalances = response["balances"];
          try {
            addContributionSummary(contributionBalances);
          } catch (error) {
            throw CustomException(message: ERROR_MESSAGE);
          }
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

  Future<dynamic> getGroupFinesSummary() async {
    const url = EndpointUrl.GET_FINE_SUMMARY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        try {
          final fineBalances = response["balances"];
          addFinesSummary(fineBalances);
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
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _expenses = []; //clear accounts
        final groupExpenses = response['data'] as dynamic;
        addExpenseSummary(groupExpenses);
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

  /// ***********************Loans Summary*****************************
  Future<void> fetchLoansSummary() async {
    const url = EndpointUrl.GET_LOANS_SUMMARY;

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final data = response['data'] as dynamic;
        addLoansSummary(data);
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

  /// ***********************Contribution Statement*****************************
  Future<void> fetchContributionStatement(int statementFlag) async {
    String url = EndpointUrl.GET_CONTRIBUTION_STATEMENT;
    if (statementFlag == FINE_STATEMENT) {
      url = EndpointUrl.GET_FINE_STATEMENT;
    }

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        addContributionStatement(response);
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

  /// ***********************Member Loans*****************************
  Future<void> fetchMemberLoans() async {
    const url = EndpointUrl.GET_GROUP_LOAN_LIST;

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "is_member_loans": 1
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final loans = response['loans'] as List<dynamic>;
        addMemberLoans(loans);
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

  /// ***********************Member Loan Statement*****************************/
  Future<void> fetchLoanStatement(int loanId) async {
    const url = EndpointUrl.GET_LOAN_STATEMENT;

    try {
      final postRequest = json.encode(
          {"user_id": _userId, "group_id": _currentGroupId, "id": loanId});

      try {
        final response = await PostToServer.post(postRequest, url);
        final data = response['data'] as dynamic;
        addLoanStatements(data);
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

  Future<void> fetchDeposits() async {
    const url = EndpointUrl.GET_DEPOSITS_LIST;

    try {
      final postRequest =
          json.encode({"user_id": _userId, "group_id": _currentGroupId});

      try {
        final response = await PostToServer.post(postRequest, url);
        final data = response['deposits'] as List<dynamic>;
        addDepositList(data);
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

  Future<void> fetchWithdrawals() async {
    const url = EndpointUrl.GET_GROUP_WITHDRAWAL_LIST;

    try {
      final postRequest =
          json.encode({"user_id": _userId, "group_id": _currentGroupId});

      try {
        final response = await PostToServer.post(postRequest, url);
        final data = response['withdrawals'] as List<dynamic>;
        addWithdrawalList(data);
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

  /// ********************TODO: consolidate with fetchAccounts()********************/
  Future<void> temporaryFetchAccounts() async {
    const url = EndpointUrl.GET_GROUP_ACCOUNT_OPTIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final accounts = response['accounts'] as dynamic;
        addCategorisedAccounts(accounts);
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

  /************************Load Form initial Data**********/

  Future<Map<String, dynamic>> loadInitialFormData({
    bool contr = false,
    bool acc = false,
    bool member = false,
    bool fineOptions = false,
    bool incomeCats = false,
    bool depositor = false,
  }) async {
    List<NamesListItem> contributionOptions = [],
        accountOptions = [],
        memberOptions = [],
        finesOptions = [],
        depositorOptions = [],
        incomeCategoryOptions = [];

    if (contr) {
      if (_contributions.length == 0) {
        await fetchContributions();
      }
      _contributions
          .map((element) => contributionOptions.add(
              NamesListItem(id: int.tryParse(element.id), name: element.name)))
          .toList();
    }
    if (acc) {
      if (_allAccounts.length == 0) {
        await fetchAccounts();
      }
      for (var account in _allAccounts) {
        for (var typeAccount in account) {
          accountOptions.add(
              NamesListItem(id: typeAccount.uniqueId, name: typeAccount.name));
        }
      }
    }
    if (member) {
      if (_members.length == 0) {
        await fetchMembers();
      }

      _members
          .map((member) => memberOptions.add(
              NamesListItem(id: int.tryParse(member.id), name: member.name)))
          .toList();
    }

    if (fineOptions) {
      if (_fineTypes.length == 0) {
        await fetchFineTypes();
      }
      _fineTypes
          .map((fine) => finesOptions
              .add(NamesListItem(id: int.tryParse(fine.id), name: fine.name)))
          .toList();
    }

    if (incomeCats) {
      if (_incomeCategories.length == 0) {
        await fetchIncomeCategories();
      }
      _incomeCategories
          .map((income) => incomeCategoryOptions.add(
              NamesListItem(id: int.tryParse(income.id), name: income.name)))
          .toList();
    }

    if (depositor) {
      if (_depositors.length == 0) {
        await fetchGroupDepositors();
      }
      _depositors
          .map((depositor) => depositorOptions.add(NamesListItem(
              id: int.tryParse(depositor.id), name: "${depositor.name}")))
          .toList();
    }

    Map<String, dynamic> result = {
      "contributionOptions": contributionOptions,
      "accountOptions": accountOptions,
      "memberOptions": memberOptions,
      "finesOptions": finesOptions,
      "incomeCategoryOptions": incomeCategoryOptions,
      "depositorOptions": depositorOptions,
    };
    return result;
  }

  /****************************Transaction****************/

  Future<void> recordContibutionPayments(Map<String, dynamic> formData) async {
    try {
      const url = EndpointUrl.NEW_RECORD_CONTRIBUTION_PAYMENTS;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = _getAccountFormId(formData['account_id']);

      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
        final postRequest = json.encode(formData);
        print(postRequest);
        await PostToServer.post(postRequest, url);
      } on CustomException catch (error) {
        throw CustomException(message: error.toString(), status: error.status);
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> recordFinePayments(Map<String, dynamic> formData) async {
    try {
      const url = EndpointUrl.NEW_RECORD_FINE_PAYMENTS;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = _getAccountFormId(formData['account_id']);
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
        print(formData);
        final postRequest = json.encode(formData);
        await PostToServer.post(postRequest, url);
      } on CustomException catch (error) {
        throw CustomException(message: error.toString(), status: error.status);
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> recordIncomePayment(Map<String, dynamic> formData) async {
    try {
      const url = EndpointUrl.RECORD_INCOME;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = _getAccountFormId(formData['account_id']);
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        print(postRequest);
        await PostToServer.post(postRequest, url);
      } on CustomException catch (error) {
        throw CustomException(message: error.toString(), status: error.status);
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> recordMiscellaneousPayments(Map<String, dynamic> formData)async{
    try {
      const url = EndpointUrl.RECORD_MISCELLANEOUS_PAYMENTS;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = _getAccountFormId(formData['account_id']);
      formData['request_id'] ="${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        print(postRequest);
        await PostToServer.post(postRequest, url);
      } on CustomException catch (error) {
        throw CustomException(message: error.toString(), status: error.status);
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void>recordBankLoanIncome(Map<String, dynamic> formData)async{
    try {
      const url = EndpointUrl.RECORD_BANK_LOAN;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = _getAccountFormId(formData['account_id']);
      formData['request_id'] ="${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        print(postRequest);
        await PostToServer.post(postRequest, url);
      } on CustomException catch (error) {
        throw CustomException(message: error.toString(), status: error.status);
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }
}
