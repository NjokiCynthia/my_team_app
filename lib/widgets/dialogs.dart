import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

void alertDialog(BuildContext context, String message, [String title = "Something went wrong"]) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            content: customTitleWithWrap(text: message, textAlign: TextAlign.start),
            title: heading2(text: title, textAlign: TextAlign.start),
            actions: <Widget>[
              FlatButton(
                child: subtitle1(text: "Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
}
