import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class EditCollections extends StatefulWidget {
  final String type;
  final Map<dynamic, dynamic> recorded;
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
  Map<String, dynamic> _selected = {};

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  void _newCollectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewCollectionDialog(
          selected: (val) {
            setState(() {
              _selected = val;
              print(_selected);
            });
          },
          type: widget.type,
          groupMembers: _groupMembers,
        );
      },
    );
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final group = Provider.of<Groups>(context, listen: false);
    await group.fetchMembers();
    await group.fetchContributions();
    await group.fetchLoanTypes();
    setState(() {
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
      print(_groupLoanTypes);
      _isLoading = false;
      _isInit = false;
    });
    return true;
  }

  @override
  void initState() {
    if (widget.type == 'contributions') {
      _title = "Group Contribution";
      _selected = {
        'member_id': '',
        'amount': '',
      };
    } else if (widget.type == 'repayments') {
      _title = "Loan Repayment";
      _selected = {
        'member_id': '',
        'loan_id': '',
        'amount': '',
      };
    } else if (widget.type == 'disbursements') {
      _title = "Loan Disbursement";
      _selected = {
        'member_id': '',
        'loan_id': '',
        'amount': '',
      };
    }
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
                              return InkWell(
                                onTap: () => {},
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0,
                                            ),
                                            child: Icon(
                                              Icons.group,
                                              color: Theme.of(context)
                                                  .textSelectionHandleColor,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              subtitle2(
                                                text: _data[index].date,
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor,
                                                textAlign: TextAlign.start,
                                              ),
                                              subtitle1(
                                                text: _data[index].title,
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor,
                                                textAlign: TextAlign.start,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Members present ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 13.0,
                                                      color: Theme.of(context)
                                                          .textSelectionHandleColor,
                                                      fontFamily: 'SegoeUI',
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    _data[index]
                                                        .members['present']
                                                        .length
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13.0,
                                                      color: Theme.of(context)
                                                          .textSelectionHandleColor,
                                                      fontFamily: 'SegoeUI',
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      _data[index].members['synced'] == 1
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(right: 22.0),
                                              child: Icon(
                                                Icons.cloud_done,
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor
                                                    .withOpacity(0.7),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(right: 12.0),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.file_upload,
                                                  color: Colors.red[700],
                                                ),
                                                onPressed: () => {
                                                  // Upload meeting
                                                },
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Expanded(
                            child: emptyList(
                              color: Colors.blue[400],
                              iconData: LineAwesomeIcons.file_text,
                              text: "There's nothing to show",
                            ),
                          ),
                  ],
                );
              },
            ),
    );
  }
}

class NewCollectionDialog extends StatefulWidget {
  final String type;
  final List<dynamic> groupMembers;
  final ValueChanged<dynamic> selected;
  NewCollectionDialog({
    @required this.type,
    @required this.groupMembers,
    @required this.selected,
  });
  @override
  _NewCollectionDialogState createState() => new _NewCollectionDialogState();
}

class _NewCollectionDialogState extends State<NewCollectionDialog> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _selected = {};
  String title = "";

  @override
  void initState() {
    if (widget.type == 'contributions') {
      title = "Group Contribution";
      _selected = {
        'member_id': '',
        'amount': '',
      };
    } else if (widget.type == 'repayments') {
      title = "Loan Repayment";
      _selected = {
        'member_id': '',
        'loan_id': '',
        'amount': '',
      };
    } else if (widget.type == 'disbursements') {
      title = "Loan Disbursement";
      _selected = {
        'member_id': '',
        'loan_id': '',
        'amount': '',
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
          color: Theme.of(context).textSelectionHandleColor),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                  widget.selected(_selected);
                });
              },
              onChanged: (value) {
                setState(() {
                  _selected['member_id'] = value;
                  widget.selected(_selected);
                });
              },
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
            }),
        FlatButton(
          padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
          child: customTitle(
            text: "Save Changes",
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
          onPressed: () {},
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
