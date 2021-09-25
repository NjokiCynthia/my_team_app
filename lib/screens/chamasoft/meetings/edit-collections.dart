import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class EditCollections extends StatefulWidget {
  final String type;
  final Map<String, dynamic> recorded;
  final ValueChanged<dynamic> collections;
  EditCollections({
    @required this.type,
    @required this.collections,
    @required this.recorded,
  });
  @override
  _EditCollectionsState createState() => _EditCollectionsState();
}

class _EditCollectionsState extends State<EditCollections> {
  String _title = "Manage Collection";
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isLoading = true;
  bool _isInit = true;
  List<dynamic> _groupMembers = [];
  List<dynamic> _groupContributions = [];
  List<dynamic> _groupLoanTypes = [];
  List<dynamic> _groupMemberLoanOptions = [];
  List<dynamic> _memberLoanOptions = [];
  List<dynamic> _groupAccounts = [];
  List<dynamic> _groupFineCategories = [];
  List<dynamic> _data = [];
  Map<String, dynamic> formLoadData = {};
  String _groupCurrency = "KES";
  var formatter = NumberFormat('#,##,##0', "en_US");

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Map<String, dynamic> getMember(dynamic id) {
    return _groupMembers.where((m) => m['id'] == id).toList()[0];
  }

  Map<String, dynamic> getGroupAccount(dynamic id) {
    return _groupAccounts.where((m) => m['id'] == id).toList()[0];
  }

  Map<String, dynamic> getContribution(dynamic id) {
    return _groupContributions.where((c) => c['id'] == id).toList()[0];
  }

  Map<String, dynamic> getFine(dynamic id) {
    return _groupFineCategories.where((f) => f['id'] == id).toList()[0];
  }

  Map<String, dynamic> getLoanTypes(dynamic id) {
    return _groupLoanTypes.where((l) => l['id'] == id).toList()[0];
  }

  Map<String, dynamic> getMemberLoan(dynamic id) {
    return _memberLoanOptions.where((l) => l['id'] == id).toList()[0];
  }

  List<dynamic> _convertToDataSource(List<NamesListItem> formData) {
    if (formData.length > 0) {
      List<dynamic> _result = [];
      formData.forEach((element) {
        String identity = "";
        try {
          identity = element.identity;
        } catch (err) {}
        _result.add({
          "id": element.id,
          "name": element.name,
          "identity": identity,
          "account_id": Provider.of<Groups>(context, listen: false)
              .getAccountFormId(element.id),
        });
      });
      return _result;
    }
    return [];
  }

