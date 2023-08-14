import 'dart:async';
import 'package:chamasoft/config.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
// import 'package:chamasoft/providers/helpers/notifications.dart';
import 'package:chamasoft/screens/chamasoft/new_home.dart';
import 'package:chamasoft/screens/chamasoft/notifications/notification-alert.dart';
import 'package:chamasoft/screens/chamasoft/reports.dart';
import 'package:chamasoft/screens/chamasoft/settings.dart';
import 'package:chamasoft/screens/chamasoft/transactions.dart';
// import 'package:chamasoft/screens/chamasoft/wallet.dart';
import 'package:chamasoft/screens/new-group/new-group.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/notifications.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appswitcher.dart';
import 'package:chamasoft/widgets/showCase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'meetings/meetings.dart';

// ignore: must_be_immutable
class ChamasoftDashboard extends StatefulWidget {
  static const namedRoute = "/dashboard";
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING_DASHBOARDS =
      "PREFERENCES_IS_FIRST_LAUNCH_STRING_DASHBOARDS";
  RateMyApp rateMyApp;

  ChamasoftDashboard({
    Key key,
    this.rateMyApp,
  }) : super(key: key);

  @override
  _ChamasoftDashboardState createState() => _ChamasoftDashboardState();
}

class _ChamasoftDashboardState extends State<ChamasoftDashboard> {
  StreamController _eventDispatcher = new StreamController.broadcast();
  List<dynamic> _overlayItems = [];
  Stream get _stream => _eventDispatcher.stream;

  final GlobalKey<ScaffoldState> dashboardScaffoldKey =
      new GlobalKey<ScaffoldState>();
  int _currentPage;
  double _appBarElevation = 0;
  int _selectedGroupIndex = 0;
  bool _notificationCount = false;
  // bool _updateSelectedGroup = false;

  final switchGroupKey = GlobalKey();
  final meetingsKey = GlobalKey();
  final notificationsKey = GlobalKey();
  final settingsKey = GlobalKey();
  final homeDashboardKey = GlobalKey();
  // final groupDashboardKey = GlobalKey();
  final transactionKey = GlobalKey();
  final transactionAdminKey = GlobalKey();
  final reportKey = GlobalKey();
  final marketplaceKey = GlobalKey();

  BuildContext dashboardContext;

