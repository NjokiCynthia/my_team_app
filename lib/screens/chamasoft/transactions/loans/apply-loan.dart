import 'package:chamasoft/screens/chamasoft/transactions/loans/loan-amortization.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../../dashboard.dart';

class ApplyLoan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ApplyLoanState();
  }
}

class ApplyLoanState extends State<ApplyLoan> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  double amountInputValue;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  static final List<String> _dropdownItems = <String>[
    'Emergency Loan',
    'Education Loan'
  ];
  final formKey = new GlobalKey<FormState>();
  String _dropdownValue;
  String _errorText;

  Widget buildDropDown() {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new InputDecorator(
                decoration: InputDecoration(
                    labelStyle: inputTextStyle(),
                    hintStyle: inputTextStyle(),
                    errorStyle: inputTextStyle(),
                    filled: false,
                    hintText: 'Select Loan Type',
                    labelText: _dropdownValue == null
                        ? 'Select Loan Type'
                        : 'Select Loan Type',
                    errorText: _errorText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor, width: 1.0))),
                isEmpty: _dropdownValue == null,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: (themeChangeProvider.darkTheme)
                        ? Colors.blueGrey[800]
                        : Colors.white,
                  ),
                  child: new DropdownButton<String>(
                    value: _dropdownValue,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                    },
                    items: _dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: inputTextStyle(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = new TextEditingController();
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ChamasoftDashboard(),
          ),
        ),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Apply Loan",
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            toolTip(
                context: context,
                title: "Note that...",
                message:
                    "Loan application process is totally depended on your group's constitution and your group\'s management."),
            Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: <Widget>[
                  buildDropDown(),
                  amountTextInputField(
                      context: context,
                      labelText: "Amount applying for",
                      onChanged: (value) {
                        setState(() {
                          amountInputValue = double.parse(value);
                        });
                      }),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: textWithExternalLinks(
                        color: Colors.blueGrey,
                        size: 12.0,
                        textData: {
                          'By applying for this loan you agree to the ': {},
                          'terms and conditions': {
                            "url": () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoanAmortization(),
                                  ),
                                ),
                            "color": primaryColor,
                            "weight": FontWeight.w500
                          },
                        }),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  defaultButton(
                      context: context, text: "Apply Now", onPressed: () {})
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
