import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class FilterContainer extends StatefulWidget {
  final int filterType;
  final List<int> currentFilters;
  final List<String> currentMembers;

  FilterContainer(
      {@required this.filterType,
      @required this.currentFilters,
      @required this.currentMembers});

  @override
  _FilterContainerState createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInit = true;
  bool _isLoading = false;
  bool _selectAll = false;
  bool _selectAllMembers = false;
  // bool _contributionPayments = false;
  bool _showStatusFilter = true;
  bool _showMemberFilter = false;
  List<NamesListItem> _list = [];
  List<Member> _memberList = [];
  List<int> _selectedItems = [];
  List<String> _selectedMembers = [];
  String title = "Deposit Options";

  void _prepareDepositList() {
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    title = currentLanguage == 'English'
        ? 'Deposit Options'
        : Provider.of<TranslationProvider>(context, listen: false)
                .translate('Deposit Options') ??
            'Deposit Options';
    _list = [
      NamesListItem(
        id: 1,
        name: currentLanguage == 'English'
            ? 'Contribution Payments'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Contribution Payments') ??
                'Contribution Payments',
      ),
      NamesListItem(
        id: 2,
        name: currentLanguage == 'English'
            ? 'Fine Payments'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Fine Payments') ??
                'Fine Payments',
      ),
      NamesListItem(
        id: 3,
        name: currentLanguage == 'English'
            ? 'Loan Repayments'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Loan Repayments') ??
                'Loan Repayments',
      ),
      NamesListItem(
        id: 4,
        name: currentLanguage == 'English'
            ? 'Miscellaneous Payments'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Miscellaneous Payments') ??
                'Miscellaneous Payments',
      ),
      NamesListItem(
        id: 5,
        name: currentLanguage == 'English'
            ? 'Income Receipts'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Income Receipts') ??
                'Income Receipts',
      ),
      NamesListItem(
        id: 6,
        name: currentLanguage == 'English'
            ? 'Bank Loan Disbursement'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Bank Loan Disbursement') ??
                'Bank Loan Disbursement',
      ),
      NamesListItem(
        id: 7,
        name: currentLanguage == 'English'
            ? 'Stock Sales'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Stock Sales') ??
                'Stock Sales',
      ),
      NamesListItem(
        id: 8,
        name: currentLanguage == 'English'
            ? 'Money Markets'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Money Markets') ??
                'Money Markets',
      ),
      NamesListItem(
        id: 9,
        name: currentLanguage == 'English'
            ? 'Asset Sales'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Asset Sales') ??
                'Asset Sales',
      ),
      NamesListItem(
        id: 10,
        name: currentLanguage == 'English'
            ? 'Funds Transfer'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Funds Transfer') ??
                'Funds Transfer',
      ),
      NamesListItem(
        id: 11,
        name: currentLanguage == 'English'
            ? 'Loan Processing'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Loan Processing') ??
                'Loan Processing',
      ),
      NamesListItem(
        id: 12,
        name: currentLanguage == 'English'
            ? 'External Lending Processing Income'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('External Lending Processing Income') ??
                'External Lending Processing Income',
      ),
      NamesListItem(
        id: 13,
        name: currentLanguage == 'English'
            ? 'External Lending Loan Repayment'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('External Lending Loan Repayment') ??
                'External Lending Loan Repayment',
      ),
    ];

    if (widget.currentFilters.isEmpty ||
        widget.currentFilters.length == _list.length) {
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
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    title = currentLanguage == 'English'
        ? 'Withdrawal Options'
        : Provider.of<TranslationProvider>(context, listen: false)
                .translate('Withdrawal Options') ??
            'Withdrawal Options';
    _list = [
      NamesListItem(
        id: 1,
        name: currentLanguage == 'English'
            ? 'Expense Payments'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Expense Payments') ??
                'Expense Payments',
      ),
      NamesListItem(
        id: 2,
        name: currentLanguage == 'English'
            ? 'Asset Purchase Payments'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Asset Purchase Payments') ??
                'Asset Purchase Payments',
      ),
      NamesListItem(
        id: 3,
        name: currentLanguage == 'English'
            ? 'Loan Disbursement'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Loan Disbursement') ??
                'Loan Disbursement',
      ),
      NamesListItem(
        id: 4,
        name: currentLanguage == 'English'
            ? 'Stock Purchases'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Stock Purchases') ??
                'Stock Purchases',
      ),
      NamesListItem(
        id: 5,
        name: currentLanguage == 'English'
            ? 'Money Market Investments'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Money Market Investments') ??
                'Money Market Investments',
      ),
      NamesListItem(
        id: 6,
        name: currentLanguage == 'English'
            ? 'Contribution Refunds'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Contribution Refunds') ??
                'Contribution Refunds',
      ),
      NamesListItem(
        id: 7,
        name: currentLanguage == 'English'
            ? 'Bank Loan Repayments'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Bank Loan Repayments') ??
                'Bank Loan Repayments',
      ),
      NamesListItem(
        id: 8,
        name: currentLanguage == 'English'
            ? 'Funds Transfer'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Funds Transfer') ??
                'Funds Transfer',
      ),
      NamesListItem(
        id: 9,
        name: currentLanguage == 'English'
            ? 'External Loan Disbursement'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('External Loan Disbursement') ??
                'External Loan Disbursement',
      ),
    ];

    if (widget.currentFilters.isEmpty ||
        widget.currentFilters.length == _list.length) {
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
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    title = currentLanguage == 'English'
        ? 'Approval Status'
        : Provider.of<TranslationProvider>(context, listen: false)
                .translate('Approval Status') ??
            'Approval Status';
    _list = [
      NamesListItem(
        id: 1,
        name: currentLanguage == 'English'
            ? 'Pending Requests'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Pending Requests') ??
                'Pending Requests',
      ),
      NamesListItem(
        id: 2,
        name: currentLanguage == 'English'
            ? 'Approved Requests'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Approved Requests') ??
                'Approved Requests',
      ),
      NamesListItem(
        id: 3,
        name: currentLanguage == 'English'
            ? 'Declined Requests'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Declined Requests') ??
                'Declined Requests',
      ),
      NamesListItem(
        id: -1,
        name: currentLanguage == 'English'
            ? 'Disbursement Status'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Disbursement Status') ??
                'Disbursement Status',
      ),
      NamesListItem(
        id: 14,
        name: currentLanguage == 'English'
            ? 'Pending Disbursement'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Pending Disbursement') ??
                'Pending Disbursement',
      ),
      NamesListItem(
        id: 15,
        name: currentLanguage == 'English'
            ? 'Successful Disbursement'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Successful Disbursement') ??
                'Successful Disbursement',
      ),
      NamesListItem(
        id: 16,
        name: currentLanguage == 'English'
            ? 'Failed Disbursement'
            : Provider.of<TranslationProvider>(context, listen: false)
                    .translate('Failed Disbursement') ??
                'Failed Disbursement',
      ),
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
        if (/*widget.currentMembers.isEmpty ||*/ widget.currentMembers.length ==
            _memberList.length) {
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

  Group _currentGroup;
  @override
  Widget build(BuildContext context) {
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    _currentGroup =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
      key: _scaffoldKey,
      appBar: tertiaryPageAppbar(
          context: context,
          title: currentLanguage == 'English'
              ? 'Filter By'
              : Provider.of<TranslationProvider>(context, listen: false)
                      .translate('Filter By') ??
                  'Filter By',
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.times,
          trailingIcon: LineAwesomeIcons.check,
          trailingAction: () =>
              Navigator.pop(context, [_selectedItems, _selectedMembers])),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: double.infinity,
        child: Row(
          children: [
            Container(
              color: themeChangeProvider.darkTheme
                  ? Colors.grey[800]
                  : Colors.grey[100],
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    child: Material(
                      color: themeChangeProvider.darkTheme
                          ? Colors.grey[800]
                          : Colors.grey[100],
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
                                text: currentLanguage == 'English'
                                    ? 'Status'
                                    : Provider.of<TranslationProvider>(context,
                                                listen: false)
                                            .translate('Status') ??
                                        'Status',
                                textAlign: TextAlign.start,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor),
                            Visibility(
                                visible: _showStatusFilter,
                                child: Icon(LineAwesomeIcons.chevron_right,
                                    size: 12,
                                    color: Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _currentGroup.isGroupAdmin,
                    child: Container(
                      height: 50,
                      child: Material(
                        color: themeChangeProvider.darkTheme
                            ? Colors.grey[800]
                            : Colors.grey[100],
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
                                  text: currentLanguage == 'English'
                                      ? 'Members'
                                      : Provider.of<TranslationProvider>(
                                                  context,
                                                  listen: false)
                                              .translate('Members') ??
                                          'Members',
                                  textAlign: TextAlign.start,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor),
                              Visibility(
                                  visible: _showMemberFilter,
                                  child: Icon(LineAwesomeIcons.chevron_right,
                                      size: 12,
                                      color: Theme.of(context)
                                          .textSelectionTheme
                                          .selectionHandleColor))
                            ],
                          ),
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
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor),
                      Visibility(
                        visible:
                            widget.filterType == 1 || widget.filterType == 2,
                        child: CheckboxListTile(
                          dense: true,
                          title: subtitle1(
                              text: currentLanguage == 'English'
                                  ? 'Select All'
                                  : Provider.of<TranslationProvider>(context,
                                              listen: false)
                                          .translate('Select All') ??
                                      'Select All',
                              textAlign: TextAlign.start,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor),
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
                                    color: Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor);
                              } else
                                return CheckboxListTile(
                                  dense: true,
                                  value: _selectedItems.contains(item.id),
                                  onChanged: (value) {
                                    setState(() {
                                      if (item.id == 14 ||
                                          item.id == 15 ||
                                          item.id == 16) {
                                        if (_selectedItems.contains(1))
                                          _selectedItems.remove(1);
                                        if (_selectedItems.contains(2))
                                          _selectedItems.remove(2);
                                        if (_selectedItems.contains(3))
                                          _selectedItems.remove(3);
                                      } else {
                                        if (_selectedItems.contains(14))
                                          _selectedItems.remove(14);
                                        if (_selectedItems.contains(15))
                                          _selectedItems.remove(15);
                                        if (_selectedItems.contains(16))
                                          _selectedItems.remove(16);
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
                                      color: Theme.of(context)
                                          .textSelectionTheme
                                          .selectionHandleColor),
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
                                    color: Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor),
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
                            text: currentLanguage == 'English'
                                ? 'Select All'
                                : Provider.of<TranslationProvider>(context,
                                            listen: false)
                                        .translate('Select All') ??
                                    'Select All',
                            textAlign: TextAlign.start,
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor),
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
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor,
                                  textAlign: TextAlign.start),
                              subtitle: subtitle2(
                                  text: member.identity,
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor,
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
