import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class FilterContainer extends StatefulWidget {
  final int filterType;
  final List<int> currentFilters;
  final List<String> currentMembers;

  FilterContainer({@required this.filterType, @required this.currentFilters, @required this.currentMembers});

  @override
  _FilterContainerState createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInit = true;
  bool _isLoading = false;
  bool _selectAll = false;
  bool _selectAllMembers = false;
  bool _contributionPayments = false;
  bool _showStatusFilter = true;
  bool _showMemberFilter = false;
  List<NamesListItem> _list = [];
  List<Member> _memberList = [];
  List<int> _selectedItems = [];
  List<String> _selectedMembers = [];
  String title = "Deposit Options";

  void _prepareDepositList() {
    _list = [
      NamesListItem(id: 1, name: "Contribution Payments"),
      NamesListItem(id: 2, name: "Fine Payments"),
      NamesListItem(id: 3, name: "Loan Repayments"),
      NamesListItem(id: 4, name: "Miscellaneous Payments"),
      NamesListItem(id: 5, name: "Income Receipts"),
      NamesListItem(id: 6, name: "Bank Loan Disbursement"),
      NamesListItem(id: 7, name: "Stock Sales"),
      NamesListItem(id: 8, name: "Money Markets"),
      NamesListItem(id: 9, name: "Asset Sales"),
      NamesListItem(id: 10, name: "Funds Transfer"),
      NamesListItem(id: 11, name: "Loan Processing"),
      NamesListItem(id: 12, name: "External Lending Processing Income"),
      NamesListItem(id: 13, name: "External Lending Loa Repayment"),
    ];

    if (widget.currentFilters.isEmpty || widget.currentFilters.length == _list.length) {
      for (var item in _list) {
        _selectedItems.add(item.id);
        _selectAll = true;
      }
    } else {
      for (var item in _list) {
        for (var filter in widget.currentFilters) {
          if (item.id == filter) _selectedItems.add(item.id);
        }
      }
    }
  }

  void _prepareWithdrawalList() {
    title = "Withdrawal Options";
    _list = [
      NamesListItem(id: 1, name: "Expense Payments"),
      NamesListItem(id: 2, name: "Asset Purchase Payments"),
      NamesListItem(id: 3, name: "Loan Disbursement"),
      NamesListItem(id: 4, name: "Stock Purchases"),
      NamesListItem(id: 5, name: "Money Market Investments"),
      NamesListItem(id: 6, name: "Contribution Refunds"),
      NamesListItem(id: 7, name: "Bank Loan Repayments"),
      NamesListItem(id: 8, name: "Funds Transfer"),
      NamesListItem(id: 9, name: "External Loan Disbursement"),
    ];

    if (widget.currentFilters.isEmpty || widget.currentFilters.length == _list.length) {
      for (var item in _list) {
        _selectedItems.add(item.id);
        _selectAll = true;
      }
    } else {
      for (var item in _list) {
        for (var filter in widget.currentFilters) {
          if (item.id == filter) _selectedItems.add(item.id);
        }
      }
    }
  }

  void _prepareWithdrawalRequestList() {
    title = "Approval Status";
    _list = [
      NamesListItem(id: 1, name: "Pending Requests"),
      NamesListItem(id: 2, name: "Approved Requests"),
      NamesListItem(id: 3, name: "Declined Requests"),
      NamesListItem(id: -1, name: "Disbursement Status"),
      NamesListItem(id: 14, name: "Pending Disbursement"),
      NamesListItem(id: 15, name: "Successful Disbursement"),
      NamesListItem(id: 16, name: "Failed Disbursement"),
    ];

    for (var item in _list) {
      for (var filter in widget.currentFilters) {
        if (item.id == filter) _selectedItems.add(item.id);
      }
    }
  }

  Future<void> _getGroupMembers(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchMembers();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getGroupMembers(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  void _fetchData() {
    if (_showMemberFilter)
      setState(() {
        _isLoading = true;
      });
    _memberList = Provider.of<Groups>(context, listen: false).members;
    _getGroupMembers(context).then((_) {
      if (context != null) {
        _memberList = Provider.of<Groups>(context, listen: false).members;
        if (/*widget.currentMembers.isEmpty ||*/ widget.currentMembers.length == _memberList.length) {
          for (var member in _memberList) {
            _selectedMembers.add(member.id);
            _selectAllMembers = true;
          }
        } else {
          for (var member in _memberList) {
            for (var filter in widget.currentMembers) {
              if (member.id == filter) _selectedMembers.add(member.id);
            }
          }
        }
        if (_showMemberFilter)
          setState(() {
            _isLoading = false;
          });
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      if (widget.filterType == 1) {
        //deposits
        _prepareDepositList();
      } else if (widget.filterType == 2) {
        //withdrawals
        _prepareWithdrawalList();
      } else if (widget.filterType == 3) {
        //withdrawal requests
        _prepareWithdrawalRequestList();
      }

      _fetchData();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: tertiaryPageAppbar(
          context: context,
          title: "Filter By",
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.close,
          trailingIcon: LineAwesomeIcons.check,
          trailingAction: () => Navigator.pop(context, [_selectedItems, _selectedMembers])),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: double.infinity,
        child: Row(
          children: [
            Container(
              color: themeChangeProvider.darkTheme ? Colors.grey[800] : Colors.grey[100],
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    child: Material(
                      color: themeChangeProvider.darkTheme ? Colors.grey[800] : Colors.grey[100],
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showMemberFilter = false;
                            _showStatusFilter = true;
                          });
                        },
                        splashColor: Colors.blueGrey.withOpacity(0.2),
                        child: Row(
                          children: [
                            customTitle(
                                text: "Status",
                                textAlign: TextAlign.start,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textSelectionHandleColor),
                            Visibility(
                                visible: _showStatusFilter,
                                child: Icon(LineAwesomeIcons.chevron_right,
                                    size: 12, color: Theme.of(context).textSelectionHandleColor))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: Material(
                      color: themeChangeProvider.darkTheme ? Colors.grey[800] : Colors.grey[100],
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showMemberFilter = true;
                            _showStatusFilter = false;
                          });
                        },
                        splashColor: Colors.blueGrey.withOpacity(0.2),
                        child: Row(
                          children: [
                            customTitle(
                                text: "Members",
                                textAlign: TextAlign.start,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textSelectionHandleColor),
                            Visibility(
                                visible: _showMemberFilter,
                                child: Icon(LineAwesomeIcons.chevron_right,
                                    size: 12, color: Theme.of(context).textSelectionHandleColor))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: _showStatusFilter,
              child: Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTitle(
                          text: title,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textSelectionHandleColor),
                      Visibility(
                        visible: widget.filterType == 1 || widget.filterType == 2,
                        child: CheckboxListTile(
                          dense: true,
                          title: subtitle1(
                              text: "Select All",
                              textAlign: TextAlign.start,
                              color: Theme.of(context).textSelectionHandleColor),
                          value: _selectAll,
                          onChanged: (value) {
                            _selectedItems.clear();
                            if (value) {
                              for (var item in _list) {
                                _selectedItems.add(item.id);
                              }
                            }
                            setState(() {
                              _selectAll = value;
                            });
                          },
                          activeColor: primaryColor,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            NamesListItem item = _list[index];
                            if (widget.filterType == 3) {
                              if (item.id == -1) {
                                return customTitle(
                                    text: item.name,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).textSelectionHandleColor);
                              } else
                                return CheckboxListTile(
                                  dense: true,
                                  value: _selectedItems.contains(item.id),
                                  onChanged: (value) {
                                    setState(() {
                                      if (item.id == 14 || item.id == 15 || item.id == 16) {
                                        if (_selectedItems.contains(1)) _selectedItems.remove(1);
                                        if (_selectedItems.contains(2)) _selectedItems.remove(2);
                                        if (_selectedItems.contains(3)) _selectedItems.remove(3);
                                      } else {
                                        if (_selectedItems.contains(14)) _selectedItems.remove(14);
                                        if (_selectedItems.contains(15)) _selectedItems.remove(15);
                                        if (_selectedItems.contains(16)) _selectedItems.remove(16);
                                      }
                                      if (value) {
                                        _selectedItems.add(item.id);
                                      } else {
                                        _selectedItems.remove(item.id);
                                      }
                                    });
                                  },
                                  title: subtitle1(
                                      text: item.name,
                                      textAlign: TextAlign.start,
                                      color: Theme.of(context).textSelectionHandleColor),
                                  activeColor: primaryColor,
                                );
                            } else
                              return CheckboxListTile(
                                dense: true,
                                value: _selectedItems.contains(item.id),
                                onChanged: (value) {
                                  setState(() {
                                    if (value) {
                                      _selectedItems.add(item.id);
                                    } else {
                                      _selectedItems.remove(item.id);
                                    }
                                  });
                                },
                                title: subtitle1(
                                    text: item.name,
                                    textAlign: TextAlign.start,
                                    color: Theme.of(context).textSelectionHandleColor),
                                activeColor: primaryColor,
                              );
                          },
                          itemCount: _list.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _showMemberFilter,
              child: Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isLoading
                          ? showLinearProgressIndicator()
                          : SizedBox(
                              height: 0.0,
                            ),
                      CheckboxListTile(
                        dense: true,
                        title: subtitle1(
                            text: "Select All",
                            textAlign: TextAlign.start,
                            color: Theme.of(context).textSelectionHandleColor),
                        value: _selectAllMembers,
                        onChanged: (value) {
                          _selectedMembers.clear();
                          if (value) {
                            for (var member in _memberList) {
                              _selectedMembers.add(member.id);
                            }
                          }
                          setState(() {
                            _selectAllMembers = value;
                          });
                        },
                        activeColor: primaryColor,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            Member member = _memberList[index];
                            return CheckboxListTile(
                              secondary: const Icon(Icons.person),
                              value: _selectedMembers.contains(member.id),
                              onChanged: (value) {
                                setState(() {
                                  if (value) {
                                    _selectedMembers.add(member.id);
                                  } else {
                                    _selectedMembers.remove(member.id);
                                  }
                                });
                              },
                              title: subtitle1(
                                  text: member.name,
                                  color: Theme.of(context).textSelectionHandleColor,
                                  textAlign: TextAlign.start),
                              subtitle: subtitle2(
                                  text: member.identity,
                                  color: Theme.of(context).textSelectionHandleColor,
                                  textAlign: TextAlign.start),
                            );
                          },
                          itemCount: _memberList.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
