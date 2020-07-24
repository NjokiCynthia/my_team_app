import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

Widget simpleTextInputField(
    {BuildContext context,
    String labelText,
    bool enabled,
    Function onChanged,
    String hintText = '',
    TextEditingController controller,
    Function validator,
    Function onSaved}) {
  return TextFormField(
    onChanged: onChanged,
    style: inputTextStyle(),
    keyboardType: TextInputType.text,
    textCapitalization: TextCapitalization.sentences,
    validator: validator,
    onSaved: onSaved,
    controller: controller,
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
        color: Theme.of(context).hintColor,
        width: 1.0,
      )),
      hintText: hintText,
      labelText: labelText,
      enabled: enabled ?? true,
    ),
  );
}

Widget amountTextInputField(
    {BuildContext context,
    String labelText,
    Function onChanged,
    String hintText = '',
    TextEditingController controller,
    Function validator,
    Function onSaved,
    bool enabled = true}) {
  return TextFormField(
    enabled: enabled != null ? enabled : true,
    onChanged: onChanged,
    style: inputTextStyle(),
    controller: controller,
    inputFormatters: [_amountValidator],
    keyboardType: TextInputType.numberWithOptions(
      decimal: true,
      signed: false,
    ),
    validator: validator,
    onSaved: onSaved,
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
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
    String hintText = '',
    TextEditingController controller,
    Function validator,
    Function onSaved}) {
  return Padding(
    padding: EdgeInsets.only(top: 10),
    child: TextFormField(
      onChanged: onChanged,
      style: inputTextStyle(),
      inputFormatters: [_amountValidator],
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: false,
        signed: false,
      ),
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Theme.of(context).hintColor,
          width: 1.0,
        )),
        hintText: hintText,
        labelText: labelText,
      ),
    ),
  );
}

Widget multilineTextField({BuildContext context, String labelText, Function onChanged, Function validator, bool enabled, int maxLines}) {
  return TextFormField(
    keyboardType: TextInputType.multiline,
    maxLines: maxLines,
    minLines: 3,
    onChanged: onChanged,
    validator: validator,
    enabled: enabled ?? true,
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
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
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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
