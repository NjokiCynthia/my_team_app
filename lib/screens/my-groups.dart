import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/create-group.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class MyGroups extends StatefulWidget {
  static const namedRoute = '/my-groups-screen';
  @override
  _MyGroupsState createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> with TickerProviderStateMixin {
  Future<void> _future;
  AnimationController _controller;
  DateTime currentBackPressTime;

  Future<void> _getUserCheckinData(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchAndSetUserGroups();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getUserCheckinData(context);
          });
    } finally {}
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 300),
      vsync: this,
    );
    _future = _getUserCheckinData(context);
    super.initState();
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

  Widget buildContainer(Widget child, int itemCount, [bool initialLoad = false]) {
    double height = MediaQuery.of(context).size.height * 0.45;
    double itemCountHeight = (itemCount.toDouble()) * 80;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: itemCount >= 1 ? (itemCountHeight > height ? height : itemCountHeight) : (initialLoad ? 80 : 10),
      child: child,
    );
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Logout"),
          content: new Text("Are you sure you want to log out? You'll have to login again to continue."),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
                child: new Text(
                  "Logout",
                  style: new TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  StatusHandler().logout(context);
                }

                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => Login(),
                //   ),
                // ),
                ),
          ],
        );
      },
    );
  }

  Future<void> fetchCountryOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchCountryOptions();
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateGroup()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch countries'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchCountryOptions(context);
          },
        ),
      );
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      //Fluttertoast.showToast(msg: "Press again to exit");
      SystemNavigator.pop();
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
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
                padding: EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    heading1(text: "My Groups", color: Theme.of(context).textSelectionHandleColor),
                    subtitle1(text: "All groups I belong to", color: Theme.of(context).textSelectionHandleColor),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                      child: auth.displayAvatar != null
                          ? CachedNetworkImage(
                              imageUrl: auth.displayAvatar,
                              placeholder: (context, url) => const CircleAvatar(
                                radius: 45.0,
                                backgroundImage: const AssetImage('assets/no-user.png'),
                              ),
                              imageBuilder: (context, image) => CircleAvatar(
                                backgroundImage: image,
                                radius: 45.0,
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              fadeOutDuration: const Duration(seconds: 1),
                              fadeInDuration: const Duration(seconds: 3),
                            )
                          : const CircleAvatar(
                              backgroundImage: const AssetImage('assets/no-user.png'),
                              radius: 45.0,
                            ),
                    ),
                    heading2(text: auth.userName, color: Theme.of(context).textSelectionHandleColor),
                    subtitle1(text: auth.phoneNumber, color: Theme.of(context).textSelectionHandleColor.withOpacity(0.6)),
                    SizedBox(
                      height: 20,
                    ),
                    groupInfoButton(
                        context: context,
                        leadingIcon: LineAwesomeIcons.plus,
                        trailingIcon: LineAwesomeIcons.angle_right,
                        hideTrailingIcon: true,
                        backgroundColor: primaryColor.withOpacity(0.2),
                        title: "ADD NEW GROUP",
                        subtitle: "Social Group, Merry-go-round, Fundraiser",
                        textColor: primaryColor,
                        borderColor: primaryColor,
                        action: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                          await fetchCountryOptions(context);
                        }),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FutureBuilder(
                            future: _future,
                            builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                                ? buildContainer(Center(child: CircularProgressIndicator()), 0, true)
                                : RefreshIndicator(
                                    onRefresh: () => _getUserCheckinData(context),
                                    child: Consumer<Groups>(
                                      child: Center(
                                        child: Text("Groups"),
                                      ),
                                      builder: (ctx, groups, ch) => buildContainer(
                                          ListView.builder(
                                              padding: EdgeInsets.only(top: 15, bottom: 5),
                                              shrinkWrap: true,
                                              //physics: NeverScrollableScrollPhysics(),
                                              itemCount: groups.item.length,
                                              itemBuilder: (ctx2, index) {
                                                return groupInfoButton(
                                                    context: context,
                                                    leadingIcon: LineAwesomeIcons.group,
                                                    trailingIcon: LineAwesomeIcons.angle_right,
                                                    backgroundColor: primaryColor.withOpacity(0.2),
                                                    title: "${groups.item[index].groupName}",
                                                    subtitle: "${groups.item[index].groupSize} Members",
                                                    description: groups.item[index].isGroupAdmin
                                                        ? "Group Admin | ${groups.item[index].groupRole}"
                                                        : groups.item[index].groupRole,
                                                    textColor: Colors.blueGrey,
                                                    borderColor: Colors.blueGrey.withOpacity(0.2),
                                                    action: () {
                                                      Provider.of<Groups>(ctx2, listen: false).setSelectedGroupId(groups.item[index].groupId);
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (BuildContext context) => ChamasoftDashboard(),
                                                      ));
                                                    });
                                              }),
                                          groups.item.length),
                                    ),
                                  )),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: smallBadgeButton(
                              text: "Logout",
                              backgroundColor: Colors.red.withOpacity(0.2),
                              textColor: Colors.red,
                              buttonHeight: 36.0,
                              textSize: 15.0,
                              action: () => _logoutDialog(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
