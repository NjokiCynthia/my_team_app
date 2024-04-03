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
      "name": "Tester",
      "minAmount": "40",
      "maxAmount": "1000067",
      "times": '',
      //'4000',
      "repayment_period": 2,
      "enabled": 0,
      "interestType": "1",
      "interestRate": "1",
      "interestCharge": "3",
      "repaymentPeriodType": "1",
      "repaymentPeriod": "5",
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
      //  [
      //   {
      //     "what is the reason for applying  this_loan": "Car Purchase",
      //     "slug": "what_is_the_reason_for_applying_this_loan",
      //     "section": "Financial"
      //   },
      //   {
      //     "How Much do you make": "20000",
      //     "slug": "how_much_do_you_make",
      //     "section": "value c"
      //   }
      // ]
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
    // Extract custom additional fields and additional document fields from the selected loan product
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
      stepContent.add(TextFormField(
        decoration: InputDecoration(labelText: "Enter Loan Amount"),
        onChanged: (value) {
          setState(() {
            loanAmount = value;
          });
        },
      ));
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
          isActive: true, // Set active for all steps initially
        ),
      );
    });
    void _handleFileUpload(String fieldSlug) {

      print('Uploading file for field: $fieldSlug');
    }
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
