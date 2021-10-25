import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';


class ChamasoftGuarantors1 extends StatelessWidget {
  ChamasoftGuarantors1(chamaSoftGuarantors);

  //const ChamasoftGuarantors({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final List<NamesListItem> _memberOptions =
        arguments['formLoadData'].containsKey("memberOptions")
            ? arguments['formLoadData']['memberOptions']
            : [];

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: heading2(text: "Guarantors:"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: CustomDropDownButton(
                  enabled: true,
                  labelText: "Select guarantor ",
                  listItems: _memberOptions,
                  onChanged: () {},
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "This field is required";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 25.0,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: amountTextInputField(
                    context: context,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "The field is required";
                      }
                      return null;
                    },
                    labelText: "Enter Amount",
                    enabled: true,
                    onChanged: (value) {}),
              ))
            ],
          ),
        ],
      ),
    );
  }
}
