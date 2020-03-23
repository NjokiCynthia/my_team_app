import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

final GlobalKey<ScaffoldState> dashboardScaffoldKey = new GlobalKey<ScaffoldState>();

class ChamasoftDashboard extends StatefulWidget {
  @override
  _ChamasoftDashboardState createState() => _ChamasoftDashboardState();
}
class _ChamasoftDashboardState extends State<ChamasoftDashboard> {
  int _currentPage;

  @override
  void initState() {
    _currentPage = 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: dashboardScaffoldKey,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: primaryGradient(),
        child: Stack(
          children: <Widget>[
            // getPage(_currentPage),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: AppBar(
                  backgroundColor: Colors.blue.withOpacity(0.08),
                  centerTitle: false,
                  title: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: FlatButton(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 1.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            // width: 220,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                              dense: true,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "WITCHER WELFARE ASSOCIATION",
                                    style: TextStyle(
                                      color: Colors.blueGrey[700],
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Icon(
                                        Icons.verified_user,
                                        size: 14.0,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        "Member",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14.0,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              trailing: Container(
                                height: 44.0,
                                width: 44.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.0),
                                  color: Colors.blue.withOpacity(0.06),
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.blue.withOpacity(0.2),
                                  size: 32.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: (){},
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      textColor: Colors.blue,
                      color: Colors.white70,
                    ),
                  ),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: Colors.blueGrey[700],
                        ), 
                        onPressed: (){}
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 20.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.blueGrey[700],
                        ),
                        onPressed: (){}
                      ),
                    ),
                  ],
                  flexibleSpace: Container(
                    height: 90,
                  ),
                )
              )
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                elevation: 0,
                currentIndex: _currentPage,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(LineAwesomeIcons.home, color: _currentPage == 0 ? Colors.blue : Colors.blueGrey[300],),
                    title: Text("Home", style: TextStyle(color: _currentPage == 0 ? Colors.blue : Colors.blueGrey[300]),),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LineAwesomeIcons.users, color: _currentPage == 1 ? Colors.blue : Colors.blueGrey[300],),
                    title: Text("My Group", style: TextStyle(color: _currentPage == 1 ? Colors.blue : Colors.blueGrey[300]),)
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LineAwesomeIcons.credit_card, color: _currentPage == 2 ? Colors.blue : Colors.blueGrey[300],), 
                    title: Text("Transactions", style: TextStyle(color: _currentPage == 2 ? Colors.blue : Colors.blueGrey[300]),)
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LineAwesomeIcons.copy, color: _currentPage == 3 ? Colors.blue : Colors.blueGrey[300],), 
                    title: Text("Reports", style: TextStyle(color: _currentPage == 3 ? Colors.blue : Colors.blueGrey[300]),)
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  getPage(int page) {
    switch(page) {
      case 0:
        // return ChamasoftHome();
      case 1:
        // return ChamasoftGroup();
      case 2:
        // return ChamasoftTransactions();
      case 3:
        // return ChamasoftReports();
    }
  }

}