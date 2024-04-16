// ignore_for_file: unused_import, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/config.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chatwithcontactsupport.dart';
import 'package:chamasoft/screens/forgotpasswordverification.dart';
import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/screens/register.dart';
import 'package:chamasoft/screens/resetpassword.dart';
import 'package:chamasoft/screens/verification.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPassword extends StatefulWidget {
  static const namedRoute = "/loginpassword";
  const LoginPassword({Key key}) : super(key: key);

  @override
  State<LoginPassword> createState() => _LoginPasswordState();
}

class _LoginPasswordState extends State<LoginPassword> {
  TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isFormInputEnabled = true;
  bool _passwordVisible = true;
  FocusNode _focusNode;

  bool _isLoading = false;
  String appSignature = "{{app signature}}";

  String _logo = Config.appName.toLowerCase() == 'chamasoft'
      ? "cs.png"
      : "equity-logo.png";

  @override
  void initState() {
    _focusNode = new FocusNode();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _launchContactNumber(String phoneNumber) async {
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _fogortPassword(String identity) {
    twoButtonAlertDialogWithContentList(
        context: context,
        message: identity,
        promptMessage: "Are you sure you want to reset your password?",
        confirmMessage: "Is this your correct phone number ?",
        // title: title,
        action: () async {
          Navigator.of(context).pop();
          setState(() {
            _isLoading = true;
          });
          try {
            print("signature: $appSignature");
            print("On Forgot Pwd the identity is: $identity");
            await Provider.of<Auth>(context, listen: false)
                .generatePin(identity, appSignature);
            // Navigator.of(context)
            //     .pushNamed(Verification.namedRoute, arguments: identity);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ForgotPassswordVerification(),
                settings: RouteSettings(
                  arguments: identity,
                )));
            // await Navigator.of(context).pushNamed(Verification.namedRoute);
          } catch (error) {
            throw error;
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        });
  }

  void _callcontactSupport(BuildContext context) {
    String title = "Contact Support";
    twoButtonAlertDialogWithoutTitle(
        context: context,
        message: "Call Support",
        yesText: "Call",
        chatAction: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  ChatWithContactSupportScreen()));
        },
        callAction: () {
          setState(() {
            _launchContactNumber("tel:0733366240");
          });
        });
  }

  void _togglePassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    Navigator.of(context).pushNamed(MyGroups.namedRoute);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    String userIdentity = auth.phoneNumber;
    print("The user's phone number is $userIdentity");

    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Container(
            height: double.infinity,
            // alignment: Alignment.center,
            decoration: primaryGradient(context),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  right: 14,
                  left: 14,
                  top: MediaQuery.of(context).size.height * 0.15),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(
                    height:
                        Config.appName.toLowerCase() == 'chamasoft' ? 0.0 : 6.0,
                  ),
                  heading1(
                      text: Config.appName,
                    
                      color: Theme.of(context).primaryColor),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: auth.displayAvatar != null
                                          ? CachedNetworkImage(
                                              imageUrl: auth.displayAvatar,
                                              placeholder: (context, url) =>
                                                  const CircleAvatar(
                                                radius: 39.0,
                                                backgroundImage:
                                                    const AssetImage(
                                                        'assets/no-user.png'),
                                              ),
                                              imageBuilder: (context, image) =>
                                                  CircleAvatar(
                                                backgroundImage: image,
                                                radius: 39.0,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              fadeOutDuration:
                                                  const Duration(seconds: 1),
                                              fadeInDuration:
                                                  const Duration(seconds: 3),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/no-user.png'),
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 39,
                                            ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: subtitle1(text: "+$userIdentity"),
                                      // child: subtitle1(text: auth.phoneNumber),
                                    )
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 47),
                                    child: PopupMenuButton(
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: subtitle1(
                                                text: "Reset app",
                                                color: Theme.of(context)
                                                    .primaryColor))
                                      ],
                                      onSelected: (value) {
                                        if (value == 1) {
                                          // Navigator.of(context).popUntil(
                                          //     (route) => route.isFirst);
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  Login.namedRoute,
                                                  (route) => false);
                                        }
                                      },
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _passwordVisible,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () => _togglePassword(),
                                  child: Icon(_passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                border: UnderlineInputBorder(),
                                hintText: 'Password',
                              ),
                              enabled: _isFormInputEnabled,
                              textInputAction: TextInputAction.done,
                              focusNode: _focusNode,
                              style: TextStyle(fontFamily: 'SegoeUI'),
                              onSaved: (value) {},
                              validator: (value) {
                                if (value.trim() == '' ||
                                    value.trim() == null) {
                                  return 'Please enter your password';
                                } else if (value.trim().length < 5) {
                                  return 'Your password is too short';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultButtonWithBg(
                                text: 'Sign In',
                                action: () => _submit(),
                                btnColor: Theme.of(context).primaryColor),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  textButton(
                                    text: "Contact Support",
                                    color: Colors.black,
                                    action: () => _callcontactSupport(context),
                                  ),
                                  _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : textButton(
                                          text: "Forgot password",
                                          color: Theme.of(context).primaryColor,
                                          action: () =>
                                              _fogortPassword(userIdentity)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 8,
                    // decoration: BoxDecoration(
                    //     border: Border.all(width: 2, color: Colors.black)),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            subtitle1(text: "Share With friends"),
                            Icon(Icons.share,
                                color: Theme.of(context).primaryColor)
                          ]),
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
