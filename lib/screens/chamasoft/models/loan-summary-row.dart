class LoanSummaryRow {
  int id;
  String name;
  double amountDue, paid, balance;
  DateTime date;

  LoanSummaryRow({this.id, this.name, this.amountDue, this.paid, this.balance, this.date});
}

class LoansSummaryList {
  List<LoanSummaryRow> summaryList;
  double totalLoan, totalPayable, totalPaid, totalBalance;

  LoansSummaryList({
    this.summaryList,
    this.totalLoan,
    this.totalPayable,
    this.totalPaid,
    this.totalBalance,
  });
}
