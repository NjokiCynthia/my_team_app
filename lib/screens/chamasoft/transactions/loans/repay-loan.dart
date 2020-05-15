import 'package:chamasoft/screens/chamasoft/models/active-loan.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class RepayLoan extends StatefulWidget {
  final ActiveLoan loan;

  RepayLoan({this.loan});

  @override
  _RepayLoanState createState() => _RepayLoanState();
}

class _RepayLoanState extends State<RepayLoan> {
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

  void _numberToPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Confirm Mpesa Number"),
          content: TextFormField(
            //controller: controller,
            initialValue: "254712233344",
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
              labelText: "Mpesa Number",
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Pay Now",
                style: new TextStyle(color: primaryColor),
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
          leadingIcon: LineAwesomeIcons.close,
          title: "Repay Loan",
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              color: Theme.of(context).backgroundColor,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    color: (themeChangeProvider.darkTheme)
                        ? Colors.blueGrey[800]
                        : Color(0xffededfe),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                "${widget.loan.name}",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textSelectionHandleColor
                                      .withOpacity(0.8),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Ksh ",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "${currencyFormat.format(widget.loan.amount)}",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Amount Repaid: ",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "Ksh ${currencyFormat.format(widget.loan.repaid)}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Balance: ",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "Ksh ${currencyFormat.format(widget.loan.balance)}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Applied On: ",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "${defaultDateFormat.format(widget.loan.applicationDate)}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionHandleColor
                                    .withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        amountTextInputField(
                            context: context,
                            labelText: "Amount to repay",
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
                        Container(
                          width: double.infinity,
                          child: defaultButton(
                              context: context,
                              text: "Pay Now",
                              onPressed: () => _numberToPrompt()),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
