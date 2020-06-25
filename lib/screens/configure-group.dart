import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/accounts-and-balances.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:provider/provider.dart';

import 'chamasoft/settings/group-setup/list-contacts.dart';

Map<String, String> roles = {
  "1": "Chairperson",
  "2": "Secretary",
  "3": "Member",
  "4": "Treasurer",
  "5": "Other",
};

class ConfigureGroup extends StatefulWidget {
  @override
  _ConfigureGroupState createState() => _ConfigureGroupState();
}

class _ConfigureGroupState extends State<ConfigureGroup> {
  Future<void> _memberFuture, _accountFuture, _contributionFuture;

  Future<void> _getMembers(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchMembers();
    } on CustomException catch (error) {}
  }

  Future<void> _getAccounts(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).temporaryFetchAccounts();
    } on CustomException catch (error) {}
  }

  Future<void> _getContributions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchContributions();
    } on CustomException catch (error) {}
  }

  @override
  void initState() {
    super.initState();
    _memberFuture = _getMembers(context);
    _accountFuture = _getAccounts(context);
    _contributionFuture = _getContributions(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Builder(
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 120.0),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: primaryGradient(context),
                      child: TabBarView(
                        children: <Widget>[
                          FutureBuilder(
                              future: _memberFuture,
                              builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                                  ? Center(child: CircularProgressIndicator())
                                  : RefreshIndicator(
                                      onRefresh: () => _getMembers(context),
                                      child: Consumer<Groups>(builder: (context, data, child) {
                                        List<Member> members = data.members;
                                        print("Count: ${members.length}");
                                        return MembersTabView(members: members);
                                      }))),
                          FutureBuilder(
                            future: _accountFuture,
                            builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                                ? Center(child: CircularProgressIndicator())
                                : RefreshIndicator(
                                    onRefresh: () => _getAccounts(context),
                                    child: Consumer<Groups>(
                                      builder: (context, data, child) {
                                        List<CategorisedAccount> accounts = data.getAllCategorisedAccounts;
                                        return AccountsTabView(accounts: accounts);
                                      },
                                    ),
                                  ),
                          ),
                          FutureBuilder(
                              future: _accountFuture,
                              builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                                  ? Center(child: CircularProgressIndicator())
                                  : RefreshIndicator(
                                      onRefresh: () => _getContributions(context),
                                      child: Consumer<Groups>(builder: (context, data, child) {
                                        List<Contribution> contributions = data.contributions;
                                        return ContributionsTabView(contributions: contributions);
                                      }))),
                        ],
                      )),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      height: 120.0,
                      child: AppBar(
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              screenActionButton(
                                icon: LineAwesomeIcons.arrow_left,
                                backgroundColor: primaryColor.withOpacity(0.1),
                                textColor: primaryColor,
                                action: () => Navigator.of(context).pop(),
                              ),
                              SizedBox(width: 20.0),
                              heading2(color: primaryColor, text: Provider.of<Groups>(context, listen: false).getCurrentGroup().groupName + " Setup"),
                            ],
                          ),
                        ),
                        elevation: 0.0,
                        backgroundColor: (themeChangeProvider.darkTheme) ? Colors.blueGrey[900] : Colors.white54,
                        automaticallyImplyLeading: false,
                        bottom: TabBar(
                          indicator: MD2Indicator(
                            indicatorHeight: 3,
                            indicatorColor: primaryColor,
                            indicatorSize: MD2IndicatorSize.normal,
                          ),
                          labelColor: primaryColor,
                          unselectedLabelColor: Colors.blueGrey,
                          labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          isScrollable: false,
                          labelStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                          tabs: <Widget>[
                            FittedBox(
                              child: customTitle(
                                text: "Members",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            FittedBox(
                                child: customTitle(
                              text: "Accounts",
                              fontWeight: FontWeight.w700,
                            )),
                            FittedBox(
                                child: customTitle(
                              fontWeight: FontWeight.w700,
                              text: "Contributions",
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
//              Positioned(
//                bottom: 30.0,
//                right: 20.0,
//                child: Container(
//                  height: 60.0,
//                  child: FloatingActionButton(
//                    onPressed: () {
//                      int currentIndex = DefaultTabController.of(context).index;
//                      print(currentIndex);
//                      if (currentIndex == 0) {
//                        Navigator.of(context).push(
//                            MaterialPageRoute(builder: (BuildContext context) {
//                          return ListContacts();
//                        }));
//                      }
//                    },
//                    backgroundColor: primaryColor,
//                    child: Icon(
//                      Icons.add,
//                    ),
//                  ),
//                ),
//              ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            int currentIndex = DefaultTabController.of(context).index;
            print(currentIndex);
            if (currentIndex == 0) {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return ListContacts();
              }));
            }
          },
          backgroundColor: primaryColor,
          child: Icon(
            Icons.add,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class AccountsTabView extends StatelessWidget {
  const AccountsTabView({
    Key key,
    @required this.accounts,
  }) : super(key: key);

  final List<CategorisedAccount> accounts;

  @override
  Widget build(BuildContext context) {
    return accounts.length > 0
        ? ListView.builder(
            padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              CategorisedAccount account = accounts[index];
              if (account.isHeader) {
                return Padding(
                  padding: index == 0 ? const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0) : const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: customTitle(
                    text: account.title,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                    color: Theme.of(context).textSelectionHandleColor.withOpacity(0.6),
                    fontSize: 13.0,
                  ),
                );
              } else {
                return ListTile(
                  dense: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.credit_card,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(width: 10.0),
                            Flexible(
                              fit: FlexFit.tight,
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
                      ), //                                                    Expanded(
//                                                      flex: 1,
//                                                      child: FittedBox(
//                                                        child: Row(
//                                                          mainAxisAlignment: MainAxisAlignment.end,
//                                                          children: <Widget>[
//                                                            smallBadgeButton(
//                                                              backgroundColor: (accounts[index]['status'].toString().toLowerCase() == "connected")
//                                                                  ? primaryColor.withOpacity(0.2)
//                                                                  : Colors.blueGrey.withOpacity(0.2),
//                                                              textColor: (accounts[index]['status'].toString().toLowerCase() == "connected")
//                                                                  ? primaryColor
//                                                                  : Colors.blueGrey,
//                                                              text: accounts[index]['status'].toString().toUpperCase(),
//                                                              action: () {},
//                                                              buttonHeight: 24.0,
//                                                              textSize: 12.0,
//                                                            ),
//                                                            SizedBox(width: 10.0),
//                                                            screenActionButton(
//                                                              icon: LineAwesomeIcons.close,
//                                                              backgroundColor: Colors.red.withOpacity(0.1),
//                                                              textColor: Colors.red,
//                                                              action: () {},
//                                                              buttonSize: 30.0,
//                                                              iconSize: 16.0,
//                                                            ),
//                                                          ],
//                                                        ),
//                                                      ),
//                                                    ),
                    ],
                  ),
                );
              }
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  LineAwesomeIcons.bank,
                  size: 100,
                  color: Colors.blue[400].withOpacity(0.15),
                ),
                Padding(
                  padding: EdgeInsets.all(SPACING_HUGE),
                  child: customTitleWithWrap(
                      text: "Press the button on the bottom to add an account",
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                      textAlign: TextAlign.center,
                      color: Colors.blue[400].withOpacity(0.8)),
                )
              ],
            ),
          );
  }
}

