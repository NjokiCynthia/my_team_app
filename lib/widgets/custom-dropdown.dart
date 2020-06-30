import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  final int selectedItem;
  final String labelText;
  final Function onChanged,validator;
  final List<NamesListItem> listItems;

  const CustomDropDownButton({
    this.selectedItem,
    this.labelText,
    this.onChanged,
    this.validator,
    this.listItems,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //InputDecorator(
                // decoration: InputDecoration(
                //   icon: const Icon(Icons.laptop),
                //   border: InputBorder.none,
                //   focusedBorder: InputBorder.none,
                //   enabledBorder: InputBorder.none,
                //   errorBorder: InputBorder.none,
                //   disabledBorder: InputBorder.none,
                //   contentPadding:EdgeInsets.all(0.0),
                //   hintText: labelText,
                //   filled: false,
                //   labelStyle: inputTextStyle(),
                //   hintStyle: inputTextStyle(),
                //   errorStyle: inputTextStyle(),
                //   labelText: selectedItem == 0 ? labelText : labelText,
                // ),
                DropdownButtonFormField(
                  hint: Text(labelText),
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
                  isDense: true,
                  onChanged: onChanged,
                  validator: validator,
                )
              //)
            ],
          ),
        );
      },
    );
  }
}
