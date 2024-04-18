import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/reports/loan-applications.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
  Map<String, String> filePaths = {};
  Auth _user;
  Group _group;
  String loanAmount;
  Map<String, String> selectedFilePath = {};

  FormData formData = FormData();
  PlatformFile selectedFile;
  void submitGroupLoanApplication(BuildContext context) async {
    formData.fields.add(MapEntry('user_id', _user.id));
    formData.fields.add(MapEntry('group_id', _group.groupId));
    formData.fields.add(MapEntry('member_id', _group.memberId));
    formData.fields.add(MapEntry('loan_amount', loanAmount.toString()));
    formData.fields
        .add(MapEntry('name', widget.selectedLoanProduct['name'].toString()));
    formData.fields.add(MapEntry(
        'minAmount', widget.selectedLoanProduct['minAmount'].toString()));
    formData.fields.add(MapEntry(
        'maxAmount', widget.selectedLoanProduct['maxAmount'].toString()));
    formData.fields.add(MapEntry(
        'loan_product_id', widget.selectedLoanProduct['_id'].toString()));
    formData.fields.add(MapEntry('repayment_period',
        widget.selectedLoanProduct['repayment_period'].toString()));
    formData.fields.add(
        MapEntry('enabled', widget.selectedLoanProduct['enabled'].toString()));
    formData.fields.add(MapEntry(
        'interestType', widget.selectedLoanProduct['interestType'].toString()));
    formData.fields.add(MapEntry(
        'interestRate', widget.selectedLoanProduct['interestRate'].toString()));
    formData.fields.add(MapEntry('interestCharge',
        widget.selectedLoanProduct['interestCharge'].toString()));
    formData.fields.add(MapEntry(
        'repaymentPeriodType',
        widget.selectedLoanProduct['repaymentPeriodType']
            .toString()
            .toString()));
    formData.fields.add(MapEntry('repaymentPeriod',
        widget.selectedLoanProduct['repaymentPeriod'].toString()));
    formData.fields.add(MapEntry('maxRepaymentPeriod', ''));
    formData.fields.add(MapEntry('minRepaymentPeriod', ''));
    formData.fields.add(MapEntry(
        'enableFinesForLateInstallments',
        widget.selectedLoanProduct['enableFinesForLateInstallments']
            .toString()));
    formData.fields.add(MapEntry('lateLoanPaymentFineType',
        widget.selectedLoanProduct['lateLoanPaymentFineType'].toString()));
    formData.fields.add(MapEntry('oneOffPercentageOn', ''));
    formData.fields.add(MapEntry('percentageFineRate', ''));
    formData.fields.add(MapEntry('fineFrequency', ''));
    formData.fields.add(MapEntry('outstandingBalOneOffAmount', ''));
    formData.fields.add(MapEntry('outstandingBalFixedFineAmount', ''));
    formData.fields.add(MapEntry('outstandingBalFineFrequency', ''));
    formData.fields.add(MapEntry('outstandingBalPercentageFineRate', ''));
    formData.fields.add(MapEntry('outstandingBalFineChargeFactor', ''));
    formData.fields.add(MapEntry('fineChargeFactor', ''));
    formData.fields.add(MapEntry('enableGuarantors',
        widget.selectedLoanProduct['enableGuarantors'].toString()));
    formData.fields.add(MapEntry('enableLoanProfitFee', ''));
    formData.fields.add(MapEntry('loanProfitFeeType', ''));
    formData.fields.add(MapEntry('percentageLoanProfitFee', ''));
    formData.fields.add(MapEntry('eventToEnableGuarantors',
        widget.selectedLoanProduct['eventToEnableGuarantors']));
    formData.fields.add(MapEntry('minGuarantors',
        widget.selectedLoanProduct['minGuarantors'].toString()));
    formData.fields.add(MapEntry('loanProcessingFeeType', ''));
    formData.fields.add(MapEntry('loanProcessingFeeAmount', ''));
    formData.fields.add(MapEntry('loanProcessingFeePercentage', ''));
    formData.fields.add(MapEntry('loanProcessingFeePercentageFactor', ''));
    formData.fields.add(MapEntry('fixedLoanProfitFeeAmount', ''));
    formData.fields.add(MapEntry('oneOffFineType', ''));
    formData.fields.add(MapEntry('oneOffFixedAmount', ''));
    formData.fields.add(MapEntry('enableFinesForOutstandingBalances', ''));
    formData.fields.add(MapEntry('outstandingBalanceFineType', ''));
    formData.fields.add(MapEntry('enableLoanProcessingFee',
        widget.selectedLoanProduct['enableLoanProcessingFee'].toString()));
    formData.fields.add(MapEntry('disableAutomatedLoanProcessingIncome', ''));
    formData.fields.add(MapEntry('requireOfficialsApproval',
        widget.selectedLoanProduct['requireOfficialsApproval'].toString()));
    formData.fields.add(MapEntry('requirePurposeOfLoan', ''));
    formData.fields.add(MapEntry('loanProductNature',
        widget.selectedLoanProduct['loanProductNature'].toString()));
    formData.fields.add(MapEntry('loanProductMode',
        widget.selectedLoanProduct['loanProductMode'].toString()));
    formData.fields.add(MapEntry(
        'gracePeriod', widget.selectedLoanProduct['gracePeriod'].toString()));
    formData.fields.add(MapEntry('groupId', ''));
    formData.fields.add(MapEntry('times', ''));
    formData.fields.add(MapEntry('guarantors', ['59070', '59072'].toString()));
    formData.fields.add(MapEntry('amounts', ['3000', '4310'].toString()));
    formData.fields
        .add(MapEntry('type', widget.selectedLoanProduct['type'].toString()));
    formData.fields.add(MapEntry('comments', ['test', 'test'].toString()));
    formData.fields.add(MapEntry('metadata', _data.toString()));
    formData.fields.add(MapEntry('requireDocuments',
        widget.selectedLoanProduct['requireDocuments'].toString()));

    additionalDocumentFields.forEach((docField) async {
      String slug = docField['slug'];
      formData.files.add(MapEntry(
          slug,
          //'file',
          await MultipartFile.fromFile(
            selectedFile.path.toString(),
            filename: selectedFile.name,
          )));
    });

    print(_data);
    print('form data is here: $formData');
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
        MaterialPageRoute(builder: (context) => ListLoanApplications()),
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
        title: Text('Enter amount you want to apply for.'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: stepContent,
          ),
          isActive: true,
        ),
      );
    });
    void _handleFileUpload(String slug) async {
      // Open file picker
      FilePickerResult result = await FilePicker.platform.pickFiles();

      if (result != null) {
        String path = result.files.single.path;
        filePaths[slug] = path;
        print('File path for $slug: $path');
        // Update UI to display file path
        // print('File path for $slug: $path');

        // Update selectedFilePath
        selectedFilePath[slug] = path;
        setState(() {
          // Update selectedFilePath
        });
      }
    }

    if (additionalDocumentFields.isNotEmpty) {
      List<Widget> uploadFields = [];
      for (var docField in additionalDocumentFields) {
        String slug = docField['slug'];
        //String filePath = selectedFilePath;
        uploadFields.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _handleFileUpload(slug);
                });
              },
              child: Text('Upload ${docField['title']}'),
            ),
            // Display path if available
            Text('File path: $slug '),
            //${selectedFilePath[slug]}
            // Text(
            //     'Selected file path: $selectedFilePath'), // Display selected file path
          ],
        ));
      }
      setState(() {
        steps.add(
          Step(
            title: Text('Upload Documents'),
            content: Column(
              children: uploadFields,
            ),
            isActive: true, // Set active for all steps initially
          ),
        );
      });
    }
  }

  List<Step> _getSteps() {
    List<Step> allSteps = [];
    steps.forEach((element) {
      allSteps.add(element);
      print('label of element: ${element.title}');
    });

    return allSteps;
  }

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
        title: "Apply Loan",
      ),
      body: Stepper(
        steps: _getSteps(),
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
    );
  }
  // void saveData() {
  //   // Implement your save data logic here
  //   print('I WANT TO SEE TEH DATA:');
  //   print(_data);
  //   // Reset form data if needed
  //   _data.clear();
  // }
}
