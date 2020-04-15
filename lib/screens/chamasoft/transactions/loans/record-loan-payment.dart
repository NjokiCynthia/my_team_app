import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/date-picker.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<NamesListItem> depositMethods = [
  NamesListItem(id: 1, name: "Cash"),
  NamesListItem(id: 2, name: "Cheque"),
  NamesListItem(id: 3, name: "MPesa"),
];
List<NamesListItem> groupMembers = [
  NamesListItem(id: 1, name: "Martin Nzuki"),
  NamesListItem(id: 2, name: "Peter Kimutai"),
  NamesListItem(id: 3, name: "Geoffrey Githaiga"),
  NamesListItem(id: 4, name: "Edwin Kapkei"),
];
List<NamesListItem> loans = [
  NamesListItem(id: 1, name: "Emergency Loan"),
  NamesListItem(id: 2, name: "Chama Loan"),
  NamesListItem(id: 3, name: "Business Loan"),
];
List<NamesListItem> accounts = [
  NamesListItem(id: 1, name: "KCB Chama Account"),
  NamesListItem(id: 2, name: "Equity Investment Account"),
  NamesListItem(id: 3, name: "NCBA Loop Account"),
];

class RecordLoanPayment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecordLoanPaymentState();
  }
}

class RecordLoanPaymentState extends State<RecordLoanPayment> {
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
  DateTime depositDate = DateTime.now();
  int depositMethod;
  NamesListItem depositMethodValue;
  int groupMemberId;
  int loanId;
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
        title: "Record Loan Payment",
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            toolTip(
                context: context,
                title: "Maually record loan payments",
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
                          labelText: 'Select Deposit Date',
                          selectedDate: depositDate == null
                              ? DateTime.now()
                              : depositDate,
                          selectDate: (selectedDate) {
                            setState(() {
                              depositDate = selectedDate;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: CustomDropDownButton(
                          labelText: 'Select Deposit Method',
                          listItems: depositMethods,
                          dropdownItems: buildDropDownMenus(depositMethods),
                          selectedItem: depositMethod,
                          onChanged: (value) {
                            setState(() {
                              depositMethod = depositMethods[value].id;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Member',
                    listItems: groupMembers,
                    dropdownItems: buildDropDownMenus(groupMembers),
                    selectedItem: groupMemberId,
                    onChanged: (value) {
                      setState(() {
                        groupMemberId = groupMembers[value].id;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Loan',
                    listItems: loans,
                    dropdownItems: buildDropDownMenus(loans),
                    selectedItem: loanId,
                    onChanged: (value) {
                      setState(() {
                        loanId = loans[value].id;
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
                    'Amount to pay',
                    amountTextController,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  defaultButton(
                    context: context,
                    text: "SAVE",
                    onPressed: () {
                      print('Deposit date: $depositDate');
                      print('Deposit Method: $depositMethod');
                      print('Member: $groupMemberId');
                      print('Loan: $loanId');
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
              new InputDecorator(
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