  void _newCollectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewCollectionDialog(
          selected: (val) {
            setState(() {
              // print("val >>>> ");
              // print(val);
              Map<String, dynamic> _member = {};
              Map<String, dynamic> _contribution = {};
              Map<String, dynamic> _loan = {};
              Map<String, dynamic> _fine = {};
              _member = getMember(val['member_id']);
              if (val['type'] == "contributions")
                _contribution = getContribution(val['contribution_id']);
              else if (val['type'] == "fines")
                _fine = getFine(val['fine_id']);
              else if (val['type'] == "repayments")
                _loan = getMemberLoan(val['loan_id']);
              else
                _loan = getLoanTypes(val['loan_type_id']);
              // print(_member);
              _data.add({
                'member': _member,
                'contribution': _contribution,
                'loans': _loan,
                'type': val['type'],
                'fines': _fine,
                'account': getGroupAccount(val['account_id']),
                'amount': int.parse(val['amount']),
              });
              widget.collections(_data);
              print("Collections >>>>>>>>>>");
              print(_data);
            });
          },
          type: widget.type,
          groupMembers: _groupMembers,
          groupContributions: _groupContributions,
          groupLoanTypes: _groupLoanTypes,
          groupAccounts: _groupAccounts,
          groupFines: _groupFineCategories,
          groupMemberLoans: _groupMemberLoanOptions,
          groupCurrency: _groupCurrency,
        );
      },
    );
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final group = Provider.of<Groups>(context, listen: false);
    final currentGroup = group.getCurrentGroup();
    // List<dynamic> _fineCats = await group.fetchFineCategories();
    formLoadData = await group.loadInitialFormData(
        acc: true,
        fineOptions: true,
        member: true,
        contr: true,
        loanTypes: true,
        memberOngoingLoans: true);
    print(group.members);
    setState(() {
      _groupFineCategories = _convertToDataSource(
          formLoadData.containsKey("finesOptions")
              ? formLoadData["finesOptions"]
              : []);
      _groupCurrency = currentGroup.groupCurrency;
      _groupAccounts = _convertToDataSource(
          formLoadData.containsKey("accountOptions")
              ? formLoadData["accountOptions"]
              : []);
      _groupMembers = _convertToDataSource(
          formLoadData.containsKey("memberOptions")
              ? formLoadData["memberOptions"]
              : []);
      _groupContributions = _convertToDataSource(
          formLoadData.containsKey("contributionOptions")
              ? formLoadData["contributionOptions"]
              : []);
      _groupLoanTypes = _convertToDataSource(
          formLoadData.containsKey("loanTypeOptions")
              ? formLoadData["loanTypeOptions"]
              : []);
      _memberLoanOptions = _convertToDataSource(
          formLoadData.containsKey("memberOngoingLoanOptions")
              ? formLoadData["memberOngoingLoanOptions"]
              : []);
      _groupMemberLoanOptions =
          Provider.of<Groups>(context, listen: false).getMemberOngoingLoans;
      _data = widget.recorded[widget.type];
      print("data >>>>>>> $_data");
      _isLoading = false;
      _isInit = false;
    });
    return true;
  }

  void _removeCollectionDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
            text: "Remove $_title",
            textAlign: TextAlign.start,
            // ignore: deprecated_member_use
            color: Theme.of(context).textSelectionHandleColor,
          ),
          content: customTitleWithWrap(
            text:
                "Are you sure you want to remove this ${_title.toString().toLowerCase()}?",
            textAlign: TextAlign.start,
            // ignore: deprecated_member_use
            color: Theme.of(context).textSelectionHandleColor,
            maxLines: null,
          ),
          actions: <Widget>[
            negativeActionDialogButton(
              text: "Cancel",
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionHandleColor,
              action: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
            FlatButton(
              padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
              child: customTitle(
                text: "Yes, remove",
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _data.removeAt(index);
                  widget.collections(_data);
                });
              },
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4.0),
              ),
              textColor: Colors.red,
              color: Colors.red.withOpacity(0.15),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    if (widget.type == 'contributions')
      _title = "Group Contribution";
    else if (widget.type == 'repayments')
      _title = "Loan Repayment";
    else if (widget.type == 'disbursements') _title = "Loan Disbursement";
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
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "${_title}s",
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              tooltip: "Add New",
              icon: Icon(
                Icons.add,
                // ignore: deprecated_member_use
                color: Theme.of(context).textSelectionHandleColor,
              ),
              onPressed: _isLoading ? null : () => _newCollectionDialog(),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
            )
          : Builder(
              builder: (BuildContext context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      color: (themeChangeProvider.darkTheme)
                          ? Colors.blueGrey[800]
                          : Color(0xffededfe),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.lightbulb_outline,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
                            size: 24.0,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                subtitle1(
                                  text: "About ${widget.type}",
                                  textAlign: TextAlign.start,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                ),
                                subtitle2(
                                  text:
                                      "You can add or remove ${widget.type} from the list",
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _data.length > 0
                        ? ListView.separated(
                            controller: _scrollController,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Divider(
                              color: Theme.of(context)
                                  // ignore: deprecated_member_use
                                  .textSelectionHandleColor
                                  .withOpacity(0.5),
                              height: 0.0,
                            ),
                            itemCount: _data.length,
                            itemBuilder: (context, index) {
                              print("data here >>>> $_data");
                              return Container(
                                padding: EdgeInsets.fromLTRB(
                                  20.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            subtitle1(
                                              text: _data[index]['member']
                                                  ['name'],
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionHandleColor,
                                              textAlign: TextAlign.start,
                                            ),
                                            subtitle2(
                                              text: _data[index]['member']
                                                  ['identity'],
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionHandleColor,
                                              textAlign: TextAlign.start,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                color: widget.type ==
                                                        "contributions"
                                                    ? Colors.green[700]
                                                        .withOpacity(0.1)
                                                    : widget.type ==
                                                            "repayments"
                                                        ? Colors.cyan[700]
                                                            .withOpacity(0.1)
                                                        : widget.type == "fines"
                                                            ? Colors.red[700]
                                                                .withOpacity(
                                                                    0.1)
                                                            : Colors.brown
                                                                .withOpacity(
                                                                    0.1),
                                              ),
                                              padding: EdgeInsets.fromLTRB(
                                                8.0,
                                                2.0,
                                                8.0,
                                                2.0,
                                              ),
                                              margin: EdgeInsets.only(
                                                top: 6.0,
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    widget.type ==
                                                            "contributions"
                                                        ? _data[index]
                                                                ['contribution']
                                                            ['name']
                                                        : (widget.type ==
                                                                    "disbursements" ||
                                                                widget.type ==
                                                                    "repayments")
                                                            ? _data[index]
                                                                    ["loans"]
                                                                ['name']
                                                            : _data[index]
                                                                    ["fines"]
                                                                ['name'],
                                                    style: TextStyle(
                                                      color: widget.type ==
                                                              "contributions"
                                                          ? Colors.green[700]
                                                          : widget.type ==
                                                                  "repayments"
                                                              ? Colors.cyan[700]
                                                              : widget.type ==
                                                                      "fines"
                                                                  ? Colors
                                                                      .red[700]
                                                                  : Colors
                                                                      .brown,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 22.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            _groupCurrency,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionHandleColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Text(
                                            formatter
                                                .format(_data[index]['amount']),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionHandleColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 6.0,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 18.0,
                                            ),
                                            onPressed: () =>
                                                _removeCollectionDialog(index),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Flexible(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              alignment: Alignment.center,
                              child: emptyList(
                                color: Colors.blue[400],
                                iconData: LineAwesomeIcons.file_text,
                                text: "There's nothing to show",
                              ),
                            ),
                          ),
                  ],
                );
              },
            ),
      floatingActionButton: Visibility(
        visible: !_isLoading,
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
        ),
      ),
    );
  }
}

