import 'custom-helper.dart';

class EndpointUrl {
  //Dashboard
  static const String GET_MEMBERS_AND_DETAILS = CustomHelper.baseUrl + "/mobile/members/get_members_and_details";
  static const String GET_MEMBER_DASHBOARD = CustomHelper.baseUrl + "/mobile/get_member_dashboard";

  //On-boarding
  static const String GENERATE_OTP = CustomHelper.baseUrl + "/mobile/generate_pin";
  static const String VERIFY_OTP = CustomHelper.baseUrl + "/mobile/verify_pin";
  static const String RESEND_OTP = CustomHelper.baseUrl + "/mobile/resend_pin";
  static const String FORGOT_PASSWORD = CustomHelper.baseUrl + "/mobile/forgot_password";
  static const String RESEND_FORGOT_PASSWORD_OTP = CustomHelper.baseUrl + "/mobile/resend_forgot_password_code";
  static const String RESET_PASSWORD = CustomHelper.baseUrl + "/mobile/reset_password";
  static const String VALIDATE_FORGOT_PASSWORD_CODE = CustomHelper.baseUrl + "/mobile/validate_forgot_password_code";
  static const String LOGIN = CustomHelper.baseUrl + "/mobile/login";
  static const String SIGNUP = CustomHelper.baseUrl + "/mobile/register_user";
  static const String UPDATE_USER_NAME = CustomHelper.baseUrl+"/mobile/users/update_name";
  static const String UPDATE_USER_EMAIL_ADDRESS = CustomHelper.baseUrl+"/mobile/users/update_email";

  //Initial group setup
  static const String CREATE_GROUP = CustomHelper.baseUrl + "/mobile/create_group";
  static const String GET_MEMBERS = CustomHelper.baseUrl + "/mobile/members/get_members_and_details";
  static const String ADD_MEMBERS = CustomHelper.baseUrl + "/mobile/setup_tasks/add_group_members";
  static const String GET_GROUP_UNASSIGNED_ROLES = CustomHelper.baseUrl + "/mobile/group_roles/get_group_unassigned_roles";
  static const String GET_GROUP_UNASSIGNED_ROLE_IDS = CustomHelper.baseUrl + "/mobile/group_roles/get_group_unassigned_role_ids";

  //Payment
  static const String MAKE_PAYMENT = CustomHelper.baseUrl + "/mobile/deposits/make_group_payment";
  static const String MAKE_ARREARS_PAYMENT = CustomHelper.baseUrl + "/mobile/deposits/make_group_arrears_payment";
  static const String CALCULATE_CONVENIENCE_FEE = CustomHelper.baseUrl + "/mobile/deposits/calculate_convenience_charge";

  static const String GET_GROUPS = CustomHelper.baseUrl + "/mobile/get_user_checkin_data";
  static const String GET_GROUP_DATA = CustomHelper.baseUrl + "/mobile/get_group_data";
  static const String GET_GROUP_MEMBERS = CustomHelper.baseUrl + "/mobile/members/get_group_member_options";
  static const String GET_GROUP_ACCOUNT_OPTIONS = CustomHelper.baseUrl + "/mobile/accounts/get_group_active_account_options";
  static const String GET_GROUP_ALL_ACCOUNT_OPTIONS = CustomHelper.baseUrl + "/mobile/accounts/get_group_account_options";
  static const String GET_GROUP_FINE_OPTIONS = CustomHelper.baseUrl + "/mobile/fine_categories/get_group_fine_category_options";
  static const String GET_MEMBER_LOAN_TYPE_OPTIONS = CustomHelper.baseUrl + "/mobile/loans/get_member_loan_options";
  static const String GET_GROUP_CONTRIBUTIONS_OPTIONS = CustomHelper.baseUrl + "/mobile/contributions/get_group_contribution_options";
  static const String GET_MEMBER_CONTRIBUTIONS_OPTIONS = CustomHelper.baseUrl + "/mobile/contributions/get_member_contribution_options";

