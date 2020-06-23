import 'dart:convert';
import 'dart:io' as io;

import 'package:chamasoft/screens/chamasoft/models/account-balance.dart';
import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/screens/chamasoft/models/expense-category.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-summary-row.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/transaction-statement-model.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/endpoint-url.dart';
import 'package:chamasoft/utilities/post-to-server.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';
import 'helpers/report_helper.dart';

class Group {
  final String groupId;
  final String groupName;
  final String groupSize;
  final String groupCountryId;
  final String groupCurrencyId;
  final String groupPhone;
  final String groupEmail;
  final String groupCountryName;
  final String groupCurrencyName;
  final String avatar;
  final List<GroupRoles> groupRoles;
  final String smsBalance, accountNumber;
  final bool onlineBankingEnabled,
      enableMemberInformationPrivacy,
      disableArrears,
      enableAbsoluteLoanRecalculation,
      disableMemberEditProfile,
      disableIgnoreContributionTransfers;
  final String memberListingOrderBy, orderMembersBy;
  final bool enableSendMonthlyEmailStatements;
  final String groupRoleId;
  final String groupRole;
  final bool isGroupAdmin;
  final String groupCurrency;

  Group({
    @required this.groupId,
    @required this.groupName,
    @required this.groupSize,
    @required this.groupCountryId,
    @required this.smsBalance,
    this.memberListingOrderBy,
    @required this.accountNumber,
    this.enableMemberInformationPrivacy,
    this.enableSendMonthlyEmailStatements,
    this.disableArrears,
    this.disableMemberEditProfile,
    this.enableAbsoluteLoanRecalculation,
    this.disableIgnoreContributionTransfers,
    @required this.onlineBankingEnabled,
    this.orderMembersBy,
    @required this.groupRoles,
    @required this.groupRoleId,
    @required this.groupRole,
    @required this.isGroupAdmin,
    @required this.groupCurrency,
    this.groupCurrencyId,
    this.groupPhone,
    this.groupEmail,
    this.groupCountryName,
    this.groupCurrencyName,
    this.avatar,
  });
}

class GroupRoles {
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

  List<Group> _groups = [];
  List<Account> _accounts = [];
  List<Contribution> _contributions = [];
  List<Expense> _expenses = [];
  List<FineType> _fineTypes = [];
  List<LoanType> _loanTypes = [];
  List<Member> _members = [];
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
  List<ActiveLoan> _memberLoanList = [];

