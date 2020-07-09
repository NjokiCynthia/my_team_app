import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void alertDialog(BuildContext context, String message, [String title = "Something went wrong"]) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            content: customTitleWithWrap(text: message, textAlign: TextAlign.start),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: heading2(text: title, textAlign: TextAlign.start, color: Theme.of(context).textSelectionHandleColor),
            actions: <Widget>[
              negativeActionDialogButton(
                  text: "OKAY",
                  color: Theme.of(context).textSelectionHandleColor,
                  action: () {
                    Navigator.of(context).pop();
                  })
            ],
          ));
}

void twoButtonAlertDialog(
    {BuildContext context, String message, String title, Function action, String yesText = "Continue", String noText = "Cancel"}) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: customTitleWithWrap(text: message, textAlign: TextAlign.start),
            title: heading2(text: title, textAlign: TextAlign.start, color: Theme.of(context).textSelectionHandleColor),
            actions: <Widget>[
              negativeActionDialogButton(
                  text: noText,
                  color: Theme.of(context).textSelectionHandleColor,
                  action: () {
                    Navigator.of(context).pop();
                  }),
              positiveActionDialogButton(text: yesText, color: primaryColor, action: action)
            ],
          ));
}

void addMemberDialog({BuildContext context}) {
  var width = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: heading2(textAlign: TextAlign.start, text: "Add Member", color: Theme.of(context).textSelectionHandleColor),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(
              builder: (context) {
                //var height = MediaQuery.of(context).size.height;
                return SingleChildScrollView(
                  child: Container(
                    width: width * 3 / 4,
                    child: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2.0)),
                                labelText: "Member Name",
                                labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2.0)),
                                labelText: "Phone Number",
                                labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2.0)),
                                labelText: "Email Address",
                                labelStyle: TextStyle(fontFamily: 'SegoeUI')),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            actions: <Widget>[
              negativeActionDialogButton(text: "Cancel", color: Theme.of(context).textSelectionHandleColor, action: () {}),
              positiveActionDialogButton(text: "Add", color: primaryColor, action: () {}),
              SizedBox(
                width: 10,
              ),
            ],
          ));
}
