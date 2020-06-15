import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/create-bank-account.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

List<String> accountTypes = [
  "Bank Accounts",
  "Sacco Accounts",
  "Mobile Money Accounts",
  "Petty Cash Accounts"
];

class ListBankAccounts extends StatefulWidget {
  @override
  _ListBankAccountsState createState() => _ListBankAccountsState();
}

class _ListBankAccountsState extends State<ListBankAccounts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateBankAccount(),
          ));
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
                            padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
                            itemCount: accounts.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
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
                                      icon: Icons.close,
                                      backgroundColor:
                                          Colors.redAccent.withOpacity(.3),
                                      color: Colors.red,
                                      iconSize: 18.0,
                                      padding: 0.0,
                                      onPressed: () {
                                        // TODO: Implement Delete Method
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: Theme.of(context).dividerColor,
                                height: 6.0,
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
