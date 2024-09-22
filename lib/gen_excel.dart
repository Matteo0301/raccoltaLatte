import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raccoltalatte/collections/collection.dart';
import 'package:raccoltalatte/requests.dart';

Future<List<Collection>> getCollectionsByOrigin(
    DateTime date, bool admin, String username, String origin) async {
  DateTime end = date.copyWith(month: date.month + 1, day: 0, hour: 12);
  DateTime start = end.copyWith(day: 0, hour: 12);
  String endDate = end.toIso8601String();
  String startDate = start.toIso8601String();
  final res = (await getCollections(username, admin, startDate, endDate))
      .where((element) => element.origin == origin)
      .toList();
  return res;
}

Future<List<Collection>> getCollectionList(
  DateTime date,
  bool admin,
  String username,
) async {
  DateTime end = date.copyWith(month: date.month + 1, day: 0, hour: 12);
  DateTime start = end.copyWith(day: 0, hour: 12);
  String endDate = end.toIso8601String();
  String startDate = start.toIso8601String();
  final res = await getCollections(username, admin, startDate, endDate);
  return res;
}

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

Future<Map<String, Map<int, int>>> getOriginMap(
    bool admin, String username, String origin) async {
  final DateTime date = DateTime.now();
  final List<Collection> coll =
      await getCollectionsByOrigin(date, admin, username, origin);
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

Future<Map<String, Map<int, int>>> getCollectionsMap(
    DateTime date, bool admin, String username) async {
  List<Collection> coll = await getCollectionList(date, admin, username);
  final Map<String, Map<int, int>> res = {};
  for (var element in coll) {
    final String origin = element.origin;
    final int day = getDay(element);
    if (!res.containsKey(origin)) {
      res[origin] = {};
    }
    final int old = (res[origin]![day]) ?? 0;
    res[origin]![day] = old + element.quantity + element.quantity2;
  }
  return res;
}

void fillExcel(Excel excel, DateTime date, List<String> k,
    Map<String, Map<int, int>> map) {
  final DateTime end = date.copyWith(month: date.month + 1, day: 0, hour: 12);
  List<CellValue> header = [TextCellValue('')];

  for (int i = 1; i <= end.day; i++) {
    header.add(TextCellValue('$i'));
  }
  header.add(TextCellValue('Totale'));
  excel['Sheet1'].appendRow(header);
  for (var key in k) {
    final List<CellValue> row = [TextCellValue(key)];
    int total = 0;
    for (int i = 1; i <= end.day; i++) {
      int quantity = map[key] != null ? (map[key]![i] ?? 0) : 0;
      row.add(IntCellValue(quantity));
      total += quantity;
    }
    row.add(IntCellValue(total));
    excel['Sheet1'].appendRow(row);
  }
}

void genExcel(
    String filename, Map<String, Map<int, int>> map, List<String> k) async {
  var excel = Excel.createExcel();
  fillExcel(excel, DateTime.now(), k, map);
  if (kIsWeb) {
    excel.save(fileName: filename);
  } else {
    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();
    if (fileBytes != null) {
      File('$directory/output_file_name.xlsx')
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
  }
}
