import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/helpers/report_helper.dart';
// import 'package:chamasoft/helpers/common.dart';

List<CategorisedAccount> getCategorisedAccounts(dynamic response) {
  List<CategorisedAccount> accounts = [];

  final groupBankAccounts = response['bank_accounts'] as List<dynamic>;
  final groupSaccoAccounts = response['sacco_accounts'] as List<dynamic>;
  final groupMobileMoneyAccounts =
      response['mobile_money_accounts'] as List<dynamic>;
  final groupPettyCashAccountsAccounts =
      response['petty_cash_accounts'] as List<dynamic>;

  if (groupBankAccounts.length > 0) {
    final bankAccountHeader =
        CategorisedAccount.header(isHeader: true, title: "Bank Accounts");
    accounts.add(bankAccountHeader);
    accounts.addAll(parseAccountsJson(groupBankAccounts, 1));
  }

  if (groupSaccoAccounts.length > 0) {
    final saccoAccountHeader =
        CategorisedAccount.header(isHeader: true, title: "Sacco Accounts");
    accounts.add(saccoAccountHeader);
    accounts.addAll(parseAccountsJson(groupSaccoAccounts, 2));
  }

  if (groupMobileMoneyAccounts.length > 0) {
    final mobileMoneyAccountHeader = CategorisedAccount.header(
        isHeader: true, title: "Mobile Money Accounts");
    accounts.add(mobileMoneyAccountHeader);
    accounts.addAll(parseAccountsJson(groupMobileMoneyAccounts, 3));
  }

  if (groupPettyCashAccountsAccounts.length > 0) {
    final pettyCashAccountHeader =
        CategorisedAccount.header(isHeader: true, title: "Petty Cash Accounts");
    accounts.add(pettyCashAccountHeader);
    accounts.addAll(parseAccountsJson(groupPettyCashAccountsAccounts, 4));
  }

  return accounts;
}

Group parseSingleGroup(dynamic groupJSON) {
  var groupRoles = groupJSON["group_roles"];
  List<GroupRoles> groupRoleObject = [];
  if (groupRoles.length > 0) {
    groupRoles.forEach((key, value) {
      final newRole = GroupRoles(roleId: key, roleName: value);
      groupRoleObject.add(newRole);
    });
  }
  final newGroup = Group(
    groupId: groupJSON['id'].toString(),
    memberId: groupJSON['member_id'].toString(),
    groupName: groupJSON['name'].toString(),
    groupSize: groupJSON['size'].toString(),
    groupCountryId: groupJSON['country_id'].toString(),
    smsBalance: groupJSON["sms_balance"].toString(),
    accountNumber: groupJSON["account_number"].toString(),
    enableMemberInformationPrivacy:
        groupJSON["enable_member_information_privacy"].toString() == "1"
            ? true
            : false,
    enableSendMonthlyEmailStatements:
        groupJSON["enable_send_monthly_email_statements"].toString() == "1"
            ? true
            : false,
    groupRoles: groupRoleObject,
    memberListingOrderBy: groupJSON["member_listing_order_by"]..toString(),
    orderMembersBy: groupJSON["order_members_by"]..toString(),
    enablehidegroupbalancestoMembers:
        groupJSON["enable_hide_group_balances_to_members"].toString() == "1"
            ? true
            : false,
    onlineBankingEnabled:
        groupJSON["online_banking_enabled"].toString() == "1" ? true : false,
    groupRoleId: groupJSON['group_role_id']..toString(),
    groupRole: groupJSON['role']..toString(),
    disableArrears:
        groupJSON['disable_arrears'].toString() == "1" ? true : false,
    enableAbsoluteLoanRecalculation:
        groupJSON['enable_absolute_loan_recalculation'].toString() == "1"
            ? true
            : false,
    disableIgnoreContributionTransfers:
        groupJSON['disable_ignore_contribution_transfers'].toString() == "1"
            ? true
            : false,
    disableMemberEditProfile:
        groupJSON['disable_member_edit_profile'].toString() == "1"
            ? true
            : false,
    offerLoans: groupJSON['group_offer_loans'].toString() == "1" ? true : false,
    isGroupAdmin: groupJSON['is_admin'].toString() == "1" ? true : false,
    isCollective: groupJSON['is_collective'].toString() == '1' ? true : false,
    referralCode: groupJSON['referral_code'].toString(),
    groupCurrency: groupJSON['group_currency'].toString(),
    groupCurrencyId: groupJSON['country_id'].toString(),
    groupPhone: groupJSON['phone'].toString(),
    groupEmail: groupJSON['email'].toString(),
    groupCountryName: groupJSON['country_name'].toString(),
    avatar: groupJSON['avatar'].toString(),
  );

  return newGroup;
}

