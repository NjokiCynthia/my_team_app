import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataRow> rowItems;
  const CustomDataTable({Key key, this.rowItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
        dataRowHeight: 30.0,
        showBottomBorder: true,
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.cyanAccent),
        columnSpacing: 30.0,
        columns: [
          DataColumn(label: Text('No.')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Interest')),
          DataColumn(label: Text('Principal')),
          DataColumn(label: Text('Balance'))
        ],
        rows: rowItems);
  }
}
