import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class PayNow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PayNowState();
  }
}

class PayNowState extends State<PayNow> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  double amountInputValue;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

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
                    labelStyle: inputTextStyle(),
                    hintStyle: inputTextStyle(),
                    errorStyle: inputTextStyle(),
                    filled: false,
                    hintText: 'Select Contribution',
                    labelText: _dropdownValue == null
                        ? 'Select Contribution'
                        : 'Select Contribution',
                    errorText: _errorText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor, width: 1.0))),
                isEmpty: _dropdownValue == null,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Theme.of(context).cardColor,
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
                        child: Text(
                          value,
                          style: inputTextStyle(),
                        ),
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

  void _numberToPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
              text: "Confirm Mpesa Number",
              color: Theme.of(context).textSelectionHandleColor,
              textAlign: TextAlign.start),
          content: TextFormField(
            //controller: controller,
            style: inputTextStyle(),
            initialValue: "254712233344",
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
              )),
              // hintText: 'Phone Number or Email Address',
              labelText: "Mpesa Number",
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                    fontFamily: 'SegoeUI'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Pay Now",
                style:
                    new TextStyle(color: primaryColor, fontFamily: 'SegoeUI'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Contribution Payment",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              toolTip(
                  context: context,
                  title: "Note that...",
                  message:
                      "An STK Push will be initiated on your phone, this process is almost instant but may take a while due to third-party delays"),
              Container(
                padding: EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    buildDropDown(),
                    amountTextInputField(
                        context: context,
                        labelText: "Amount to pay",
                        onChanged: (value) {
                          setState(() {
                            amountInputValue = double.parse(value);
                          });
                        }),
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
                              "color": primaryColor,
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
                        onPressed: () => _numberToPrompt())
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
