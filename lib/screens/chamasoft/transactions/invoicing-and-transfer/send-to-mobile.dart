import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/choose_member.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/certificates/certificates.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class SendToMobile extends StatefulWidget {
  @override
  State<SendToMobile> createState() => _SendToMobileState();
}

class _SendToMobileState extends State<SendToMobile> {
  static final List<NamesListItem> _selectTransferPurpose = [
    NamesListItem(id: 1, name: "Expense Payment"),
    NamesListItem(id: 2, name: "Contribution Refund"),
    NamesListItem(id: 3, name: "Merry Go Round"),
    NamesListItem(id: 4, name: "Loan Disbursement")
  ];

  Map<String, dynamic> _formLoadData = {};
  bool _isInit = true;

  int selectedTransferitem;
  // int _withdrawalPurpose;
  ScrollController _scrollController;
  double _appBarElevation = 0;
  int _memberId;
  int _contributionId;
  int _expenseCategoryId;
  int _loanTypeId;

  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      await Provider.of<Groups>(context).fetchMembers();
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

  void _prepareSubmission(BuildContext context, String groupId) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    Map<String, String> formData = {};
    formData['withdrawal_for'] = selectedTransferitem.toString();
    List<NamesListItem> list = [];
    switch (selectedTransferitem) {
      case 1:
        formData['expense_category_id'] = _expenseCategoryId.toString();
        list = _formLoadData["expenseCategories"];
        formData['name'] = _getOptionName(_expenseCategoryId, list);
        // formData['description'] = _description;
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
    }

    formData['recipient'] = "1";

    print("The form load data is $_formLoadData");
    print("The form data is $formData");
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ListMemberContacts(
        formLoadData: _formLoadData,
        formData: formData,
        groupId: groupId,
      );
    }));
  }

  String _getOptionName(int memberId, List<NamesListItem> list) {
    var name = '';
    for (final item in list) {
      if (memberId == item.id) {
        name = item.name;
      }
    }
    return name;
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _fetchDefaultValues(context));
    WidgetsBinding.instance
        .addPostFrameCallback((/*timeStamp*/ _) => _fetchMembers(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Send to Mobile",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            toolTip(
              context: context,
              title: "Select Transfer Purpose",
              message: "",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
              padding: inputPagePadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomDropDownButton(
                      labelText: 'Select Transfer Purpose',
                      enabled: true,
                      listItems: _selectTransferPurpose,
                      selectedItem: selectedTransferitem,
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedTransferitem = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomDropDownButton(
                      labelText: 'Select Member Name',
                      enabled: true,
                      listItems: _formLoadData.containsKey("memberOptions")
                          ? _formLoadData["memberOptions"]
                          : [],
                      selectedItem: _memberId,
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _memberId = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _prepareSubmission(context, _groupObject.groupId);
              },
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Text(
                  "Send to Mobile",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
