import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'configure-group.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
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
      await Provider.of<Groups>(context, listen: false).createGroup(groupName: _groupName);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ConfigureGroup(),
      ));
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
    final auth = Provider.of<Auth>(context);
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
                          subtitle1(text: "Give your group a name", color: Theme.of(context).textSelectionHandleColor),
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                            child: auth.displayAvatar != null
                                ? CachedNetworkImage(
                                    imageUrl: auth.displayAvatar,
                                    placeholder: (context, image) => const CircleAvatar(
                                      radius: 45.0,
                                      backgroundImage: const AssetImage('assets/no-user.png'),
                                    ),
                                    imageBuilder: (context, image) => CircleAvatar(
                                      backgroundImage: image,
                                      radius: 45.0,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fadeOutDuration: const Duration(seconds: 1),
                                    fadeInDuration: const Duration(seconds: 3),
                                  )
                                : const CircleAvatar(
                                    backgroundImage: const AssetImage('assets/no-user.png'),
                                    radius: 45.0,
                                  ),
                          ),
                          heading2(text: auth.userName, color: Theme.of(context).textSelectionHandleColor),
                          subtitle1(text: auth.phoneNumber, color: Theme.of(context).textSelectionHandleColor.withOpacity(0.6)),
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
                            height: 24,
                          ),
                          _isLoading
                              ? CircularProgressIndicator()
                              : defaultButton(
                                  context: context,
                                  text: "Continue",
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _submit(context);
                                    }
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