  static const String GET_DEPOSITS_LIST = CustomHelper.baseUrl + "/mobile/deposits/get_deposits_list";
  static const String GET_GROUP_WITHDRAWAL_LIST = CustomHelper.baseUrl + "/mobile/withdrawals/get_group_withdrawal_list";
  static const String GET_GROUP_LOAN_LIST = CustomHelper.baseUrl + "/mobile/loans/get_group_loans_list";

  //Record
  static const String RECORD_MEMBER_LOAN = CustomHelper.baseUrl + "/mobile/loans/record_member_loan";
  static const String RECORD_CONTRIBUTION_PAYMENTS = CustomHelper.baseUrl + "/mobile/deposits/record_contribution_payments";
  static const String NEW_RECORD_CONTRIBUTION_PAYMENTS = CustomHelper.baseUrl + "/mobile/deposits/new_record_contribution_payments";
  static const String RECORD_FINE_PAYMENTS = CustomHelper.baseUrl + "/mobile/deposits/record_fine_payments";
  static const String NEW_RECORD_FINE_PAYMENTS = CustomHelper.baseUrl + "/mobile/deposits/new_record_fine_payments";
  static const String RECORD_LOAN_REPAYMENTS = CustomHelper.baseUrl + "/mobile/deposits/record_loan_repayments";
  static const String RECORD_MISCELLANEOUS_PAYMENTS = CustomHelper.baseUrl + "/mobile/deposits/record_miscellaneous_payments";
  static const String RECORD_INCOME = CustomHelper.baseUrl + "/mobile/deposits/record_income";
  static const String NEW_RECORD_INCOME = CustomHelper.baseUrl + "/mobile/deposits/new_record_income_payment";
  
  static const String RECORD_BANK_LOAN = CustomHelper.baseUrl + "/mobile/deposits/record_bank_loan";
  static const String RECORD_BANK_LOAN_REPAYMENT = CustomHelper.baseUrl + "/mobile/withdrawals/record_bank_loan_repayment";
  static const String RECORD_CONTRIBUTION_REFUND = CustomHelper.baseUrl + "/mobile/withdrawals/record_contribution_refund";
  static const String RECORD_FUNDS_TRANSFER = CustomHelper.baseUrl + "/mobile/withdrawals/record_funds_transfer";
  static const String RECORD_EXPENSES = CustomHelper.baseUrl + "/mobile/withdrawals/record_expenses";
  static const String FINE_MEMBERS = CustomHelper.baseUrl + "/mobile/fines/fine_members";
  static const String RECORD_CONTRIBUTION_TRANSFER = CustomHelper.baseUrl + "/mobile/deposits/record_contribution_transfer";

  static const String GET_GROUP_DEPOSITOR_OPTIONS = CustomHelper.baseUrl + "/mobile/depositors/get_group_depositor_options";
  static const String GET_GROUP_INCOME_CATEGORIES = CustomHelper.baseUrl + "/mobile/income_categories/get_group_income_category_options";
  static const String ADD_NEW_DEPOSITOR = CustomHelper.baseUrl + "/mobile/depositors/create";
  static const String ADD_INCOME_CATEGORY = CustomHelper.baseUrl + "/mobile/income_categories/create";
  static const String EDIT_INCOME_CATEGORY = CustomHelper.baseUrl + "/mobile/income_categories/edit";
  static const String GET_GROUP_EXPENSE_CATEGORY_OPTIONS = CustomHelper.baseUrl + "/mobile/expense_categories/get_group_expense_category_options";
  static const String GET_GROUP_BANK_LOAN_OPTIONS = CustomHelper.baseUrl + "/mobile/bank_loans/get_group_bank_loan_options";

