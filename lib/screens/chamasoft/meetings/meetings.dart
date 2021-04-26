import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/dashed-divider.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class Meetings extends StatefulWidget {
  @override
  _MeetingsState createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
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
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context);
    final currentGroup = group.getCurrentGroup();

    final List<dynamic> meetings = <dynamic>[
      {
        'date': '',
        'members': {
          'present': 10,
          'absent': {
            'with_apology': 2,
            'without_apology': 1,
          },
        },
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: "Meetings",
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
                onPressed: () => {
                  // Add new meeting
                },
              ),
            ),
          ]),
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
          child: Column(
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
                      color: Theme.of(context).textSelectionHandleColor,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
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
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                          subtitle2(
                            text:
                                "That everytime you have your regular group meetings, Chamasoft helps you keep minutes for future reference, and also record any transactions.",
                            color: Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subtitle2(
                      text: "12 April, 2021",
                      color: Theme.of(context).textSelectionHandleColor,
                      textAlign: TextAlign.start,
                    ),
                    subtitle1(
                      text: "Group's AGM meeting held at KNH",
                      color: Theme.of(context).textSelectionHandleColor,
                      textAlign: TextAlign.start,
                    ),
                    Row(
                      children: [
                        Text(
                          "Members present ",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13.0,
                            color: Theme.of(context).textSelectionHandleColor,
                            fontFamily: 'SegoeUI',
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "12",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0,
                            color: Theme.of(context).textSelectionHandleColor,
                            fontFamily: 'SegoeUI',
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // emptyList(
              //   color: Colors.blue[400],
              //   iconData: LineAwesomeIcons.file_text,
              //   text: "There are no meetings to show",
              // ),
            ],
          ),
        );
      }),
    );
  }
}