class NewCollectionDialog extends StatefulWidget {
  final String type;
  final List<dynamic> groupMembers;
  final List<dynamic> groupContributions;
  final List<dynamic> groupLoanTypes;
  final List<dynamic> groupAccounts;
  final List<dynamic> groupFines;
  final List<dynamic> groupMemberLoans;
  final ValueChanged<dynamic> selected;
  final String groupCurrency;
  NewCollectionDialog({
    @required this.type,
    @required this.groupMembers,
    @required this.groupContributions,
    @required this.groupLoanTypes,
    @required this.groupAccounts,
    @required this.groupFines,
    @required this.selected,
    @required this.groupMemberLoans,
    @required this.groupCurrency,
  });
  @override
  _NewCollectionDialogState createState() => new _NewCollectionDialogState();
}

class _NewCollectionDialogState extends State<NewCollectionDialog> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _selected = {};
  String title = "";
  List<dynamic> memberLoans = [];

  String getAlertText() {
    String _resp = "You're not allowed to do anything here";
    if (widget.groupMembers.length == 0)
      _resp = "There are no group members found";
    if (widget.type == 'contributions' && widget.groupContributions.length == 0)
      _resp = "There are no group contributions found";
    if (widget.type == 'disbursements' && widget.groupLoanTypes.length == 0)
      _resp = "There are no loan types found";
    if (widget.type == 'repayments' && widget.groupMemberLoans.length == 0)
      _resp = "There are no member loans to repay";
    return _resp + ", you cannot continue.";
  }

  void _prepareMemberLoans(String currency, String selectedMemberID) {
    List<dynamic> _result = [];
    if (widget.groupMemberLoans != null && widget.groupMemberLoans.isNotEmpty) {
      for (var loan in widget.groupMemberLoans) {
        if (loan.memberId == selectedMemberID) {
          _result.add({
            "id": int.tryParse(loan.id),
            "name":
                "${loan.loanType} of $currency ${currencyFormat.format(loan.amount)} balance $currency ${currencyFormat.format(loan.balance)}"
          });
        }
      }
    }
    setState(() {
      memberLoans.clear();
      memberLoans = _result;

      print("member loans >>  $memberLoans and result $_result");
    });
  }

  @override
  void initState() {
    if (widget.type == 'contributions') {
      title = "Group Contribution";
      _selected = {
        'member_id': '',
        'contribution_id': '',
        'account_id': '',
        'amount': '',
        'type': widget.type,
      };
    } else if (widget.type == 'repayments') {
      title = "Loan Repayment";
      _selected = {
        'member_id': '',
        'loan_id': '',
        'account_id': '',
        'amount': '',
        'type': widget.type,
      };
    } else if (widget.type == 'disbursements') {
      title = "Loan Disbursement";
      _selected = {
        'member_id': '',
        'loan_type_id': '',
        'account_id': '',
        'amount': '',
        'type': widget.type,
      };
    } else if (widget.type == 'fines') {
      title = "Fine Payment";
      _selected = {
        'member_id': '',
        'fine_id': '',
        'account_id': '',
        'amount': '',
        'type': widget.type,
      };
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      title: heading2(
        text: "New $title",
        textAlign: TextAlign.start,
        // ignore: deprecated_member_use
        color: Theme.of(context).textSelectionHandleColor,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ((widget.groupContributions.length == 0 &&
                        widget.type == "contributions") ||
                    (widget.groupMemberLoans.length == 0 &&
                        widget.type == "repayments") ||
                    (widget.type == "disbursements" &&
                        widget.groupLoanTypes.length == 0) ||
                    widget.groupMembers.length == 0)
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2),
                      ),
                      color: Colors.red.withOpacity(0.15),
                    ),
                    padding: EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      children: [
                        Text(
                          getAlertText(),
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            DropDownFormField(
              titleText: 'Group Member',
              hintText: 'Select group member',
              dataSource: widget.groupMembers,
              textField: 'name',
              valueField: 'id',
              filled: false,
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              value: _selected['member_id'],
              onSaved: (value) {
                setState(() {
                  _selected['member_id'] = value;
                  _prepareMemberLoans(widget.groupCurrency, value.toString());
                });
              },
              onChanged: (value) {
                setState(() {
                  _selected['member_id'] = value;
                  _prepareMemberLoans(widget.groupCurrency, value.toString());
                });
              },
              validator: (value) {
                if (value == null)
                  return "Member is required";
                else
                  return null;
              },
            ),
            widget.type == "contributions"
                ? SizedBox(height: 20.0)
                : SizedBox(),
            widget.type == "contributions"
                ? DropDownFormField(
                    titleText: 'Group Contribution',
                    hintText: 'Select group contribution',
                    dataSource: widget.groupContributions,
                    textField: 'name',
                    valueField: 'id',
                    filled: false,
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    value: _selected['contribution_id'],
                    onSaved: (value) {
                      setState(() {
                        _selected['contribution_id'] = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _selected['contribution_id'] = value;
                      });
                    },
                    validator: (value) {
                      if (value == null)
                        return "Contribution is required";
                      else
                        return null;
                    },
                  )
                : SizedBox(),
            (widget.type == "disbursements")
                ? SizedBox(height: 20.0)
                : SizedBox(),
            (widget.type == "disbursements")
                ? DropDownFormField(
                    titleText: 'Loan Type',
                    hintText: 'Select group loan type',
                    dataSource: widget.groupLoanTypes,
                    textField: 'name',
                    valueField: 'id',
                    filled: false,
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    value: _selected['loan_type_id'],
                    onSaved: (value) {
                      setState(() {
                        _selected['loan_type_id'] = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _selected['loan_type_id'] = value;
                      });
                    },
                    validator: (value) {
                      if (value == null)
                        return "Loan type is required";
                      else
                        return null;
                    },
                  )
                : SizedBox(),
            (widget.type == "repayments") ? SizedBox(height: 20.0) : SizedBox(),
            (widget.type == "repayments")
                ? DropDownFormField(
                    titleText: 'Member Loan',
                    hintText: 'Select member ongoing loan',
                    dataSource: memberLoans,
                    textField: 'name',
                    valueField: 'id',
                    filled: false,
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    value: _selected['loan_id'],
                    onSaved: (value) {
                      setState(() {
                        _selected['loan_id'] = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _selected['loan_id'] = value;
                      });
                    },
                    validator: (value) {
                      if (value == null)
                        return "Member loan is required";
                      else
                        return null;
                    },
                  )
                : SizedBox(),
            (widget.type == "fines") ? SizedBox(height: 20.0) : SizedBox(),
            widget.type == "fines"
                ? DropDownFormField(
                    titleText: 'Fine Category',
                    hintText: 'Select group fine category',
                    dataSource: widget.groupFines,
                    textField: 'name',
                    valueField: 'id',
                    filled: false,
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    value: _selected['fine_id'],
                    onSaved: (value) {
                      setState(() {
                        _selected['fine_id'] = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _selected['fine_id'] = value;
                      });
                    },
                    validator: (value) {
                      if (value == null)
                        return "Fine category is required";
                      else
                        return null;
                    },
                  )
                : SizedBox(),
            SizedBox(height: 20.0),
            DropDownFormField(
              titleText: 'Group Account',
              hintText: 'Select group account',
              dataSource: widget.groupAccounts,
              textField: 'name',
              valueField: 'id',
              filled: false,
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              value: _selected['account_id'],
              onSaved: (value) {
                setState(() {
                  _selected['account_id'] = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  _selected['account_id'] = value;
                });
              },
              validator: (value) {
                if (value == null)
                  return "Account is required";
                else
                  return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              validator: (val) {
                if (val.isEmpty)
                  return "Amount is required";
                else {
                  setState(() {
                    _selected['amount'] = val;
                  });
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'Set amount',
                contentPadding: EdgeInsets.only(bottom: 0.0),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        negativeActionDialogButton(
          text: "Cancel",
          // ignore: deprecated_member_use
          color: Theme.of(context).textSelectionHandleColor,
          action: () {
            Navigator.of(context).pop();
          },
        ),
        // ignore: deprecated_member_use
        FlatButton(
          padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
          child: customTitle(
            text: "Save Changes",
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.of(context).pop();
              print(">>> $_selected");
              widget.selected(_selected);
            }
          },
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(4.0),
          ),
          textColor: primaryColor,
          color: primaryColor.withOpacity(0.15),
        )
      ],
    );
  }
}
