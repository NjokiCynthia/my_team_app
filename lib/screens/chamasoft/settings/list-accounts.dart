import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/create-mobile-money-account.dart';
import 'package:chamasoft/screens/chamasoft/settings/create-sacco-account.dart';
import 'package:chamasoft/screens/chamasoft/settings/edit-sacco-account.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'create-bank-account.dart';
import 'create-petty-cash-account.dart';
import 'edit-bank-account.dart';
import 'edit-mobile-money-account.dart';
import 'edit-petty-cash-account.dart';

List<String> accountTypes = [
  "Bank Accounts",
  "Sacco Accounts",
  "Mobile Money Accounts",
  "Petty Cash Accounts"
];

class ListAccounts extends StatefulWidget {
  @override
  _ListAccountsState createState() => _ListAccountsState();
}

class _ListAccountsState extends State<ListAccounts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> fetchBankOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchBankOptions();
      return true;
    } on CustomException catch (error) {
      print(error.message);
      return false;
    }
  }

  Future<bool> fetchSaccoOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchSaccoOptions();
      return true;
    } on CustomException catch (error) {
      print(error.message);
      return false;
    }
  }

  Future<bool> fetchMobileMoneyProviderOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchMobileMoneyProviderOptions();
      return true;
    } on CustomException catch (error) {
      print(error.message);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Accounts List",
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Add Bank Account',
                          style: TextStyle(
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                          await fetchBankOptions(context);
                          Navigator.pop(context);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateBankAccount(),
                          ));
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Add Sacco Account',
                          style: TextStyle(
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                          await fetchSaccoOptions(context);
                          Navigator.pop(context);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateSaccoAccount(),
                          ));
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Add Mobile Money Account',
                          style: TextStyle(
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                          await fetchMobileMoneyProviderOptions(context);
                          Navigator.pop(context);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateMobileMoneyAccount(),
                          ));
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Add Petty Cash Account',
                          style: TextStyle(
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreatePettyCashAccount(),
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: primaryGradient(context),
          child: Consumer<Groups>(builder: (context, groupData, child) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: groupData.allAccounts.length,
              itemBuilder: (context, index) {
                String accountTitle = " ";
                int accountType = index;
                accountTitle = accountTypes[index];
                List<Account> accounts = groupData.allAccounts[index];

                return accounts.length > 0
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              accountTitle,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                            itemCount: accounts.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 0.0,
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 16.0),
                                  leading: Icon(
                                    Icons.credit_card,
                                    size: 20,
                                  ),
                                  title: Text(
                                    '${accounts[index].name}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  trailing: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: circleIconButton(
                                      icon: Icons.edit,
                                      backgroundColor:
                                          primaryColor.withOpacity(.3),
                                      color: primaryColor,
                                      iconSize: 18.0,
                                      padding: 0.0,
                                      onPressed: () {
                                        if (accountType == 0) {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                EditBankAccount(
                                              bankAccountId:
                                                  int.parse(accounts[index].id),
                                            ),
                                          ));
                                        } else if (accountType == 1) {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                EditSaccoAccount(
                                              saccoAccountId:
                                                  int.parse(accounts[index].id),
                                            ),
                                          ));
                                        } else if (accountType == 2) {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                EditMobileMoneyAccount(
                                              mobileMoneyAccountId:
                                                  int.parse(accounts[index].id),
                                            ),
                                          ));
                                        } else if (accountType == 3) {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                EditPettyCashAccount(
                                              pettyCashAccountId:
                                                  int.parse(accounts[index].id),
                                            ),
                                          ));
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: Theme.of(context).dividerColor,
                                height: 2.0,
                              );
                            },
                          ),
                        ],
                      )
                    : Container();
              },
            );
          })),
    );
  }
}
