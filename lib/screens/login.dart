import '../providers/auth.dart';

import 'package:chamasoft/utilities/common.dart';
import 'package:provider/provider.dart';
import '../utilities/custom-helper.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _logo = "cs.png";
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _identity;
  @override
  void initState() {
    (themeChangeProvider.darkTheme) ? _logo = "cs-alt.png" : _logo = "cs.png";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    // setState(() {
    //   _isLoading = true;
    // });
    try {
      await Provider.of<Auth>(context,listen:false).generatePin(_identity);

      // if (_authMode == AuthMode.Login) {
      //   await Provider.of<Auth>(context, listen: false)
      //       .login(_authData['email'], _authData['password']);
      // } else {
      //   await Provider.of<Auth>(context, listen: false)
      //       .signup(_authData['email'], _authData['password']);
      // }
      //Navigator.of(context).pushReplacementNamed(ProductsOverview.namedRoute);
    } on HttpException catch (error) {
      print("Http ${error.toString()}");
    } catch (error) {
      print("System ${error.toString()}");
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          decoration: primaryGradient(context),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: Image(
                    image: AssetImage('assets/$_logo'),
                    height: 100.0,
                  ),
                ),
                heading1(
                    text: "Chamasoft",
                    color: Theme.of(context).textSelectionHandleColor),
                SizedBox(
                  height: 10,
                ),
                subtitle1(
                    text: "Let's verify your identity first",
                    color: Theme.of(context).textSelectionHandleColor),
                subtitle2(
                    text: "Enter your phone number or email address below",
                    color: Theme.of(context).textSelectionHandleColor),
                TextFormField(
                  decoration: InputDecoration(
                    hasFloatingPlaceholder: true,
                    labelText: 'Phone number or Email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).hintColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  validator: (value){
                    if(!CustomHelper.validIdentity(value)){
                      return 'Enter valid email or phone number';
                    }
                  },
                  onSaved: (value){
                    _identity = value;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                defaultButton(
                  context: context,
                  text: "Continue",
                  onPressed: _submit,
                ),
                SizedBox(
                  height: 24,
                ),
                textWithExternalLinks(
                    color: Theme.of(context).textSelectionHandleColor,
                    size: 12.0,
                    textData: {
                      'By continuing you agree to our': {},
                      'terms & conditions': {
                        "url": () => launchURL(
                            'https://chamasoft.com/terms-and-conditions/'),
                        "color": primaryColor,
                        "weight": FontWeight.w500
                      },
                      'and': {},
                      'privacy policy.': {
                        "url": () => launchURL(
                            'https://chamasoft.com/terms-and-conditions/'),
                        "color": primaryColor,
                        "weight": FontWeight.w500
                      },
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
