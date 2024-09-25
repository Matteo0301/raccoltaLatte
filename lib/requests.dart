import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:raccoltalatte/collections/collection.dart';
import 'package:raccoltalatte/origins/origin.dart';
import 'package:raccoltalatte/secrets.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;
const String imagePrefix = 'image_';
const String storagePath = 'images/';

Future<List<Origin>> getOrigins() async {
  try {
    final list = (await db.collection('origins').get())
        .docs
        .map((e) => Origin.fromJson(e.data(), e.id))
        .toList();
    return list;
  } catch (e) {
    return Future.error('Impossibile effettuare l\'operazione');
  }
}

Future<void> removeOrigin(String name) async {
  String id =
      (await db.collection('origins').where('name', isEqualTo: name).get())
          .docs
          .first
          .id;
  db.collection('origins').doc(id).delete();
}

Future<void> updateOrigin(String name, Origin origin) async {
  String id =
      (await db.collection('origins').where('name', isEqualTo: name).get())
          .docs
          .first
          .id;
  db.collection('origins').doc(id).set(origin.toJson());
}

Future<void> addOrigin(Origin origin) async {
  await db.collection('origins').add(origin.toJson());
}

getCollectionsQuery(
    String username, bool admin, String startDate, String endDate) {
  final baseQuery = db
      .collection('collections')
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
  await db.collection('collections').add(collection.toJson());
}

Future<void> uploadFile(File file, DateTime date) async {
  await storage
      .ref(storagePath + imagePrefix + date.toIso8601String())
      .putFile(file);
}

Future<String?> getImageURL(DateTime date) async {
  try {
    return (await storage
        .ref(storagePath)
        .child('$imagePrefix${date.toIso8601String()}')
        .getDownloadURL());
  } catch (_) {
    return null;
  }
}

Future<void> removeCollection(String date) async {
  String id =
      (await db.collection('collections').where('date', isEqualTo: date).get())
          .docs
          .first
          .id;
  db.collection('collections').doc(id).delete();
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
