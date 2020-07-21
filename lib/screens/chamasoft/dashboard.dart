import 'dart:async';

import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/group.dart';
import 'package:chamasoft/screens/chamasoft/home.dart';
import 'package:chamasoft/screens/chamasoft/notifications/notifications.dart';
import 'package:chamasoft/screens/chamasoft/reports.dart';
import 'package:chamasoft/screens/chamasoft/settings.dart';
import 'package:chamasoft/screens/chamasoft/transactions.dart';
import 'package:chamasoft/screens/create-group.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appswitcher.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class ChamasoftDashboard extends StatefulWidget {

  static const namedRoute = "/dashboard";
  @override
  _ChamasoftDashboardState createState() => _ChamasoftDashboardState();
}

class _ChamasoftDashboardState extends State<ChamasoftDashboard> {
  StreamController _eventDispatcher = new StreamController.broadcast();
  List<dynamic> _overlayItems = [
    // {"id": 1, "title": "DVEA Staff Welfare", "role": "Member"},
    // {"id": 2, "title": "La Casa De Papel", "role": "Organizer"},
    // {"id": 3, "title": "Witcher Welfare Association", "role": "Chairperson"},
    // {"id": 4, "title": "Kejodu Investments", "role": "Secretary"},
  ];

  Stream get _stream => _eventDispatcher.stream;

  final GlobalKey<ScaffoldState> dashboardScaffoldKey =
      new GlobalKey<ScaffoldState>();
  int _currentPage;
  double _appBarElevation = 0;
  int _selectedGroupIndex = 0;
  bool _updateSelectedGroup = false;

  _setElevation(double elevation) {
    double newElevation = elevation > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  _handleSelectedOption(BuildContext context,String option,_updateSelectedGroup) {
    if (option == '0') {
      // CREATE NEW Selected, handle it!
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => CreateGroup(),
        ),
      );
    } else {
      // Group Selected, handle it!
      _overlayItems.asMap().forEach((index, value) {
        if (value["id"] == option) {
          setState(() {
            _selectedGroupIndex = index;
            if(_updateSelectedGroup) 
              Provider.of<Groups>(context, listen: false).setSelectedGroupId(value["id"]);
          });
        }
        //switch to selected group.
      });
    }
  }

  Future<void> _getUserGroupsOverlay(BuildContext context) async{
    var _groups = Provider.of<Groups>(context,listen: false).item;
    _overlayItems = [];
    _overlayItems.insert(0, {
      "id": '0',
      "title": "Create New",
      "role": "Group, Merry-go-round, fundraiser"
    });
    _groups.map((group) => {
      _overlayItems.add(
        {"id": group.groupId, "title": group.groupName, "role": group.isGroupAdmin?"Group Admin | ${group.groupRole}":group.groupRole}
      )
    }).toList();
  }

  @override
  void initState() {
    _currentPage = 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _getUserGroupsOverlay(context).then((_) async {
      await Provider.of<Groups>(context,listen: false).getCurrentGroupId().then((groupId){
        _handleSelectedOption(context,groupId,false);
      });
    })
    .catchError((error){
      
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _eventDispatcher.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) => _eventDispatcher.add('TAP'),
      child: Scaffold(
        key: dashboardScaffoldKey,
        backgroundColor: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[900]
              : Colors.blue[50],
        appBar: AppBar(
          backgroundColor: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[900]
              : Colors.blue[50],
          centerTitle: false,
          title: AppSwitcher(
            key: ObjectKey('$_overlayItems'),
            listItems: _overlayItems,
            parentStream: _stream,
            currentGroup: _overlayItems[_selectedGroupIndex],
            selectedOption: (selected) {
              _handleSelectedOption(context,selected,true);
            },
          ),
          elevation: _appBarElevation,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Theme.of(context).textSelectionHandleColor,
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChamasoftNotifications(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ChamasoftSettings(),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[900] //.withOpacity(0.95)
              : Colors.blue[50],
          //.withOpacity(0.89),
          elevation: 0,
          currentIndex: _currentPage,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                AntDesign.home,
                color: _currentPage == 0 ? primaryColor : Colors.blueGrey[300],
              ),
              title: Text(
                "Home",
                style: TextStyle(
                    color:
                        _currentPage == 0 ? primaryColor : Colors.blueGrey[300],
                    fontFamily: 'SegoeUI',
                    fontWeight: FontWeight.w700),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Feather.users,
                  color:
                      _currentPage == 1 ? primaryColor : Colors.blueGrey[300],
                ),
                title: Text(
                  "My Group",
                  style: TextStyle(
                      color: _currentPage == 1
                          ? primaryColor
                          : Colors.blueGrey[300],
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.w700),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Feather.credit_card,
                  color:
                      _currentPage == 2 ? primaryColor : Colors.blueGrey[300],
                ),
                title: Text(
                  "Transactions",
                  style: TextStyle(
                      color: _currentPage == 2
                          ? primaryColor
                          : Colors.blueGrey[300],
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.w700),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Feather.copy,
                  color:
                      _currentPage == 3 ? primaryColor : Colors.blueGrey[300],
                ),
                title: Text(
                  "Reports",
                  style: TextStyle(
                      color: _currentPage == 3
                          ? primaryColor
                          : Colors.blueGrey[300],
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.w700),
                )),
          ],
          onTap: (index) {
            setState(() {
              _currentPage = index;
            });
          },
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            _eventDispatcher.add('ORIENTATION');
            return SafeArea(
              child: Container(
                decoration: primaryGradient(context),
                child:getPage(_currentPage),
              ),
            );
          },
        ),
      ),
    );
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return ChamasoftHome(
          appBarElevation: (elevation) => _setElevation(elevation),
        );
      case 1:
        return ChamasoftGroup(
          appBarElevation: (elevation) => _setElevation(elevation),
        );
      case 2:
        return ChamasoftTransactions();
      case 3:
        return ChamasoftReports();
    }
  }
}
