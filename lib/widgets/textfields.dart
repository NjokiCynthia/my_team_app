import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget simpleTextInputField(
    {BuildContext context, String labelText, Function onChanged,String hintText = ''}) {
  return TextFormField(
    onChanged: onChanged,
    style: inputTextStyle(),
    keyboardType: TextInputType.text,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      hasFloatingPlaceholder: true,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
        color: Theme.of(context).hintColor,
        width: 1.0,
      )),
      hintText: hintText,
      labelText: labelText,
    ),
  );
}

Widget amountTextInputField(
    {BuildContext context, String labelText, Function onChanged,String hintText = ''}) {
  return TextFormField(
    onChanged: onChanged,
    style: inputTextStyle(),
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
      WhitelistingTextInputFormatter.digitsOnly,
    ],
    decoration: InputDecoration(
      hasFloatingPlaceholder: true,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
        color: Theme.of(context).hintColor,
        width: 1.0,
      )),
      hintText: hintText,
      labelText: labelText,
    ),
  );
}

Widget multilineTextField(
    {BuildContext context,
    String labelText,
    Function onChanged,
    int maxLines = 4}) {
  return TextFormField(
    keyboardType: TextInputType.multiline,
    maxLines: maxLines,
    minLines: 1,
    onChanged: onChanged,
    decoration: InputDecoration(
      hasFloatingPlaceholder: true,
      labelStyle: inputTextStyle(),
      errorStyle: inputTextStyle(),
      hintStyle: inputTextStyle(),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
        color: Theme.of(context).hintColor,
        width: 1.0,
      )),
      labelText: labelText,
    ),
  );
}
