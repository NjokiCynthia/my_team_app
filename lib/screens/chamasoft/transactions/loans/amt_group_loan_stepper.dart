import 'dart:convert';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/group-loan-applications.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:platform_file/platform_file.dart';
import 'package:provider/provider.dart';

class AmtStepper extends StatefulWidget {
  const AmtStepper({Key key, this.selectedLoanProduct}) : super(key: key);

  final Map<String, dynamic> selectedLoanProduct;

  @override
  _AmtStepperState createState() => _AmtStepperState();
}

class _AmtStepperState extends State<AmtStepper> {
  List<Map<String, dynamic>> customAdditionalFields = [];
  List<Map<String, dynamic>> additionalDocumentFields = [];
  List<Step> steps = [];
  List<Map<String, dynamic>> _data = [];

  PlatformFile selectedProofOfPayment;

  Auth _user;
  Group _group;
  String loanAmount;

  void submitGroupLoanApplication(BuildContext context) async {
    Map<String, dynamic> formData = {
      "user_id": _user.id,
      "group_id": _group.groupId,
      "member_id": _group.memberId,
      "loan_product_id": "2441",
      "loan_amount": loanAmount.toString(),
      "name": widget.selectedLoanProduct['name'],
      "minAmount": widget.selectedLoanProduct['minAmount'],
      "maxAmount": widget.selectedLoanProduct['maxAmount'],
      "times": '',
      //'4000',
      "repayment_period": 2,
      "enabled": 0,
      "interestType": widget.selectedLoanProduct['interestType'],
      "interestRate": widget.selectedLoanProduct['interestRate'],
      "interestCharge": widget.selectedLoanProduct['interestCharge'],
      "repaymentPeriodType": widget.selectedLoanProduct['repaymentPeriodType'],
      "repaymentPeriod": widget.selectedLoanProduct['repaymentPeriod'],
      "maxRepaymentPeriod": "",
      "minRepaymentPeriod": "",
      "enableFinesForLateInstallments": "1",
      "lateLoanPaymentFineType": "1",
      "oneOffPercentageOn": "",
      "percentageFineRate": "",
      "fineFrequency": "",
      "outstandingBalOneOffAmount": "",
      "outstandingBalFixedFineAmount": "",
      "outstandingBalFineFrequency": "",
      "outstandingBalPercentageFineRate": "",
      "outstandingBalFineChargeFactor": "",
      "fineChargeFactor": "",
      "enableGuarantors": "0",
      "enableLoanProfitFee": "",
      "loanProfitFeeType": "",
      "percentageLoanProfitFee": "",
      "eventToEnableGuarantors": "1",
      "minGuarantors": "3",
      "loanProcessingFeeType": "",
      "loanProcessingFeeAmount": "",
      "loanProcessingFeePercentage": "",
      "loanProcessingFeePercentageFactor": "",
      "fixedLoanProfitFeeAmount": "",
      "oneOffFineType": "",
      "oneOffFixedAmount": "",
      "enableFinesForOutstandingBalances": "",
      "outstandingBalanceFineType": "",
      "enableLoanProcessingFee": "0",
      "disableAutomatedLoanProcessingIncome": "",
      "requireOfficialsApproval": "1",
      "requirePurposeOfLoan": "",
      "loanProductNature": "1",
      "loanProductMode": "1",
      "gracePeriod": "1",
      "groupId": "",
      "guarantors": ["59070", "59072"],
      "amounts": ["3000", "4310"],
      "type": "2",
      "comments": ["test", "test"],
      "metadata": _data,
    };
    print(_data);
    print('form data is: $formData');
    // Show the loader
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });

    try {
      String response = await Provider.of<Groups>(context, listen: false)
          .submitAMTLoanApplication(formData);

      StatusHandler().showSuccessSnackBar(context, "Good news: $response");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GroupLoanApplications()),
      );
    } on CustomException catch (error) {
      StatusHandler().showDialogWithAction(
          context: context, message: error.toString(), dismissible: true);
    } finally {}
  }

  @override
  void initState() {
    super.initState();
    _user = Provider.of<Auth>(context, listen: false);
    _group = Provider.of<Groups>(context, listen: false).getCurrentGroup();
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

    List<Widget> firstStepContent = [];
    firstStepContent.add(TextFormField(
      decoration:
          InputDecoration(labelText: "Enter the amount you are applying for"),
      onChanged: (value) {
        setState(() {
          loanAmount = value;
        });
      },
    ));

    // Insert the loan amount field in the first step
    steps.add(
      Step(
        title: Text('Enter Loan Amount'),
        content: Column(
          children: firstStepContent,
        ),
        isActive: true,
      ),
    );

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
              //_data[field['slug']] = value;
              _data.clear();
              _data.add({
                field['question']: value,
                "slug": field['slug'],
                "section": field['section']
              });
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
          isActive: true,
        ),
      );
    });

    // Handle additional document fields if any
    void _handleFileUpload(String fieldSlug) {
      print('Uploading file for field: $fieldSlug');
    }

    if (additionalDocumentFields.isNotEmpty) {
      List<Widget> uploadFields = [];
      for (var docField in additionalDocumentFields) {
        uploadFields.add(ElevatedButton(
          onPressed: () {
            _handleFileUpload(docField['slug']);
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
                submitGroupLoanApplication(context);
                // saveData();
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

  void saveData() {
    // Implement your save data logic here
    print('I WANT TO SEE TEH DATA:');
    print(_data);
    // Reset form data if needed
    _data.clear();
  }
}
