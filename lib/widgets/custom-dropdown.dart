import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  final int selectedItem;
  final String labelText;
  final Function onChanged, validator;
  final List<NamesListItem> listItems;
  final bool enabled;

  const CustomDropDownButton({
    this.selectedItem,
    this.labelText,
    this.onChanged,
    this.validator,
    this.listItems,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: FormField(
        builder: (FormFieldState state) {
          return DropdownButtonHideUnderline(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField(
                  isExpanded: true,
                  value: selectedItem,
                  items: listItems.map((NamesListItem item) {
                    return new DropdownMenuItem(
                      value: item.id,
                      child: new Text(
                        item.name,
                        style: inputTextStyle(),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelStyle: inputTextStyle(),
                      hintStyle: inputTextStyle(),
                      errorStyle: inputTextStyle(),
                      hintText: labelText,
                      labelText: selectedItem == 0 ? labelText : labelText,
                      enabled: enabled ?? true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                          width: 1.0,
                        ),
                      )),
                  validator: validator,
                  onChanged: onChanged,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
