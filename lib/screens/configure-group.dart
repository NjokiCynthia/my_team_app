import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

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
  {"id": 3, "name": "Geoffrey Githaiga", "phone": "+254 701 234 567", "role_id": 3},
  {"id": 4, "name": "Edwin Kiburu", "phone": "+254 701 234 567", "role_id": 2},
  {"id": 5, "name": "Edwin Kapkei", "phone": "+254 701 234 567", "role_id": 4},
  {"id": 6, "name": "Samuel Wahome", "phone": "+254 701 234 567", "role_id": 3},
];

List<dynamic> accounts = [
  {"id": 1, "bank": "Equity Bank", "branch": "Kasarani", "account": "011245762988", "status": "connected"},
  {"id": 2, "bank": "KCB Bank", "branch": "Upperhill", "account": "011245762988", "status": "pending"},
];

List<dynamic> contributions = [
  {"id": 1, "name": "Witcher School Fund", "type": "Regular", "frequency": "Once a month", "amount": "Ksh 2,500"},
  {"id": 2, "name": "Witcher School Fund", "type": "Regular", "frequency": "Once a month", "amount": "Ksh 1,500"},
  {"id": 3, "name": "Witcher School Fund", "type": "Regular", "frequency": "Once a month", "amount": "Ksh 2,100"},
];

class ConfigureGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 130.0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: primaryGradient(),
                child: TabBarView(
                  children: <Widget>[
                    ListView.separated(
                      itemCount: members.length,
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
                                        Icons.person,
                                        color: Colors.blueGrey[300],
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${members[index]['name']}',
                                            style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Text(
                                            '${members[index]['phone']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueGrey,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      smallBadgeButton(
                                        backgroundColor: Colors.blueGrey.withOpacity(0.2),
                                        textColor: Colors.blueGrey,
                                        text: roles[members[index]['role_id'].toString()],
                                        action: (){},
                                        buttonHeight: 24.0,
                                        textSize: 12.0,
                                      ),
                                      SizedBox(width: 10.0),
                                      screenActionButton(
                                        icon: LineAwesomeIcons.close,
                                        backgroundColor: Colors.red.withOpacity(0.1),
                                        textColor: Colors.red,
                                        action: (){},
                                        buttonSize: 30.0,
                                        iconSize: 16.0,
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
                          color: Colors.blueGrey[100],
                          height: 6.0,
                        );
                      },
                    ),
                    ListView.separated(
                      itemCount: accounts.length,
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
                                        Icons.credit_card,
                                        color: Colors.blueGrey[300],
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${accounts[index]['bank']}, ${accounts[index]['branch']}',
                                            style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Text(
                                            '${accounts[index]['account']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueGrey,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      smallBadgeButton(
                                        backgroundColor: (accounts[index]['status'].toString().toLowerCase() == "connected") ? Colors.blue.withOpacity(0.2) : Colors.blueGrey.withOpacity(0.2),
                                        textColor: (accounts[index]['status'].toString().toLowerCase() == "connected") ? Colors.blue : Colors.blueGrey,
                                        text: accounts[index]['status'].toString().toUpperCase(),
                                        action: (){},
                                        buttonHeight: 24.0,
                                        textSize: 12.0,
                                      ),
                                      SizedBox(width: 10.0),
                                      screenActionButton(
                                        icon: LineAwesomeIcons.close,
                                        backgroundColor: Colors.red.withOpacity(0.1),
                                        textColor: Colors.red,
                                        action: (){},
                                        buttonSize: 30.0,
                                        iconSize: 16.0,
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
                          color: Colors.blueGrey[100],
                          height: 6.0,
                        );
                      },
                    ),
                    ListView.separated(
                      itemCount: contributions.length,
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
                                        Icons.person,
                                        color: Colors.blueGrey[300],
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${contributions[index]['name']}',
                                            style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    'Contribution Type: ',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.blueGrey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${contributions[index]['type']}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.blueGrey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    'Frequency: ',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.blueGrey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${contributions[index]['frequency']}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.blueGrey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      smallBadgeButton(
                                        backgroundColor: Colors.blue.withOpacity(0.2),
                                        textColor: Colors.blue,
                                        text: '${contributions[index]['amount']}',
                                        action: (){},
                                        buttonHeight: 24.0,
                                        textSize: 12.0,
                                      ),
                                      SizedBox(width: 10.0),
                                      screenActionButton(
                                        icon: LineAwesomeIcons.close,
                                        backgroundColor: Colors.red.withOpacity(0.1),
                                        textColor: Colors.red,
                                        action: (){},
                                        buttonSize: 30.0,
                                        iconSize: 16.0,
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
                          color: Colors.blueGrey[100],
                          height: 6.0,
                        );
                      },
                    ),
                  ],
                )
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  width: 200.0,
                  height: 130.0,
                  child: AppBar(
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          screenActionButton(
                            icon: LineAwesomeIcons.arrow_left,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            textColor: Colors.blue,
                            action: () => Navigator.pushReplacementNamed(context, '/my-groups'),
                          ),
                          SizedBox(width: 20.0),
                          heading2(color: Colors.blue, text: "Staff Welfare Group"),
                        ],
                      ),
                    ),
                    elevation: 0.0,
                    backgroundColor: Colors.white54,
                    bottom: TabBar(
                      indicator: MD2Indicator(
                        indicatorHeight: 3,
                        indicatorColor: Colors.blue,
                        indicatorSize: MD2IndicatorSize.normal,
                      ),
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.blueGrey.shade300,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      isScrollable: false,
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: <Widget>[
                        Text(
                          "Members",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "Accounts",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "Contributions",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}