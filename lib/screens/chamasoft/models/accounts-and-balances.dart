class CategorisedAccount {
  String id, name, accountNumber;
  int typeId;
  String title;
  bool isHeader;

  CategorisedAccount.header({this.isHeader, this.title});

  CategorisedAccount({this.isHeader, this.id, this.name, this.accountNumber, this.typeId});
}

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