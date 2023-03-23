import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/config.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/login_password.dart';
import 'package:chamasoft/screens/new-group/new-group.dart';
// import 'package:chamasoft/screens/pinlogin.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/showCase.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class MyGroups extends StatefulWidget {
  static const namedRoute = '/my-groups-screen';
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING_MYGROUPS =
      "PREFERENCES_IS_FIRST_LAUNCH_STRING_MYGROUPS";

  @override
  _MyGroupsState createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> with TickerProviderStateMixin {
  Future<void> _future;
  AnimationController _controller;
  DateTime currentBackPressTime;
  final newGroupKey = GlobalKey();
  final myGroupsKey = GlobalKey();
  final logoutKey = GlobalKey();

  BuildContext myGroupContext;

  Future<void> _getUserCheckInData(BuildContext context,
      [bool refresh = false]) async {
    try {
      if (Provider.of<Groups>(context, listen: false).item.length > 0) {
      } else {
        refresh = true;
      }
      if (refresh) {
        await Provider.of<Groups>(context, listen: false)
            .fetchAndSetUserGroups();
      }
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getUserCheckInData(context);
          });
    } finally {}
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 300),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFirstLaunch().then((result) {
        if (result)
          ShowCaseWidget.of(myGroupContext)
              .startShowCase([newGroupKey, logoutKey]);
      });
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) =>
    //     ShowCaseWidget.of(myGroupContext)
    //         .startShowCase([newGroupKey, logoutKey]));

    _future = _getUserCheckInData(context);
    super.initState();
  }

  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = sharedPreferences
            .getBool(MyGroups.PREFERENCES_IS_FIRST_LAUNCH_STRING_MYGROUPS) ??
        true;

    if (isFirstLaunch)
      sharedPreferences.setBool(
          MyGroups.PREFERENCES_IS_FIRST_LAUNCH_STRING_MYGROUPS, false);

    return isFirstLaunch;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget buildContainer(Widget child, int itemCount,
      [bool initialLoad = false]) {
    double height = MediaQuery.of(context).size.height * 0.45;
    double itemCountHeight = (itemCount.toDouble()) * 80;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: itemCount >= 1
          ? (itemCountHeight > height ? height : itemCountHeight)
          : (initialLoad ? 80 : 10),
      child: child,
    );
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
            text: "Logout",
            textAlign: TextAlign.start,
            // ignore: deprecated_member_use
            color: Theme.of(context).textSelectionTheme.selectionHandleColor,
          ),
          content: customTitleWithWrap(
            text:
                "Are you sure you want to log out? You'll have to login again to continue.",
            textAlign: TextAlign.start,
            // ignore: deprecated_member_use
            color: Theme.of(context).textSelectionTheme.selectionHandleColor,
            maxLines: null,
          ),
          actions: <Widget>[
            negativeActionDialogButton(
              text: "Cancel",
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              action: () async {
                if (Config.appName.toLowerCase() == "chamasoft") {
                  Navigator.of(context).pop();
                } else {
                  print("Logout was clicked from MyGroups Screen");
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginPassword.namedRoute, (route) => false);
                  StatusHandler().logout(context);
                }
              },
            ),
            // ignore: deprecated_member_use
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
              ),

              child: customTitle(
                text: "Logout",
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                StatusHandler().logout(context);
              },
              // shape: new RoundedRectangleBorder(
              //     borderRadius: new BorderRadius.circular(4.0)),
              // textColor: Colors.red,
              // color: Colors.red.withOpacity(0.2),
            )
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      //Fluttertoast.showToast(msg: "Press again to exit");
      SystemNavigator.pop();
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return ShowCaseWidget(builder: Builder(builder: (context) {
      myGroupContext = context;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: Builder(builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              decoration: primaryGradient(context),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 40,
                  right: 40,
                  bottom: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    heading1(
                      text: "My Groups",
                      // ignore: deprecated_member_use
                      color: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                    ),
                    subtitle1(
                      text: "All groups I belong to",
                      // ignore: deprecated_member_use
                      color: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      child: auth.displayAvatar != null
                          ? CachedNetworkImage(
                              imageUrl: auth.displayAvatar,
                              placeholder: (context, url) => const CircleAvatar(
                                radius: 45.0,
                                backgroundImage:
                                    const AssetImage('assets/no-user.png'),
                              ),
                              imageBuilder: (context, image) => CircleAvatar(
                                backgroundImage: image,
                                radius: 45.0,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fadeOutDuration: const Duration(seconds: 1),
                              fadeInDuration: const Duration(seconds: 3),
                            )
                          : const CircleAvatar(
                              backgroundImage:
                                  const AssetImage('assets/no-user.png'),
                              radius: 45.0,
                            ),
                    ),
                    heading2(
                      text: auth.userName,
                      // ignore: deprecated_member_use
                      color: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor,
                    ),
                    subtitle1(
                      text: auth.phoneNumber,
                      color: Theme.of(context)
                          // ignore: deprecated_member_use
                          .textSelectionTheme
                          .selectionHandleColor
                          .withOpacity(0.6),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 10, 2, 0),
                      child: customShowCase(
                        key: newGroupKey,
                        description: "Create a new Group",
                        child: groupInfoButton(
                          context: context,
                          leadingIcon: LineAwesomeIcons.plus,
                          trailingIcon: LineAwesomeIcons.angle_right,
                          hideTrailingIcon: true,
                          backgroundColor: primaryColor.withOpacity(0.2),
                          title: "ADD NEW GROUP",
                          subtitle: "Chama, Merry-go-round, Fundraiser",
                          textColor: primaryColor,
                          borderColor: primaryColor,
                          action: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NewGroup(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FutureBuilder(
                          future: _future,
                          builder: (ctx, snapshot) => snapshot
                                      .connectionState ==
                                  ConnectionState.waiting
                              ? buildContainer(
                                  Center(
                                    child: dataLoadingEffect(
                                        context: context,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.98,
                                        height: 50,
                                        borderRadius: 50.0),
                                  ),
                                  0,
                                  true)
                              : RefreshIndicator(
                                  backgroundColor:
                                      (themeChangeProvider.darkTheme)
                                          ? Colors.blueGrey[800]
                                          : Colors.white,
                                  onRefresh: () =>
                                      _getUserCheckInData(context, true),
                                  child: Consumer<Groups>(
                                    child: Center(
                                      child: Text("Groups"),
                                    ),
                                    builder: (ctx, groups, ch) =>
                                        buildContainer(
                                      ListView.builder(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 5,
                                          left: 2,
                                          right: 2,
                                        ),
                                        shrinkWrap: true,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        itemCount: groups.item.length,
                                        itemBuilder: (ctx2, index) {
                                          return groupInfoButton(
                                            context: context,
                                            leadingIcon: LineAwesomeIcons.user_friends,
                                            trailingIcon:
                                                LineAwesomeIcons.angle_right,
                                            backgroundColor:
                                                primaryColor.withOpacity(0.2),
                                            title:
                                                "${groups.item[index].groupName}",
                                            subtitle:
                                                "${((groups.item[index].groupSize) == null ? 1 : groups.item[index].groupSize)} Members",
                                            description: groups
                                                    .item[index].isGroupAdmin
                                                ? "Group Admin | ${groups.item[index].groupRole}"
                                                : groups.item[index].groupRole,
                                            textColor: Colors.blueGrey,
                                            borderColor: Colors.blueGrey
                                                .withOpacity(0.2),
                                            action: () {
                                              // if (int.parse(groups.item[index]
                                              //             .groupSize) <
                                              //         3 &&
                                              //     groups.item[index]
                                              //         .isGroupAdmin) {
                                              //   Provider.of<Groups>(
                                              //     ctx2,
                                              //     listen: false,
                                              //   ).setSelectedGroupId(
                                              //     groups.item[index].groupId,
                                              //   );
                                              //   Navigator.of(context).push(
                                              //     MaterialPageRoute(
                                              //       builder: (BuildContext
                                              //               context) =>
                                              //           NewGroup(
                                              //               groupName: groups
                                              //                   .item[index]
                                              //                   .groupName,
                                              //               groupId: groups
                                              //                   .item[index]
                                              //                   .groupId),
                                              //     ),
                                              //   );
                                              // } else {
                                              Provider.of<Groups>(
                                                ctx2,
                                                listen: false,
                                              ).setSelectedGroupId(
                                                groups.item[index].groupId,
                                              );
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          ChamasoftDashboard(),
                                                ),
                                              );
                                              //}
                                            },
                                          );
                                        },
                                      ),
                                      groups.item.length,
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: customShowCase(
                              key: logoutKey,
                              description: 'Click here to log out',
                              child: smallBadgeButton(
                                text: "Logout",
                                backgroundColor: Colors.red.withOpacity(0.2),
                                textColor: Colors.red,
                                buttonHeight: 30.0,
                                textSize: 15.0,
                                action: () => _logoutDialog(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   // ignore: deprecated_member_use
                    //   child: RaisedButton(
                    //     onPressed: () => {
                    //       // Navigator.push(
                    //       //   context,
                    //       //   MaterialPageRoute(
                    //       //       builder: (context) => DetailReciept()),
                    //       // )

                    //       Navigator.of(context).pushNamed(PinLogin.namedRoute)
                    //     },
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: <Widget>[
                    //         Icon(Icons.add_alarm), // icon
                    //         Text("Test Pin"), // text
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    }));
  }
}
