class WithdrawalRequest {
  int requestId;
  String requestDate, name;
  String withdrawalFor;
  double amount;
  int approved, declined, pending;
  String status;
  int statusCode, isOwner;
  String recipient;
  int hasResponded, responseStatus;
  String description;

  WithdrawalRequest(
      {this.requestId,
      this.requestDate,
      this.name,
      this.withdrawalFor,
      this.amount,
      this.approved,
      this.declined,
      this.pending,
      this.status,
      this.statusCode,
      this.isOwner,
      this.recipient,
      this.hasResponded,
      this.responseStatus,
      this.description});
}

class WithdrawalRequestDetails {
  String approvalStatus;
  String description;
  List<StatusModel> signatories = [];
  int hasResponded, responseStatus;

  WithdrawalRequestDetails({
      this.approvalStatus, this.description, this.signatories, this.hasResponded, this.responseStatus});
}

class StatusModel {
  String name, status;

  StatusModel({this.name, this.status});
}
