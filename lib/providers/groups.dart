import 'dart:convert';
// import 'dart:developer';
import 'dart:io' as io;
import 'dart:io';
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
import 'package:chamasoft/screens/chamasoft/models/withdrawal-request.dart';
import 'package:chamasoft/screens/chamasoft/models/withdrawal.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/database-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:chamasoft/helpers/report_helper.dart';
import 'package:chamasoft/helpers/setting_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class Notification {
  final int id;
  String fromMemberId;
  String fromUserId;
  String toUserId;
  String toMemberId;
  String subject;
  String message;
  String groupId;
  String isRead;
  String createdBy;
  String createdOn;
  String modifiedBy;
  String modifiedOn;
  String callToAction;
  String callToActionLink;
  String category;
  String active;
  String invoiceId;
  String depositId;
  String transactionAlertId;
  String fileSize;
  String filePath;
  String fileType;
  String referenceNumber;
  String paymentRequestStatus;
  String withdrawalRequestId;
  String withdrawalApprovalRequestId;
  String loanId;
  String count;
  String timeAgo;

  Notification({
    @required this.id,
    @required this.message,
    this.fromMemberId,
    this.fromUserId,
    this.toUserId,
    this.toMemberId,
    @required this.subject,
    this.groupId,
    this.isRead,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.callToAction,
    this.callToActionLink,
    this.category,
    this.active,
    this.invoiceId,
    this.depositId,
    this.transactionAlertId,
    this.fileSize,
    this.filePath,
    this.fileType,
    this.referenceNumber,
    this.paymentRequestStatus,
    this.withdrawalRequestId,
    this.withdrawalApprovalRequestId,
    this.loanId,
    this.count,
    this.timeAgo,
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
  final bool isHidden;
  final bool active;

  IncomeCategories(
      {this.id, this.name, this.description, this.isHidden, this.active});
}

class ExpenseCategories {
  @required
  final String id;
  @required
  final String name;
  final String description;
  final bool ishidden;

  ExpenseCategories({
    this.id,
    this.name,
    this.description,
    this.ishidden,
  });
}

class Stock {
  @required
  final String id;
  @required
  final String name;
  final String description;
  final bool ishidden;

  Stock({
    this.id,
    this.name,
    this.description,
    this.ishidden,
  });
}

class MoneyMarketInvestment {
  @required
  final String id;
  @required
  final String name;
  final String description;
  final bool ishidden;

  MoneyMarketInvestment({
    this.id,
    this.name,
    this.description,
    this.ishidden,
  });
}

class Borrower {
  @required
  final String id;
  @required
  final String name;
  final String description;
  final bool ishidden;

  Borrower({
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
  final bool isHidden;

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

class BankLoans {
  final String id;
  final String description;
  final double amount, balance;

  BankLoans(
      {@required this.id,
      @required this.description,
      this.amount,
      this.balance});
}

class OngoingMemberLoanOptions {
  final String id, memberId;
  final String description, loanType;
  final double amount, balance;
  final isSelected;

  OngoingMemberLoanOptions(
      {@required this.id,
      @required this.memberId,
      @required this.description,
      this.amount,
      this.balance,
      this.isSelected,
      this.loanType});
}

class UnreconciledDeposit {
  final int type;
  final String transactionType;
  final String transactionDate;
  final double amount;
  final String description;
  final String transactionAlertId;
  bool isReconciled;
  final String particulars;
  final String accountNumber;
  final String transactionId;
  final String accountDetails;

  UnreconciledDeposit(
      {@required this.type,
      @required this.transactionType,
      @required this.transactionDate,
      @required this.amount,
      @required this.description,
      @required this.transactionAlertId,
      @required this.isReconciled,
      @required this.particulars,
      @required this.accountNumber,
      @required this.transactionId,
      @required this.accountDetails});
}

class UnreconciledWithdrawal {
  final int type;
  final String transactionType;
  final String transactionDate;
  final double amount;
  final String description;
  final String transactionAlertId;
  bool isReconciled;
  final String particulars;
  final String accountNumber;
  final String transactionId;
  final String accountDetails;

  UnreconciledWithdrawal(
      {@required this.type,
      @required this.transactionType,
      @required this.transactionDate,
      @required this.amount,
      @required this.description,
      @required this.transactionAlertId,
      @required this.isReconciled,
      @required this.particulars,
      @required this.accountNumber,
      @required this.transactionId,
      @required this.accountDetails});
}

class Groups with ChangeNotifier {
  static const String selectedGroupId = "selectedGroupId";

  List<Account> _accounts = [];
  List<Contribution> _contributions = [];
  List<Contribution> _payContributions = [];
  List<Expense> _expenses = [];
  List<FineType> _fineTypes = [];
  List<IncomeCategories> _incomeCategories = [];
  List<IncomeCategories> _detailedIncomeCategories = [];
  List<IncomeCategories> _assetCategories = [], _groupAssetOptions = [];
  List<Stock> _groupStockOptions = [];
  List<MoneyMarketInvestment> _groupMoneyMarketInvestmentOptions = [];
  List<Borrower> _groupBorrowerOptions = [];
  List<ExpenseCategories> _expenseCategories = [];
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
  List<OngoingMemberLoanOptions> _ongoingMemberLoans = [];

  AccountBalanceModel _accountBalances;
  TransactionStatementModel _transactionStatement;
  ExpenseSummaryList _expenseSummaryList;
  LoansSummaryList _loansSummaryList;
  ContributionStatementModel _contributionStatement;
  ContributionStatementModel _fineStatement;
  LoanStatementModel _loanStatements;
  List<GroupContributionSummary> _groupContributionSummary = [];
  List<GroupContributionSummary> _groupFinesSummary = [];
  List<Deposit> _depositList = [];
  List<Withdrawal> _withdrawalList = [];
  List<WithdrawalRequest> _withdrawalRequests = [];
  List<UnreconciledDeposit> _unreconciledDeposits = [];
  List<UnreconciledWithdrawal> _unreconciledWithdrawals = [];
  WithdrawalRequestDetails _withdrawalRequestDetails;
  List<ActiveLoan> _memberLoanList = [];
  double _totalGroupContributionSummary = 0, _totalGroupFinesSummary = 0;
  List<CategorisedAccount> _categorisedAccounts = [];
  GroupRolesStatusAndCurrentMemberStatus
      _groupRolesStatusAndCurrentMemberStatus;

  List<BankLoans> _bankLoans = [];
  List<Notification> _notifications = [];
  bool _loanPulled = false;

  String _userId;
  String _identity;
  List<Group> _groups = [];
  String _currentGroupId;
  // String _currentMemberId;

  List<dynamic> _meetings = [];

  Groups(List<Group> _groups, String _userId, String _identity,
      String _currentGroupId) {
    this._groups = _groups;
    this._userId = _userId;
    this._identity = _identity;
    this._currentGroupId = _currentGroupId;
  }

  List<Group> get item {
    return [..._groups];
  }

  List<dynamic> get meetings {
    return [..._meetings];
  }

  String get userId {
    return _userId;
  }

  String get currentGroupId {
    return _currentGroupId;
  }

  List<Account> get accounts {
    return [..._accounts];
  }

  List<Contribution> get contributions {
    return [..._contributions];
  }

  List<Contribution> get payContributions {
    return [..._payContributions];
  }

  List<Expense> get expenses {
    return [..._expenses];
  }

  List<ExpenseCategories> get expenseCategories {
    return [..._expenseCategories];
  }

  List<FineType> get fineTypes {
    return [..._fineTypes];
  }

  List<IncomeCategories> get detailedIncomeCategories {
    return [..._detailedIncomeCategories];
  }

  List<IncomeCategories> get assetCategories {
    return [..._assetCategories];
  }

  List<IncomeCategories> get groupAssetOptions {
    return [..._groupAssetOptions];
  }

  List<Stock> get groupStockOptions {
    return [..._groupStockOptions];
  }

  List<MoneyMarketInvestment> get groupMoneyMarketInvestmentOptions {
    return [..._groupMoneyMarketInvestmentOptions];
  }

  List<Borrower> get groupBorrowerOptions {
    return [..._groupBorrowerOptions];
  }

  List<LoanType> get loanTypes {
    return [..._loanTypes];
  }

  List<Member> get members {
    return [..._members];
  }

  List<Country> get countryOptions {
    return [..._countryOptions];
  }

  List<Bank> get bankOptions {
    return [..._bankOptions];
  }

  List<BankBranch> get bankBranchOptions {
    return [..._bankBranchOptions];
  }

  List<MobileMoneyProvider> get mobileMoneyProviderOptions {
    return [..._mobileMoneyProviderOptions];
  }

  List<Sacco> get saccoOptions {
    return [..._saccoOptions];
  }

  List<SaccoBranch> get saccoBranchOptions {
    return [..._saccoBranchOptions];
  }

  List<Currency> get currencyOptions {
    return [..._currencyOptions];
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
    return [..._groupContributionSummary];
  }

  List<GroupContributionSummary> get groupFinesSummary {
    return [..._groupFinesSummary];
  }

  LoansSummaryList get getLoansSummaryList {
    return _loansSummaryList;
  }

  ContributionStatementModel get getContributionStatements {
    return _contributionStatement;
  }

  ContributionStatementModel get getFineStatements {
    return _fineStatement;
  }

  List<ActiveLoan> get getMemberLoans {
    return [..._memberLoanList];
  }

  List<OngoingMemberLoanOptions> get getMemberOngoingLoans {
    return [..._ongoingMemberLoans];
  }

  LoanStatementModel get getLoanStatements {
    return _loanStatements;
  }

  List<Deposit> get getDeposits {
    return [..._depositList];
  }

  List<Withdrawal> get getWithdrawals {
    return [..._withdrawalList];
  }

  List<UnreconciledDeposit> get getUnreconciledDeposits {
    return [..._unreconciledDeposits];
  }

  List<UnreconciledWithdrawal> get getUnreconciledWithdrawals {
    return [..._unreconciledWithdrawals];
  }

  List<WithdrawalRequest> get getWithdrawalRequestList {
    return [..._withdrawalRequests];
  }

  WithdrawalRequestDetails get getWithdrawalRequestDetails {
    return _withdrawalRequestDetails;
  }

  double groupTotalContributionSummary() {
    return _totalGroupContributionSummary;
  }

  double groupTotalFinesSummary() {
    return _totalGroupFinesSummary;
  }

  List<CategorisedAccount> get getAllCategorisedAccounts {
    return [..._categorisedAccounts];
  }

  GroupRolesStatusAndCurrentMemberStatus
      get getGroupRolesAndCurrentMemberStatus {
    return _groupRolesStatusAndCurrentMemberStatus;
  }

  List<Notification> get notifications {
    return _notifications;
  }

  /// ********************Group Objects************/
  setSelectedGroupId(String groupId) async {
    switchGroupValuesToDefault();
    _currentGroupId = groupId;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(selectedGroupId)) {
      prefs.remove(selectedGroupId);
    }
    prefs.setString(selectedGroupId, groupId);
    notifyListeners();
  }

  getCurrentGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedGroupId);
  }

  removeCurrentGroupId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(selectedGroupId);
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
      if (_groups.length > 0) {
        return _groups[0];
      } else {
        return null;
      }
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
    notifyListeners();
  }

  Future<void> updateGroupAvatar(io.File avatar) async {
    final url = EndpointUrl.EDIT_NEW_GROUP_PHOTO;
    try {
      try {
        final newAvatar = base64Encode(avatar.readAsBytesSync());
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
    final url = EndpointUrl.GET_GROUP_DATA;
    final postRequest = json.encode({
      "user_id": _userId,
      "group_id": _currentGroupId,
    });
    try {
      final response = await PostToServer.post(postRequest, url);
      // log(response.toString());
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
          typeId: accountType,
        );
        bankAccounts.add(newAccount);
        _accounts.add(newAccount);
      }
    }
    _allAccounts.add(bankAccounts);
    notifyListeners();
    return position;
  }

  // ignore: missing_return
  String getAccountFormId(int position) {
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

  Future<void> addContributions(
      {List<dynamic> groupContributions, isLocal = false}) async {
    if (groupContributions.length > 0) {
      List<Map> _contributionsList = [];
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
        if (!isLocal) {
          var contributionMap = {
            "id": int.parse(groupContributionJSON['id'].toString()),
            "group_id": int.parse(_currentGroupId),
            "name": groupContributionJSON['name'].toString(),
            "amount": groupContributionJSON['amount'].toString(),
            "type": groupContributionJSON['type'].toString(),
            "contribution_type":
                groupContributionJSON['contribution_type'].toString(),
            "frequency": groupContributionJSON['frequency'].toString(),
            "invoice_date": groupContributionJSON['invoice_date'].toString(),
            "contribution_date":
                groupContributionJSON['contribution_date'].toString(),
            " one_time_contribution_setting":
                groupContributionJSON['one_time_contribution_setting']
                    .toString(),
            "is_hidden": groupContributionJSON['is_hidden'].toString(),
            "active": groupContributionJSON['active'].toString(),
            "modified_on": DateTime.now().millisecondsSinceEpoch,
          };
          _contributionsList.add(contributionMap);
        }
      }
      if (!isLocal) {
        await dbHelper.deleteMultiple(
            [int.parse(_currentGroupId)], DatabaseHelper.contributionsTable);
        await dbHelper.batchInsert(
            _contributionsList, DatabaseHelper.contributionsTable);
      }
    }
    notifyListeners();
  }

  Future<void> addPayContributions(
      {List<dynamic> groupContributions, bool isLocal = false}) async {
    if (groupContributions.length > 0) {
      if (isLocal) {
        for (var groupContributionJSON in groupContributions) {
          final newContribution = Contribution(
            id: groupContributionJSON['id'].toString(),
            name: groupContributionJSON['name'].toString(),
            amount: groupContributionJSON['amount'].toString(),
            isHidden: groupContributionJSON['is_hidden'].toString(),
            active: groupContributionJSON['active'].toString(),
          );
          _payContributions.add(newContribution);
        }
      } else {
        List<Map> _contributionsList = [];
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
                groupContributionJSON['one_time_contribution_setting']
                    .toString(),
            isHidden: groupContributionJSON['is_hidden'].toString(),
            active: groupContributionJSON['active'].toString(),
          );
          var contributionMap = {
            "id": int.parse(groupContributionJSON['id'].toString()),
            "group_id": int.parse(_currentGroupId),
            "active": int.parse(groupContributionJSON['active'].toString()),
            "amount": double.parse(groupContributionJSON['amount'].toString()),
            "name": groupContributionJSON['name'].toString(),
            "is_hidden":
                int.parse(groupContributionJSON['is_hidden'].toString()),
            "modified_on": DateTime.now().millisecondsSinceEpoch,
          };
          _contributionsList.add(contributionMap);
          _payContributions.add(newContribution);
        }
        await dbHelper.deleteMultiple(
            [int.parse(_currentGroupId)], DatabaseHelper.payContributionsTable);
        await dbHelper.batchInsert(
            _contributionsList, DatabaseHelper.payContributionsTable);
      }
    }
    notifyListeners();
  }

  void parseExpenseData(List<dynamic> groupExpenses) {
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

  Future<void> addFineTypes(
      {List<dynamic> groupFineTypes, isLocal = false}) async {
    if (groupFineTypes.length > 0) {
      if (isLocal) {
        for (var groupFineTypesJSON in groupFineTypes) {
          final newFineType = FineType(
            id: groupFineTypesJSON['id'].toString(),
            name: groupFineTypesJSON['name'].toString(),
            amount: groupFineTypesJSON['amount'].toString(),
            balance: groupFineTypesJSON['balance'].toString(),
          );
          _fineTypes.add(newFineType);
        }
      } else {
        List<Map> _fineTypesList = [];
        for (var groupFineTypesJSON in groupFineTypes) {
          final newFineType = FineType(
              id: groupFineTypesJSON['id'].toString(),
              name: groupFineTypesJSON['name'].toString(),
              amount: groupFineTypesJSON['amount'].toString(),
              balance: groupFineTypesJSON['balance'].toString());

          var fineTypeMap = {
            "id": int.parse(groupFineTypesJSON['id'].toString()),
            "group_id": int.parse(_currentGroupId),
            "amount": double.parse(groupFineTypesJSON['amount'].toString()),
            "balance": double.parse(groupFineTypesJSON['balance'].toString()),
            "name": groupFineTypesJSON['name'].toString(),
            "modified_on": DateTime.now().millisecondsSinceEpoch,
          };
          _fineTypes.add(newFineType);
          _fineTypesList.add(fineTypeMap);
        }
        await dbHelper.deleteMultiple(
            [int.parse(_currentGroupId)], DatabaseHelper.fineCategories);
        await dbHelper.batchInsert(
            _fineTypesList, DatabaseHelper.fineCategories);
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
          isHidden: false,
        );
        _incomeCategories.add(income);
      }
    }
    notifyListeners();
  }

  void addDetailedIncomeCategories(List<dynamic> incomeCategories) {
    if (incomeCategories.length > 0) {
      for (var incomeCategoryJson in incomeCategories) {
        var description = incomeCategoryJson["description"];
        final income = IncomeCategories(
          id: incomeCategoryJson['id'].toString(),
          name: incomeCategoryJson['name'].toString(),
          description: description != null ? description.toString() : "",
          isHidden:
              ParseHelper.getIntFromJson(incomeCategoryJson, "is_hidden") != 0,
          active: ParseHelper.getIntFromJson(incomeCategoryJson, "active") != 0,
        );
        _detailedIncomeCategories.add(income);
      }
    }
    notifyListeners();
  }

  void addAssetCategories(List<dynamic> incomeCategories) {
    if (incomeCategories.length > 0) {
      for (var incomeCategoryJson in incomeCategories) {
        var description = incomeCategoryJson["description"];
        final income = IncomeCategories(
          id: incomeCategoryJson['id'].toString(),
          name: incomeCategoryJson['name'].toString(),
          description: description != null ? description.toString() : "",
          isHidden:
              ParseHelper.getIntFromJson(incomeCategoryJson, "is_hidden") != 0,
          active: ParseHelper.getIntFromJson(incomeCategoryJson, "active") != 0,
        );
        _assetCategories.add(income);
      }
    }
    notifyListeners();
  }

  void addGroupAssetOptions(List<dynamic> assetOptions) {
    if (assetOptions.length > 0) {
      for (var assetOptionJson in assetOptions) {
        var description = assetOptionJson["description"];
        final income = IncomeCategories(
          id: assetOptionJson['id'].toString(),
          name: assetOptionJson['name'].toString(),
          description: description != null ? description.toString() : "",
        );
        _groupAssetOptions.add(income);
      }
    }
    notifyListeners();
  }

  void addGroupStockOptions(List<dynamic> stockOptions) {
    if (stockOptions.length > 0) {
      for (var stockOptionJson in stockOptions) {
        var description = stockOptionJson["description"];
        final stock = Stock(
          id: stockOptionJson['id'].toString(),
          name: stockOptionJson['name'].toString(),
          description: description != null ? description.toString() : "",
        );
        _groupStockOptions.add(stock);
      }
    }
    notifyListeners();
  }

  void addGroupMoneyMarketInvestmentOptions(
      List<dynamic> moneyMarketInvestmentOptions) {
    if (moneyMarketInvestmentOptions.length > 0) {
      for (var moneyMarketInvestmentOptionJson
          in moneyMarketInvestmentOptions) {
        var description = moneyMarketInvestmentOptionJson["description"];
        final moneyMarketInvestment = MoneyMarketInvestment(
          id: moneyMarketInvestmentOptionJson['id'].toString(),
          name: moneyMarketInvestmentOptionJson['investment_institution_name']
              .toString(),
          description: description != null ? description.toString() : "",
        );
        _groupMoneyMarketInvestmentOptions.add(moneyMarketInvestment);
      }
    }
    notifyListeners();
  }

  void addGroupBorrowerOptions(List<dynamic> borrowerOptions) {
    if (borrowerOptions.length > 0) {
      for (var borrowerOptionJson in borrowerOptions) {
        var description = borrowerOptionJson["description"];
        final borrower = Borrower(
          id: borrowerOptionJson['id'].toString(),
          name: borrowerOptionJson['name'].toString(),
          description: description != null ? description.toString() : "",
        );
        _groupBorrowerOptions.add(borrower);
      }
    }
    notifyListeners();
  }

  void addExpenseCategories({List<dynamic> expenseCategories}) {
    if (expenseCategories.length > 0) {
      for (var expenseCategoryJson in expenseCategories) {
        final expense = ExpenseCategories(
          id: expenseCategoryJson['id'].toString(),
          name: expenseCategoryJson['name'].toString(),
          description: "",
          ishidden: false,
        );
        _expenseCategories.add(expense);
      }
    }
    notifyListeners();
  }

  void addLoanTypes(List<dynamic> groupLoanTypes) {
    _loanTypes = parseLoanTypes(groupLoanTypes);
    notifyListeners();
  }

  void addMembers({List<dynamic> groupMembers, isLocal = false}) {
    if (groupMembers.length > 0) {
      if (isLocal) {
        for (var groupMembersJSON in groupMembers) {
          final newMember = Member(
              id: groupMembersJSON['id'].toString(),
              name: groupMembersJSON['name'].toString(),
              userId: groupMembersJSON['user_id'].toString(),
              identity: groupMembersJSON['identity'].toString(),
              avatar: groupMembersJSON['avatar'].toString());
          _members.add(newMember);
        }
      } else {
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
    }
    notifyListeners();
  }

  void addNotification(List<dynamic> newNotifications) {
    if (newNotifications.length > 0) {
      for (var notificationJson in newNotifications) {
        final noticeBody = Notification(
            id: int.parse(notificationJson["id"]),
            message: notificationJson["message"]..toString(),
            isRead: notificationJson["is_read"]..toString(),
            timeAgo: notificationJson["time_ago"]..toString(),
            subject: notificationJson["subject"]..toString());
        _notifications.add(noticeBody);
        // final notification = Notification(
        //   id: notificationJson['id'].toInt(),
        //   message: "this is sample"
        //   // fromMemberId: notificationJson['fromMemberId'].toString(),
        //   // fromUserId: notificationJson['fromUserId'].toString(),
        //   // toUserId: notificationJson['toUserId'].toString(),
        //   // toMemberId: notificationJson['toMemberId'].toString(),
        //   // subject: notificationJson['subject'].toString(),
        //   // message: notificationJson['message'].toString(),
        //   // groupId: notificationJson['groupId'].toString(),
        //   // isRead: notificationJson['isRead'].toString(),
        //   // createdBy: notificationJson['createdBy'].toString(),
        //   // createdOn: notificationJson['createdOn'].toString(),
        //   // modifiedBy: notificationJson['modifiedBy'].toString(),
        //   // modifiedOn: notificationJson['modifiedOn'].toString(),
        //   // callToAction: notificationJson['callToAction'].toString(),
        //   // callToActionLink: notificationJson['callToActionLink'].toString(),
        //   // category: notificationJson['category'].toString(),
        //   // active: notificationJson['active'].toString(),
        //   // invoiceId: notificationJson['invoiceId'].toString(),
        //   // depositId: notificationJson['depositId'].toString(),
        //   // transactionAlertId: notificationJson['transactionAlertId'].toString(),
        //   // fileSize: notificationJson['fileSize'].toString(),
        //   // filePath: notificationJson['filePath'].toString(),
        //   // fileType: notificationJson['fileType'].toString(),
        //   // referenceNumber: notificationJson['referenceNumber'].toString(),
        //   // paymentRequestStatus:
        //   //     notificationJson['paymentRequestStatus'].toString(),
        //   // withdrawalRequestId:
        //   //     notificationJson['withdrawalRequestId'].toString(),
        //   // withdrawalApprovalRequestId:
        //   //     notificationJson['withdrawalApprovalRequestId'].toString(),
        //   // loanId: notificationJson['loanId'].toString(),
        //   // count: notificationJson['count'].toString(),
        //   // timeAgo: notificationJson['timeAgo'].toString(),
        // );
        // _notifications.add(notification);
      }
    }
    notifyListeners();
  }

  void addUnreconciledDeposit({List<dynamic> unreconciledDeposits}) {
    if (unreconciledDeposits.length > 0) {
      for (var unreconciledDeposit in unreconciledDeposits) {
        final newUnreconciledDeposit = UnreconciledDeposit(
            type: int.tryParse(unreconciledDeposit['type'].toString()),
            transactionType: unreconciledDeposit['transaction_type']
              ..toString(),
            transactionDate: unreconciledDeposit['transactionDate']..toString(),
            amount: double.tryParse(unreconciledDeposit['amount'].toString()) ??
                0.0,
            description: unreconciledDeposit['description']..toString(),
            transactionAlertId: unreconciledDeposit['transactionAlertId']
              ..toString(),
            isReconciled:
                (unreconciledDeposit['isReconciled']..toString()) == "1"
                    ? true
                    : false,
            particulars: unreconciledDeposit['particulars']..toString(),
            accountNumber: unreconciledDeposit['accountNUmber']..toString(),
            transactionId: unreconciledDeposit['transaction_id']..toString(),
            accountDetails: unreconciledDeposit['account_details']..toString());

        _unreconciledDeposits.add(newUnreconciledDeposit);
      }
    }
    notifyListeners();
  }

  void addUnreconciledWithdrawal({List<dynamic> unreconciledWithdrawals}) {
    if (unreconciledWithdrawals.length > 0) {
      for (var unreconciledWithdrawal in unreconciledWithdrawals) {
        final newUnreconciledWithdrawal = UnreconciledWithdrawal(
            type: int.tryParse(unreconciledWithdrawal['type'].toString()),
            transactionType: unreconciledWithdrawal['transaction_type']
              ..toString(),
            transactionDate: unreconciledWithdrawal['transactionDate']
              ..toString(),
            amount:
                double.tryParse(unreconciledWithdrawal['amount'].toString()) ??
                    0.0,
            description: unreconciledWithdrawal['description']..toString(),
            transactionAlertId: unreconciledWithdrawal['transactionAlertId']
              ..toString(),
            isReconciled:
                (unreconciledWithdrawal['isReconciled']..toString()) == "1"
                    ? true
                    : false,
            particulars: unreconciledWithdrawal['particulars']..toString(),
            accountNumber: unreconciledWithdrawal['accountNUmber']..toString(),
            transactionId: unreconciledWithdrawal['transaction_id']..toString(),
            accountDetails: unreconciledWithdrawal['account_details']
              ..toString());

        _unreconciledWithdrawals.add(newUnreconciledWithdrawal);
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
            id: int.parse(saccoBranchJSON['id'].toString()),
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

  void addContributionStatement(int flag, dynamic data) {
    if (flag == FINE_STATEMENT) {
      _fineStatement = getContributionStatement(data);
    } else
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
    _depositList.addAll(getDepositList(data));
    notifyListeners();
  }

  void addWithdrawalList(List<dynamic> data) {
    _withdrawalList.addAll(getWithdrawalList(data));
    notifyListeners();
  }

  void addWithdrawalRequestList(List<dynamic> data) {
    _withdrawalRequests = getWithdrawalRequests(data);
    notifyListeners();
  }

  void addWithdrawalRequestDetails(dynamic data) {
    _withdrawalRequestDetails = getWithdrawalDetails(data);
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
          balanceAmount: double.tryParse(object['arrears'].toString()) ?? 0.0,
        );
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
          balanceAmount: double.tryParse(object['arrears'].toString()) ?? 0.0,
        );
        finesSummary.add(newData);
        total += amountpaid;
      }
    }
    _totalGroupFinesSummary = total;
    _groupFinesSummary = finesSummary;
    notifyListeners();
  }

  void addBankLoans(List<dynamic> bankLoansList) {
    final List<BankLoans> bankLoansSummary = [];
    if (bankLoansList.length > 0) {
      for (var object in bankLoansList) {
        final newData = BankLoans(
          id: object['id'].toString(),
          description: object['description'].toString(),
          amount: double.tryParse(object['amount'].toString()) ?? 0.0,
          balance: double.tryParse(object['balance'].toString()) ?? 0.0,
        );
        bankLoansSummary.add(newData);
      }
    }
    _bankLoans = bankLoansSummary;
    notifyListeners();
  }

  Future<void> addOngoingMemberLoans(
      {List<dynamic> memberLoansList, isLocal = false}) async {
    List<OngoingMemberLoanOptions> memberLoansSummary = [];
    if (memberLoansList.length > 0) {
      if (isLocal) {
        for (var object in memberLoansList) {
          final memberId = object['member_id'].toString();
          final bool isSelected =
              object['is_selected'].toString() == "1" ? true : false;
          memberLoansSummary.add(OngoingMemberLoanOptions(
              id: object['id'].toString(),
              memberId: memberId,
              isSelected: isSelected,
              description: object['description'],
              amount: object['amount'],
              balance: object['balance'],
              loanType: object['loanType']));
        }
        _ongoingMemberLoans = memberLoansSummary;
        _loanPulled = true;
      } else {
        List<Map> _ongoingMemberLoanList = [];
        for (var object in memberLoansList) {
          final memberId = object['member_id'].toString();
          final bool isSelected =
              object['is_selected'].toString() == "1" ? true : false;
          memberLoansSummary.add(OngoingMemberLoanOptions(
              id: object['id'].toString(),
              memberId: memberId,
              isSelected: isSelected,
              description: object['description'].toString(),
              amount: double.tryParse(object['amount'].toString()) ?? 0.0,
              balance: double.tryParse(object['balance'].toString()) ?? 0.0,
              loanType: object['name'].toString()));
          Map<String, dynamic> memberLoansMap = {
            "id": int.parse(object['id'].toString()),
            "group_id": int.tryParse(_currentGroupId),
            "user_id": int.tryParse(_userId),
            "member_id": int.tryParse(memberId),
            "is_selected": int.tryParse(object['is_selected'].toString()) ?? 0,
            "description": object['description'].toString(),
            "loanType": object['name'].toString(),
            "amount": double.tryParse(object['amount'].toString()),
            "balance": double.tryParse(object['balance'].toString()),
            "modified_on": DateTime.now().millisecondsSinceEpoch,
          };
          _ongoingMemberLoanList.add(memberLoansMap);
        }
        _ongoingMemberLoans = memberLoansSummary;
        _loanPulled = true;
        try {
          await dbHelper.deleteMultiple(
              [int.parse(_currentGroupId)], DatabaseHelper.memberLoanOptions);
          await dbHelper.batchInsert(
              _ongoingMemberLoanList, DatabaseHelper.memberLoanOptions);
        } catch (e) {
          throw e;
        }
      }
    }
    notifyListeners();
  }

  Future<void> fetchAndSetUserGroups() async {
    final url = EndpointUrl.GET_GROUPS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);

        //=== BEGIN: OFFLINE PLUG
        //=== Check if record exists...
        bool _exists = await entryExistsInDb(
          DatabaseHelper.dataTable,
          "section",
          "groups",
        );
        //=== ...if it doesn't exist, insert it.
        if (!_exists) {
          await insertToLocalDb(
            DatabaseHelper.dataTable,
            {
              "section": "groups",
              "value": jsonEncode(response['user_groups']),
              "modified_on": DateTime.now().millisecondsSinceEpoch,
            },
          );
        }
        //=== If it does exist, update it.
        else {
          dynamic _groups = await getLocalData('groups');
          await updateInLocalDb(
            DatabaseHelper.dataTable,
            {
              "id": _groups['id'],
              "section": "groups",
              "value": jsonEncode(response['user_groups']),
              "modified_on": DateTime.now().millisecondsSinceEpoch,
            },
          );
        }
        //=== END: OFFLINE PLUG

        final userGroups = response['user_groups'] as List<dynamic>;
        addGroups(userGroups);
      } on CustomException catch (error) {
        if (error.status == ErrorStatusCode.statusNoInternet) {
          //=== BEGIN: OFFLINE PLUG
          dynamic _localData = await getLocalData('groups');
          if (_localData['value'] != null) {
            final userGroups = _localData['value'] as List<dynamic>;
            addGroups(userGroups);
          }
          //=== END: OFFLINE PLUG
        } else {
          throw CustomException(message: error.message, status: error.status);
        }
      } catch (error) {
        throw CustomException(message: error.message);
      }
    } on CustomException catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        //=== BEGIN: OFFLINE PLUG
        dynamic _localData = await getLocalData('groups');
        if (_localData['value'] != null) {
          final userGroups = _localData['value'] as List<dynamic>;
          addGroups(userGroups);
        }
        //=== END: OFFLINE PLUG
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> createGroup({
    String groupName,
    int countryId,
    File avatar,
  }) async {
    final url = EndpointUrl.CREATE_GROUP;

    try {
      String newAvatar;
      if (avatar != null) {
        newAvatar = base64Encode(avatar.readAsBytesSync());
      }

      final postRequest = json.encode({
        "user_id": _userId,
        "group_name": groupName,
        "country_id": countryId,
        "avatar": newAvatar
      });
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

  Future<dynamic> syncMeeting(Map<String, dynamic> meeting) async {
    try {
      final url = EndpointUrl.CREATE_MEETING;
      try {
        meeting['user_id'] = _userId;
        final postRequest = json.encode(meeting);
        var response = await PostToServer.post(postRequest, url);
        return response;
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

  Future<void> fetchLocalMeetings() async {
    List<dynamic> _localData = [];
    _localData = await dbHelper.queryWhere(
      table: DatabaseHelper.meetingsTable,
      column: "group_id",
      whereArguments: [_currentGroupId],
      orderBy: 'id',
      order: 'DESC',
      isMeeting: true,
    );
    addMeetings(_localData);
  }

  Future<dynamic> fetchMeetings() async {
    final url = EndpointUrl.GET_MEETINGS;
    try {
      final postRequest = json.encode({
        "group_id": _currentGroupId,
        "user_id": _userId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final groupMeetings = response['meetings'] as List<dynamic>;

        //=== BEGIN: OFFLINE PLUG
        //=== Remove all synced meetings & insert new ones
        // List<int> _ids = [];
        // groupMeetings.forEach((meeting) {
        //   if (!_ids.contains(int.parse(meeting['group_id'])))
        //     _ids.add(int.parse(meeting['group_id']));
        // });
        await dbHelper.deleteMultipleMeetings(
          [int.parse(_currentGroupId)],
          DatabaseHelper.meetingsTable,
        );
        //=== ...insert records.
        List<dynamic> rows = [];
        groupMeetings.forEach((m) {
          rows.add({
            "group_id": int.parse(_currentGroupId),
            "user_id": int.parse(m['user_id']),
            "title": m['title'],
            "venue": m['venue'],
            "purpose": m['purpose'],
            "date": m['date'],
            "members": jsonEncode(m['members']),
            "agenda": jsonEncode(m['agenda']),
            "collections": jsonEncode(m['collections']),
            "aob": jsonEncode(m['aob']),
            "synced": 1,
            "submitted_on": int.parse(m['time']),
            "synced_on": int.parse(m['time']),
            "modified_on": DateTime.now().millisecondsSinceEpoch,
          });
        });
        if (rows.length > 0)
          await insertManyToLocalDb(DatabaseHelper.meetingsTable, rows);
        //=== ...fetch local records
        await fetchLocalMeetings();
      } on CustomException catch (error) {
        if (error.status == ErrorStatusCode.statusNoInternet) {
          await fetchLocalMeetings();
        } else {
          throw CustomException(message: error.message, status: error.status);
        }
      } catch (error) {
        throw CustomException(message: error.message);
      }
    } on CustomException catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        await fetchLocalMeetings();
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> addMeetings(List<dynamic> meetingObject,
      [bool replace = false,
      int position = 0,
      bool isNewMeeting = false]) async {
    final List<dynamic> loadedMeetings = [];
    dynamic loadedNewMeeting;
    _meetings = [];
    if (meetingObject.length > 0) {
      for (var meetingJSON in meetingObject) {
        // var meeting = parseSingleGroup(meetingJSON);
        final newMeeting = meetingJSON;

        loadedMeetings.add(newMeeting);
        loadedNewMeeting = newMeeting;
      }
    }
    if (replace) {
      _meetings.removeAt(position);
      _meetings.insert(position, loadedNewMeeting);
    } else if (isNewMeeting) {
      _meetings.add(loadedNewMeeting);
    } else {
      _meetings = loadedMeetings;
    }
    notifyListeners();
  }

  Future<void> _stripAndAddAccounts(Map<String, dynamic> accounts) async {
    int position = 0;
    final groupBankAccounts = accounts['bank_accounts'] as List<dynamic>;
    position = addAccounts(groupBankAccounts, 1, position);
    final groupSaccoAccounts = accounts['sacco_accounts'] as List<dynamic>;
    position = addAccounts(groupSaccoAccounts, 2, position);
    final groupMobileMoneyAccounts =
        accounts['mobile_money_accounts'] as List<dynamic>;
    position = addAccounts(groupMobileMoneyAccounts, 3, position);
    final groupPettyCashAccountsAccounts =
        accounts['petty_cash_accounts'] as List<dynamic>;
    position = addAccounts(groupPettyCashAccountsAccounts, 4, position);
  }

  Future<void> fetchAccounts() async {
    final url = EndpointUrl.GET_GROUP_ACCOUNT_OPTIONS;
    List<dynamic> _localData = [];
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        _localData = await dbHelper.queryWhere(
          table: DatabaseHelper.groupAccountsTable,
          column: "group_id",
          whereArguments: [_currentGroupId],
          orderBy: 'modified_on',
          order: 'DESC',
        );
        if (_localData.length > 0) {
          try {
            await _stripAndAddAccounts(jsonDecode(_localData[0]["value"]));
          } catch (e) {
            throw CustomException(message: ERROR_MESSAGE);
          }
        } else {
          final response = await PostToServer.post(postRequest, url);
          _accounts = []; //clear accounts
          _allAccounts = []; //clear all accounts
          Map<String, dynamic> accounts = {
            "group_id": currentGroupId,
            "value": jsonEncode(response['accounts']),
            "modified_on": DateTime.now().millisecondsSinceEpoch,
          };
          await _stripAndAddAccounts(response['accounts']);
          await dbHelper.deleteMultiple(
              [int.parse(_currentGroupId)], DatabaseHelper.groupAccountsTable);
          await dbHelper.insert(accounts, DatabaseHelper.groupAccountsTable);
        }
      } on CustomException catch (error) {
        if (error.status == ErrorStatusCode.statusNoInternet) {
          _stripAndAddAccounts({});
        } else {
          throw CustomException(message: error.message, status: error.status);
        }
      } catch (error) {
        if (error.status == ErrorStatusCode.statusNoInternet) {
          _stripAndAddAccounts({});
        } else {
          throw CustomException(message: ERROR_MESSAGE);
        }
      }
    } on CustomException catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        _stripAndAddAccounts({});
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        _stripAndAddAccounts({});
      } else {
        throw CustomException(message: ERROR_MESSAGE);
      }
    }
  }

  Future<dynamic> fetchBankAccount(int bankAccountId) async {
    final url = EndpointUrl.GET_BANK_ACCOUNTS;
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
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<dynamic> fetchSaccoAccount(int saccoAccountId) async {
    final url = EndpointUrl.GET_SACCO_ACCOUNTS;
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
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<dynamic> fetchMobileMoneyAccount(int mobileMoneyAccountId) async {
    final url = EndpointUrl.GET_MOBILE_MONEY_ACCOUNTS;
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
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<dynamic> fetchPettyCashAccount(int pettyCashAccountId) async {
    final url = EndpointUrl.GET_PETTY_CASH_ACCOUNTS;
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
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchContributions() async {
    final url = EndpointUrl.GET_GROUP_CONTRIBUTIONS;
    List<dynamic> _localData = [];
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        _localData = await dbHelper.queryWhere(
          table: DatabaseHelper.contributionsTable,
          column: "group_id",
          whereArguments: [_currentGroupId],
          orderBy: 'name',
          order: 'DESC',
        );
        if (_localData.length > 0) {
          addContributions(groupContributions: _localData, isLocal: true);
        } else {
          try {
            final response = await PostToServer.post(postRequest, url);
            _contributions = []; //clear
            final groupContributions =
                response['contributions'] as List<dynamic>;
            addContributions(groupContributions: groupContributions);
          } on CustomException catch (error) {
            if (error.status == ErrorStatusCode.statusNoInternet) {
              addContributions(groupContributions: _localData, isLocal: true);
            } else {
              throw CustomException(
                  message: error.message, status: error.status);
            }
          } catch (error) {
            if (error.status == ErrorStatusCode.statusNoInternet) {
              addContributions(groupContributions: _localData, isLocal: true);
            } else {
              throw CustomException(message: ERROR_MESSAGE);
            }
          }
        }
      } on CustomException catch (error) {
        if (error.status == ErrorStatusCode.statusNoInternet) {
          addContributions(groupContributions: _localData, isLocal: true);
        } else {
          throw CustomException(message: error.message, status: error.status);
        }
      } catch (error) {
        if (error.status == ErrorStatusCode.statusNoInternet) {
          addContributions(groupContributions: _localData, isLocal: true);
        } else {
          throw CustomException(message: ERROR_MESSAGE);
        }
      }
    } on CustomException catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        addContributions(groupContributions: _localData, isLocal: true);
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchPayContributions() async {
    final url = EndpointUrl.GET_GROUP_PAY_CONTRIBUTIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      List<dynamic> _localData = [];
      _localData = await dbHelper.queryWhere(
        table: DatabaseHelper.payContributionsTable,
        column: "group_id",
        whereArguments: [_currentGroupId],
        orderBy: 'name',
        order: 'DESC',
      );
      if (_localData.length > 0) {
        addPayContributions(groupContributions: _localData, isLocal: true);
      } else {
        try {
          final response = await PostToServer.post(postRequest, url);
          _payContributions = []; //clear
          final groupContributions = response['contributions'] as List<dynamic>;
          addPayContributions(groupContributions: groupContributions);
        } on CustomException catch (error) {
          throw CustomException(message: error.message, status: error.status);
        } catch (error) {
          throw CustomException(message: ERROR_MESSAGE);
        }
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchExpenses() async {
    final url = EndpointUrl.GET_EXPENSES_SUMMARY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _expenses = []; //clear accounts
        final groupExpenses = response['data']['expenses'] as List<dynamic>;
        parseExpenseData(groupExpenses);
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
    final url = EndpointUrl.GET_GROUP_FINE_OPTIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      List<dynamic> _localData = [];
      _localData = await dbHelper.queryWhere(
        table: DatabaseHelper.fineCategories,
        column: "group_id",
        whereArguments: [_currentGroupId],
        orderBy: 'name',
        order: 'DESC',
      );
      // if (_localData.length > 0) {
      //   addFineTypes(groupFineTypes: _localData, isLocal: true);
      // } else {
      try {
        final response = await PostToServer.post(postRequest, url);
        _fineTypes = []; //clear accounts
        final groupFineTypes =
            response['fine_category_options'] as List<dynamic>;
        addFineTypes(groupFineTypes: groupFineTypes, isLocal: false);
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
      // }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchExpenseCategories() async {
    final url = EndpointUrl.GET_GROUP_EXPENSE_CATEGORIES;
    List<Map<String, dynamic>> _localData = [];
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      _localData = await dbHelper.queryWhere(
        table: DatabaseHelper.expenseCategoriesTable,
        column: "group_id",
        whereArguments: [_currentGroupId],
        orderBy: 'modified_on',
        order: 'ASC',
      );
      _expenseCategories = [];
      if (_localData.length > 0) {
        addExpenseCategories(
            expenseCategories: jsonDecode(_localData[0]['value']));
      } else {
        try {
          final response = await PostToServer.post(postRequest, url);
          final expenseCategoriesTypes =
              response['expense_categories'] as List<dynamic>;
          Map<String, dynamic> expenseCategoriesMap = {
            "group_id": currentGroupId,
            "value": jsonEncode(expenseCategoriesTypes),
            "modified_on": DateTime.now().millisecondsSinceEpoch,
          };
          await dbHelper.deleteMultiple([int.parse(_currentGroupId)],
              DatabaseHelper.expenseCategoriesTable);
          await dbHelper.insert(
              expenseCategoriesMap, DatabaseHelper.expenseCategoriesTable);
          addExpenseCategories(expenseCategories: expenseCategoriesTypes);
        } on CustomException catch (error) {
          if (error.status == ErrorStatusCode.statusNoInternet) {
            addExpenseCategories(expenseCategories: _localData);
          } else {
            throw CustomException(message: error.message, status: error.status);
          }
        } catch (error) {
          if (error.status == ErrorStatusCode.statusNoInternet) {
            addExpenseCategories(expenseCategories: _localData);
          } else {
            throw CustomException(message: ERROR_MESSAGE);
          }
        }
      }
    } on CustomException catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        addExpenseCategories(expenseCategories: _localData);
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      if (error.status && error.status == ErrorStatusCode.statusNoInternet) {
        addExpenseCategories(expenseCategories: _localData);
      } else {
        throw CustomException(message: ERROR_MESSAGE);
      }
    }
  }

  Future<void> fetchIncomeCategories() async {
    final url = EndpointUrl.GET_GROUP_INCOME_CATEGORIES;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
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
      throw CustomException(message: error.toString(), status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchDetailedIncomeCategories() async {
    final url = EndpointUrl.GET_GROUP_INCOME_CATEGORIES_LIST;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _detailedIncomeCategories = []; //clear accounts
        final incomeCategoriesTypes =
            response['income_categories'] as List<dynamic>;
        addDetailedIncomeCategories(incomeCategoriesTypes);
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

  Future<void> fetchAssetCategories() async {
    final url = EndpointUrl.GET_GROUP_ASSET_CATEGORIES;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _assetCategories = []; //clear accounts
        final incomeCategoriesTypes =
            response['asset_categories'] as List<dynamic>;
        addAssetCategories(incomeCategoriesTypes);
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

  Future<void> fetchGroupAssetOptions() async {
    final url = EndpointUrl.GET_GROUP_ASSET_OPTIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        print(response);
        _groupAssetOptions = []; //clear accounts
        final groupAssetOptionsData =
            response['group_asset_options'] as List<dynamic>;
        addGroupAssetOptions(groupAssetOptionsData);
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

  Future<void> fetchGroupStockOptions() async {
    final url = EndpointUrl.GET_GROUP_STOCK_OPTIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        print(response);
        _groupStockOptions = []; //clear accounts
        final groupStockOptionsData = response['group_stocks'] as List<dynamic>;
        addGroupStockOptions(groupStockOptionsData);
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

  Future<void> fetchMoneyMarketInvestmentOptions() async {
    final url = EndpointUrl.GET_GROUP_MONEY_MARKET_INVESTMENT_OPTIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        print(response);
        _groupMoneyMarketInvestmentOptions = []; //clear accounts
        final groupMoneyMarketInvestmentOptionsData =
            response['investments'] as List<dynamic>;
        addGroupMoneyMarketInvestmentOptions(
            groupMoneyMarketInvestmentOptionsData);
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

  Future<void> fetchBorrowerOptions() async {
    final url = EndpointUrl.GET_GROUP_BORROWER_OPTIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        print(response);
        _groupBorrowerOptions = []; //clear accounts
        final groupBorrowerOptionsData = response['debtors'] as List<dynamic>;
        addGroupBorrowerOptions(groupBorrowerOptionsData);
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
    final url = EndpointUrl.GET_GROUP_LOAN_TYPES;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });

      try {
        // ignore: unused_local_variable
        List<dynamic> _localData = [];
        _localData = await dbHelper.queryWhere(
          table: DatabaseHelper.loanTypesTable,
          column: "group_id",
          whereArguments: [_currentGroupId],
          orderBy: 'modified_on',
          order: 'DESC',
        );
        // ignore: todo
        // TODO: handle reseting of data.
        // if (_localData.length > 0 &&
        //     jsonDecode(_localData[0]['value']).length > 0) {
        //   addLoanTypes(jsonDecode(_localData[0]['value']));
        // } else {
        final response = await PostToServer.post(postRequest, url);
        _loanTypes = []; //clear
        final groupLoanTypes = response['loan_types'] as List<dynamic>;
        Map<String, dynamic> loanTypesMap = {
          "group_id": currentGroupId,
          "value": jsonEncode(groupLoanTypes),
          "modified_on": DateTime.now().millisecondsSinceEpoch,
        };
        await dbHelper.deleteMultiple(
            [int.parse(_currentGroupId)], DatabaseHelper.loanTypesTable);
        await dbHelper.insert(loanTypesMap, DatabaseHelper.loanTypesTable);
        addLoanTypes(groupLoanTypes);
        //}
      } on CustomException catch (error) {
        if (error.status == ErrorStatusCode.statusNoInternet) {
          //=== BEGIN: OFFLINE PLUG
          dynamic _localData = await getLocalData('loanTypes');
          if (_localData['value'] != null) {
            List<dynamic> _loanTypesData = jsonDecode(_localData['value']);
            _loanTypes = []; //clear
            addLoanTypes(_loanTypesData);
          }
          //=== END: OFFLINE PLUG
        } else {
          throw CustomException(message: error.message, status: error.status);
        }
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        //=== BEGIN: OFFLINE PLUG
        dynamic _localData = await getLocalData('loanTypes');
        if (_localData['value'] != null) {
          List<dynamic> _loanTypesData = jsonDecode(_localData['value']);
          _loanTypes = []; //clear
          addLoanTypes(_loanTypesData);
        }
        //=== END: OFFLINE PLUG
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> _fetchOfflineMembers() async {
    //=== BEGIN: OFFLINE PLUG
    dynamic _localData = await getLocalMembers(int.parse(_currentGroupId));
    if (_localData['value'].length > 0) {
      List<dynamic> rows = [];
      final _tempMembers = _localData['value'] as List<dynamic>;
      _tempMembers.forEach((m) {
        rows.add({
          "group_id": int.parse(_currentGroupId),
          "id": int.parse(m['id']),
          "user_id": int.parse(m['user_id']),
          "name": m['name'],
          "avatar": (m['avatar'] != null) ? m['avatar'] : '',
          "identity": m['identity'],
        });
      });
      _members = []; //clear
      addMembers(groupMembers: rows);
    }
    //=== END: OFFLINE PLUG
  }

  Future<void> fetchMembers() async {
    final url = EndpointUrl.GET_GROUP_MEMBERS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        // ignore: unused_local_variable
        List<dynamic> _localData = [];
        _localData = await dbHelper.queryWhere(
          table: DatabaseHelper.membersTable,
          column: "group_id",
          whereArguments: [_currentGroupId],
          orderBy: 'name',
          order: 'ASC',
        );
        // if (_localData.length > 0) {
        //   addMembers(groupMembers: _localData, isLocal: true);
        // } else {
        final response = await PostToServer.post(postRequest, url);
        _members = [];
        final _tempMembers = response['members'] as List<dynamic>;

        List<dynamic> rows = [];
        _tempMembers.forEach((m) {
          rows.add({
            "group_id": int.parse(_currentGroupId),
            "id": int.parse(m['id']),
            "user_id": int.parse(m['user_id']),
            "name": m['name'],
            "avatar": (m['avatar'] != null) ? m['avatar'] : '',
            "identity": m['identity'],
            "modified_on": DateTime.now().millisecondsSinceEpoch,
          });
        });
        addMembers(groupMembers: _tempMembers);
        await dbHelper.deleteMultiple(
            [int.parse(_currentGroupId)], DatabaseHelper.membersTable);
        await insertManyToLocalDb(
          DatabaseHelper.membersTable,
          rows,
        );
        // }
      } on CustomException catch (error) {
        if (error.status == ErrorStatusCode.statusNoInternet) {
          _fetchOfflineMembers();
        } else {
          throw CustomException(message: error.message, status: error.status);
        }
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        _fetchOfflineMembers();
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchGroupDepositors() async {
    final url = EndpointUrl.GET_GROUP_DEPOSITOR_OPTIONS;
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
      if (error.status == ErrorStatusCode.statusNoInternet) {
        throw CustomException(message: ERROR_MESSAGE);
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchUnAssignedGroupRoles() async {
    final url = EndpointUrl.GET_GROUP_UNASSIGNED_ROLES;
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
    final url = EndpointUrl.ADD_MEMBERS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "members": members
      });
      try {
        await PostToServer.post(postRequest, url);
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

  Future<dynamic> getContributionDetails(String id) async {
    final url = EndpointUrl.GET_CONTRIBUTION_DETAILS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": id,
      });
      try {
        return await PostToServer.post(postRequest, url);
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

  Future<dynamic> addContributionStepOne(
      Map<String, dynamic> formData, bool isEditMode) async {
    var url = EndpointUrl.CREATE_CONTRIBUTION_SETTING;
    if (isEditMode) {
      url = EndpointUrl.EDIT_CONTRIBUTION_SETTING;
    }
    try {
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        return await PostToServer.post(postRequest, url);
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

  Future<dynamic> addContributionStepTwo(Map<String, dynamic> formData) async {
    final url = EndpointUrl.ADD_MEMBERS_CONTRIBUTION_SETTING;
    try {
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        return await PostToServer.post(postRequest, url);
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

  Future<dynamic> addContributionStepThree(
      Map<String, dynamic> formData) async {
    final url = EndpointUrl.FINE_CONTRIBUTION_SETTING;
    try {
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        return await PostToServer.post(postRequest, url);
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

  Future<dynamic> getLoanDetails(String id) async {
    final url = EndpointUrl.GET_LOAN_TYPE_DETAILS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": id,
      });
      try {
        return await PostToServer.post(postRequest, url);
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

  Future<bool> completeGroupSetup(String referralCode) async {
    final url = EndpointUrl.COMPLETE_GROUP_SETUP;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "referral_code": referralCode,
      });
      try {
        await PostToServer.post(postRequest, url);
        return true;
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

  Future<dynamic> addLoanTypeStepOne(
      Map<String, dynamic> formData, bool isEditMode) async {
    var url = EndpointUrl.CREATE_LOAN_TYPE;
    if (isEditMode) {
      url = EndpointUrl.EDIT_LOAN_TYPE;
    }
    try {
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        return await PostToServer.post(postRequest, url);
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

  Future<dynamic> addLoanTypeStepTwo(Map<String, dynamic> formData) async {
    var url = EndpointUrl.UPDATE_LOAN_TYPE_FINES;
    try {
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        return await PostToServer.post(postRequest, url);
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

  Future<dynamic> addLoanTypeStepThree(Map<String, dynamic> formData) async {
    var url = EndpointUrl.UPDATE_LOAN_TYPE_DETAILS;
    try {
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        return await PostToServer.post(postRequest, url);
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

  Future<void> updateLoanType(
      {@required String id, @required SettingActions action}) async {
    String url = EndpointUrl.LOAN_TYPES_UNHIDE;
    if (action == SettingActions.actionHide) {
      url = EndpointUrl.LOAN_TYPES_HIDE;
    } else if (action == SettingActions.actionDelete) {
      url = EndpointUrl.LOAN_TYPES_DELETE;
    }

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": id,
      });

      try {
        await PostToServer.post(postRequest, url);
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
    final url = EndpointUrl.GET_COUNTRY_LIST;
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
    final url = EndpointUrl.GET_CURRENCY_LIST;
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
    final url = EndpointUrl.UPDATE_GROUP_NAME;
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
    final url = EndpointUrl.UPDATE_GROUP_EMAIL;
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
    final url = EndpointUrl.UPDATE_GROUP_PHONE_NUMBER;
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
    final url = EndpointUrl.UPDATE_GROUP_COUNTRY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "country_id": countryId,
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

  Future<dynamic> updateGroupCurrency(int currencyId) async {
    final url = EndpointUrl.UPDATE_GROUP_CURRENCY;
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
    final url = EndpointUrl.UPDATE_GROUP_SETTINGS;

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
    final url = EndpointUrl.GET_BANKS;
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
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchBankBranchOptions(String bankId) async {
    final url = EndpointUrl.GET_BANK_BRANCHES;
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
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<void> fetchMobileMoneyProviderOptions() async {
    final url = EndpointUrl.GE_MOBILE_PROVIDERS;
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
    final url = EndpointUrl.GET_SACCOS;
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
    final url = EndpointUrl.GET_SACCO_BRANCHES;
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
    final url = EndpointUrl.ADD_BANK_ACCOUNT;
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
    final url = EndpointUrl.EDIT_BANK_ACCOUNT;
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
    final url = EndpointUrl.ADD_SACCO_ACCOUNT;
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
    final url = EndpointUrl.EDIT_SACCO_ACCOUNT;
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
    final url = EndpointUrl.ADD_MOBILE_MONEY_ACCOUNT;
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
    final url = EndpointUrl.EDIT_MOBILE_MONEY_ACCOUNT;
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
    final url = EndpointUrl.ADD_PETTY_CASH_ACCOUNT;
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
    final url = EndpointUrl.EDIT_PETTY_CASH_ACCOUNT;
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

  Future<void> createFineCategory({
    String name,
    String amount,
  }) async {
    final url = EndpointUrl.CREATE_FINE_CATEGORY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": "0",
        "name": name,
        "amount": amount,
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchFineTypes();
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

  Future<void> editFineCategory({
    String id,
    String name,
    String amount,
  }) async {
    final url = EndpointUrl.EDIT_FINE_CATEGORY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": id,
        "name": name,
        "amount": amount,
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchFineTypes();
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

  Future<void> createIncomeCategory(
      {@required String name,
      @required String description,
      String id,
      @required SettingActions action}) async {
    String url = EndpointUrl.ADD_INCOME_CATEGORY;
    if (action == SettingActions.actionEdit) {
      url = EndpointUrl.EDIT_INCOME_CATEGORY;
    } else if (action == SettingActions.actionHide) {
      url = EndpointUrl.INCOME_CATEGORIES_HIDE;
    } else if (action == SettingActions.actionUnHide) {
      url = EndpointUrl.INCOME_CATEGORIES_UNHIDE;
    } else if (action == SettingActions.actionDelete) {
      url = EndpointUrl.INCOME_CATEGORIES_DELETE;
    }

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": action != SettingActions.actionAdd ? id : "",
        "name": name,
        "description": description,
      });

      try {
        await PostToServer.post(postRequest, url);
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

  Future<void> createAssetCategory(
      {@required String name,
      @required String description,
      String id,
      @required SettingActions action}) async {
    String url = EndpointUrl.CREATE_ASSET_CATEGORY;
    if (action == SettingActions.actionEdit) {
      url = EndpointUrl.EDIT_ASSET_CATEGORY;
    } else if (action == SettingActions.actionHide) {
      url = EndpointUrl.ASSET_CATEGORIES_HIDE;
    } else if (action == SettingActions.actionUnHide) {
      url = EndpointUrl.ASSET_CATEGORIES_UNHIDE;
    }

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": action != SettingActions.actionAdd ? id : "",
        "name": name,
        "description": description,
      });

      try {
        await PostToServer.post(postRequest, url);
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

  Future<dynamic> fetchFineCategory(int fineCategoryId) async {
    final url = EndpointUrl.GET_GROUP_FINE_CATEGORIES_LIST;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final groupFineCategories =
            response['fine_categories'] as List<dynamic>;
        for (int i = 0; i < groupFineCategories.length; i++) {
          if (groupFineCategories[i]['id'].toString() ==
              fineCategoryId.toString()) {
            return groupFineCategories[i];
          }
        }
        return null;
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

  Future<dynamic> fetchFineCategories() async {
    final url = EndpointUrl.GET_GROUP_FINE_CATEGORIES_LIST;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        List<dynamic> groupFineCategories = [];
        //=== BEGIN: OFFLINE PLUG
        //=== Check if record exists...
        bool _exists = await entryExistsInDb(
          DatabaseHelper.dataTable,
          "section",
          "fine_categories",
        );
        //=== ...if it doesn't exist, insert it.
        if (!_exists) {
          await insertToLocalDb(
            DatabaseHelper.dataTable,
            {
              "section": "fine_categories",
              "value": jsonEncode(response['fine_categories']),
              "modified_on": DateTime.now().millisecondsSinceEpoch,
            },
          );
          groupFineCategories = response['fine_categories'];
        }
        //=== If it does exist, update it.
        else {
          dynamic _fineCategories = await getLocalData('fine_categories');
          await updateInLocalDb(
            DatabaseHelper.dataTable,
            {
              "id": _fineCategories['id'],
              "section": "fine_categories",
              "value": jsonEncode(response['fine_categories']),
              "modified_on": DateTime.now().millisecondsSinceEpoch,
            },
          );
          groupFineCategories = _fineCategories['value'];
        }
        //=== END: OFFLINE PLUG
        return groupFineCategories;
      } on CustomException catch (error) {
        if (error.status == ErrorStatusCode.statusNoInternet) {
          //=== BEGIN: OFFLINE PLUG
          dynamic _localData = await getLocalData('fine_categories');
          if (_localData['value'] != null) {
            final fineCategories = _localData['value'] as List<dynamic>;
            return fineCategories;
          }
          //=== END: OFFLINE PLUG
        } else {
          throw CustomException(message: error.message, status: error.status);
        }
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        //=== BEGIN: OFFLINE PLUG
        dynamic _localData = await getLocalData('fine_categories');
        if (_localData['value'] != null) {
          final fineCategories = _localData['value'] as List<dynamic>;
          return fineCategories;
        }
        //=== END: OFFLINE PLUG
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<dynamic> fetchExpenseCategory(int categoryId) async {
    final url = EndpointUrl.GET_GROUP_EXPENSE_CATEGORIES;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final expenseCategoriesTypes =
            response['expense_categories'] as List<dynamic>;
        for (int i = 0; i < expenseCategoriesTypes.length; i++) {
          if (expenseCategoriesTypes[i]['id'].toString() ==
              categoryId.toString()) {
            return expenseCategoriesTypes[i];
          }
        }
        return null;
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

  Future<void> createExpenseCategory({
    String name,
    String description,
  }) async {
    final url = EndpointUrl.CREATE_EXPENSE_CATEGORY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": "0",
        "name": name,
        "description": description,
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchExpenseCategories();
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

  Future<void> editExpenseCategory({
    String id,
    String name,
    String description,
  }) async {
    final url = EndpointUrl.EDIT_EXPENSE_CATEGORY;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "id": id,
        "name": name,
        "description": description,
      });

      try {
        await PostToServer.post(postRequest, url);
        await fetchExpenseCategories();
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

  Future<void> fetchGroupNotifications() async {
    final url = EndpointUrl.GET_GROUP_NOTIFICATIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "lower_limit": 0,
        "upper_limit": 50
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        _notifications = []; //clear
        final notifications = response['notifications'] as List<dynamic>;
        addNotification(notifications);
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

  Future<String> fetchNotificationCount(String bankId) async {
    final url = EndpointUrl.GET_GROUP_NOTIFICATIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        return response['all_notification_counts'].toString();
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

  Future<void> markNotificationAsRead(String notificationId) async {
    final url = EndpointUrl.MARK_AS_READ_NOTIFICATION;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "notification_id": notificationId,
      });
      try {
        await PostToServer.post(postRequest, url);
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

  Future<void> markAllNotificationsAsRead() async {
    final url = EndpointUrl.MARK_ALL_AS_READ_NOTIFICATION;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "mark_all_notifications_as_read": 1,
      });
      try {
        await PostToServer.post(postRequest, url);
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
    final url = EndpointUrl.GET_ACCOUNT_BALANCES;

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
    final url = EndpointUrl.GET_TRANSACTION_STATEMENT;

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

  Future<void> fetchGroupBankLoans() async {
    //addBankLoans
    final url = EndpointUrl.GET_GROUP_BANK_LOAN_OPTIONS;
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final data = response['loans'] as List<dynamic>;
        addBankLoans(data);
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

  Future<void> fetchGroupMembersOngoingLoans() async {
    final url = EndpointUrl.GET_MEMBERs_LOAN_TYPE_OPTIONS;
    List<dynamic> _localData = [];
    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
      });
      _localData = await dbHelper.queryMultipleWhere(
        table: DatabaseHelper.memberLoanOptions,
        columns: ["group_id", "user_id"],
        whereArguments: [_currentGroupId, _userId],
        orderBy: 'id',
        order: 'DESC',
      );
      if (_localData.length > 0) {
        addOngoingMemberLoans(memberLoansList: _localData, isLocal: true);
      } else {
        try {
          final response = await PostToServer.post(postRequest, url);
          final data = response['loans'] as List<dynamic>;
          addOngoingMemberLoans(memberLoansList: data);
        } on CustomException catch (error) {
          if (error.status == ErrorStatusCode.statusNoInternet) {
            addOngoingMemberLoans(memberLoansList: _localData, isLocal: true);
          } else {
            throw CustomException(message: error.message, status: error.status);
          }
        } catch (error) {
          if (error.status == ErrorStatusCode.statusNoInternet) {
            addOngoingMemberLoans(memberLoansList: _localData, isLocal: true);
          } else {
            throw CustomException(message: ERROR_MESSAGE);
          }
        }
      }
    } on CustomException catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        addOngoingMemberLoans(memberLoansList: _localData, isLocal: true);
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        addOngoingMemberLoans(memberLoansList: _localData, isLocal: true);
      } else {
        throw CustomException(message: ERROR_MESSAGE);
      }
    }
  }

  ///*************************Contributions Summary and Fines Summary*****************************/

  Future<dynamic> getGroupContributionSummary() async {
    final url = EndpointUrl.GET_CONTRIBUTION_SUMMARY;
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
    final url = EndpointUrl.GET_FINE_SUMMARY;
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
    final url = EndpointUrl.GET_EXPENSES_SUMMARY;
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
    final url = EndpointUrl.GET_LOANS_SUMMARY;

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
        addContributionStatement(statementFlag, response);
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
    final url = EndpointUrl.GET_GROUP_LOAN_LIST;
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
    final url = EndpointUrl.GET_LOAN_STATEMENT;

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

  Future<void> fetchDeposits(String sortOption, List<int> filterList,
      List<String> memberList, int lowerLimit) async {
    final url = EndpointUrl.GET_DEPOSITS_LIST;

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "sort_by": sortOption,
        "status": filterList,
        "members": memberList,
        "lower_limit": lowerLimit,
        "upper_limit": lowerLimit + 20
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        final data = response['deposits'] as List<dynamic>;
        if (lowerLimit == 0) _depositList = [];
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

  Future<void> fetchWithdrawals(String sortOption, List<int> filterList,
      List<String> memberList, int lowerLimit) async {
    final url = EndpointUrl.GET_GROUP_WITHDRAWAL_LIST;

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "sort_by": sortOption,
        "status": filterList,
        "members": memberList,
        "lower_limit": lowerLimit,
        "upper_limit": lowerLimit + 20
      });
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

  Future<void> fetchWithdrawalRequests(String sortOption, List<int> filterList,
      List<String> memberList, int lowerLimit) async {
    final url = EndpointUrl.GET_GROUP_WITHDRAWAL_REQUESTS;

    try {
      final postRequest = json.encode({
        "user_id": _userId,
        "group_id": _currentGroupId,
        "sort_by": sortOption,
        "status": filterList,
        //"upper_limit": lowerLimit + 20,
        //"lower_limit": 0
      });
      try {
        final response = await PostToServer.post(postRequest, url);
        // log(response.toString());
        final data = response['posts'] as List<dynamic>;
        addWithdrawalRequestList(data);
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

  Future<void> fetchWithdrawalRequestDetails(int id) async {
    final url = EndpointUrl.VIEW_WITHDRAWAL_REQUEST;

    try {
      final postRequest = json
          .encode({"user_id": _userId, "group_id": _currentGroupId, "id": id});
      try {
        final response = await PostToServer.post(postRequest, url);
        // log(response.toString());
        final data = response as dynamic;
        addWithdrawalRequestDetails(data);
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

  Future<void> respondToWithdrawalRequest(Map<String, String> formData) async {
    final url = EndpointUrl.RESPOND_TO_WITHDRAWAL_REQUEST;

    try {
      formData["user_id"] = _userId;
      formData["group_id"] = _currentGroupId;
      final postRequest = json.encode(formData);
      try {
        await PostToServer.post(postRequest, url);
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

  Future<void> cancelWithdrawalRequest(Map<String, String> formData) async {
    final url = EndpointUrl.CANCEL_WITHDRAWAL_REQUEST;

    try {
      formData["user_id"] = _userId;
      formData["group_id"] = _currentGroupId;
      final postRequest = json.encode(formData);
      try {
        await PostToServer.post(postRequest, url);
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

  // ignore: todo
  /// ********************TODO: consolidate with fetchAccounts()********************/
  Future<void> temporaryFetchAccounts() async {
    final url = EndpointUrl.GET_GROUP_ACCOUNT_OPTIONS;
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

  ///************************Load Form initial Data**********/

  Future<Map<String, dynamic>> loadInitialFormData(
      {bool contr = false,
      bool acc = false,
      bool member = false,
      bool incomeCats = false,
      bool depositor = false,
      bool fineOptions = false,
      bool exp = false,
      bool bankLoans = false,
      bool loanTypes = false,
      bool memberOngoingLoans = false,
      bool groupAssets = false,
      bool groupStocks = false,
      bool moneyMarketInvestments = false,
      bool borrowers = false}) async {
    List<NamesListItem> contributionOptions = [],
        accountOptions = [],
        memberOptions = [],
        finesOptions = [],
        depositorOptions = [],
        incomeCategoryOptions = [],
        expenseCategories = [],
        bankLoansOptions = [],
        loanTypeOptions = [],
        memberOngoingLoanOptions = [],
        groupAssetOptions = [],
        groupStockOptions = [],
        moneyMarketInvestmentOptions = [],
        borrowerOptions = [];
    if (contr) {
      if (_payContributions.length == 0) {
        await fetchPayContributions();
      }
      _payContributions
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
          .map((member) => memberOptions.add(NamesListItem(
              id: int.tryParse(member.id),
              name: member.name,
              identity: member.identity)))
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

    if (exp) {
      if (_expenseCategories.length == 0) {
        await fetchExpenseCategories();
      }
      _expenseCategories
          .map((expense) => expenseCategories.add(
              NamesListItem(id: int.tryParse(expense.id), name: expense.name)))
          .toList();
    }

    if (loanTypes) {
      if (_loanTypes.length == 0) {
        await fetchLoanTypes();
      }
      _loanTypes
          .map((loanType) => loanTypeOptions.add(NamesListItem(
              id: int.tryParse(loanType.id), name: loanType.name)))
          .toList();
    }

    if (bankLoans) {
      if (_bankLoans.length == 0) {
        await fetchGroupBankLoans();
      }
      _bankLoans
          .map((bankLoan) => bankLoansOptions.add(NamesListItem(
              id: int.tryParse(bankLoan.id),
              name:
                  "${bankLoan.description} of ${getCurrentGroup().groupCurrency} ${currencyFormat.format(bankLoan.amount)} balance ${getCurrentGroup().groupCurrency} ${currencyFormat.format(bankLoan.balance)}")))
          .toList();
    }
    if (memberOngoingLoans) {
      if (_ongoingMemberLoans.length == 0 && _loanPulled == false) {
        await fetchGroupMembersOngoingLoans();
      }

      for (var loan in _ongoingMemberLoans) {
        if (loan.isSelected) {
          memberOngoingLoanOptions.add(NamesListItem(
              id: int.tryParse(loan.id),
              name:
                  "${loan.loanType} of ${getCurrentGroup().groupCurrency} ${currencyFormat.format(loan.amount)} balance ${getCurrentGroup().groupCurrency} ${currencyFormat.format(loan.balance)}"));
        }
      }
    }
    if (groupAssets) {
      if (_groupAssetOptions.length == 0) {
        await fetchGroupAssetOptions();
      }
      _groupAssetOptions
          .map((groupAssetOption) => groupAssetOptions.add(NamesListItem(
              id: int.tryParse(groupAssetOption.id),
              name: groupAssetOption.name)))
          .toList();
    }

    if (groupStocks) {
      if (_groupStockOptions.length == 0) {
        await fetchGroupStockOptions();
      }
      _groupStockOptions
          .map((groupStockOption) => groupStockOptions.add(NamesListItem(
              id: int.tryParse(groupStockOption.id),
              name: groupStockOption.name)))
          .toList();
    }

    if (moneyMarketInvestments) {
      if (_groupMoneyMarketInvestmentOptions.length == 0) {
        await fetchMoneyMarketInvestmentOptions();
      }

      _groupMoneyMarketInvestmentOptions
          .map((groupMoneyMarketOption) => moneyMarketInvestmentOptions.add(
              NamesListItem(
                  id: int.tryParse(groupMoneyMarketOption.id),
                  name: groupMoneyMarketOption.name)))
          .toList();
    }

    if (borrowers) {
      if (_groupBorrowerOptions.length == 0) {
        await fetchBorrowerOptions();
      }

      _groupBorrowerOptions
          .map((borrowerOption) => borrowerOptions.add(NamesListItem(
              id: int.tryParse(borrowerOption.id), name: borrowerOption.name)))
          .toList();
    }

    Map<String, dynamic> result = {
      "contributionOptions": contributionOptions,
      "accountOptions": accountOptions,
      "memberOptions": memberOptions,
      "finesOptions": finesOptions,
      "incomeCategoryOptions": incomeCategoryOptions,
      "depositorOptions": depositorOptions,
      'expenseCategories': expenseCategories,
      'bankLoansOptions': bankLoansOptions,
      'loanTypeOptions': loanTypeOptions,
      'memberOngoingLoanOptions': memberOngoingLoanOptions,
      'groupAssetOptions': groupAssetOptions,
      'groupStockOptions': groupStockOptions,
      'moneyMarketInvestmentOptions': moneyMarketInvestmentOptions,
      'borrowerOptions': borrowerOptions
    };
    return result;
  }

  ///****************************Transaction****************/

  Future<String> recordContributionPayments(
      Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.NEW_RECORD_CONTRIBUTION_PAYMENTS;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = getAccountFormId(formData['account_id']);

      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        return response["message"].toString();
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

  Future<String> recordMemberLoan(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.RECORD_MEMBER_LOAN;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = getAccountFormId(formData['account_id']);
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      // log(formData.toString());
      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        return response["success"].toString();
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

  Future<String> recordLoanRepayment(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.RECORD_LOAN_REPAYMENTS;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      // log(formData.toString());
      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        return response["message"].toString();
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

  Future<String> recordFinePayments(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.NEW_RECORD_FINE_PAYMENTS;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = getAccountFormId(formData['account_id']);
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        String message = response["message"].toString();
        return message;
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

  Future<String> recordIncomePayment(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.NEW_RECORD_INCOME;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = getAccountFormId(formData['account_id']);
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        String message = response["message"].toString();
        return message;
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

  Future<String> recordMiscellaneousPayments(
      Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.NEW_RECORD_MISCELLANEOUS_PAYMENTS;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = getAccountFormId(formData['account_id']);
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        return response["message"].toString();
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

  Future<String> recordBankLoanIncome(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.RECORD_BANK_LOAN;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = getAccountFormId(formData['account_id']);

      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        return response["message"].toString();
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

  Future<String> recordExpensePayment(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.NEW_RECORD_EXPENSES;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = getAccountFormId(formData['account_id']);
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";
      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        return response["message"].toString();
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

  Future<String> recordBankLoanRepayment(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.RECORD_BANK_LOAN_REPAYMENT;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = getAccountFormId(formData['account_id']);

      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        return response["message"].toString();
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

  Future<String> recordContributionRefund(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.RECORD_CONTRIBUTION_REFUND;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['account_id'] = getAccountFormId(formData['account_id']);
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        return response["message"].toString();
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

  Future<void> fineMembers(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.NEW_FINE_MEMBERS;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;

      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
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

  Future<void> recordAccountToAccountTransfer(
      Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.RECORD_FUNDS_TRANSFER;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['from_account_id'] =
          getAccountFormId(formData['from_account_id']);
      formData['to_account_id'] = getAccountFormId(formData['to_account_id']);

      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
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

  Future<void> makeGroupPayment(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.MAKE_NEW_PAYMENT;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      try {
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

  Future<String> createWithdrawalRequest(Map<String, dynamic> formData) async {
    try {
      final url = EndpointUrl.WITHDRAWALS_FUNDS_TRANSFER;
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['request_id'] =
          "${formData['request_id']}_${_userId}_$_identity";

      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);

        int status = ParseHelper.getIntFromJson(response, "status");
        if (status == 12) {
          return "-1";
        } else {
          return response["request_id"].toString();
        }
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

  // reconcile withdrawal transaction alert

  Future<String> reconcileWithdrawalTransactionAlert(
      List formDataPayload, String transactionAlertId, int position) async {
    try {
      // ignore: unused_local_variable
      final url = EndpointUrl.RECONCILE_WITHDRAWAL_TRANSACTION_ALERT;
      final Map<String, dynamic> formData = {};
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['transaction_alert_id'] = transactionAlertId;
      formData['reconcile_withdrawal_break_down'] = formDataPayload;
      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        int status = ParseHelper.getIntFromJson(response, "status");
        if (status == 12) {
          return "-1";
        } else {
          _unreconciledWithdrawals.removeAt(position);
          notifyListeners();
          return response["message"].toString();
        }
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

  // reconcile deposit transaction alert

  Future<String> reconcileDepositTransactionAlert(
      List formDataPayload, String transactionAlertId, int position) async {
    try {
      // ignore: unused_local_variable
      final url = EndpointUrl.RECONCILE_DEPOSIT_TRANSACTION_ALERT;
      final Map<String, dynamic> formData = {};
      formData['user_id'] = _userId;
      formData['group_id'] = currentGroupId;
      formData['transaction_alert_id'] = transactionAlertId;
      formData['reconcile_deposits_break_down'] = formDataPayload;
      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        int status = ParseHelper.getIntFromJson(response, "status");
        if (status == 12) {
          return "-1";
        } else {
          _unreconciledDeposits.removeAt(position);
          notifyListeners();
          return response["message"].toString();
        }
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

  // get unreconciled deposits

  Future<void> fetchGroupUnreconciledDeposits() async {
    try {
      final url = EndpointUrl.GET_GROUP_UNRECONCILED_DEPOSITS;
      Map<String, String> formData = {
        "user_id": _userId,
        "group_id": currentGroupId
      };
      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        // Reset the unreconciled deposits to empty
        _unreconciledDeposits = [];
        addUnreconciledDeposit(
            unreconciledDeposits: response['unreconciled_deposits']);
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

  // get unreconciled withdrawals

  Future<void> fetchGroupUnreconciledWithdrawals() async {
    try {
      final url = EndpointUrl.GET_GROUP_UNRECONCILED_WITHDRAWALS;
      Map<String, String> formData = {
        "user_id": _userId,
        "group_id": currentGroupId
      };

      try {
        final postRequest = json.encode(formData);
        final response = await PostToServer.post(postRequest, url);
        // Reset the unreconciled withdrawals to empty.
        _unreconciledWithdrawals = [];
        addUnreconciledWithdrawal(
            unreconciledWithdrawals: response['unreconciled_withdrawals']);
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

  void switchGroupValuesToDefault({bool removeGroups = false}) {
    if (removeGroups) {
      _groups = [];
      removeCurrentGroupId();
    }
    _groupContributionSummary = [];
    _groupFinesSummary = [];
    _accounts = [];
    _members = [];
    _meetings = [];
    _allAccounts = [];
    _contributions = [];
    _payContributions = [];
    _countryOptions = [];
    _currencyOptions = [];
    _bankOptions = [];
    _bankBranchOptions = [];
    _mobileMoneyProviderOptions = [];
    _saccoOptions = [];
    _saccoBranchOptions = [];
    _expenses = [];
    _fineTypes = [];
    _incomeCategories = [];
    _detailedIncomeCategories = [];
    _assetCategories = [];
    _groupAssetOptions = [];
    _groupStockOptions = [];
    _groupMoneyMarketInvestmentOptions = [];
    _expenseCategories = [];
    _loanTypes = [];
    _depositors = [];
    _groupContributionSummary = [];
    _groupFinesSummary = [];
    _depositList = [];
    _withdrawalList = [];
    _memberLoanList = [];
    _totalGroupContributionSummary = 0;
    _totalGroupFinesSummary = 0;
    _categorisedAccounts = [];
    _bankLoans = [];
    _contributionStatement = null;
    _fineStatement = null;
    _groupRolesStatusAndCurrentMemberStatus = null;
    _ongoingMemberLoans = [];
    _withdrawalRequests = [];
    _withdrawalRequestDetails = null;
    _loanPulled = false;
    _unreconciledDeposits = [];
  }

  //SubmitLoan Type
  Future<String> submitLoanApplication(Map<String, dynamic> formData) async {
    final url = EndpointUrl.CREATE_GROUP_LOAN_APPLICATION;
    try {
      try {
        formData['user_id'] = _userId;

        final postRequest = json.encode(formData);

        final response = await PostToServer.post(postRequest, url);

        return response['message'];
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  //loan calculator
  Future<Map<String, dynamic>> fetchGroupLoanCalculator(
      Map<String, dynamic> formData) async {
    final url = EndpointUrl.GET_GROUP_LOAN_CALCULATOR;
    try {
      formData['user_id'] = _userId;
      formData['group_id'] = _currentGroupId;
      final postRequest = json.encode(formData);
      print("post request is: " + postRequest);
      try {
        final response = await PostToServer.post(postRequest, url);
        //print("response is" + response);
        Map<String, dynamic> _loanCalculator = {
          "amortizationTotals": {
            "totalPayable": double.tryParse(response['amortization_totals']
                        ['total_payable']
                    .toString()) ??
                0.0,
            "totalPrinciple": double.tryParse(response['amortization_totals']
                        ['total_principle'] //total_principle
                    .toString()) ??
                0.0,
            "totalInterest": double.tryParse(response['amortization_totals']
                        ['total_interest'] //total_interest
                    .toString()) ??
                0.0,
          },
          "breakdown": response['breakdown']
              .map((breakdown) => {
                    "dueDate": breakdown['due_date'],
                    "amountPayable": double.tryParse(
                            breakdown['amount_payable'].toString()) ??
                        0.0,
                    "principlePayable": double.tryParse(
                            breakdown['principle_payable'].toString()) ??
                        0.0,
                    "interestPayable": double.tryParse(
                            breakdown['interest_payable'].toString()) ??
                        0.0,
                    "totalInterestPayable": double.tryParse(
                            breakdown['total_intrest_payable'].toString()) ??
                        0.0,
                    "balance":
                        double.tryParse(breakdown['balance'].toString()) ?? 0.0
                  })
              .toList(),
        };

        return _loanCalculator;
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print("error $error");
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }
}
