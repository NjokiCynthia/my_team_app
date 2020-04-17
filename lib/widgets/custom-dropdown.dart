import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:flutter/material.dart';
class CustomDropDownButton extends StatelessWidget {
  final int selectedItem;
  final String labelText;
  final Function onChanged;
  final List<NamesListItem> listItems;
  const CustomDropDownButton({
    this.selectedItem,
    this.labelText,
    this.onChanged,
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
              InputDecorator(
                decoration: InputDecoration(
                  filled: false,
                  hintText: labelText,
                  labelText: selectedItem == 0 ? labelText : labelText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 2.0,
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
                    items: listItems.map((NamesListItem item) {
                      return new DropdownMenuItem(
                        value: item.id,
                        child: new Text(
                          item.name,
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