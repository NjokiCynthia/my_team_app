import 'package:chamasoft/screens/chamasoft/models/string-named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';

class CustomDropDownStringOnlyButton extends StatelessWidget {
  final String selectedItem;
  final String labelText;
  final Function onChanged, validator;
  final List<StringNamesListItem> listItems;
  final bool enabled;

  const CustomDropDownStringOnlyButton({this.selectedItem, this.labelText, this.onChanged, this.listItems, this.validator, this.enabled});

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: validator,
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              InputDecorator(
                decoration: InputDecoration(
                  filled: false,
                  labelStyle: inputTextStyle(),
                  hintStyle: inputTextStyle(),
                  errorStyle: inputTextStyle(),
                  hintText: labelText,
                  labelText: selectedItem == null ? labelText : labelText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 1.0,
                    ),
                  ),
                ),
                isEmpty: selectedItem == null,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Theme.of(context).cardColor,
                  ),
                  child: new DropdownButton(
                    value: selectedItem,
                    isDense: true,
                    onChanged: onChanged,
                    items: listItems.map((StringNamesListItem item) {
                      return new DropdownMenuItem(
                        value: item.id,
                        child: new Text(
                          item.name,
                          style: inputTextStyle(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
