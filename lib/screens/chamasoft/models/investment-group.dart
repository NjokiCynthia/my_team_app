import 'package:chamasoft/helpers/custom-helper.dart';

import 'named-list-item.dart';

class InvestmentGroup {
  int id;
  int size;
  int onlineBankingEnabled;
  int enableMemberInformationPrivacy;
  int enableSendMonthlyEmailStatements;
  int enableBulkTransactionAlertsReconciliation;
  int disableArrears;
  int disableIgnoreContributionTransfers;
  int disableMemberDirectory;
  int disableMemberEditProfile;
  int enableAbsoluteLoanRecalculation;
  int countryId;
  int subscriptionStatus;
  int trialDays;
  int billingPackageId;
  int billingCycle;
  int isOnFreePlan;
  int isAdmin;
  int groupRoleId;
  int isValidated;
  double smsBalance;
  String avatar;
  String name;
  String slug;
  String accountNumber;
  String theme;
  String memberListingOrderBy;
  String orderMembersBy;
  String phone;
  String email;
  String countryName;
  String activationStatus;
  String activationStatusColorCode;
  String groupCurrency;
  String role;
  dynamic enablehidegroupbalancestoMembers;
  List<NamesListItem> groupRoles;

  InvestmentGroup(
      this.id,
      this.size,
      this.onlineBankingEnabled,
      this.enableMemberInformationPrivacy,
      this.enableSendMonthlyEmailStatements,
      this.enableBulkTransactionAlertsReconciliation,
      this.disableArrears,
      this.disableIgnoreContributionTransfers,
      this.disableMemberDirectory,
      this.disableMemberEditProfile,
      this.enableAbsoluteLoanRecalculation,
      this.countryId,
      this.subscriptionStatus,
      this.trialDays,
      this.billingPackageId,
      this.billingCycle,
      this.isOnFreePlan,
      this.isAdmin,
      this.groupRoleId,
      this.isValidated,
      this.smsBalance,
      this.avatar,
      this.name,
      this.slug,
      this.accountNumber,
      this.theme,
      this.memberListingOrderBy,
      this.orderMembersBy,
      this.phone,
      this.email,
      this.countryName,
      this.activationStatus,
      this.activationStatusColorCode,
      this.groupCurrency,
      this.role,
      this.enablehidegroupbalancestoMembers,
      this.groupRoles);

  void initGroupRoles(List<NamesListItem> roles) {
    this.groupRoles = roles;
  }

  InvestmentGroup.fromJson(Map<String, dynamic> json)
      : id = CustomHelper.parseInt(json['id']),
        size = CustomHelper.parseInt(json['size']),
        onlineBankingEnabled =
            CustomHelper.parseInt(json['online_banking_enabled']),
        enableMemberInformationPrivacy =
            CustomHelper.parseInt(json['enable_member_information_privacy']),
        enableSendMonthlyEmailStatements =
            CustomHelper.parseInt(json['enable_send_monthly_email_statements']),
        enableBulkTransactionAlertsReconciliation = CustomHelper.parseInt(
            json['enable_bulk_transaction_alerts_reconciliation']),
        disableArrears = CustomHelper.parseInt(json['disable_arrears']),
        disableIgnoreContributionTransfers = CustomHelper.parseInt(
            json['disable_ignore_contribution_transfers']),
        disableMemberDirectory =
            CustomHelper.parseInt(json['disable_member_directory']),
        disableMemberEditProfile =
            CustomHelper.parseInt(json['disable_member_edit_profile']),
        enableAbsoluteLoanRecalculation =
            CustomHelper.parseInt(json['enable_absolute_loan_recalculation']),
        countryId = CustomHelper.parseInt(json['country_id']),
        subscriptionStatus = CustomHelper.parseInt(json['subscription_status']),
        trialDays = CustomHelper.parseInt(json['trial_days']),
        billingPackageId = CustomHelper.parseInt(json['billing_package_id']),
        billingCycle = CustomHelper.parseInt(json['billing_cycle']),
//        isOnFreePlan = CustomHelper.parseInt(json['is_on_free_plan']),
        //       isAdmin = CustomHelper.parseInt(json['is_admin']),
        groupRoleId = CustomHelper.parseInt(json['group_role_id']),
        isValidated = CustomHelper.parseInt(json['is_validated']),
        smsBalance = CustomHelper.parseDouble(json['sms_balance']),
        avatar = json['avatar'],
        name = json['name'],
        slug = json['slug'],
        accountNumber = json['account_number'],
        theme = json['theme'],
        memberListingOrderBy = json['member_listing_order_by'],
        orderMembersBy = json['order_members_by'],
        phone = json['phone'],
        email = json['email'],
        countryName = json['country_name'],
        activationStatus = json['activation_status'],
        activationStatusColorCode = json['activation_status_color_code'],
        groupCurrency = json['group_currency'],
        enablehidegroupbalancestoMembers = CustomHelper.parseInt(
            json['enable_hide_group_balances_to_members']),
        role = json['role'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'size': size,
        'online_banking_enabled': onlineBankingEnabled,
        'enable_member_information_privacy': enableMemberInformationPrivacy,
        'enable_send_monthly_email_statements':
            enableSendMonthlyEmailStatements,
        'enable_bulk_transaction_alerts_reconciliation':
            enableBulkTransactionAlertsReconciliation,
        'disable_arrears': disableArrears,
        'disable_ignore_contribution_transfers':
            disableIgnoreContributionTransfers,
        'disable_member_directory': disableMemberDirectory,
        'disable_member_edit_profile': disableMemberEditProfile,
        'enable_absolute_loan_recalculation': enableAbsoluteLoanRecalculation,
        'country_id': countryId,
        'subscription_status': subscriptionStatus,
        'trial_days': trialDays,
        'billing_package_id': billingPackageId,
        'billing_cycle': billingCycle,
        'is_on_free_plan': isOnFreePlan,
        'is_admin': isAdmin,
        'enable_hide_group_balances_to_members':
            enablehidegroupbalancestoMembers,
        'group_role_id': groupRoleId,
        'is_validated': isValidated,
        'sms_balance': smsBalance,
        'avatar': avatar,
        'name': name,
        'slug': slug,
        'account_number': accountNumber,
        'theme': theme,
        'member_listing_order_by': memberListingOrderBy,
        'order_members_by': orderMembersBy,
        'phone': phone,
        'email': email,
        'country_name': countryName,
        'activation_status': activationStatus,
        'activation_status_color_code': activationStatusColorCode,
        'group_currency': groupCurrency,
        'role': role,
      };
}
