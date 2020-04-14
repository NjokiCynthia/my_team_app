class LoanStatementRow {
  int id;
  String type;
  double amountDue, paid, balance;
  DateTime date;

  LoanStatementRow(
      {this.id, this.type, this.amountDue, this.paid, this.balance, this.date});
}
