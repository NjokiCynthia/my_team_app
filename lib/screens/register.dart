import 'package:chamasoft/screens/login_password.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const namedRoute = "/registerScreen";
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _identity = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Form(
            child: Container(
          height: double.infinity,
          decoration: primaryGradient(context),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: MediaQuery.of(context).size.height * 0.1),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/no-user.png'),
                  backgroundColor: Colors.transparent,
                  radius: 47,
                ),
                SizedBox(
                  height: 15,
                ),
                heading3(
                    text: _identity, color: Theme.of(context).primaryColor),
                SizedBox(
                  height: 15,
                ),
                subtitle1(
                    text:
                        "Kindly complete the following form to complete registration",
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'First Name',
                  ),
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontFamily: 'SegoeUI'),
                  onSaved: (value) {},
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Last Name Name',
                  ),
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontFamily: 'SegoeUI'),
                  onSaved: (value) {},
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Password',
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
                  ),
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontFamily: 'SegoeUI'),
                  onSaved: (value) {},
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: _confirmPasswordVisible,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Confirm Password',
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                      child: Icon(_passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontFamily: 'SegoeUI'),
                  onSaved: (value) {},
                ),
                SizedBox(
                  height: 18,
                ),
                defaultButton(
                  context: context,
                  text: "Register",
                  onPressed: () {},
                ),
                SizedBox(
                  height: 15,
                ),
                RichText(
                    text: TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(color: Colors.black),
                        children: [
                      TextSpan(
                          text: " Click here",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacementNamed(
                                  LoginPassword.namedRoute,
                                  arguments: _identity);
                              print("User has an account");
                            },
                          style:
                              TextStyle(color: Theme.of(context).primaryColor))
                    ]))
              ],
            ),
          ),
        ));
      }),
    );
  }
}
