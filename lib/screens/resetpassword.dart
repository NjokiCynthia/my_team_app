import 'package:chamasoft/screens/login_password.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../config.dart';

class ResetPassword extends StatefulWidget {
  static const namedRoute = "/resetpassword";

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _logo = Config.appName.toLowerCase() == 'chamasoft'
      ? "cs.png"
      : "equity-logo.png";
  TextEditingController _passwordController;
  bool _passwordVisible = false;
  bool _forgotPasswordVisible = false;
  bool _isFormInputEnabled = true;
  FocusNode _passwordFocusNode;
  FocusNode _confirmPasswordFocusNode;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _passwordFocusNode = new FocusNode();
    _confirmPasswordFocusNode = new FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> _authData = {'password': ''};

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: heading2(text: "Create new password")),
      // appBar: secondaryPageAppbar(
      //     context: context,
      //     title: "Reset Password",
      //     action: () => Navigator.of(context).pop(),
      //     elevation: 1,
      //     leadingIcon: LineAwesomeIcons.arrow_left),
      body: Builder(builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            // alignment: Alignment.center,
            decoration: primaryGradient(context),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  right: 14,
                  left: 14,
                  top: MediaQuery.of(context).size.height * 0.15),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Image(
                      image: AssetImage('assets/$_logo'),
                      height: Config.appName.toLowerCase() == 'chamasoft'
                          ? 100.0
                          : 50.0,
                    ),
                  ),
                  heading1(
                      text: Config.appName,
                      // ignore: deprecated_member_use
                      color: Theme.of(context).primaryColor),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          subtitle1(text: "Reset Password"),
                          Divider(),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _passwordVisible,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                child: Icon(_passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              border: UnderlineInputBorder(),
                              hintText: 'Password',
                            ),
                            enabled: _isFormInputEnabled,
                            textInputAction: TextInputAction.next,
                            focusNode: _passwordFocusNode,
                            style: TextStyle(fontFamily: 'SegoeUI'),
                            validator: (value) {
                              if (value != null || value.length <= 5) {
                                return "Password is too short";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['password'] = value;
                            },
                          ),
                          TextFormField(
                            obscureText: _forgotPasswordVisible,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _forgotPasswordVisible =
                                        !_forgotPasswordVisible;
                                  });
                                },
                                child: Icon(_forgotPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              border: UnderlineInputBorder(),
                              hintText: 'Confirm Password',
                            ),
                            enabled: _isFormInputEnabled,
                            textInputAction: TextInputAction.done,
                            focusNode: _confirmPasswordFocusNode,
                            style: TextStyle(fontFamily: 'SegoeUI'),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return "Password do not match";
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          defaultButtonWithBg(
                              text: 'Submit',
                              action: () {
                                _submit();
                                Navigator.of(context).pop();
                              },
                              // print("on submit called");
                              // Navigator.of(context).pop();

                              btnColor: Theme.of(context).primaryColor),
                          SizedBox(
                            height: 2,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
