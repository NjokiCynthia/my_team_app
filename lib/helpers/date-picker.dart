import 'dart:async';

import 'package:flutter/material.dart';

import 'common.dart';

class DatePicker extends StatelessWidget {
  final String labelText;
  final DateTime selectedDate, lastDate,firstDate;
  final ValueChanged<DateTime> selectDate;

  const DatePicker({
    required Key key,
    required this.labelText,
    required this.selectedDate,
    required this.selectDate,
    required this.lastDate,
    required this.firstDate,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate==null?new DateTime(1970, 8):firstDate,
        lastDate:
            lastDate.isAfter(selectedDate) ? lastDate : new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return new _InputDropdown(
      labelText: labelText,
      valueText: defaultDateFormat.format(selectedDate),
      valueStyle: inputTextStyle(),
      onPressed: () {
        _selectDate(context);
      }, child: null,
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key? key, 
        required this.child,
      required this.labelText,
      required this.valueText,
      required this.valueStyle,
      required this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelStyle: inputTextStyle(),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Theme.of(context).hintColor,
            width: 1.0,
          )),
        ),
//        baseStyle: valueStyle,
        child: Text(
          valueText,
//                style: valueStyle,
        ),
      ),
    );
  }
}
