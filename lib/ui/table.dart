import 'package:flutter/material.dart';

class AppTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;

  const AppTable({required this.columns, required this.rows, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
        rows: rows.map((r) => DataRow(cells: r.map((c) => DataCell(Text(c))).toList())).toList(),
      ),
    );
  }
}
