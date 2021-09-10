import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:flutter/material.dart';

class Deposit {
  final int type;
  final String transactionType;
  final String transactionDate;
  final String amount;
  final String description;
  final String transactionAlertId;
  int isReconciled;
  final String particulars;
  final String accountNumber;
  final String transactionId;
  final String accountDetails;

  Deposit(
      {@required this.type,
      @required this.transactionType,
      @required this.transactionDate,
      @required this.amount,
      @required this.description,
      @required this.transactionAlertId,
      @required this.isReconciled,
      @required this.particulars,
      @required this.accountNumber,
      @required this.transactionId,
      @required this.accountDetails});
}

class DepositDefaults {
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
}

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

class Deposits with ChangeNotifier {
  // Dummy deposits.
  final List<Deposit> _deposits = [
    Deposit(
      type: 1,
      transactionType: null,
      description: "",
      amount: "1000",
      transactionAlertId: "361810",
      isReconciled: 0,
      particulars:
          "MPESA Transaction  by MARTHA ADHIAMBO ADHIAMBO (254707158577) via paybill number 546448",
      accountNumber: "10022748",
      transactionId: "PB42BY1WSG",
      accountDetails: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
      transactionDate: "Tue, 19th Jan 2038",
    ),
    Deposit(
        type: 1,
        transactionType: null,
        description: "",
        amount: "700",
        transactionAlertId: "361808",
        isReconciled: 0,
        particulars:
            "MPESA Transaction  by AGGREY KIPROTICH KOROS (254703656970) via paybill number 546448",
        accountNumber: "10022748",
        transactionId: "PB40BXJF16",
        accountDetails: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
        transactionDate: "Tue, 19th Jan 2038"),
  ];

  // get the deposits
  List<Deposit> get deposits {
    // only get deposits that are not reconciled.
    return _deposits.where((deposit) => deposit.isReconciled == 0).toList();

    // Will continue from here
  }

  // get a single deposit
  Deposit deposit(String id) {
    return _deposits.firstWhere((deposit) => deposit.transactionAlertId == id);
  }

  // reconcile a deposit.
  void reconcileDeposit(String id) {
    // get the deposit.
    var deposit =
        _deposits.firstWhere((deposit) => deposit.transactionAlertId == id);
    // update the deposit
    deposit.isReconciled = 1;
    // update the listeners
    notifyListeners();
  }

  List<NamesListItem> get depositOptions {
    return new DepositDefaults().depositTypes.map((depositType) {
      return NamesListItem(
          id: depositType['id'],
          name: depositType['name'],
          identity: "${depositType['id']}");
    }).toList();
  }

  List<NamesListItem> get memberOptions {
    return new DepositDefaults().members.map((member) {
      return NamesListItem(
          id: member['id'], name: member['name'], identity: "${member['id']}");
    }).toList();
  }

  List<NamesListItem> get contributionOptions {
    return new DepositDefaults().contributions.map((contrib) {
      return NamesListItem(
          id: contrib['id'],
          name: contrib['name'],
          identity: "${contrib['id']}");
    }).toList();
  }

  List<NamesListItem> get fineCategoryOptions {
    return new DepositDefaults().fineCategories.map((category) {
      return NamesListItem(
          id: category['id'],
          name: category['name'],
          identity: "${category['id']}");
    }).toList();
  }

  List<NamesListItem> get incomeCategoryOptions {
    return new DepositDefaults().incomeCategories.map((incomeCategory) {
      return NamesListItem(
          id: incomeCategory['id'],
          name: incomeCategory['name'],
          identity: "${incomeCategory['id']}");
    });
  }

  List<NamesListItem> get depositorOptions {
    return new DepositDefaults().depositors.map((depositor) {
      return NamesListItem(
          id: depositor['id'],
          name: depositor['name'],
          identity: "${depositor['id']}");
    });
  }

  List<NamesListItem> get loanOptions {
    return new DepositDefaults().loans.map((loan) {
      return NamesListItem(
          id: loan['id'], name: loan['name'], identity: "${loan['id']}");
    });
  }

  List<NamesListItem> get accountOptions {
    return new DepositDefaults().accounts.map((account) {
      return NamesListItem(
          id: account['id'],
          name: account['name'],
          identity: "${account['id']}");
    });
  }

  List<NamesListItem> get stockOptions {
    return new DepositDefaults().stocks.map((stock) {
      return NamesListItem(
          id: stock['id'], name: stock['name'], identity: "${stock['id']}");
    });
  }

  List<NamesListItem> get assetOptions {
    return new DepositDefaults().assets.map((asset) {
      return NamesListItem(
          id: asset['id'], name: asset['name'], identity: "${asset['id']}");
    });
  }

  List<NamesListItem> get moneyMarketInvestments {
    return new DepositDefaults().moneyMarketInvsts.map((invst) {
      return NamesListItem(
          id: invst['id'], name: invst['name'], identity: "${invst['id']}");
    });
  }

  List<NamesListItem> get borrowerOptions {
    return new DepositDefaults().borrowers.map((borrower) {
      return NamesListItem(
          id: borrower['id'],
          name: borrower['name'],
          identity: "${borrower['id']}");
    });
  }

  // get the deposit type
  String getDepositType(int id) {
    return new DepositDefaults()
        .depositTypes
        .firstWhere((type) => type['id'] == id)['name'];
  }

  // get the member
  String getMember(int id) {
    return new DepositDefaults()
        .members
        .firstWhere((member) => member['id'] == id)['name'];
  }

  List<ReconciledDeposit> _reconciledDeposits = [];

  // get the reconciled deposits
  List<ReconciledDeposit> get reconciledDeposits {
    return [..._reconciledDeposits];
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