  //Accounts
  static const String GET_BANKS = CustomHelper.baseUrl + "/mobile/banks/get_bank_options";
  static const String GET_BANK_BRANCHES = CustomHelper.baseUrl + "/mobile/bank_branches/get_bank_branches_options";
  static const String GE_MOBILE_PROVIDERS = CustomHelper.baseUrl + "/mobile/mobile_money_providers/get_mobile_money_provider_options";
  static const String GET_SACCOS = CustomHelper.baseUrl + "/mobile/saccos/get_sacco_options";
  static const String GET_SACCO_BRANCHES = CustomHelper.baseUrl + "/mobile/sacco_branches/get_sacco_branches_options";
  static const String ADD_PETTY_CASH_ACCOUNT = CustomHelper.baseUrl + "/mobile/petty_cash_accounts/create";
  static const String EDIT_PETTY_CASH_ACCOUNT = CustomHelper.baseUrl + "/mobile/petty_cash_accounts/edit";
  static const String ADD_BANK_ACCOUNT = CustomHelper.baseUrl + "/mobile/bank_accounts/create";
  static const String EDIT_BANK_ACCOUNT = CustomHelper.baseUrl + "/mobile/bank_accounts/edit";
  static const String ADD_SACCO_ACCOUNT = CustomHelper.baseUrl + "/mobile/sacco_accounts/create";
  static const String EDIT_SACCO_ACCOUNT = CustomHelper.baseUrl + "/mobile/sacco_accounts/edit";
  static const String ADD_MOBILE_MONEY_ACCOUNT = CustomHelper.baseUrl + "/mobile/mobile_money_accounts/create";
  static const String EDIT_MOBILE_MONEY_ACCOUNT = CustomHelper.baseUrl + "/mobile/mobile_money_accounts/edit";
  static const String GET_BANK_ACCOUNTS = CustomHelper.baseUrl + "/mobile/bank_accounts/get_group_bank_accounts_list";
  static const String GET_SACCO_ACCOUNTS = CustomHelper.baseUrl + "/mobile/sacco_accounts/get_group_sacco_accounts_list";
  static const String GET_MOBILE_MONEY_ACCOUNTS = CustomHelper.baseUrl + "/mobile/mobile_money_accounts/get_group_mobile_money_accounts_list";
  static const String GET_PETTY_CASH_ACCOUNTS = CustomHelper.baseUrl + "/mobile/petty_cash_accounts/get_group_petty_cash_accounts_list";
  static const String ENABLE_CHAMASOFT_WALLET = CustomHelper.baseUrl + "/mobile/bank_accounts/activate_wallet";

  //Upload images
  static const String EDIT_USER_PHOTO = CustomHelper.baseUrl + "/mobile/users/edit_profile_photo";
  static const String EDIT_NEW_USER_PHOTO = CustomHelper.baseUrl + "/mobile/users/edit_new_profile_photo";
  static const String EDIT_MEMBER_PHOTO = CustomHelper.baseUrl + "/mobile/members/edit_profile_photo";
  static const String EDIT_GROUP_PHOTO = CustomHelper.baseUrl + "/mobile/groups/edit_profile_photo";
  static const String EDIT_NEW_GROUP_PHOTO = CustomHelper.baseUrl + "/mobile/groups/edit_new_profile_photo";

  static const String WITHDRAWALS_FUNDS_TRANSFER = CustomHelper.baseUrl + "/mobile/withdrawals/request_funds_transfer";
  static const String VIEW_WITHDRAWAL_REQUEST = CustomHelper.baseUrl + "/mobile/withdrawals/view_withdrawal_request";
  static const String GET_CONTRIBUTIONS = CustomHelper.baseUrl + "/mobile/contributions/get_group_contribution_options";
  static const String RESPOND_TO_WITHDRAWAL_REQUEST = CustomHelper.baseUrl + "/mobile/withdrawals/respond_to_withdrawal_request";
  static const String BANK_ACCOUNTS_CONNECT = CustomHelper.baseUrl + "/mobile/bank_accounts/connect";
  static const String BANK_ACCOUNTS_VERIFY = CustomHelper.baseUrl + "/mobile/bank_accounts/verify";
  static const String BANK_ACCOUNTS_DISCONNECT = CustomHelper.baseUrl + "/mobile/bank_accounts/disconnect";
  static const String GET_GROUP_UNRECONCILED_DEPOSITS = CustomHelper.baseUrl + "/mobile/transaction_alerts/get_group_unreconcilled_deposits";
  static const String GET_GROUP_UNRECONCILED_WITHDRAWALS = CustomHelper.baseUrl + "/mobile/transaction_alerts/get_group_unreconcilled_withdrawals";

