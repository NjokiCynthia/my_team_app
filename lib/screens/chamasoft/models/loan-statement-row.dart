class LoanStatementRow {
  int id;
  String type;
  double paid, balance;
  DateTime date;

  LoanStatementRow({this.id, this.type, this.date, this.paid, this.balance});
}
