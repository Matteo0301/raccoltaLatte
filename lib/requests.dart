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

Future<List<Origin>> getOrigins() async {
  try {
    return (await db.collection('origins').get())
        .docs
        .map((e) => Origin.fromJson(e.data(), e.id))
        .toList();
  } catch (e) {
    return Future.error('Impossibile effettuare l\'operazione');
  }
}

Future<void> removeOrigins(String name) async {
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

Future<List<Collection>> getCollections(
    String username, bool admin, String startDate, String endDate) async {
  final baseQuery = db
      .collection('collections')
      .where('date', isGreaterThan: startDate)
      .where('date', isLessThan: endDate);
  final finalQuery =
      (admin) ? baseQuery : baseQuery.where('user', isEqualTo: username);
  return (await finalQuery.get())
      .docs
      .map((e) => Collection.fromJson(e.data(), e.id))
      .toList();
}

Future<void> addCollection(Collection collection, String? filename) async {
  await db.collection('collections').add(collection.toJson());
}

Future<void> uploadFile(File file) async {
  await storage.ref().putFile(file);
}

Future<String> getImageURL(DateTime date) async {
  return (await storage.ref().child(date.toIso8601String()).getDownloadURL());
}

Future<void> removeCollections(List<Collection> collections) async {
  final WriteBatch batch = db.batch();
  await db
      .collection('collections')
      .where('date',
          whereIn: collections.map(
            (e) => e.date.toIso8601String(),
          ))
      .get()
      .then(
    (querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });

      return batch.commit();
    },
  );
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
