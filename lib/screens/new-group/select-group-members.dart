import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/new-group/add-members-from-contacts.dart';
import 'package:chamasoft/screens/new-group/add-members-manually.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
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
  String _title = "Group Members";
  Map<String, String> roles = {
    "1": "Chairperson",
    "2": "Secretary",
    "3": "Member",
    "4": "Treasurer",
  };
  final List<Map<String, dynamic>> addChoices = [
    {'id': 1, 'title': 'From Contacts', 'icon': Icons.perm_contact_calendar},
    {'id': 2, 'title': 'Add manually', 'icon': Icons.edit},
  ];
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
    await group.fetchMembers();
    setState(() {
      _groupMembers = [];
      group.members.forEach((m) {
        _groupMembers.add({
          'id': m.id,
          'name': m.name,
          'identity': m.identity,
          'avatar': m.avatar,
          'user_id': m.userId,
        });
      });
      _isLoading = false;
      _isInit = false;
    });
    return true;
  }

  void choiceAction(String choice) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            choice == '1' ? SelectFromContacts() : AddGroupMembersManually(),
      ),
    )
        .then(
      (resp) {
        getGroupMembers();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    // _memberFuture = _getMembers();
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.add,
                // ignore: deprecated_member_use
                color: Theme.of(context).textSelectionHandleColor,
              ),
              onSelected: choiceAction,
              enabled: !_isLoading,
              itemBuilder: (BuildContext context) {
                return addChoices.map((Map<String, dynamic> choice) {
                  return PopupMenuItem<String>(
                    value: choice['id'].toString(),
                    child: Row(
                      children: [
                        Icon(
                          choice['icon'],
                          size: 22.0,
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        SizedBox(width: 12.0),
                        Text(
                          choice['title'],
                          style: TextStyle(
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
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
                            color: Theme.of(context)
                                // ignore: deprecated_member_use
                                .textSelectionHandleColor,
                            size: 24.0,
                            semanticLabel: 'Add members...',
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                subtitle1(
                                  text: "Group members",
                                  textAlign: TextAlign.start,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                ),
                                subtitle2(
                                  text:
                                      "Select the members you want to add to the group, you can also update their roles.",
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  textAlign: TextAlign.start,
                                ),
                              ],
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
                                        title: customTitleWithWrap(
                                          text:
                                              '${_groupMembers[index]['name']}',
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor,
                                          fontWeight: FontWeight.w800,
                                          textAlign: TextAlign.start,
                                          fontSize: 15.0,
                                        ),
                                        subtitle: customTitleWithWrap(
                                          text:
                                              '${_groupMembers[index]['identity']}',
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor
                                              .withOpacity(0.5),
                                          fontSize: 12.0,
                                        ),
                                        leading: Container(
                                          height: 42,
                                          width: 42,
                                          child: CircleAvatar(
                                            foregroundColor:
                                                (themeChangeProvider.darkTheme)
                                                    ? Colors.blueGrey[900]
                                                    : Colors.white,
                                            backgroundColor: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor,
                                            child: Text(
                                              getInitials(
                                                _groupMembers[index]['name'],
                                              ),
                                            ),
                                          ),
                                        ),
                                        trailing: smallBadgeButton(
                                          backgroundColor:
                                              Colors.blueGrey.withOpacity(0.2),
                                          textColor: Colors.blueGrey,
                                          text: roles["3"],
                                          action: () {},
                                          buttonHeight: 24.0,
                                          textSize: 12.0,
                                        ),
                                      ),
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
                _groupMembers.forEach(
                  (m) {
                    _selected.add({
                      'id': m['id'],
                      'name': m['name'],
                      'identity': m['identity'],
                      'avatar': m['avatar'],
                      'user_id': m['user_id'],
                    });
                  },
                );
                widget.members(_selected);
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