  //Selected Setting Apis
  static const String GET_GROUP_CONTRIBUTIONS = CustomHelper.baseUrl + "/mobile/contributions/get_group_contributions";
  static const String GET_GROUP_EXPENSE_CATEGORIES = CustomHelper.baseUrl + "/mobile/expense_categories/get_group_expense_categories";
  static const String GET_GROUP_INCOME_CATEGORIES_LIST = CustomHelper.baseUrl + "/mobile/income_categories/group_income_categories_list";
  static const String GET_GROUP_ASSET_CATEGORIES = CustomHelper.baseUrl + "/mobile/asset_categories/get_group_asset_categories";
  static const String GET_GROUP_FINE_CATEGORIES_LIST = CustomHelper.baseUrl + "/mobile/fine_categories/group_fine_categories_list";
  static const String GET_GROUP_ROLE_LIST = CustomHelper.baseUrl + "/mobile/group_roles/group_roles_list";

  //Contribution
  static const String GET_CONTRIBUTION_DETAILS = CustomHelper.baseUrl + "/mobile/contributions/get_group_contribution";

  //Selected Settings Adapter Api
  static const String EDIT_ASSET_CATEGORY = CustomHelper.baseUrl + "/mobile/asset_categories/edit";
  static const String CREATE_ASSET_CATEGORY = CustomHelper.baseUrl + "/mobile/asset_categories/create";
  static const String ASSET_CATEGORIES_DELETE = CustomHelper.baseUrl + "/mobile/asset_categories/delete";
  static const String ASSET_CATEGORIES_HIDE = CustomHelper.baseUrl + "/mobile/asset_categories/hide";
  static const String ASSET_CATEGORIES_UNHIDE = CustomHelper.baseUrl + "/mobile/asset_categories/unhide";

  static const String EDIT_CONTRIBUTION_SETTING = CustomHelper.baseUrl + "/mobile/setup_tasks/edit_contribution_setting";
  static const String CREATE_CONTRIBUTION_SETTING = CustomHelper.baseUrl + "/mobile/setup_tasks/create_group_contribution_setting";
  static const String ADD_MEMBERS_CONTRIBUTION_SETTING = CustomHelper.baseUrl + "/mobile/setup_tasks/contributing_members";
  static const String FINE_CONTRIBUTION_SETTING = CustomHelper.baseUrl + "/mobile/setup_tasks/contribution_fine_settings";
  static const String CONTRIBUTIONS_LIST_DELETE = CustomHelper.baseUrl + "/mobile/contributions/delete";
  static const String CONTRIBUTIONS_LIST_HIDE = CustomHelper.baseUrl + "/mobile/contributions/hide";
  static const String CONTRIBUTIONS_LIST_UNHIDE = CustomHelper.baseUrl + "/mobile/contributions/unhide";

  static const String EDIT_EXPENSE_CATEGORY = CustomHelper.baseUrl + "/mobile/expense_categories/edit";
  static const String CREATE_EXPENSE_CATEGORY = CustomHelper.baseUrl + "/mobile/expense_categories/create";
  static const String EXPENSE_CATEGORIES_DELETE = CustomHelper.baseUrl + "/mobile/expense_categories/delete";
  static const String EXPENSE_CATEGORIES_HIDE = CustomHelper.baseUrl + "/mobile/expense_categories/hide";
  static const String EXPENSE_CATEGORIES_UNHIDE = CustomHelper.baseUrl + "/mobile/expense_categories/unhide";

