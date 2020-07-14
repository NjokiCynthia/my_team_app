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
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class AccountToAccountTransfer extends StatefulWidget {
  @override
  _AccountToAccountTransferState createState() =>
      _AccountToAccountTransferState();
}

class _AccountToAccountTransferState extends State<AccountToAccountTransfer> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final _formKey = new GlobalKey<FormState>();
  DateTime transferDate = DateTime.now();
  DateTime now = DateTime.now();
  int depositMethod;
  int fromAccountId;
  int toAccountId;
  double amount;
  String description;
  bool _isInit=true,_isLoading=false,_isFormInputEnabled=true;
  Map<String,dynamic> _formData = {},_formLoadData={};
  
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));


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
    _formLoadData = await Provider.of<Groups>(context,listen: false).loadInitialFormData(acc: true); 
    setState(() {
      _isInit = false;
    });
    Navigator.of(context,rootNavigator: true).pop();
  }

  void _submit(BuildContext context)async{
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
      _isFormInputEnabled = false;
    });
     _formKey.currentState.save();
     FocusScope.of(context).unfocus();
    _formData['transfer_date'] = transferDate.toString();
    _formData['request_id'] = requestId;
    _formData['amount'] = amount;
    _formData['from_account_id'] = fromAccountId;
    _formData['to_account_id'] = toAccountId;
    _formData['description'] = description;
    try {
      await Provider.of<Groups>(context, listen: false).recordAccountToAccountTransfer(_formData);
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
        title: "Account to Account Transfer",
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
              toolTip(context: context,title: "Funds transfer from one account to another",message: "",),
              Padding(
                padding: inputPagePadding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      DatePicker(
                        labelText: 'Select Deposit Date',
                        lastDate: DateTime.now(),
                        selectedDate: transferDate == null ? new DateTime(now.year, now.month, now.day - 1, 6, 30) : transferDate,
                        selectDate: (selectedDate) {
                          setState(() {
                            transferDate = selectedDate;
                          });
                        },
                      ),
                      CustomDropDownButton(
                        labelText: 'Select account to transfer from',
                        listItems: !_isFormInputEnabled?[]:_formLoadData.containsKey("accountOptions")?_formLoadData["accountOptions"]:[],
                        selectedItem: fromAccountId,
                        validator: (value){
                          if(value==""||value==null){
                            return "This field is required";
                          }
                          if(value==toAccountId){
                            return "Select different account";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            fromAccountId = value;
                          });
                        },
                      ),
                      CustomDropDownButton(
                        labelText: 'Select account to transfer to',
                        listItems: !_isFormInputEnabled?[]:_formLoadData.containsKey("accountOptions")?_formLoadData["accountOptions"]:[],
                        selectedItem: toAccountId,
                        validator: (value){
                          if(value==""||value==null){
                            return "This field is required";
                          }
                          if(value==fromAccountId){
                            return "Select different account";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            toAccountId = value;
                          });
                        },
                      ),
                      amountTextInputField(
                          context: context,
                          labelText: 'Enter Amount',
                          enabled: _isFormInputEnabled,
                          validator: (value){
                          if(value==""||value==null){
                            return "This field is required";
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
                        onPressed: ()=>_submit(context),
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
