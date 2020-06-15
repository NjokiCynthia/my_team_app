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

AccountBalances getAccountBalances(dynamic data) {
  final balances = data['balances'] as List<dynamic>;
  final List<AccountBalance> bankAccounts = [];
  if (balances.length > 0) {
    for (var balance in balances) {
      final name = balance['category_name'].toString();
      bankAccounts.add(AccountBalance.header(isHeader: true, header: name));
      final accounts = balance['account_balances'] as List<dynamic>;
      for (var account in accounts) {
        final accountBalance = AccountBalance(
            isHeader: false, name: account['account_name'].toString(), accountNumber: '10010012123', balance: account['account_balance'].toString());
        bankAccounts.add(accountBalance);
      }
    }
  }
  String totalBalance = data['grand_total_balance'].toString();
  return AccountBalances(accounts: bankAccounts, totalBalance: totalBalance);
}
