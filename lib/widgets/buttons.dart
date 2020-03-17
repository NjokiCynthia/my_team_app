import 'package:flutter/material.dart';

Widget defaultButton({ BuildContext context, String text, Function onPressed}) {
  return RaisedButton(
    color: Colors.blue,
    child: Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Text(text),
    ),
    textColor: Colors.white,
    onPressed: onPressed,
  );
}
