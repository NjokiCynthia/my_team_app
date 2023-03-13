// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/config.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChamasoftMarketPlace extends StatefulWidget {
  ChamasoftMarketPlace({
    this.appBarElevation,
  });

  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftMarketPlaceState createState() => _ChamasoftMarketPlaceState();
}

class _ChamasoftMarketPlaceState extends State<ChamasoftMarketPlace> {
  ScrollController _scrollController;
  bool _showMeetingsBanner = true;
  Group _currentGroup;

  void _meetingsBannerStatus() async {
    dynamic _bannerDbStatus = [
      {
        'group_id': _currentGroup.groupId,
        'show_banner': true,
      },
    ];
    Map<String, dynamic> _banner = _bannerDbStatus[0];
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("meetings-banner")) {
      String bannerStatusObject = prefs.getString("meetings-banner");
      _bannerDbStatus = jsonDecode(bannerStatusObject);
    }
    List<dynamic> _filtered = _bannerDbStatus
        .where((s) => s['group_id'] == _currentGroup.groupId)
        .toList();
    if (_filtered.length == 1) _banner = _filtered[0];
    setState(() {
      if ((_currentGroup.isGroupAdmin) && (_banner['show_banner']))
        _showMeetingsBanner = true;
      else
        _showMeetingsBanner = false;
    });
  }

  void hideBanner() async {
    List<dynamic> _bannerDbStatus = [
      {
        'group_id': _currentGroup.groupId,
        'show_banner': false,
      },
    ];
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("meetings-banner")) {
      String bannerStatusObject = prefs.getString("meetings-banner");
      _bannerDbStatus = jsonDecode(bannerStatusObject);
      List<dynamic> _filtered = _bannerDbStatus
          .where((s) => s['group_id'] == _currentGroup.groupId)
          .toList();
      if (_bannerDbStatus.length > 0) {
        if (_filtered.length == 0) {
          _bannerDbStatus.add(
            {
              'group_id': _currentGroup.groupId,
              'show_banner': false,
            },
          );
        } else {
          int _idx = _bannerDbStatus
              .indexWhere((b) => b['group_id'] == _currentGroup.groupId);
          _bannerDbStatus.removeAt(_idx);
          _bannerDbStatus.add(
            {
              'group_id': _currentGroup.groupId,
              'show_banner': false,
            },
          );
        }
      }
    }
    await prefs.setString("meetings-banner", jsonEncode(_bannerDbStatus));
    setState(() {
      _showMeetingsBanner = false;
    });
  }

  void _scrollListener() {
    widget.appBarElevation(_scrollController.offset);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context)
        .pushReplacementNamed(ChamasoftDashboard.namedRoute);
    return null;
  }

  void _launchURL() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'sales@imelaplace.co.ke',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  void didChangeDependencies() {
    _meetingsBannerStatus();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
          child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            Visibility(
              visible: _showMeetingsBanner,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16.0,
                  16.0,
                  16.0,
                  16.0,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: cardDecoration(
                    gradient: plainCardGradient(context),
                    context: context,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Stack(
                      children: <Widget>[
                        Image(
                          image: AssetImage(
                            'assets/marketplace-image.jpg',
                          ),
                          width: double.infinity,
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.3),
                            padding: EdgeInsets.only(
                              right: 16.0,
                              top: 6.0,
                              bottom: 6.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${Config.appName} Market Place",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    subtitle2(
                                      color: Colors.white.withOpacity(0.9),
                                      text:
                                          "Advertise your Product with us today.",
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    CustomHelper.callNumber("+254733366240");
                                  },
                                  child: Text(
                                    "Call us today",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'SegoeUI',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => hideBanner(),
                                  child: Text(
                                    "Don't show this again",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontFamily: 'SegoeUI',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 11.0,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Market Place Products",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontFamily: 'SegoeUI',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Feather.more_horizontal,
                        color: Colors.blueGrey,
                      ),
                      onPressed: () {})
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              "https://app.chamasoft.com/templates/admin_themes/groups/img/adverts/studiorm.jfif",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                          imageBuilder: (context, image) => Image(
                            image: image,
                            width: double.infinity,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fadeOutDuration: const Duration(milliseconds: 700),
                          fadeInDuration: const Duration(milliseconds: 1000),
                        ),
                        // Image.network(
                        //     'https://app.chamasoft.com/templates/admin_themes/groups/img/adverts/studiorm.jfif'),
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
                          padding: EdgeInsets.all(8.0),
                          decoration: cardDecoration(
                            gradient: plainCardGradient(context),
                            context: context,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    plainButtonWithIcon(
                                        text: "Email us",
                                        size: 17.0,
                                        spacing: 5.0,
                                        color: Colors.blue,
                                        iconData: Icons.email,
                                        action: () {
                                          _launchURL();
                                        }),
                                  ],
                                ),
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
                                    plainButtonWithIcon(
                                        text: "Call us",
                                        size: 17.0,
                                        spacing: 5.0,
                                        color: Colors.blue,
                                        iconData: Icons.call,
                                        action: () {
                                          CustomHelper.callNumber("0115205332");
                                        }),
                                  ],
                                ),
                              ]),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
