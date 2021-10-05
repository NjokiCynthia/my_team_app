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
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'chamasoft-loan-amortization.dart';

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
  BuildContext _buildContext;

  double generalAmount;

  List<int> _guarantors = [];

  List<double> _amounts = [];

  bool _isChecked = false;

  var guarantorsMap = Map();

  final snackbar = SnackBar(
      content: subtitle2(
          text: "Kindly accept T&C to proceed", textAlign: TextAlign.start));

  double get totalGuaranteed {
    double total = 0.0;

    total = _amounts.reduce((value, element) => value + element);

    return total;
  }

  void submit(LoanProduct loanProduct, bool isChecked) {
    final Group groupObject =
        Provider.of<Groups>(_buildContext, listen: false).getCurrentGroup();

    if (_formKey.currentState.validate()) {
      if (totalGuaranteed == generalAmount) {
        // check guarantor duplicates
        bool duplicateGuarantor = false;

        for (var guarantorId in _guarantors) {
          int index = _guarantors.indexOf(guarantorId);
          if (_guarantors.sublist(index + 1).contains(guarantorId)) {
            duplicateGuarantor = true;
            break;
          }
          if (duplicateGuarantor == true) {
            // show error dialog
            StatusHandler().showErrorDialog(_buildContext,
                "You cannot be guaranteed by one member more than once.");
          } else {
            // show confirmation dialog
            showConfirmationDialog(loanProduct, groupObject);
          }
        }
      }
      if (!isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else {
        // show error dialog
        StatusHandler().showErrorDialog(_buildContext,
            "You have guaranteed ${groupObject.groupCurrency} ${currencyFormat.format(totalGuaranteed)} out of ${groupObject.groupCurrency} ${currencyFormat.format(generalAmount)}.");
      }
    }
  }

  void showConfirmationDialog(LoanProduct loanProduct, Group groupObject) {
    showDialog(
        context: _buildContext,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: subtitle1(text: "Confirmation"),
              content: subtitle2(
                  text:
                      "Accept loan application of ${groupObject.groupCurrency} ${currencyFormat.format(generalAmount)}."),
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
      'guarantors': _guarantors,
      'amounts': _amounts
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

    int numOfGuarantors = int.tryParse(_loanProduct.guarantors) != null
        ? int.tryParse(_loanProduct.guarantors)
        : 0;

    String repaymentPeriod = _loanProduct.fixedRepaymentPeriod != ""
        ? _loanProduct.fixedRepaymentPeriod
        : _loanProduct.maximumRepaymentPeriod;

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return (themeChangeProvider.darkTheme)
            ? Color(0xff00a9f0)
            : Color(0xff00a9f0);
      }
      return (themeChangeProvider.darkTheme)
          ? Color(0xff00a9f0)
          : Color(0xff00a9f0);
    }

    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          title: "Apply Loan",
        ),
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          onPressed: () => submit(_loanProduct, _isChecked),
          backgroundColor: primaryColor,
        ),
        body: Builder(builder: (BuildContext context) {
          _buildContext = context;
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
                                    if (_loanProduct.loanAmountType == "2")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          subtitle2(
                                              text:
                                                  'Maximum loan amount: ${groupObject.groupCurrency} ${currencyFormat.format(int.tryParse(_loanProduct.maximumLoanAmount))}, Minimum loan amount: ${groupObject.groupCurrency} ${currencyFormat.format(int.tryParse(_loanProduct.minimumLoanAmount))}',
                                              textAlign: TextAlign.start),
                                        ],
                                      ),
                                    if (_loanProduct.loanAmountType == "3")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          subtitle2(
                                              text:
                                                  'Fixed loan amount: ${groupObject.groupCurrency} ${currencyFormat.format(int.tryParse(_loanProduct.maximumLoanAmount))}',
                                              textAlign: TextAlign.start),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              _loanProduct.enableLoanGuarantors == "1" &&
                                      numOfGuarantors > 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: subtitle1(
                                              text:
                                                  " Guarantors : $numOfGuarantors",
                                              textAlign: TextAlign.start),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              (numOfGuarantors >= 5
                                                  ? (5 / 10)
                                                  : (numOfGuarantors / 10)),
                                          padding: EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return addGuarantor(
                                                  _memberOptions,
                                                  context,
                                                  index);
                                            },
                                            itemCount: numOfGuarantors,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                        checkColor: Colors.white,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                getColor),
                                        value: _isChecked,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _isChecked = value;
                                          });
                                        }),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Flexible(
                                      child: textWithExternalLinks(
                                          color: Colors.blueGrey,
                                          size: 12.0,
                                          textData: {
                                            'I agree to the ': {},
                                            'terms and conditions': {
                                              "url": () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ChamasoftLoanAmortization(
                                                            loanAmount:
                                                                generalAmount,
                                                            loanTypeId: _loanProduct
                                                                .loanAmountType,
                                                            repaymentPeriod:
                                                                repaymentPeriod,
                                                          ),
                                                      settings: RouteSettings(
                                                          arguments: {
                                                            'loanProduct':
                                                                _loanProduct,
                                                            'generalAmount':
                                                                generalAmount
                                                          }))),
                                              "color": primaryColor,
                                              "weight": FontWeight.w500
                                            },
                                          }),
                                    ),
                                  ],
                                ),
                              ),
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

  // STEP 1: if at that index we have a map set, if there is no map, you add else you set.

  // STEP 2: Do step 1 for guaranto and amount.

  Row addGuarantor(
      List<NamesListItem> _memberOptions, BuildContext context, int index) {
    //_memberOptions.map((e) => guarantors);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: CustomDropDownButton(
            enabled: true,
            labelText: "Select guarantor",
            listItems: _memberOptions,
            onChanged: (value) {
              setState(() {
                if (_guarantors.asMap().containsKey(index)) {
                  _guarantors[index] = value;
                } else {
                  _guarantors.add(value);
                }
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
                  if (_amounts.asMap().containsKey(index)) {
                    _amounts[index] = double.tryParse(value);
                  } else {
                    _amounts.add(double.tryParse(value));
                  }
                });
              }),
        ))
      ],
    );
  }
}
