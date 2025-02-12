import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:raccoltalatte/collections/collection.dart';
import 'package:raccoltalatte/config.dart';
import 'package:raccoltalatte/employees/employee.dart';
import 'package:raccoltalatte/origins/origin.dart';
import 'package:raccoltalatte/secrets.dart';
import 'package:raccoltalatte/utils.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;
const String imagePrefix = 'image_';
const String storagePath = 'images/';
const String employeesTable = 'employees';
const String originsTable = 'origins';
const String collectionsTable = 'collections';

Future<List<Origin>> getOrigins() async {
  try {
    final List<Origin> list;
    if (useCache) {
      list = (await db
              .collection(originsTable)
              .get(const GetOptions(source: Source.cache)))
          .docs
          .map((e) => Origin.fromJson(e.data(), e.id))
          .toList();
    } else {
      list = (await db.collection(originsTable).get())
          .docs
          .map((e) => Origin.fromJson(e.data(), e.id))
          .toList();
    }

    return list;
  } catch (e) {
    return Future.error('Impossibile effettuare l\'operazione');
  }
}

Future<void> removeOrigin(String name) async {
  String id =
      (await db.collection(originsTable).where('name', isEqualTo: name).get())
          .docs
          .first
          .id;
  db.collection(originsTable).doc(id).delete();
}

Future<void> updateOrigin(String name, Origin origin) async {
  String id =
      (await db.collection(originsTable).where('name', isEqualTo: name).get())
          .docs
          .first
          .id;
  db.collection(originsTable).doc(id).set(origin.toJson());
}

Future<void> addOrigin(Origin origin) async {
  await db.collection(originsTable).add(origin.toJson());
}

Future<void> removeEmployee(String name) async {
  String id =
      (await db.collection(employeesTable).where('name', isEqualTo: name).get())
          .docs
          .first
          .id;
  db.collection(employeesTable).doc(id).delete();
}

Future<void> updateEmployee(String name, Employee employee) async {
  String id =
      (await db.collection(employeesTable).where('name', isEqualTo: name).get())
          .docs
          .first
          .id;
  db.collection(employeesTable).doc(id).set(employee.toJson());
}

Future<void> addEmployee(Employee employee) async {
  await db.collection(employeesTable).add(employee.toJson());
}

Future<List<Employee>> getEmployees() async {
  try {
    final list = (await db.collection(employeesTable).get())
        .docs
        .map((e) => Employee.fromJson(e.data(), e.id))
        .toList();
    return list;
  } catch (e) {
    return Future.error('Impossibile effettuare l\'operazione');
  }
}

getCollectionsQuery(
    String username, bool admin, String startDate, String endDate) {
  final baseQuery = db
      .collection(collectionsTable)
      .where('date', isGreaterThan: startDate)
      .where('date', isLessThan: endDate);
  final finalQuery =
      ((admin) ? baseQuery : baseQuery.where('user', isEqualTo: username));
  return finalQuery.orderBy('date', descending: true);
}

Future<List<Collection>> getCollections(
    String username, bool admin, String startDate, String endDate) async {
  final query = getCollectionsQuery(username, admin, startDate, endDate);
  return (await query.get())
      .docs
      .map<Collection>((e) => Collection.fromJson(e.data(), e.id))
      .toList();
}

Future<void> addCollection(Collection collection) async {
  await db.collection(collectionsTable).add(collection.toJson());
}

Future<void> uploadFile(File file, String remoteName) async {
  debugPrint(remoteName);
  await storage.ref(remoteName).putFile(file);
}

void queueFile(File file, String date) {
  FileList.sent = false;
  FileList.filenames.add(Tuple2(file, date));
}

String remoteName(DateTime date) {
  return storagePath + imagePrefix + date.toIso8601String();
}

Future<String?> getImageURL(DateTime date) async {
  debugPrint(imagePrefix + date.toIso8601String());
  try {
    return (await storage
        .ref(storagePath)
        .child(imagePrefix + date.toIso8601String())
        .getDownloadURL());
  } catch (_) {
    return null;
  }
}

Future<void> removeCollection(String date) async {
  String id = (await db
          .collection(collectionsTable)
          .where('date', isEqualTo: date)
          .get())
      .docs
      .first
      .id;
  db.collection(collectionsTable).doc(id).delete();
}

Future<Tuple2<double, double>> address2Coordinates(String address) async {
  final String url =
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeFull(address)}&key=$key';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      if (res['status'] == 'OK') {
        var lat = res['results'][0]['geometry']['location']['lat'];
        var lng = res['results'][0]['geometry']['location']['lng'];
        return Tuple2(lat, lng);
      } else {
        return Future.error('Indirizzo non trovato');
      }
    } else {
      return Future.error('Errore durante l\'operazione');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi');
  }
}
