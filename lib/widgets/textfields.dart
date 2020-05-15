import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _amountValidator =
    RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

Widget simpleTextInputField(
    {BuildContext context,
    String labelText,
    Function onChanged,
    String hintText = ''}) {
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
    {BuildContext context,
    String labelText,
    Function onChanged,
    String hintText = ''}) {
  return TextFormField(
    onChanged: onChanged,
    style: inputTextStyle(),
    inputFormatters: [_amountValidator],
    keyboardType: TextInputType.numberWithOptions(
      decimal: true,
      signed: false,
    ),
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


Widget numberTextInputField(
    {BuildContext context,
      String labelText,
      Function onChanged,
      String hintText = ''}) {
  return TextFormField(
    onChanged: onChanged,
    style: inputTextStyle(),
    inputFormatters: [_amountValidator],
    keyboardType: TextInputType.numberWithOptions(
      decimal: false,
      signed: false,
    ),
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

class RegExInputFormatter implements TextInputFormatter {
  final RegExp _regExp;

  RegExInputFormatter._(this._regExp);

  factory RegExInputFormatter.withRegex(String regexString) {
    try {
      final regex = RegExp(regexString);
      return RegExInputFormatter._(regex);
    } catch (e) {
      // Something not right with regex string.
      assert(false, e.toString());
      return null;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = _isValid(oldValue.text);
    final newValueValid = _isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }

  bool _isValid(String value) {
    try {
      final matches = _regExp.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}
