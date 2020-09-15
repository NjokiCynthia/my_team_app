import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class SelectMember extends StatefulWidget {
  final List<MembersFilterEntry> initialMembersList;

  SelectMember({@required this.initialMembersList});

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
  List<MembersFilterEntry> selectedMembersList = [];

  @override
  void initState() {
    selectedMembersList = widget.initialMembersList;
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

  Future<void> _getGroupMembers(BuildContext context, [bool fullRefresh = false]) async {
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
          .map((member) => emptyMemberOptions.add(
              MembersFilterEntry(memberId: member.id, name: member.name, phoneNumber: member.identity, amount: 0.0)))
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tertiaryPageAppbar(
        context: context,
        action: () => Navigator.pop(context, selectedMembersList),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Select Members",
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
          height: MediaQuery.of(context).size.height,
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
                child: _membersList == null
                    ? Center(
                        child: Text("There are no members to select"),
                      )
                    : FutureBuilder(
                        future: _future,
                        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                            ? Center(child: CircularProgressIndicator())
                            : RefreshIndicator(
                                onRefresh: () => _getGroupMembers(context, true),
                                child: Consumer<Groups>(
                                  child: Center(
                                    child: Text("Groups"),
                                  ),
                                  builder: (ctx, groups, ch) => ListView.builder(
                                    itemCount: _membersList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      MembersFilterEntry entry = _membersList[index];
                                      bool isSelected = false;
                                      for (var selected in selectedMembersList) {
                                        if (selected.memberId == entry.memberId) {
                                          isSelected = true;
                                          break;
                                        }
                                      }
                                      return filter == null || filter == ""
                                          ? Card(
                                              child: CheckboxListTile(
                                                secondary: const Icon(Icons.person),
                                                value: isSelected,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value) {
                                                      selectedMembersList.add(entry);
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
                                                title: customTitle(
                                                    text: entry.name,
                                                    textAlign: TextAlign.start,
                                                    color: Theme.of(context).textSelectionHandleColor),
                                                subtitle: subtitle2(
                                                    text: entry.phoneNumber,
                                                    textAlign: TextAlign.start,
                                                    color: Theme.of(context).textSelectionHandleColor),
                                              ),
                                            )
                                          : _membersList[index].name.toLowerCase().contains(filter.toLowerCase())
                                              ? Card(
                                                  child: CheckboxListTile(
                                                    secondary: const Icon(Icons.person),
                                                    value: isSelected,
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
                                                    title: customTitle(
                                                        text: entry.name,
                                                        fontWeight: FontWeight.w800,
                                                        textAlign: TextAlign.start,
                                                        color: Theme.of(context).textSelectionHandleColor),
                                                    subtitle: subtitle1(
                                                        text: _membersList[index].phoneNumber,
                                                        textAlign: TextAlign.start,
                                                        color: Theme.of(context).textSelectionHandleColor),
                                                  ),
                                                )
                                              : new Container();
                                    },
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
