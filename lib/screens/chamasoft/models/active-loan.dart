class ActiveLoan {
  int id, status;
  String name;
  double amount, repaid, balance;
  DateTime applicationDate;

  ActiveLoan(
      {this.id,
      this.status,
      this.name,
      this.amount,
      this.repaid,
      this.balance,
      this.applicationDate});
}
