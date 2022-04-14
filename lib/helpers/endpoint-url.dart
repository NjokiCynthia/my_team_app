import 'custom-helper.dart';

class EndpointUrl {
  //Dashboard
  // ignore: non_constant_identifier_names
  static final String GET_MEMBERS_AND_DETAILS =
      CustomHelper.baseUrl + "/mobile/members/get_members_and_details";
  // ignore: non_constant_identifier_names
  static final String GET_MEMBER_DASHBOARD =
      CustomHelper.baseUrl + "/mobile/get_member_dashboard";
  // ignore: non_constant_identifier_names
  static final String GET_MEMBER_DASHBOARD_DATA =
      CustomHelper.baseUrl + "/mobile/get_member_dashboard_data";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_DASHBOARD_DATA =
      CustomHelper.baseUrl + "/mobile/get_group_dashboard_data";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_CHART_DATA =
      CustomHelper.baseUrl + "/mobile/get_member_and_group_chart_data";

  //On-boarding
  // ignore: non_constant_identifier_names
  static final String GENERATE_OTP =
      CustomHelper.baseUrl + "/mobile/generate_pin";
  // ignore: non_constant_identifier_names
  static final String VERIFY_OTP = CustomHelper.baseUrl + "/mobile/verify_pin";
  // ignore: non_constant_identifier_names
  static final String RESEND_OTP = CustomHelper.baseUrl + "/mobile/resend_pin";
  // ignore: non_constant_identifier_names
  static final String FORGOT_PASSWORD =
      CustomHelper.baseUrl + "/mobile/forgot_password";
  // ignore: non_constant_identifier_names
  static final String RESEND_FORGOT_PASSWORD_OTP =
      CustomHelper.baseUrl + "/mobile/resend_forgot_password_code";
  // ignore: non_constant_identifier_names
  static final String RESET_PASSWORD =
      CustomHelper.baseUrl + "/mobile/reset_password";
  // ignore: non_constant_identifier_names
  static final String VALIDATE_FORGOT_PASSWORD_CODE =
      CustomHelper.baseUrl + "/mobile/validate_forgot_password_code";
  // ignore: non_constant_identifier_names
  static final String LOGIN = CustomHelper.baseUrl + "/mobile/login";
  // ignore: non_constant_identifier_names
  static final String SIGNUP = CustomHelper.baseUrl + "/mobile/register_user";
  // ignore: non_constant_identifier_names
  static final String UPDATE_USER_NAME =
      CustomHelper.baseUrl + "/mobile/users/update_name";
  // ignore: non_constant_identifier_names
  static final String UPDATE_USER_EMAIL_ADDRESS =
      CustomHelper.baseUrl + "/mobile/users/update_email";
  // ignore: non_constant_identifier_names
  static final String UPDATE_USER_MOBILE_TOKEN =
      CustomHelper.baseUrl + "/mobile/users/update_user_mobile_token";

  //Initial group setup
  // ignore: non_constant_identifier_names
  static final String CREATE_GROUP =
      CustomHelper.baseUrl + "/mobile/create_group";
  // ignore: non_constant_identifier_names
  static final String GET_MEMBERS =
      CustomHelper.baseUrl + "/mobile/members/get_members_and_details";
  // ignore: non_constant_identifier_names
  static final String ADD_MEMBERS =
      CustomHelper.baseUrl + "/mobile/setup_tasks/add_group_members";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_UNASSIGNED_ROLES =
      CustomHelper.baseUrl + "/mobile/group_roles/get_group_unassigned_roles";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_UNASSIGNED_ROLE_IDS = CustomHelper.baseUrl +
      "/mobile/group_roles/get_group_unassigned_role_ids";

  //Payment
  // ignore: non_constant_identifier_names
  static final String MAKE_PAYMENT =
      CustomHelper.baseUrl + "/mobile/deposits/make_group_payment";
  // ignore: non_constant_identifier_names
  static final String MAKE_NEW_PAYMENT =
      CustomHelper.baseUrl + "/mobile/deposits/make_new_group_payment";

  // ignore: non_constant_identifier_names
  static final String MAKE_ARREARS_PAYMENT =
      CustomHelper.baseUrl + "/mobile/deposits/make_group_arrears_payment";
  // ignore: non_constant_identifier_names
  static final String CALCULATE_CONVENIENCE_FEE =
      CustomHelper.baseUrl + "/mobile/deposits/calculate_convenience_charge";

