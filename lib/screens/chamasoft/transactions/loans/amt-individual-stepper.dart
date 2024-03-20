import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
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
  List<Map<String, String>> titles = [];
  List<List<TextEditingController>> controllersList = [];
  int currentStep = 0;

  Map<String, List<Map<String, dynamic>>> sectionQuestionsMap = {};
  Map<String, dynamic> _data = {}; // Data storage for form fields
  bool hasDocumentFields = false;

  @override
  void initState() {
    super.initState();
    dynamic jsonData = {
      "result_code": 1,
      "entities": [
        {
          "id": 1,
          "enabled": 0,
          "name": "Tester",
          "type": "1",
          "minAmount": "4000",
          "maxAmount": "10000",
          "times": null,
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
          "enableGuarantors": "1",
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
          "is_migrated": false,
          "chama_loan_type_id": "",
          "institutionId": "653765c21bc18d64a8846b8f",
          "referralCode": "CWA1153",
          "customAdditionalInputFields": [
            {
              "id": 1,
              "question": "What is the reason for applying this loan",
              "slug": "what_is_the_reason_for_applying_this_loan",
              "type": "Text",
              "options": null,
              "section": "Financial"
            },
            {
              "id": 2,
              "question": "How Much do you get in full",
              "slug": "how_much_do_you_get_in_full",
              "type": "Number",
              "options": null,
              "section": "Financial"
            },
            {
              "id": 3,
              "question": "How Much do you make ",
              "slug": "how_much_do_you_make",
              "type": "Number",
              "options": null,
              "section": "COORPORATE"
            },
            {
              "id": 4,
              "question": "How Much do yOU EARN HERE ",
              "slug": "how_much_do_you_EARN_HERE",
              "type": "Number",
              "options": null,
              "section": "COORPORATE"
            }
          ],
          "additionalDocumentFields": [
            {
              "title": "Colored Passport Picture (Both side)",
              "slug": "passport_picture",
              "type": "1"
            },
            {"title": "Bank Statement", "slug": "bank_statement", "type": "1"},
            {
              "title": "Constitution / Memo-Arts",
              "slug": "constitution",
              "type": "1"
            },
            {"title": "ID Card", "slug": "id_card", "type": "1"},
            {
              "title": "Current Bank Statement",
              "slug": "current_bank_statement",
              "type": "1"
            }
          ],
          "active": 0,
          "_id": "65f8871abdfff13f0da60a8d",
          "modifiedBy": "65030cb0811ec23f2e32ee49",
          "createdAt": "2024-03-18T18:25:30.658Z",
          "updatedAt": "2024-03-18T18:25:30.658Z"
        }
      ],
      "totalCount": 1,
      "message": "Success"
    };
    parseJsonData(jsonData);
    fetchFields(widget.selectedOption).then((data) {
      setState(() {
        titles = data['titles'];
        controllersList = List.generate(
          titles.length,
          (index) => List.generate(
            sectionQuestionsMap[titles[index]['value']].length,
            (index) => TextEditingController(),
          ),
        );
        hasDocumentFields = checkDocumentFields(jsonData);
      });
    });
  }

  void parseJsonData(dynamic jsonData) {
    List<dynamic> entities = jsonData['entities'];
    for (var entity in entities) {
      List<Map<String, dynamic>> questions =
          entity['customAdditionalInputFields'];
      for (var question in questions) {
        String section = question['section'];
        if (!sectionQuestionsMap.containsKey(section)) {
          sectionQuestionsMap[section] = [];
        }
        sectionQuestionsMap[section].add(question);
      }
    }
  }

  Future<Map<String, List<Map<String, String>>>> fetchFields(
      String selectedOption) async {
    // Simulate API call or fetch data based on selectedOption
    // Return a list of titles
    List<Map<String, String>> titles = [];
    for (var section in sectionQuestionsMap.keys) {
      titles.add({"value": section});
    }
    return {"titles": titles};
  }

  bool checkDocumentFields(dynamic jsonData) {
    List<dynamic> entities = jsonData['entities'];
    for (var entity in entities) {
      if (entity.containsKey('additionalDocumentFields')) {
        return true;
      }
    }
    return false;
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stepper(
                physics: ClampingScrollPhysics(),
                steps: _buildSteps(),
                currentStep: currentStep,
                onStepContinue: () {
                  setState(() {
                    if (currentStep < titles.length) {
                      currentStep += 1;
                    } else {
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    List<Step> steps = [];

    for (int index = 0; index < titles.length; index++) {
      String section = titles[index]["value"];
      List<Map<String, dynamic>> questions = sectionQuestionsMap[section] ?? [];

      List<Widget> stepContent = [];

      for (var question in questions) {
        stepContent.add(TextFormField(
          controller: controllersList[index][stepContent.length],
          decoration: InputDecoration(
            labelText: question['question'],
          ),
          onChanged: (value) {
            setState(() {
              _data[question['slug']] = value; // Store form data
            });
          },
        ));
      }

      steps.add(
        Step(
          title: Text(section),
          content: Column(
            children: stepContent,
          ),
          isActive: currentStep == index,
        ),
      );
    }

    // Add a step for uploading documents only if additionalDocumentFields exist
    if (hasDocumentFields) {
      steps.add(
        Step(
          title: Text('Upload Documents'),
          content: Column(
            children: [
              Text(
                  'Upload your documents here'), // Add upload widgets here as needed
            ],
          ),
          isActive: currentStep == titles.length,
        ),
      );
    }

    return steps;
  }

  void saveData() {
    // Implement your save data logic here
    print('Saving data:');
    print(_data);
    // Reset form data if needed
    _data.clear();
    // Navigate to next screen or perform other actions
  }
}
