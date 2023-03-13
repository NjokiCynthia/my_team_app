import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

class SortContainer extends StatefulWidget {
  final String selectedSort;
  final void Function(String) applySort;

  SortContainer(this.selectedSort, this.applySort);

  @override
  _SortContainerState createState() => _SortContainerState();
}

class _SortContainerState extends State<SortContainer> {
  int selectedRadioTile;

  void setSelectedRadioTile(int value) {
    setState(() {
      selectedRadioTile = value;
    });
  }

  @override
  void initState() {
    if (widget.selectedSort == "date_desc") {
      selectedRadioTile = 1;
    } else if (widget.selectedSort == "date_asc") {
      selectedRadioTile = 2;
    }
    if (widget.selectedSort == "amount_desc") {
      selectedRadioTile = 3;
    } else if (widget.selectedSort == "amount_asc") {
      selectedRadioTile = 4;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                width: double.infinity,
                color: primaryColor,
                child: customTitle(
                    textAlign: TextAlign.start,
                    text: "SORT BY",
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: double.infinity,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RadioListTile(
                      value: 1,
                      groupValue: selectedRadioTile,
                      title: subtitle1(
                          text: "Transaction Date: Newest First",
                          textAlign: TextAlign.start,
                          // ignore: deprecated_member_use
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor),
                      onChanged: (value) {
                        widget.applySort("date_desc");
                        Navigator.pop(context);
                      },
                      activeColor: primaryColor,
                      selected: true,
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedRadioTile,
                      title: subtitle1(
                          text: "Transaction Date: Oldest First",
                          textAlign: TextAlign.start,
                          // ignore: deprecated_member_use
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor),
                      onChanged: (value) {
                        widget.applySort("date_asc");
                        Navigator.pop(context);
                      },
                      activeColor: primaryColor,
                      selected: false,
                    ),
                    RadioListTile(
                      value: 3,
                      groupValue: selectedRadioTile,
                      title: subtitle1(
                          text: "Amount: Highest to Lowest",
                          textAlign: TextAlign.start,
                          // ignore: deprecated_member_use
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor),
                      onChanged: (value) {
                        widget.applySort("amount_desc");
                        Navigator.pop(context);
                      },
                      activeColor: primaryColor,
                      selected: false,
                    ),
                    RadioListTile(
                      value: 4,
                      groupValue: selectedRadioTile,
                      title: subtitle1(
                          text: "Amount: Lowest to Highest",
                          textAlign: TextAlign.start,
                          // ignore: deprecated_member_use
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor),
                      onChanged: (value) {
                        widget.applySort("amount_asc");
                        Navigator.pop(context);
                      },
                      activeColor: primaryColor,
                      selected: false,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