  _setElevation(double elevation) {
    double newElevation = elevation > 0 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  _setNotificationCount(double notificationCount) {
    print("count $notificationCount");
    if (this.mounted) {
      setState(() {
        _notificationCount = notificationCount > 0 ? true : false;
      });
    }
  }

  _handleSelectedOption(
    BuildContext context,
    String option,
    _updateSelectedGroup,
  ) {
    if (option == '0') {
      // CREATE NEW Selected, handle it!
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => NewGroup(),
        ),
      );
    } else {
      // Group Selected, handle it!
      _overlayItems.asMap().forEach((index, value) {
        if (value["id"] == option) {
          setState(() {
            _selectedGroupIndex = index;
            if (_updateSelectedGroup)
              Provider.of<Groups>(context, listen: false)
                  .setSelectedGroupId(value["id"]);
          });
        }
        //switch to selected group.
      });
    }
  }

  Future<void> _getUserGroupsOverlay(BuildContext context) async {
    var _groups = Provider.of<Groups>(context, listen: false).item;
    _overlayItems = [];
    _overlayItems.insert(
      0,
      {
        "id": '0',
        "title": "Create New",
        "role": "Add your Chama",
      },
    );
    _groups
        .map(
          (group) => {
            _overlayItems.add(
              {
                "id": group.groupId,
                "title": group.groupName,
                "role": group.isGroupAdmin
                    ? "Group Admin & ${group.groupRole}"
                    : group.groupRole
              },
            )
          },
        )
        .toList();
  }

  Future<void> _checkUserAuthentication(BuildContext context) async {
    if ((Provider.of<Auth>(context, listen: false).mobileToken) == null ||
        (Provider.of<Auth>(context, listen: false).mobileToken).isEmpty) {
      NotificationManager.registerUserToken(
          context, Provider.of<Auth>(context, listen: false).id);
      print(Provider.of<Auth>(context, listen: false).mobileToken);
    }
  }

  @override
  void initState() {
    _currentPage = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFirstLaunch().then((result) {
        if (result)
          ShowCaseWidget.of(dashboardContext).startShowCase([
            switchGroupKey,
            // notificationsKey,
            settingsKey,
            homeDashboardKey,
            // groupDashboardKey,
            transactionKey,
            reportKey,
            marketplaceKey,
            // meetingsKey,
          ]);
      });
    });

    // WidgetsBinding.instance.addPostFrameCallback(
    //     (_) => Future.delayed(Duration(milliseconds: 200), () {
    //           ShowCaseWidget.of(dashboardContext).startShowCase([
    //             switchGroupKey,
    //             notificationsKey,
    //             settingsKey,
    //             homeDashboardKey,
    //             groupDashboardKey,
    //             transactionKey,
    //             reportKey,
    //             marketplaceKey,
    //             meetingsKey,
    //           ]);
    //         }));
    super.initState();
  }

  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = sharedPreferences.getBool(
            ChamasoftDashboard.PREFERENCES_IS_FIRST_LAUNCH_STRING_DASHBOARDS) ??
        true;

    if (isFirstLaunch)
      sharedPreferences.setBool(
          ChamasoftDashboard.PREFERENCES_IS_FIRST_LAUNCH_STRING_DASHBOARDS,
          false);

    return isFirstLaunch;
  }

  @override
  void didChangeDependencies() {
    // ignore: todo
    // TODO: implement didChangeDependencies
    _getUserGroupsOverlay(context).then((_) async {
      final group = Provider.of<Groups>(context, listen: false);
      await group.getCurrentGroupId().then((groupId) async {
        _handleSelectedOption(context, groupId, false);
      });
    }).catchError((error) {});
    _checkUserAuthentication(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _eventDispatcher.close();
    super.dispose();
  }

  String getUserName(String name) =>
      name.isNotEmpty ? name.trim().split(' ')[0].toLowerCase() : 'Home';

  notificationAlertDialog() {
    return showGeneralDialog(
      // barrierColor: Colors.white.withOpacity(0.5),
      barrierDismissible: false,
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: NotificationAlert(),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 400),
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    // RateAppInitWidget(
    //               builder: (rateMyApp) =>
    //                   ChamasoftDashboard(rateMyApp: rateMyApp),
    //             ),

    return ShowCaseWidget(builder: Builder(builder: (context) {
      dashboardContext = context;
      return GestureDetector(
        onTapDown: (TapDownDetails details) => _eventDispatcher.add('TAP'),
        child: Scaffold(
          key: dashboardScaffoldKey,
          backgroundColor: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[900]
              : Config.appName.toLowerCase() == 'chamasoft'
                  ? Colors.blue[50]
                  : Colors.white,
          appBar: AppBar(
            backgroundColor: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[900]
                : Config.appName.toLowerCase() == 'chamasoft'
                    ? Colors.blue[50]
                    : Colors.white70,
            centerTitle: false,
            title: customShowCase(
              key: switchGroupKey,
              title: 'Switch Groups',
              description: "Click here to switch in between Chamas",

              // ignore: deprecated_member_use
              textColor:
                  Theme.of(context).textSelectionTheme.selectionHandleColor,
              child: AppSwitcher(
                key: ObjectKey('$_overlayItems'),
                listItems: _overlayItems,
                parentStream: _stream,
                currentGroup: _overlayItems[_selectedGroupIndex],
                selectedOption: (selected) {
                  _handleSelectedOption(context, selected, true);
                },
              ),
            ),
            elevation: _appBarElevation,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Visibility(
                visible: /*_group.isGroupAdmin*/ true,
                // visible: _currentGroup.isGroupAdmin,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    customShowCase(
                      key: meetingsKey,
                      title: "Chamasoft Meetings",
                      description:
                          "Schedule,View and Manage your Chama Meetings",

                      // ignore: deprecated_member_use
                      textColor: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.people_alt,
                          color: Config.appName.toLowerCase() == 'chamasoft'
                              ?
                              // ignore: deprecated_member_use
                              Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor
                              : primaryColor,
                        ),
                        onPressed: () /*=>*/ {
                          _eventDispatcher.add('TAP'); //Closes the AppSwitcher
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => Meetings(),
                            ),
                          );
                        },
                      ),
                    )
                    // Showcase(
                    //   key: meetingsKey,
                    //   title: 'Chamasoft Meetings',
                    //   description: "Schedule,View and Manage Chama Meetings",
                    // child: IconButton(
                    //   icon: Icon(
                    //     Icons.people_alt,
                    //     color: Config.appName.toLowerCase() == 'chamasoft'
                    //         ?
                    //         // ignore: deprecated_member_use
                    //         Theme.of(context).textSelectionHandleColor
                    //         : primaryColor,
                    //   ),
                    //   onPressed: () => {
                    //     _eventDispatcher.add('TAP'), //Closes the AppSwitcher
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (BuildContext context) => Meetings(),
                    //       ),
                    //     ),
                    //   },
                    //   ),
                    // ),

                    // Positioned(
                    //   top: 12,
                    //   right: 6,
                    //   child: Container(
                    //     width: 12.0,
                    //     height: 12.0,
                    //     decoration: new BoxDecoration(
                    //       color: Colors.blue,
                    //       shape: BoxShape.circle,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Visibility(
                    visible: true,
                    child: customShowCase(
                      key: notificationsKey,
                      title: 'Chamasoft Notifications',
                      description:
                          "View all your Transactions Notification from Here",

                      // ignore: deprecated_member_use
                      textColor: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: Config.appName.toLowerCase() == 'chamasoft'
                              ?
                              // ignore: deprecated_member_use
                              Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor
                              : primaryColor,
                        ),
                        onPressed: null, // Disable notifications for now
                        /*onPressed: () => {
                                _eventDispatcher
                                    .add('TAP'), //Closes the AppSwitcher
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChamasoftNotifications(),
                                  ),
                                ),
                              }*/
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (_notificationCount) /* false */,
                    child: Positioned(
                      top: 12,
                      right: 6,
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              customShowCase(
                key: settingsKey,
                title: 'Chamasoft Settings',
                description:
                    "Personalize your Chama Settings, Personal Settings,Help and Assistance , Preferences and Terms and Conditions",

                // ignore: deprecated_member_use
                textColor:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Config.appName.toLowerCase() == 'chamasoft'
                        ?
                        // ignore: deprecated_member_use
                        Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor
                        : primaryColor,
                  ),
                  onPressed: () => {
                    _eventDispatcher.add('TAP'), //Closes the AppSwitcher
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ChamasoftSettings(),
                      ),
                    ),
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.blueGrey[300],
            unselectedLabelStyle: TextStyle(
              color: Colors.blueGrey[500],
              fontFamily: 'SegoeUI',
              fontWeight: FontWeight.w700,
            ),
            selectedLabelStyle: TextStyle(
                color: _currentPage == /*2*/ 1
                    ? primaryColor
                    : Config.appName.toLowerCase() == 'chamasoft'
                        ? Colors.blueGrey[300]
                        : Colors.blueGrey[300].withOpacity(0.5),
                fontFamily: 'SegoeUI',
                fontWeight: FontWeight.w700),
            backgroundColor: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[900] //.withOpacity(0.95)
                : Config.appName.toLowerCase() == 'chamasoft'
                    ? Colors.blue[50]
                    : Colors.white,
            //.withOpacity(0.89),
            elevation: 0,
            currentIndex: _currentPage,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: customShowCase(
                  key: homeDashboardKey,
                  title: 'Personal Dashboard',
                  description: "View all your Summarized Transactions",

                  // ignore: deprecated_member_use
                  textColor:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  child: Icon(
                    Feather.user,
                    color:
                        _currentPage == 0 ? primaryColor : Colors.blueGrey[300],
                  ),
                ),
                label: toBeginningOfSentenceCase(getUserName(auth.userName)),

                // style: TextStyle(
                //   color:
                //       _currentPage == 0 ? primaryColor : Colors.blueGrey[300],
                //   fontFamily: 'SegoeUI',
                //   fontWeight: FontWeight.w700,
                // ),
              ),
              // BottomNavigationBarItem(
              //   icon: customShowCase(
              //     key: groupDashboardKey,
              //     title: 'Chama Dashboard',
              //     description:
              //         "View your Chamas Transaction Summary, Loan balances and Accounts balances",

              //     // ignore: deprecated_member_use
              //     textColor: Theme.of(context).textSelectionHandleColor,
              //     child: Icon(
              //       Feather.users,
              //       color: _currentPage == 1
              //           ? primaryColor
              //           : Config.appName.toLowerCase() == 'chamasoft'
              //               ? Colors.blueGrey[300]
              //               : Colors.blueGrey[300].withOpacity(0.5),
              //     ),
              //   ),
              //   // ignore: deprecated_member_use
              //   title: Text(
              //     toBeginningOfSentenceCase(
              //         getUserName((_group.groupName).replaceAll(" ", "-"))),
              //     style: TextStyle(
              //         color: _currentPage == 1
              //             ? primaryColor
              //             : Config.appName.toLowerCase() == 'chamasoft'
              //                 ? Colors.blueGrey[300]
              //                 : Colors.blueGrey[300].withOpacity(0.5),
              //         fontFamily: 'SegoeUI',
              //         fontWeight: FontWeight.w700),
              //   ),
              // ),
              BottomNavigationBarItem(
                icon: customShowCase(
                  key: transactionKey,
                  title: 'Chamasoft Transactions',
                  description:
                      "Manually Record chama Transactions, Create withdrawals form E-Walet and Invoice Transfers",

                  // ignore: deprecated_member_use
                  textColor: Colors.black,
                      // Theme.of(context).textSelectionTheme.selectionHandleColor,
                  child: Icon(
                    Feather.credit_card,
                    color: _currentPage == /*2*/ 1
                        ? primaryColor
                        : Config.appName.toLowerCase() == 'chamasoft'
                            ? Colors.blueGrey[300]
                            : Colors.blueGrey[300].withOpacity(1.0),
                  ),
                ),
                // ignore: deprecated_member_use
                label: "Transactions",
              ),
              //),
              BottomNavigationBarItem(
                icon: customShowCase(
                  key: reportKey,
                  title: 'Chamasoft Reports',
                  description:
                      "View well summarized Transactions reports and Reciepts, You can down load and share.",
                  // ignore: deprecated_member_use
                  textColor:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  child: Icon(
                    Feather.copy,
                    color: _currentPage == /*3*/ 2
                        ? primaryColor
                        : Config.appName.toLowerCase() == 'chamasoft'
                            ? Colors.blueGrey[300]
                            : Colors.blueGrey[300].withOpacity(0.5),
                  ),
                ),
                // ignore: deprecated_member_use
                label: 'Reports',
                // style: TextStyle(
                //   color: _currentPage == /*3*/ 2
                //       ? primaryColor
                //       : Config.appName.toLowerCase() == 'chamasoft'
                //           ? Colors.blueGrey[300]
                //           : Colors.blueGrey[300].withOpacity(0.5),
                //   fontFamily: 'SegoeUI',
                //   fontWeight: FontWeight.w700,
                // ),
              ),
              //),
              // BottomNavigationBarItem(
              //   icon: customShowCase(
              //     key: marketplaceKey,
              //     title: 'Chamasoft MarketPlace',
              //     description: "View Chamasoft Post Ads",

              //     // ignore: deprecated_member_use
              //     textColor: Theme.of(context).textSelectionHandleColor,
              //     child: Icon(
              //       Feather.shopping_cart,
              //       color: _currentPage == 4
              //           ? primaryColor
              //           : Config.appName.toLowerCase() == 'chamasoft'
              //               ? Colors.blueGrey[300]
              //               : Colors.blueGrey[300].withOpacity(0.5),
              //     ),
              //   ),
              //   // ignore: deprecated_member_use
              //   title: Text(
              //     "Market",
              //     style: TextStyle(
              //       color: _currentPage == 4
              //           ? primaryColor
              //           : Config.appName.toLowerCase() == 'chamasoft'
              //               ? Colors.blueGrey[300]
              //               : Colors.blueGrey[300].withOpacity(0.5),
              //       fontFamily: 'SegoeUI',
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              // ),
            ],
            onTap: (index) {
              // setState(() {
              //   if ((Config.appName.toLowerCase() != 'chamasoft') &&
              //       (index > 0))
              //     _currentPage = 0;
              //   else
              //     _currentPage = index;
              // });

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
                  // decoration: primaryGradient(context),
                  child: getPage(_currentPage),
                ),
              );
            },
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     _eventDispatcher.add('TAP');
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (BuildContext context) => NewGroup(),
          //       ),
          //     );
          //   },
          //   child: const Icon(
          //     Icons.add,
          //     color: Colors.white,
          //   ),
          //   backgroundColor: primaryColor,
          // ),
        ),
      );
    }));
  }

  getPage(int page) {
    // if ((Config.appName.toLowerCase() != 'chamasoft') && (page > 0)) {
    //   return ChamasoftHome(
    //     appBarElevation: (elevation) => _setElevation(elevation),
    //   );
    // }

    switch (page) {
      case 0:

        // return RateAppInitWidget(
        //     builder: (rateMyApp) => ChamasoftHome(
        //       rateMyApp: rateMyApp,
        //       appBarElevation: (elevation) => _setElevation(elevation),
        //       notificationCount: (_notificationCount) =>
        //           _setNotificationCount(_notificationCount),
        //     ),
        //   );
        return ChamasoftHome /*ChamasoftHomeOld*/ (
          appBarElevation: (elevation) => _setElevation(elevation),
          notificationCount: (_notificationCount) =>
              _setNotificationCount(_notificationCount),
        );
      // case 1:
      //   return ChamasoftGroup(
      //     appBarElevation: (elevation) => _setElevation(elevation),
      //   );
      case 1:
        // return Wallet(
        //   appBarElevation: (elevation) => _setElevation(elevation),
        // );

        return ChamasoftTransactions(
          appBarElevation: (elevation) => _setElevation(elevation),
        );
      case 2:
        return ChamasoftReports(
          appBarElevation: (elevation) => _setElevation(elevation),
        );
      // case 4:
      //   return ChamasoftMarketPlace(
      //     appBarElevation: (elevation) => _setElevation(elevation),
      //   );
    }
  }
}
