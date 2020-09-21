import 'dart:io';

import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/configure-group.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/country-dropdown.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class CreateGroup extends StatefulWidget {
  static const String namedRoute = "/create-group";

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  bool _isInit = true;
  List<Country> _countryOptions = [];
  File avatar;
  int countryId = 1;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isFormInputEnabled = true;
  bool _isLoading = false;
  String _groupName;

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isFormInputEnabled = false;
      _isLoading = true;
    });

    try {
      await Provider.of<Groups>(context, listen: false).createGroup(groupName: _groupName, countryId: countryId, avatar: avatar);
      Navigator.of(context).pushReplacementNamed(ConfigureGroup.namedRoute);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _submit(context);
          });
    } finally {
      setState(() {
        _isLoading = false;
        _isFormInputEnabled = true;
      });
    }
  }

  Future<void> _fetchCountryOptions(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
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
          });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _countryOptions = Provider.of<Groups>(context).countryOptions;
    if (_countryOptions == null || _countryOptions.isEmpty) {
      if (_isInit) _fetchCountryOptions(context);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: primaryGradient(context),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          heading1(text: "Create Group", color: Theme.of(context).textSelectionHandleColor),
                          subtitle1(text: "Give your group a name, profile photo and country", color: Theme.of(context).textSelectionHandleColor),
                          SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: avatar == null ? AssetImage('assets/no-user.png') : FileImage(avatar),
                                  backgroundColor: Colors.transparent,
                                  radius: 50,
                                ),
                                Positioned(
                                  bottom: -12.0,
                                  right: -12.0,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 30.0,
                                    ),
                                    onPressed: () async {
                                      FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.image);
                                      if(result != null){
                                        File newAvatar = File(result.files.single.path);
                                        setState(() {
                                          avatar = newAvatar;
                                        });
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            enabled: _isFormInputEnabled,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter group name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _groupName = value.trim();
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              labelText: 'Group name',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                          SizedBox(
                            height: 24,
                          ),
                          _isLoading
                              ? CircularProgressIndicator()
                              : defaultButton(
                                  context: context,
                                  text: "Continue",
                                  onPressed: () {
                                    _submit(context);
                                  }),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50.0,
                  left: 20.0,
                  child: screenActionButton(
                    icon: LineAwesomeIcons.close,
                    backgroundColor: primaryColor.withOpacity(0.2),
                    textColor: primaryColor,
                    action: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
