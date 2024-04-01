import 'dart:convert';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:platform_file/platform_file.dart';

class IndividualStepper extends StatefulWidget {
  const IndividualStepper({Key key, this.selectedLoanProduct})
      : super(key: key);

  final Map<String, dynamic> selectedLoanProduct;

  @override
  _IndividualStepperState createState() => _IndividualStepperState();
}

class _IndividualStepperState extends State<IndividualStepper> {
  List<Map<String, dynamic>> customAdditionalFields = [];
  List<Map<String, dynamic>> additionalDocumentFields = [];
  List<Step> steps = [];
  Map<String, dynamic> _data = {};

  PlatformFile selectedProofOfPayment;

  @override
  void initState() {
    super.initState();
    // Extract custom additional fields and additional document fields from the selected loan product
    if (widget.selectedLoanProduct != null) {
      customAdditionalFields = List<Map<String, dynamic>>.from(
          widget.selectedLoanProduct['customAdditionalInputFields']);
      additionalDocumentFields = List<Map<String, dynamic>>.from(
          widget.selectedLoanProduct['additionalDocumentFields']);
    }

    _buildSteps();
  }

  void _buildSteps() {
    steps = [];

    Map<String, List<Map<String, dynamic>>> groupedFields = {};

    // Group fields by their section names
    for (var field in customAdditionalFields) {
      String sectionName = field['section'];
      if (!groupedFields.containsKey(sectionName)) {
        groupedFields[sectionName] = [];
      }
      groupedFields[sectionName].add(field);
    }

    // Create steps for each grouped section
    groupedFields.forEach((sectionName, fields) {
      List<Widget> stepContent = [];
      for (var field in fields) {
        stepContent.add(TextFormField(
          decoration: InputDecoration(labelText: field['question']),
          onChanged: (value) {
            setState(() {
              _data[field['slug']] = value;
            });
          },
        ));
      }

      steps.add(
        Step(
          title: Text(sectionName),
          content: Column(
            children: stepContent,
          ),
          isActive: true, // Set active for all steps initially
        ),
      );
    });
    void _handleFileUpload(String fieldSlug) {
      // Implement file upload logic for the given fieldSlug
      // This function will be called when a file upload button is pressed

      // For demonstration purposes, we will print a message
      print('Uploading file for field: $fieldSlug');

      // You can add your file upload logic here, such as opening a file picker dialog, uploading the file to a server, etc.
    }

    // Create step for additional document fields if they exist
    // Create step for additional document fields if they exist
    if (additionalDocumentFields.isNotEmpty) {
      List<Widget> uploadFields = [];
      for (var docField in additionalDocumentFields) {
        uploadFields.add(ElevatedButton(
          onPressed: () {
            _handleFileUpload(
                docField['slug']); // Pass the field slug for identification
          },
          child: Text('Upload ${docField['title']}'),
        ));
      }
      steps.add(
        Step(
          title: Text('Upload Documents'),
          content: Column(
            children: uploadFields,
          ),
          isActive: true, // Set active for all steps initially
        ),
      );
    }
  }

  int currentStep = 0;
  double _appBarElevation = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.pop(context),
        // Navigator.of(context)
        //     .popUntil((Route<dynamic> route) => route.isFirst),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Apply Loan",
      ),
      body: SingleChildScrollView(
        child: Stepper(
          steps: steps,
          currentStep: currentStep,
          onStepContinue: () {
            setState(() {
              if (currentStep < steps.length - 1) {
                currentStep += 1; // Move to the next step
              } else {
                // Handle last step or completion logic
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currentStep > 0) {
                currentStep -= 1; // Move to the previous step
              }
            });
          },
        ),
      ),
    );
  }
}
