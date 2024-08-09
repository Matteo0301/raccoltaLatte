import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:raccoltalatte/origin_details/details_page.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:flutter/material.dart';

class OriginsList extends StatelessWidget {
  const OriginsList({super.key, required this.admin, required this.username});
  final bool admin;
  final String username;

  @override
  Widget build(BuildContext context) {
    final query = db.collection('origins');
    return FirestoreListView(
      query: query,
      itemBuilder: (context, doc) => ListTile(
        title: Text(
            style: const TextStyle(fontSize: 20), 'Conferente: ${doc['name']}'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => OriginDetails(
                          title: 'Dettagli conferente',
                          admin: admin,
                          origin: doc['name'],
                          username: username,
                        ))),
          ),
          IconButton(
              onPressed: () => removeOrigin(doc['name']).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.toString())),
                    );
                  }),
              icon: const Icon(Icons.delete))
        ]),
      ),
    );
  }
}
