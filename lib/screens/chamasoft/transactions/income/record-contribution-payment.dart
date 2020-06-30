import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/helpers/setting_helper.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../select-member.dart';

class RecordContributionPayment extends StatefulWidget {
  @override
  _RecordContributionPaymentState createState() => _RecordContributionPaymentState();
}

class _RecordContributionPaymentState extends State<RecordContributionPayment> {
  bool _isInit = true;
  bool _isLoading = false;
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [];
  int memberTypeId;
  final _formKey = new GlobalKey<FormState>();
  DateTime contributionDate = DateTime.now();
  final now = DateTime.now();
  int depositMethod;
  int contributionId;
  int accountId;
  String contributionAmount;
  Map<String, dynamic> _formData = {};
  String selectedContributionValue;
  String selectedAccountValue;
  String selectedMemberType;
  List<NamesListItem> contributionOptions = [];
  List<NamesListItem> accountOptions = [];
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

  Future<void> _fetchDefaultValues(BuildContext context) async {
    List<Contribution> contributions = Provider.of<Groups>(context, listen: false).contributions;
    if (contributions.length == 0) {
      await Provider.of<Groups>(context, listen: false).fetchContributions();
      contributions = Provider.of<Groups>(context, listen: false).contributions;
    }
    List<NamesListItem> emptyContributions = [];
    contributions.map((element) => emptyContributions.add(NamesListItem(id: int.tryParse(element.id), name: element.name))).toList();

    List<List<Account>> accounts = Provider.of<Groups>(context, listen: false).allAccounts;
    if (accounts.length == 0) {
      await Provider.of<Groups>(context, listen: false).fetchAccounts();
      accounts = Provider.of<Groups>(context, listen: false).allAccounts;
    }
    List<NamesListItem> emptyAccountOptions = [];
    for (var account in accounts) {
      for (var typeAccount in account) {
        print("id: ${typeAccount.uniqueId}");
        emptyAccountOptions.add(NamesListItem(id: typeAccount.uniqueId, name: typeAccount.name));
      }
    }
    print(emptyAccountOptions);
    setState(() {
      contributionOptions = emptyContributions;
      accountOptions = emptyAccountOptions;
      _isInit = false;
    });
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      print("validation failed");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState.save();
    _formData['deposit_date'] = contributionDate.toString();
    _formData['deposit_method'] = depositMethod;
    _formData['contribution_id'] = contributionId;
    _formData['account_id'] = accountId;
    _formData['request_id'] = requestId;
    _formData['amount'] = contributionAmount;
    try {
      await Provider.of<Groups>(context, listen: false).recordContibutionPayments(_formData);
    } on CustomException catch (error) {
      print("Error: ${error.toString()}");
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _submit(context);
          });
    } finally {
      setState(() {
        _isLoading = false;
        //_isFormInputEnabled = true;
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
//          avatar: CircleAvatar(child: Text(member.initials)),
        title: Text(member.name, style: TextStyle(color: Color(0xFFB3C7D9), fontWeight: FontWeight.w700)),
        contentPadding: EdgeInsets.all(4.0),
        subtitle: Text(
          member.phoneNumber,
          style: TextStyle(color: Color(0xFFB3C7D9)),
        ),
        trailing: Container(
          width: 250.0,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: amountTextInputField(
                    context: context,
                    labelText: 'Enter Amount',
                    onChanged: (value) {
                      member.amount = value;
                    }),
              ),
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
        title: "Record Contribution Payment",
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                toolTip(context: context, title: "Note that...", message: "Manually record contribution payments", showTitle: false),
                Padding(
                  padding: inputPagePadding,
                  child: Form(
                    key: _formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: DatePicker(
                              labelText: 'Select Deposit Date',
                              lastDate: DateTime.now(),
                              selectedDate: contributionDate == null ? new DateTime(now.year, now.month, now.day - 1, 6, 30) : contributionDate,
                              selectDate: (selectedDate) {
                                setState(() {
                                  contributionDate = selectedDate;
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
                      SizedBox(
                        height: 10,
                      ),
                      CustomDropDownButton(
                        labelText: "Select Contribution",
                        listItems: contributionOptions,
                        selectedItem: contributionId,
                        onChanged: (value) {
                          setState(() {
                            contributionId = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomDropDownButton(
                        labelText: "Select Account",
                        listItems: accountOptions,
                        selectedItem: accountId,
                        onChanged: (value) {
                          setState(() {
                            accountId = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomDropDownButton(
                        labelText: 'Select Member',
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
                                  //open select members dialog
                                  selectedMembersList = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SelectMember(
                                                initialMembersList: selectedMembersList,
                                              )));
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
                            labelText: 'Enter Amount',
                            onChanged: (value) {
                              contributionAmount = value;
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : defaultButton(
                              context: context,
                              text: "SAVE",
                              onPressed: () {
                                selectedMembersList.map((MembersFilterEntry mem) {
                                  return print(mem.name);
                                }).toList();
                                _submit(context);
                              },
                            )
                    ]),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
