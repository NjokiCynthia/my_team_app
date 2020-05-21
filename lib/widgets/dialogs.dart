import 'package:flutter/material.dart';

Widget alertDialog(BuildContext context, String message){
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
          content: Text(message),
          title: Text("Something went wrong"),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
}