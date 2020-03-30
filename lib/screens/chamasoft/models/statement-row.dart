class StatementRow {
  bool isHeader;
  String month;
  String title, description, amount;
  DateTime date;

  StatementRow.header(this.isHeader, this.month);

  StatementRow(this.isHeader, this.title, this.description, this.amount,
      this.date);
}
