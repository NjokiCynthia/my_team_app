import 'dart:io';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-accounts.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-contributions.dart';
import 'package:chamasoft/screens/chamasoft/settings/list-loan-types.dart';
import 'package:chamasoft/screens/new-group/select-group-members.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/country-dropdown.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NewGroup extends StatefulWidget {
  final String groupName, groupId;
  const NewGroup({Key key, this.groupName, this.groupId}) : super(key: key);

  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentStep = 0;
  bool complete = false;
  List<Step> steps = [];
  final _stepOneFormKey = GlobalKey<FormState>();
  final _lastStepFormKey = GlobalKey<FormState>();
  Map<String, dynamic> _data = {
    "name": '',
    "members": [],
    "contributions": [],
    "loan_types": [],
    "accounts": [],
    "referral": '',
  };
  bool _saving = false;
  bool _isInit = true;
  List<Country> _countryOptions = [];
  int countryId = 1;

  bool _isFormInputEnabled = true;
  PickedFile avatar;
  File imageFile;
  final ImagePicker _picker = ImagePicker();

  int _hasReferralCode = 0;

  void _onImagePickerClicked(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await _picker.getImage(
          source: source,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: IMAGE_QUALITY);
      setState(() {
        avatar = pickedFile;
        imageFile = File(avatar.path);
      });
    } catch (e) {
      //show SnackBar?
      //setState(() {});
    }
  }

  Future<void> retrieveLostData() async {
    final LostData lostData = await _picker.getLostData();
    if (lostData.isEmpty) return;

    if (lostData.file != null) {
      setState(() {
        avatar = lostData.file;
      });
    } else {}
  }

  goTo(int step) {
    setState(() {
      currentStep = step;
      _isInit = true;
    });
  }

  _showSnackbar(String msg, int duration) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: duration),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  next() {
    if (currentStep + 1 != steps.length) {
      if (currentStep == 0) {
        if (_stepOneFormKey.currentState.validate()) {
          if (widget.groupId != null) {
            // ignore: unnecessary_statements
            _data['name'] == widget.groupName;
          } else if (_data['name'] == '') {
            _showSnackbar("You need to fill group info to continue.", 4);
          } else {
            // goTo(1);
            _createGroup();
          }
        } else {
          _showSnackbar("Fill in the required fields to continue.", 4);
        }
      } else if (currentStep == 1) {
        if (_data['members'].length < 3) {
          _showSnackbar("You need to add at least 3 members to continue", 6);
        } else {
          goTo(2);
        }
      } else if (currentStep == 2) {
        if (_data['contributions'].length < 1) {
          _showSnackbar("You need to setup a contribution to continue", 6);
        } else {
          goTo(3);
        }
      } else if (currentStep == 3) {
        // if (_data['accounts'].length < 1) {
        //   _showSnackbar("You need to setup an account to continue", 6);
        // } else {
        goTo(4);
        // }
      } else if (currentStep == 4) {
        //if (_data['loan_types'].length < 0) {
        //  _showSnackbar("You need to setup a loan type to continue", 6);
        //} else {
        goTo(5);
        //}
      } else {
        goTo(currentStep + 1);
      }
    } else {
      if (_hasReferralCode == 1) {
        if (_lastStepFormKey.currentState.validate()) {
          // print(_data['referral']);
          if (_data['referral'] == '') {
            _showSnackbar("Your referral code is required.", 4);
          } else {
            setState(() {
              _saving = true;
            });
            completeGroupSetup();
          }
        }
      } else {
        // print(_data['referral']);
        setState(() {
          _saving = true;
        });
        completeGroupSetup();
      }
    }
  }

  completeGroupSetup() async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .completeGroupSetup(_data["referral"]);
      setState(() {
        _saving = false;
        complete = true;
      });
      _showSnackbar("Group set up completed successfully.", 4);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => ChamasoftDashboard(),
        ),
      );
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
        context: context,
        error: error,
        callback: () => _showSnackbar(
          "An error occurred while saving your changes, please try again.",
          6,
        ),
      );
    }
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  formatStep(step, title) {
    return Text(
      title,
      style: TextStyle(
        color: currentStep >= step
            ? primaryColor
            // ignore: deprecated_member_use
            : Theme.of(context).textSelectionTheme.selectionHandleColor,
        fontFamily: 'SegoeUI',
        fontWeight: currentStep >= step ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  _setMembers(dynamic members) {
    setState(() {
      _data['members'] = members;
    });
  }

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  String validateGroupInfo(String field, String value) {
    if (field == 'name') {
      if (value.isEmpty)
        return "Group name is required";
      else if (value.length < 3)
        return "Group name is way too short";
      else {
        _data['name'] = value;
        return null;
      }
    } else if (field == 'referral') {
      if (value.isEmpty)
        return "Referral code is required";
      else if (value.length < 3)
        return "Referral code is way too short";
      else {
        _data['referral'] = value;
        return null;
      }
    } else {
      return null;
    }
  }

  void _createGroup() async {
    setState(() {
      _isFormInputEnabled = false;
      _saving = true;
    });

    try {
      await Provider.of<Groups>(context, listen: false).createGroup(
          groupName: _data['name'], countryId: countryId, avatar: imageFile);
      setState(() {
        _isInit = true;
      });
      goTo(1);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _createGroup();
          });
    } finally {
      setState(() {
        _saving = false;
        _isFormInputEnabled = true;
      });
    }
  }

  Future<void> _fetchCountryOptions(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog<String>(
          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          },
        );
      },
    );
    try {
      await Provider.of<Groups>(context, listen: false).fetchCountryOptions();
      setState(() {
        _isInit = false;
      });
      Navigator.of(context, rootNavigator: true).pop();
    } on CustomException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      StatusHandler().handleStatus(
        context: context,
        error: error,
        callback: () {
          _fetchCountryOptions(context);
        },
      );
    }
  }

  String _getFirstName(String name) {
    String resp = "";
    try {
      resp = name.split(" ")[0];
    } catch (e) {
      resp = name;
    }
    return resp;
  }

  String _renderMembersText() {
    List<dynamic> _mbrs = _data['members'];
    if (_mbrs.length == 1)
      return "1 member";
    else if (_mbrs.length > 1)
      return _getFirstName(_data['members'][0]['name']) +
          " & " +
          (_mbrs.length - 1).toString() +
          " other member" +
          (((_mbrs.length - 1) == 1) ? "" : "s");
    else
      return "Tap to add members";
  }

  Future<void> getGroupMembers(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog<String>(
          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          },
        );
      },
    );
    try {
      final group = Provider.of<Groups>(context, listen: false);
      await group.fetchMembers();
      setState(() {
        List<Map<String, dynamic>> _mbrs = [];
        group.members.forEach((m) {
          _mbrs.add({
            'id': m.id,
            'name': m.name,
            'identity': m.identity,
            'avatar': m.avatar,
            'user_id': m.userId,
          });
        });
        _data['members'] = _mbrs;
        _isInit = false;
      });
      Navigator.of(context, rootNavigator: true).pop();
    } on CustomException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      StatusHandler().handleStatus(
        context: context,
        error: error,
        callback: () {
          getGroupMembers(context);
        },
      );
    }
  }

  Future<void> _fetchContributions(BuildContext context) async {
    print("in fetch contributions");
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog<String>(
          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          },
        );
      },
    );
    try {
      final group = Provider.of<Groups>(context, listen: false);
      await group.fetchContributions().then((value) {
        setState(() {
          List<dynamic> _ctrbs = [];
          group.contributions.forEach((m) {
            _ctrbs.add({
              'id': m.id,
              'name': m.name,
              'amount': m.amount,
              'contributionDate': m.contributionDate,
              'contributionType': m.contributionType,
            });
          });
          _data['contributions'] = _ctrbs;
          _isInit = false;
        });
        Navigator.of(context).pop();
      });
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
        context: context,
        error: error,
        callback: () {
          _fetchContributions(context);
        },
      );
    }
  }

  Future<void> _fetchAccounts(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog<String>(
          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          },
        );
      },
    );
    try {
      final group = Provider.of<Groups>(context, listen: false);
      await group.temporaryFetchAccounts();
      setState(() {
        List<dynamic> _accs = [];
        group.accounts.forEach((m) {
          _accs.add({
            'id': m.id,
            'name': m.name,
            'typeId': m.typeId,
          });
        });
        _data['accounts'] = _accs;
        _isInit = false;
      });
      Navigator.of(context, rootNavigator: true).pop();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchAccounts(context);
          });
    }
  }

  Future<void> _fetchLoanTypes(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog<String>(
          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          },
        );
      },
    );
    try {
      final group = Provider.of<Groups>(context, listen: false);
      await group.fetchLoanTypes();
      setState(() {
        List<dynamic> _loanTyps = [];

        group.loanTypes.forEach((m) {
          _loanTyps.add({
            'id': m.id,
            'name': m.name,
            'amount': m.loanAmount,
            'repaymentPeriod': m.repaymentPeriod,
            'loanProcessing': m.loanProcessing,
            'guarantors': m.guarantors,
            'latePaymentFines': m.latePaymentFines,
            'outstandingPaymentFines': m.outstandingPaymentFines,
          });
        });
        _data['loan_types'] = _loanTyps;
        _isInit = false;
      });
      Navigator.of(context, rootNavigator: true).pop();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
        context: context,
        error: error,
        callback: () {
          _fetchLoanTypes(context);
        },
      );
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
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final currentGroup = group.getCurrentGroup();
    if (currentGroup != null) _data['group_id'] = currentGroup.groupId;
    _data['user_id'] = auth.id;
    // Handle countries
    _countryOptions = Provider.of<Groups>(context).countryOptions;
    if ((_countryOptions == null || _countryOptions.isEmpty) &&
        currentStep == 0) {
      if (_isInit) _fetchCountryOptions(context);
    }
    if (_isInit && currentStep == 1) getGroupMembers(context);
    if (_isInit && currentStep == 2) _fetchContributions(context);
    if (_isInit && currentStep == 3) _fetchAccounts(context);
    if (_isInit && currentStep == 4) _fetchLoanTypes(context);

    final List<Map<String, dynamic>> _radOptions = [
      {
        "value": 1,
        "name": "Yes",
      },
      {
        "value": 0,
        "name": "No",
      },
    ];

    steps = [
      Step(
        title: currentStep == 0
            ? formatStep(0, "Group Info")
            : Text(
                "Group Info",
                style: TextStyle(
                  // ignore: deprecated_member_use
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
        isActive: currentStep == 0 ? true : false,
        state: StepState.disabled,
        content: Form(
          key: _stepOneFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              subtitle1(
                text: "Select group avatar",
                // ignore: deprecated_member_use
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                textAlign: TextAlign.start,
              ),
              subtitle2(
                text: "Could be a logo or an image associated with your group",
                // ignore: deprecated_member_use
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: <Widget>[
                    !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                        ? FutureBuilder<void>(
                            future: retrieveLostData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/no-group.png'),
                                    backgroundColor: Colors.transparent,
                                    radius: 50,
                                  );
                                case ConnectionState.done:
                                  return CircleAvatar(
                                    backgroundImage: avatar == null
                                        ? AssetImage('assets/no-group.png')
                                        : FileImage(File(avatar.path)),
                                    backgroundColor: Colors.transparent,
                                    radius: 50,
                                  );
                                default:
                                  return CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/no-group.png'),
                                    backgroundColor: Colors.transparent,
                                    radius: 50,
                                  );
                              }
                            },
                          )
                        : CircleAvatar(
                            backgroundImage: avatar == null
                                ? AssetImage('assets/no-group.png')
                                : FileImage(File(avatar.path)),
                            backgroundColor: Colors.transparent,
                            radius: 50,
                          ),
                    Positioned(
                      bottom: -8.0,
                      right: -8.0,
                      child: IconButton(
                        icon: Container(
                          padding: EdgeInsets.all(2.0),
                          width: 42.0,
                          height: 42.0,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              color: Theme.of(context).backgroundColor,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(32),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          _onImagePickerClicked(ImageSource.gallery, context);
                        },
                      ),
                    )
                  ],
                ),
              ),
              TextFormField(
                enabled: _isFormInputEnabled,
                textCapitalization: TextCapitalization.words,
                validator: (val) => validateGroupInfo('name', val),
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'The name of this group',
                  // contentPadding: EdgeInsets.only(bottom: 0.0),
                ),
              ),
              CountryDropdown(
                labelText: 'Select Country',
                listItems: _countryOptions,
                selectedItem: countryId,
                onChanged: (value) {
                  setState(() {
                    countryId = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: formatStep(1, "Members"),
        isActive: currentStep >= 1 ? true : false,
        state: currentStep > 1 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[
            Container(
              color: primaryColor.withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SelectGroupMembers(
                          selected: _data['members'],
                          members: (membrs) => _setMembers(membrs),
                        ),
                      ),
                    )
                    .then(
                      (resp) => getGroupMembers(context),
                    ),
                title: "Group Members",
                subtitle: _renderMembersText(),
                icon: Icons.add,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
      Step(
        title: formatStep(2, "Contributions"),
        isActive: currentStep >= 2 ? true : false,
        state: currentStep > 2 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[
            Container(
              color: primaryColor.withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ListContributions(),
                  ),
                )
                    .then(
                  (resp) {
                    _fetchContributions(context);
                  },
                ),
                title: "Group Contributions",
                subtitle: "Tap to manage contributions",
                icon: Icons.edit,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
      Step(
        title: formatStep(3, "Accounts"),
        isActive: currentStep >= 3 ? true : false,
        state: currentStep > 3 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[
            Container(
              color: primaryColor.withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ListAccounts(),
                      ),
                    )
                    .then((resp) => _fetchAccounts(context)),
                title: "Group Accounts",
                subtitle: "Tap to manage accounts",
                icon: Icons.edit,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
      Step(
        title: formatStep(4, "Loan Types"),
        isActive: currentStep >= 4 ? true : false,
        state: currentStep > 4 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[
            Container(
              color: primaryColor.withOpacity(0.1),
              width: double.infinity,
              child: meetingMegaButton(
                context: context,
                action: () => Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ListLoanTypes(),
                      ),
                    )
                    .then((value) => _fetchLoanTypes(context)),
                title: "Group Loan types",
                subtitle: "Tap to manage loan types",
                icon: Icons.edit,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
      Step(
        title: formatStep(5, "Finish"),
        isActive: currentStep >= 5 ? true : false,
        state: currentStep > 5 ? StepState.complete : StepState.disabled,
        content: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              subtitle1(
                text: "Do you have a referral code?",
                // ignore: deprecated_member_use
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                textAlign: TextAlign.start,
              ),
              subtitle2(
                text:
                    "Use it if referred by a Bank, an NGO, a Partner or anyone",
                // ignore: deprecated_member_use
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                textAlign: TextAlign.start,
              ),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _radOptions
                      .map((option) => Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                activeColor: primaryColor,
                                value: option['value'],
                                // title: Text(option['name']),
                                groupValue: _hasReferralCode,
                                onChanged: (val) {
                                  setState(() {
                                    _hasReferralCode = val;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () => setState(() {
                                  _hasReferralCode = option['value'];
                                }),
                                child: Text(
                                  option['name'],
                                  style: TextStyle(
                                    color: _hasReferralCode == option['value']
                                        ? primaryColor
                                        : Theme.of(context)
                                            // ignore: deprecated_member_use
                                            .textSelectionTheme
                                            .selectionHandleColor,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(width: 15.0),
                            ],
                          ))
                      .toList(),
                ),
              ),
              Visibility(
                visible: (_hasReferralCode == 1),
                child: Form(
                  key: _lastStepFormKey,
                  child: TextFormField(
                    enabled: _isFormInputEnabled,
                    textCapitalization: TextCapitalization.characters,
                    validator: (val) => validateGroupInfo('referral', val),
                    decoration: InputDecoration(
                      labelText: 'Referral Code',
                      hintText: 'The referral code shared',
                      // contentPadding: EdgeInsets.only(bottom: 0.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "New Group",
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
            child: Column(
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
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor,
                        size: 24.0,
                        semanticLabel: 'About new group...',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // subtitle1(
                            //   text: "About new meeting...",
                            //   textAlign: TextAlign.start,
                            //   color: Theme.of(context).textSelectionHandleColor,
                            // ),
                            subtitle2(
                              text:
                                  "Follow all the steps and provide all required data about this group. You'll be able to preview a summary of the group before you submit.",
                              // ignore: deprecated_member_use
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionHandleColor,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Stepper(
                  physics: ClampingScrollPhysics(),
                  steps: steps,
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepTapped: (step) => goTo(step),
                  onStepCancel: cancel,
                  controlsBuilder: (
                    BuildContext context, {
                    VoidCallback onStepContinue,
                    VoidCallback onStepCancel,
                  }) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 12.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // ignore: deprecated_member_use
                          ElevatedButton(
                            color: primaryColor,
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                              child: Row(
                                children: [
                                  Text(
                                    currentStep == 5
                                        ? "Confirm & Submit"
                                        : "Save & Continue",
                                    style: TextStyle(
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.w700),
                                  ),
                                  (_saving)
                                      ? SizedBox(width: 10.0)
                                      : SizedBox(),
                                  (_saving)
                                      ? SizedBox(
                                          height: 16.0,
                                          width: 16.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            backgroundColor: Colors.transparent,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.grey[700],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                            textColor: Colors.white,
                            onPressed: (!_saving) ? onStepContinue : null,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          currentStep > 1
                              // ignore: deprecated_member_use
                              ? OutlinedButton(
                                  color: Colors.white,
                                  child: Text(
                                    "Go Back",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                    ),
                                  ),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionHandleColor
                                        .withOpacity(0.5),
                                  ),
                                  highlightColor: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor
                                      .withOpacity(0.1),
                                  highlightedBorderColor: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor
                                      .withOpacity(0.6),
                                  onPressed: (!_saving) ? onStepCancel : null,
                                )
                              : SizedBox(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
