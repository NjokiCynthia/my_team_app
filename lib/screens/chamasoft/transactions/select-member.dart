import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

final List<MembersFilterEntry> _membersList = <MembersFilterEntry>[
  MembersFilterEntry('Peter Kimutai', 'PK', '+254 725 854 025', amount: 2500.0),
  MembersFilterEntry('Samuel Wahome', 'SW', '+254 725 854 025', amount: 5820.0),
  MembersFilterEntry('Edwin Kapkei', 'EK', '+254 725 854 025', amount: 7800.0),
  MembersFilterEntry('Geoffrey Githaiga', 'GG', '+254 725 854 025',
      amount: 6000.0),
];

class SelectMember extends StatefulWidget {
  final List<MembersFilterEntry> initialMembersList;

  SelectMember({this.initialMembersList});
  @override
  State<StatefulWidget> createState() => new SelectMemberState();
}

class SelectMemberState extends State<SelectMember> {
  List<String> items;
  TextEditingController controller = new TextEditingController();
  String filter;

  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [];

  @override
  void initState() {
    selectedMembersList = widget.initialMembersList;
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Search Member",
                  prefixIcon: Icon(LineAwesomeIcons.search),
                ),
                controller: controller,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _membersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return filter == null || filter == ""
                        ? Card(
                            child: CheckboxListTile(
                              secondary: const Icon(Icons.person),
                              value: selectedMembersList
                                  .contains(_membersList[index]),
                              onChanged: (value) {
                                setState(() {
                                  if (value) {
                                    selectedMembersList
                                        .add(_membersList[index]);
                                  } else {
                                    selectedMembersList
                                        .remove(_membersList[index]);
                                  }
                                });
                              },
                              title: Text(_membersList[index].name),
                              subtitle: Text(_membersList[index].phoneNumber),
                            ),
                          )
                        : _membersList[index]
                                .name
                                .toLowerCase()
                                .contains(filter.toLowerCase())
                            ? Card(
                                child: CheckboxListTile(
                                  secondary: const Icon(Icons.person),
                                  value: selectedMembersList
                                      .contains(_membersList[index]),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        selectedMembersList
                                            .add(_membersList[index]);
                                      } else {
                                        selectedMembersList
                                            .remove(_membersList[index]);
                                      }
                                    });
                                  },
                                  title: Text(
                                    _membersList[index].name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                  subtitle:
                                      Text(_membersList[index].phoneNumber),
                                ),
                              )
                            : new Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
