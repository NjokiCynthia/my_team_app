import 'package:chamasoft/providers/groups.dart';
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
import 'package:chamasoft/providers/helpers/setting_helper.dart';
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
  int depositMethod,memberId,accountId;
  double amount;
  String description;
  final _formKey = new GlobalKey<FormState>();
  bool _isFormInputEnabled = true;
  Map<String, dynamic> _formData = {};
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));
  bool _isLoading = false;

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

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
      _isFormInputEnabled = false;
    });
    _formKey.currentState.save();
    _formData['request_id'] = requestId;
    _formData["deposit_date"] = depositDate.toString();
    _formData["deposit_method"] = depositMethod;
    _formData["member_id"] = memberId;
    _formData["account_id"] = accountId;
    _formData["amount"] = amount;
    _formData["description"] = description;

    try {
      await Provider.of<Groups>(context, listen: false).recordMiscellaneousPayments(_formData);
      Navigator.of(context).pop();
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
              Padding(
                padding: inputPagePadding,
                child: Form(
                  key:_formKey,
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
                              enabled: _isFormInputEnabled,
                              listItems: depositMethods,
                              selectedItem: depositMethod,
                              validator: (value){
                                if(value==""||value==null){
                                  return "Field is required";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  depositMethod = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      CustomDropDownButton(
                        labelText: 'Select Member',
                        enabled: _isFormInputEnabled,
                        listItems: formLoadData.containsKey("memberOptions")?formLoadData["memberOptions"]:[],
                        selectedItem: memberId,
                        validator: (value){
                          if(value==""||value==null){
                            return "Field is required";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            memberId = value;
                          });
                        },
                      ),
                      CustomDropDownButton(
                        labelText: 'Select Account',
                        enabled: _isFormInputEnabled,
                        listItems: formLoadData.containsKey("accountOptions")?formLoadData["accountOptions"]:[],
                        selectedItem: accountId,
                        validator: (value){
                          if(value==""||value==null){
                            return "Field is required";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            accountId = value;
                          });
                        },
                      ),
                      amountTextInputField(
                          context: context,
                          labelText: 'Enter Amount',
                          enabled: _isFormInputEnabled,
                          validator: (value){
                            if(value==""||value==null){
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
                      _isLoading
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: CircularProgressIndicator()
                          ),
                      ): 
                      defaultButton(
                        context: context,
                        text: "SAVE",
                        onPressed: () {
                          _submit(context);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
