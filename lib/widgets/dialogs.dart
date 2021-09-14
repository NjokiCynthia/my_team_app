import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void alertDialog(BuildContext context, String message,
    [String title = "Something went wrong"]) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            content: customTitleWithWrap(
                text: message, textAlign: TextAlign.start, maxLines: null),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: heading2(
                text: title,
                textAlign: TextAlign.start,
                // ignore: deprecated_member_use
                color: Theme.of(context).textSelectionHandleColor),
            actions: <Widget>[
              negativeActionDialogButton(
                  text: "OKAY",
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
                  action: () {
                    Navigator.of(context).pop();
                  })
            ],
          ));
}

void alertDialogWithAction(
    BuildContext context, String message, Function action,
    [bool dismissible = true]) {
  showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (ctx) => AlertDialog(
            content: customTitleWithWrap(
                text: message, textAlign: TextAlign.start, maxLines: null),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            actions: <Widget>[
              negativeActionDialogButton(
                  text: "OKAY",
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionHandleColor,
                  action: action)
            ],
          ));
}

void twoButtonAlertDialog(
    {BuildContext context,
    String message,
    String title,
    Function action,
    String yesText = "Continue",
    String noText = "Cancel"}) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: customTitleWithWrap(
                text: message, textAlign: TextAlign.start, maxLines: null),
            title: heading2(
                text: title,
                textAlign: TextAlign.start,
                // ignore: deprecated_member_use
                color: Theme.of(context).textSelectionHandleColor),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  negativeActionDialogButton(
                    text: noText,
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionHandleColor,
                    action: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  positiveActionDialogButton(
                    text: yesText,
                    color: primaryColor,
                    action: action,
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                ],
              ),
            ],
          ));
}

void twoButtonAlertDialogwithConteiner(
    {BuildContext context,
    Container message,
    String title,
    Function action,
    String yesText = "Continue",
    String noText = "Cancel"}) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Container(),
            title: heading2(
                text: title,
                textAlign: TextAlign.start,
                // ignore: deprecated_member_use
                color: Theme.of(context).textSelectionHandleColor),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  negativeActionDialogButton(
                    text: noText,
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionHandleColor,
                    action: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  positiveActionDialogButton(
                    text: yesText,
                    color: primaryColor,
                    action: action,
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                ],
              ),
            ],
          ));
}
