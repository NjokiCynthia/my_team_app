import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void alertDialog(BuildContext context, String message, [String title = "Something went wrong"]) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            content: customTitleWithWrap(text: message, textAlign: TextAlign.start),
            title: heading2(text: title, textAlign: TextAlign.start),
            actions: <Widget>[
              FlatButton(
                child: subtitle1(text: "OKAY"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
}

void cupertinoAlertDialogWithTwoButtons(BuildContext context, String message, Function onPressed, [String title = "Something went wrong"]) {}
