import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';
import 'package:chamasoft/screens/chamasoft/settings/create-mobile-money-account.dart';
import 'package:chamasoft/screens/chamasoft/settings/create-sacco-account.dart';
import 'package:chamasoft/screens/chamasoft/settings/edit-sacco-account.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'create-bank-account.dart';
import 'create-petty-cash-account.dart';
import 'edit-bank-account.dart';
import 'edit-mobile-money-account.dart';
import 'edit-petty-cash-account.dart';

List<String> accountTypes = ["Bank Accounts", "Sacco Accounts", "Mobile Money Accounts", "Petty Cash Accounts"];

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
      await Provider.of<Groups>(context, listen: false).fetchMobileMoneyProviderOptions();
      return true;
    } on CustomException catch (error) {
      print(error.message);
      return false;
    }
  }

  Future<void> _fetchAccounts(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).temporaryFetchAccounts();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchAccounts(context);
          });
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
      body: Builder(builder: (BuildContext context) {
        return RefreshIndicator(
          onRefresh: () => _fetchAccounts(context),
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: primaryGradient(context),
              child: Consumer<Groups>(builder: (context, groupData, child) {
                List<CategorisedAccount> accounts = groupData.getAllCategorisedAccounts;
                return accounts.length > 0
                    ? ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                        itemCount: groupData.getAllCategorisedAccounts.length,
                        itemBuilder: (context, index) {
                          CategorisedAccount account = accounts[index];
                          if (account.isHeader) {
                            return Padding(
                              padding:
                                  index == 0 ? const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0) : const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                              child: customTitle(
                                text: account.title,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start,
                                color: Theme.of(context).textSelectionHandleColor.withOpacity(0.6),
                                fontSize: 13.0,
                              ),
                            );
                          } else
                            return ListTile(
                              contentPadding: EdgeInsets.only(left: 16.0),
                              leading: Icon(
                                Icons.credit_card,
                                color: Colors.blueGrey,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        customTitleWithWrap(
                                          text: account.name,
                                          color: Theme.of(context).textSelectionHandleColor,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15.0,
                                        ),
                                        account.accountNumber.isNotEmpty
                                            ? customTitle(
                                                text: account.accountNumber,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.start,
                                                color: Theme.of(context).textSelectionHandleColor.withOpacity(0.5),
                                                fontSize: 12.0,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: circleIconButton(
                                  icon: Icons.edit,
                                  backgroundColor: primaryColor.withOpacity(.3),
                                  color: primaryColor,
                                  iconSize: 18.0,
                                  padding: 0.0,
                                  onPressed: () {
                                    if (account.typeId == 1) {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => EditBankAccount(
                                          bankAccountId: int.parse(account.id),
                                        ),
                                      ));
                                    } else if (account.typeId == 2) {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => EditSaccoAccount(
                                          saccoAccountId: int.parse(account.id),
                                        ),
                                      ));
                                    } else if (account.typeId == 3) {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => EditMobileMoneyAccount(
                                          mobileMoneyAccountId: int.parse(account.id),
                                        ),
                                      ));
                                    } else if (account.typeId == 4) {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => EditPettyCashAccount(
                                          pettyCashAccountId: int.parse(account.id),
                                        ),
                                      ));
                                    }
                                  },
                                ),
                              ),
                            );
                        },
                        separatorBuilder: (context, index) {
                          CategorisedAccount account = accounts[index];
                          if (account.isHeader) {
                            return Container();
                          } else
                            return Divider(
                              color: Theme.of(context).dividerColor,
                              height: 2.0,
                            );
                        },
                      )
                    : Container();
              })),
        );
      }),
    );
  }
}