  List<Group> get item {
    return _groups;
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
    _groups.forEach((element) {
      if (element.groupId == currentGroupId) {
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
    var result = (avatar != null || avatar == "")
        ? CustomHelper.imageUrl + avatar
        : null;
    return result;
  }

  void addGroups(List<dynamic> groupObject,
      [bool replace = false, int position = 0]) {
    final List<Group> loadedGroups = [];
    Group loadedNewGroup;

    if (groupObject.length > 0) {
      for (var groupJSON in groupObject) {
        var groupRoles = groupJSON["group_roles"];
        List<GroupRoles> groupRoleObject = [];
        if (groupRoles.length > 0) {
          groupRoles.forEach((key, value) {
            final newRole = GroupRoles(roleId: key, roleName: value);
            groupRoleObject.add(newRole);
          });
        }
        final newGroup = Group(
          groupId: groupJSON['id']..toString(),
          groupName: groupJSON['name']..toString(),
          groupSize: groupJSON['size']..toString(),
          groupCountryId: groupJSON['country_id']..toString(),
          smsBalance: groupJSON["sms_balance"]..toString(),
          accountNumber: groupJSON["account_number"]..toString(),
          enableMemberInformationPrivacy:
              groupJSON["enable_member_information_privacy"] == 1
                  ? true
                  : false,
          enableSendMonthlyEmailStatements:
              groupJSON["enable_send_monthly_email_statements"] == 1
                  ? true
                  : false,
          groupRoles: groupRoleObject,
          memberListingOrderBy: groupJSON["member_listing_order_by"]
            ..toString(),
          orderMembersBy: groupJSON["order_members_by"]..toString(),
          onlineBankingEnabled:
              groupJSON["online_banking_enabled"] == 1 ? true : false,
          groupRoleId: groupJSON['group_role_id']..toString(),
          groupRole: groupJSON['role']..toString(),
          disableArrears: groupJSON['disable_arrears'] == 1 ? true : false,
          enableAbsoluteLoanRecalculation:
              groupJSON['enable_absolute_loan_recalculation'] == 1
                  ? true
                  : false,
          disableIgnoreContributionTransfers:
              groupJSON['disable_ignore_contribution_transfers'] == 1
                  ? true
                  : false,
          disableMemberEditProfile:
              groupJSON['disable_member_edit_profile'] == 1 ? true : false,
          isGroupAdmin: groupJSON['is_admin'] == 1 ? true : false,
          groupCurrency: groupJSON['group_currency']..toString(),
          groupCurrencyId: groupJSON['country_id']..toString(),
          groupPhone: groupJSON['phone']..toString(),
          groupEmail: groupJSON['email']..toString(),
          groupCountryName: groupJSON['country_name']..toString(),
          groupCurrencyName: groupJSON['group_currency']..toString(),
          avatar: groupJSON['avatar']..toString(),
        );
        loadedGroups.add(newGroup);
        loadedNewGroup = newGroup;
      }
    }
    if (replace) {
      _groups.removeAt(position);
      _groups.insert(0, loadedNewGroup);
    } else {
      _groups = loadedGroups;
    }
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
          "user_id": await Auth.getUser(Auth.userId),
          "group_id": currentGroupId,
        });
        final response = await PostToServer.post(postRequest, url);
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
      "user_id": await Auth.getUser(Auth.userId),
      "group_id": currentGroupId,
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

  void addAccounts(List<dynamic> groupBankAccounts, int accountType) {
    final List<Account> bankAccounts = [];
    if (groupBankAccounts.length > 0) {
      for (var bankAccountJSON in groupBankAccounts) {
        final newAccount = Account(
            id: bankAccountJSON['id'].toString(),
            name: bankAccountJSON['name'].toString(),
            typeId: accountType);
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
            id: bankJSON['id'].toInt(),
            logo: bankJSON['logo'].toString(),
            name: bankJSON['name'].toString());
        _bankOptions.add(newBank);
        notifyListeners();
      }
    }
  }

  void addBankBranchOptions(List<dynamic> bankBranches) {
    if (bankBranches.length > 0) {
      for (var bankBranchJSON in bankBranches) {
        final newBankBranch = BankBranch(
            id: bankBranchJSON['id'].toInt(),
            name: bankBranchJSON['name'].toString());
        _bankBranchOptions.add(newBankBranch);
        notifyListeners();
      }
    }
  }

  void addMobileMoneyProviderOptions(List<dynamic> mobileMoneyProviderOptions) {
    if (mobileMoneyProviderOptions.length > 0) {
      for (var mobileMoneyProviderJSON in mobileMoneyProviderOptions) {
        final newMobileMoneyProviderJSON = MobileMoneyProvider(
            id: mobileMoneyProviderJSON['id'].toInt(),
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
            id: saccoJSON['id'].toInt(),
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
            id: saccoBranchJSON['id'].toInt(),
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
    _groupContributionSummary = contributionSummary;
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
        _allAccounts = []; //clear all accounts
        final groupBankAccounts =
            response['accounts']['bank_accounts'] as List<dynamic>;
        addAccounts(groupBankAccounts, 1);
        final groupSaccoAccounts =
            response['accounts']['sacco_accounts'] as List<dynamic>;
        addAccounts(groupSaccoAccounts, 2);
        final groupMobileMoneyAccounts =
            response['accounts']['mobile_money_accounts'] as List<dynamic>;
        addAccounts(groupMobileMoneyAccounts, 3);
        final groupPettyCashAccountsAccounts =
            response['accounts']['petty_cash_accounts'] as List<dynamic>;
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

  Future<void> fetchCountryOptions() async {
    const url = EndpointUrl.GET_COUNTRY_LIST;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
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
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
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
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
        "name": name,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        if (response['status'] == 1) {
          updateGroupProfile();
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
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
        "email": email,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        if (response['status'] == 1) {
          updateGroupProfile();
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
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
        "phone": phone,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        if (response['status'] == 1) {
          updateGroupProfile();
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
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
        "country_id": countryId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        //final name = response['name'];
        //final countryId = response['country_id'];
        if (response['status'] == 1) {
          updateGroupProfile();
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
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
        "currency_id": currencyId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        //final currencyId = response['currencyId'];
        //final currency = response['currency'];
        if (response['status'] == 1) {
          updateGroupProfile();
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

  Future<dynamic> updateGroupSettings({
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
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
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
        //final status = response['status'];
        //final message = response['message'];

        if (response['status'] == 1) {
          updateGroupProfile();
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

  Future<void> fetchBankOptions() async {
    const url = EndpointUrl.GET_BANKS;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _bankOptions = []; //clear
        final banks = response['banks'] as List<dynamic>;
        addBankOptions(banks);
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

  Future<void> fetchBankBranchOptions() async {
    const url = EndpointUrl.GET_BANK_BRANCHES;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _bankBranchOptions = []; //clear
        final bankBranches = response['bank_branches'] as List<dynamic>;
        addBankBranchOptions(bankBranches);
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

  Future<void> fetchMobileMoneyProviderOptions() async {
    const url = EndpointUrl.GE_MOBILE_PROVIDERS;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
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
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
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

  Future<void> fetchSaccoBranchesOptions() async {
    const url = EndpointUrl.GET_SACCO_BRANCHES;
    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
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
    _groupContributionSummary = [];
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

  /// ***********************Loans Summary*****************************
  Future<void> fetchLoansSummary() async {
    const url = EndpointUrl.GET_LOANS_SUMMARY;

    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final data = response['data'] as dynamic;
        addLoansSummary(data);
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

  /// ***********************Contribution Statement*****************************
  Future<void> fetchContributionStatement(int statementFlag) async {
    String url = EndpointUrl.GET_CONTRIBUTION_STATEMENT;
    if (statementFlag == FINE_STATEMENT) {
      url = EndpointUrl.GET_FINE_STATEMENT;
    }

    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        addContributionStatement(response);
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

  /// ***********************Member Loans*****************************
  Future<void> fetchMemberLoans() async {
    const url = EndpointUrl.GET_GROUP_LOAN_LIST;

    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
        "is_member_loans": 1
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final loans = response['loans'] as List<dynamic>;
        addMemberLoans(loans);
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

  /// ***********************Member Loan Statement*****************************
  Future<void> fetchLoanStatement(int loanId) async {
    const url = EndpointUrl.GET_LOAN_STATEMENT;

    try {
      final postRequest = json.encode({
        "user_id": await Auth.getUser(Auth.userId),
        "group_id": currentGroupId,
        "id": loanId
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final data = response['data'] as dynamic;
        addLoanStatements(data);
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
}
