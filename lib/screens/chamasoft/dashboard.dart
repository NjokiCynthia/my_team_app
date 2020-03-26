import 'package:chamasoft/screens/chamasoft/group.dart';
import 'package:chamasoft/screens/chamasoft/home.dart';
import 'package:chamasoft/screens/chamasoft/reports.dart';
import 'package:chamasoft/screens/chamasoft/settings.dart';
import 'package:chamasoft/screens/chamasoft/transactions.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:chamasoft/widgets/buttons.dart';

class ChamasoftDashboard extends StatefulWidget {
  @override
  _ChamasoftDashboardState createState() => _ChamasoftDashboardState();
}
class _ChamasoftDashboardState extends State<ChamasoftDashboard> {
  final GlobalKey<ScaffoldState> dashboardScaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentPage;
  double _appBarElevation = 0;

  _setElevation(double elevation){
    double newElevation = elevation > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

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
        decoration: primaryGradient(context),
        child: Stack(
          children: <Widget>[
            getPage(_currentPage),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: AppBar(
                  backgroundColor: (themeChangeProvider.darkTheme) ? Colors.blueGrey[900] : Colors.blue[50],
                  centerTitle: false,
                  title: groupSwitcherButton(
                    title: "Witcher Welfare Association",
                    role: "Chairperson",
                    context: context,
                  ),
                  elevation: _appBarElevation,
                  automaticallyImplyLeading: false,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: Theme.of(context).textSelectionHandleColor,
                      ), 
                      onPressed: (){}
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChamasoftSettings(),),)
                      ),
                    ),
                  ],
                  // flexibleSpace: Container(
                  //   height: 90,
                  // ),
                )
              )
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: BottomNavigationBar(
                backgroundColor: (themeChangeProvider.darkTheme) ? Colors.blueGrey[900].withOpacity(0.95) : Colors.blue[50].withOpacity(0.89),
                elevation: 0,
                currentIndex: _currentPage,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(AntDesign.home, color: _currentPage == 0 ? Colors.blue : Colors.blueGrey[300],),
                    title: Text("Home", style: TextStyle(color: _currentPage == 0 ? Colors.blue : Colors.blueGrey[300], fontWeight: FontWeight.w700),),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Feather.users, color: _currentPage == 1 ? Colors.blue : Colors.blueGrey[300],),
                    title: Text("My Group", style: TextStyle(color: _currentPage == 1 ? Colors.blue : Colors.blueGrey[300], fontWeight: FontWeight.w700),)
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Feather.credit_card, color: _currentPage == 2 ? Colors.blue : Colors.blueGrey[300],), 
                    title: Text("Transactions", style: TextStyle(color: _currentPage == 2 ? Colors.blue : Colors.blueGrey[300], fontWeight: FontWeight.w700),)
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Feather.copy, color: _currentPage == 3 ? Colors.blue : Colors.blueGrey[300],), 
                    title: Text("Reports", style: TextStyle(color: _currentPage == 3 ? Colors.blue : Colors.blueGrey[300], fontWeight: FontWeight.w700),)
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getPage(int page) {
    switch(page) {
      case 0:
        return ChamasoftHome(
          appBarElevation: (elevation) =>  _setElevation(elevation),
        );
      case 1:
        return ChamasoftGroup();
      case 2:
        return ChamasoftTransactions();
      case 3:
        return ChamasoftReports();
    }
  }

}