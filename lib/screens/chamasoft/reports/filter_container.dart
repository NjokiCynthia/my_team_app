import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class FilterContainer extends StatefulWidget {
  final int filterType;
  final List<int> currentFilters;

  FilterContainer({@required this.filterType, @required this.currentFilters});

  @override
  _FilterContainerState createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInit = true;
  bool _selectAll = false;
  bool _contributionPayments = false;
  bool _showStatusFilter = true;
  bool _showMemberFilter = false;
  List<NamesListItem> _list = [];
  List<int> _selectedItems = [];

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
  }

  void _prepareWithdrawalRequestList() {
    _list = [
      NamesListItem(id: 1, name: "Pending Requests"),
      NamesListItem(id: 2, name: "Approved Requests"),
      NamesListItem(id: 3, name: "Declined Requests"),
      NamesListItem(id: -1, name: "Disbursement Status"),
      NamesListItem(id: 14, name: "Pending Disbursement"),
      NamesListItem(id: 15, name: "Failed Disbursement"),
      NamesListItem(id: 16, name: "Successful Disbursement"),
    ];
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
          trailingAction: () => Navigator.pop(context, _selectedItems)),
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
                            subtitle1(
                                text: "Status",
                                textAlign: TextAlign.start,
                                color: Theme.of(context).textSelectionHandleColor),
                            Visibility(
                                visible: _showStatusFilter,
                                child: Icon(LineAwesomeIcons.chevron_right,
                                    size: 16, color: Theme.of(context).textSelectionHandleColor))
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
                            subtitle1(
                                text: "Members",
                                textAlign: TextAlign.start,
                                color: Theme.of(context).textSelectionHandleColor),
                            Visibility(
                                visible: _showMemberFilter,
                                child: Icon(LineAwesomeIcons.chevron_right,
                                    size: 16, color: Theme.of(context).textSelectionHandleColor))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTitle(
                        text: "Deposit Options",
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textSelectionHandleColor),
                    CheckboxListTile(
                      dense: true,
                      title: subtitle1(
                          text: "Select All",
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
                      value: _selectAll,
                      onChanged: (value) {
                        _selectedItems.clear();
                        if (value) {
                          _selectedItems.clear();
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
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          NamesListItem item = _list[index];
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
            )
          ],
        ),
      ),
    );
  }
}
