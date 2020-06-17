import 'package:chamasoft/screens/chamasoft/models/account-balance.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-summary-row.dart';
import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';

AccountBalanceModel getAccountBalances(dynamic data) {
  final balances = data['balances'] as List<dynamic>;
  final List<AccountBalance> bankAccounts = [];
  if (balances.length > 0) {
    for (var balance in balances) {
      final name = balance['category_name'].toString();
      bankAccounts.add(AccountBalance.header(isHeader: true, header: name));
      final accounts = balance['account_balances'] as List<dynamic>;
      for (var account in accounts) {
        final accountBalance = AccountBalance(
            isHeader: false, name: account['account_name'].toString(), accountNumber: '10010012123', balance: account['account_balance'].toString());
        bankAccounts.add(accountBalance);
      }
    }
  }
  String totalBalance = data['grand_total_balance'].toString();
  return AccountBalanceModel(accounts: bankAccounts, totalBalance: totalBalance);
}

class TransactionStatementRow {
  String date, description;
  double deposit, withdrawal, balance;

  TransactionStatementRow({this.date, this.description, this.deposit, this.withdrawal, this.balance});
}

class TransactionStatement {
  List<TransactionStatementRow> transactionStatements;
  double totalDeposits, totalWithdrawals;
  double totalBalance;
  String statementDate, statementPeriodFrom, statementPeriodTo;

  TransactionStatement(
      {this.transactionStatements,
      this.totalDeposits,
      this.totalWithdrawals,
      this.totalBalance,
      this.statementDate,
      this.statementPeriodFrom,
      this.statementPeriodTo});
}

TransactionStatement getTransactionStatement(dynamic data) {
  final String statementAsAt = data['statement_details']['statement_as_at'].toString();
  final String statementPeriodFrom = data['statement_details']['statement_period_from'].toString();
  final String statementPeriodTo = data['statement_details']['statement_period_to'].toString();
  final double totalBalance = ParseJson.getDoubleFromJson(data['statement_footer'], 'balance');

  final List<TransactionStatementRow> transactionStatements = [];

  final double depositsBroughtForward = ParseJson.getDoubleFromJson(data['statement_header'], 'deposited');
  final double withdrawalsBroughtForward = ParseJson.getDoubleFromJson(data['statement_header'], 'withdrawn');
  final double balanceBroughtForward = ParseJson.getDoubleFromJson(data['statement_header'], 'balance');
  final String descriptionBF = data['statement_header']['description'].toString();
  final String dateBF = data['statement_header']['date'].toString();

  final transactionRow = TransactionStatementRow(
      date: dateBF,
      description: descriptionBF,
      deposit: depositsBroughtForward,
      withdrawal: withdrawalsBroughtForward,
      balance: balanceBroughtForward);

  transactionStatements.add(transactionRow);

  final statementBody = data['statement_body'] as List<dynamic>;
  if (statementBody.length > 0) {
    for (var statement in statementBody) {
      final date = statement['transaction_date'].toString();
      final description = statement['description'].toString();
      final withdrawn = ParseJson.getDoubleFromJson(statement, 'withdrawn');
      final deposited = ParseJson.getDoubleFromJson(statement, 'deposited');
      final balance = ParseJson.getDoubleFromJson(statement, 'balance');

      final transactionRow =
          TransactionStatementRow(date: date, description: description, deposit: deposited, withdrawal: withdrawn, balance: balance);
      transactionStatements.add(transactionRow);
    }
  }

  return TransactionStatement(
      transactionStatements: transactionStatements,
      totalDeposits: 0,
      totalWithdrawals: 0,
      totalBalance: totalBalance,
      statementDate: statementAsAt,
      statementPeriodFrom: statementPeriodFrom,
      statementPeriodTo: statementPeriodTo);
}

class ExpenseSummaryList {
  List<SummaryRow> expenseSummary;
  double totalExpenses;

  ExpenseSummaryList({
    this.expenseSummary,
    this.totalExpenses,
  });
}

ExpenseSummaryList getExpenseSummary(dynamic data) {
  final expenses = data['expenses'] as List<dynamic>;
  final List<SummaryRow> expenseList = [];
  if (expenses.length > 0) {
    for (var expense in expenses) {
      final name = expense['expense_name'].toString();
      final amount = ParseJson.getDoubleFromJson(expense, "amount");
      final expenseRow = SummaryRow(name: name, paid: amount);
      expenseList.add(expenseRow);
    }
  }
  double totalExpenses = ParseJson.getDoubleFromJson(data, "total_expenses");
  return ExpenseSummaryList(expenseSummary: expenseList, totalExpenses: totalExpenses);
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

LoansSummaryList getLoanSummaryList(dynamic data) {
  final double totalLoan = ParseJson.getDoubleFromJson(data['statement_footer'], 'total_loan');
  final double totalInterest = ParseJson.getDoubleFromJson(data['statement_footer'], 'total_interest');
  final double totalPayable = totalLoan + totalInterest;
  final double totalPaid = ParseJson.getDoubleFromJson(data['statement_footer'], 'total_paid');
  final double totalBalance = ParseJson.getDoubleFromJson(data['statement_footer'], 'total_balance');

  final List<LoanSummaryRow> summaryList = [];

  final statementBody = data['statement_body'] as List<dynamic>;
  if (statementBody.length > 0) {
    for (var statement in statementBody) {
      final member = statement['member'].toString();
      final disbursementDate = statement['disbursement_date'].toString();
      final loan = ParseJson.getDoubleFromJson(statement, 'amount');
      final interest = ParseJson.getDoubleFromJson(statement, 'interest');
      final due = loan + interest;
      final paid = ParseJson.getDoubleFromJson(statement, 'amount_paid');
      final balance = ParseJson.getDoubleFromJson(statement, 'balance');

      final loanSummaryRow = LoanSummaryRow(name: member, amountDue: due, paid: paid, balance: balance, date: DateTime.now());
      summaryList.add(loanSummaryRow);
    }
  }

  return LoansSummaryList(
      summaryList: summaryList, totalLoan: totalLoan, totalPayable: totalPayable, totalPaid: totalPaid, totalBalance: totalBalance);
}

class ParseJson {
  static double getDoubleFromJson(dynamic object, String key) {
    try {
      return double.tryParse(object[key].toString());
    } catch (error) {
      return 0;
    }
  }
}
