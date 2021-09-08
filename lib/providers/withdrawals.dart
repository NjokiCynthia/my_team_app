import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import "package:flutter/material.dart";

class WithDrawal {
  final String id;
  final DateTime dateOfTransaction;
  final double amountTransacted;
  final String transactionDets;
  final String account;
  bool isReconciled;

  WithDrawal({
    @required this.id,
    @required this.dateOfTransaction,
    @required this.amountTransacted,
    @required this.transactionDets,
    @required this.account,
    @required this.isReconciled,
  });
}

class Withdrawals with ChangeNotifier {
  List<WithDrawal> _withdrawals = [
    WithDrawal(
        id: "1",
        dateOfTransaction: DateTime.fromMillisecondsSinceEpoch(1631092495312),
        amountTransacted: 500.00,
        transactionDets:
            "Payment reversal to 254728747061 - GEOFFREY GITHAIGA for payment id OC33HSOFP9",
        account: "Chamasoft E-Wallet - VIUSASA C.E.W (10020860)",
        isReconciled: false),
    WithDrawal(
        id: "2",
        dateOfTransaction: DateTime.fromMillisecondsSinceEpoch(1631092744336),
        amountTransacted: 100.00,
        transactionDets: "254725882136 - GEORGE KAMARA Withdrawal charge",
        account: "Chamasoft E-Wallet - VIUSASA C.E.W (10020860)",
        isReconciled: false),
    WithDrawal(
        id: "3",
        dateOfTransaction: DateTime.fromMillisecondsSinceEpoch(1631092874502),
        amountTransacted: 16200.00,
        transactionDets: "254725882136 - GEORGE KAMARA",
        account: "Chamasoft E-Wallet - VIUSASA C.E.W (10020860)",
        isReconciled: false),
    WithDrawal(
        id: "4",
        dateOfTransaction: DateTime.fromMillisecondsSinceEpoch(1631092495312),
        amountTransacted: 500.00,
        transactionDets:
            "Payment reversal to 254728747061 - GEOFFREY GITHAIGA for payment id OC33HSOFP9",
        account: "Chamasoft E-Wallet - VIUSASA C.E.W (10020860)",
        isReconciled: false),
    WithDrawal(
        id: "5",
        dateOfTransaction: DateTime.fromMillisecondsSinceEpoch(1631092952795),
        amountTransacted: 1000.00,
        transactionDets: "254716258084 - MARTIN THUKU NDUNGU",
        account: "Chamasoft E-Wallet - VIUSASA C.E.W (10020860)",
        isReconciled: false),
  ];

  List<WithDrawal> get withdrawals {
    List<WithDrawal> result = _withdrawals
        .where((withdrawal) => withdrawal.isReconciled == false)
        .toList();
    return result;
  }

  // reconcile withdrawal
  void reconcileWithdrawal(String id) {
    WithDrawal selectedWithdrawal =
        _withdrawals.firstWhere((entity) => entity.id == id);

    selectedWithdrawal.isReconciled = true;

    notifyListeners();
  }

  // get the withdrawal
  WithDrawal withdrawal(String id) {
    return _withdrawals.firstWhere((entity) => entity.id == id);
  }
}

class WithdrawalDefaults {
  List<Map> withdrawalTypes = [
    {"id": 1, "name": "Expense"},
    {"id": 2, "name": "Asset purchase payment"},
    {"id": 3, "name": "Loan disbursement"},
    {"id": 4, "name": "Stock purchase"},
    {"id": 5, "name": "Money market investment"},
    {"id": 6, "name": "Money market investment top up"},
    {"id": 7, "name": "Contribution refund"},
    {"id": 8, "name": "Bank loan repayment"},
    {"id": 9, "name": "Funds transfer"},
    {"id": 10, "name": "External lending"},
    {"id": 11, "name": "Dividend"},
  ];

  List<Map> expenseCategories = [
    {"id": 1, "name": "Stationery"},
    {"id": 2, "name": "Bank charges"},
    {"id": 3, "name": "Withholding tax"},
    {"id": 4, "name": "Company registration"},
    {"id": 5, "name": "Legal fees"},
    {"id": 6, "name": "Wages"},
    {"id": 7, "name": "Salaries"},
    {"id": 8, "name": "Donation"},
    {"id": 9, "name": "Miscellaneous expenses"},
    {"id": 10, "name": "Subscription fees"},
    {"id": 11, "name": "Office expenses"},
    {"id": 12, "name": "Insuarance fees"},
    {"id": 13, "name": "Excise duty"},
    {"id": 14, "name": "Transport"},
    {"id": 15, "name": "Courier"},
    {"id": 16, "name": "Search fee"},
    {"id": 17, "name": "Food and drinks"},
    {"id": 18, "name": "Brokerage fees"},
    {"id": 19, "name": "Operating expenses"},
    {"id": 20, "name": "Benevolence"},
    {"id": 21, "name": "Company seal"},
    {"id": 22, "name": "Telephone and postages"},
    {"id": 23, "name": "Corporate and responsibility"},
  ];

  List<Map> assets = [
    {"id": 1, "name": "Asset a"},
    {"id": 2, "name": "Asset b"},
  ];

  List<Map> members = [
    {"id": 1, "name": "John doe"},
    {"id": 2, "name": "Jane doe"},
    {"id": 3, "name": "Alex doe"},
  ];

  List<Map> loans = [
    {"id": 1, "name": "Loan a"},
    {"id": 2, "name": "Loan b"},
  ];

  List<Map> moneyMarketInvestments = [
    {"id": 1, "name": "Money market investment a"},
    {"id": 2, "name": "Money market investment b"},
  ];

