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

class TransactionStatementRow {
  String date, description;
  double deposit, withdrawal, balance;

  TransactionStatementRow({this.date, this.description, this.deposit, this.withdrawal, this.balance});
}

class TransactionStatement {
  List<TransactionStatementRow> transactionStatements;
  double totalDeposits, totalWithdrawals, totalBalance;
  String statementDate, statementPeriodFrom, statementPeriodTo;

  TransactionStatement(
      {this.transactionStatements,
      this.totalDeposits,
      this.totalWithdrawals,
      this.totalBalance,
      this.statementDate,
      this.statementPeriodFrom,
      this.statementPeriodTo});
}

TransactionStatement getTransactionStatement(dynamic data) {
  final String statementAsAt = data['statement_details']['statement_as_at'].toString();
  final String statementPeriodFrom = data['statement_details']['statement_period_from'].toString();
  final String statementPeriodTo = data['statement_details']['statement_period_to'].toString();
  final double totalDeposits = double.tryParse(data['statement_header']['deposited']) ?? 0;
  final double totalWithdrawals = double.tryParse(data['statement_header']['withdrawn']) ?? 0;
  final double totalBalance = double.tryParse(data['statement_footer']['balance']) ?? 0;

  final statementBody = data['statement_body'] as List<dynamic>;
  final List<TransactionStatementRow> transactionStatements = [];

  if (statementBody.length > 0) {
    for (var statement in statementBody) {
      final date = statement['transaction_date'].toString();
      final description = statement['description'].toString();
      final withdrawn = double.tryParse(statement['withdrawn']) ?? 0;
      final deposited = double.tryParse(statement['deposited']) ?? 0;
      final balance = double.tryParse(statement['balance']) ?? 0;

      final transactionRow =
          TransactionStatementRow(date: date, description: description, deposit: deposited, withdrawal: withdrawn, balance: balance);
      transactionStatements.add(transactionRow);
    }
  }

  return TransactionStatement(
      transactionStatements: transactionStatements,
      totalDeposits: totalDeposits,
      totalWithdrawals: totalWithdrawals,
      totalBalance: totalBalance,
      statementDate: statementAsAt,
      statementPeriodFrom: statementPeriodFrom,
      statementPeriodTo: statementPeriodTo);
}
