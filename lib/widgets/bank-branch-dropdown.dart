import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/material.dart';

class BankBranchDropdown extends StatelessWidget {
  final int selectedItem;
  final String labelText;
  final Function onChanged;
  final List<BankBranch> listItems;

  const BankBranchDropdown({
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
                  labelStyle: inputTextStyle(),
                  hintStyle: inputTextStyle(),
                  errorStyle: inputTextStyle(),
                  hintText: labelText,
                  labelText: selectedItem == 0 ? labelText : labelText,
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
                    items: listItems.map((BankBranch item) {
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
