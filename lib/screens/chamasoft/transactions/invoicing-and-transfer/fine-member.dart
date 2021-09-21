import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/date-picker.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../select-member.dart';

List<NamesListItem> memberTypes = [
  NamesListItem(id: 1, name: "Individual Members"),
  NamesListItem(id: 2, name: "All Members"),
];

class FineMember extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FineMemberState();
  }
}

class FineMemberState extends State<FineMember> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [];
  final _formKey = new GlobalKey<FormState>();
  DateTime fineDate = DateTime.now();
  DateTime now = DateTime.now();
  int fineTypeId;
  int memberTypeId;
  double amount;
  String description;
  bool _isInit = true, _isLoading = false, _isFormInputEnabled = true;
  Map<String, dynamic> _formLoadData = {}, _formData = {};
  List<String> _individualMembers = [];
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
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
    _formLoadData = await Provider.of<Groups>(context, listen: false)
        .loadInitialFormData(fineOptions: true);
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
    FocusScope.of(context).unfocus();
    _formData['fine_date'] = fineDate.toString();
    _formData['fine_category_id'] = fineTypeId;
    _formData['request_id'] = requestId;
    _formData['amount'] = amount;
    _formData['member_type_id'] = memberTypeId;
    _individualMembers = [];
    selectedMembersList.map((selectedMember) {
      _individualMembers.add(selectedMember.memberId);
    }).toList();
    _formData['members'] = _individualMembers;
    try {
      await Provider.of<Groups>(context, listen: false).fineMembers(_formData);
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

  Iterable<Widget> get memberWidgets sync* {
    for (MembersFilterEntry member in selectedMembersList) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: Chip(
//          avatar: CircleAvatar(child: Text(member.initials)),
          label: Text(member.name),
          onDeleted: () {
            setState(() {
              selectedMembersList.removeWhere((MembersFilterEntry entry) {
                return entry.name == member.name;
              });
            });
          },
        ),
      );
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
        title: "Fine Member",
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
              toolTip(
                context: context,
                title: "Fine members for custom fines",
                message: "",
              ),
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
                        selectedDate: fineDate == null
                            ? new DateTime(
                                now.year, now.month, now.day - 1, 6, 30)
                            : fineDate,
                        selectDate: (selectedDate) {
                          setState(() {
                            fineDate = selectedDate;
                          });
                        },
                      ),
                      CustomDropDownButton(
                        labelText: 'Select Fine type',
                        enabled: _isFormInputEnabled,
                        listItems: _formLoadData.containsKey("finesOptions")
                            ? _formLoadData["finesOptions"]
                            : [],
                        selectedItem: fineTypeId,
                        validator: (value) {
                          if (value == null || value == "") {
                            return "This field is required";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            fineTypeId = value;
                          });
                        },
                      ),
                      CustomDropDownButton(
                        labelText: 'Select Member',
                        listItems: memberTypes,
                        selectedItem: memberTypeId,
                        enabled: _isFormInputEnabled,
                        validator: (value) {
                          if (value == null || value == "") {
                            return "This field is required";
                          }
                          return null;
                        },
                        onChanged: (selected) async {
                          if (selected == 1) {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectMember(
                                          initialMembersList:
                                              selectedMembersList,
                                          //membersList: memberOptions,
                                        ))).then((value) {
                              setState(() {
                                memberTypeId = selected;
                                selectedMembersList = value;
                              });
                            });
                          } else {
                            setState(() {
                              memberTypeId = selected;
                            });
                          }
                        },
                      ),
                      Visibility(
                        visible: memberTypeId == 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Wrap(
                              children: memberWidgets.toList(),
                            ),
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () async {
                                //open select members dialog
                                await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SelectMember(
                                                initialMembersList:
                                                    selectedMembersList)))
                                    .then((value) {
                                  setState(() {
                                    selectedMembersList = value;
                                  });
                                });
                              },
                              child: Text(
                                'Select more members',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      amountTextInputField(
                          context: context,
                          enabled: _isFormInputEnabled,
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "Field is required";
                            }
                            return null;
                          },
                          labelText: 'Enter Amount to fine',
                          onChanged: (value) {
                            setState(() {
                              amount = double.parse(value);
                            });
                          }),
                      multilineTextField(
                          context: context,
                          labelText: 'Short Description (Optional)',
                          maxLines: 5,
                          enabled: _isFormInputEnabled,
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
                              child: Center(child: CircularProgressIndicator()),
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
      ),
    );
  }
}
