import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
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
  List<dynamic> _data = [];
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

  Map<String, dynamic> getContribution(dynamic id) {
    return _groupContributions.where((c) => c['id'] == id).toList()[0];
  }

  Map<String, dynamic> getLoanTypes(dynamic id) {
    return _groupLoanTypes.where((l) => l['id'] == id).toList()[0];
  }

  void _newCollectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewCollectionDialog(
          selected: (val) {
            setState(() {
              // _selected = val;
              // print(_selected);
              Map<String, dynamic> _member = {};
              Map<String, dynamic> _contribution = {};
              Map<String, dynamic> _loan = {};
              _member = getMember(val['member_id']);
              if (val['type'] == "contributions")
                _contribution = getContribution(val['contribution_id']);
              else
                _loan = getContribution(val['loan_id']);
              // print(_member);
              // print(_contribution);
              // print(_loan);
              _data.add({
                'member': _member,
                'contribution': _contribution,
                'loan': _loan,
                'type': val['type'],
                'amount': int.parse(val['amount']),
              });
              widget.collections(_data);
              print(_data);
            });
          },
          type: widget.type,
          groupMembers: _groupMembers,
          groupContributions: _groupContributions,
          groupLoans: _groupLoanTypes,
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
    await group.fetchMembers();
    await group.fetchContributions();
    await group.fetchLoanTypes();
    setState(() {
      _groupCurrency = currentGroup.groupCurrency;
      // Iterate group members
      group.members.forEach((m) {
        _groupMembers.add({
          'id': m.id,
          'name': m.name,
          'identity': m.identity,
          'avatar': m.avatar,
          'userId': m.userId,
        });
      });
      // Iterate group contributions
      group.contributions.forEach((c) {
        if (c.active == '1' && c.isHidden == '0') {
          _groupContributions.add({
            'id': c.id,
            'name': c.name,
            'amount': c.amount,
            'type': c.type,
          });
        }
      });
      // Iterate group loan types
      group.loanTypes.forEach((l) {
        // if (l.isHidden == false) {
        _groupLoanTypes.add({
          'id': l.id,
          'disbursementDate': l.disbursementDate,
          'guarantors': l.guarantors,
          'interestRate': l.interestRate,
          'latePaymentFines': l.latePaymentFines,
          'loanAmount': l.loanAmount,
          'loanProcessing': l.loanProcessing,
          'name': l.name,
          'outstandingPaymentFines': l.outstandingPaymentFines,
          'repaymentPeriod': l.repaymentPeriod,
          'isHidden': l.isHidden,
        });
        // }
      });
      _data = widget.recorded[widget.type];
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
            color: Theme.of(context).textSelectionHandleColor,
          ),
          content: customTitleWithWrap(
            text:
                "Are you sure you want to remove this ${_title.toString().toLowerCase()}?",
            textAlign: TextAlign.start,
            color: Theme.of(context).textSelectionHandleColor,
            maxLines: null,
          ),
          actions: <Widget>[
            negativeActionDialogButton(
              text: "Cancel",
              color: Theme.of(context).textSelectionHandleColor,
              action: () {
                Navigator.of(context).pop();
              },
            ),
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
                                      .textSelectionHandleColor,
                                ),
                                subtitle2(
                                  text:
                                      "You can add or remove ${widget.type} from the list",
                                  color: Theme.of(context)
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
                                  .textSelectionHandleColor
                                  .withOpacity(0.5),
                              height: 0.0,
                            ),
                            itemCount: _data.length,
                            itemBuilder: (context, index) {
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
                                                  .textSelectionHandleColor,
                                              textAlign: TextAlign.start,
                                            ),
                                            subtitle2(
                                              text: _data[index]['member']
                                                  ['identity'],
                                              color: Theme.of(context)
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
                                                        : Colors.brown
                                                            .withOpacity(0.1),
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
                                                        : _data[index]
                                                                [widget.type]
                                                            ['name'],
                                                    style: TextStyle(
                                                      color: widget.type ==
                                                              "contributions"
                                                          ? Colors.green[700]
                                                          : widget.type ==
                                                                  "repayments"
                                                              ? Colors.cyan[700]
                                                              : Colors.brown,
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
  final List<dynamic> groupLoans;
  final ValueChanged<dynamic> selected;
  NewCollectionDialog({
    @required this.type,
    @required this.groupMembers,
    @required this.groupContributions,
    @required this.groupLoans,
    @required this.selected,
  });
  @override
  _NewCollectionDialogState createState() => new _NewCollectionDialogState();
}

class _NewCollectionDialogState extends State<NewCollectionDialog> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _selected = {};
  String title = "";

  String getAlertText() {
    String _resp = "You're not allowed to do anything here";
    if (widget.groupMembers.length == 0)
      _resp = "There are no group members found";
    else if (widget.groupContributions.length == 0)
      _resp = "There are no group contributions found";
    else if (widget.groupLoans.length == 0)
      _resp = "There are no loan types found";
    return _resp + ", you cannot continue.";
  }

  @override
  void initState() {
    if (widget.type == 'contributions') {
      title = "Group Contribution";
      _selected = {
        'member_id': '',
        'contribution_id': '',
        'amount': '',
        'type': widget.type,
      };
    } else if (widget.type == 'repayments') {
      title = "Loan Repayment";
      _selected = {
        'member_id': '',
        'loan_id': '',
        'amount': '',
        'type': widget.type,
      };
    } else if (widget.type == 'disbursements') {
      title = "Loan Disbursement";
      _selected = {
        'member_id': '',
        'loan_id': '',
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
        color: Theme.of(context).textSelectionHandleColor,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ((widget.groupContributions.length == 0 &&
                        widget.type == "contributions") ||
                    (widget.groupLoans.length == 0 &&
                        (widget.type == "repayments" ||
                            widget.type == "disbursements")) ||
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
                });
              },
              onChanged: (value) {
                setState(() {
                  _selected['member_id'] = value;
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
            (widget.type == "repayments" || widget.type == "disbursements")
                ? SizedBox(height: 20.0)
                : SizedBox(),
            (widget.type == "repayments" || widget.type == "disbursements")
                ? DropDownFormField(
                    titleText: 'Loan Type',
                    hintText: 'Select group loan type',
                    dataSource: widget.groupLoans,
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
                        return "Loan type is required";
                      else
                        return null;
                    },
                  )
                : SizedBox(),
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
          color: Theme.of(context).textSelectionHandleColor,
          action: () {
            Navigator.of(context).pop();
          },
        ),
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
