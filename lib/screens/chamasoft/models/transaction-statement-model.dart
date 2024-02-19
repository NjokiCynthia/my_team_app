class TransactionStatementRow {
  String date, description;
  double deposit, withdrawal, balance;

  TransactionStatementRow(
      {this.date,
      this.description,
      this.deposit,
      this.withdrawal,
      this.balance});
}

class TransactionStatementModel {
  List<TransactionStatementRow> transactionStatements;
  double totalDeposits, totalWithdrawals;
  double totalBalance;
  String statementDate, statementPeriodFrom, statementPeriodTo;

  TransactionStatementModel(
      {this.transactionStatements,
      this.totalDeposits,
      this.totalWithdrawals,
      this.totalBalance,
      this.statementDate,
      this.statementPeriodFrom,
      this.statementPeriodTo});
}
