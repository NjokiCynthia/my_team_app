import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/helpers/setting_helper.dart';
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
import 'package:provider/provider.dart';

List<NamesListItem> loans = [
  NamesListItem(id: 1, name: "Emergency Loan"),
  NamesListItem(id: 2, name: "Chama Loan"),
  NamesListItem(id: 3, name: "Business Loan"),
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
  bool _isInit = true;
  Map<String, dynamic> formLoadData = {};
  DateTime now = DateTime.now();
  DateTime depositDate = DateTime.now();
  int depositMethod, memberId, loanId, accountId;
  double amount;
  String description;
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));

  final _formKey = new GlobalKey<FormState>();
  bool _isFormInputEnabled = true;
  bool _isLoading = false;
  Map<String, dynamic> _formData = {};
  List<OngoingMemberLoanOptions> ongoingGroupMemberLoans = [];
  List<NamesListItem> memberLoans = [];

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _fetchDefaultValues(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
    formLoadData = await Provider.of<Groups>(context, listen: false)
        .loadInitialFormData(member: true, acc: true, memberOngoingLoans: true);
    setState(() {
      ongoingGroupMemberLoans = Provider.of<Groups>(context, listen: false).getMemberOngoingLoans;
      _isInit = false;
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _prepareMemberLoans(String currency, String selectedMemberID) {
    List<NamesListItem> loans = [];

    if (ongoingGroupMemberLoans != null && ongoingGroupMemberLoans.isNotEmpty) {
      for (var loan in ongoingGroupMemberLoans) {
        if (loan.memberId == selectedMemberID) {
          loans.add(NamesListItem(
              id: int.tryParse(loan.id),
              name:
                  "${loan.loanType} of $currency ${currencyFormat.format(loan.amount)} balance $currency ${currencyFormat.format(loan.balance)}"));
        }
      }
    }

    setState(() {
      memberLoans.clear();
      memberLoans = loans;
    });
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

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<Groups>(context, listen: false).getCurrentGroup().groupCurrency;
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Record Loan Payment",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    toolTip(context: context, title: "Manually record loan payments", message: ""),
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
                                  selectedDate: depositDate == null ? DateTime.now() : depositDate,
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
                                  validator: (value) {
                                    if (value == "" || value == null) {
                                      return "Field is required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          CustomDropDownButton(
                            labelText: 'Select Member',
                            listItems: formLoadData.containsKey("memberOptions") ? formLoadData["memberOptions"] : [],
                            selectedItem: memberId,
                            onChanged: (value) {
                              setState(() {
                                memberId = value;
                                loanId = null;
                                _prepareMemberLoans(currency, value.toString());
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "Field is required";
                              }
                              return null;
                            },
                          ),
                          CustomDropDownButton(
                            labelText: memberLoans.length < 1 ? 'No ongoing loans' : 'Select Loan',
                            listItems: memberLoans,
                            selectedItem: loanId,
                            onChanged: (value) {
                              setState(() {
                                loanId = value;
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "Field is required";
                              }
                              return null;
                            },
                          ),
                          CustomDropDownButton(
                            labelText: 'Select Account',
                            listItems: formLoadData.containsKey("accountOptions") ? formLoadData["accountOptions"] : [],
                            selectedItem: accountId,
                            onChanged: (value) {
                              setState(() {
                                accountId = value;
                              });
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "Field is required";
                              }
                              return null;
                            },
                          ),
                          amountTextInputField(
                              context: context,
                              labelText: 'Enter Amount',
                              enabled: _isFormInputEnabled,
                              validator: (value) {
                                if (value == "" || value == null) {
                                  return "Field is required";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  amount = double.parse(value);
                                });
                              }),
                          multilineTextField(
                              context: context,
                              labelText: 'Short Description (Optional)',
                              maxLines: 5,
                              onChanged: (value) {
                                setState(() {
                                  description = value;
                                });
                              }),
                          SizedBox(
                            height: 24,
                          ),
                          // _isLoading
                          //     ? Padding(
                          //   padding: EdgeInsets.all(10),
                          //   child: Center(child: CircularProgressIndicator()),
                          // )
                          //     : defaultButton(
                          //   context: context,
                          //   text: "SAVE",
                          //   onPressed: () {
                          //     _submit(context);
                          //   },
                          // ),
                          defaultButton(
                            context: context,
                            text: "SAVE",
                            onPressed: () {
                              print('Deposit date: $depositDate');
                              print('Deposit Method: $depositMethod');
                              print('Member: $memberId');
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
        },
      ),
    );
  }
}
