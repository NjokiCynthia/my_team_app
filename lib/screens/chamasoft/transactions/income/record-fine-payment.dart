import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/helpers/setting_helper.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/reports/deposit-receipts.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/fine-member.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/date-picker.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../select-member.dart';

class RecordFinePayment extends StatefulWidget {
  @override
  _RecordFinePaymentState createState() => _RecordFinePaymentState();
}

class _RecordFinePaymentState extends State<RecordFinePayment> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [];
  int memberTypeId;
  Map<String, dynamic> formLoadData = {};
  bool _isInit = true;
  bool _isLoading = false;
  bool _isFormInputEnabled = true;
  final now = DateTime.now();
  final formKey = new GlobalKey<FormState>();
  DateTime finePaymentDate = DateTime.now();
  int depositMethod;
  int fineId;
  int accountId;
  var selectDateController = TextEditingController();
  double amountInputValue;
  Map<String, dynamic> _individualMemberContributions = {};
  final _formKey = new GlobalKey<FormState>();
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));
  Map<String, dynamic> _formData = {};

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
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
    formLoadData = await Provider.of<Groups>(context, listen: false).loadInitialFormData(acc: true, fineOptions: true);
    setState(() {
      _isInit = false;
    });
    Navigator.of(context, rootNavigator: true).pop();
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

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
      _isFormInputEnabled = false;
    });
    _formKey.currentState.save();
    _formData['deposit_date'] = finePaymentDate.toString();
    _formData['deposit_method'] = depositMethod;
    _formData['fine_category_id'] = "fine_category-$fineId";
    _formData['account_id'] = accountId;
    _formData['request_id'] = requestId;
    _formData['amount'] = amountInputValue;
    _formData['member_type_id'] = memberTypeId;
    _formData['individual_payments'] = _individualMemberContributions;
    try {
      String message = await Provider.of<Groups>(context, listen: false).recordFinePayments(_formData);
      StatusHandler().showSuccessSnackBar(context, message);

      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => DepositReceipts()));
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
      body: Builder(builder: (BuildContext context) {
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
                toolTip(
                    context: context,
                    title: "Manually record fine payments",
                    message: "",
                    showTitle: true),
                Padding(
                  padding: inputPagePadding,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: DatePicker(
                                labelText: 'Select Deposit Date',
                                lastDate: DateTime.now(),
                                selectedDate: finePaymentDate == null
                                    ? new DateTime(now.year, now.month, now.day - 1, 6, 30)
                                    : finePaymentDate,
                                selectDate: (selectedDate) {
                                  setState(() {
                                    finePaymentDate = selectedDate;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 3,
                                child: CustomDropDownButton(
                                  labelText: "Select Deposit Method",
                                  enabled: _isFormInputEnabled,
                                  listItems: depositMethods,
                                  selectedItem: depositMethod,
                                  validator: (value) {
                                    if (value == null) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      depositMethod = value;
                                    });
                                  },
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomDropDownButton(
                          labelText: "Select Fine",
                          enabled: _isFormInputEnabled,
                          listItems: formLoadData.containsKey("finesOptions") ? formLoadData["finesOptions"] : [],
                          selectedItem: fineId,
                          onChanged: (value) {
                            setState(() {
                              fineId = value;
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
                        CustomDropDownButton(
                          labelText: "Select Deposit Account",
                          enabled: _isFormInputEnabled,
                          listItems: formLoadData.containsKey("accountOptions") ? formLoadData["accountOptions"] : [],
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
                        SizedBox(
                          height: 10,
                        ),
                        CustomDropDownButton(
                          labelText: 'Select Member',
                          enabled: _isFormInputEnabled,
                          listItems: memberTypes,
                          selectedItem: memberTypeId,
                          onChanged: (value) {
                            setState(() {
                              memberTypeId = value;
                            });
                          },
                        ),
                        Visibility(
                          visible: memberTypeId == 1,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  children: memberWidgets.toList(),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SelectMember(
                                                  initialMembersList: selectedMembersList,
                                                ))).then((value) {
                                      setState(() {
                                        selectedMembersList = value;
                                      });
                                    });
                                  },
                                  child: Text(
                                    'Select members',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: memberTypeId == 2,
                          child: amountTextInputField(
                              context: context,
                              enabled: _isFormInputEnabled,
                              labelText: 'Enter Amount for Each Member',
                              onChanged: (value) {
                                setState(() {
                                  amountInputValue = double.parse(value);
                                });
                              },
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "Field is required";
                                }
                                return null;
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _isLoading
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : SizedBox(
                                width: 200,
                                child: defaultButton(
                                  context: context,
                                  text: "Save",
                                  onPressed: () {
                                    _submit(context);
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