List<CategorisedAccount> parseAccountsJson(
    List<dynamic> accountsJson, int typeId) {
  List<CategorisedAccount> accounts = [];
  int position = 0;
  for (var account in accountsJson) {
    ++position;
    String id = account['id'].toString();
    String name = account['name'].toString();

    // ignore: todo
    //TODO: add account number to API response
    String accountNumber = "";
    if (typeId != 4) {
      accountNumber = "";
    }

    final newAccount = CategorisedAccount(
      isHeader: false,
      id: id,
      name: name,
      accountNumber: accountNumber,
      typeId: typeId,
      uniqueId: position,
    );
    accounts.add(newAccount);
  }

  return accounts;
}

List<LoanType> parseLoanTypes(List<dynamic> groupLoanTypes) {
  List<LoanType> loanTypes = [];
  if (groupLoanTypes.length > 0) {
    for (var groupLoanTypesJSON in groupLoanTypes) {
      final newLoanType = LoanType(
        id: groupLoanTypesJSON['id'].toString(),
        name: groupLoanTypesJSON['name'].toString(),
        repaymentPeriod: groupLoanTypesJSON['repayment_period'].toString(),
        loanAmount: groupLoanTypesJSON['loan_amount'].toString(),
        interestRate: groupLoanTypesJSON['interest_rate'].toString(),
        loanProcessing: groupLoanTypesJSON['loan_processing'].toString(),
        disbursementDate: groupLoanTypesJSON['disbursement_date'].toString(),
        guarantors: groupLoanTypesJSON['guarantors'].toString(),
        latePaymentFines: groupLoanTypesJSON['late_payment_fines'].toString(),
        repaymentPeriodType:
            groupLoanTypesJSON['repayment_period_type'].toString(),
        outstandingPaymentFines:
            groupLoanTypesJSON['outstanding_payment_fines'].toString(),
        isHidden:
            ParseHelper.getIntFromJson(groupLoanTypesJSON, "is_hidden") == 0
                ? false
                : true,
      );
      loanTypes.add(newLoanType);
    }
  }

  return loanTypes;
}

List<NamesListItem> depositMethods = [
  NamesListItem(id: 1, name: "MPesa"),
  NamesListItem(id: 2, name: "Cash"),
  NamesListItem(id: 3, name: "Cheque"),
  NamesListItem(id: 4, name: "FundsTransfer"),
  NamesListItem(id: 5, name: "Equitel"),
  NamesListItem(id: 6, name: "Standing Order"),
];

List<NamesListItem> withdrawalMethods = [
  NamesListItem(id: 1, name: "Cash"),
  NamesListItem(id: 2, name: "MPesa"),
  NamesListItem(id: 3, name: "Cheque"),
  NamesListItem(id: 4, name: "Account to Account Transfer"),
  NamesListItem(id: 5, name: "Equitel"),
];

List<Map> depositTypes = [
  {"id": 1, "name": "Contribution payment"},
  {"id": 2, "name": "Fine payment"},
  {"id": 3, "name": "Miscellaneous payment"},
  {"id": 4, "name": "Income"},
  {"id": 5, "name": "Loan repayment"},
  {"id": 6, "name": "Bank loan disbursement"},
  {"id": 7, "name": "Funds transfer"},
  {"id": 8, "name": "Stock sale"},
  {"id": 9, "name": "Asset sale"},
  {"id": 10, "name": "Money market cash in"},
  {"id": 11, "name": "Loan processing income"},
  {"id": 12, "name": "External loan repayment"},
];

List<Map> withdrawalTypes = [
  {"id": 1, "name": "Expense"},
  {"id": 2, "name": "Asset Purchase Payment"},
  {"id": 3, "name": "Loan Disbursement"},
  {"id": 4, "name": "Stock Purchase"},
  {"id": 5, "name": "Money Market Investment"},
  {"id": 6, "name": "Money Market Investment Top Up"},
  {"id": 7, "name": "Contribution Refund"},
  {"id": 8, "name": "Bank Loan Repayment"},
  {"id": 9, "name": "Funds Transfer"},
  {"id": 10, "name": "External Lending"},
  {"id": 11, "name": "Dividend"},
];

List<NamesListItem> depositTypeOptions = depositTypes
    .map((type) => NamesListItem(id: type['id'], name: type['name']))
    .toList();

List<NamesListItem> withdrawalTypeOptions = withdrawalTypes
    .map((type) => NamesListItem(id: type['id'], name: type['name']))
    .toList();

String getDepositType(depositId) {
  return depositTypes
      .firstWhere((deposit) => deposit['id'] == depositId)['name'];
}

String getWithdrawalType(withdrawalId) {
  return withdrawalTypes
      .firstWhere((withdrawal) => withdrawal['id'] == withdrawalId)['name'];
}
