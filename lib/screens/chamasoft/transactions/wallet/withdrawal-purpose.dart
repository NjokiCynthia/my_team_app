import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/choose_member.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/list-banks.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'review-withdrawal.dart';

class WithdrawalPurpose extends StatefulWidget {
  final String groupId;
  const WithdrawalPurpose({Key key, this.groupId})
      : super(key: key);
  @override
  _WithdrawalPurposeState createState() => _WithdrawalPurposeState();
}

class _WithdrawalPurposeState extends State<WithdrawalPurpose> {
  List<NamesListItem> _withdrawalPurposeList = [
    NamesListItem(id: 1, name: "Expense Payment"),
    NamesListItem(id: 2, name: "Contribution Refund"),
    NamesListItem(id: 3, name: "Merry Go Round"),
    NamesListItem(id: 4, name: "Loan Disbursement")
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInit = true;
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final _formKey = new GlobalKey<FormState>();
  Map<String, dynamic> _formLoadData = {};
  bool _isFormInputEnabled = true;
  int _withdrawalPurpose;
  int _expenseCategoryId;
  String _description;
  int _memberId;
  int _contributionId;
  int _loanTypeId;



  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _fetchMembers(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchMembers(/*widget.groupId*/);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchMembers(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<void> _fetchDefaultValues(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      _formLoadData = await Provider.of<Groups>(context, listen: false)
          .loadInitialFormData(
              contr: true, member: true, exp: true, loanTypes: true);
      Navigator.of(context).pop();
      setState(() {
        _isInit = false;
      });
    } on CustomException catch (error) {
      Navigator.of(context).pop();
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchDefaultValues(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }

    _isInit = false;
  }

  Future<bool> fetchBankOptions(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchBankOptions();
      return true;
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            fetchBankOptions(context);
          });
      return false;
    }
  }

  Future<void> fetchBankAccounts() async {}

  void _prepareSubmission(
      BuildContext context, int flag, String groupId) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    Map<String, String> formData = {};
    formData['withdrawal_for'] = _withdrawalPurpose.toString();

    List<NamesListItem> list = [];
    switch (_withdrawalPurpose) {
      case 1:
        formData['expense_category_id'] = _expenseCategoryId.toString();
        list = _formLoadData["expenseCategories"];
        formData['name'] = _getOptionName(_expenseCategoryId, list);
        formData['description'] = _description;
        break;
      case 2:
        formData['contribution_id'] = _contributionId.toString();
        formData['member_id'] = _memberId.toString();

        list = _formLoadData["memberOptions"];
        formData['member_name'] = _getOptionName(_memberId, list);

        list = _formLoadData["contributionOptions"];
        formData['name'] = _getOptionName(_contributionId, list);
        break;
      case 3:
        formData['member_id'] = _memberId.toString();

        list = _formLoadData["memberOptions"];
        formData['name'] = _getOptionName(_memberId, list);
        break;
      case 4:
        formData['loan_type_id'] = _loanTypeId.toString();

        list = _formLoadData["memberOptions"];
        formData['member_name'] = _getOptionName(_memberId, list);
        formData['member_id'] = _memberId.toString();

        list = _formLoadData["loanTypeOptions"];
        formData['name'] = _getOptionName(_loanTypeId, list);
        break;
    }

