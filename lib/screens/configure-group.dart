import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

import 'chamasoft/settings/group-setup/list-contacts.dart';

Map<String, String> roles = {
  "1": "Chairperson",
  "2": "Secretary",
  "3": "Member",
  "4": "Treasurer",
  "5": "Other",
};

List<dynamic> members = [
  {"id": 1, "name": "Peter Kimutai", "phone": "+254 701 234 567", "role_id": 1},
  {"id": 2, "name": "Edwin Kapkei", "phone": "+254 701 234 567", "role_id": 3},
  {
    "id": 3,
    "name": "Geoffrey Githaiga",
    "phone": "+254 701 234 567",
    "role_id": 3
  },
  {"id": 4, "name": "Edwin Kiburu", "phone": "+254 701 234 567", "role_id": 2},
  {"id": 5, "name": "Edwin Kapkei", "phone": "+254 701 234 567", "role_id": 4},
  {"id": 6, "name": "Samuel Wahome", "phone": "+254 701 234 567", "role_id": 3},
];

List<dynamic> accounts = [
  {
    "id": 1,
    "bank": "Equity Bank",
    "branch": "Kasarani, Nairobi, Kenya",
    "account": "011245762988",
    "status": "connected"
  },
  {
    "id": 2,
    "bank": "KCB Bank",
    "branch": "Upperhill",
    "account": "011245762988",
    "status": "pending"
  },
];

List<dynamic> contributions = [
  {
    "id": 1,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,500"
  },
  {
    "id": 2,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 1,500"
  },
  {
    "id": 3,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,100"
  },
];

class ConfigureGroup extends StatefulWidget {
  @override
  _ConfigureGroupState createState() => _ConfigureGroupState();
}

