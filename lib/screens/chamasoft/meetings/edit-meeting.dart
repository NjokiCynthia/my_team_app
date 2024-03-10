import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/database-helper.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/meetings/edit-collections.dart';

// import 'package:chamasoft/screens/chamasoft/meetings/select-members.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/transactions/select-member.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class EditMeeting extends StatefulWidget {
  @override
  _EditMeetingState createState() => _EditMeetingState();
}

class _EditMeetingState extends State<EditMeeting> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //  List<MembersFilterEntry> selectedMembersList = [];

  int currentStep = 0;
  bool complete = false;
  List<Step> steps = [];
  final _stepOneFormKey = GlobalKey<FormState>();
  final _agendaFormKey = GlobalKey<FormState>();
  final _aobFormKey = GlobalKey<FormState>();
  Map<String, dynamic> _data = {
    'title': "",
    'venue': "",
    'purpose': "",
    'date': "",
    'members': {
      'present': [],
      'withApology': [],
      'withoutApology': [],
      'late': [],
    },
    'agenda': [],
    'collections': {
      'contributions': [],
      'repayments': [],
      'disbursements': [],
      'fines': [],
    },
    'aob': [],
  };
  String _groupCurrency = "Ksh";
  bool _saving = false;

  _setMembers(String type, dynamic members) {
    List<dynamic> _groupMember = [];
    for (MembersFilterEntry member in members) {
      _groupMember.add({
        'id': member.memberId,
        'name': member.name,
        'identity': member.phoneNumber,
        'avatar': member.avatar,
        'user_id': member.userId,
      });
    }
    setState(() {
      _data['members'][type] = _groupMember;
    });
  }

  List<MembersFilterEntry> _setSelectedMembers(String type) {
    List<MembersFilterEntry> _selectedMemberList = [];
    var members = _data["members"][type];
    if (members.length > 0) {
      for (int i = 0; i < members.length; i++) {
        _selectedMemberList.add(MembersFilterEntry(
          memberId: members[i]["id"],
          name: members[i]["name"],
        ));
      }
    }
    return _selectedMemberList;
  }

  _setCollections(dynamic collection, String type) {
    setState(() {
      _data['collections'][type] = collection;
    });
    print("<<<<<<<< type >>>>>>>> ");
    _data.forEach((final String key, final dynamic value) {
      print({'$key': '$value'});
    });
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  _showSnackbar(String msg, int duration) {
   
    ScaffoldMessenger.of(_scaffoldKey.currentState.context)
        .hideCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: duration),
    );
   
    ScaffoldMessenger.of(_scaffoldKey.currentState.context)
        .showSnackBar(snackBar);
  }

  next() {
    if (currentStep + 1 != steps.length) {
      if (currentStep == 0) {
        if (_stepOneFormKey.currentState.validate()) {
          if (_data['date'] == '') {
            _showSnackbar(
                "You need to select the meeting date to continue.", 4);
          } else {
            goTo(1);
          }
        } else {
          _showSnackbar("Fill in the required fields to continue.", 4);
        }
      } else {
        if (currentStep == 1) {
          if (_data['members']['present'].length == 0) {
            _showSnackbar("You need to select members present to continue.", 4);
          } else {
            goTo(currentStep + 1);
          }
        } else if (currentStep == 2) {
          if (_data['agenda'].length == 0) {
            _showSnackbar("You need to add at least one agenda item.", 4);
          } else {
            goTo(currentStep + 1);
          }
        } else {
          goTo(currentStep + 1);
        }
      }
    } else {
      // print(_data);
      setState(() {
        _saving = true;
      });
      saveMeeting();
      setState(() => complete = true);
    }
  }

  saveMeeting() async {
    // print("_data >>> ");
    // print(_data);
    await insertToLocalDb(
      DatabaseHelper.meetingsTable,
      {
        "group_id": _data['group_id'],
        "user_id": _data['user_id'],
        "title": _data['title'],
        "venue": _data['venue'],
        "purpose": _data['purpose'],
        "date": _data['date'],
        "members": jsonEncode(_data['members']),
        "agenda": jsonEncode(_data['agenda']),
        "collections": jsonEncode(_data['collections']),
        "aob": jsonEncode(_data['aob']),
        "submitted_on": 0,
        "synced_on": 0,
        "modified_on": DateTime.now().millisecondsSinceEpoch,
      },
    );
    setState(() {
      _saving = false;
    });
    Navigator.of(context).pop();
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  formatStep(step, title) {
    return Text(
      title,
      style: TextStyle(
        color: currentStep >= step
            ? primaryColor
           
            : Theme.of(context).textSelectionTheme.selectionHandleColor,
        fontFamily: 'SegoeUI',
        fontWeight: currentStep >= step ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  String validateMeeting(String field, String value) {
    if (field == 'title') {
      if (value.isEmpty)
        return "Meeting title is required";
      else if (value.length < 6)
        return "Meeting title is way too short";
      else {
        _data['title'] = value;
        return null;
      }
    } else if (field == 'venue') {
      if (value.isEmpty)
        return "Meeting venue is required";
      else if (value.length < 3)
        return "Meeting venue is way too short";
      else {
        _data['venue'] = value;
        return null;
      }
    } else if (field == 'purpose') {
      _data['purpose'] = value;
      return null;
    } else {
      return null;
    }
  }

  Widget agendaItem({String agenda, Function action}) {
    return Container(
     
      color: Theme.of(context)
          .textSelectionTheme
          .selectionHandleColor
          .withOpacity(0.1),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agenda,
                  style: TextStyle(
                   
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.close,
                color: Colors.red[700],
                size: 16.0,
              ),
            ),
            onTap: action,
          ),
        ],
      ),
    );
  }

  Widget summaryTitle({String text}) {
    return Text(
      text,
      style: TextStyle(
       
        color: Theme.of(context).textSelectionTheme.selectionHandleColor,
        fontSize: 12.0,
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
    );
  }

  TextStyle summaryContentFormat() {
    return TextStyle(
     
      color: Theme.of(context).textSelectionTheme.selectionHandleColor,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    );
  }

  String summaryList(String type) {
    String _resp = "";
    List<dynamic> _list = _data[type];
    _list.forEach((l) {
      _resp += (_list.indexOf(l) + 1).toString() +
          ". " +
          l.toString() +
          (((_list.indexOf(l) + 1) < _list.length) ? "\n" : "");
    });
    return _resp;
  }

  String _getFirstName(String name) {
    String resp = "";
    try {
      resp = name.split(" ")[0];
    } catch (e) {
      resp = name;
    }
    return resp;
  }

  Widget renderAgenda() {
    List<Widget> _list = [];
    List<dynamic> agenda = [..._data['agenda']];
    agenda.forEach((a) {
      _list.add(agendaItem(
        agenda: a,
        action: () {
          agenda.removeAt(agenda.indexOf(a));
          setState(() {
            _data['agenda'] = agenda;
          });
        },
      ));
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: (_list.length > 0)
          ? _list
          : [
              subtitle1(
                color:
                   
                    Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor
                        .withOpacity(0.7),
                text: "No agenda added",
                textAlign: TextAlign.left,
              ),
              subtitle2(
                color:
                   
                    Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor
                        .withOpacity(0.7),
                text: "Added agenda items will be displayed here",
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20.0),
            ],
    );
  }

  Widget renderAob() {
    List<Widget> _list = [];
    List<dynamic> aob = [..._data['aob']];
    aob.forEach((a) {
      _list.add(agendaItem(
        agenda: a,
        action: () {
          aob.removeAt(aob.indexOf(a));
          setState(() {
            _data['aob'] = aob;
          });
        },
      ));
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: (_list.length > 0)
          ? _list
          : [
              subtitle1(
                color:
                   
                    Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor
                        .withOpacity(0.7),
                text: "No AOB added",
                textAlign: TextAlign.left,
              ),
              subtitle2(
                color:
                   
                    Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor
                        .withOpacity(0.7),
                text: "Added AOB items will be displayed here",
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20.0),
            ],
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
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final currentGroup = group.getCurrentGroup();
    _data['group_id'] = currentGroup.groupId;
    _data['user_id'] = auth.id;
    _groupCurrency = currentGroup.groupCurrency;
    var formatter = NumberFormat('#,##,##0', "en_US");

    String _renderMembersText(String type) {
      List<dynamic> _mbrs = _data['members'][type];
      // if (_mbrs.length > 1)
      //   return (_mbrs.length).toString() + " members";
      // else if (_mbrs.length == 1) {
      //   return (_mbrs.length).toString() + " member";
      // }
      if (_mbrs.length == 1)
        return "1 member";
      else if (_mbrs.length > 1)
        return _getFirstName(_data['members'][type][0]['name']) +
            " & " +
            (_mbrs.length - 1).toString() +
            " other members";
      else
        return "Tap to select members";
    }

    String _renderCollectionsText(String type) {
      List<dynamic> _collections = _data['collections'][type];
      int _total = 0;
      String _totalAmnt = "";
      _collections.forEach((c) {
        _total = _total + c['amount'];
      });
      _totalAmnt = _groupCurrency + " " + formatter.format(_total);
      if (_collections.length > 0)
        return _totalAmnt +
            " from " +
            (_collections.length).toString() +
            (_collections.length == 1 ? " member" : " members");
      else
        return "Tap to manage " + type;
    }

    String _getTotals(String type) {
      double totals = 0;
      List<dynamic> _collection = _data['collections'][type];
      _collection.forEach((c) => totals += c['amount']);
      print("totals : $totals");
      return _groupCurrency + " " + formatter.format(totals);
    }

    steps = [
      Step(
        title: formatStep(0, "Name & Venue"),
        isActive: currentStep >= 0 ? true : false,
        state: currentStep > 0 ? StepState.complete : StepState.disabled,
        content: Form(
          key: _stepOneFormKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (val) => validateMeeting('title', val),
                decoration: InputDecoration(
                  labelText: 'Meeting Title',
                  hintText: 'The title for this meeting',
                  // contentPadding: EdgeInsets.only(bottom: 0.0),
                ),
              ),
              TextFormField(
                validator: (val) => validateMeeting('venue', val),
                decoration: InputDecoration(
                  labelText: 'Venue',
                  hintText: 'The venue for this meeting',
                  // contentPadding: EdgeInsets.only(bottom: 0.0),
                ),
              ),
              TextFormField(
                validator: (val) => validateMeeting('purpose', val),
                decoration: InputDecoration(
                  labelText: 'Meeting Purpose (Optional)',
                  // contentPadding: EdgeInsets.only(bottom: 0.0),
                ),
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                initialValue: '',
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                dateLabelText: 'Meeting Date & Time',
                onChanged: (val) => _data['date'] = val,
                validator: (val) {
                  _data['date'] = val;
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: formatStep(1, "Members"),
        isActive: currentStep >= 1 ? true : false,
        state: currentStep > 1 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[
            Container(
              color: Colors.green.withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SelectMember(
                          initialMembersList: _setSelectedMembers("present"),
                          pageTitle: "Select Present Members",
                          hideFromList: [],
                        ),
                      ),
                    )
                    .then((value) => {_setMembers('present', value)}),
                title: "Members present",
                subtitle: _renderMembersText("present"),
                icon: Icons.edit,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.cyan.withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SelectMember(
                          initialMembersList: _setSelectedMembers("late"),
                          pageTitle: "Select Members Late",
                          hideFromList: _setSelectedMembers("present"),
                        ),
                      ),
                    )
                    .then((value) => {_setMembers('late', value)}),
                title: "Members late",
                subtitle: _renderMembersText("late"),
                icon: Icons.edit,
                color: Colors.cyan,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.orange[700].withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SelectMember(
                          initialMembersList:
                              _setSelectedMembers("withApology"),
                          pageTitle: "Members Late With Apology",
                          hideFromList: _setSelectedMembers("present") +
                              _setSelectedMembers("late"),
                        ),
                      ),
                    )
                    .then((value) => {_setMembers('withApology', value)}),
                title: "Absent with apology",
                subtitle: _renderMembersText("withApology"),
                icon: Icons.edit,
                color: Colors.orange[700],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.red[400].withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SelectMember(
                          initialMembersList:
                              _setSelectedMembers("withoutApology"),
                          pageTitle: "Members Absent Without Apology",
                          hideFromList: _setSelectedMembers("present") +
                              _setSelectedMembers("late") +
                              _setSelectedMembers("withApology"),
                        ),
                      ),
                    )
                    .then((value) => {_setMembers('withoutApology', value)}),
                title: "Absent without apology",
                subtitle: _renderMembersText("withoutApology"),
                icon: Icons.edit,
                color: Colors.red[400],
              ),
            ),
          ],
        ),
      ),
      Step(
        title: formatStep(2, "Agenda"),
        isActive: currentStep >= 2 ? true : false,
        state: currentStep > 2 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[
            Form(
              key: _agendaFormKey,
              child: Stack(
                children: <Widget>[
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty)
                        return "Agenda is required";
                      else if (val.length < 3)
                        return "Agenda is way too short";
                      else {
                        List<dynamic> _tempAgenda = [..._data['agenda']];
                        _tempAgenda.add(val);
                        setState(() {
                          _data['agenda'] = _tempAgenda;
                        });
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Add agenda item...',
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    top: 0.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.check,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        if (_agendaFormKey.currentState.validate()) {
                          _agendaFormKey.currentState.reset();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            renderAgenda(),
          ],
        ),
      ),
      Step(
        title: formatStep(3, "Collections"),
        isActive: currentStep >= 3 ? true : false,
        state: currentStep > 3 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[
            Container(
              color: Colors.green[700].withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => EditCollections(
                        type: 'contributions',
                        recorded: _data['collections'],
                        collections: (collection) =>
                            _setCollections(collection, 'contributions'),
                      ),
                    ),
                  );
                },
                title: "Group Contributions",
                subtitle: _renderCollectionsText('contributions'),
                icon: Icons.edit,
                color: Colors.green[700],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.cyan[700].withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditCollections(
                      type: 'repayments',
                      recorded: _data['collections'],
                      collections: (collection) =>
                          _setCollections(collection, 'repayments'),
                    ),
                  ),
                ),
                title: "Loan Repayments",
                subtitle: _renderCollectionsText('repayments'),
                icon: Icons.edit,
                color: Colors.cyan[700],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.red[700].withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditCollections(
                      type: 'fines',
                      recorded: _data['collections'],
                      collections: (collection) =>
                          _setCollections(collection, 'fines'),
                    ),
                  ),
                ),
                title: "Fine Payments",
                subtitle: _renderCollectionsText('fines'),
                icon: Icons.edit,
                color: Colors.red[700],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.brown.withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditCollections(
                      type: 'disbursements',
                      recorded: _data['collections'],
                      collections: (collection) =>
                          _setCollections(collection, 'disbursements'),
                    ),
                  ),
                ),
                title: "Loan Disbursements",
                subtitle: _renderCollectionsText('disbursements'),
                icon: Icons.edit,
                color: Colors.brown,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
      Step(
        title: formatStep(4, "AOB"),
        isActive: currentStep >= 4 ? true : false,
        state: currentStep > 4 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[
            Form(
              key: _aobFormKey,
              child: Stack(
                children: <Widget>[
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty)
                        return "AOB is required";
                      else if (val.length < 3)
                        return "AOB is way too short";
                      else {
                        List<dynamic> _tempAob = [..._data['aob']];
                        _tempAob.add(val);
                        setState(() {
                          _data['aob'] = _tempAob;
                        });
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Add AOB item...',
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    top: 0.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.check,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        if (_aobFormKey.currentState.validate()) {
                          _aobFormKey.currentState.reset();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            renderAob(),
          ],
        ),
      ),
      Step(
        title: formatStep(5, "Summary"),
        isActive: currentStep >= 5 ? true : false,
        state: currentStep > 5 ? StepState.complete : StepState.disabled,
        content: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              summaryTitle(text: "Meeting title"),
              Text(
                _data["title"],
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryTitle(text: "Venue"),
              Text(
                _data["venue"],
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryTitle(text: "Date"),
              Text(
                _data["date"],
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryTitle(text: "Members"),
              Text(
                (_data['members']['present'].length).toString() +
                    " present, " +
                    (_data['members']['late'].length).toString() +
                    " late, " +
                    (_data['members']['withApology'].length).toString() +
                    " absent with apology and " +
                    (_data['members']['withoutApology'].length).toString() +
                    " absent without",
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryList("agenda") != ""
                  ? summaryTitle(text: "Agenda")
                  : SizedBox(),
              summaryList("agenda") != ""
                  ? Text(
                      summaryList("agenda"),
                      style: summaryContentFormat(),
                      overflow: TextOverflow.ellipsis,
                    )
                  : SizedBox(),
              summaryList("agenda") != "" ? SizedBox(height: 10.0) : SizedBox(),
              summaryTitle(text: "Collections"),
              Text(
                "1. Group contributions: ${_getTotals('contributions')}\n" +
                    "2. Loan repayments: ${_getTotals('repayments')}\n" +
                    "3. Fine payments: ${_getTotals('fines')}\n" +
                    "4. Loan disbursements: ${_getTotals('disbursements')}\n",
                // "\n"+
                // "4. Total Collections: ${_getTotals('disbursements')}\n",
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryList("aob") != "" ? summaryTitle(text: "AOB") : SizedBox(),
              summaryList("aob") != ""
                  ? Text(
                      summaryList("aob"),
                      style: summaryContentFormat(),
                      overflow: TextOverflow.ellipsis,
                    )
                  : SizedBox(),
              summaryList("aob") != "" ? SizedBox(height: 10.0) : SizedBox(),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "New Meeting",
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
            child: Column(
              children: [
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
                            .textSelectionTheme
                            .selectionHandleColor,
                        size: 24.0,
                        semanticLabel: 'About new meeting...',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            subtitle1(
                              text: "About new meeting...",
                              textAlign: TextAlign.start,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                            ),
                            subtitle2(
                              text:
                                  "Follow all the steps and provide all required data about this meeting. You'll be able to preview a summary of the meeting before you submit.",
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Stepper(
                  physics: ClampingScrollPhysics(),
                  steps: steps,
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepTapped: (step) => goTo(step),
                  onStepCancel: cancel,
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controlDetails) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 12.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                         
                          // RaisedButton(
                          //   color: primaryColor,
                          //   child: Padding(
                          //     padding:
                          //     EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          //     child: Row(
                          //       children: [
                          //         Text(
                          //           currentStep == 5
                          //               ? "Confirm & Submit"
                          //               : "Save & Continue",
                          //           style: TextStyle(
                          //               fontFamily: 'SegoeUI',
                          //               fontWeight: FontWeight.w700),
                          //         ),
                          //         (_saving)
                          //             ? SizedBox(width: 10.0)
                          //             : SizedBox(),
                          //         (_saving)
                          //             ? SizedBox(
                          //           height: 16.0,
                          //           width: 16.0,
                          //           child: CircularProgressIndicator(
                          //             strokeWidth: 2.5,
                          //             backgroundColor: Colors.transparent,
                          //             valueColor:
                          //             AlwaysStoppedAnimation<Color>(
                          //               Colors.grey[700],
                          //             ),
                          //           ),
                          //         )
                          //             : SizedBox(),
                          //       ],
                          //     ),
                          //   ),
                          //   textColor: Colors.white,
                          //   onPressed: (!_saving) ? onStepContinue : null,
                          // ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                              child: Row(
                                children: [
                                  Text(
                                    currentStep == 5
                                        ? "Confirm & Submit"
                                        : "Save & Continue",
                                    style: TextStyle(
                                      fontFamily: 'SegoeUI',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  _saving ? SizedBox(width: 10.0) : SizedBox(),
                                  _saving
                                      ? SizedBox(
                                          height: 16.0,
                                          width: 16.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            backgroundColor: Colors.transparent,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.grey[700],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                            onPressed:
                                !_saving ? controlDetails.onStepContinue : null,
                          ),

                          SizedBox(
                            width: 20.0,
                          ),
                          currentStep > 0
                             
                              // ? OutlineButton(
                              //     color: Colors.white,
                              //     child: Text(
                              //       "Go Back",
                              //       style: TextStyle(
                              //         color: Theme.of(context)
                              //            
                              //             .textSelectionTheme.selectionHandleColor,
                              //       ),
                              //     ),
                              //     borderSide: BorderSide(
                              //       width: 2.0,
                              //       color: Theme.of(context)
                              //          
                              //           .textSelectionTheme.selectionHandleColor
                              //           .withOpacity(0.5),
                              //     ),
                              //     highlightColor: Theme.of(context)
                              //        
                              //         .textSelectionTheme.selectionHandleColor
                              //         .withOpacity(0.1),
                              //     highlightedBorderColor: Theme.of(context)
                              //        
                              //         .textSelectionTheme.selectionHandleColor
                              //         .withOpacity(0.6),
                              //     onPressed: (!_saving) ? onStepCancel : null,
                              //   )
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(
                                      width: 2.0,
                                      color: Theme.of(context)
                                         
                                          .textSelectionTheme
                                          .selectionHandleColor
                                          .withOpacity(0.5),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Go Back",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                         
                                          .textSelectionTheme
                                          .selectionHandleColor,
                                    ),
                                  ),
                                  onPressed: !_saving
                                      ? controlDetails.onStepCancel
                                      : null,
                                )
                              : SizedBox(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
