import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/member-fine-statement.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/member_contribution_statement.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dotted_line/dotted_line.dart';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class MemeberSatement extends StatefulWidget {
  const MemeberSatement({Key key}) : super(key: key);

  @override
  _MemeberSatementState createState() => _MemeberSatementState();
}

class _MemeberSatementState extends State<MemeberSatement> {
  TextEditingController controller = new TextEditingController();
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isInit = true;
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Member> _member = [];
  bool _hasMoreData = false;
  String filter;
  Member member;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _fetchMembers(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchMembers();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchMembers(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _fetchMembers(context).then((_) {
      if (context != null) {
        setState(() {
          if (_member.length < 20) {
            _hasMoreData = false;
          } else
            _hasMoreData = true;
          _isLoading = false;
        });
      }
    });

    _isInit = false;
    return true;
  }

  // print('${_fetchMembers}');

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final groupObject =
    //     Provider.of<Groups>(context, listen: false).getCurrentGroup();
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    _member = Provider.of<Groups>(context, listen: true).members;

    return Scaffold(
      key: _scaffoldKey,
      appBar: secondaryPageAppbar(
          context: context,
          title: "Member Statements",
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: RefreshIndicator(
          backgroundColor: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Colors.white,
          key: _refreshIndicatorKey,
          onRefresh: () => _fetchData(),
          child: Container(
            // height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
            // decoration: primaryGradient(context),
            decoration: primaryGradient(context),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: "Search Member",
                    prefixIcon: Icon(LineAwesomeIcons.search),
                  ),
                  controller: controller,
                ),
                _isLoading
                    ? showLinearProgressIndicator()
                    : SizedBox(
                        height: 0.0,
                      ),
                Expanded(
                  child: _member.length > 0
                      ? NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!_isLoading &&
                                scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent &&
                                _hasMoreData) {
                              _fetchData();
                            }
                            return true;
                          },
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                Member member = _member[index];

                                return filter == null || filter == ""
                                    ? MemberCard(
                                        member: member,
                                        position: index,
                                        bodyContext: context,
                                      )
                                    : member.name
                                            .toLowerCase()
                                            .contains(filter.toLowerCase())
                                        ? MemberCard(
                                            member: member,
                                            position: index,
                                            bodyContext: context,
                                          )
                                        : Visibility(
                                            visible: false,
                                            child: new Container());
                              },
                              itemCount: _member.length),
                        )
                      : emptyList(
                          color: Colors.blue[400],
                          iconData: LineAwesomeIcons.angle_double_down,
                          text: "There are no members to display"),
                )
              ],
            ),
          )),
    );
  }
}

// ignore: must_be_immutable
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
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
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
                        member.avatar != null
                            ? Container(
                                height: 50,
                                width: 50,
                                child: new CachedNetworkImage(
                                  imageUrl: member.avatar,
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                    backgroundImage:
                                        const AssetImage('assets/no-user.png'),
                                  ),
                                  imageBuilder: (context, image) =>
                                      CircleAvatar(
                                    backgroundImage: image,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    backgroundImage:
                                        const AssetImage('assets/no-user.png'),
                                  ),
                                  fadeOutDuration: const Duration(seconds: 1),
                                  fadeInDuration: const Duration(seconds: 3),
                                ),
                              )
                            : const CircleAvatar(
                                backgroundImage:
                                    const AssetImage('assets/no-user.png'),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              heading3(
                                text: member.name,
                                // fontSize: 16.0,
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              customTitle(
                                text: member.identity,
                                textAlign: TextAlign.start,
                                fontSize: 12.0,
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              subtitle2(
                                text: " ",
                                textAlign: TextAlign.start,
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
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
                  groupObject.isGroupAdmin
                      ? Container(
                          padding: EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Column(
                            children: [
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
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    groupObject.isGroupAdmin
                                        ? Row(
                                            children: <Widget>[
                                              plainButtonWithArrow(
                                                  text:
                                                      //"Contribution Statement",
                                                      currentLanguage ==
                                                              'English'
                                                          ? 'Contribution Statement'
                                                          : Provider.of<TranslationProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .translate(
                                                                      'Contribution statement') ??
                                                              'Contribution statement',
                                                  size: 12.0,
                                                  spacing: 1.0,
                                                  color: Colors.blue,
                                                  action: () =>
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MemberContributionStatement(
                                                                memberName:
                                                                    member.name,
                                                                memberId:
                                                                    member.id,
                                                                memberPhoto:
                                                                    member
                                                                        .avatar),
                                                      ))),
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
                                    groupObject.isGroupAdmin
                                        ? Row(
                                            children: <Widget>[
                                              plainButtonWithArrow(
                                                  text: "Fine Statement",
                                                  size: 12.0,
                                                  spacing: 1.0,
                                                  color: Colors.red,
                                                  action: () =>
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MemberFineStatement(
                                                                memberNames:
                                                                    member.name,
                                                                memberIds:
                                                                    member.id,
                                                                memberPhoto:
                                                                    member
                                                                        .avatar),
                                                      ))),
                                            ],
                                          )
                                        : Container()
                                  ]),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 10,
                        ),
                ],
              )),
        ),
      ),
    );
  }
}
