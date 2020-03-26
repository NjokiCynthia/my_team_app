import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class PayNow extends StatefulWidget {
  @override
  PayNowState createState() => PayNowState();
}

class PayNowState extends State<PayNow> {
  static final List<String> _dropdownItems = <String>[
    'Monthly Savings',
    'Welfare'
  ];
  final formKey = new GlobalKey<FormState>();
  String _dropdownValue;
  String _errorText;

  Widget buildDropDown() {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new InputDecorator(
                decoration: InputDecoration(
                  filled: false,
                  hintText: 'Select contribution',
                  labelText: _dropdownValue == null
                      ? 'Select Contribution'
                      : 'Select Contribution',
                  errorText: _errorText,
                ),
                isEmpty: _dropdownValue == null,
                child: new DropdownButton<String>(
                  value: _dropdownValue,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      _dropdownValue = newValue;
                    });
                  },
                  items: _dropdownItems.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: Icon(LineAwesomeIcons.arrow_left),
        title: Text("Contribution Payment"),
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            toolTip(
                context: context,
                title: "Note that...",
                message:
                    "An STK Push will be initiated on your phone, this process is almost instant but may take a while due to third-party delays"),
            Container(
              padding: EdgeInsets.all(40.0),
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  buildDropDown(),
                  amountInputField(context, 'Amount to pay', controller),
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
