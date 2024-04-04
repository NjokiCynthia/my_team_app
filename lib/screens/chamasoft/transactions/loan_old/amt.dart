import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/database-helper.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/widgets/buttons.dart';

import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class ApplyLoanFromAmt extends StatefulWidget {
  Map<String, dynamic> formLoadData;
  List<LoanProduct> loanProducts;
  ApplyLoanFromAmt({this.formLoadData, this.loanProducts});

  @override
  _ApplyLoanFromAmtState createState() => _ApplyLoanFromAmtState();
}

class _ApplyLoanFromAmtState extends State<ApplyLoanFromAmt> {
  int currentStep = 0;
  bool complete = false;
  List<Step> steps = [];
  final _stepOneFormKey = GlobalKey<FormState>();
  final _stepTwoFormKey = GlobalKey<FormState>();
  final _stepThreeFormKey = GlobalKey<FormState>();
  final _stepFourFormKey = GlobalKey<FormState>();
  final _stepFiveFormKey = GlobalKey<FormState>();
  final _stepSixFormKey = GlobalKey<FormState>();
  final _stepSevenFormKey = GlobalKey<FormState>();

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

  ScrollController _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double _appBarElevation = 0;
  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
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

  String _groupCurrency = "Ksh";
  bool _saving = false;

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
                color: Theme.of(context)
                    .textSelectionTheme
                    .selectionHandleColor
                    .withOpacity(0.7),
                text: "No agenda added",
                textAlign: TextAlign.left,
              ),
              subtitle2(
                color: Theme.of(context)
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
                color: Theme.of(context)
                    .textSelectionTheme
                    .selectionHandleColor
                    .withOpacity(0.7),
                text: "No AOB added",
                textAlign: TextAlign.left,
              ),
              subtitle2(
                color: Theme.of(context)
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

  Map<String, dynamic> _data = {
    'name': "",
    'registrationCode': "",
    'registrationdate': "",
    'loanAccountNo': "",
    'applicationDate': "",
    'telephone': "",
    'email': "",
    'contactPerson': "",
    'contactPersonPosition': "",
    'contactPersonTelephone': "",
    'contactPersonEmail': "",
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
  String validateInfo(String field, String value) {
    if (field == 'name') {
      if (value.isEmpty)
        return "Name is required";
      else if (value.length < 6)
        return "Name is way too short";
      else {
        _data['title'] = value;
        return null;
      }
    }
    if (field == 'registrationCode') {
      if (value.isEmpty)
        return "Registration code is required";
      else {
        _data['title'] = value;
        return null;
      }
    }
    if (field == 'registrationdate') {
      if (value.isEmpty)
        return "Registration date is required";
      else {
        _data['title'] = value;
        return null;
      }
    }
    if (field == 'loanAccountNo') {
      if (value.isEmpty)
        return "Loan Account number is required";
      else {
        _data['title'] = value;
        return null;
      }
    }
    if (field == 'applicationDate') {
      if (value.isEmpty)
        return "Application date is required";
      else {
        _data['title'] = value;
        return null;
      }
    }
    if (field == 'telephone') {
      if (value.isEmpty)
        return "Telephone is required";
      else {
        _data['title'] = value;
        return null;
      }
    }
    if (field == 'email') {
      if (value.isEmpty)
        return "Email is required";
      else {
        _data['title'] = value;
        return null;
      }
    }
    if (field == 'contactPerson') {
      if (value.isEmpty)
        return "Contact person is required";
      else {
        _data['title'] = value;
        return null;
      }
    }
    if (field == 'contactPersonPosition') {
      if (value.isEmpty)
        return "Contact Person Position is required";
      else {
        _data['title'] = value;
        return null;
      }
    } else if (field == 'contactPersonTelephone') {
      if (value.isEmpty)
        return "Contact Person Telephone is required";
      else {
        _data['venue'] = value;
        return null;
      }
    } else if (field == 'contactPersonEmail') {
      _data['details'] = value;
      return null;
    } else {
      return null;
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
        if (_stepOneFormKey.currentState.validate()) {
          if (_data['date'] == '') {
            _showSnackbar(
                "You need to select the registration date to continue.", 4);
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
      saveDetails();
      setState(() => complete = true);
    }
  }

  saveDetails() async {
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

  @override
  Widget build(BuildContext context) {
    steps = [
      Step(
        title: formatStep(0, "Applicant Information"),
        isActive: currentStep >= 0 ? true : false,
        state: currentStep > 0 ? StepState.complete : StepState.disabled,
        content: Container(
          height: 300,
          child: ListView(scrollDirection: Axis.vertical, children: [
            Form(
              key: _stepOneFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val) => validateInfo('title', val),
                    decoration: InputDecoration(
                      labelText: 'Name of applicant',
                      hintText: "Enter applicant's name",
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('venue', val),
                    decoration: InputDecoration(
                      labelText: 'AMT membership registration code',
                      hintText: 'Membership registration code',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTime,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2030),
                    dateLabelText: 'Registration date at AMT',
                    onChanged: (val) => _data['date'] = val,
                    validator: (val) {
                      _data['date'] = val;
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Meeting Purpose (Optional)',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTime,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2030),
                    dateLabelText: 'Date of this applicaion',
                    onChanged: (val) => _data['date'] = val,
                    validator: (val) {
                      _data['date'] = val;
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Telephone',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Contact Person',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Position/job title of contact person',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Telephone of contact person',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Email of contact person',
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
        title: formatStep(1, "Program/Project Information"),
        isActive: currentStep >= 1 ? true : false,
        state: currentStep > 1 ? StepState.complete : StepState.disabled,
        content: Container(
          height: 300,
          child: ListView(scrollDirection: Axis.vertical, children: [
            Form(
              key: _stepTwoFormKey,
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
                  TextFormField(
                    validator: (val) => validateInfo('venue', val),
                    decoration: InputDecoration(
                      labelText: 'Location of project/program',
                      hintText: 'Program location',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Number of employees',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'What problems will your program address',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'How many people are yu benefiting',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Frequency of general meetings',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Who are your partners',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'List your sources of income',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Monthly income from operations',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Other income(specify)',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Monthly direct program expenditure',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText:
                          'Monthly administration/operations expenditure',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
      Step(
        title: formatStep(2, "Financial and Borrowing Information"),
        isActive: currentStep >= 2 ? true : false,
        state: currentStep > 2 ? StepState.complete : StepState.disabled,
        content: Container(
          height: 300,
          child: ListView(scrollDirection: Axis.vertical, children: [
            Form(
              key: _stepThreeFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val) => validateInfo('title', val),
                    decoration: InputDecoration(
                      labelText: 'What is your total budget for this project',
                      hintText: "Enter total budget",
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('venue', val),
                    decoration: InputDecoration(
                      labelText:
                          'How much money do you want to borrom from AMT?',
                      hintText: 'Amount to borrow',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'What will you do with this loan money?',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'How many people will this loan benefit?',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'How much cash collateral will you offer?',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'How much asset collateral will you offer?',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText:
                          'Where else will you obtain funding for this project?',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText:
                          'How much mony will you onbtain from these sources other than AMT?',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText:
                          'How many times have you borrowed form AMT in the past?',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText:
                          'How many times have you borrowed from other sources in the past? List three sources',
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
        title: formatStep(3, "Financial Products Portifolio Information"),
        isActive: currentStep >= 3 ? true : false,
        state: currentStep > 3 ? StepState.complete : StepState.disabled,
        content: Container(
          height: 300,
          child: ListView(scrollDirection: Axis.vertical, children: [
            Form(
              key: _stepFourFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val) => validateInfo('title', val),
                    decoration: InputDecoration(
                      labelText: 'Number fo savings accounts',
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('venue', val),
                    decoration: InputDecoration(
                      labelText: 'Number fo savings deposits accounts',

                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Value of shares account',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Face/per value of one share',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText:
                          'Number of insurance/contingency/welfare/social fund accounts',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Value of welfare/insurance fund account',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Value of administration fund account',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Value of collective investments at AMT',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Number of oustanding loan accounts',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Value of outstanding loans accounts',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Annual service charge/interest rate on loans',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Cumulative number of loans disbursed to date',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Cumulative value of loans disbursed to date',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Number of loans in arrears',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Value of laons in arrears',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Arrears amount',
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
        title: formatStep(4, "Proposed Terms and Condition in this Loan"),
        isActive: currentStep >= 4 ? true : false,
        state: currentStep > 4 ? StepState.complete : StepState.disabled,
        content: Container(
          height: 300,
          child: ListView(scrollDirection: Axis.vertical, children: [
            Form(
              key: _stepFiveFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val) => validateInfo('title', val),
                    decoration: InputDecoration(
                      labelText: 'Proposed loan term (months)',
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('venue', val),
                    decoration: InputDecoration(
                      labelText:
                          'Attached: Resolution/minutes of meeting authorizating this application',

                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Attached: Constitution/Memo-Arts',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Attached: Certificate of registration',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Attached: Current approved business plan',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText:
                          'Attached:Bank statements - for past six months',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Attached: Financial statements/records',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Property title/document of ownership',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                  TextFormField(
                    validator: (val) => validateInfo('purpose', val),
                    decoration: InputDecoration(
                      labelText: 'Other attcahments(specify)',
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
        title: formatStep(5,
            "References: List your references(Must not be members of group/organization)"),
        isActive: currentStep >= 5 ? true : false,
        state: currentStep > 5 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[
            Form(
              key: _stepSixFormKey,
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
                        if (_stepSixFormKey.currentState.validate()) {
                          _stepSixFormKey.currentState.reset();
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
        title: formatStep(6, "Commitment by Applicant:"),
        isActive: currentStep >= 6 ? true : false,
        state: currentStep > 6 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[
            Form(
              key: _stepSevenFormKey,
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
                        if (_stepSevenFormKey.currentState.validate()) {
                          _stepSevenFormKey.currentState.reset();
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
    ];
    return SingleChildScrollView(
      child: Container(
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
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: SingleChildScrollView(
                    controller: _scrollController,
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
                                              currentStep == 6
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
      ),
    );
  }
}
