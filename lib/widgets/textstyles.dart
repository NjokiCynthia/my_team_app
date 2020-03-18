import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget heading1({String text, Color color}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 24.0,
      color: color,
    ),
  );
}

Widget heading2({String text, Color color}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 18.0,
      color: color,
    ),
  );
}

Widget subtitle1({String text, Color color}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
      color: color,
    ),
  );
}

Widget subtitle2({String text, Color color}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.0,
      color: color,
    ),
  );
}

Widget textWithExternalLinks({Map<String, Map<String, dynamic>> textData, Color color, double size}) {
  if(textData.isNotEmpty) {
    List<TextSpan> _children = [];
    textData.forEach((text, options){
      _children.add(
        options.isNotEmpty ? TextSpan(
          text: text.trim() + ' ',
          recognizer: TapGestureRecognizer()
          ..onTap = options['url'],
          style: TextStyle(
            color: options['color'], 
            fontWeight: options['weight']
          )
        ) : TextSpan(
          text: text.trim() + ' ',
        ),
      );
    });
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: size,
          color: color,
        ),
        children: _children,
      ),
    );
  } else {
    return subtitle2(text: "", color: Colors.blueGrey);
  }
}