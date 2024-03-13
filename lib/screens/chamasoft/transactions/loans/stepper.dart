import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/database-helper.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';

import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan-from-chamasoft-form.dart';

import 'package:chamasoft/widgets/backgrounds.dart';

import 'package:chamasoft/widgets/empty_screens.dart';

import 'package:chamasoft/widgets/textstyles.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ApplyIndividualAmtLoan extends StatefulWidget {
  Map<String, dynamic> formLoadData;
  List<LoanProduct> loanProducts;
  ApplyIndividualAmtLoan({this.formLoadData, this.loanProducts});

  @override
  _ApplyIndividualAmtLoanState createState() => _ApplyIndividualAmtLoanState();
}

class _ApplyIndividualAmtLoanState extends State<ApplyIndividualAmtLoan> {
  double _appBarElevation = 0;
  ScrollController _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //  List<MembersFilterEntry> selectedMembersList = [];

  int currentStep = 0;
  bool complete = false;
  List<Step> steps = [];
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _step3FormKey = GlobalKey<FormState>();
  final _step4FormKey = GlobalKey<FormState>();
  final _step5FormKey = GlobalKey<FormState>();
  final _step6FormKey = GlobalKey<FormState>();

  Map<String, dynamic> _data = {
    'location': "",
    'plotNo': "",
    'amount': "",
    'residence': "",
    'rooms': "",
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

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  String validateInfo(String field, String value) {
    if (field == 'name') {
      if (value.isEmpty)
        return "Name is required";
      else if (value.length < 6)
        return "Name is way too short";
      else {
        _data['name'] = value;
        return null;
      }
    }
    if (field == 'location') {
      if (value.isEmpty)
        return "Location is required";
      else {
        _data['location'] = value;
        return null;
      }
    }
    if (field == 'plotNo') {
      if (value.isEmpty)
        return "Plot number is required";
      else {
        _data['plotNo'] = value;
        return null;
      }
    }
    if (field == 'amount') {
      if (value.isEmpty)
        return "Amount is required";
      else {
        _data['amount'] = value;
        return null;
      }
    }
    if (field == 'idNo') {
      if (value.isEmpty)
        return "ID number is required";
      else {
        _data['idNo'] = value;
        return null;
      }
    }
    if (field == 'residence') {
      if (value.isEmpty)
        return "Residence is required";
      else {
        _data['residence'] = value;
        return null;
      }
    }
    if (field == 'rooms') {
      if (value.isEmpty)
        return "Room is required";
      else {
        _data['rooms'] = value;
        return null;
      }
    }
    if (field == 'telephone') {
      if (value.isEmpty)
        return "Telephone number is required";
      else {
        _data['telephone'] = value;
        return null;
      }
    }
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
        if (_step1FormKey.currentState.validate()) {
          if (_data['location'] == '') {
            _showSnackbar(
                "You need to enter the location of applicant to continue.", 4);
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

  @override
  Widget build(BuildContext context) {
    steps = [
      Step(
        title: formatStep(0, "Applicant Information"),
        isActive: currentStep >= 0 ? true : false,
        state: currentStep > 0 ? StepState.complete : StepState.disabled,
        content: Container(
          height: 200,
          child: ListView(scrollDirection: Axis.vertical, children: [
            Form(
              key: _step1FormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val) => validateInfo('location', val),
                    decoration: InputDecoration(
                      labelText: 'Location of the plots',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('plotNo', val),
                    decoration: InputDecoration(
                      labelText: 'Plot number',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('amount', val),
                    decoration: InputDecoration(
                      labelText: 'Amount of loan applied for',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('residence', val),
                    decoration: InputDecoration(
                      labelText: 'Place of residence',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('rooms', val),
                    decoration: InputDecoration(
                      labelText: 'Number of rooms',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      Step(
        title: formatStep(1, "Why do you want a loan?"),
        isActive: currentStep >= 1 ? true : false,
        state: currentStep > 1 ? StepState.complete : StepState.disabled,
        content: Container(
          height: 300,
          child: ListView(scrollDirection: Axis.vertical, children: [
            Form(
              key: _step2FormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val) => validateInfo('title', val),
                    decoration: InputDecoration(
                      labelText: 'Describe your program/project activities',
                      hintText: "Enter program activities",
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      Step(
        title: formatStep(2, "Your borrowing record"),
        isActive: currentStep >= 2 ? true : false,
        state: currentStep > 2 ? StepState.complete : StepState.disabled,
        content: Container(
          height: 300,
          child: ListView(scrollDirection: Axis.vertical, children: [
            Form(
              key: _step3FormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val) => validateInfo('title', val),
                    decoration: InputDecoration(
                      labelText: 'Describe your program/project activities',
                      hintText: "Enter program activities",
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      Step(
        title: formatStep(3, "Your present economic activity/project"),
        isActive: currentStep >= 3 ? true : false,
        state: currentStep > 3 ? StepState.complete : StepState.disabled,
        content: Container(
          height: 300,
          child: ListView(scrollDirection: Axis.vertical, children: [
            Form(
              key: _step4FormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val) => validateInfo('title', val),
                    decoration: InputDecoration(
                      labelText: 'Describe your program/project activities',
                      hintText: "Enter program activities",
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      Step(
        title: formatStep(4, "Other sources of income"),
        isActive: currentStep >= 4 ? true : false,
        state: currentStep > 4 ? StepState.complete : StepState.disabled,
        content: Container(
          height: 300,
          child: ListView(scrollDirection: Axis.vertical, children: [
            Form(
              key: _step5FormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val) => validateInfo('title', val),
                    decoration: InputDecoration(
                      labelText: 'Describe your program/project activities',
                      hintText: "Enter program activities",
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    ];
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          toolTip(
            context: context,
            title: "Note that...",
            message:
                "Apply quick loan from Amt guaranteed by your savings and fellow group members.",
          ),
          Builder(
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Stepper(
                          physics: ClampingScrollPhysics(),
                          steps: steps,
                          currentStep: currentStep,
                          onStepContinue: next,
                          onStepTapped: (step) => goTo(step),
                          onStepCancel: cancel,
                          controlsBuilder: (BuildContext context,
                              ControlsDetails controlDetails) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: 12.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 0.0, 20.0, 0.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            currentStep == 4
                                                ? "Confirm & Submit"
                                                : "Save & Continue",
                                            style: TextStyle(
                                              fontFamily: 'SegoeUI',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          _saving
                                              ? SizedBox(width: 10.0)
                                              : SizedBox(),
                                          _saving
                                              ? SizedBox(
                                                  height: 16.0,
                                                  width: 16.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.grey[700],
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                    onPressed: !_saving
                                        ? controlDetails.onStepContinue
                                        : null,
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  currentStep > 0
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
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
