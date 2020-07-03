import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/date-picker.dart';
import 'package:chamasoft/providers/helpers/setting_helper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

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
  int refundMethod;
  NamesListItem depositMethodValue;
  int depositorId;
  int groupMemberId;
  int incomeCategoryId;
  int accountId;
  double amount;
  String description;
  bool _isInit = true;
  Map<String, dynamic> _formData = {};
  bool _isFormInputEnabled = true;
  Map <String,dynamic> formLoadData = {};

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
    formLoadData = await Provider.of<Groups>(context,listen: false).loadInitialFormData(acc:true,incomeCats: true); 
    setState(() {
      _isInit = false;
    });
    Navigator.of(context,rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Record Income",
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
                  title: "Manually record income payments",
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
                      labelText: 'Select Deposit Date',
                      lastDate: DateTime.now(),
                      selectedDate: incomeDate == null ? new DateTime(now.year, now.month, now.day - 1, 6, 30) : incomeDate,
                      selectDate: (selectedDate) {
                        setState(() {
                          incomeDate = selectedDate;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Depositor',
                      listItems: formLoadData.containsKey("depositorOptions")?formLoadData["depositorOptions"]:[],
                      selectedItem: depositorId,
                      onChanged: (value) {
                        setState(() {
                          depositorId = value;
                        });
                      },
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Income Category',
                      listItems: formLoadData.containsKey("incomeCategoryOptions")?formLoadData["incomeCategoryOptions"]:[],
                      selectedItem: incomeCategoryId,
                      onChanged: (value) {
                        setState(() {
                          incomeCategoryId = value;
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
                    CustomDropDownButton(
                      labelText: 'Select Deposit Method',
                      listItems: depositMethods,
                      selectedItem: refundMethod,
                      onChanged: (value) {
                        setState(() {
                          refundMethod = value;
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
                        maxLines : 3,
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
