import 'package:flutter/material.dart';

class Group {
  final String groupId;
  final String groupName;
  final String groupSize;
  final String groupCountryId;
  final String groupCurrencyId;
  final String groupPhone;
  final String groupEmail;
  final String groupCountryName;
  final String avatar;
  final dynamic referralCode;
  final dynamic isCollective;
  final List<GroupRoles> groupRoles;
  final String smsBalance, accountNumber;
  final bool onlineBankingEnabled,
      enableMemberInformationPrivacy,
      disableArrears,
      enableAbsoluteLoanRecalculation,
      disableMemberEditProfile,
      disableIgnoreContributionTransfers;
  final String memberListingOrderBy, orderMembersBy;
  final bool enableSendMonthlyEmailStatements;
  final String groupRoleId;
  final String groupRole;
  final bool isGroupAdmin;
  final String groupCurrency;
  final String memberId;
  dynamic offerLoans;
  dynamic enablehidegroupbalancestoMembers;

  Group(
      {@required this.groupId,
      @required this.groupName,
      @required this.groupSize,
      @required this.groupCountryId,
      @required this.smsBalance,
      this.memberListingOrderBy,
      @required this.accountNumber,
      this.referralCode,
      this.isCollective,
      this.offerLoans,
      this.enableMemberInformationPrivacy,
      this.enableSendMonthlyEmailStatements,
      this.disableArrears,
      this.disableMemberEditProfile,
      this.enableAbsoluteLoanRecalculation,
      this.disableIgnoreContributionTransfers,
      @required this.onlineBankingEnabled,
      this.orderMembersBy,
      @required this.groupRoles,
      @required this.groupRoleId,
      @required this.groupRole,
      @required this.isGroupAdmin,
      this.memberId,
      @required this.groupCurrency,
      this.groupCurrencyId,
      this.groupPhone,
      this.groupEmail,
      this.groupCountryName,
      this.avatar,
      this.enablehidegroupbalancestoMembers});
}

class GroupRoles {
  String roleId;
  String roleName;

  GroupRoles({
    @required this.roleId,
    @required this.roleName,
  });
}

class GroupRolesStatusAndCurrentMemberStatus {
  final int currentMemberStatus;
  final Map<String, int> roleStatus;

  GroupRolesStatusAndCurrentMemberStatus(
      {this.currentMemberStatus, this.roleStatus});
}