  // ignore: non_constant_identifier_names
  static final String GET_GROUPS =
      CustomHelper.baseUrl + "/mobile/get_user_checkin_data";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_DATA =
      CustomHelper.baseUrl + "/mobile/get_group_data";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_MEMBERS =
      CustomHelper.baseUrl + "/mobile/members/get_group_member_options";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_ACCOUNT_OPTIONS = CustomHelper.baseUrl +
      "/mobile/accounts/get_group_active_account_options";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_ALL_ACCOUNT_OPTIONS =
      CustomHelper.baseUrl + "/mobile/accounts/get_group_account_options";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_FINE_OPTIONS = CustomHelper.baseUrl +
      "/mobile/fine_categories/get_group_fine_category_options";
  // ignore: non_constant_identifier_names
  static final String GET_MEMBER_LOAN_OPTIONS =
      CustomHelper.baseUrl + "/mobile/loans/get_member_loan_options";
  // ignore: non_constant_identifier_names
  static final String GET_MEMBERs_LOAN_TYPE_OPTIONS =
      CustomHelper.baseUrl + "/mobile/loans/get_members_loans_options";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_CONTRIBUTIONS_OPTIONS = CustomHelper.baseUrl +
      "/mobile/contributions/get_group_contribution_options";
  // ignore: non_constant_identifier_names
  static final String GET_MEMBER_CONTRIBUTIONS_OPTIONS = CustomHelper.baseUrl +
      "/mobile/contributions/get_member_contribution_options";

  // ignore: non_constant_identifier_names
  static final String GET_DEPOSITS_LIST =
      CustomHelper.baseUrl + "/mobile/deposits/get_deposits_list";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_WITHDRAWAL_LIST =
      CustomHelper.baseUrl + "/mobile/withdrawals/get_group_withdrawal_list";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_LOAN_LIST =
      CustomHelper.baseUrl + "/mobile/loans/get_group_loans_list";

  //Record
  // ignore: non_constant_identifier_names
  static final String RECORD_MEMBER_LOAN =
      CustomHelper.baseUrl + "/mobile/loans/record_member_loan";
  // ignore: non_constant_identifier_names
  static final String RECORD_CONTRIBUTION_PAYMENTS =
      CustomHelper.baseUrl + "/mobile/deposits/record_contribution_payments";
  // ignore: non_constant_identifier_names
  static final String NEW_RECORD_CONTRIBUTION_PAYMENTS = CustomHelper.baseUrl +
      "/mobile/deposits/new_record_contribution_payments";
  // ignore: non_constant_identifier_names
  static final String RECORD_FINE_PAYMENTS =
      CustomHelper.baseUrl + "/mobile/deposits/record_fine_payments";
  // ignore: non_constant_identifier_names
  static final String NEW_RECORD_FINE_PAYMENTS =
      CustomHelper.baseUrl + "/mobile/deposits/new_record_fine_payments";
  // ignore: non_constant_identifier_names
  static final String RECORD_LOAN_REPAYMENTS =
      CustomHelper.baseUrl + "/mobile/deposits/record_loan_repayments";
  // ignore: non_constant_identifier_names
  static final String RECORD_MISCELLANEOUS_PAYMENTS =
      CustomHelper.baseUrl + "/mobile/deposits/record_miscellaneous_payments";
  // ignore: non_constant_identifier_names
  static final String NEW_RECORD_MISCELLANEOUS_PAYMENTS = CustomHelper.baseUrl +
      "/mobile/deposits/new_record_miscellaneous_payments";
  // ignore: non_constant_identifier_names
  static final String RECORD_INCOME =
      CustomHelper.baseUrl + "/mobile/deposits/record_income";
  // ignore: non_constant_identifier_names
  static final String NEW_RECORD_INCOME =
      CustomHelper.baseUrl + "/mobile/deposits/new_record_income_payment";
  // ignore: non_constant_identifier_names
  static final String RECORD_BANK_LOAN =
      CustomHelper.baseUrl + "/mobile/deposits/record_bank_loan";
  // ignore: non_constant_identifier_names
  static final String RECORD_BANK_LOAN_REPAYMENT =
      CustomHelper.baseUrl + "/mobile/withdrawals/record_bank_loan_repayment";
  // ignore: non_constant_identifier_names
  static final String RECORD_CONTRIBUTION_REFUND =
      CustomHelper.baseUrl + "/mobile/withdrawals/record_contribution_refund";
  // ignore: non_constant_identifier_names
  static final String RECORD_FUNDS_TRANSFER =
      CustomHelper.baseUrl + "/mobile/withdrawals/record_funds_transfer";
  // ignore: non_constant_identifier_names
  static final String RECORD_EXPENSES =
      CustomHelper.baseUrl + "/mobile/withdrawals/record_expenses";
  // ignore: non_constant_identifier_names
  static final String NEW_RECORD_EXPENSES =
      CustomHelper.baseUrl + "/mobile/withdrawals/new_record_expenses";
  // ignore: non_constant_identifier_names
  static final String FINE_MEMBERS =
      CustomHelper.baseUrl + "/mobile/fines/fine_members";
  // ignore: non_constant_identifier_names
  static final String NEW_FINE_MEMBERS =
      CustomHelper.baseUrl + "/mobile/fines/new_fine_members";
  // ignore: non_constant_identifier_names
  static final String RECORD_CONTRIBUTION_TRANSFER =
      CustomHelper.baseUrl + "/mobile/deposits/record_contribution_transfer";

