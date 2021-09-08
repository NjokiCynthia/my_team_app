import 'package:chamasoft/screens/confirm_temp_pin.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class ResetPin extends StatefulWidget {
//  const ResetPin({ Key? key }) : super(key: key);
// set up the buttons

  @override
  _ResetPinState createState() => _ResetPinState();
}

class _ResetPinState extends State<ResetPin> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(builder: (BuildContext context) {
        return Container(
          alignment: Alignment.center,
          decoration: primaryGradient(context),
          // height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  child: Container(
                alignment: Alignment.center,
                // margin: EdgeInsets.only(top: 50.0),
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      switches(),
                      SizedBox(
                        height: 30.0,
                      ),
                      securityQuestion(),
                      SizedBox(
                        height: 30.0,
                      ),
                      ansSecurityQuestion(),
                      SizedBox(
                        height: 30.0,
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text("Reset  Pin Confirmation"),
                                      content: Text(
                                          "Are you sure you want to Reset your pin?"),
                                      actions: [
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          // FlatButton widget is used to make a text to work like a button
                                          textColor: Colors.black,
                                          onPressed: () => Navigator.pop(
                                              context,
                                              false), // function used to perform after pressing the button
                                          child: Text('CANCEL'),
                                        ),
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          textColor: Colors.black,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TempolaryPin()),
                                            );
                                          },
                                          child: Text('ACCEPT'),
                                        ),
                                      ],
                                    ));
                          }
                        },
                        child: Text(" Submit"),
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        );
      }),
    );
  }

  securityQuestion() {
    return heading2(text: "Where were you born?");
  }

  ansSecurityQuestion() {
    return Column(
      children: [
        Container(
            child: TextFormField(
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            hintText: 'Enter your Answer Here!',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Answer is required.';
            }
            return null;
          },
        ))
      ],
    );
  }

  switches() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: FlutterToggleTab(
            width: 70,
            borderRadius: 15,
            labels: ["Send Money", "Request Money"],
            initialIndex: 0,
            selectedLabelIndex: (index) {
              setState(() {});
            },
            selectedTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600),
            unSelectedTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
