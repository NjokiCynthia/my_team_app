class LoanSummaryRow {
  int id;
  String name;
  double amountDue, paid, balance;
  DateTime date;

  LoanSummaryRow(
      {this.id, this.name, this.amountDue, this.paid, this.balance, this.date});
}
