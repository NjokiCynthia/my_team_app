import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';
import 'package:chamasoft/screens/chamasoft/settings/accounts/create-mobile-money-account.dart';
import 'package:chamasoft/screens/chamasoft/settings/accounts/create-sacco-account.dart';
import 'package:chamasoft/screens/chamasoft/settings/accounts/edit-sacco-account.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'accounts/create-bank-account.dart';
import 'accounts/create-petty-cash-account.dart';
import 'accounts/edit-bank-account.dart';
import 'accounts/edit-mobile-money-account.dart';
import 'accounts/edit-petty-cash-account.dart';

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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            fetchBankOptions(context);
          });
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

  Future<void> _fetchAccounts(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .temporaryFetchAccounts();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchAccounts(context);
          });
    }
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text(
                    'Add Bank Account',
                    style: TextStyle(
                      // ignore: deprecated_member_use
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
                    Navigator.pop(context); //pop bottom sheet

                    final result =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateBankAccount(),
                    ));
                    if (result != null) {
                      int status = int.tryParse(result.toString()) ?? 0;
                      if (status == 1) {
                        _refreshIndicatorKey.currentState.show();
                        _fetchAccounts(context);
                      }
                    }
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text(
                    'Add Sacco Account',
                    style: TextStyle(
                      // ignore: deprecated_member_use
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
                    Navigator.pop(context); //pop bottom sheet

                    final result =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateSaccoAccount(),
                    ));

                    if (result != null) {
                      int status = int.tryParse(result.toString()) ?? 0;
                      if (status == 1) {
                        _refreshIndicatorKey.currentState.show();
                        _fetchAccounts(context);
                      }
                    }
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text(
                    'Add Mobile Money Account',
                    style: TextStyle(
                      // ignore: deprecated_member_use
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
                    Navigator.pop(context); //pop bottom sheet

                    final result =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateMobileMoneyAccount(),
                    ));

                    if (result != null) {
                      int status = int.tryParse(result.toString()) ?? 0;
                      if (status == 1) {
                        _refreshIndicatorKey.currentState.show();
                        _fetchAccounts(context);
                      }
                    }
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text(
                    'Add Petty Cash Account',
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context); //pop bottom sheet

                    final result =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreatePettyCashAccount(),
                    ));

                    if (result != null) {
                      int status = int.tryParse(result.toString()) ?? 0;
                      if (status == 1) {
                        _refreshIndicatorKey.currentState.show();
                        _fetchAccounts(context);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: secondaryPageAppbar(
        elevation: 0,
        context: context,
        action: () => Navigator.of(context).pop(),
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Accounts",
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        onPressed: () => _showActions(context),
      ),
      body: Builder(builder: (BuildContext context) {
        return RefreshIndicator(
          backgroundColor: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Colors.white,
          key: _refreshIndicatorKey,
          onRefresh: () => _fetchAccounts(context),
          child: Container(
              color: Theme.of(context).backgroundColor,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // decoration: primaryGradient(context),
              child: Consumer<Groups>(builder: (context, groupData, child) {
                List<CategorisedAccount> accounts =
                    groupData.getAllCategorisedAccounts;
                return accounts.length > 0
                    ? ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                        itemCount: groupData.getAllCategorisedAccounts.length,
                        itemBuilder: (context, index) {
                          CategorisedAccount account = accounts[index];
                          if (account.isHeader) {
                            return Padding(
                              padding: index == 0
                                  ? const EdgeInsets.fromLTRB(
                                      16.0, 4.0, 16.0, 0.0)
                                  : const EdgeInsets.fromLTRB(
                                      16.0, 16.0, 16.0, 0.0),
                              child: customTitle(
                                text: account.title,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start,
                                color: Theme.of(context)
                                    // ignore: deprecated_member_use
                                    .textSelectionHandleColor
                                    .withOpacity(0.6),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        customTitleWithWrap(
                                          text: account.name,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15.0,
                                        ),
                                        account.accountNumber.isNotEmpty
                                            ? customTitle(
                                                text: account.accountNumber,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.start,
                                                color: Theme.of(context)
                                                    // ignore: deprecated_member_use
                                                    .textSelectionHandleColor
                                                    .withOpacity(0.5),
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
                                  onPressed: () async {
                                    if (account.typeId == 1) {
                                      final result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => EditBankAccount(
                                          bankAccountId: int.parse(account.id),
                                        ),
                                      ));
                                      if (result != null) {
                                        int status =
                                            int.tryParse(result.toString()) ??
                                                0;
                                        if (status == 1) {
                                          _refreshIndicatorKey.currentState
                                              .show();
                                          _fetchAccounts(context);
                                        }
                                      }
                                    } else if (account.typeId == 2) {
                                      final result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => EditSaccoAccount(
                                          saccoAccountId: int.parse(account.id),
                                        ),
                                      ));
                                      if (result != null) {
                                        int status =
                                            int.tryParse(result.toString()) ??
                                                0;
                                        if (status == 1) {
                                          _refreshIndicatorKey.currentState
                                              .show();
                                          _fetchAccounts(context);
                                        }
                                      }
                                    } else if (account.typeId == 3) {
                                      final result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            EditMobileMoneyAccount(
                                          mobileMoneyAccountId:
                                              int.parse(account.id),
                                        ),
                                      ));
                                      if (result != null) {
                                        int status =
                                            int.tryParse(result.toString()) ??
                                                0;
                                        if (status == 1) {
                                          _refreshIndicatorKey.currentState
                                              .show();
                                          _fetchAccounts(context);
                                        }
                                      }
                                    } else if (account.typeId == 4) {
                                      final result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            EditPettyCashAccount(
                                          pettyCashAccountId:
                                              int.parse(account.id),
                                        ),
                                      ));
                                      if (result != null) {
                                        int status =
                                            int.tryParse(result.toString()) ??
                                                0;
                                        if (status == 1) {
                                          _refreshIndicatorKey.currentState
                                              .show();
                                          _fetchAccounts(context);
                                        }
                                      }
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
                    : betterEmptyList(
                        message: "Sorry, you have not added any accounts");
              })),
        );
      }),
    );
  }
}
