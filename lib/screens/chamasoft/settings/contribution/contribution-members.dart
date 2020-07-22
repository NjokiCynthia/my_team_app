import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/dashed-divider.dart';
import 'package:flutter/material.dart';

class ContributionMembers extends StatefulWidget {
  final dynamic responseData;
  final Function(dynamic) onButtonPressed;

  ContributionMembers({@required this.responseData, @required this.onButtonPressed});

  @override
  _ContributionMembersState createState() => _ContributionMembersState();
}

class _ContributionMembersState extends State<ContributionMembers> {
  List<MembersFilterEntry> selectedMembersList = [];
  int selectedTabIndex = 0;
  bool selectAll = false;
  int currentPage = 0;
  final List<MembersFilterEntry> _membersList = <MembersFilterEntry>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
          title: Text(
            "Members",
            style: TextStyle(color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            "Select members who will contribute",
            style: TextStyle(color: Theme.of(context).bottomAppBarColor),
          ),
        ),
        CheckboxListTile(
          title: Text(
            "Select All",
            style: TextStyle(color: Theme.of(context).textSelectionHandleColor, fontWeight: FontWeight.w500),
          ),
          value: selectAll,
          onChanged: (value) {
            setState(() {
              selectAll = value;
              if (selectAll) {
                selectedMembersList.clear();
                selectedMembersList.addAll(_membersList);
              } else {
                selectedMembersList.clear();
              }
            });
          },
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _membersList.length,
            separatorBuilder: (context, index) => DashedDivider(
              thickness: 1.0,
              color: Color(0xFFD4D4D4),
            ),
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                secondary: const Icon(Icons.person),
                value: selectedMembersList.contains(_membersList[index]),
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      selectedMembersList.add(_membersList[index]);
                    } else {
                      selectedMembersList.remove(_membersList[index]);
                    }
                  });
                },
                title: Text(_membersList[index].name),
                subtitle: Text(_membersList[index].phoneNumber),
              );
            },
          ),
        ),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: RaisedButton(
              onPressed: widget.onButtonPressed(null),
              color: primaryColor,
              child: Text(
                'Save & Continue',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ))
      ]),
    );
  }
}
