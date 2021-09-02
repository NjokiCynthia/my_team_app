import 'package:flutter/material.dart';

class Deposit {
  final String id;
  final String dateOfTransaction;
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
    isReconciled = false,
  });
}

class Deposits with ChangeNotifier {
  // Dummy deposits.
  final List<Deposit> _deposits = [
    Deposit(
        id: "1",
        dateOfTransaction: "1630500791797",
        amountTransacted: 5000.00,
        account: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
        transactionDets:
            "MPESA Transaction by MARTHA ADHIAMBO ADHIAMBO (254707158577) via paybill number 546448.",
        isReconciled: false),
    Deposit(
        id: "2",
        dateOfTransaction: "1630501108932",
        amountTransacted: 3000.00,
        account: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
        transactionDets:
            "MPESA Transaction by AGGREY KIPROTICH KOROS (254703656970) via paybill number 546448.",
        isReconciled: false),
    Deposit(
        id: "3",
        dateOfTransaction: "1630501218663",
        amountTransacted: 4000.00,
        account: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
        transactionDets:
            "MPESA Transaction by GEOFFREY ISAAC GITHAIGA (254728747061) via paybill number 546448.",
        isReconciled: false),
    Deposit(
        id: "4",
        dateOfTransaction: "1630501315757",
        amountTransacted: 1000.00,
        account: "Chamasoft E-Wallet - DVEA WELFARE C.E.W (10022748)",
        transactionDets:
            "MPESA Transaction by BRIAN MWANGI KABIRU (254716592266) via paybill number 546448.",
        isReconciled: false)
  ];

  // get the deposits
  List<Deposit> get deposits {
    // only get deposits that are not reconciled.
    return [..._deposits];

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
}
