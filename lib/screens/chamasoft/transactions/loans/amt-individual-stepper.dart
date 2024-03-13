import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/database-helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class StepperPage extends StatefulWidget {
  final String selectedOption;

  const StepperPage({Key key, @required this.selectedOption}) : super(key: key);

  @override
  _StepperPageState createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  List<String> titles = [];
  List<List<TextEditingController>> controllersList = [];
  int currentStep = 0; // Track the current step

  double _appBarElevation = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.pop(context),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "AMT Individual groups loan application",
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          color: (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Colors.white,
          height: MediaQuery.of(context).size.height * 0.9,
          child: titles.isEmpty
              ? Center(child: CircularProgressIndicator())
              : buildStepper(),
        ),
      ),
    );
  }

  // Your _data map
  Map<String, dynamic> _data = {
    'name': "",
    'location': "",
    'id': "",
    'houseNumber': "",
    'amount': "",
    'value': "",
  };

  Future<List<String>> fetchFields(String selectedOption) async {
    // Simulate API call or fetch data based on selectedOption
    // Return a list of titles
    await Future.delayed(Duration(seconds: 1)); // Simulating API delay
    if (widget.selectedOption == '1') {
      return [
        'Plot Location',
        'Loan amount applied for',
        'Number of rooms',
        //'Place of residence'
      ];
    } else {
      return [
        'Applicant details',
        'Why do you want a loan?',
        'Your borrowing record',
        'Your present economic activity/project',
        'Other sources of income'
      ];
    }
  }

  void updateData(int stepIndex, int fieldIndex, String value) {
    // Update _data based on stepIndex and fieldIndex
    // You need to implement your logic here
    // For simplicity, we'll update a sample field
    String fieldName = '';
    if (stepIndex == 0) {
      switch (fieldIndex) {
        case 0:
          fieldName = 'name';
          break;
        case 1:
          fieldName = 'location';
          break;
      }
    } else if (stepIndex == 1) {
      switch (fieldIndex) {
        case 0:
          fieldName = 'id';
          break;
        case 1:
          fieldName = 'houseNumber';
          break;
        case 2:
          fieldName = 'amount';
          break;
      }
    } else if (stepIndex == 2) {
      switch (fieldIndex) {
        case 0:
          fieldName = 'value';
          break;
        // Add other cases as needed
      }
    }
    if (fieldName.isNotEmpty) {
      setState(() {
        _data[fieldName] = value;
      });
    }
  }

  void saveData() async {
    // Implement your save data logic here
    print('my save data logic here');
    print(_data); // For debugging purposes

    // Add your database saving logic here
    await insertToLocalDb(DatabaseHelper.loansTable, {
      "name": _data['name'],
      "location": _data['location'],
      "id": _data['id'],
      "houseNumber": _data['houseNumber'],
      "amount": _data['amount'],
      "value": _data['value'],
      // Assuming 'members' and 'collections' are JSON strings in your database

      // Add other fields as needed
    });

    // After saving, you can navigate to the next screen or perform any other actions
    Navigator.of(context).pop(); // Example: Go back to the previous screen
  }

  Widget buildStepper() {
    return Stepper(
      physics: ClampingScrollPhysics(),
      steps: _buildSteps(),
      currentStep: currentStep,
      onStepContinue: () {
        setState(() {
          // Move to the next step if available
          if (currentStep < titles.length - 1) {
            currentStep += 1;
          }
        });
      },
      onStepCancel: () {
        setState(() {
          // Move to the previous step if available
          if (currentStep > 0) {
            currentStep -= 1;
          }
        });
      },
    );
  }

  int _getFieldCount(int stepIndex) {
    // Return the number of fields for a given step index
    // Update this method to return the correct number of fields for each step
    if (stepIndex == 0) {
      return 2;
    } else if (stepIndex == 1) {
      return 3;
    } else if (stepIndex == 2) {
      return 1; // Update to match the number of fields for step 2
    } else {
      return 1; // Last step has one field
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFields(widget.selectedOption).then((fields) {
      setState(() {
        titles = fields;
        controllersList = List.generate(
          titles.length,
          (index) => List.generate(
            _getFieldCount(
                index), // Use _getFieldCount to get the correct count
            (index) => TextEditingController(),
          ),
        );
      });
    });
  }

  List<Step> _buildSteps() {
    List<Step> steps = List.generate(titles.length, (index) {
      return Step(
        title: Text(titles[index]),
        content: Column(
          children: List.generate(
            _getFieldCount(index),
            (i) {
              // Get the corresponding field name from _data based on stepIndex and fieldIndex
              String fieldName = '';
              String labelText = '';
              if (index == 0) {
                switch (i) {
                  case 0:
                    fieldName = 'name';
                    labelText = 'Enter name';

                    break;
                  case 1:
                    fieldName = 'location';
                    labelText = 'Enter location';
                    break;
                  default:
                    fieldName = 'here';
                    labelText = 'Enter here';
                    break;
                }
              } else if (index == 1) {
                switch (i) {
                  case 0:
                    fieldName = 'id';
                    labelText = 'Enter id';
                    break;
                  case 1:
                    fieldName = 'houseNumber';
                    labelText = 'Enter house number';
                    break;
                  case 2:
                    fieldName = 'amount';
                    labelText = 'Enter amount';
                    break;
                  default:
                    fieldName = 'dog';
                    labelText = 'Enter value';
                    // Handle default case for step 1
                    break;
                }
              } else if (index == 2) {
                switch (i) {
                  case 0:
                    fieldName = 'value';
                    labelText = 'Enter value';
                    break;
                  default:
                    fieldName = 'cat';
                    labelText = 'Enter cat';
                    // Handle default case for step 2
                    break;
                }
              }

// Add default value if fieldName is still empty
              if (fieldName.isEmpty) {
                fieldName = 'default'; // Or any other default value you want
              }

              return TextFormField(
                controller: controllersList[index][i],
                decoration: InputDecoration(
                  labelText: labelText,
                  // _data[fieldName], // Use the field name from _data
                ),
                onChanged: (value) {
                  // Update _data when a field changes
                  updateData(index, i, value);
                },
              );
            },
          ),
        ),
        isActive: true,
      );
    });

    // Add the "Save and Continue" button at the correct index
    int lastStepIndex = titles.length - 1;
    steps.insert(
        lastStepIndex,
        Step(
          title: Text('Save and Continue'),
          content: ElevatedButton(
            onPressed: () {
              saveData();
            },
            child: Text('Save and Continue'),
          ),
          isActive: currentStep == lastStepIndex,
        ));

    return steps;
  }
}
