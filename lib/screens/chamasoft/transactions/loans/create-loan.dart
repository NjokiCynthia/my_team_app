import 'dart:developer';

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/reports/withdrawal_receipts.dart';
import 'package:chamasoft/screens/chamasoft/settings/setup-lists/loan-setup-list.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/date-picker.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class CreateMemberLoan extends StatefulWidget {
  @override
  _RecordContributionPaymentState createState() => _RecordContributionPaymentState();
}

class _RecordContributionPaymentState extends State<CreateMemberLoan> {
  bool _isInit = true;
  bool _isLoading = false;
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [], memberOptions = [];
  int memberTypeId;
  final _formKey = new GlobalKey<FormState>();
  DateTime disbursementDate = DateTime.now();
  final now = DateTime.now();
  int loanTypeId;
  int accountId;
  int groupMemberId;
  int gracePeriod;
  String repaymentPeriod;
  String loanAmount;
  Map<String, dynamic> _formData = {};
  String selectedLoanValue;
  String selectedAccountValue;
  String selectedMemberType;
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));
  Map<String, dynamic> _individualMemberContributions = {};
  bool _isFormInputEnabled = true;
  Map<String, dynamic> formLoadData = {};

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
    formLoadData =
        await Provider.of<Groups>(context, listen: false).loadInitialFormData(acc: true, member: true, loanTypes: true);
    setState(() {
      _isInit = false;
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _isFormInputEnabled = false;
    });

    _formKey.currentState.save();
    _formData['disbursement_date'] = disbursementDate.toString();
    _formData['loan_type_id'] = loanTypeId;
    _formData['account_id'] = accountId;
    _formData['request_id'] = requestId;
    _formData['loan_amount'] = loanAmount;
    _formData['member_id'] = groupMemberId;
    _formData['grace_period'] = gracePeriod;
    _formData['repayment_period'] = repaymentPeriod;

    log(_formData.toString());
    try {
      String message = await Provider.of<Groups>(context, listen: false).recordMemberLoan(_formData);
      StatusHandler().showSuccessSnackBar(context, message);

      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => WithdrawalReceipts()));
      });
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _submit(context);
          });
    } finally {
      setState(() {
        _isLoading = false;
        _isFormInputEnabled = true;
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
  void didChangeDependencies() {
    if (_isInit) {
      _fetchDefaultValues(context);
    }
    super.didChangeDependencies();
  }

  Iterable<Widget> get memberWidgets sync* {
    for (MembersFilterEntry member in selectedMembersList) {
      yield ListTile(
        title: Container(width: 200, child: Text(member.name, style: TextStyle(fontSize: 17))),
        contentPadding: EdgeInsets.all(4.0),
        subtitle: Container(
            width: 200,
            child: Text(
              member.phoneNumber,
              style: TextStyle(fontSize: 12),
            )),
        trailing: Container(
          width: 220.0,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: amountTextInputField(
                      labelText: "Enter Amount",
                      enabled: _isFormInputEnabled,
                      context: context,
                      onChanged: (value) {
                        _individualMemberContributions[member.memberId] = value;
                      },
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Field is required";
                        }
                        return null;
                      })),
              Expanded(
                child: circleIconButton(
                    backgroundColor: Color(0xFFFFF2F2),
                    color: Color(0xFFE40000),
                    icon: Icons.close,
                    iconSize: 18,
                    onPressed: () {
                      setState(() {
                        selectedMembersList.removeWhere((MembersFilterEntry entry) {
                          return entry.name == member.name;
                        });
                      });
                    }),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        title: "Record Member Loan",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
                    toolTip(context: context, title: "Manually record member loans", message: "", showTitle: true),
                    Padding(
                      padding: inputPagePadding,
                      child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              DatePicker(
                                labelText: 'Select Disbursement Date',
                                lastDate: DateTime.now(),
                                selectedDate: disbursementDate == null
                                    ? new DateTime(now.year, now.month, now.day - 1, 6, 30)
                                    : disbursementDate,
                                selectDate: (selectedDate) {
                                  setState(() {
                                    disbursementDate = selectedDate;
                                  });
                                },
                              ),
                              CustomDropDownButton(
                                labelText: "Select Loan Type",
                                enabled: _isFormInputEnabled,
                                listItems:
                                    formLoadData.containsKey("loanTypeOptions") ? formLoadData["loanTypeOptions"] : [],
                                selectedItem: loanTypeId,
                                validator: (value) {
                                  if (value == null) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    loanTypeId = value;
                                  });
                                },
                              ),
                              CustomDropDownButton(
                                labelText: 'Select Member Taking the Loan',
                                enabled: _isFormInputEnabled,
                                listItems:
                                    formLoadData.containsKey("memberOptions") ? formLoadData["memberOptions"] : [],
                                selectedItem: groupMemberId,
                                validator: (value) {
                                  if (value.toString().isEmpty || value == null) {
                                    return "Field is required";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    groupMemberId = value;
                                  });
                                },
                              ),
                              amountTextInputField(
                                  enabled: _isFormInputEnabled,
                                  context: context,
                                  labelText: 'Loan Amount',
                                  onChanged: (value) {
                                    loanAmount = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return "Field is required";
                                    }
                                    return null;
                                  }),
                              CustomDropDownButton(
                                labelText: "Select Disbursing Account",
                                enabled: _isFormInputEnabled,
                                listItems:
                                    formLoadData.containsKey("accountOptions") ? formLoadData["accountOptions"] : [],
                                selectedItem: accountId,
                                onChanged: (value) {
                                  setState(() {
                                    accountId = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                              ),
                              amountTextInputField(
                                  enabled: _isFormInputEnabled,
                                  context: context,
                                  labelText: 'Repayment Period(in Months)',
                                  onChanged: (value) {
                                    repaymentPeriod = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return "Field is required";
                                    }
                                    return null;
                                  }),
                              CustomDropDownButton(
                                labelText: "Select Grace Period",
                                enabled: _isFormInputEnabled,
                                listItems: loanGracePeriods,
                                selectedItem: gracePeriod,
                                onChanged: (value) {
                                  setState(() {
                                    gracePeriod = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _isLoading
                                  ? Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(child: CircularProgressIndicator()),
                                    )
                                  : defaultButton(
                                      context: context,
                                      text: "SAVE",
                                      onPressed: () {
                                        _submit(context);
                                      },
                                    )
                            ]),
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
