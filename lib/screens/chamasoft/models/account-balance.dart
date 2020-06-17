class AccountBalance {
  String name, accountNumber, balance;
  bool isHeader;
  String header;

  AccountBalance.header({this.isHeader, this.header});

  AccountBalance({this.isHeader, this.name, this.accountNumber, this.balance});
}

class AccountBalanceModel {
  List<AccountBalance> accounts;
  String totalBalance;

  AccountBalanceModel({this.accounts, this.totalBalance});
}
