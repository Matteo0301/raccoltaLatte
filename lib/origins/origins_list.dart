import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:raccoltalatte/origins/gen_excel.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:flutter/material.dart';
import 'package:raccoltalatte/origins/add_button.dart';

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
            icon: const Icon(Icons.download),
            onPressed: () async => genExcel(
                '${doc['name']}.xls',
                (await getOriginMap(admin, username, doc['name'])),
                ['sera', 'mattina']),
          ),
          IconButton(
              onPressed: () => removeOrigin(doc['name']).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.toString())),
                    );
                  }),
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () async {
                String name = doc['name'];
                await AddButton.inputPopup(context, name);
              },
              icon: const Icon(Icons.create))
        ]),
      ),
    );
  }
}
