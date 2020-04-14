import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/date-picker.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
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

  List<DropdownMenuItem> buildDropDownMenus(List<NamesListItem> listItems) {
    List<DropdownMenuItem> dropdownItems = [];
    for (NamesListItem menu in listItems) {
      dropdownItems
          .add(new DropdownMenuItem(value: menu.id, child: Text(menu.name)));
    }
    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountTextController =
        TextEditingController(text: '');
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
                          dropdownItems: buildDropDownMenus(withdrawalMethods),
                          selectedItem: withdrawalMethod,
                          onChanged: (value) {
                            setState(() {
                              withdrawalMethod = withdrawalMethods[value].id;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Expense Category',
                    listItems: expenseCategories,
                    dropdownItems: buildDropDownMenus(expenseCategories),
                    selectedItem: expenseCategoryId,
                    onChanged: (value) {
                      setState(() {
                        expenseCategoryId = expenseCategories[value].id;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Account',
                    listItems: accounts,
                    dropdownItems: buildDropDownMenus(accounts),
                    selectedItem: accountId,
                    onChanged: (value) {
                      setState(() {
                        accountId = accounts[value].id;
                      });
                    },
                  ),
                  amountInputField(
                    context,
                    'Enter Amount',
                    amountTextController,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hasFloatingPlaceholder: true,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).hintColor,
                        width: 2.0,
                      )),
                      // hintText: 'Phone Number or Email Address',
                      labelText: 'Short Description (optional)',
                    ),
                  ),
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
                      print('Amount: ${amountTextController.text}');
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

class CustomDropDownButton extends StatelessWidget {
  final int selectedItem;
  final String labelText;
  final Function onChanged;
  final List<NamesListItem> listItems;
  final List<DropdownMenuItem> dropdownItems;
  const CustomDropDownButton({
    this.selectedItem,
    this.labelText,
    this.onChanged,
    this.listItems,
    this.dropdownItems,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              InputDecorator(
                decoration: InputDecoration(
                  filled: false,
                  hintText: labelText,
                  labelText: selectedItem == 0 ? labelText : labelText,
//                  errorText: errorText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 2.0,
                    ),
                  ),
                ),
                isEmpty: selectedItem == null,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Theme.of(context).cardColor,
                  ),
                  child: new DropdownButton(
                    value: selectedItem,
                    isDense: true,
                    onChanged: onChanged,
                    items: dropdownItems,
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