  // ignore: non_constant_identifier_names
  static final String GET_GROUP_DEPOSITOR_OPTIONS =
      CustomHelper.baseUrl + "/mobile/depositors/get_group_depositor_options";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_INCOME_CATEGORIES = CustomHelper.baseUrl +
      "/mobile/income_categories/get_group_income_category_options";
  // ignore: non_constant_identifier_names
  static final String ADD_NEW_DEPOSITOR =
      CustomHelper.baseUrl + "/mobile/depositors/create";
  // ignore: non_constant_identifier_names
  static final String ADD_INCOME_CATEGORY =
      CustomHelper.baseUrl + "/mobile/income_categories/create";
  // ignore: non_constant_identifier_names
  static final String EDIT_INCOME_CATEGORY =
      CustomHelper.baseUrl + "/mobile/income_categories/edit";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_EXPENSE_CATEGORY_OPTIONS =
      CustomHelper.baseUrl +
          "/mobile/expense_categories/get_group_expense_category_options";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_BANK_LOAN_OPTIONS =
      CustomHelper.baseUrl + "/mobile/bank_loans/get_group_bank_loan_options";

  //Accounts
  // ignore: non_constant_identifier_names
  static final String GET_BANKS =
      CustomHelper.baseUrl + "/mobile/banks/get_bank_options";
  // ignore: non_constant_identifier_names
  static final String GET_BANK_BRANCHES =
      CustomHelper.baseUrl + "/mobile/bank_branches/get_bank_branches_options";
  // ignore: non_constant_identifier_names
  static final String GE_MOBILE_PROVIDERS = CustomHelper.baseUrl +
      "/mobile/mobile_money_providers/get_mobile_money_provider_options";
  // ignore: non_constant_identifier_names
  static final String GET_SACCOS =
      CustomHelper.baseUrl + "/mobile/saccos/get_sacco_options";
  // ignore: non_constant_identifier_names
  static final String GET_SACCO_BRANCHES = CustomHelper.baseUrl +
      "/mobile/sacco_branches/get_sacco_branches_options";
  // ignore: non_constant_identifier_names
  static final String ADD_PETTY_CASH_ACCOUNT =
      CustomHelper.baseUrl + "/mobile/petty_cash_accounts/create";
  // ignore: non_constant_identifier_names
  static final String EDIT_PETTY_CASH_ACCOUNT =
      CustomHelper.baseUrl + "/mobile/petty_cash_accounts/edit";
  // ignore: non_constant_identifier_names
  static final String ADD_BANK_ACCOUNT =
      CustomHelper.baseUrl + "/mobile/bank_accounts/create";
  // ignore: non_constant_identifier_names
  static final String EDIT_BANK_ACCOUNT =
      CustomHelper.baseUrl + "/mobile/bank_accounts/edit";
  // ignore: non_constant_identifier_names
  static final String ADD_SACCO_ACCOUNT =
      CustomHelper.baseUrl + "/mobile/sacco_accounts/create";
  // ignore: non_constant_identifier_names
  static final String EDIT_SACCO_ACCOUNT =
      CustomHelper.baseUrl + "/mobile/sacco_accounts/edit";
  // ignore: non_constant_identifier_names
  static final String ADD_MOBILE_MONEY_ACCOUNT =
      CustomHelper.baseUrl + "/mobile/mobile_money_accounts/create";
  // ignore: non_constant_identifier_names
  static final String EDIT_MOBILE_MONEY_ACCOUNT =
      CustomHelper.baseUrl + "/mobile/mobile_money_accounts/edit";
  // ignore: non_constant_identifier_names
  static final String GET_BANK_ACCOUNTS = CustomHelper.baseUrl +
      "/mobile/bank_accounts/get_group_bank_accounts_list";
  // ignore: non_constant_identifier_names
  static final String GET_SACCO_ACCOUNTS = CustomHelper.baseUrl +
      "/mobile/sacco_accounts/get_group_sacco_accounts_list";
  // ignore: non_constant_identifier_names
  static final String GET_MOBILE_MONEY_ACCOUNTS = CustomHelper.baseUrl +
      "/mobile/mobile_money_accounts/get_group_mobile_money_accounts_list";
  // ignore: non_constant_identifier_names
  static final String GET_PETTY_CASH_ACCOUNTS = CustomHelper.baseUrl +
      "/mobile/petty_cash_accounts/get_group_petty_cash_accounts_list";
  // ignore: non_constant_identifier_names
  static final String ENABLE_CHAMASOFT_WALLET =
      CustomHelper.baseUrl + "/mobile/bank_accounts/activate_wallet";
  // ignore: non_constant_identifier_names
  static final String ACCOUNT_BALANCE_SUMMARY =
      CustomHelper.baseUrl + "/mobile/get_group_bank_balances";

