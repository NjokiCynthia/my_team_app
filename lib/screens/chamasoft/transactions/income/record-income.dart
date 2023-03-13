import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/reports/deposit-receipts.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/date-picker.dart';
import 'package:chamasoft/helpers/setting_helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';

List<NamesListItem> depositors = [
  NamesListItem(id: 1, name: "Peter Parker"),
  NamesListItem(id: 2, name: "Tony Stark"),
  NamesListItem(id: 3, name: "Stephen Strange"),
];
List<NamesListItem> incomeCategories = [
  NamesListItem(id: 1, name: "Tax Refunds"),
  NamesListItem(id: 2, name: "Dividends"),
  NamesListItem(id: 3, name: "Share Profits"),
];

class RecordIncome extends StatefulWidget {
  @override
  _RecordIncomeState createState() => _RecordIncomeState();
}

class _RecordIncomeState extends State<RecordIncome> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final formKey = new GlobalKey<FormState>();
  bool toolTipIsVisible = true;
  DateTime incomeDate = DateTime.now();
  DateTime now = DateTime.now();
  int depositMethod;
  int depositorId;
  int groupMemberId;
  int incomeCategoryId;
  int accountId;
  double amount;
  String description;
  bool _isInit = true;
  Map<String, dynamic> _formData = {};
  bool _isFormInputEnabled = true;
  static final int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String requestId = ((epochTime.toDouble() / 1000).toStringAsFixed(0));
  Map<String, dynamic> formLoadData = {};
  final _formKey = new GlobalKey<FormState>();
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
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
    formLoadData = await Provider.of<Groups>(context, listen: false)
        .loadInitialFormData(acc: true, incomeCats: true, depositor: true);
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
    _formData['deposit_date'] = incomeDate.toString();
    _formData["depositor_id"] = depositorId;
    _formData["income_category_id"] = incomeCategoryId;
    _formData["account_id"] = accountId;
    _formData["deposit_method"] = depositMethod;
    _formData["amount"] = amount;
    _formData["description"] = description;
    _formData["request_id"] = requestId;
    try {
      String message = await Provider.of<Groups>(context, listen: false)
          .recordIncomePayment(_formData);
      StatusHandler().showSuccessSnackBar(context, message);

      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DepositReceipts()));
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
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.times_circle,
        title: "Record Income",
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
                  toolTip(
                      context: context,
                      message: "",
                      title: "Manually record income payment",
                      showTitle: true),
                  Padding(
                    padding: inputPagePadding,
                    // height: MediaQuery.of(context).size.height,
                    // color: Theme.of(context).backgroundColor,
                    child: Form(
                      key: _formKey,
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
                                  selectedDate: incomeDate == null
                                      ? new DateTime(now.year, now.month,
                                          now.day - 1, 6, 30)
                                      : incomeDate,
                                  selectDate: (selectedDate) {
                                    setState(() {
                                      incomeDate = selectedDate;
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
                                  labelText: 'Select Deposit Method',
                                  enabled: _isFormInputEnabled,
                                  listItems: depositMethods,
                                  selectedItem: depositMethod,
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return "Field required";
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
                            labelText: 'Select Depositor',
                            enabled: _isFormInputEnabled,
                            listItems:
                                formLoadData.containsKey("depositorOptions")
                                    ? formLoadData["depositorOptions"]
                                    : [],
                            selectedItem: depositorId,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Field required";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                depositorId = value;
                              });
                            },
                          ),
                          CustomDropDownButton(
                            labelText: 'Select Income Category',
                            enabled: _isFormInputEnabled,
                            listItems: formLoadData
                                    .containsKey("incomeCategoryOptions")
                                ? formLoadData["incomeCategoryOptions"]
                                : [],
                            selectedItem: incomeCategoryId,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Field required";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                incomeCategoryId = value;
                              });
                            },
                          ),
                          CustomDropDownButton(
                            labelText: 'Select Account',
                            enabled: _isFormInputEnabled,
                            listItems:
                                formLoadData.containsKey("accountOptions")
                                    ? formLoadData["accountOptions"]
                                    : [],
                            selectedItem: accountId,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Field required";
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
                            enabled: _isFormInputEnabled,
                            labelText: 'Enter Amount',
                            onChanged: (value) {
                              setState(() {
                                amount = double.parse(value);
                              });
                            },
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Field required";
                              }
                              return null;
                            },
                          ),
                          multilineTextField(
                              maxLines: 30,
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
                                      child: CircularProgressIndicator()),
                                )
                              : defaultButton(
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
          );
        },
      ),
    );
  }
}
