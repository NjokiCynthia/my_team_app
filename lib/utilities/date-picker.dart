import 'dart:async';

import 'package:flutter/material.dart';

import 'common.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(1970, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.body1;
    return new _InputDropdown(
      labelText: labelText,
      valueText: defaultDateFormat.format(selectedDate),
      valueStyle: valueStyle,
      onPressed: () {
        _selectDate(context);
      },
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          hasFloatingPlaceholder: true,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Theme.of(context).hintColor,
            width: 2.0,
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
