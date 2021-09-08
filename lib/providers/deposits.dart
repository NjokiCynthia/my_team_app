import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:flutter/material.dart';

class Deposit {
  final String id;
  final DateTime dateOfTransaction;
  final double amountTransacted;
  final String transactionDets;
  final String account;
  bool isReconciled;

  Deposit({
    @required this.id,
    @required this.dateOfTransaction,
    @required this.amountTransacted,
    @required this.transactionDets,
    @required this.account,
    @required this.isReconciled,
  });
}

class Deposits with ChangeNotifier {
  // Dummy deposits.
  final List<Deposit> _deposits = [
    Deposit(
        id: "1",
        dateOfTransaction: DateTime.fromMillisecondsSinceEpoch(1630500791797),
        amountTransacted: 5000.00,
        account: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
        transactionDets:
            "MPESA Transaction by MARTHA ADHIAMBO ADHIAMBO (254707158577) via paybill number 546448",
        isReconciled: false),
    Deposit(
        id: "2",
        dateOfTransaction: DateTime.fromMillisecondsSinceEpoch(1630501108932),
        amountTransacted: 3000.00,
        account: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
        transactionDets:
            "MPESA Transaction by AGGREY KIPROTICH KOROS (254703656970) via paybill number 546448",
        isReconciled: false),
    Deposit(
        id: "3",
        dateOfTransaction: DateTime.fromMillisecondsSinceEpoch(1630501218663),
        amountTransacted: 4000.00,
        account: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
        transactionDets:
            "MPESA Transaction by GEOFFREY ISAAC GITHAIGA (254728747061) via paybill number 546448",
        isReconciled: false),
    Deposit(
        id: "4",
        dateOfTransaction: DateTime.fromMillisecondsSinceEpoch(1630501315757),
        amountTransacted: 1000.00,
        account: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
        transactionDets:
            "MPESA Transaction by BRIAN MWANGI KABIRU (254716592266) via paybill number 546448",
        isReconciled: false),
    Deposit(
        id: "4",
        dateOfTransaction: DateTime.fromMillisecondsSinceEpoch(1630588856773),
        amountTransacted: 1000.00,
        account: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
        transactionDets:
            "MPESA Transaction by MARTIN MUTUA NZUKI (254728908916) via paybill number 546448",
        isReconciled: false)
  ];

  // get the deposits
  List<Deposit> get deposits {
    // only get deposits that are not reconciled.
    return _deposits.where((deposit) => deposit.isReconciled == false).toList();

    // Will continue from here
  }

  // get a single deposit
  Deposit deposit(String id) {
    return _deposits.firstWhere((deposit) => deposit.id == id);
  }

  // reconcile a deposit.
  void reconcileDeposit(String id) {
    // get the deposit.
    var deposit = _deposits.firstWhere((deposit) => deposit.id == id);
    // update the deposit
    deposit.isReconciled = true;
    // update the listeners
    notifyListeners();
  }

  List<NamesListItem> get depositTypes {
    return [
      NamesListItem(name: "Contribution payment", id: 1, identity: "1"),
      NamesListItem(name: "Fine payment", id: 2, identity: "2"),
      NamesListItem(name: "Miscellaneous payment", id: 3, identity: "3"),
      NamesListItem(name: "Income", id: 4, identity: "4"),
      NamesListItem(name: "Loan repayment", id: 5, identity: "5"),
      NamesListItem(name: "Bank loan disbursement", id: 6, identity: "6"),
      NamesListItem(name: "Funds transfer", id: 7, identity: "7"),
      NamesListItem(name: "Stock sale", id: 8, identity: "8"),
      NamesListItem(name: "Asset sale", id: 9, identity: "9"),
      NamesListItem(name: "Money market cash in", id: 10, identity: "10"),
      NamesListItem(name: "Loan processing income", id: 11, identity: "11"),
      NamesListItem(name: "External loan repayment", id: 12, identity: "12"),
    ];
  }

  List<NamesListItem> get members {
    return [
      NamesListItem(name: 'Jane doe', id: 1, identity: "1"),
      NamesListItem(name: 'John doe', id: 2, identity: "2"),
      NamesListItem(name: 'Alex doe', id: 3, identity: "3")
    ];
  }

  List<NamesListItem> get contributions {
    return [
      NamesListItem(name: 'Contribution a', id: 1, identity: "1"),
      NamesListItem(name: 'Contribution b', id: 2, identity: "2"),
    ];
  }

  List<NamesListItem> get fineCategories {
    return [
      NamesListItem(name: 'Absent without apology', id: 1, identity: "1"),
      NamesListItem(name: 'Lateness to attend meeting', id: 2, identity: "2"),
      NamesListItem(name: 'Rude behavior', id: 3, identity: "3"),
      NamesListItem(name: 'Phone calls during meeting', id: 4, identity: "4"),
      NamesListItem(name: 'Absent with apology', id: 5, identity: "5"),
      NamesListItem(name: 'Absconding duty', id: 6, identity: "6"),
      NamesListItem(name: 'Miscellaneous fine', id: 7, identity: "7"),
    ];
  }

  List<NamesListItem> get incomeCategories {
    return [
      NamesListItem(name: 'Rent', id: 1, identity: "1"),
      NamesListItem(name: 'Interest', id: 2, identity: "2"),
      NamesListItem(name: 'Sales', id: 3, identity: "3"),
      NamesListItem(name: 'Miscellaneous income', id: 4, identity: "4"),
      NamesListItem(name: 'Dividends', id: 5, identity: "5"),
      NamesListItem(name: 'Lease', id: 6, identity: "6"),
    ];
  }

  List<NamesListItem> get depositors {
    return [
      NamesListItem(name: 'John doe', id: 1, identity: "1"),
      NamesListItem(name: 'Jane doe', id: 2, identity: "2"),
      NamesListItem(name: 'Alex doe', id: 3, identity: "3")
    ];
  }

  List<NamesListItem> get loans {
    return [
      NamesListItem(name: 'Loan a', id: 1, identity: "1"),
      NamesListItem(name: 'Loan b', id: 2, identity: "2")
    ];
  }

  List<NamesListItem> get accounts {
    return [
      NamesListItem(name: 'E-wallet', id: 1, identity: "1"),
      NamesListItem(name: 'Cash at hand', id: 2, identity: "2"),
    ];
  }

  List<NamesListItem> get stocks {
    return [
      NamesListItem(name: 'Stock a', id: 1, identity: "1"),
      NamesListItem(name: 'Stock b', id: 2, identity: "2"),
    ];
  }

  List<NamesListItem> get assets {
    return [
      NamesListItem(name: 'Asset a', id: 1, identity: "1"),
      NamesListItem(name: 'Asset b', id: 2, identity: "2"),
    ];
  }

  List<NamesListItem> get moneyMarketInvestments {
    return [
      NamesListItem(name: 'Investment a', id: 1, identity: "1"),
      NamesListItem(name: 'Investment b', id: 2, identity: "2"),
    ];
  }

  List<NamesListItem> get borrowers {
    return [
      NamesListItem(name: 'John doe', id: 1, identity: "1"),
      NamesListItem(name: 'Jane doe', id: 2, identity: "2"),
      NamesListItem(name: 'Alex doe', id: 3, identity: "3"),
    ];
  }
}
