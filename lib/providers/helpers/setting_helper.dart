import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';

List<CategorisedAccount> getCategorisedAccounts(dynamic response) {
  List<CategorisedAccount> accounts = [];

  print(response);
  final groupBankAccounts = response['bank_accounts'] as List<dynamic>;
  final groupSaccoAccounts = response['sacco_accounts'] as List<dynamic>;
  final groupMobileMoneyAccounts = response['mobile_money_accounts'] as List<dynamic>;
  final groupPettyCashAccountsAccounts = response['petty_cash_accounts'] as List<dynamic>;

  if (groupBankAccounts.length > 0) {
    final bankAccountHeader = CategorisedAccount.header(isHeader: true, title: "Bank Accounts");
    accounts.add(bankAccountHeader);
    accounts.addAll(parseAccountsJson(groupBankAccounts, 1));
  }

  if (groupSaccoAccounts.length > 0) {
    final saccoAccountHeader = CategorisedAccount.header(isHeader: true, title: "Sacco Accounts");
    accounts.add(saccoAccountHeader);
    accounts.addAll(parseAccountsJson(groupSaccoAccounts, 2));
  }

  if (groupMobileMoneyAccounts.length > 0) {
    final mobileMoneyAccountHeader = CategorisedAccount.header(isHeader: true, title: "Mobile Money Accounts");
    accounts.add(mobileMoneyAccountHeader);
    accounts.addAll(parseAccountsJson(groupMobileMoneyAccounts, 3));
  }

  if (groupPettyCashAccountsAccounts.length > 0) {
    final pettyCashAccountHeader = CategorisedAccount.header(isHeader: true, title: "Petty Cash Accounts");
    accounts.add(pettyCashAccountHeader);
    accounts.addAll(parseAccountsJson(groupPettyCashAccountsAccounts, 4));
  }

  return accounts;
}

List<CategorisedAccount> parseAccountsJson(List<dynamic> accountsJson, int typeId) {
  List<CategorisedAccount> accounts = [];
  for (var account in accountsJson) {
    String id = account['id'].toString();
    String name = account['name'].toString();

    String accountNumber = "";
    if (typeId != 4) {
      accountNumber = "1100312314562";
    }

    final newAccount = CategorisedAccount(isHeader: false, id: id, name: name, accountNumber: accountNumber, typeId: typeId);

    accounts.add(newAccount);
  }

  return accounts;
}
