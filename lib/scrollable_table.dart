import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class ScrollableTable extends StatelessWidget {
  final Map<String, Map<int, int>> map;
  final DateTime date;
  final List<String> k;

  const ScrollableTable(
      {super.key, required this.map, required this.date, required this.k});

  @override
  Widget build(BuildContext context) {
    DateTime end = date.copyWith(month: date.month + 1, day: 0, hour: 12);
    const leftWidth = 100.0;
    const rightWidth = 65.0;
    const height = 40.0;
    const leftPadding = 10.0;
    BoxDecoration decoration = BoxDecoration(
      border: Border.all(color: Colors.black),
    );

    List<Container> header = [
      Container(
          decoration: decoration,
          width: leftWidth,
          height: height,
          child: const Padding(
              padding: EdgeInsets.all(leftPadding),
              child: Text('', style: TextStyle(fontWeight: FontWeight.bold))))
    ];

    for (int i = 1; i <= end.day; i++) {
      header.add(Container(
          decoration: decoration,
          width: rightWidth,
          height: height,
          child: Padding(
              padding: const EdgeInsets.all(leftPadding),
              child: Text('$i',
                  style: const TextStyle(fontWeight: FontWeight.bold)))));
    }
    header.add(Container(
        decoration: decoration,
        width: rightWidth,
        height: height,
        child: const Padding(
            padding: EdgeInsets.all(leftPadding),
            child: Text('Totale',
                style: TextStyle(fontWeight: FontWeight.bold)))));
    final List<Row> leftRows = [];
    final List<Row> rightRows = [];
    for (var key in k) {
      final List<Container> left = [
        Container(
            decoration: decoration,
            width: leftWidth,
            height: height,
            child: Padding(
                padding: const EdgeInsets.all(leftPadding), child: Text(key)))
      ];
      final List<Container> right = [];
      int total = 0;
      for (int i = 1; i <= end.day; i++) {
        int quantity = map[key] != null ? (map[key]![i] ?? 0) : 0;
        right.add(Container(
            decoration: decoration,
            width: rightWidth,
            height: height,
            child: Padding(
                padding: const EdgeInsets.all(leftPadding),
                child: Text('$quantity'))));
        total += quantity;
      }
      right.add(Container(
          decoration: decoration,
          width: rightWidth,
          height: height,
          child: Padding(
              padding: const EdgeInsets.all(leftPadding),
              child: Text('$total',
                  style: const TextStyle(fontWeight: FontWeight.bold)))));
      leftRows.add(Row(
        children: left,
      ));
      rightRows.add(Row(
        children: right,
      ));
    }
    return SizedBox(
        height: (k.length + 1) * height,
        width: MediaQuery.of(context).size.width,
        child: HorizontalDataTable(
          leftHandSideColumnWidth: leftWidth,
          rightHandSideColumnWidth: 2080,
          leftSideChildren: leftRows,
          rightSideChildren: rightRows,
          horizontalScrollbarStyle: const ScrollbarStyle(isAlwaysShown: true),
          headerWidgets: header,
          isFixedHeader: true,
        ));
  }
}