  //Upload images
  // ignore: non_constant_identifier_names
  static final String EDIT_USER_PHOTO =
      CustomHelper.baseUrl + "/mobile/users/edit_profile_photo";
  // ignore: non_constant_identifier_names
  static final String EDIT_NEW_USER_PHOTO =
      CustomHelper.baseUrl + "/mobile/users/edit_new_profile_photo";
  // ignore: non_constant_identifier_names
  static final String EDIT_MEMBER_PHOTO =
      CustomHelper.baseUrl + "/mobile/members/edit_profile_photo";
  // ignore: non_constant_identifier_names
  static final String EDIT_GROUP_PHOTO =
      CustomHelper.baseUrl + "/mobile/groups/edit_profile_photo";
  // ignore: non_constant_identifier_names
  static final String EDIT_NEW_GROUP_PHOTO =
      CustomHelper.baseUrl + "/mobile/groups/edit_new_profile_photo";

  // ignore: non_constant_identifier_names
  static final String WITHDRAWALS_FUNDS_TRANSFER =
      CustomHelper.baseUrl + "/mobile/withdrawals/request_funds_transfer";
  // ignore: non_constant_identifier_names
  static final String VIEW_WITHDRAWAL_REQUEST =
      CustomHelper.baseUrl + "/mobile/withdrawals/view_withdrawal_request";
  // ignore: non_constant_identifier_names
  static final String GET_CONTRIBUTIONS = CustomHelper.baseUrl +
      "/mobile/contributions/get_group_contribution_options";
  // ignore: non_constant_identifier_names
  static final String RESPOND_TO_WITHDRAWAL_REQUEST = CustomHelper.baseUrl +
      "/mobile/withdrawals/respond_to_withdrawal_request";
  // ignore: non_constant_identifier_names
  static final String BANK_ACCOUNTS_CONNECT =
      CustomHelper.baseUrl + "/mobile/bank_accounts/connect";
  // ignore: non_constant_identifier_names
  static final String BANK_ACCOUNTS_VERIFY =
      CustomHelper.baseUrl + "/mobile/bank_accounts/verify";
  // ignore: non_constant_identifier_names
  static final String BANK_ACCOUNTS_DISCONNECT =
      CustomHelper.baseUrl + "/mobile/bank_accounts/disconnect";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_UNRECONCILED_DEPOSITS = CustomHelper.baseUrl +
      "/mobile/transaction_alerts/get_group_unreconcilled_deposits";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_UNRECONCILED_WITHDRAWALS =
      CustomHelper.baseUrl +
          "/mobile/transaction_alerts/get_group_unreconcilled_withdrawals";
  // ignore: non_constant_identifier_names
  static final String RECONCILE_WITHDRAWAL_TRANSACTION_ALERT =
      CustomHelper.baseUrl + "/mobile/transaction_alerts/reconcile_withdrawals";
  // ignore: non_constant_identifier_names
  static final String RECONCILE_DEPOSIT_TRANSACTION_ALERT =
      CustomHelper.baseUrl + "/mobile/transaction_alerts/reconcile_deposits";

  //Selected Setting Apis
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_CONTRIBUTIONS =
      CustomHelper.baseUrl + "/mobile/contributions/get_group_contributions";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_PAY_CONTRIBUTIONS = CustomHelper.baseUrl +
      "/mobile/contributions/get_group_contributions_to_pay";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_EXPENSE_CATEGORIES = CustomHelper.baseUrl +
      "/mobile/expense_categories/get_group_expense_categories";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_INCOME_CATEGORIES_LIST = CustomHelper.baseUrl +
      "/mobile/income_categories/group_income_categories_list";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_ASSET_CATEGORIES = CustomHelper.baseUrl +
      "/mobile/asset_categories/get_group_asset_categories";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_FINE_CATEGORIES_LIST = CustomHelper.baseUrl +
      "/mobile/fine_categories/group_fine_categories_list";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_ROLE_LIST =
      CustomHelper.baseUrl + "/mobile/group_roles/group_roles_list";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_ASSET_OPTIONS =
      CustomHelper.baseUrl + "/mobile/assets/get_group_asset_options";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_STOCK_OPTIONS =
      CustomHelper.baseUrl + "/mobile/stocks/get_group_stocks_list";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_MONEY_MARKET_INVESTMENT_OPTIONS =
      CustomHelper.baseUrl +
          "/mobile/money_market_investments/get_money_market_investment_list";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_BORROWER_OPTIONS =
      CustomHelper.baseUrl + "/mobile/debtors/get_debtors_list";

  //Contribution
  // ignore: non_constant_identifier_names
  static final String GET_CONTRIBUTION_DETAILS =
      CustomHelper.baseUrl + "/mobile/contributions/get_group_contribution";

  // ignore: non_constant_identifier_names
  static final String GET_MEMBER_CONTRIBUTION_SUMMARY =
      CustomHelper.baseUrl + "/mobile/get_group_member_contribution_summary";

