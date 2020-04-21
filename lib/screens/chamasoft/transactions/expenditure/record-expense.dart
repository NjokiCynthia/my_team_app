import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/date-picker.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<NamesListItem> withdrawalMethods = [
  NamesListItem(id: 1, name: "Cash"),
  NamesListItem(id: 2, name: "Cheque"),
  NamesListItem(id: 3, name: "MPesa"),
];
List<NamesListItem> expenseCategories = [
  NamesListItem(id: 1, name: "Kikopey Land Leasing"),
  NamesListItem(id: 2, name: "Masaai Foreign Advantage"),
  NamesListItem(id: 3, name: "DVEA Properties"),
];
List<NamesListItem> accounts = [
  NamesListItem(id: 1, name: "KCB Chama Account"),
  NamesListItem(id: 2, name: "Equity Investment Account"),
  NamesListItem(id: 3, name: "NCBA Loop Account"),
];

class RecordExpense extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecordExpenseState();
  }
}

class RecordExpenseState extends State<RecordExpense> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

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

  final formKey = new GlobalKey<FormState>();
  bool toolTipIsVisible = true;
  DateTime expenseDate = DateTime.now();
  int withdrawalMethod;
  NamesListItem depositMethodValue;
  int expenseCategoryId;
  int accountId;
  String description;
  double amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Record Expense",
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            toolTip(
                context: context,
                title: "Manually record income payment",
                message: "",
                visible: toolTipIsVisible,
                toggleToolTip: () {
                  setState(() {
                    toolTipIsVisible = !toolTipIsVisible;
                  });
                }),
            Container(
              padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).backgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: DatePicker(
                          labelText: 'Select Expense Date',
                          selectedDate: expenseDate == null
                              ? DateTime.now()
                              : expenseDate,
                          selectDate: (selectedDate) {
                            setState(() {
                              expenseDate = selectedDate;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: CustomDropDownButton(
                          labelText: 'Select Withdrawal Method',
                          listItems: withdrawalMethods,
                          selectedItem: withdrawalMethod,
                          onChanged: (value) {
                            setState(() {
                              withdrawalMethod = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Expense Category',
                    listItems: expenseCategories,
                    selectedItem: expenseCategoryId,
                    onChanged: (value) {
                      setState(() {
                        expenseCategoryId = value;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Account',
                    listItems: accounts,
                    selectedItem: accountId,
                    onChanged: (value) {
                      setState(() {
                        accountId = value;
                      });
                    },
                  ),
                  amountTextInputField(
                      context: context,
                      labelText: 'Enter Amount refunded',
                      onChanged: (value) {
                        setState(() {
                          amount = double.parse(value);
                        });
                      }),
                  multilineTextField(
                      context: context,
                      labelText: 'Short Description (Optional)',
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      }),
                  SizedBox(
                    height: 24,
                  ),
                  defaultButton(
                    context: context,
                    text: "SAVE",
                    onPressed: () {
                      print('Expense date: $expenseDate');
                      print('Withdrawal Method: $withdrawalMethod');
                      print('Member: $expenseCategoryId');
                      print('Account: $accountId');
                      print('Amount: $amount');
                      print('Description: $description');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
