class LoanStatementRow {
  int id;
  String type;
  double paid, balance;
  String date;

  LoanStatementRow({this.id, this.type, this.date, this.paid, this.balance});
}

class LoanStatementModel {
  List<LoanStatementRow> statementRows;
  double lumpSum, paid, balance;
  String description;

  LoanStatementModel({this.statementRows, this.lumpSum, this.paid, this.balance, this.description});
}