  //Selected Settings Adapter Api
  // ignore: non_constant_identifier_names
  static final String EDIT_ASSET_CATEGORY =
      CustomHelper.baseUrl + "/mobile/asset_categories/edit";
  // ignore: non_constant_identifier_names
  static final String CREATE_ASSET_CATEGORY =
      CustomHelper.baseUrl + "/mobile/asset_categories/create";
  // ignore: non_constant_identifier_names
  static final String ASSET_CATEGORIES_DELETE =
      CustomHelper.baseUrl + "/mobile/asset_categories/delete";
  // ignore: non_constant_identifier_names
  static final String ASSET_CATEGORIES_HIDE =
      CustomHelper.baseUrl + "/mobile/asset_categories/hide";
  // ignore: non_constant_identifier_names
  static final String ASSET_CATEGORIES_UNHIDE =
      CustomHelper.baseUrl + "/mobile/asset_categories/unhide";

  // ignore: non_constant_identifier_names
  static final String EDIT_CONTRIBUTION_SETTING =
      CustomHelper.baseUrl + "/mobile/setup_tasks/edit_contribution_setting";
  // ignore: non_constant_identifier_names
  static final String CREATE_CONTRIBUTION_SETTING = CustomHelper.baseUrl +
      "/mobile/setup_tasks/create_group_contribution_setting";
  // ignore: non_constant_identifier_names
  static final String ADD_MEMBERS_CONTRIBUTION_SETTING =
      CustomHelper.baseUrl + "/mobile/setup_tasks/contributing_members";
  // ignore: non_constant_identifier_names
  static final String FINE_CONTRIBUTION_SETTING =
      CustomHelper.baseUrl + "/mobile/setup_tasks/contribution_fine_settings";
  // ignore: non_constant_identifier_names
  static final String CONTRIBUTIONS_LIST_DELETE =
      CustomHelper.baseUrl + "/mobile/contributions/delete";
  // ignore: non_constant_identifier_names
  static final String CONTRIBUTIONS_LIST_HIDE =
      CustomHelper.baseUrl + "/mobile/contributions/hide";
  // ignore: non_constant_identifier_names
  static final String CONTRIBUTIONS_LIST_UNHIDE =
      CustomHelper.baseUrl + "/mobile/contributions/unhide";

  // ignore: non_constant_identifier_names
  static final String EDIT_EXPENSE_CATEGORY =
      CustomHelper.baseUrl + "/mobile/expense_categories/edit";
  // ignore: non_constant_identifier_names
  static final String CREATE_EXPENSE_CATEGORY =
      CustomHelper.baseUrl + "/mobile/expense_categories/create";
  // ignore: non_constant_identifier_names
  static final String EXPENSE_CATEGORIES_DELETE =
      CustomHelper.baseUrl + "/mobile/expense_categories/delete";
  // ignore: non_constant_identifier_names
  static final String EXPENSE_CATEGORIES_HIDE =
      CustomHelper.baseUrl + "/mobile/expense_categories/hide";
  // ignore: non_constant_identifier_names
  static final String EXPENSE_CATEGORIES_UNHIDE =
      CustomHelper.baseUrl + "/mobile/expense_categories/unhide";

  // ignore: non_constant_identifier_names
  static final String EDIT_FINE_CATEGORY =
      CustomHelper.baseUrl + "/mobile/fine_categories/edit";
  // ignore: non_constant_identifier_names
  static final String CREATE_FINE_CATEGORY =
      CustomHelper.baseUrl + "/mobile/fine_categories/create";
  // ignore: non_constant_identifier_names
  static final String FINE_CATEGORIES_DELETE =
      CustomHelper.baseUrl + "/mobile/fine_categories/delete";
  // ignore: non_constant_identifier_names
  static final String FINE_CATEGORIES_HIDE =
      CustomHelper.baseUrl + "/mobile/fine_categories/hide";
  // ignore: non_constant_identifier_names
  static final String FINE_CATEGORIES_UNHIDE =
      CustomHelper.baseUrl + "/mobile/fine_categories/unhide";

  // ignore: non_constant_identifier_names
  static final String INCOME_CATEGORIES_DELETE =
      CustomHelper.baseUrl + "/mobile/income_categories/delete";
  // ignore: non_constant_identifier_names
  static final String INCOME_CATEGORIES_HIDE =
      CustomHelper.baseUrl + "/mobile/income_categories/hide";
  // ignore: non_constant_identifier_names
  static final String INCOME_CATEGORIES_UNHIDE =
      CustomHelper.baseUrl + "/mobile/income_categories/unhide";

  // ignore: non_constant_identifier_names
  static final String EDIT_GROUP_ROLE =
      CustomHelper.baseUrl + "/mobile/group_roles/edit";
  // ignore: non_constant_identifier_names
  static final String CREATE_GROUP_ROLE =
      CustomHelper.baseUrl + "/mobile/group_roles/create";

