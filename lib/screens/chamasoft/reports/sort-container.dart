import 'package:chamasoft/utilities/theme.dart';
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
    selectedRadioTile = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).backgroundColor,
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
                          color: Theme.of(context).textSelectionHandleColor),
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
                          color: Theme.of(context).textSelectionHandleColor),
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
                          text: "Amount: Highest to lowest",
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
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
                          text: "Amount: Lowest to highest",
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
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
