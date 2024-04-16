class LoanApprovalRequests {
  String id;
  String loanTypeId;
  String loanApplicationId;
  String loanRequestApplicantUserId;
  String loanRequestMemberId;
  String signatoryUserId;
  String signatoryMemberId;
  String groupId;
  String loanAmount;
  String active;
  String isApproved;
  String isDeclined;
  String approveComment;
  String declineComment;
  String createdOn;
  String createdBy;
  String modifiedOn;
  String modifiedBy;
  String loanSignatoryProgressStatus;
  String commiteeMemberId;
  String committeeProgressStatus;
  String status;
  String oldId;
  String signatoryName;
  String loanRequestMemberName;

  LoanApprovalRequests(
      {this.id,
      this.loanTypeId,
      this.loanApplicationId,
      this.loanRequestApplicantUserId,
      this.loanRequestMemberId,
      this.signatoryUserId,
      this.signatoryMemberId,
      this.groupId,
      this.loanAmount,
      this.active,
      this.isApproved,
      this.isDeclined,
      this.approveComment,
      this.declineComment,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy,
      this.loanSignatoryProgressStatus,
      this.commiteeMemberId,
      this.committeeProgressStatus,
      this.status,
      this.oldId,
      this.loanRequestMemberName,
      this.signatoryName});
}
