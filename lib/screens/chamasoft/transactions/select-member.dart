import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SelectMember extends StatefulWidget {
  final List<MembersFilterEntry> initialMembersList;
  final String pageTitle;
  final List<MembersFilterEntry> hideFromList;

  SelectMember(
      {@required this.initialMembersList, this.pageTitle, this.hideFromList});

  @override
  State<StatefulWidget> createState() => new SelectMemberState();
}

class SelectMemberState extends State<SelectMember> {
  TextEditingController controller = new TextEditingController();
  String filter;
  Future<void> _future;
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> _membersList = <MembersFilterEntry>[];
  List<MembersFilterEntry> selectedMembersList, hideFromList = [];
  String pageTitle = "";

  @override
  void initState() {
    selectedMembersList =
        widget.initialMembersList == null ? [] : widget.initialMembersList;
    hideFromList = widget.hideFromList == null ? [] : widget.hideFromList;
    pageTitle = widget.pageTitle == null ? "Select members" : widget.pageTitle;
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    _future = _getGroupMembers(context, false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _getGroupMembers(BuildContext context,
      [bool fullRefresh = false]) async {
    try {
      List<Member> members;
      if (fullRefresh) {
        await Provider.of<Groups>(context, listen: false).fetchMembers();
        members = Provider.of<Groups>(context, listen: false).members;
      } else {
        members = Provider.of<Groups>(context, listen: false).members;
      }
      if (members.length == 0) {
        await Provider.of<Groups>(context, listen: false).fetchMembers();
        members = Provider.of<Groups>(context, listen: false).members;
      }
      List<MembersFilterEntry> emptyMemberOptions = [];
      members
          .map((member) => emptyMemberOptions.add(MembersFilterEntry(
              memberId: member.id,
              name: member.name,
              phoneNumber: member.identity,
              amount: 0.0)))
          .toList();
      setState(() {
        _membersList = emptyMemberOptions;
      });
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getGroupMembers(context, false);
          });
    } finally {}
  }

  Widget _memberListDisplay(
      MembersFilterEntry entry, bool isSelected, int index) {
    if (hideFromList
            .indexWhere((element) => element.memberId == entry.memberId) >=
        0) return Container();
    return Container(
      padding: EdgeInsets.only(top: 1.0, bottom: 1.0),
      child: Column(
        children: <Widget>[
          CheckboxListTile(
            activeColor: primaryColor,
            isThreeLine: false,
            dense: true,
            title: Text(
              entry.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? primaryColor
                    : Theme.of(context)
                        // ignore: deprecated_member_use
                        .textSelectionHandleColor,
              ),
            ),
            subtitle: Text(
              entry.phoneNumber,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? primaryColor
                    : Theme.of(context)
                        // ignore: deprecated_member_use
                        .textSelectionHandleColor,
              ),
            ),
            value: isSelected,
            secondary: Container(
              height: 42,
              width: 42,
              child: CircleAvatar(
                foregroundColor: isSelected
                    ? Colors.white
                    : (themeChangeProvider.darkTheme)
                        ? Colors.blueGrey[900]
                        : Colors.white,
                backgroundColor: isSelected
                    ? primaryColor
                    : Theme.of(context)
                        // ignore: deprecated_member_use
                        .textSelectionHandleColor,
                child: Text(
                  CustomHelper.getInitials(
                    entry.name,
                  ),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                if (value) {
                  selectedMembersList.add(_membersList[index]);
                } else {
                  for (var selected in selectedMembersList) {
                    if (selected.memberId == entry.memberId) {
                      selectedMembersList.remove(selected);
                      break;
                    }
                  }
                }
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tertiaryPageAppbar(
        context: context,
        action: () => Navigator.pop(context, selectedMembersList),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.times,
        title: pageTitle,
        trailingIcon: LineAwesomeIcons.check,
        trailingAction: () async {
          if (selectedMembersList.length > 0) {
            Navigator.pop(context, selectedMembersList);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).backgroundColor,
                  title: new Text("Please select a member"),
                  actions: <Widget>[
                    // ignore: deprecated_member_use
                    new FlatButton(
                      child: new Text(
                        "OK",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          height: (MediaQuery.of(context).size.height) - (_membersList.length),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              TextField(
                style: inputTextStyle(),
                decoration: InputDecoration(
                  labelText: "Search Member",
                  prefixIcon: Icon(LineAwesomeIcons.search),
                ),
                controller: controller,
              ),
              Expanded(
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(bottom: 20.0),
                  margin: EdgeInsets.only(bottom: 50.0),
                  child: _membersList == null
                      ? Center(
                          child: Text("There are no members to select"),
                        )
                      : FutureBuilder(
                          future: _future,
                          builder: (ctx, snapshot) => snapshot
                                      .connectionState ==
                                  ConnectionState.waiting
                              ? Center(child: CircularProgressIndicator())
                              : RefreshIndicator(
                                  backgroundColor:
                                      (themeChangeProvider.darkTheme)
                                          ? Colors.blueGrey[800]
                                          : Colors.white,
                                  onRefresh: () =>
                                      _getGroupMembers(context, true),
                                  child: Consumer<Groups>(
                                    child: Center(
                                      child: Text("Groups"),
                                    ),
                                    builder: (ctx, groups, ch) =>
                                        ListView.builder(
                                            itemCount: _membersList.length,
                                            itemBuilder: (context, index) {
                                              bool isSelected = false;
                                              MembersFilterEntry entry =
                                                  _membersList[index];
                                              for (var selected
                                                  in selectedMembersList) {
                                                if (selected.memberId ==
                                                    entry.memberId) {
                                                  isSelected = true;
                                                  break;
                                                }
                                              }
                                              return filter == null ||
                                                      filter == ""
                                                  ? _memberListDisplay(
                                                      entry, isSelected, index)
                                                  : _membersList[index]
                                                          .name
                                                          .toLowerCase()
                                                          .contains(filter
                                                              .toLowerCase())
                                                      ? _memberListDisplay(
                                                          entry,
                                                          isSelected,
                                                          index)
                                                      : new Container();
                                            }),
                                  ),
                                ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