  static const String EDIT_FINE_CATEGORY = CustomHelper.baseUrl + "/mobile/fine_categories/edit";
  static const String CREATE_FINE_CATEGORY = CustomHelper.baseUrl + "/mobile/fine_categories/create";
  static const String FINE_CATEGORIES_DELETE = CustomHelper.baseUrl + "/mobile/fine_categories/delete";
  static const String FINE_CATEGORIES_HIDE = CustomHelper.baseUrl + "/mobile/fine_categories/hide";
  static const String FINE_CATEGORIES_UNHIDE = CustomHelper.baseUrl + "/mobile/fine_categories/unhide";

  static const String INCOME_CATEGORIES_DELETE = CustomHelper.baseUrl + "/mobile/income_categories/delete";
  static const String INCOME_CATEGORIES_HIDE = CustomHelper.baseUrl + "/mobile/income_categories/hide";
  static const String INCOME_CATEGORIES_UNHIDE = CustomHelper.baseUrl + "/mobile/income_categories/unhide";

  static const String EDIT_GROUP_ROLE = CustomHelper.baseUrl + "/mobile/group_roles/edit";
  static const String CREATE_GROUP_ROLE = CustomHelper.baseUrl + "/mobile/group_roles/create";

  //Loans related APIs
  static const String GET_LOAN_DETAILS = CustomHelper.baseUrl + "/mobile/loans/get_group_loan";
  static const String EDIT_MEMBER_LOAN = CustomHelper.baseUrl + "/mobile/loans/edit_member_loan";
  static const String GET_GROUP_LOAN_TYPES = CustomHelper.baseUrl + "/mobile/loan_types/get_group_loan_types_list";
  static const String CREATE_LOAN_TYPE = CustomHelper.baseUrl + "/mobile/loan_types/create";
  static const String EDIT_LOAN_TYPE = CustomHelper.baseUrl + "/mobile/loan_types/edit";
  static const String UPDATE_LOAN_TYPE_FINES = CustomHelper.baseUrl + "/mobile/loan_types/update_loan_type_fines";
  static const String UPDATE_LOAN_TYPE_DETAILS = CustomHelper.baseUrl + "/mobile/loan_types/update_general_details";
  static const String GET_LOAN_TYPE_DETAILS = CustomHelper.baseUrl + "/mobile/loan_types/get_group_loan_type";
  static const String LOAN_TYPES_HIDE = CustomHelper.baseUrl + "/mobile/loan_types/hide";
  static const String LOAN_TYPES_UNHIDE = CustomHelper.baseUrl + "/mobile/loan_types/unhide";
  static const String LOAN_TYPES_DELETE = CustomHelper.baseUrl + "/mobile/loan_types/delete";
  static const String GET_GROUP_LOAN_TYPE_OPTIONS = CustomHelper.baseUrl + "/mobile/loan_types/get_group_loan_type_options";

  //Notifications
  static const String GET_GROUP_NOTIFICATIONS = CustomHelper.baseUrl + "/mobile/notifications/get_all_group_member_notifications";
  static const String GET_GROUP_INVOICE_DETAILS = CustomHelper.baseUrl + "/mobile/invoices/get_group_invoice";
  static const String GET_GROUP_DEPOSIT_DETAILS = CustomHelper.baseUrl + "/mobile/deposits/get_group_deposit";
  static const String GET_GROUP_WITHDRAWAL_DETAILS = CustomHelper.baseUrl + "/mobile/withdrawals/get_group_withdrawal";
  static const String MARK_AS_READ_NOTIFICATION = CustomHelper.baseUrl + "/mobile/notifications/mark_as_read";
  static const String MARK_ALL_AS_READ_NOTIFICATION = CustomHelper.baseUrl + "/mobile/notifications/mark_all_as_read";
  static const String GET_NOTIFICATION_COUNT = CustomHelper.baseUrl + "/mobile/notifications/get_group_member_notification_count";

