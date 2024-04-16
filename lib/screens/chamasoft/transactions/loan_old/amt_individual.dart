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
  List<Widget> memberFields = [];
  int currentStep = 0;

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
    'members': [], // List to store members' data
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
        'Members', // Add a field for adding members
      ];
    } else {
      return [
        'Applicant details',
        'Why do you want a loan?',
        'Your borrowing record',
        'Your present economic activity/project',
        'Other sources of income',
        'Members',
      ];
    }
  }

  void updateData(int stepIndex, int fieldIndex, String value) {
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
        case 3: // This case handles members' data
          fieldName = 'members';
          break;
      }
    } else if (stepIndex == 2) {
      switch (fieldIndex) {
        case 0:
          fieldName = 'value';
          break;
      }
    }
    if (fieldName.isNotEmpty) {
      setState(() {
        _data[fieldName] = value;
      });
    }
  }

  void saveData() async {
    print('Saving data to database:');
    print(_data);

    String membersJson = jsonEncode(_data['members']);

    _data['members'] = membersJson;

    await insertToLocalDb(DatabaseHelper.loansTable, _data);

    Navigator.of(context).pop();
  }

  void addMemberField() {
    setState(() {
      memberFields.add(TextFormField(
        decoration: InputDecoration(labelText: 'Enter member name'),
        onChanged: (value) {
          _data['members'].add(value);
        },
      ));
    });
  }

  Widget buildStepper() {
    return Stepper(
      physics: ClampingScrollPhysics(),
      steps: _buildSteps(),
      currentStep: currentStep,
      onStepContinue: () {
        setState(() {
          if (currentStep < titles.length) {
            currentStep += 1;
          } else {
            // Save data when reaching the last step (summary page)
            saveData();
          }
        });
      },
      onStepCancel: () {
        setState(() {
          if (currentStep > 0) {
            currentStep -= 1;
          }
        });
      },
    );
  }

  List<Step> _buildSteps() {
    List<Step> steps = List.generate(titles.length, (index) {
      return Step(
        title: Text(titles[index]),
        content: Column(
          children: List.generate(
            _getFieldCount(index),
            (i) {
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
                  case 3:
                    fieldName = 'members';
                    labelText = 'Enter members';
                    break;
                }
              } else if (index == 2) {
                switch (i) {
                  case 0:
                    fieldName = 'value';
                    labelText = 'Enter value';
                    break;
                }
              }

              return fieldName == 'members'
                  ? Column(
                      children: [
                        ...memberFields,
                        ElevatedButton(
                          onPressed: addMemberField,
                          child: Text('Add Member'),
                        ),
                      ],
                    )
                  : TextFormField(
                      controller: controllersList[index][i],
                      decoration: InputDecoration(
                        labelText: labelText,
                      ),
                      onChanged: (value) {
                        updateData(index, i, value);
                      },
                    );
            },
          ),
        ),
        isActive: true,
      );
    });

    // Add the summary step
    steps.add(
      Step(
        title: Text('Summary'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var entry in _data.entries)
              if (entry.key != 'members') Text('${entry.key}: ${entry.value}'),
            if (_data.containsKey('members'))
              ..._data['members']
                  .map((member) => Text('Member: $member'))
                  .toList(),
          ],
        ),
        isActive: currentStep == titles.length,
      ),
    );

    return steps;
  }

  int _getFieldCount(int stepIndex) {
    if (stepIndex == 0) {
      return 2;
    } else if (stepIndex == 1) {
      return 4; // Increased for the members field
    } else if (stepIndex == 2) {
      return 1;
    } else {
      return 1;
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
            _getFieldCount(index),
            (index) => TextEditingController(),
          ),
        );
      });
    });
  }
}
//   List<Step> _buildSteps() {
//     List<Step> steps = [];
//     List<Widget> primaryStepContent = [];
//     TextEditingController amountController = TextEditingController();
//     TextEditingController repaymentController = TextEditingController();

//     primaryStepContent.add(TextFormField(
//       controller: amountController,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(labelText: 'Amount'),
//       onChanged: (value) {},
//     ));
//     primaryStepContent.add(TextFormField(
//       controller: repaymentController,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(labelText: 'Loan Repayment Period'),
//       onChanged: (value) {},
//     ));
//     steps.add(
//       Step(
//         title: Text('Primary Details'),
//         content: Column(
//           children: primaryStepContent,
//         ),
//         isActive: currentStep == 0,
//       ),
//     );
//     // List<Step> steps =
//     List.generate(titles.length, (index) {
//       print(">>>>>> titles >>>>>>>");
//       print(titles);
//       print(">>>>> end of titles >>>>>>>");
//       String section = titles[index]["value"];

//       List<Map<String, dynamic>> questions =
//           sectionQuestionsMap[section] ?? []; // Use an empty list if null

//       print(">>>>>> section question maps >>>>>>>");
//       print(sectionQuestionsMap);
//       print(">>>>> end of section question maps >>>>>>>");

//       List<Widget> stepContent = [];
//       print(">>>>>>> dynamic fields");
//       print(dynamicFields);
//       print(">>>>>>> end of dynamic fields");
//       for (var question in questions) {
//         String labelText = question['question'];
//         Map<String, dynamic> field = dynamicFields
//             .firstWhere((element) => element['field'] == question['slug']);
//         print("the field is $field");
//         stepContent.add(TextFormField(
//           controller: controllersList[index][stepContent.length] ?? 0,
//           decoration: InputDecoration(
//             labelText: labelText,
//           ),
//           onChanged: (value) {
//             // print("the value is $value");
//             // Update data here if neededsetState(() {
//             field['value'] = value;

//             print("the new map is $dynamicFields");
//           },
//         ));
//       }
//       return Step(
//         title: Text(section),
//         content: Column(
//           children: stepContent,
//         ),
//         isActive: true,
//       );
//     });
//     steps.add(
//       Step(
//         title: Text('Summary'),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   // Print the values of all dynamic fields
//                   for (var field in dynamicFields) {
//                     print('${field['field']}: ${field['value']}');
//                   }
//                 },
//                 child: Text('Save data'))
//           ],
//         ),
//         isActive: currentStep == titles.length,
//       ),
//     );

//     return steps;
//   }
// }