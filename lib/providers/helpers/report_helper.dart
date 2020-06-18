import 'package:chamasoft/screens/chamasoft/models/account-balance.dart';
import 'package:chamasoft/screens/chamasoft/models/expense-category.dart';
import 'package:chamasoft/screens/chamasoft/models/loan-summary-row.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/models/summary-row.dart';
import 'package:chamasoft/screens/chamasoft/models/transaction-statement-model.dart';
import 'package:chamasoft/utilities/common.dart';

///Account Balances
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

TransactionStatementModel getTransactionStatement(dynamic data) {
  final String statementAsAt = data['statement_details']['statement_as_at'].toString();
  final String statementPeriodFrom = data['statement_details']['statement_period_from'].toString();
  final String statementPeriodTo = data['statement_details']['statement_period_to'].toString();
  final double totalBalance = ParseHelper.getDoubleFromJson(data['statement_footer'], 'balance');

  final List<TransactionStatementRow> transactionStatements = [];

  final double depositsBroughtForward = ParseHelper.getDoubleFromJson(data['statement_header'], 'deposited');
  final double withdrawalsBroughtForward = ParseHelper.getDoubleFromJson(data['statement_header'], 'withdrawn');
  final double balanceBroughtForward = ParseHelper.getDoubleFromJson(data['statement_header'], 'balance');
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
      final withdrawn = ParseHelper.getDoubleFromJson(statement, 'withdrawn');
      final deposited = ParseHelper.getDoubleFromJson(statement, 'deposited');
      final balance = ParseHelper.getDoubleFromJson(statement, 'balance');

      final transactionRow =
          TransactionStatementRow(date: date, description: description, deposit: deposited, withdrawal: withdrawn, balance: balance);
      transactionStatements.add(transactionRow);
    }
  }

  return TransactionStatementModel(
      transactionStatements: transactionStatements,
      totalDeposits: 0,
      totalWithdrawals: 0,
      totalBalance: totalBalance,
      statementDate: statementAsAt,
      statementPeriodFrom: statementPeriodFrom,
      statementPeriodTo: statementPeriodTo);
}

ExpenseSummaryList getExpenseSummary(dynamic data) {
  final expenses = data['expenses'] as List<dynamic>;
  final List<SummaryRow> expenseList = [];
  if (expenses.length > 0) {
    for (var expense in expenses) {
      final name = expense['expense_name'].toString();
      final amount = ParseHelper.getDoubleFromJson(expense, "amount");
      final expenseRow = SummaryRow(name: name, paid: amount);
      expenseList.add(expenseRow);
    }
  }
  double totalExpenses = ParseHelper.getDoubleFromJson(data, "total_expenses");
  return ExpenseSummaryList(expenseSummary: expenseList, totalExpenses: totalExpenses);
}

LoansSummaryList getLoanSummaryList(dynamic data) {
  final double totalLoan = ParseHelper.getDoubleFromJson(data['statement_footer'], 'total_loan');
  final double totalInterest = ParseHelper.getDoubleFromJson(data['statement_footer'], 'total_interest');
  final double totalPayable = totalLoan + totalInterest;
  final double totalPaid = ParseHelper.getDoubleFromJson(data['statement_footer'], 'total_paid');
  final double totalBalance = ParseHelper.getDoubleFromJson(data['statement_footer'], 'total_balance');

  final List<LoanSummaryRow> summaryList = [];

  final statementBody = data['statement_body'] as List<dynamic>;
  if (statementBody.length > 0) {
    for (var statement in statementBody) {
      final member = statement['member'].toString();
      final disbursementDate = statement['disbursement_date'].toString();
      final loan = ParseHelper.getDoubleFromJson(statement, 'amount');
      final interest = ParseHelper.getDoubleFromJson(statement, 'interest');
      final due = loan + interest;
      final paid = ParseHelper.getDoubleFromJson(statement, 'amount_paid');
      final balance = ParseHelper.getDoubleFromJson(statement, 'balance');

      final loanSummaryRow = LoanSummaryRow(name: member, amountDue: due, paid: paid, balance: balance, date: DateTime.now());
      summaryList.add(loanSummaryRow);
    }
  }

  return LoansSummaryList(
      summaryList: summaryList, totalLoan: totalLoan, totalPayable: totalPayable, totalPaid: totalPaid, totalBalance: totalBalance);
}

ContributionStatementModel getContributionStatement(dynamic data) {
  final double totalPayable = ParseHelper.getDoubleFromJson(data['statement_footer'], 'payable');
  final double totalPaid = ParseHelper.getDoubleFromJson(data['statement_footer'], 'paid');
  final double totalBalance = ParseHelper.getDoubleFromJson(data['statement_footer'], 'balance');

  final List<ContributionStatementRow> statementList = [];

  final statementBody = data['statement_body'] as List<dynamic>;
  if (statementBody.length > 0) {
    for (var statement in statementBody) {
      final description = statement['description'].toString();
      final date = ParseHelper.formatDate(statement['date'].toString());
      double amount = 0;
      String type = "";

      if (description.contains("invoice")) {
        amount = ParseHelper.getDoubleFromJson(statement, 'payable');
        type = "Invoice";
      } else {
        amount = ParseHelper.getDoubleFromJson(statement, 'paid');
        type = "Payment";
      }

      final statementRow = ContributionStatementRow(isHeader: false, title: description, description: type, amount: amount, date: date);
      statementList.add(statementRow);
    }
  }

  return ContributionStatementModel(statements: statementList, totalPaid: totalPaid, totalDue: totalPayable, totalBalance: totalBalance);
}

class ParseHelper {
  static String formatDate(String date) {
    try {
      return defaultDateFormat.format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  static double getDoubleFromJson(dynamic object, String key) {
    try {
      return double.tryParse(object[key].toString());
    } catch (error) {
      return 0;
    }
  }
}
