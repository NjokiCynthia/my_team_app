import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class AmountToWithdraw extends StatefulWidget {
  @override
  _AmountToWithdrawState createState() => _AmountToWithdrawState();
}

class _AmountToWithdrawState extends State<AmountToWithdraw> {
  double amount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.close,
          title: "Set Amount To Withdraw",
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16.0),
                  width: double.infinity,
                  color: (themeChangeProvider.darkTheme)
                      ? Colors.blueGrey[800]
                      : Color(0xffededfe),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: heading2(
                              text: "Expense Payment",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: heading2(
                              text: "Audit Fees",
                              color: Theme.of(context).textSelectionHandleColor,
                              align: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          subtitle1(
                            text: "Recipient: ",
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                          Expanded(
                              child: customTitle(
                            align: TextAlign.start,
                            text: "Peter Parker - 0712000111",
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w600,
                          )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          subtitle1(
                            text: "Description: ",
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                          customTitle(
                            align: TextAlign.start,
                            text: "Give unto Ceasar",
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        amountTextInputField(
                            context: context,
                            labelText: 'Amount to withdraw',
                            onChanged: (value) {
                              setState(() {
                                amount = double.parse(value);
                              });
                            }),
                        SizedBox(
                          height: 24,
                        ),
                        defaultButton(
                          context: context,
                          text: "SUBMIT REQUEST",
                          onPressed: () {
                            print('Amount: $amount');
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
