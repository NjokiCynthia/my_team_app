import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/record-loan-payment.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/date-picker.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class AccountToAccountTransfer extends StatefulWidget {
  @override
  _AccountToAccountTransferState createState() =>
      _AccountToAccountTransferState();
}

class _AccountToAccountTransferState extends State<AccountToAccountTransfer> {
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

  final formKey = new GlobalKey<FormState>();
  bool toolTipIsVisible = true;
  DateTime depositDate = DateTime.now();
  int depositMethod;
  NamesListItem depositMethodValue;
  int groupMemberId;
  int loanId;
  int fromAccountId;
  int toAccountId;
  double amount;
  String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Account to Account Transfer",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            toolTip(
                context: context,
                title: "Manually record account to account money transfer",
                message: "",
                visible: toolTipIsVisible,
                toggleToolTip: () {
                  setState(() {
                    toolTipIsVisible = !toolTipIsVisible;
                  });
                }),
            Container(
              padding: inputPagePadding,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).backgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DatePicker(
                    labelText: 'Select Transfer Date',
                    selectedDate:
                        depositDate == null ? DateTime.now() : depositDate,
                    selectDate: (selectedDate) {
                      setState(() {
                        depositDate = selectedDate;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select account to transfer from',
                    listItems: accounts,
                    selectedItem: fromAccountId,
                    onChanged: (value) {
                      setState(() {
                        fromAccountId = value;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select account to transfer to',
                    listItems: accounts,
                    selectedItem: toAccountId,
                    onChanged: (value) {
                      setState(() {
                        toAccountId = value;
                      });
                    },
                  ),
                  amountTextInputField(
                      context: context,
                      labelText: 'Enter Amount',
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
                      print('Deposit date: $depositDate');
                      print('Deposit Method: $depositMethod');
                      print('Member: $groupMemberId');
                      print('Loan: $loanId');
                      print('Account: $fromAccountId');
                      print('Amount: $amount');
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
