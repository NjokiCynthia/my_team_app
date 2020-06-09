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
  "",
  "Bank Account",
  "Sacco Account",
  "Mobile Money Account",
  "Petty Cash Account"
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
        title: "Bank Accounts List",
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
            return ListView.separated(
              padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
              itemCount: groupData.accounts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.label,
                                color: Colors.blueGrey,
                              ),
                              SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${groupData.accounts[index].name}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              smallBadgeButton(
                                backgroundColor: primaryColor.withOpacity(0.2),
                                textColor: primaryColor,
                                text:
                                    '${accountTypes[groupData.accounts[index].typeId]}',
                                action: () {},
                                buttonHeight: 24.0,
                                textSize: 12.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Theme.of(context).dividerColor,
                  height: 6.0,
                );
              },
            );
          })),
    );
  }
}
