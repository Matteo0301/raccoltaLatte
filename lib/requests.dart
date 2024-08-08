import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raccoltalatte/collections/collection.dart';
import 'package:raccoltalatte/origins/origin.dart';
import 'package:raccoltalatte/secrets.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

final db = FirebaseFirestore.instance;

/* Future<List<User>> getUsers() async {
  try {
    final response = await http.get(Uri.https(baseUrl, '/users'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List<User> users = [];
      for (var user in jsonDecode(response.body)['users']) {
        users.add(User.fromJson(user));
      }
      return users;
    } else {
      return Future.error('Operazione non permessa');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
} */

/* Future<void> removeUsers(List<User> users) async {
  try {
    for (var u in users) {
      debugPrint('$baseUrl/users/${u.name}');
      final response = await http.delete(Uri.https(baseUrl, '/users/${u.name}'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode != 204) {
        return Future.error('Operazione non permessa');
      }
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
} */

/* Future<void> updateUser(String name, User user, String pass) async {
  try {
    debugPrint('$baseUrl/users/$name');
    final response = await http.patch(Uri.https(baseUrl, '/users/$name'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(<String, String>{
          'username': user.name,
          'admin': user.isAdmin.toString(),
          'password': pass
        }));
    if (response.statusCode != 204) {
      return Future.error('Operazione non permessa');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
} */

/* Future<void> addUser(User user, String pass) async {
  try {
    final response = await http.put(Uri.https(baseUrl, '/users'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(<String, String>{
          'username': user.name,
          'admin': user.isAdmin.toString(),
          'password': pass
        }));
    debugPrint('Response: ${response.body}');
    if (response.statusCode != 201) {
      debugPrint('Wrong status code');
      return Future.error('Errore durante l\'operazione');
    }
  } catch (e) {
    debugPrint('Error: $e');
    return Future.error('Impossibile connettersi al server');
  }
}
 */

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
  /* for (var o in origins) {
    debugPrint('$baseUrl/origins/${o.name}');
    final response = await http.delete(Uri.https(baseUrl, '/origins/${o.name}'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode != 201) {
      return Future.error('Operazione non permessa');
    }
  } */
  String id =
      (await db.collection('origins').where('name', isEqualTo: name).get())
          .docs
          .first
          .id;
  db.collection('origins').doc(id).delete();
}

Future<void> updateOrigin(String name, Origin origin) async {
  /* final response = await http.patch(Uri.https(baseUrl, '/origins/$name'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: jsonEncode(<String, String>{
        'name': origin.name,
        'lat': '${origin.lat}',
        'lng': '${origin.lng}',
      }));
  if (response.statusCode != 204) {
    return Future.error('Operazione non permessa');
  } */
  String id =
      (await db.collection('origins').where('name', isEqualTo: name).get())
          .docs
          .first
          .id;
  db.collection('origins').doc(id).set(origin.toJson());
}

Future<void> addOrigin(Origin origin) async {
  /* final response = await http.post(
        Uri.https(
            baseUrl, '/origins/${origin.name}/${origin.lat}/${origin.lng}'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    debugPrint('Response: ${response.body}');
    if (response.statusCode != 201) {
      debugPrint('Wrong status code');
      return Future.error('Errore durante l\'operazione');
    } */
  db.collection('origins').add(origin.toJson());
}

Future<List<Collection>> getCollections(
    String username, bool admin, String startDate, String endDate) async {
  try {
    /* final response = await http.get(Uri.https(baseUrl, url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List<Collection> collections = [];
      for (var user in jsonDecode(response.body)) {
        collections.add(Collection.fromJson(user));
      }
      debugPrint(collections.toString());
      return collections;
    } else {
      return Future.error('Operazione non permessa');
    } */
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
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> addCollection(Collection collection, String? filename) async {
  // TODO Upload file
  /* String base64Image;
  if (filename == null) {
    base64Image = '';
  } else {
    List<int> imageBytes = await File(filename).readAsBytes();
    base64Image = base64Encode(imageBytes);
  } */
  /* final response = await http.post(
        Uri.https(
            baseUrl, '/collections/${collection.user}/${collection.origin}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(body));
    //debugPrint('Response: ${response.body}');
    if (response.statusCode != 201) {
      debugPrint('Wrong status code');
      return Future.error('Errore durante l\'operazione');
    } */
  db.collection('collections').add(collection.toJson());
}

Future<void> removeCollections(List<Collection> collections) async {
  /* for (var c in collections) {
      final response = await http.delete(
          Uri.https(baseUrl, '/collections/${c.id}'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode != 204) {
        return Future.error('Operazione non permessa');
      }
    } */
  final WriteBatch batch = db.batch();
  db
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
