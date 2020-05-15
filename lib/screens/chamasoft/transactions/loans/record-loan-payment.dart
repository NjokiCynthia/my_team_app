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
  double amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Record Loan Payment",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
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
                padding: EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height,
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
                            selectedItem: depositMethod,
                            onChanged: (value) {
                              setState(() {
                                depositMethod = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Member',
                      listItems: groupMembers,
                      selectedItem: groupMemberId,
                      onChanged: (value) {
                        setState(() {
                          groupMemberId = value;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Loan',
                      listItems: loans,
                      selectedItem: loanId,
                      onChanged: (value) {
                        setState(() {
                          loanId = value;
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
                        print('Amount: $amount');
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
