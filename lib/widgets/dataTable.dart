import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataRow> rowItems;
  const CustomDataTable({Key key, this.rowItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
        dataRowHeight: 50.0,
        showBottomBorder: true,
        headingRowColor: MaterialStateColor.resolveWith(
          (states) => (themeChangeProvider.darkTheme)
              ? Colors.blueGrey[800]
              : Color(0xffededfe),
        ),
        columnSpacing: 20.0,
        columns: [
          DataColumn(label: subtitle2(text: 'Date')),
          DataColumn(label: subtitle2(text: 'Payment')),
          DataColumn(label: subtitle2(text: 'Interest')),
          DataColumn(label: subtitle2(text: 'Principal')),
          DataColumn(label: subtitle2(text: 'Balance'))
        ],
        rows: rowItems);
  }
}
