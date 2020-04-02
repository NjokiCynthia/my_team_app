class WithdrawalRequest {
  int requestID;
  DateTime requestDate;
  String purpose, particulars;
  double amount;

  WithdrawalRequest(this.requestID, this.requestDate, this.purpose,
      this.particulars, this.amount);
}
