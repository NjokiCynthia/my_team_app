import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/meetings/select-members.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';

class EditMeeting extends StatefulWidget {
  @override
  _EditMeetingState createState() => _EditMeetingState();
}

class _EditMeetingState extends State<EditMeeting> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  int currentStep = 0;
  bool complete = false;
  List<Step> steps = [];
  final _stepOneFormKey = GlobalKey<FormState>();
  Map<String, dynamic> _data = {};

  goTo(int step) {
    setState(() => currentStep = step);
  }

  next() {
    if (currentStep + 1 != steps.length) {
      if (currentStep == 0) {
        if (_stepOneFormKey.currentState.validate()) {
          print(_data);
          goTo(1);
        }
      } else {
        goTo(currentStep + 1);
      }
    } else {
      setState(() => complete = true);
    }
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
            : Theme.of(context).textSelectionHandleColor,
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
      color: Theme.of(context).textSelectionHandleColor.withOpacity(0.1),
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
                    color: Theme.of(context).textSelectionHandleColor,
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
        color: Theme.of(context).textSelectionHandleColor,
        fontSize: 12.0,
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
    );
  }

  TextStyle summaryContentFormat() {
    return TextStyle(
      color: Theme.of(context).textSelectionHandleColor,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
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
    final group = Provider.of<Groups>(context);
    final currentGroup = group.getCurrentGroup();
    _data['groupId'] = currentGroup.groupId;

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
                action: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SelectMembers(
                      type: 'present',
                    ),
                  ),
                ),
                title: "Members present",
                subtitle: "Martin & 23 other members",
                icon: Icons.edit,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.orange[700].withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SelectMembers(
                      type: 'with-apology',
                    ),
                  ),
                ),
                title: "Absent with apology",
                subtitle: "Aggrey & 2 other members",
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
                action: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SelectMembers(
                      type: 'without-apology',
                    ),
                  ),
                ),
                title: "Absent without apology",
                subtitle: "1 member",
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
            Stack(
              children: [
                TextFormField(
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
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            agendaItem(
              agenda: "Some text goes here for the agenda item",
              action: () {},
            ),
            agendaItem(
              agenda:
                  "Some text goes here for the agenda item text goes here for the agenda item text goes here for the agenda item text goes here for the agenda item.",
              action: () {},
            ),
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
                action: () {},
                title: "Group Contributions",
                subtitle: "KES 13,600 contributed by 18 members",
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
                action: () {},
                title: "Loan Repayments",
                subtitle: "KES 31,000 repaid by 3 members",
                icon: Icons.edit,
                color: Colors.cyan[700],
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
                action: () {},
                title: "Loan Disbursements",
                subtitle: "KES 10,500 disbursed to 4 members",
                icon: Icons.edit,
                color: Colors.brown,
              ),
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
            Stack(
              children: [
                TextFormField(
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
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            agendaItem(
              agenda: "Some text goes here for the AOB item",
              action: () {},
            ),
            agendaItem(
              agenda:
                  "Some text goes here for the AOB item text goes here for the AOB item text goes here for the AOB item text goes here for the AOB item.",
              action: () {},
            ),
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
                "Some meeting title goes here",
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryTitle(text: "Venue"),
              Text(
                "Nairobi, KNH",
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryTitle(text: "Date"),
              Text(
                "28th April 2021",
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryTitle(text: "Members"),
              Text(
                "23 present, 2 absent with apology and 1 absent without",
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryTitle(text: "Agenda"),
              Text(
                "1. This is agent item\n" +
                    "2. This is another agenda item\n" +
                    "3. You can always have a third too, you know.",
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryTitle(text: "Collections"),
              Text(
                "1. Group contributions: KES 13,600\n" +
                    "2. Loan repayments: KES 31,000\n" +
                    "3. Loan disbursements: KES 10,500",
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              summaryTitle(text: "AOB"),
              Text(
                "1. This is AOB item\n" + "2. This is another AOB item",
                style: summaryContentFormat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
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
                        color: Theme.of(context).textSelectionHandleColor,
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
                            // subtitle1(
                            //   text: "About new meeting...",
                            //   textAlign: TextAlign.start,
                            //   color: Theme.of(context).textSelectionHandleColor,
                            // ),
                            subtitle2(
                              text:
                                  "Follow all the steps and provide all required data about this meeting. You'll be able to preview a summary of the meeting before you submit.",
                              color: Theme.of(context).textSelectionHandleColor,
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
                  controlsBuilder: (
                    BuildContext context, {
                    VoidCallback onStepContinue,
                    VoidCallback onStepCancel,
                  }) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 12.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          defaultButton(
                            context: context,
                            text: currentStep == 5
                                ? "Confirm & Submit"
                                : "Save & Continue",
                            onPressed: onStepContinue,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          currentStep > 0
                              ? OutlineButton(
                                  color: Colors.white,
                                  child: Text(
                                    "Go Back",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                    ),
                                  ),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color: Theme.of(context)
                                        .textSelectionHandleColor
                                        .withOpacity(0.5),
                                  ),
                                  highlightColor: Theme.of(context)
                                      .textSelectionHandleColor
                                      .withOpacity(0.1),
                                  highlightedBorderColor: Theme.of(context)
                                      .textSelectionHandleColor
                                      .withOpacity(0.6),
                                  onPressed: onStepCancel,
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