  //Loans related APIs
  // ignore: non_constant_identifier_names
  static final String GET_LOAN_DETAILS =
      CustomHelper.baseUrl + "/mobile/loans/get_group_loan";
  // ignore: non_constant_identifier_names
  static final String EDIT_MEMBER_LOAN =
      CustomHelper.baseUrl + "/mobile/loans/edit_member_loan";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_LOAN_TYPES =
      CustomHelper.baseUrl + "/mobile/loan_types/get_group_loan_types_list";
  // ignore: non_constant_identifier_names
  static final String CREATE_LOAN_TYPE =
      CustomHelper.baseUrl + "/mobile/loan_types/create";
  // ignore: non_constant_identifier_names
  static final String EDIT_LOAN_TYPE =
      CustomHelper.baseUrl + "/mobile/loan_types/edit";
  // ignore: non_constant_identifier_names
  static final String UPDATE_LOAN_TYPE_FINES =
      CustomHelper.baseUrl + "/mobile/loan_types/update_loan_type_fines";
  // ignore: non_constant_identifier_names
  static final String UPDATE_LOAN_TYPE_DETAILS =
      CustomHelper.baseUrl + "/mobile/loan_types/update_general_details";
  // ignore: non_constant_identifier_names
  static final String GET_LOAN_TYPE_DETAILS =
      CustomHelper.baseUrl + "/mobile/loan_types/get_group_loan_type";
  // ignore: non_constant_identifier_names
  static final String LOAN_TYPES_HIDE =
      CustomHelper.baseUrl + "/mobile/loan_types/hide";
  // ignore: non_constant_identifier_names
  static final String LOAN_TYPES_UNHIDE =
      CustomHelper.baseUrl + "/mobile/loan_types/unhide";
  // ignore: non_constant_identifier_names
  static final String LOAN_TYPES_DELETE =
      CustomHelper.baseUrl + "/mobile/loan_types/delete";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_LOAN_TYPE_OPTIONS =
      CustomHelper.baseUrl + "/mobile/loan_types/get_group_loan_type_options";
  // ignore: non_constant_identifier_names
  static final GET_GROUP_MEMBER_LOANS_SUMMARY =
      CustomHelper.baseUrl + "/mobile/get_group_member_loans_summary";

  //Notifications
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_NOTIFICATIONS = CustomHelper.baseUrl +
      "/mobile/notifications/get_all_group_member_notifications";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_INVOICE_DETAILS =
      CustomHelper.baseUrl + "/mobile/invoices/get_group_invoice";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_DEPOSIT_DETAILS =
      CustomHelper.baseUrl + "/mobile/deposits/get_group_deposit";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_WITHDRAWAL_DETAILS =
      CustomHelper.baseUrl + "/mobile/withdrawals/get_group_withdrawal";
  // ignore: non_constant_identifier_names
  static final String MARK_AS_READ_NOTIFICATION =
      CustomHelper.baseUrl + "/mobile/notifications/mark_as_read";
  // ignore: non_constant_identifier_names
  static final String MARK_ALL_AS_READ_NOTIFICATION =
      CustomHelper.baseUrl + "/mobile/notifications/mark_all_as_read";
  // ignore: non_constant_identifier_names
  static final String GET_NOTIFICATION_COUNT = CustomHelper.baseUrl +
      "/mobile/notifications/get_group_member_notification_count";

  //Country and currency list
  // ignore: non_constant_identifier_names
  static final String GET_COUNTRY_LIST =
      CustomHelper.baseUrl + "/mobile/countries/get_country_options";
  // ignore: non_constant_identifier_names
  static final String GET_CURRENCY_LIST =
      CustomHelper.baseUrl + "/mobile/countries/get_currency_options";

  //update group profile
  // ignore: non_constant_identifier_names
  static final String UPDATE_GROUP_NAME =
      CustomHelper.baseUrl + "/mobile/groups/update_name";
  // ignore: non_constant_identifier_names
  static final String UPDATE_GROUP_EMAIL =
      CustomHelper.baseUrl + "/mobile/groups/update_email";
  // ignore: non_constant_identifier_names
  static final String UPDATE_GROUP_PHONE_NUMBER =
      CustomHelper.baseUrl + "/mobile/groups/update_phone";
  // ignore: non_constant_identifier_names
  static final String UPDATE_GROUP_COUNTRY =
      CustomHelper.baseUrl + "/mobile/groups/update_country";
  // ignore: non_constant_identifier_names
  static final String UPDATE_GROUP_CURRENCY =
      CustomHelper.baseUrl + "/mobile/groups/update_currency";
  // ignore: non_constant_identifier_names
  static final String UPDATE_GROUP_SETTINGS =
      CustomHelper.baseUrl + "/mobile/groups/update_group_settings";

