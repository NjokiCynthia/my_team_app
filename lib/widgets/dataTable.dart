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
        DataColumn(label: subtitle3(text: 'Date')),
        DataColumn(label: subtitle3(text: 'Payment')),
        DataColumn(label: subtitle3(text: 'Principal')),
        DataColumn(label: subtitle3(text: 'Interest')),
        DataColumn(label: subtitle3(text: 'Balance'))
      ],
      rows: rowItems,
    );
  }
}