  List<Map> contributions = [
    {"id": 1, "name": "Contribution a"},
    {"id": 2, "name": "Contribution b"},
  ];

  List<Map> bankLoans = [
    {"id": 1, "name": "Bank loan a"},
    {"id": 2, "name": "Bank loan b"},
  ];

  List<Map> accounts = [
    {"id": 1, "name": "Account a"},
    {"id": 2, "name": "Account b"},
  ];

  List<Map> borrowers = [
    {"id": 1, "name": "Borrower a"},
    {"id": 2, "name": "Borrower b"},
  ];

  List<NamesListItem> get withdrawalOptions {
    return withdrawalTypes.map((withdrawal) {
      return NamesListItem(
          id: withdrawal['id'],
          name: withdrawal['name'],
          identity: "${withdrawal['id']}");
    }).toList();
  }

  List<NamesListItem> get expenseCategoryOptions {
    return expenseCategories.map((expense) {
      return NamesListItem(
          id: expense['id'],
          name: expense['name'],
          identity: "${expense['id']}");
    }).toList();
  }

  List<NamesListItem> get assetOptions {
    return assets
        .map((asset) => NamesListItem(
            id: asset['id'], name: asset['name'], identity: "${asset['id']}"))
        .toList();
  }

  List<NamesListItem> get memberOptions {
    return members
        .map((member) => NamesListItem(
            id: member['id'],
            name: member['name'],
            identity: "${member['id']}"))
        .toList();
  }

  List<NamesListItem> get loanOptions {
    return loans
        .map((loan) => NamesListItem(
            id: loan['id'], name: loan['name'], identity: "${loan['id']}"))
        .toList();
  }

  List<NamesListItem> get moneyMarketInvestmentOptions {
    return moneyMarketInvestments
        .map((moneyMarketInvestment) => NamesListItem(
            id: moneyMarketInvestment['id'],
            name: moneyMarketInvestment['name'],
            identity: "${moneyMarketInvestment['id']}"))
        .toList();
  }

  List<NamesListItem> get contributionOptions {
    return contributions
        .map((contribution) => NamesListItem(
            id: contribution['id'],
            name: contribution['name'],
            identity: "${contribution['id']}"))
        .toList();
  }

  List<NamesListItem> get bankLoanOptions {
    return bankLoans
        .map((bankLoan) => NamesListItem(
            id: bankLoan['id'],
            name: bankLoan['name'],
            identity: "${bankLoan['id']}"))
        .toList();
  }

  List<NamesListItem> get accountOptions {
    return accounts
        .map((account) => NamesListItem(
            id: account['id'],
            name: account['name'],
            identity: "${account['id']}"))
        .toList();
  }

  List<NamesListItem> get borrowerOptions {
    return borrowers
        .map((borrower) => NamesListItem(
            id: borrower['id'],
            name: borrower['name'],
            identity: "${borrower['id']}"))
        .toList();
  }

  String getWithdrawalType(int id) {
    return withdrawalTypes.firstWhere((entity) => entity['id'] == id)['name'];
  }

  String getMember(int id) {
    return members.firstWhere((entity) => entity['id'] == id)['name'];
  }
}

class ReconciledWithdrawal {
  int withdrawalTypeId;
  int expenseCategoryId;
  String expenseDesc;
  double amount;
  int assetId;
  String assetPurchasePaymentDesc;
  int memberId;
  int loanId;
  String stockName;
  int numberOfShares;
  double pricePerShare;
  String moneyMktInvstName;
  String moneyMktInvstDesc;
  int moneyMktInvstId;
  String moneyMktTopupDesc;
  int contribId;
  int bankLoanId;
  String bankLoanRepaymentDesc;
  int recipientAccountId;
  String fundsTransferDesc;
  int borrowerId;
  String dividendDesc;

  ReconciledWithdrawal(
      {this.withdrawalTypeId,
      this.expenseCategoryId,
      this.expenseDesc,
      this.amount,
      this.assetId,
      this.assetPurchasePaymentDesc,
      this.memberId,
      this.loanId,
      this.stockName,
      this.numberOfShares,
      this.pricePerShare,
      this.moneyMktInvstName,
      this.moneyMktInvstDesc,
      this.moneyMktInvstId,
      this.moneyMktTopupDesc,
      this.contribId,
      this.bankLoanId,
      this.bankLoanRepaymentDesc,
      this.recipientAccountId,
      this.fundsTransferDesc,
      this.borrowerId,
      this.dividendDesc});
}

class ReconcileWithdrawal with ChangeNotifier {
  List<ReconciledWithdrawal> _reconciledWithdrawals = [];

  // get the reconciled withdrawals.
  List<ReconciledWithdrawal> get reconciledWithdrawals {
    return [..._reconciledWithdrawals];
  }

  // add a reconciled withdrawal
  void addReconciledWithdrawal(ReconciledWithdrawal data) {
    _reconciledWithdrawals.add(data);
    notifyListeners();
  }

  // remove a reconciled withdrawal
  void removeReconciledWithdrawal(int index) {
    _reconciledWithdrawals.removeAt(index);
    notifyListeners();
  }

  // calculate the total amount reconciled
  double get totalReconciled {
    double total = 0.0;

    if (_reconciledWithdrawals.length > 0) {
      for (var withdrawal in _reconciledWithdrawals) {
        if (withdrawal.amount != null) {
          total += withdrawal.amount;
        } else {
          continue;
        }
      }
      return total;
    } else {
      return total;
    }
  }

  // reset the reconciled withdrawals
  void reset() {
    _reconciledWithdrawals = [];
    notifyListeners();
  }
}
