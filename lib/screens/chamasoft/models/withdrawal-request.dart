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
  String withdrawalFor, date, requestBy;
  double amount;
  String recipient;
  String approvalStatus;
  String description;
  List<StatusModel> signatories = [];
  int isOwner, hasResponded, responseStatus;

  WithdrawalRequestDetails(
      {this.withdrawalFor,
      this.date,
      this.requestBy,
      this.amount,
      this.recipient,
      this.approvalStatus,
      this.description,
      this.signatories,
      this.isOwner,
      this.hasResponded,
      this.responseStatus});
}

class StatusModel {
  String name, status;

  StatusModel({this.name, this.status});
}
