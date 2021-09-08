import 'package:flutter/cupertino.dart';

class ReconciledDeposit {
  final String paymentDescription, bankLoanDescription, transferDescription;

  final double amount,
      amountPayable,
      amountDisbursed,
      transferredAmount,
      pricePerShare;

  final int depositTypeId,
      memberId,
      contributionId,
      fineCategoryId,
      depositorId,
      incomeCategoryId,
      loanId,
      accountId,
      stockId,
      assetId,
      moneyMarketInvstId,
      borrowerId,
      numberOfSharesSold;

  ReconciledDeposit(
      {this.paymentDescription,
      this.bankLoanDescription,
      this.transferDescription,
      this.amount,
      this.amountPayable,
      this.amountDisbursed,
      this.transferredAmount,
      this.pricePerShare,
      this.depositTypeId,
      this.memberId,
      this.contributionId,
      this.fineCategoryId,
      this.depositorId,
      this.incomeCategoryId,
      this.loanId,
      this.accountId,
      this.stockId,
      this.assetId,
      this.moneyMarketInvstId,
      this.borrowerId,
      this.numberOfSharesSold});
}

class DepositReconciliation with ChangeNotifier {
  List<ReconciledDeposit> _reconciledDeposits = [];
  List<Map> depositTypes = [
    {"id": 1, "name": "Contribution payment"},
    {"id": 2, "name": "Fine payment"},
    {"id": 3, "name": "Miscellaneous payment"},
    {"id": 4, "name": "Income"},
    {"id": 5, "name": "Loan repayment"},
    {"id": 6, "name": "Bank loan disbursement"},
    {"id": 7, "name": "Funds transfer"},
    {"id": 8, "name": "Stock sale"},
    {"id": 9, "name": "Asset sale"},
    {"id": 10, "name": "Money market cash in"},
    {"id": 11, "name": "Loan processing income"},
    {"id": 12, "name": "External loan repayment"},
  ];
  List<Map> members = [
    {"id": 1, "name": "Jane doe"},
    {"id": 2, "name": "John doe"},
    {"id": 3, "name": "Alex doe"},
  ];
  List<Map> contributions = [
    {"id": 1, "name": "Contribution a"},
    {"id": 2, "name": "Contribution b"},
  ];
  List<Map> fineCategories = [
    {"id": 1, "name": "Absent without apology"},
    {"id": 2, "name": "Lateness to attend meeting"},
    {"id": 3, "name": "Rude behavior"},
    {"id": 4, "name": "Phone calls during meeting"},
    {"id": 5, "name": "Absent with apology"},
    {"id": 6, "name": "Absconding duty"},
    {"id": 7, "name": "Miscellaneous fine"},
  ];
  List<Map> incomeCategories = [
    {"id": 1, "name": "Rent"},
    {"id": 2, "name": "Interest"},
    {"id": 3, "name": "Sales"},
    {"id": 4, "name": "Miscellaneous income"},
    {"id": 5, "name": "Dividends"},
    {"id": 6, "name": "Lease"},
  ];
  List<Map> depositors = [
    {"id": 1, "name": "John doe"},
    {"id": 2, "name": "Jane doe"},
    {"id": 3, "name": "Alex doe"},
  ];
  List<Map> loans = [
    {"id": 1, "name": "Loan a"},
    {"id": 2, "name": "Loan b"},
  ];
  List<Map> accounts = [
    {"id": 1, "name": "E-wallet"},
    {"id": 2, "name": "Cash at hand"},
  ];
  List<Map> stocks = [
    {"id": 1, "name": "Stock a"},
    {"id": 2, "name": "Stock b"},
  ];
  List<Map> assets = [
    {"id": 1, "name": "Asset a"},
    {"id": 2, "name": "Asset b"}
  ];
  List<Map> moneyMarketInvsts = [
    {"id": 1, "name": "Investment a"},
    {"id": 2, "name": "Investment b"},
  ];
  List<Map> borrowers = [
    {"id": 1, "name": "John doe"},
    {"id": 2, "name": "Jane doe"},
    {"id": 3, "name": "Alex doe"},
  ];

  // get the reconciled deposits
  List<ReconciledDeposit> get reconciledDeposits {
    return [..._reconciledDeposits];
  }

  // get the deposit type
  String getDepositType(int id) {
    return depositTypes.firstWhere((type) => type['id'] == id)['name'];
  }

  // get the member
  String getMember(int id) {
    return members.firstWhere((member) => member['id'] == id)['name'];
  }

  // add reconciled deposit
  void addReconciledDeposit(ReconciledDeposit data) {
    _reconciledDeposits.add(data);
    notifyListeners();
  }

  // remove reconciled deposit
  void removeReconciledDeposit(index) {
    _reconciledDeposits.removeAt(index);
    notifyListeners();
  }

  // get the total amount entered.
  double get totalReconciled {
    double total = 0.0;

    // ensure that formData has data.
    if (_reconciledDeposits.length > 0) {
      // loop through the data.
      for (var entity in reconciledDeposits) {
        if (entity.amount != null) {
          total += entity.amount;
        } else if (entity.amountDisbursed != null) {
          total += entity.amountDisbursed;
        } else if (entity.transferredAmount != null) {
          total += entity.transferredAmount;
        } else {
          continue;
        }
      }

      return total;
    } else {
      return total;
    }
  }

  // reset
  void reset() {
    _reconciledDeposits = [];
  }
}