class ContributionsTabView extends StatelessWidget {
  const ContributionsTabView({
    Key key,
    @required this.contributions,
  }) : super(key: key);

  final List<Contribution> contributions;

  @override
  Widget build(BuildContext context) {
    return contributions.length > 0
        ? ListView.separated(
            padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
            itemCount: contributions.length,
            itemBuilder: (context, index) {
              Contribution contribution = contributions[index];
              return ListTile(
                dense: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.label,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                customTitle(
                                  text: '${contribution.name}',
                                  color: Theme.of(context).textSelectionHandleColor,
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.start,
                                  fontSize: 15.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        customTitle(
                                          text: 'Contribution Type: ',
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start,
                                          color: Theme.of(context).textSelectionHandleColor.withOpacity(0.5),
                                          fontSize: 12.0,
                                        ),
                                        Expanded(
                                          child: customTitle(
                                            text: '${contribution.type}',
                                            fontWeight: FontWeight.w900,
                                            textAlign: TextAlign.start,
                                            color: Theme.of(context).textSelectionHandleColor.withOpacity(0.5),
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        customTitle(
                                          text: 'Frequency: ',
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start,
                                          color: Theme.of(context).textSelectionHandleColor.withOpacity(0.5),
                                          fontSize: 12.0,
                                        ),
                                        Expanded(
                                          child: customTitle(
                                            text: '${contribution.frequency}',
                                            fontWeight: FontWeight.w900,
                                            textAlign: TextAlign.start,
                                            color: Theme.of(context).textSelectionHandleColor.withOpacity(0.5),
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          smallBadgeButton(
                            backgroundColor: primaryColor.withOpacity(0.2),
                            textColor: primaryColor,
                            text: 'Ksh ' + currencyFormat.format(double.tryParse(contribution.amount) ?? 0),
                            action: () {},
                            buttonHeight: 24.0,
                            textSize: 12.0,
                          ),
//                                                          SizedBox(width: 10.0),
//                                                          screenActionButton(
//                                                            icon: LineAwesomeIcons.close,
//                                                            backgroundColor: Colors.red.withOpacity(0.1),
//                                                            textColor: Colors.red,
//                                                            action: () {},
//                                                            buttonSize: 30.0,
//                                                            iconSize: 16.0,
//                                                          ),
                        ],
                      ),
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
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  LineAwesomeIcons.file_text,
                  size: 100,
                  color: Colors.blue[400].withOpacity(0.15),
                ),
                Padding(
                  padding: EdgeInsets.all(SPACING_HUGE),
                  child: customTitleWithWrap(
                      text: "Press the button on the bottom to create your first contribution",
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                      textAlign: TextAlign.center,
                      color: Colors.blue[400].withOpacity(0.8)),
                )
              ],
            ),
          );
  }
}

class MembersTabView extends StatelessWidget {
  const MembersTabView({
    Key key,
    @required this.members,
  }) : super(key: key);

  final List<Member> members;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
      itemCount: members.length,
      itemBuilder: (context, index) {
        Member member = members[index];
        return ListTile(
          dense: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: Colors.blueGrey,
                    ),
                    SizedBox(width: 10.0),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          customTitleWithWrap(
                            text: '${member.name}',
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w800,
                            textAlign: TextAlign.start,
                            fontSize: 15.0,
                          ),
                          customTitleWithWrap(
                            text: '${member.identity}',
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                            color: Theme.of(context).textSelectionHandleColor.withOpacity(0.5),
                            fontSize: 12.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: smallBadgeButton(
                        backgroundColor: Colors.blueGrey.withOpacity(0.2),
                        textColor: Colors.blueGrey,
                        text: roles["3"],
                        action: () {},
                        buttonHeight: 24.0,
                        textSize: 12.0,
                      ),
                    ),
                    SizedBox(width: 10.0),
//                      screenActionButton(
//                        icon: LineAwesomeIcons.close,
//                        backgroundColor: Colors.red.withOpacity(0.1),
//                        textColor: Colors.red,
//                        action: () {},
//                        buttonSize: 30.0,
//                        iconSize: 16.0,
//                      ),
                  ],
                ),
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
  }
}
