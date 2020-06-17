class StatementRow {
  bool isHeader;
  String month;
  String title, description, amount;
  DateTime date;

  StatementRow.header(this.isHeader, this.month);

  StatementRow(this.isHeader, this.title, this.description, this.amount, this.date);
}

class ContributionStatementRow {
  bool isHeader;
  String month;
  String title, description, date;
  double amount;

  ContributionStatementRow.header({this.isHeader, this.month});

  ContributionStatementRow({this.isHeader, this.title, this.description, this.amount, this.date});
}

class ContributionStatementModel {
  List<ContributionStatementRow> statements = [];
  double totalPaid, totalDue, totalBalance;

  ContributionStatementModel({this.statements, this.totalPaid, this.totalDue, this.totalBalance});
}
