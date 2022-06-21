import 'package:chamasoft/config.dart';
import 'package:chamasoft/screens/chatwithcontactsupport.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPassword extends StatefulWidget {
  const LoginPassword({Key key}) : super(key: key);

  @override
  State<LoginPassword> createState() => _LoginPasswordState();
}

class _LoginPasswordState extends State<LoginPassword> {
  TextEditingController _passwordController;
  bool _isFormInputEnabled = true;
  bool _passwordVisible = true;
  FocusNode _focusNode;
  final GlobalKey<FormState> _formKey = GlobalKey();
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
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
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
            _launchContactNumber("tel:0741564020");
          });
        });
  }

  void _togglePassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      // ignore: deprecated_member_use
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
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/no-user.png'),
                                      backgroundColor: Colors.transparent,
                                      radius: 39,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: subtitle1(text: "0741564020"),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 47),
                                  child: Icon(Icons.more_vert,
                                      color: Theme.of(context).primaryColor),
                                ),
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
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultButtonWithBg(
                                text: 'Sign In',
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
                                  textButton(
                                    text: "Forgot password",
                                    color: Theme.of(context).primaryColor,
                                    // action: () =>
                                    //     _callcontactSupport(context),
                                  ),
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
