class TransactionStatementRow {
  int id;
  DateTime date;
  double deposit, withdrawal, balance;
  String description;

  TransactionStatementRow(
      {this.id,
      this.date,
      this.deposit,
      this.withdrawal,
      this.balance,
      this.description});
}
