class LoanApplication {
  int loanApplicationId, status;
  DateTime requestDate;
  String loanName, borrowerName;
  double amount;

  LoanApplication({
    this.loanApplicationId,
    this.requestDate,
    this.amount,
    this.loanName,
    this.borrowerName,
    this.status,
  });
}
