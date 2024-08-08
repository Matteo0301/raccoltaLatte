import 'package:raccoltalatte/collections/collection.dart';
import 'package:raccoltalatte/scrollable_table.dart';
import 'package:flutter/material.dart';

class DetailsTable extends StatelessWidget {
  final DateTime date;
  final ValueGetter<Future<List<Collection>>> request;

  const DetailsTable({super.key, required this.date, required this.request});

  int getDay(Collection c) {
    final DateTime res;
    if (c.date.hour >= 12) {
      res = c.date.copyWith(day: c.date.day + 1);
    } else {
      res = c.date;
    }
    return res.day;
  }

  String getRow(Collection c) {
    return (c.date.hour >= 12) ? 'sera' : 'mattina';
  }

  Map<String, Map<int, int>> getMap(List<Collection> coll) {
    final Map<String, Map<int, int>> res = {};
    for (var element in coll) {
      final String row = getRow(element);
      final int day = getDay(element);
      if (!res.containsKey(row)) {
        res[row] = {};
      }
      final int old = (res[row]![day]) ?? 0;
      res[row]![day] = old + element.quantity + element.quantity2;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: request(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Nessun dato trovato'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final Map<String, Map<int, int>> map = getMap(snapshot.data!);
          return ScrollableTable(
            map: map,
            date: date,
            k: map.keys.toList(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
