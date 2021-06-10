import 'dart:io';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/country-dropdown.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class NewGroup extends StatefulWidget {
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
  Map<String, dynamic> _data = {
    "name": '',
    "members": [],
  };
  bool _saving = false;
  bool _isInit = true;
  List<Country> _countryOptions = [];
  int countryId = 1;

  bool _isFormInputEnabled = true;
  PickedFile avatar;
  File imageFile;
  final ImagePicker _picker = ImagePicker();

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
    setState(() => currentStep = step);
  }

  _showSnackbar(String msg, int duration) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.removeCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: duration),
    );
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  next() {
    if (currentStep + 1 != steps.length) {
      if (currentStep == 0) {
        if (_stepOneFormKey.currentState.validate()) {
          if (_data['name'] == '') {
            _showSnackbar("You need to fill group info to continue.", 4);
          } else {
            // goTo(1);
            _createGroup();
          }
        } else {
          _showSnackbar("Fill in the required fields to continue.", 4);
        }
      } else {
        goTo(currentStep + 1);
      }
    } else {
      // print(_data);
      setState(() {
        _saving = true;
      });
      setState(() => complete = true);
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
            : Theme.of(context).textSelectionHandleColor,
        fontFamily: 'SegoeUI',
        fontWeight: currentStep >= step ? FontWeight.bold : FontWeight.normal,
      ),
    );
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
          });
    });
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
    _data['group_id'] = currentGroup.groupId;
    _data['user_id'] = auth.id;
    // Handle countries
    _countryOptions = Provider.of<Groups>(context).countryOptions;
    if (_countryOptions == null || _countryOptions.isEmpty) {
      if (_isInit) _fetchCountryOptions(context);
    }

    steps = [
      Step(
        title: currentStep == 0
            ? formatStep(0, "Group Info")
            : Text(
                "Group Info",
                style: TextStyle(
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
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
                color: Theme.of(context).textSelectionHandleColor,
                textAlign: TextAlign.start,
              ),
              subtitle2(
                text: "Could be a logo or an image associated with your group",
                // ignore: deprecated_member_use
                color: Theme.of(context).textSelectionHandleColor,
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
          children: <Widget>[],
        ),
      ),
      Step(
        title: formatStep(2, "Contributions"),
        isActive: currentStep >= 2 ? true : false,
        state: currentStep > 2 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[],
        ),
      ),
      Step(
        title: formatStep(3, "Accounts"),
        isActive: currentStep >= 3 ? true : false,
        state: currentStep > 3 ? StepState.complete : StepState.disabled,
        content: Column(
          children: <Widget>[],
        ),
      ),
      Step(
        title: formatStep(4, "Confirmation"),
        isActive: currentStep >= 4 ? true : false,
        state: currentStep > 4 ? StepState.complete : StepState.disabled,
        content: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[],
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
                        color: Theme.of(context).textSelectionHandleColor,
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
                              color: Theme.of(context).textSelectionHandleColor,
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
                          RaisedButton(
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
                          currentStep > 0
                              // ignore: deprecated_member_use
                              ? OutlineButton(
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
