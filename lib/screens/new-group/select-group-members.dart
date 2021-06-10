import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
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
  String _title = "Add Members";
  final List<Map<String, dynamic>> addChoices = [
    {'title': 'From Contacts', 'icon': Icons.perm_contact_calendar},
    {'title': 'Add manually', 'icon': Icons.edit},
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

  void choiceAction(String choice) {
    print('choice >>>>> $choice');
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.add,
              ),
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return addChoices.map((Map<String, dynamic> choice) {
                  return PopupMenuItem<String>(
                    value: choice['title'],
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
