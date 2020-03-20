import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class PayNow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PayNowState();
  }
}

class PayNowState extends State<PayNow> {
  var _currentSelectedValue;
  var _currencies = [
    "Monthly Savings",
    "Welfare",
  ];

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: Icon(LineAwesomeIcons.arrow_left),
        title: Text("Contribution Payment"),
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(20.0),
                color: Color(0xffededfe),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: Colors.blueGrey,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          subtitle1(
                              text: "Note that...", color: Colors.blueGrey),
                          subtitle2(
                              text:
                                  "An STK Push will be initiated on your phone, this process is almost instant but may take a while due to third-party delays",
                              color: Colors.blueGrey)
                        ],
                      ),
                    ),
                    screenActionButton(
                        icon: LineAwesomeIcons.close,
                        //backgroundColor: Colors.blue.withOpacity(0.2),
                        textColor: Colors.blueGrey,
                        action: null),
                  ],
                )),
            Container(
              padding: EdgeInsets.all(40.0),
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
                          labelText: "Select Contribution",
//                          errorStyle: TextStyle(
//                              color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'Please select expense',
                        ),
                        isEmpty: _currentSelectedValue == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currentSelectedValue,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _currentSelectedValue = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _currencies.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      hasFloatingPlaceholder: true,
                      // hintText: 'Phone Number or Email Address',
                      labelText: 'Amount to Pay',
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: textWithExternalLinks(
                        color: Colors.blueGrey,
                        size: 12.0,
                        textData: {
                          'Additional charges may be applied where necessary.':
                              {},
                          'Learn More': {
                            "url": () => launchURL(
                                'https://chamasoft.com/terms-and-conditions/'),
                            "color": Colors.blue,
                            "weight": FontWeight.w500
                          },
                        }),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  defaultButton(
                      context: context,
                      text: "Pay Now",
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