    if (flag == 1) {
      //send to bank
      formData['recipient'] = "3";
      List<Bank> _banksList =
          Provider.of<Groups>(context, listen: false).bankOptions;
      if (_banksList.length < 1) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        await fetchBankOptions(context);
        Navigator.pop(context);
        final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ListBanks(formData: formData)));
        if (result != null) {
          final id = int.tryParse(result) ?? 0;
          if (id != 0) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => ReviewWithdrawal(
                      requestId: id,
                    )));
          }
        }
      } else {
        final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ListBanks(formData: formData)));
        if (result != null) {
          final id = int.tryParse(result) ?? 0;
          if (id != 0) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => ReviewWithdrawal(
                      requestId: id,
                    )));
          }
        }
      }
    } else {
      //send to phone
      formData['recipient'] = "1";
      final result = await  Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ListMemberContacts(formData: formData, groupId: groupId)));
      if (result != null) {
        print("result: $result");
        final id = int.tryParse(result) ?? 0;
        if (id != 0) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => ReviewWithdrawal(
                    requestId: id,
                  )));
        }
      }
    } /* else {
      //send to phone
      formData['recipient'] = "1";
      final result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ListPhoneContacts(formData: formData)));
      if (result != null) {
        print("result: $result");
        final id = int.tryParse(result) ?? 0;
        if (id != 0) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => ReviewWithdrawal(
                    requestId: id,
                  )));
        }
      }
    } */
  }

  String _getOptionName(int id, List<NamesListItem> list) {
    var name = '';
    for (final item in list) {
      if (id == item.id) {
        name = item.name;
      }
    }
    return name;
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _fetchDefaultValues(context));
    WidgetsBinding.instance.addPostFrameCallback((/*timeStamp*/_) => _fetchMembers(context));
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    final List<BankAccountDashboardSummary> accountBalances =
        Provider.of<Dashboard>(context, listen: false)
            .bankAccountDashboardSummary;

    String accountName = "";
    double balance = 0;
    if (accountBalances.length > 0) {
      for (var account in accountBalances) {
        if (account.accountName.contains("Chamasoft E-Wallet")) {
          try {
            accountName = account.accountName
                .replaceAll("Chamasoft E-Wallet -", "")
                .trim();
          } catch (error) {
            accountName = account.accountName;
          }
          balance = account.balance;
        }
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: secondaryPageAppbar(
        context: context,
        title: "Create Withdrawal Request",
        action: () => Navigator.of(context).pop(),
        elevation: 1,
        leadingIcon: LineAwesomeIcons.arrow_left,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                accountName.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.all(16.0),
                        width: double.infinity,
                        color: (themeChangeProvider.darkTheme)
                            ? Colors.blueGrey[800]
                            : Color(0xffededfe),
                        child: Column(
                          children: [
                            subtitle1(
                              text: accountName,
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionHandleColor,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                subtitle1(
                                  text: "Account Balance ",
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                heading2(
                                  text:
                                      "${groupObject.groupCurrency} ${currencyFormat.format(balance)}",
                                  // ignore: deprecated_member_use
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : toolTip(
                        context: context,
                        title: "",
                        message:
                            "Withdrawal requests will be sent to the group signatories for approval",
                        showTitle: false),
                Padding(
                  padding: inputPagePadding,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomDropDownButton(
                          enabled: _isFormInputEnabled,
                          labelText: "Select Purpose of Withdrawal",
                          listItems: _withdrawalPurposeList,
                          selectedItem: _withdrawalPurpose,
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _withdrawalPurpose = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: _withdrawalPurpose == 1,
                          child: CustomDropDownButton(
                            enabled: _isFormInputEnabled,
                            labelText: "Select Expense Category",
                            listItems:
                                _formLoadData.containsKey("expenseCategories")
                                    ? _formLoadData["expenseCategories"]
                                    : [],
                            selectedItem: _expenseCategoryId,
                            validator: (value) {
                              if (_withdrawalPurpose == 1 && value == null) {
                                return "This field is required";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _expenseCategoryId = value;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: _withdrawalPurpose != null &&
                              _withdrawalPurpose != 1,
                          child: CustomDropDownButton(
                            enabled: _isFormInputEnabled,
                            labelText: "Select Member",
                            listItems:
                                _formLoadData.containsKey("memberOptions")
                                    ? _formLoadData["memberOptions"]
                                    : [],
                            selectedItem: _memberId,
                            validator: (value) {
                              if (_withdrawalPurpose != null &&
                                  _withdrawalPurpose != 1 &&
                                  value == null) {
                                return "This field is required";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _memberId = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: _withdrawalPurpose == 2,
                          child: CustomDropDownButton(
                            enabled: _isFormInputEnabled,
                            labelText: "Select Contribution",
                            listItems:
                                _formLoadData.containsKey("contributionOptions")
                                    ? _formLoadData["contributionOptions"]
                                    : [],
                            selectedItem: _contributionId,
                            validator: (value) {
                              if (_withdrawalPurpose == 2 && value == null) {
                                return "This field is required";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _contributionId = value;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: _withdrawalPurpose == 4,
                          child: CustomDropDownButton(
                            enabled: _isFormInputEnabled,
                            labelText: "Select Loan Type",
                            listItems:
                                _formLoadData.containsKey("loanTypeOptions")
                                    ? _formLoadData["loanTypeOptions"]
                                    : [],
                            selectedItem: _loanTypeId,
                            validator: (value) {
                              if (_withdrawalPurpose == 4 && value == null) {
                                return "This field is required";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _loanTypeId = value;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: _withdrawalPurpose == 1,
                          child: simpleTextInputField(
                              context: context,
                              labelText: 'Short Description (Optional)',
                              enabled: _isFormInputEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _description = value;
                                });
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: _withdrawalPurpose != null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: paymentActionButton(
                                    color: primaryColor,
                                    textColor: primaryColor,
                                    icon: FontAwesome.user,
                                    isFlat: false,
                                    text: "Send To Bank",
                                    iconSize: 12.0,
                                    action: () => _prepareSubmission(
                                        context, 1, groupObject.groupId),
                                    showIcon: false),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: paymentActionButton(
                                    color: primaryColor,
                                    textColor: Colors.white,
                                    icon: FontAwesome.bank,
                                    isFlat: true,
                                    text: "Send To Mobile",
                                    iconSize: 12.0,
                                    action: () => _prepareSubmission(
                                        context, 2, groupObject.groupId),
                                    showIcon: false),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem({Key key, @required this.title, this.icon, this.onTapped})
      : super(key: key);

  final String title;
  final IconData icon;
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4.0),
      height: 150,
      decoration: cardDecoration(
          gradient: plainCardGradient(context), context: context),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          onTap: onTapped,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 35.0,
                color: primaryColor,
              ),
              SizedBox(
                height: 15.0,
              ),
              subtitle1(
                  text: title,
                  color: primaryColor,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
