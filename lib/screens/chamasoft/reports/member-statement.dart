import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class MemeberSatement extends StatefulWidget {
  const MemeberSatement({Key key}) : super(key: key);

  @override
  _MemeberSatementState createState() => _MemeberSatementState();
}

class _MemeberSatementState extends State<MemeberSatement> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Member> _member = [];

  Future<void> _fetchMembers(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchMembers();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchMembers(context);
          });
    }
  }

  // print('${_fetchMembers}');

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
    return Scaffold(
      //_member = Provider.of<Groups>(context, listen: true).groupMembersDetails;
      appBar: secondaryPageAppbar(
          context: context,
          title: "Member Statements",
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: RefreshIndicator(
          backgroundColor: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Colors.white,
          key: _refreshIndicatorKey,
          onRefresh: () => _fetchMembers(context),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: primaryGradient(context),
            child: Column(
              children: [
                Expanded(
                  child: Consumer<Groups>(
                    builder: (context, groupData, child) {
                      return groupData.members.length > 0
                          ? NotificationListener<ScrollNotification>(
                              child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    Member member = _member[index];
                                    return MemberCard(
                                      member: member,
                                      position: index,
                                      bodyContext: context,
                                    );
                                  },
                                  itemCount: _member.length),
                            )
                          : emptyList(
                              color: Colors.blue[400],
                              iconData: LineAwesomeIcons.angle_double_down,
                              text: "There are no Members to display");
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class MemberCard extends StatelessWidget {
  MemberCard(
      {Key key,
      @required this.member,
      @required this.bodyContext,
      @required this.position})
      : super(key: key);

  final Member member;
  final int position;
  BuildContext bodyContext;
  GlobalKey _containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: RepaintBoundary(
        key: _containerKey,
        child: Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          borderOnForeground: false,
          child: Container(
              decoration: cardDecoration(
                  gradient: plainCardGradient(context), context: context),
              child: Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              customTitle1(
                                text: member.identity,
                                fontSize: 16.0,
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.start,
                              ),
                              subtitle2(
                                text: member.name,
                                textAlign: TextAlign.start,
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 0.5,
                    dashLength: 2.0,
                    dashColor: Colors.black45,
                    dashRadius: 0.0,
                    dashGapLength: 2.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          groupObject.isGroupAdmin
                              ? Row(
                                  children: <Widget>[
                                    plainButtonWithArrow(
                                        text: "Contribution Statement",
                                        size: 14.0,
                                        spacing: 2.0,
                                        color: Colors.blue,
                                        // iconData: Icons.remove_red_eye,
                                        action: () {}),
                                  ],
                                )
                              : Container(),
                          Container(
                            child: Column(
                              children: <Widget>[
                                DottedLine(
                                  direction: Axis.vertical,
                                  lineLength: 45.0,
                                  lineThickness: 0.5,
                                  dashLength: 2.0,
                                  dashColor: Colors.black45,
                                  dashRadius: 0.0,
                                  dashGapLength: 2.0,
                                  dashGapColor: Colors.transparent,
                                  dashGapRadius: 0.0,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              plainButtonWithArrow(
                                  text: "Fine Statement",
                                  size: 14.0,
                                  spacing: 2.0,
                                  color: Colors.red,
                                  action: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             new DetailReciept(
                                    //                 deposit: deposit,
                                    //                 group: groupObject))
                                    //                 );
                                  }),
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
