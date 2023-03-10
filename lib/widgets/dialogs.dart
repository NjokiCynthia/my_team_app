import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';

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
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor),
            actions: <Widget>[
              negativeActionDialogButton(
                  text: "OKAY",
                  // ignore: deprecated_member_use
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
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
                  color:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
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
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  negativeActionDialogButton(
                    text: noText,
                    // ignore: deprecated_member_use
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
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
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  negativeActionDialogButton(
                    text: noText,
                    // ignore: deprecated_member_use
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
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

void twoButtonAlertDialogWithContentList(
    {BuildContext context,
    String message,
    // String title,
    Function action,
    String promptMessage,
    String confirmMessage,
    String yesText = "YES",
    String noText = "Cancel"}) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            insetPadding: EdgeInsets.all(17),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: ListBody(
                  children: [
                    subtitle2(text: promptMessage, textAlign: TextAlign.start),
                    SizedBox(
                      height: 7,
                    ),
                    Text("Phone: ${message}"),
                    SizedBox(
                      height: 7,
                    ),
                    subtitle2(text: confirmMessage, textAlign: TextAlign.start)
                  ],
                ),
              ),
            ),
            // title: heading2(
            //     text: title,
            //     textAlign: TextAlign.start,
            //     // ignore: deprecated_member_use
            //     color: Theme.of(context).textSelectionHandleColor),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  actionDialogButtonWithBgColor(
                      text: noText,
                      buttonSize: 110,
                      textColor: Theme.of(context).primaryColor,
                      color: Color.fromRGBO(229, 212, 210, 1),
                      action: () {
                        Navigator.of(context).pop();
                      }),
                  SizedBox(
                    width: 20.0,
                  ),
                  actionDialogButtonWithBgColor(
                      text: yesText,
                      buttonSize: 110,
                      color: Theme.of(context).primaryColor,
                      action: action),
                  SizedBox(
                    width: 6.0,
                  ),
                ],
              ),
            ],
          ));
}

void twoButtonAlertDialogWithoutTitle(
    {BuildContext context,
    String message,
    // String title,
    Function chatAction,
    Function callAction,
    String yesText = "Continue",
    String noText = "Chat"}) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: customTitleWithWrap(
                text: message, textAlign: TextAlign.start, maxLines: null),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // negativeActionDialogButton(
                  //   text: noText,
                  //   // ignore: deprecated_member_use
                  //   color: Theme.of(context).textSelectionHandleColor,
                  //   action: chatAction,
                  // ),
                  actionDialogButtonWithBgColor(
                      text: noText,
                      buttonSize: 80,
                      textColor: Theme.of(context).primaryColor,
                      color: Color.fromRGBO(229, 212, 210, 1),
                      action: chatAction),
                  SizedBox(
                    width: 20.0,
                  ),
                  // positiveActionDialogButton(
                  //   text: yesText,
                  //   color: primaryColor,
                  //   action: callAction,
                  // ),
                  actionDialogButtonWithBgColor(
                      text: yesText,
                      buttonSize: 80,
                      color: Theme.of(context).primaryColor,
                      action: callAction),
                  SizedBox(
                    width: 6.0,
                  ),
                ],
              ),
            ],
          ));
}
