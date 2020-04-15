import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final List<MembersFilterEntry> _membersList = <MembersFilterEntry>[
  const MembersFilterEntry('Peter Kimutai', 'PK'),
  const MembersFilterEntry('Samuel Wahome', 'SW'),
  const MembersFilterEntry('Edwin Kapkei', 'EK'),
  const MembersFilterEntry('Geoffrey Githaiga', 'GG'),
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
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Select Members",
        trailingIcon: LineAwesomeIcons.check,
        trailingAction: () async {
          if (selectedMembersList != null) {
            Navigator.pop(context, selectedMembersList);
          } else {
            Alert(
              context: context,
              style: AlertStyle(
                backgroundColor: Colors.white,
              ),
              type: AlertType.error,
              title: "ERROR",
              desc: "Please select members",
              buttons: [
                DialogButton(
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show();
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
                            child: ListTile(
                              leading: Checkbox(
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
                              ),
                              title: Text(_membersList[index].name),
                            ),
                          )
                        : _membersList[index]
                                .name
                                .toLowerCase()
                                .contains(filter.toLowerCase())
                            ? Card(
                                child: ListTile(
                                  leading: Checkbox(
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
                                  ),
                                  title: Text(_membersList[index].name),
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
