import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dashed-divider.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContributionMembers extends StatefulWidget {
  final dynamic responseData;
  final bool isEditMode;
  final dynamic contributionDetails;
  final Function(dynamic) onButtonPressed;

  ContributionMembers(
      {@required this.responseData,
      this.isEditMode,
      this.contributionDetails,
      @required this.onButtonPressed});

  @override
  _ContributionMembersState createState() => _ContributionMembersState();
}

class _ContributionMembersState extends State<ContributionMembers> {
  List<Member> _selectedMembers = [];
  List<Member> _members = [];
  int selectedTabIndex = 0;
  bool selectAll = false;
  bool _isLoading = false;
  int currentPage = 0;
  String contributionId;
  String requestId =
      ((DateTime.now().millisecondsSinceEpoch / 1000).truncate()).toString();

  void _getGroupMembers() {
    contributionId = widget.responseData['contribution_id'].toString();
    final membersJson = widget.responseData['members'] as List<dynamic>;
    for (var memberJson in membersJson) {
      String identity = memberJson["phone"].toString() ?? '';
      final email = memberJson["email"].toString() ?? '';
      if (identity.isEmpty) {
        identity = email;
      }
      final member = Member(
          id: memberJson['id'].toString(),
          name: memberJson['first_name'].toString() +
              ' ' +
              memberJson['last_name'].toString(),
          userId: memberJson['user_id'].toString(),
          identity: identity,
          phone:identity ,
          avatar: memberJson['avatar'].toString());
      _members.add(member);
    }

    if (widget.isEditMode) {
      final members =
          widget.contributionDetails['selected_group_members'] as List<dynamic>;
      if (members.length == _members.length) {
        setState(() {
          selectAll = true;
          _selectedMembers.clear();
          _selectedMembers.addAll(_members);
        });
      } else {
        for (var id in members) {
          for (var member in _members) {
            if (id == member.id) {
              _selectedMembers.add(member);
            }
          }
        }
        setState(() {});
      }
    }
  }

  void _submit(BuildContext context) async {
    Map<String, dynamic> formData = {};
    formData["request_id"] = requestId;
    formData["contribution_id"] = contributionId;
    if (selectAll) {
      formData["all_members"] = 1;
    } else {
      if (_selectedMembers.length < 1) {
        formData["all_members"] = 1;
      } else {
        formData["all_members"] = 0;

        List<dynamic> theChosen = [];
        for (var member in _selectedMembers) {
          Map<String, dynamic> id = {};
          id['member_id'] = member.id;
          theChosen.add(id);
        }
        formData["contributing_members"] = theChosen;
      }
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Provider.of<Groups>(context, listen: false)
          .addContributionStepTwo(formData);
      print(response);
      requestId = null;
      alertDialogWithAction(context, response["message"].toString(), () {
        Navigator.of(context).pop();
        widget.onButtonPressed(response);
      }, false);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _submit(context);
          });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getGroupMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                "Members",
                style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "Select members who will contribute",
                style: TextStyle(color: Theme.of(context).bottomAppBarColor),
              ),
            ),
            CheckboxListTile(
              title: Text(
                "Select All",
                style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                    fontWeight: FontWeight.w500),
              ),
              value: selectAll,
              onChanged: (value) {
                setState(() {
                  selectAll = value;
                  if (selectAll) {
                    _selectedMembers.clear();
                    _selectedMembers.addAll(_members);
                  } else {
                    _selectedMembers.clear();
                  }
                });
              },
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _members.length,
                separatorBuilder: (context, index) => DashedDivider(
                  thickness: 1.0,
                  color: Color(0xFFD4D4D4),
                ),
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    secondary: const Icon(Icons.person),
                    value: _selectedMembers.contains(_members[index]),
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          _selectedMembers.add(_members[index]);
                        } else {
                          _selectedMembers.remove(_members[index]);
                        }
                      });
                    },
                    title: Text(_members[index].name),
                    subtitle: Text(_members[index].identity),
                  );
                },
              ),
            ),
            _isLoading
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(child: CircularProgressIndicator()))
                : Column(
                    children: <Widget>[
                      defaultButton(
                        context: context,
                        text: "Save & Continue",
                        onPressed: () => _submit(context),
                      ),
                    ],
                  ),
            SizedBox(
              height: 10,
            )
          ]),
    );
  }
}
