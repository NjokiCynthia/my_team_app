class Data {
  String id;
  String loanTypeId;
  String loanApplicationId;
  String loanRequestApplicantUserId;
  String loanRequestApplicantMemberId;
  String guarantorMemberId;
  String guarantorUserId;
  String groupId;
  String amount;
  String comment;
  String loanRequestProgressStatus;
  String isApproved;
  String isDeclined;
  String active;
  String approvedOn;
  String declinedOn;
  String approveComment;
  String declineComment;
  String createdBy;
  String createdOn;
  String modifiedOn;
  String modifiedBy;
  String status;
  String declineReason;
  String loanApplicantUserId;
  String loanApplicantMemberId;
  String oldId;

  Data(
      {this.id,
      this.loanTypeId,
      this.loanApplicationId,
      this.loanRequestApplicantUserId,
      this.loanRequestApplicantMemberId,
      this.guarantorMemberId,
      this.guarantorUserId,
      this.groupId,
      this.amount,
      this.comment,
      this.loanRequestProgressStatus,
      this.isApproved,
      this.isDeclined,
      this.active,
      this.approvedOn,
      this.declinedOn,
      this.approveComment,
      this.declineComment,
      this.createdBy,
      this.createdOn,
      this.modifiedOn,
      this.modifiedBy,
      this.status,
      this.declineReason,
      this.loanApplicantUserId,
      this.loanApplicantMemberId,
      this.oldId});
}
