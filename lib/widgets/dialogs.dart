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
