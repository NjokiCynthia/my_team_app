import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../configure-group.dart';

DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

class ApplyLoan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ApplyLoanState();
  }
}

class ApplyLoanState extends State<ApplyLoan> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static final List<String> _dropdownItems = <String>[
    'Emergency Loan',
    'Education Loan'
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
                    hintText: 'Select Loan Type',
                    labelText: _dropdownValue == null
                        ? 'Select Loan Type'
                        : 'Select Loan Type',
                    errorText: _errorText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor, width: 2.0))),
                isEmpty: _dropdownValue == null,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: (themeChangeProvider.darkTheme) ? Colors.blueGrey[800] : Colors.white,
                  ),
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
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              screenActionButton(
                icon: LineAwesomeIcons.arrow_left,
                backgroundColor: Colors.blue.withOpacity(0.1),
                textColor: Colors.blue,
                action: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Login(),
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              heading2(color: Colors.blue, text: "Apply Loan"),
            ],
          ),
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            toolTip(
                context: context,
                title: "Note that...",
                message:
                    "Loan application process is totally depended on your group's constitution and your group\'s management."),
            Container(
              padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: <Widget>[
                  buildDropDown(),
                  TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      hasFloatingPlaceholder: true,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).hintColor,
                        width: 2.0,
                      )),
                      // hintText: 'Phone Number or Email Address',
                      labelText: 'Amount applying for',
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
                          'By applying for this loan you agree to the ': {},
                          'terms and conditions': {
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
                      text: "Apply Now",
                      onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ConfigureGroup(),
                            ),
                          ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
