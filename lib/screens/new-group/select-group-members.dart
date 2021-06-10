import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class SelectGroupMembers extends StatefulWidget {
  final List<dynamic> selected;
  final ValueChanged<dynamic> members;
  SelectGroupMembers({
    @required this.members,
    @required this.selected,
  });
  @override
  _SelectGroupMembersState createState() => _SelectGroupMembersState();
}

class _SelectGroupMembersState extends State<SelectGroupMembers> {
  String _title = "Select Members";
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isLoading = true;
  bool _isInit = true;
  List<dynamic> _groupMembers = [];

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  void itemChange(bool val, int index) {
    setState(() {
      // _groupMembers[index]['isCheck'] = val;
    });
  }

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';

  Future<void> getGroupMembers() async {
    setState(() {
      _isLoading = true;
    });
    final group = Provider.of<Groups>(context, listen: false);
    // await group.fetchMembers();
    List<dynamic> _members = widget.selected;
    List<dynamic> _tmpMbrs = [];
    setState(() {
      group.members.forEach((m) {
        int selCount = _tmpMbrs.where((i) => i['id'] == m.id).toList().length;
        if (selCount == 0) {
          _groupMembers.add({
            'id': m.id,
            'name': m.name,
            'identity': m.identity,
            'avatar': m.avatar,
            'user_id': m.userId,
          });
        }
      });
      _isLoading = false;
      _isInit = false;
    });
    return true;
  }

  void _clearMembersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
              text: "Clear Selection",
              textAlign: TextAlign.start,
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionHandleColor),
          content: customTitleWithWrap(
              text: "Are you sure you want to clear all selected members?",
              textAlign: TextAlign.start,
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionHandleColor,
              maxLines: null),
          actions: <Widget>[
            negativeActionDialogButton(
              text: "Cancel",
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionHandleColor,
              action: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
            FlatButton(
              padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
              child: customTitle(
                text: "Yes, clear all",
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                widget.members({
                  'present': [],
                  'late': [],
                  'withApology': [],
                  'withoutApology': [],
                });
                Navigator.of(context).pop();
              },
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4.0),
              ),
              textColor: Colors.red,
              color: Colors.red.withOpacity(0.2),
            )
          ],
        );
      },
    );
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
      WidgetsBinding.instance.addPostFrameCallback((_) => getGroupMembers());
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
        leadingIcon: LineAwesomeIcons.close,
        title: _title,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
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
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                            size: 24.0,
                            semanticLabel: 'Select members...',
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                subtitle1(
                                  text: "Select members",
                                  textAlign: TextAlign.start,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                ),
                                subtitle2(
                                  text:
                                      "Select the members you want to add and save.",
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.red[500],
                              ),
                              highlightColor: Colors.red[100].withOpacity(0.8),
                              onPressed: () => _clearMembersDialog(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
                      child: (_groupMembers.length) > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _groupMembers.length,
                              controller: _scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding:
                                      EdgeInsets.only(top: 2.0, bottom: 2.0),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        isThreeLine: false,
                                        dense: true,
                                        title: Text(
                                          _groupMembers[index]['name'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: primaryColor,
                                          ),
                                        ),
                                        subtitle: Text(
                                          _groupMembers[index]['identity'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: primaryColor,
                                          ),
                                        ),
                                        leading: Container(
                                          height: 42,
                                          width: 42,
                                          child: CircleAvatar(
                                            foregroundColor: Colors.white,
                                            backgroundColor: primaryColor,
                                            child: Text(
                                              getInitials(
                                                _groupMembers[index]['name'],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                          : Flexible(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                alignment: Alignment.center,
                                child: emptyList(
                                  color: Colors.blue[400],
                                  iconData: LineAwesomeIcons.file_text,
                                  text: "There are no members to show",
                                ),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading
            ? null
            : () {
                List<dynamic> _selected = [];
                _groupMembers.forEach((m) {
                  _selected.add({
                    'id': m['id'],
                    'name': m['name'],
                    'identity': m['identity'],
                    'avatar': m['avatar'],
                    'user_id': m['user_id'],
                  });
                });
                dynamic _members = widget.selected;
                // print("_members >> ");
                // print(_members);
                widget.members(_members);
                Navigator.of(context).pop();
              },
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
      ),
    );
  }
}