  //Investments
  // ignore: non_constant_identifier_names
  static final String GET_ASSET_PURCHASE_PAYMENTS =
      CustomHelper.baseUrl + "/mobile/assets/asset_purchase_payments";
  // ignore: non_constant_identifier_names
  static final String CREATE_ASSET =
      CustomHelper.baseUrl + "/mobile/assets/create_asset";
  // ignore: non_constant_identifier_names
  static final String VOID_ASSET_PURCHASE_PAYMENT =
      CustomHelper.baseUrl + "/mobile/assets/void_asset_purchase_payment";
  // ignore: non_constant_identifier_names
  static final String GET_ASSET_SALES_LIST =
      CustomHelper.baseUrl + "/mobile/assets/asset_sales_list";
  // ignore: non_constant_identifier_names
  static final String GET_ASSET_LISTING =
      CustomHelper.baseUrl + "/mobile/assets/get_group_assets";
  // ignore: non_constant_identifier_names
  static final String GET_STOCK_LISTING =
      CustomHelper.baseUrl + "/mobile/stocks/get_group_stocks_list";
  // ignore: non_constant_identifier_names
  static final String RECORD_STOCK_PURCHASE =
      CustomHelper.baseUrl + "/mobile/stocks/record_stock_purchase";
  // ignore: non_constant_identifier_names
  static final String UPDATE_STOCK_CURRENT_PRICE =
      CustomHelper.baseUrl + "/mobile/stocks/update_stock_current_price";
  // ignore: non_constant_identifier_names
  static final String SELL_STOCKS =
      CustomHelper.baseUrl + "/mobile/stocks/sell_stocks";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_STOCK_SALES_LIST =
      CustomHelper.baseUrl + "/mobile/stocks/get_group_stock_sales_list";
  // ignore: non_constant_identifier_names
  static final String GET_MONEY_MARKET_LISTING = CustomHelper.baseUrl +
      "/mobile/money_market_investments/get_money_market_investment_list";
  // ignore: non_constant_identifier_names
  static final String CREATE_MONEY_MARKET_INVESTMENT =
      CustomHelper.baseUrl + "/mobile/money_market_investments/create";
  // ignore: non_constant_identifier_names
  static final String TOPUP_MONEY_MARKET_INVESTMENT =
      CustomHelper.baseUrl + "/mobile/money_market_investments/topup";
  // ignore: non_constant_identifier_names
  static final String CASHIN_MONEY_MARKET_INVESTMENT =
      CustomHelper.baseUrl + "/mobile/money_market_investments/cashin";
  // ignore: non_constant_identifier_names
  static final String CASHIN_MONEY_MARKET_LISTING = CustomHelper.baseUrl +
      "/mobile/money_market_investments/get_money_market_investment_cashins";
  // ignore: non_constant_identifier_names
  static final String SELL_ASSET = CustomHelper.baseUrl + "/mobile/assets/sell";
  // ignore: non_constant_identifier_names
  static final String RECORD_ASSET_PURCHASE =
      CustomHelper.baseUrl + "/mobile/assets/record_asset_purchase_payments";
  // ignore: non_constant_identifier_names
  static final String VOID_STOCK = CustomHelper.baseUrl + "/mobile/stocks/void";
  // ignore: non_constant_identifier_names
  static final String VOID_MONEY_MARKET_INVESTMENT =
      CustomHelper.baseUrl + "/mobile/money_market_investments/void";
  // ignore: non_constant_identifier_names
  static final String CANCEL_WITHDRAWAL_REQUEST =
      CustomHelper.baseUrl + "/mobile/withdrawals/cancel_withdrawal_request";

  //Billing
  // ignore: non_constant_identifier_names
  static final String GET_BILLING_INVOICES =
      CustomHelper.baseUrl + "/mobile/billing/get_group_billing_invoices";
  // ignore: non_constant_identifier_names
  static final String GET_SUBSCRIPTION_PAYMENTS =
      CustomHelper.baseUrl + "/mobile/billing/get_group_billing_payments";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_AMOUNT_PAYABLES =
      CustomHelper.baseUrl + "/mobile/billing/get_group_amount_payables";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_AMOUNT_PAYABLE =
      CustomHelper.baseUrl + "/mobile/billing/get_group_amount_payable";
  // ignore: non_constant_identifier_names
  static final String GET_USD_CONVERSION =
      CustomHelper.baseUrl + "/mobile/billing/calculate_conversion";
  // ignore: non_constant_identifier_names
  static final String SUBMIT_PAYPAL_RESPONSE =
      CustomHelper.baseUrl + "/mobile/billing/receive_complete_billing";
  // ignore: non_constant_identifier_names
  static final String SUBMIT_MPESA_REQUEST =
      CustomHelper.baseUrl + "/mobile/billing/make_mpesa_payment";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_USER_SUMMARIES =
      CustomHelper.baseUrl + "/mobile/get_group_more_dashboard_data";
  // ignore: non_constant_identifier_names
  static final String CALCULATE_COUPON_VALUE =
      CustomHelper.baseUrl + "/mobile/billing/calculate_coupon";
  // ignore: non_constant_identifier_names
  static final String CONFIRM_FREE_BILLLING =
      CustomHelper.baseUrl + "/mobile/billing/confirm_free_billing";

