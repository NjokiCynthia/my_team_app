import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterStatements extends StatefulWidget {
  final int statementFlag;
  final Function applyFilter;

  FilterStatements(this.statementFlag, this.applyFilter);

  @override
  _FilterStatementsState createState() => _FilterStatementsState();
}

class _FilterStatementsState extends State<FilterStatements> {
  String defaultTitle = "Contributions";
  String single = "Contribution";

  void applyFilter() {
    widget.applyFilter();
    Navigator.of(context).pop();
  }

  DateTime fromDate = DateTime.now().subtract(Duration(days: 90));
  DateTime toDate = DateTime.now();

  Future<Null> _selectDate(
      BuildContext context, int sender, DateTime initialDate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1970, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != initialDate)
      setState(() {
        if (sender == 1) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.statementFlag == FINE_STATEMENT) {
      defaultTitle = "Fines";
      single = "Fine";
    }

    return Container(
      height: 250,
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              height: 10,
              width: 100,
              decoration: BoxDecoration(
                  color: Color(0xffededfe),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(5)))),
          SizedBox(
            height: 5,
          ),
          subtitle1(
              text: "Filter " + defaultTitle,
             
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              textAlign: TextAlign.start),
          SizedBox(
            height: 5,
          ),
          subtitle2(
              text: "Select " + single,
             
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              textAlign: TextAlign.start),
          FilterButton(
            text: "All " + defaultTitle,
          ),
          SizedBox(
            height: 5,
          ),
          subtitle2(
              text: "Statement Period",
             
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              textAlign: TextAlign.start),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FilterButton(
                text: DateFormat.yMMMd().format(fromDate),
                onPressed: () => _selectDate(context, 1, fromDate),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: subtitle2(
                    text: "to",
                   
                    color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                    textAlign: TextAlign.start),
              ),
              FilterButton(
                text: DateFormat.yMMMd().format(toDate),
                onPressed: () => _selectDate(context, 2, toDate),
              ),
            ],
          ),
         
          // RaisedButton(
          //   color: primaryColor,
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          //     child: Text("Apply Filter"),
          //   ),
          //   textColor: Colors.white,
          //   onPressed: () => applyFilter(),
          // )
          ElevatedButton(
            onPressed: () => applyFilter(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Text("Apply Filter"),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor, // sets the button's background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // sets the button's border radius
              ),
            ),
          )

        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({Key key, this.text, this.onPressed}) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
   
    // return OutlineButton(
    //     child: subtitle1(
    //         text: text, color: primaryColor, textAlign: TextAlign.center),
    //     onPressed: onPressed,
    //     color: primaryColor,
    //     highlightedBorderColor: primaryColor.withOpacity(0.5),
    //     disabledBorderColor: primaryColor.withOpacity(0.5),
    //     borderSide: BorderSide(
    //       width: 2.0,
    //       color: primaryColor.withOpacity(0.5),
    //     ),
    //     shape: new RoundedRectangleBorder(
    //         borderRadius: new BorderRadius.circular(5.0)));
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor, shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // sets the button's border radius
        ), disabledForegroundColor: primaryColor.withOpacity(0.5).withOpacity(0.38),
        side: BorderSide(
          color: primaryColor.withOpacity(0.5), // sets the button's border color
          width: 2.0,
        ),
        backgroundColor: primaryColor,
      ),
      child: subtitle1(text: text, color: primaryColor, textAlign: TextAlign.center),
    );

  }
}
