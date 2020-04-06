import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class RecordContributionPayment extends StatefulWidget {
  @override
  _RecordContributionPaymentState createState() =>
      _RecordContributionPaymentState();
}

class _RecordContributionPaymentState extends State<RecordContributionPayment> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
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

  static final List<String> contributionList = <String>[
    'Monthly Savings',
    'Welfare'
  ];
  static final List<String> accountList = <String>[
    'KCB Bank - 10101241241',
    'Equity Bank - 123123100292',
    'ABSA Bank - 1212111111',
  ];

  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String selectedContributionValue;
    String selectedAccountValue;

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Record Contribution Payment",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(children: <Widget>[
            toolTip(
                context: context,
                title: "Note that...",
                message: "Manually record contribution payments",
                showTitle: false),
            Container(
                padding: EdgeInsets.all(20.0),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hasFloatingPlaceholder: true,
                              labelText: 'Select Date',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hasFloatingPlaceholder: true,
                              labelText: 'Select Date',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropDownTextField(
                      hintText: "Select Contribution",
                      selectedValue: selectedContributionValue,
                      items: contributionList,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropDownTextField(
                      hintText: "Select Account",
                      selectedValue: selectedContributionValue,
                      items: accountList,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    defaultButton(
                      context: context,
                      text: "Save",
                      onPressed: () {
                        print("Contribution: " + selectedContributionValue);
                        print("Account: " + selectedAccountValue);
                      },
                    ),
                  ],
                ))
          ])),
    );
  }
}

// ignore: must_be_immutable
class DropDownTextField extends StatefulWidget {
  DropDownTextField({this.hintText, this.selectedValue, this.items});

  final String hintText;
  String selectedValue;
  final List<String> items;

  @override
  _DropDownTextFieldState createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new InputDecorator(
                decoration: InputDecoration(
                    filled: false,
                    hintText: widget.hintText,
                    labelText: widget.selectedValue == null
                        ? widget.hintText
                        : widget.hintText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor, width: 2.0))),
                isEmpty: widget.selectedValue == null,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Theme.of(context).cardColor,
                  ),
                  child: new DropdownButton<String>(
                    value: widget.selectedValue,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        widget.selectedValue = newValue;
                      });
                    },
                    items: widget.items.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
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
}
