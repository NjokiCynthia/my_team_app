class GroupModel {
  final id;
  final name;
  final slug;
  final size;
  final sms_balance;
  final account_number;
  final is_validated;
  final theme;
  final online_banking_enabled;
  final enable_member_information_privacy;
  final member_listing_order_by;
  final order_members_by;
  final enable_send_monthly_email_statements;
  final enable_bulk_transaction_alerts_reconciliation;
  final disable_arrears;
  final disable_ignore_contribution_transfers;
  final disable_member_directory;
  final disable_member_edit_profile;
  final enable_absolute_loan_recalculation;
  final avatar;
  final country_id;
  final country_name;
  final phone;
  final email;
  final subscription_status;
  final trial_days;
  final billing_package_id;
  final role;
  final billing_cycle;

  GroupModel(
      this.id,
      this.name,
      this.slug,
      this.size,
      this.sms_balance,
      this.account_number,
      this.is_validated,
      this.theme,
      this.online_banking_enabled,
      this.enable_member_information_privacy,
      this.member_listing_order_by,
      this.order_members_by,
      this.enable_send_monthly_email_statements,
      this.enable_bulk_transaction_alerts_reconciliation,
      this.disable_arrears,
      this.disable_ignore_contribution_transfers,
      this.disable_member_directory,
      this.disable_member_edit_profile,
      this.enable_absolute_loan_recalculation,
      this.avatar,
      this.country_id,
      this.country_name,
      this.phone,
      this.email,
      this.subscription_status,
      this.trial_days,
      this.billing_package_id,
      this.role,
      this.billing_cycle);

  GroupModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        slug = json['slug'],
        size = json['size'],
        sms_balance = json['sms_balance'],
        account_number = json['account_number'],
        is_validated = json['is_validated'],
        theme = json['theme'],
        online_banking_enabled = json['online_banking_enabled'],
        enable_member_information_privacy =
            json['enable_member_information_privacy'],
        member_listing_order_by = json['member_listing_order_by'],
        order_members_by = json['order_members_by'],
        enable_send_monthly_email_statements =
            json['enable_send_monthly_email_statements'],
        enable_bulk_transaction_alerts_reconciliation =
            json['enable_bulk_transaction_alerts_reconciliation'],
        disable_arrears = json['disable_arrears'],
        disable_ignore_contribution_transfers =
            json['disable_ignore_contribution_transfers'],
        disable_member_directory = json['disable_member_directory'],
        disable_member_edit_profile = json['disable_member_edit_profile'],
        enable_absolute_loan_recalculation =
            json['enable_absolute_loan_recalculation'],
        avatar = json['avatar'],
        country_id = json['country_id'],
        country_name = json['country_name'],
        phone = json['phone'],
        email = json['email'],
        subscription_status = json['subscription_status'],
        trial_days = json['trial_days'],
        billing_package_id = json['billing_package_id'],
        role = json['role'],
        billing_cycle = json['billing_cycle'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'size': size,
        'sms_balance': sms_balance,
        'account_number': account_number,
        'is_validated': is_validated,
        'theme': theme,
        'online_banking_enabled': online_banking_enabled,
        'enable_member_information_privacy': enable_member_information_privacy,
        'member_listing_order_by': member_listing_order_by,
        'order_members_by': order_members_by,
        'enable_send_monthly_email_statements':
            enable_send_monthly_email_statements,
        'enable_bulk_transaction_alerts_reconciliation':
            enable_bulk_transaction_alerts_reconciliation,
        'disable_arrears': disable_arrears,
        'disable_ignore_contribution_transfers':
            disable_ignore_contribution_transfers,
        'disable_member_directory': disable_member_directory,
        'disable_member_edit_profile': disable_member_edit_profile,
        'enable_absolute_loan_recalculation':
            enable_absolute_loan_recalculation,
        'avatar': avatar,
        'country_id': country_id,
        'country_name': country_name,
        'phone': phone,
        'email': email,
        'subscription_status': subscription_status,
        'trial_days': trial_days,
        'billing_package_id': billing_package_id,
        'billing_cycle': billing_cycle,
        'role': role,
      };
}
