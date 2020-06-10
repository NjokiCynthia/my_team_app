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
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class MyGroups extends StatefulWidget {
  static const namedRoute = '/my-groups-screen';

  @override
  _MyGroupsState createState() => _MyGroupsState();
}

bool _isInit = true;
AnimationController _controller;

Future<void> _getUserCheckinData(BuildContext context) async {
  try {
    await Provider.of<Groups>(context, listen: false).fetchAndSetUserGroups();
  } on CustomException catch (error) {
    StatusHandler().handleStatus(context: context, error: error, callback: () {});
  } finally {}
}

class _MyGroupsState extends State<MyGroups> with TickerProviderStateMixin {
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _getUserCheckinData(context);
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Widget buildContainer(Widget child, int itemCount) {
    return Container(
        // margin: EdgeInsets.all(10),
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            //color: Theme.of(context).cardColor,
            //border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        //height: itemCount >= 1 ? MediaQuery.of(context).size.height * 0.35 : 50,
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            decoration: primaryGradient(context),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  heading1(text: "My Groups", color: Theme.of(context).textSelectionHandleColor),
                  subtitle1(text: "All groups I belong to", color: Theme.of(context).textSelectionHandleColor),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Image(
                      image: auth.displayAvatar != null ? NetworkImage(auth.displayAvatar) : AssetImage('assets/no-user.png'),
                      height: 80.0,
                    ),
                  ),
                  heading2(text: auth.userName, color: Theme.of(context).textSelectionHandleColor),
                  subtitle1(
                      text: auth.phoneNumber, //auth.phoneNumber,
                      color: Theme.of(context).textSelectionHandleColor.withOpacity(0.6)),
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
                    subtitle: "Chairperson",
                    textColor: primaryColor,
                    borderColor: primaryColor,
                    action: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => CreateGroup(),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      FutureBuilder(
                          future: _getUserCheckinData(context),
                          builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                              ? buildContainer(Center(child: CircularProgressIndicator()), 0)
                              : RefreshIndicator(
                                  onRefresh: () => _getUserCheckinData(context),
                                  child: Consumer<Groups>(
                                    child: Center(
                                      child: Text("Groups"),
                                    ),
                                    builder: (ctx, groups, ch) => buildContainer(
                                        ListView.builder(
                                            shrinkWrap: true,
                                            //physics: NeverScrollableScrollPhysics(),
                                            itemCount: groups.item.length,
                                            itemBuilder: (context, index) {
                                              //InvestmentGroup groupModel = auth.groups[index];
                                              return groupInfoButton(
                                                  context: context,
                                                  leadingIcon: LineAwesomeIcons.group,
                                                  trailingIcon: LineAwesomeIcons.angle_right,
                                                  backgroundColor: primaryColor.withOpacity(0.2),
                                                  title: "${groups.item[index].groupName}",
                                                  subtitle: "${groups.item[index].groupSize} Members",
                                                  description: "Member",
                                                  textColor: Colors.blueGrey,
                                                  borderColor: Colors.blueGrey.withOpacity(0.2),
                                                  action: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (BuildContext context) => ChamasoftDashboard(),
                                                      ),
                                                    );
                                                    Provider.of<Groups>(context, listen: false).setSelectedGroupId(groups.item[index].groupId);
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
                            action: () {
                              StatusHandler().logout(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
