class ContributionStatementRow {
  bool isHeader;
  String month;
  String title, description, date;
  double amount;
  double payable;
  double balance;

  ContributionStatementRow.header({this.isHeader, this.month});

  ContributionStatementRow(
      {this.isHeader,
      this.title,
      this.description,
      this.amount,
      this.date,
      this.payable,
      this.balance});
}

class ContributionStatementModel {
  List<ContributionStatementRow> statements = [];
  double totalPaid, totalDue, totalBalance;
  String statementAsAt, statementFrom, statementTo;
  String role, email, phone, memberName;

  ContributionStatementModel(
      {this.statements,
      this.totalPaid,
      this.totalDue,
      this.totalBalance,
      this.statementAsAt,
      this.statementFrom,
      this.statementTo,
      this.role,
      this.email,
      this.phone,
      this.memberName});
}
