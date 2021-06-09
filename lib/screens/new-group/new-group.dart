import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class NewGroup extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentStep = 0;
  bool complete = false;
  List<Step> steps = [];
  final _stepOneFormKey = GlobalKey<FormState>();
  Map<String, dynamic> _data = {
    "name": '',
  };
  bool _saving = false;

  goTo(int step) {
    setState(() => currentStep = step);
  }

  _showSnackbar(String msg, int duration) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.removeCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: duration),
    );
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  next() {
    if (currentStep + 1 != steps.length) {
      if (currentStep == 0) {
        if (_stepOneFormKey.currentState.validate()) {
          if (_data['name'] == '') {
            _showSnackbar("You need to fill group info to continue.", 4);
          } else {
            goTo(1);
          }
        } else {
          _showSnackbar("Fill in the required fields to continue.", 4);
        }
      } else {
        goTo(currentStep + 1);
      }
    } else {
      // print(_data);
      setState(() {
        _saving = true;
      });
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
            // ignore: deprecated_member_use
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

  String validateGroupInfo(String field, String value) {
    if (field == 'name') {
      if (value.isEmpty)
        return "Group name is required";
      else if (value.length < 3)
        return "Group name is way too short";
      else {
        _data['name'] = value;
        return null;
      }
    } else {
      return null;
    }
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

    steps = [
      Step(
        title: formatStep(0, "Group Info"),
        isActive: currentStep >= 0 ? true : false,
        state: currentStep > 0 ? StepState.complete : StepState.disabled,
        content: Form(
          key: _stepOneFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              subtitle1(
                text: "Tell us more about your group.",
                // ignore: deprecated_member_use
                color: Theme.of(context).textSelectionHandleColor,
                textAlign: TextAlign.start,
              ),
              subtitle2(
                text: "All fields are required",
                // ignore: deprecated_member_use
                color: Theme.of(context).textSelectionHandleColor,
                textAlign: TextAlign.start,
              ),
              TextFormField(
                validator: (val) => validateGroupInfo('name', val),
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'The name of this group',
                  // contentPadding: EdgeInsets.only(bottom: 0.0),
                ),
              ),
              TextFormField(
                validator: (val) => validateGroupInfo('country', val),
                decoration: InputDecoration(
                  labelText: 'Country',
                  hintText: 'The country of operation for this group',
                  // contentPadding: EdgeInsets.only(bottom: 0.0),
                ),
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
          children: <Widget>[],
        ),
      ),
      Step(
        title: formatStep(2, "Contributions"),
        isActive: currentStep >= 2 ? true : false,
        state: currentStep > 2 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[],
        ),
      ),
      Step(
        title: formatStep(3, "Loans"),
        isActive: currentStep >= 3 ? true : false,
        state: currentStep > 3 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[],
        ),
      ),
      Step(
        title: formatStep(4, "Accounts"),
        isActive: currentStep >= 4 ? true : false,
        state: currentStep > 4 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[],
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
            children: <Widget>[],
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
        title: "New Group",
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
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor,
                        size: 24.0,
                        semanticLabel: 'About new group...',
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
                              // ignore: deprecated_member_use
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
                          // ignore: deprecated_member_use
                          RaisedButton(
                            color: primaryColor,
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
                                        fontWeight: FontWeight.w700),
                                  ),
                                  (_saving)
                                      ? SizedBox(width: 10.0)
                                      : SizedBox(),
                                  (_saving)
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
                            textColor: Colors.white,
                            onPressed: (!_saving) ? onStepContinue : null,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          currentStep > 0
                              // ignore: deprecated_member_use
                              ? OutlineButton(
                                  color: Colors.white,
                                  child: Text(
                                    "Go Back",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                    ),
                                  ),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionHandleColor
                                        .withOpacity(0.5),
                                  ),
                                  highlightColor: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor
                                      .withOpacity(0.1),
                                  highlightedBorderColor: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor
                                      .withOpacity(0.6),
                                  onPressed: (!_saving) ? onStepCancel : null,
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