class _ConfigureGroupState extends State<ConfigureGroup> {
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
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 120.0),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: primaryGradient(context),
                      child: TabBarView(
                        children: <Widget>[
                          ListView.separated(
                            padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                dense: true,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.person,
                                            color: Colors.blueGrey,
                                          ),
                                          SizedBox(width: 10.0),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                customTitleWithWrap(
                                                  text:
                                                      '${members[index]['name']}',
                                                  color: Theme.of(context)
                                                      .textSelectionHandleColor,
                                                  fontWeight: FontWeight.w800,
                                                  align: TextAlign.start,
                                                  fontSize: 15.0,
                                                ),
                                                customTitleWithWrap(
                                                  text:
                                                      '${members[index]['phone']}',
                                                  fontWeight: FontWeight.w600,
                                                  align: TextAlign.start,
                                                  color: Theme.of(context)
                                                      .textSelectionHandleColor
                                                      .withOpacity(0.5),
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
                                      child: FittedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            smallBadgeButton(
                                              backgroundColor: Colors.blueGrey
                                                  .withOpacity(0.2),
                                              textColor: Colors.blueGrey,
                                              text: roles[members[index]
                                                      ['role_id']
                                                  .toString()],
                                              action: () {},
                                              buttonHeight: 24.0,
                                              textSize: 12.0,
                                            ),
                                            SizedBox(width: 10.0),
                                            screenActionButton(
                                              icon: LineAwesomeIcons.close,
                                              backgroundColor:
                                                  Colors.red.withOpacity(0.1),
                                              textColor: Colors.red,
                                              action: () {},
                                              buttonSize: 30.0,
                                              iconSize: 16.0,
                                            ),
                                          ],
                                        ),
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
                          ),
                          ListView.separated(
                            padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
                            itemCount: accounts.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                dense: true,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.credit_card,
                                            color: Colors.blueGrey,
                                          ),
                                          SizedBox(width: 10.0),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                customTitleWithWrap(
                                                  text:
                                                      '${accounts[index]['bank']}, ${accounts[index]['branch']}',
                                                  color: Theme.of(context)
                                                      .textSelectionHandleColor,
                                                  align: TextAlign.start,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15.0,
                                                ),
                                                customTitle(
                                                  text:
                                                      '${accounts[index]['account']}',
                                                  fontWeight: FontWeight.w600,
                                                  align: TextAlign.start,
                                                  color: Theme.of(context)
                                                      .textSelectionHandleColor
                                                      .withOpacity(0.5),
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
                                      child: FittedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            smallBadgeButton(
                                              backgroundColor: (accounts[index]
                                                              ['status']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "connected")
                                                  ? primaryColor
                                                      .withOpacity(0.2)
                                                  : Colors.blueGrey
                                                      .withOpacity(0.2),
                                              textColor: (accounts[index]
                                                              ['status']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "connected")
                                                  ? primaryColor
                                                  : Colors.blueGrey,
                                              text: accounts[index]['status']
                                                  .toString()
                                                  .toUpperCase(),
                                              action: () {},
                                              buttonHeight: 24.0,
                                              textSize: 12.0,
                                            ),
                                            SizedBox(width: 10.0),
                                            screenActionButton(
                                              icon: LineAwesomeIcons.close,
                                              backgroundColor:
                                                  Colors.red.withOpacity(0.1),
                                              textColor: Colors.red,
                                              action: () {},
                                              buttonSize: 30.0,
                                              iconSize: 16.0,
                                            ),
                                          ],
                                        ),
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
                          ),
                          ListView.separated(
                            padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
                            itemCount: contributions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                dense: true,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.label,
                                            color: Colors.blueGrey,
                                          ),
                                          SizedBox(width: 10.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              customTitle(
                                                text:
                                                    '${contributions[index]['name']}',
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor,
                                                fontWeight: FontWeight.w700,
                                                align: TextAlign.start,
                                                fontSize: 15.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      customTitle(
                                                        text:
                                                            'Contribution Type: ',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .textSelectionHandleColor
                                                            .withOpacity(0.5),
                                                        fontSize: 12.0,
                                                      ),
                                                      customTitle(
                                                        text:
                                                            '${contributions[index]['type']}',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Theme.of(context)
                                                            .textSelectionHandleColor
                                                            .withOpacity(0.5),
                                                        fontSize: 12.0,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      customTitle(
                                                        text: 'Frequency: ',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .textSelectionHandleColor
                                                            .withOpacity(0.5),
                                                        fontSize: 12.0,
                                                      ),
                                                      customTitle(
                                                        text:
                                                            '${contributions[index]['frequency']}',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Theme.of(context)
                                                            .textSelectionHandleColor
                                                            .withOpacity(0.5),
                                                        fontSize: 12.0,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            smallBadgeButton(
                                              backgroundColor:
                                                  primaryColor.withOpacity(0.2),
                                              textColor: primaryColor,
                                              text:
                                                  '${contributions[index]['amount']}',
                                              action: () {},
                                              buttonHeight: 24.0,
                                              textSize: 12.0,
                                            ),
                                            SizedBox(width: 10.0),
                                            screenActionButton(
                                              icon: LineAwesomeIcons.close,
                                              backgroundColor:
                                                  Colors.red.withOpacity(0.1),
                                              textColor: Colors.red,
                                              action: () {},
                                              buttonSize: 30.0,
                                              iconSize: 16.0,
                                            ),
                                          ],
                                        ),
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
                          ),
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
                              heading2(
                                  color: primaryColor,
                                  text: "Staff Welfare Group"),
                            ],
                          ),
                        ),
                        elevation: 0.0,
                        backgroundColor: (themeChangeProvider.darkTheme)
                            ? Colors.blueGrey[900]
                            : Colors.white54,
                        automaticallyImplyLeading: false,
                        bottom: TabBar(
                          indicator: MD2Indicator(
                            indicatorHeight: 3,
                            indicatorColor: primaryColor,
                            indicatorSize: MD2IndicatorSize.normal,
                          ),
                          labelColor: primaryColor,
                          unselectedLabelColor: Colors.blueGrey,
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                int currentIndex = DefaultTabController.of(context).index;
                print(currentIndex);
                if (currentIndex == 0) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
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
          );
        },
      ),
    );
  }
}
