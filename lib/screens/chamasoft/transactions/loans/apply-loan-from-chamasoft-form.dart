import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/apply-loan.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'loan-amortization.dart';

class ApplyLoanFromChamasoftForm extends StatefulWidget {
  // const ChamaSoftLoanDetail({ Key? key }) : super(key: key);

  @override
  _ApplyLoanFromChamasoftFormState createState() =>
      _ApplyLoanFromChamasoftFormState();
}

class _ApplyLoanFromChamasoftFormState
    extends State<ApplyLoanFromChamasoftForm> {
  double _appBarElevation = 0;
  final _formKey = GlobalKey<FormState>();

  double generalAmount;
  List<double> amount = [];
  List<int> guarantors = [];

  double get totalGuaranteed {
    return amount.reduce((value, element) => value + element);
  }

  void submit(LoanProduct loanProduct, BuildContext context) {
    final Group groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    if (_formKey.currentState.validate()) {
      if (totalGuaranteed == generalAmount) {
        showConfirmationDialog(loanProduct, groupObject, context);
      } else {
        StatusHandler().showErrorDialog(context,
            "You have guaranteed ${groupObject.groupCurrency} ${currencyFormat.format(totalGuaranteed)} out of ${groupObject.groupCurrency} ${currencyFormat.format(generalAmount)}.");
      }
    }
  }

  void showConfirmationDialog(
      LoanProduct loanProduct, Group groupObject, BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: subtitle1(text: "Confirm Application"),
              content: Text(
                  "Confirm loan of ${groupObject.groupCurrency} ${currencyFormat.format(generalAmount)}"),
              actions: [
                // ignore: deprecated_member_use
                negativeActionDialogButton(
                  text: ('CANCEL'),
                  color: Theme.of(context)
                      // ignore: deprecated_member_use
                      .textSelectionHandleColor,
                  action: () {
                    Navigator.of(context).pop();
                  },
                ),
                // ignore: deprecated_member_use
                positiveActionDialogButton(
                    text: ('PROCEED'),
                    color: primaryColor,
                    action: () {
                      Navigator.of(context).pop();
                      submitLoanApplication(loanProduct, context);
                    }),
              ],
            ));
  }

  void submitLoanApplication(
      LoanProduct loanProduct, BuildContext context) async {
    Map<String, dynamic> formData = {
      'loan_product_id': loanProduct.id,
      'amount': generalAmount,
      'guarantors': guarantors
    };

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
      String response =
          await Provider.of<ChamasoftLoans>(context, listen: false)
              .submitLoanApplication(formData);

      StatusHandler().showSuccessSnackBar(context, "Good news: $response");

      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => ApplyLoan(
                  isInit: false,
                )));
      });
    } on CustomException catch (error) {
      StatusHandler().showDialogWithAction(
          context: context,
          message: error.toString(),
          function: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => ApplyLoan(
                        isInit: false,
                      ))),
          dismissible: true);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final LoanProduct _loanProduct = arguments['loanProduct'];
    final Group groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    final List<NamesListItem> _memberOptions =
        arguments['formLoadData'].containsKey("memberOptions")
            ? arguments['formLoadData']['memberOptions']
            : [];

    print("enableLoanGuarantor ${_loanProduct.enableLoanGuarantors}");

    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: "Apply Loan",
        ),
        backgroundColor: Colors.transparent,
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                color: (themeChangeProvider.darkTheme)
                    ? Colors.blueGrey[800]
                    : Colors.white,
                //   // padding: EdgeInsets.all(0.0),
                height: MediaQuery.of(context).size.height * 0.9,
                child: Container(
                  decoration: primaryGradient(context),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    subtitle1(
                                      text:
                                          "From ChamaSoft:  ${_loanProduct.name}",
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    amountTextInputField(
                                        context: context,
                                        validator: (value) {
                                          if (value == null || value == "") {
                                            return "The field is required";
                                          }
                                          return null;
                                        },
                                        labelText: "Enter The Loan Amount",
                                        enabled: true,
                                        onChanged: (value) {
                                          setState(() {
                                            generalAmount = value != null
                                                ? double.parse(value)
                                                : 0.0;
                                          });
                                        }),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customTitle(
                                            text: 'Amount: ' +
                                                (_loanProduct.maximumLoanAmount)
                                                    .toString() +
                                                " " +
                                                'Maximum to ' +
                                                " " +
                                                (_loanProduct.minimumLoanAmount)
                                                    .toString() +
                                                " " +
                                                'Minimum.',
                                            fontSize: 10.0,
                                            textAlign: TextAlign.start),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              if (_loanProduct.enableLoanGuarantors == "1")
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  padding: EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    itemBuilder: (BuildContext context, index) {
                                      return addGuarantor(
                                          _memberOptions, context, index);
                                    },
                                    itemCount: int.tryParse(
                                                _loanProduct.guarantors) !=
                                            null
                                        ? int.tryParse(_loanProduct.guarantors)
                                        : 0,
                                  ),
                                ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 30.0, right: 30.0),
                                child: Row(
                                  children: [
                                    Checkbox(
                                        value: true,
                                        onChanged: (bool value) {
                                          setState(() {
                                            value = true;
                                          });
                                        }),
                                    textWithExternalLinks(
                                        color: Colors.blueGrey,
                                        size: 12.0,
                                        textData: {
                                          'By applying for this loan you agree to the ':
                                              {},
                                          'terms and conditions': {
                                            "url": () =>
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          LoanAmortization(),
                                                      settings: RouteSettings(
                                                          arguments: {
                                                            'loanProduct':
                                                                _loanProduct,
                                                            'generalAmount':
                                                                generalAmount,
                                                          })),
                                                ),
                                            "color": primaryColor,
                                            "weight": FontWeight.w500
                                          },
                                        }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Center(
                                child: defaultButton(
                                    context: context,
                                    text: "Apply Now",
                                    onPressed: () {
                                      submit(_loanProduct, context);
                                    }),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Row addGuarantor(
      List<NamesListItem> _memberOptions, BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: CustomDropDownButton(
            enabled: true,
            labelText: "Select guarantor",
            listItems: _memberOptions,
            selectedItem: guarantors[index],
            onChanged: (value) {
              setState(() {
                guarantors[index] = value;
              });
            },
            validator: (value) {
              if (value == "" || value == null) {
                return "This field is required";
              }
              return null;
            },
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: amountTextInputField(
              context: context,
              validator: (value) {
                if (value == null || value == "") {
                  return "The field is required";
                }
                return null;
              },
              labelText: "Enter Amount",
              enabled: true,
              onChanged: (value) {
                setState(() {
                  amount[index] = value != null ? double.tryParse(value) : 0.0;
                });
              }),
        ))
      ],
    );
  }
}