  //Void Transactions
  // ignore: non_constant_identifier_names
  static final String VOID_ASSET = CustomHelper.baseUrl + "/mobile/assets/void";
  // ignore: non_constant_identifier_names
  static final String VOID_WITHDRAWAL =
      CustomHelper.baseUrl + "/mobile/withdrawals/void";
  // ignore: non_constant_identifier_names
  static final String VOID_INVOICE =
      CustomHelper.baseUrl + "/mobile/invoices/void";
  // ignore: non_constant_identifier_names
  static final String VOID_DEPOSIT =
      CustomHelper.baseUrl + "/mobile/deposits/void";
  // ignore: non_constant_identifier_names
  static final String VOID_LOAN = CustomHelper.baseUrl + "/mobile/loans/void";
  // ignore: non_constant_identifier_names
  static final String VOID_BANK_LOAN =
      CustomHelper.baseUrl + "/mobile/deposits/void_bank_loan";
  // ignore: non_constant_identifier_names
  static final String VOID_CONTRIBUTION_TRANSFER =
      CustomHelper.baseUrl + "/mobile/deposits/void_contribution_transfer";

  //Reports
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_INVOICES =
      CustomHelper.baseUrl + "/mobile/invoices/get_group_invoices";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_FINES_LIST =
      CustomHelper.baseUrl + "/mobile/fines/get_group_fines_list";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_CONTRIBUTION_TRANSFERS = CustomHelper.baseUrl +
      "/mobile/deposits/get_group_contribution_transfers";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_WITHDRAWAL_REQUESTS =
      CustomHelper.baseUrl + "/mobile/withdrawals/withdrawal_request_list";
  // ignore: non_constant_identifier_names
  static final String GET_ACCOUNT_BALANCES =
      CustomHelper.baseUrl + "/mobile/reports/account_balances";
  // ignore: non_constant_identifier_names
  static final String GET_BANK_LOAN_SUMMARY =
      CustomHelper.baseUrl + "/mobile/reports/bank_loans_summary";
  // ignore: non_constant_identifier_names
  static final String GET_EXPENSES_SUMMARY =
      CustomHelper.baseUrl + "/mobile/reports/expenses_summary";
  // ignore: non_constant_identifier_names
  static final String GET_LOANS_SUMMARY =
      CustomHelper.baseUrl + "/mobile/reports/loans_summary";
  // ignore: non_constant_identifier_names
  static final String GET_CONTRIBUTION_SUMMARY =
      CustomHelper.baseUrl + "/mobile/reports/contribution_summary";
  // ignore: non_constant_identifier_names
  static final String GET_FINE_SUMMARY =
      CustomHelper.baseUrl + "/mobile/reports/fines_summary";
  // ignore: non_constant_identifier_names
  static final String GET_TRANSACTION_STATEMENT =
      CustomHelper.baseUrl + "/mobile/reports/transaction_statement";
  // ignore: non_constant_identifier_names
  static final String GET_CONTRIBUTION_STATEMENT =
      CustomHelper.baseUrl + "/mobile/statements/contribution_statement";
  // ignore: non_constant_identifier_names
  static final String GET_FINE_STATEMENT =
      CustomHelper.baseUrl + "/mobile/statements/fine_statement";
  // ignore: non_constant_identifier_names
  static final String GET_LOAN_STATEMENT =
      CustomHelper.baseUrl + "/mobile/loans/statement";
  // ignore: non_constant_identifier_names
  static final String GET_FINES_SUMMARY =
      CustomHelper.baseUrl + "/mobile/get_group_member_fines_summary";
  // ignore: non_constant_identifier_names
  static final String GET_RECENT_MEMBER_TRANSACTIONS =
  CustomHelper.baseUrl + "/mobile/get_member_recent_transactions";

  //Meetings
  // ignore: non_constant_identifier_names
  static final String GET_MEETINGS =
      CustomHelper.baseUrl + "/mobile/meetings/get_group_meetings";
  // ignore: non_constant_identifier_names
  static final String CREATE_MEETING =
      CustomHelper.baseUrl + "/mobile/meetings/create_group_meeting";

  // ignore: non_constant_identifier_names
  static final String COMPLETE_GROUP_SETUP =
      CustomHelper.baseUrl + "/mobile/complete_group_setup";

  //Chamasoft loans
  // ignore: non_constant_identifier_names
  static final String GET_CHAMASOFT_LOAN_PRODUCTS =
      CustomHelper.baseUrl + "/mobile/chamasoft_loans/loan_products_list";
  // ignore: non_constant_identifier_names
  static final String CREATE_CHAMASOFT_LOAN_APPLICATION = CustomHelper.baseUrl +
      "/mobile/chamasoft_loans/create_chamasoft_loan_application";
  // ignore: non_constant_identifier_names
  static final String CREATE_GROUP_LOAN_APPLICATION = CustomHelper.baseUrl +
      "/mobile/chamasoft_loans/create_group_loan_application";
  // ignore: non_constant_identifier_names
  static final String GET_CHAMASOFT_LOAN_CALCULATOR = CustomHelper.baseUrl +
      "/mobile/chamasoft_loans/get_chamasoft_loan_calculator";
  // ignore: non_constant_identifier_names
  static final String GET_GROUP_LOAN_CALCULATOR = CustomHelper.baseUrl +
      "/mobile/chamasoft_loans/get_group_loan_calculator";
}
