import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget amountInputField(
    BuildContext context, String labelText, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
      WhitelistingTextInputFormatter.digitsOnly,
    ],
    decoration: InputDecoration(
      hasFloatingPlaceholder: true,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
        color: Theme.of(context).hintColor,
        width: 2.0,
      )),
      // hintText: 'Phone Number or Email Address',
      labelText: labelText,
    ),
  );
}