  //Country and currency list
  static const String GET_COUNTRY_LIST = CustomHelper.baseUrl + "/mobile/countries/get_country_options";
  static const String GET_CURRENCY_LIST = CustomHelper.baseUrl + "/mobile/countries/get_currency_options";

  //update group profile
  static const String UPDATE_GROUP_NAME = CustomHelper.baseUrl + "/mobile/groups/update_name";
  static const String UPDATE_GROUP_EMAIL = CustomHelper.baseUrl + "/mobile/groups/update_email";
  static const String UPDATE_GROUP_PHONE_NUMBER = CustomHelper.baseUrl + "/mobile/groups/update_phone";
  static const String UPDATE_GROUP_COUNTRY = CustomHelper.baseUrl + "/mobile/groups/update_country";
  static const String UPDATE_GROUP_CURRENCY = CustomHelper.baseUrl + "/mobile/groups/update_currency";
  static const String UPDATE_GROUP_SETTINGS = CustomHelper.baseUrl + "/mobile/groups/update_group_settings";

  //Investments
  static const String GET_ASSET_PURCHASE_PAYMENTS = CustomHelper.baseUrl + "/mobile/assets/asset_purchase_payments";
  static const String CREATE_ASSET = CustomHelper.baseUrl + "/mobile/assets/create_asset";
  static const String VOID_ASSET_PURCHASE_PAYMENT = CustomHelper.baseUrl + "/mobile/assets/void_asset_purchase_payment";
  static const String GET_ASSET_SALES_LIST = CustomHelper.baseUrl + "/mobile/assets/asset_sales_list";
  static const String GET_ASSET_LISTING = CustomHelper.baseUrl + "/mobile/assets/get_group_assets";
  static const String GET_STOCK_LISTING = CustomHelper.baseUrl + "/mobile/stocks/get_group_stocks_list";
  static const String RECORD_STOCK_PURCHASE = CustomHelper.baseUrl + "/mobile/stocks/record_stock_purchase";
  static const String UPDATE_STOCK_CURRENT_PRICE = CustomHelper.baseUrl + "/mobile/stocks/update_stock_current_price";
  static const String SELL_STOCKS = CustomHelper.baseUrl + "/mobile/stocks/sell_stocks";
  static const String GET_GROUP_STOCK_SALES_LIST = CustomHelper.baseUrl + "/mobile/stocks/get_group_stock_sales_list";
  static const String GET_MONEY_MARKET_LISTING = CustomHelper.baseUrl + "/mobile/money_market_investments/get_money_market_investment_list";
  static const String CREATE_MONEY_MARKET_INVESTMENT = CustomHelper.baseUrl + "/mobile/money_market_investments/create";
  static const String TOPUP_MONEY_MARKET_INVESTMENT = CustomHelper.baseUrl + "/mobile/money_market_investments/topup";
  static const String CASHIN_MONEY_MARKET_INVESTMENT = CustomHelper.baseUrl + "/mobile/money_market_investments/cashin";
  static const String CASHIN_MONEY_MARKET_LISTING = CustomHelper.baseUrl + "/mobile/money_market_investments/get_money_market_investment_cashins";
  static const String SELL_ASSET = CustomHelper.baseUrl + "/mobile/assets/sell";
  static const String RECORD_ASSET_PURCHASE = CustomHelper.baseUrl + "/mobile/assets/record_asset_purchase_payments";
  static const String VOID_STOCK = CustomHelper.baseUrl + "/mobile/stocks/void";
  static const String VOID_MONEY_MARKET_INVESTMENT = CustomHelper.baseUrl + "/mobile/money_market_investments/void";
  static const String CANCEL_WITHDRAWAL_REQUEST = CustomHelper.baseUrl + "/mobile/withdrawals/cancel_withdrawal_request";

