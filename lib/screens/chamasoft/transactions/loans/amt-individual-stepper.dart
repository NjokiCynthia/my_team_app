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
  List<Map<String, String>> titles = [];
  List<Map<String, String>> fields = [];
  List<List<TextEditingController>> controllersList = [];
  List<Widget> memberFields = [];

  int currentStep = 0;

  Map<String, List<Map<String, dynamic>>> sectionQuestionsMap = {};
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

  double _appBarElevation = 0;

  List<Map<String, dynamic>> dynamicFields = [];

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
    }; // Your JSON data here
    parseJsonData(jsonData);
    fetchFields(widget.selectedOption).then((data) {
      setState(() {
        titles = data['titles'];
        fields = data['fields'];
        dynamicFields = data['fields']
            .map((e) => e['slug'])
            .map((e) => {"field": e, "value": ""})
            .toList();
        controllersList = List.generate(
          titles.length,
          (index) {
            // Check if sectionQuestionsMap has data for the current title
            if (sectionQuestionsMap.containsKey(titles[index]['value'])) {
              return List.generate(
                sectionQuestionsMap[titles[index]['value']].length,
                (index) =>
                    TextEditingController(text: fields[index]['question']),
              );
            } else {
              // Handle case where sectionQuestionsMap does not contain data for the title
              return []; // or handle it as needed in your application
            }
          },
        );
      });
    });
  }

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

  Future<Map<String, List<Map<String, String>>>> fetchFields(
      String selectedOption) async {
    // Simulate API call or fetch data based on selectedOption
    // Return a list of titles

    List<Map<String, String>> fields = [];
    List<Map<String, String>> titles = [];
    print("<<<<<<<<<<<<<<<<");
    print(sectionQuestionsMap);
    print('end of the section question map');
    for (var section in sectionQuestionsMap.keys) {
      // Add section as stepper title
      titles.add({"value": section});
      List<Map<String, dynamic>> questions = sectionQuestionsMap[section];
      for (var question in questions) {
        fields.add({
          "slug": question['slug'],
          "title": question['question']
        }); // Add question as stepper field
      }
    }
    return {"fields": fields, "titles": titles};
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
    List<Step> steps = [];

    // Step 1: Primary Fields (Amount and Loan Repayment Period)
    List<Widget> primaryStepContent = [];
    TextEditingController amountController = TextEditingController();
    TextEditingController repaymentController = TextEditingController();

    primaryStepContent.add(TextFormField(
      controller: amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Amount'),
      onChanged: (value) {},
    ));

    primaryStepContent.add(TextFormField(
      controller: repaymentController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Loan Repayment Period'),
      onChanged: (value) {},
    ));

    steps.add(
      Step(
        title: Text('Primary Details'),
        content: Column(
          children: primaryStepContent,
        ),
        isActive: currentStep == 0,
      ),
    );

    // Step 2 and beyond: Additional Sections
    for (int index = 0; index < titles.length; index++) {
      String section = titles[index]["value"];
      List<Map<String, dynamic>> questions =
          sectionQuestionsMap[section] ?? []; // Use an empty list if null

      List<Widget> stepContent = [];

      for (var question in questions) {
        String labelText = question['question'];
        Map<String, dynamic> field = dynamicFields.firstWhere(
            (element) => element['field'] == question['slug'],
            orElse: () => null); // Handle null if field not found
        stepContent.add(TextFormField(
          controller: controllersList[index][stepContent.length] ?? 0,
          // controller:
          //     TextEditingController(text: field != null ? field['value'] : ''),
          decoration: InputDecoration(
            labelText: labelText,
          ),
          onChanged: (value) {
            setState(() {
              field['value'] = value;
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
          isActive: currentStep == index + 1,
        ),
      );
    }

    steps.add(
      Step(
        title: Text('Summary'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                // Print the values of all fields here
                print('Amount: ${amountController.text}');
                print('Loan Repayment Period: ${repaymentController.text}');
                for (var field in dynamicFields) {
                  print('${field['field']}: ${field['value']}');
                }
              },
              child: Text('Save data'),
            ),
          ],
        ),
        isActive: currentStep == titles.length + 1,
      ),
    );

    return steps;
  }
}
