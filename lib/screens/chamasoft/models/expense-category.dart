import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';

class ExpenseCategory {
  String id, name;

  ExpenseCategory(this.id, this.name);
}

class ExpenseSummaryList {
  List<SummaryRow> expenseSummary;
  double totalExpenses;

  ExpenseSummaryList({
    this.expenseSummary,
    this.totalExpenses,
  });
}
