import 'package:chamasoft/providers/groups.dart';
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
import 'package:provider/provider.dart';

class RecordMiscellaneousPayment extends StatefulWidget {
  @override
  _RecordMiscellaneousPayment createState() => _RecordMiscellaneousPayment();
}

class _RecordMiscellaneousPayment extends State<RecordMiscellaneousPayment> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isInit = true;
  Map <String,dynamic> formLoadData = {};
  DateTime now = DateTime.now();
  DateTime depositDate = DateTime.now();


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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchDefaultValues(context);
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchDefaultValues(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      );
    });
    formLoadData = await Provider.of<Groups>(context,listen: false).loadInitialFormData(member: true,acc:true); 
    setState(() {
      _isInit = false;
    });
    Navigator.of(context,rootNavigator: true).pop();
  }

  final formKey = new GlobalKey<FormState>();
  bool toolTipIsVisible = true;
  DateTime refundDate = DateTime.now();
  int refundMethod;
  NamesListItem depositMethodValue;
  int depositorId;
  int groupMemberId;
  int incomeCategoryId;
  int accountId;
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
        title: "Record Miscellaneous Payment",
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
                  title: "Manually record miscellanoues payments",
                  message: ""),
              Container(
                padding: inputPagePadding,
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
                          flex: 2,
                          child: DatePicker(
                            labelText: 'Select Deposit Date',
                            lastDate: DateTime.now(),
                            selectedDate: depositDate == null ? new DateTime(now.year, now.month, now.day - 1, 6, 30) : depositDate,
                            selectDate: (selectedDate) {
                              setState(() {
                                depositDate = selectedDate;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 3,
                          child: CustomDropDownButton(
                            labelText: 'Select Deposit Method',
                            listItems: depositMethods,
                            selectedItem: refundMethod,
                            onChanged: (value) {
                              setState(() {
                                refundMethod = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Member',
                      listItems: formLoadData.containsKey("memberOptions")?formLoadData["memberOptions"]:[],
                      selectedItem: groupMemberId,
                      onChanged: (value) {
                        setState(() {
                          groupMemberId = value;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Account',
                      listItems: formLoadData.containsKey("accountOptions")?formLoadData["accountOptions"]:[],
                      selectedItem: accountId,
                      onChanged: (value) {
                        setState(() {
                          accountId = value;
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
                        print('Refund date: $refundDate');
                        print('Refund Method: $refundMethod');
                        print('Depositor: $depositorId');
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
      ),
    );
  }
}