  //Billing
  static const String GET_BILLING_INVOICES = CustomHelper.baseUrl + "/mobile/billing/get_group_billing_invoices";
  static const String GET_SUBSCRIPTION_PAYMENTS = CustomHelper.baseUrl + "/mobile/billing/get_group_billing_payments";
  static const String GET_GROUP_AMOUNT_PAYABLES = CustomHelper.baseUrl + "/mobile/billing/get_group_amount_payables";
  static const String GET_GROUP_AMOUNT_PAYABLE = CustomHelper.baseUrl + "/mobile/billing/get_group_amount_payable";
  static const String GET_USD_CONVERSION = CustomHelper.baseUrl + "/mobile/billing/calculate_conversion";
  static const String SUBMIT_PAYPAL_RESPONSE = CustomHelper.baseUrl + "/mobile/billing/receive_complete_billing";
  static const String SUBMIT_MPESA_REQUEST = CustomHelper.baseUrl + "/mobile/billing/make_mpesa_payment";
  static const String GET_RECENT_TRANSACTIONS = CustomHelper.baseUrl + "/mobile/get_member_and_group_chart_data";
  static const String GET_GROUP_USER_SUMMARIES = CustomHelper.baseUrl + "/mobile/get_group_more_dashboard_data";
  static const String CALCULATE_COUPON_VALUE = CustomHelper.baseUrl + "/mobile/billing/calculate_coupon";
  static const String CONFIRM_FREE_BILLLING = CustomHelper.baseUrl + "/mobile/billing/confirm_free_billing";

  //Void Transactions
  static const String VOID_ASSET = CustomHelper.baseUrl + "/mobile/assets/void";
  static const String VOID_WITHDRAWAL = CustomHelper.baseUrl + "/mobile/withdrawals/void";
  static const String VOID_INVOICE = CustomHelper.baseUrl + "/mobile/invoices/void";
  static const String VOID_DEPOSIT = CustomHelper.baseUrl + "/mobile/deposits/void";
  static const String VOID_LOAN = CustomHelper.baseUrl + "/mobile/loans/void";
  static const String VOID_BANK_LOAN = CustomHelper.baseUrl + "/mobile/deposits/void_bank_loan";
  static const String VOID_CONTRIBUTION_TRANSFER = CustomHelper.baseUrl + "/mobile/deposits/void_contribution_transfer";

  //Reports
  static const String GET_GROUP_INVOICES = CustomHelper.baseUrl + "/mobile/invoices/get_group_invoices";
  static const String GET_GROUP_FINES_LIST = CustomHelper.baseUrl + "/mobile/fines/get_group_fines_list";
  static const String GET_GROUP_CONTRIBUTION_TRANSFERS = CustomHelper.baseUrl + "/mobile/deposits/get_group_contribution_transfers";
  static const String GET_GROUP_WITHDRAWAL_REQUESTS = CustomHelper.baseUrl + "/mobile/withdrawals/withdrawal_request_list";
  static const String GET_ACCOUNT_BALANCES = CustomHelper.baseUrl + "/mobile/reports/account_balances";
  static const String GET_BANK_LOAN_SUMMARY = CustomHelper.baseUrl + "/mobile/reports/bank_loans_summary";
  static const String GET_EXPENSES_SUMMARY = CustomHelper.baseUrl + "/mobile/reports/expenses_summary";
  static const String GET_LOANS_SUMMARY = CustomHelper.baseUrl + "/mobile/reports/loans_summary";
  static const String GET_CONTRIBUTION_SUMMARY = CustomHelper.baseUrl + "/mobile/reports/contribution_summary";
  static const String GET_FINE_SUMMARY = CustomHelper.baseUrl + "/mobile/reports/fines_summary";
  static const String GET_TRANSACTION_STATEMENT = CustomHelper.baseUrl + "/mobile/reports/transaction_statement";
  static const String GET_CONTRIBUTION_STATEMENT = CustomHelper.baseUrl + "/mobile/statements/contribution_statement";
  static const String GET_FINE_STATEMENT = CustomHelper.baseUrl + "/mobile/statements/fine_statement";
  static const String GET_LOAN_STATEMENT = CustomHelper.baseUrl + "/mobile/loans/statement";
}
