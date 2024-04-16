import 'dart:convert';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/meetings/edit-meeting.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/database-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class Meetings extends StatefulWidget {
  @override
  _MeetingsState createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<dynamic> meetings = [];
  String _groupCurrency = "KES";
  bool _isGroupAdmin = false;
  var formatter = NumberFormat('#,##,##0', "en_US");
  var dateFormatter = DateFormat('EEE, d MMM, yyy HH:mm a', "en_US");
  bool _isLoading = true;
  bool _isInit = true;
  bool _syncing = false;
  Map<int, bool> syncing = {};

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  String getCollectionTotals(Map<String, dynamic> collections) {
    int _totals = 0;
    List<dynamic> _contributions = collections['contributions'];
    List<dynamic> _repayments = collections['repayments'];
    List<dynamic> _disbursements = collections['disbursements'];
    List<dynamic> _fines = collections['fines'];
    _contributions.forEach((a) => _totals += a['amount']);
    _repayments.forEach((a) => _totals += a['amount']);
    _disbursements.forEach((a) => _totals += a['amount']);
    _fines.forEach((a) => _totals += a['amount']);
    return formatter.format(_totals);
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final group = Provider.of<Groups>(context, listen: false);
    final currentGroup = group.getCurrentGroup();
    await group.fetchMeetings();
    setState(() {
      _syncing = false;
      _isGroupAdmin = currentGroup.isGroupAdmin;
      meetings = [];
      _groupCurrency = currentGroup.groupCurrency;
      int c = 0;
      List<dynamic> groupMeetings = group.meetings;
      groupMeetings.forEach((d) {
        syncing[c] = false;
        Map<String, dynamic> _meeting = {};
        _meeting['id'] = d['id'];
        _meeting['group_id'] = (d['group_id']).toString();
        _meeting['title'] = d['title'];
        _meeting['venue'] = d['venue'];
        _meeting['purpose'] = d['purpose'];
        _meeting['date'] = d['date'];
        _meeting['members'] = jsonDecode(d['members']);
        _meeting['agenda'] = jsonDecode(d['agenda']);
        _meeting['collections'] = jsonDecode(d['collections']);
        _meeting['total_collections'] =
            getCollectionTotals(jsonDecode(d['collections']));
        _meeting['aob'] = jsonDecode(d['aob']);
        _meeting['synced'] = d['synced'];
        meetings.add(_meeting);
        c++;
      });
      _isLoading = false;
      _isInit = false;
    });
    return true;
  }

  void syncData(int index) async {
    setState(() {
      _syncing = true;
      syncing[index] = true;
    });
    try {
      await Provider.of<Groups>(context, listen: false)
          .syncMeeting(meetings[index])
          .then((resp) async {
        if (resp['status'] != null) {
          if (resp['status'] == 1) {
            // delete meeting from local
            await dbHelper.delete(
                meetings[index]['id'], DatabaseHelper.meetingsTable);
          }
        }
      });
      await fetchData();
      setState(() {
        _syncing = false;
        syncing[index] = false;
      });
    } on CustomException catch (error) {
      setState(() {
        _syncing = false;
        syncing[index] = false;
      });
      StatusHandler().handleStatus(context: context, error: error);
    }
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

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon:LineAwesomeIcons.arrow_left,
        title: "Meetings",
        actions: [
          _isGroupAdmin ? Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(
                Icons.add,
               
                color : Theme.of(context).textSelectionTheme.selectionHandleColor,
              ),
              onPressed: _isLoading
                  ? null
                  :  () => Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => EditMeeting(),
                        ),
                      )
                          .then((resp) {
                        fetchData();
                      }),
            ),
          ) : Container(),
        ],
      ),
      body: _isLoading
          ? Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 16.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            dataLoadingEffect(
                              context: context,
                              width: 150,
                              height: 20,
                              borderRadius: 16.0,
                            ),
                            dataLoadingEffect(
                              context: context,
                              width: 80,
                              height: 20,
                              borderRadius: 16.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            dataLoadingEffect(
                              context: context,
                              width: 100,
                              height: 16,
                              borderRadius: 16.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 0.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            dataLoadingEffect(
                              context: context,
                              width: 150,
                              height: 20,
                              borderRadius: 16.0,
                            ),
                            dataLoadingEffect(
                              context: context,
                              width: 80,
                              height: 20,
                              borderRadius: 16.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            dataLoadingEffect(
                              context: context,
                              width: 100,
                              height: 16,
                              borderRadius: 16.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 0.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            dataLoadingEffect(
                              context: context,
                              width: 150,
                              height: 20,
                              borderRadius: 16.0,
                            ),
                            dataLoadingEffect(
                              context: context,
                              width: 80,
                              height: 20,
                              borderRadius: 16.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            dataLoadingEffect(
                              context: context,
                              width: 100,
                              height: 16,
                              borderRadius: 16.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Builder(
              builder: (BuildContext context) {
                return Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      color: (themeChangeProvider.darkTheme)
                          ? Colors.blueGrey[800]
                          : Color(0xffededfe),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.lightbulb_outline,
                           
                            color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                            size: 24.0,
                            semanticLabel: 'You should know...',
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                subtitle1(
                                  text: "You should know...",
                                  textAlign: TextAlign.start,
                                  color: Theme.of(context)
                                     
                                      .textSelectionTheme.selectionHandleColor,
                                ),
                                subtitle2(
                                  text:
                                      "That everytime you have your regular group meetings, Chamasoft helps you keep minutes for future reference, and also record any transactions.",
                                  color: Theme.of(context)
                                     
                                      .textSelectionTheme.selectionHandleColor,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: meetings.length > 0
                          ? ListView.separated(
                              controller: _scrollController,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 40.0),
                              separatorBuilder: (context, index) => Divider(
                                color: Theme.of(context)
                                   
                                    .textSelectionTheme.selectionHandleColor
                                    .withOpacity(0.5),
                                height: 0.0,
                              ),
                              itemCount: meetings.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: (meetings[index]['synced'] == 1)
                                      ? Theme.of(context).backgroundColor
                                      : Colors.red[700].withOpacity(0.04),
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0,
                                            ),
                                            child: Icon(
                                              Icons.group,
                                              color: Theme.of(context)
                                                 
                                                  .textSelectionTheme.selectionHandleColor,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              subtitle2(
                                                text: dateFormatter.format(
                                                  DateFormat('yyyy-MM-dd HH:mm')
                                                      .parse(meetings[index]
                                                          ['date']),
                                                ),
                                                color: Theme.of(context)
                                                   
                                                    .textSelectionTheme.selectionHandleColor,
                                                textAlign: TextAlign.start,
                                              ),
                                              subtitle1(
                                                text: meetings[index]['title'],
                                                color: Theme.of(context)
                                                   
                                                    .textSelectionTheme.selectionHandleColor,
                                                textAlign: TextAlign.start,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Members present ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 13.0,
                                                      color: Theme.of(context)
                                                         
                                                          .textSelectionTheme.selectionHandleColor,
                                                      fontFamily: 'SegoeUI',
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    meetings[index]['members']
                                                            ['present']
                                                        .length
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13.0,
                                                      color: Theme.of(context)
                                                         
                                                          .textSelectionTheme.selectionHandleColor,
                                                      fontFamily: 'SegoeUI',
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  color: primaryColor
                                                      .withOpacity(0.1),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                  8.0,
                                                  2.0,
                                                  8.0,
                                                  2.0,
                                                ),
                                                margin: EdgeInsets.only(
                                                  top: 6.0,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Total Collections",
                                                          style: TextStyle(
                                                            color: primaryColor
                                                                .withOpacity(
                                                                    0.7),
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(width: 6.0),
                                                        Text(
                                                          _groupCurrency,
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4.0),
                                                        Text(
                                                          meetings[index][
                                                              'total_collections'],
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      (meetings[index]['synced'] == 1)
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(right: 22.0),
                                              child: Icon(
                                                Icons.cloud_done,
                                                color: Colors.green[700]
                                                    .withOpacity(0.7),
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                right: 12.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Visibility(
                                                    visible: (syncing[index]),
                                                    child: SizedBox(
                                                      height: 16.0,
                                                      width: 16.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1.5,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.file_upload,
                                                      color:
                                                          ((syncing[index]) ||
                                                                  (_syncing))
                                                              ? Colors.red[700]
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Colors.red[700],
                                                    ),
                                                    onPressed:
                                                        ((syncing[index]) ||
                                                                (_syncing))
                                                            ? null
                                                            : () =>
                                                                syncData(index),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              // alignment: Alignment.center,
                              child: emptyList(
                                color: Colors.blue[400],
                                iconData: LineAwesomeIcons.file,
                                text: "There are no meetings to show",
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
