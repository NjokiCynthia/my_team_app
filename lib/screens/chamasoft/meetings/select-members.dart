import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class SelectMembers extends StatefulWidget {
  final String type;
  final Map<dynamic, dynamic> selected;
  final ValueChanged<dynamic> members;
  SelectMembers({
    @required this.type,
    @required this.members,
    @required this.selected,
  });
  @override
  _SelectMembersState createState() => _SelectMembersState();
}

class _SelectMembersState extends State<SelectMembers> {
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
      _groupMembers[index]['isCheck'] = val;
    });
  }

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';

  Map<String, dynamic> _selectedMembers() {
    dynamic _members = widget.selected;
    List<Widget> _tmpMbrs = [];
    int count = 0;
    _getOtherTypes().forEach((type) {
      count = count + _members[type].length;
      String _type = (type == "present")
          ? "are present"
          : (type == "withApology")
              ? "are absent with apology"
              : (type == "late")
                  ? "are late"
                  : "are absent without apology";
      if (_members[type].length == 1)
        _tmpMbrs.add(subtitle2(
          text: "1 member " + _type,
          textAlign: TextAlign.start,
          // ignore: deprecated_member_use
          color: Theme.of(context).textSelectionTheme.selectionHandleColor,
        ));
      else if (_members[type].length > 1)
        _tmpMbrs.add(subtitle2(
          text: _members[type].length.toString() + " members " + _type,
          textAlign: TextAlign.start,
          // ignore: deprecated_member_use
          color: Theme.of(context).textSelectionTheme.selectionHandleColor,
        ));
    });
    return {
      'render': Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _tmpMbrs,
      ),
      'count': count,
    };
  }

  bool _isSelected(String id) {
    dynamic _members = widget.selected;
    List<dynamic> _currentCategory = _members[_getType()];
    // print(_currentCategory);
    bool resp = false;
    _currentCategory.forEach((m) {
      if (m['id'] == id) resp = true;
    });
    return resp;
  }

  Future<void> getGroupMembers() async {
    setState(() {
      _isLoading = true;
    });
    final group = Provider.of<Groups>(context, listen: false);
    // await group.fetchMembers();
    dynamic _members = widget.selected;
    List<dynamic> _tmpMbrs = [];
    _getOtherTypes().forEach((type) {
      _tmpMbrs.addAll(_members[type]);
    });
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
            'isCheck': _isSelected(m.id),
          });
        }
      });
      _isLoading = false;
      _isInit = false;
    });
    return true;
  }

  List<String> _getOtherTypes() {
    if (widget.type == 'present')
      return ['withApology', 'withoutApology', 'late'];
    else if (widget.type == 'with-apology')
      return ['withoutApology', 'present', 'late'];
    else if (widget.type == 'late')
      return ['withoutApology', 'withApology', 'present'];
    else if (widget.type == 'without-apology')
      return ['withApology', 'present', 'late'];
    else
      return ['present', 'withApology', 'withoutApology', 'late'];
  }

  String _getType() {
    if (widget.type == 'present')
      return 'present';
    else if (widget.type == 'late')
      return 'late';
    else if (widget.type == 'with-apology')
      return 'withApology';
    else if (widget.type == 'without-apology')
      return 'withoutApology';
    else
      return 'present';
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
              color: Theme.of(context).textSelectionTheme.selectionHandleColor),
          content: customTitleWithWrap(
              text: "Are you sure you want to clear all selected members?",
              textAlign: TextAlign.start,
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              maxLines: null),
          actions: <Widget>[
            negativeActionDialogButton(
              text: "Cancel",
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              action: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
            // FlatButton(
            //   padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
            //   child: customTitle(
            //     text: "Yes, clear all",
            //     color: Colors.red,
            //     fontWeight: FontWeight.w600,
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     widget.members({
            //       'present': [],
            //       'late': [],
            //       'withApology': [],
            //       'withoutApology': [],
            //     });
            //     Navigator.of(context).pop();
            //   },
            //   shape: new RoundedRectangleBorder(
            //     borderRadius: new BorderRadius.circular(4.0),
            //   ),
            //   textColor: Colors.red,
            //   color: Colors.red.withOpacity(0.2),
            // )
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                backgroundColor: Colors.red.withOpacity(0.2),
                primary: Colors.red,
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
              child: customTitle(
                text: "Yes, clear all",
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            )

          ],
        );
      },
    );
  }

  @override
  void initState() {
    if (_getType() == 'present')
      _title = "Members Present";
    else if (_getType() == 'late')
      _title = "Late Members";
    else if (_getType() == 'withApology')
      _title = "Absent With Apology";
    else if (_getType() == 'withoutApology') _title = "Absent Without Apology";
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
    print(_groupMembers);
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
        leadingIcon: LineAwesomeIcons.times,
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
                          _selectedMembers()['count'] == 0
                              ? Icon(
                                  Icons.lightbulb_outline,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionTheme.selectionHandleColor,
                                  size: 24.0,
                                  semanticLabel: 'Select members...',
                                )
                              : Icon(
                                  Icons.group,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionTheme.selectionHandleColor
                                      .withOpacity(0.7),
                                  size: 24.0,
                                  semanticLabel: 'Selected members...',
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _selectedMembers()['count'] == 0
                                    ? subtitle1(
                                        text: "Select members",
                                        textAlign: TextAlign.start,
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionTheme.selectionHandleColor,
                                      )
                                    : subtitle1(
                                        text: _selectedMembers()['count']
                                                .toString() +
                                            " other members selected",
                                        textAlign: TextAlign.start,
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionTheme.selectionHandleColor,
                                      ),
                                _selectedMembers()['count'] == 0
                                    ? subtitle2(
                                        text:
                                            "Select the members you want to add and save.",
                                        color: Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionTheme.selectionHandleColor,
                                        textAlign: TextAlign.start,
                                      )
                                    : _selectedMembers()['render'],
                              ],
                            ),
                          ),
                          _selectedMembers()['count'] != 0
                              ? Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.red[500],
                                    ),
                                    highlightColor:
                                        Colors.red[100].withOpacity(0.8),
                                    onPressed: () => _clearMembersDialog(),
                                  ),
                                )
                              : SizedBox()
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
                                      CheckboxListTile(
                                        activeColor: primaryColor,
                                        isThreeLine: false,
                                        dense: true,
                                        title: Text(
                                          _groupMembers[index]['name'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: _groupMembers[index]
                                                    ['isCheck']
                                                ? primaryColor
                                                : Theme.of(context)
                                                    // ignore: deprecated_member_use
                                                    .textSelectionTheme.selectionHandleColor,
                                          ),
                                        ),
                                        subtitle: Text(
                                          _groupMembers[index]['identity'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _groupMembers[index]
                                                    ['isCheck']
                                                ? primaryColor
                                                : Theme.of(context)
                                                    // ignore: deprecated_member_use
                                                    .textSelectionTheme.selectionHandleColor,
                                          ),
                                        ),
                                        value: _groupMembers[index]['isCheck'],
                                        secondary: Container(
                                          height: 42,
                                          width: 42,
                                          child: CircleAvatar(
                                            foregroundColor:
                                                _groupMembers[index]['isCheck']
                                                    ? Colors.white
                                                    : (themeChangeProvider
                                                            .darkTheme)
                                                        ? Colors.blueGrey[900]
                                                        : Colors.white,
                                            backgroundColor: _groupMembers[
                                                    index]['isCheck']
                                                ? primaryColor
                                                : Theme.of(context)
                                                    // ignore: deprecated_member_use
                                                    .textSelectionTheme.selectionHandleColor,
                                            child: Text(
                                              getInitials(
                                                _groupMembers[index]['name'],
                                              ),
                                            ),
                                          ),
                                        ),
                                        onChanged: (bool val) {
                                          itemChange(val, index);
                                        },
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
                                  iconData: LineAwesomeIcons.file,
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
                  if (m['isCheck'] == true) {
                    _selected.add({
                      'id': m['id'],
                      'name': m['name'],
                      'identity': m['identity'],
                      'avatar': m['avatar'],
                      'user_id': m['user_id'],
                    });
                  }
                });
                dynamic _members = widget.selected;
                _members[_getType()] = _selected;
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
