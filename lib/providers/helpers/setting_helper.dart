import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';

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
    isGroupAdmin: groupJSON['is_admin'].toString() == "1" ? true : false,
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

    //TODO: add account to API response
    String accountNumber = "";
    if (typeId != 4) {
      accountNumber = "1100312314562";
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


List<NamesListItem> depositMethods = [
  NamesListItem(id: 1, name: "MPesa"),
  NamesListItem(id: 2, name: "Cash"),
  NamesListItem(id: 3, name: "FundsTransfer"),
  NamesListItem(id: 4, name: "Equitel"),
  NamesListItem(id: 4, name: "Standing Order"),
];

List<NamesListItem> withdrawalMethods = [
  NamesListItem(id: 1, name: "Cash"),
  NamesListItem(id: 2, name: "MPesa"),
  NamesListItem(id: 3, name: "Cheque"),
  NamesListItem(id: 4, name: "Account to Account Transfer"),
  NamesListItem(id: 5, name: "Equitel"),
];
