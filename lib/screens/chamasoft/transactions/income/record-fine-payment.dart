import 'package:chamasoft/screens/chamasoft/transactions/income/record-contribution-payment.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class RecordFinePayment extends StatefulWidget {
  @override
  _RecordFinePaymentState createState() => _RecordFinePaymentState();
}

class _RecordFinePaymentState extends State<RecordFinePayment> {
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

  static final List<String> depositType = <String>[
    'Cash',
    'Mobile Money',
    'Cheque',
  ];

  static final List<String> finesList = <String>[
    "Noise Making",
    "Lateness",
    "Disturbance",
  ];

  static final List<String> accountsList = <String>[
    "KCB Bank (Kasarani Branch) - 1102236566655",
    "Equity Bank (Kasarani Branch) - 565953659",
  ];

  static final List<String> memberSelection = <String>[
    'All Members',
    'Individual Members',
  ];

  String selectedFineValue,
      selectedDepositValue,
      selectedAccountValue,
      selectedMemberValue;
  DateTime _selectedDate;
  var selectDateController = TextEditingController();
  var amountInputValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Record Fine Payment",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            toolTip(
                context: context,
                title: "Note that...",
                message: "Manually record fine payments",
                showTitle: false),
            Container(
              padding: EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: selectDateController,
                          onTap: () => showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          ).then((date) {
                            setState(() {
                              _selectedDate = date;
                              selectDateController.text = _selectedDate == null
                                  ? ""
                                  : defaultDateFormat.format(_selectedDate);
                            });
                          }),
                          readOnly: true,
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
                        flex: 2,
                        child: DropDownTextField(
                          hintText: "Select Deposit Method",
                          items: depositType,
                          selectedValue: selectedDepositValue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropDownTextField(
                    hintText: "Select Fine",
                    items: finesList,
                    selectedValue: selectedFineValue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropDownTextField(
                    hintText: "Select Deposit Account",
                    items: accountsList,
                    selectedValue: selectedAccountValue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropDownTextField(
                    hintText: "Select Members",
                    items: memberSelection,
                    selectedValue: selectedMemberValue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  amountInputField(context, "Enter Amount(for each member)",
                      amountInputValue),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: defaultButton(
                      context: context,
                      text: "Save",
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
