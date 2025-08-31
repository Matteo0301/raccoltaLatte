import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:raccoltalatte/config.dart';
import 'package:raccoltalatte/date_time_picker.dart';
import 'package:raccoltalatte/gen_excel.dart';
import 'package:raccoltalatte/origins/origin.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:flutter/material.dart';
import 'package:raccoltalatte/origins/add_button.dart';

class OriginsList extends StatelessWidget {
  OriginsList({super.key, required this.admin, required this.username});
  final bool admin;
  final String username;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final query = db.collection(originsTable);
    return Column(
      children: [
        DateTimePicker(
            date: date,
            onChanged: (value) {
              date = value;
            },
            immutable: admin),
        Expanded(
            child: FirestoreListView(
          query: query,
          itemBuilder: (context, doc) => ListTile(
            title: Text(
                style: const TextStyle(fontSize: 20),
                'Conferente: ${doc['name']}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () async => genExcel(
                    '${doc['name']}.xls',
                    (await getOriginMap(admin, username, doc['name'], date)),
                    ['sera', 'mattina']),
              ),
              IconButton(
                  onPressed: () =>
                      removeOrigin(doc['name']).catchError((error) {
                        snackbarKey.currentState?.showSnackBar(
                          SnackBar(content: Text(error.toString())),
                        );
                      }),
                  icon: const Icon(Icons.delete)),
              IconButton(
                  onPressed: () async {
                    final String name = doc['name'];
                    final String address = (doc.data().containsKey('address'))
                        ? doc['address']
                        : '';
                    await AddButton.inputPopup(
                        context, Origin(name, 0, 0, address, ''));
                  },
                  icon: const Icon(Icons.create))
            ]),
          ),
        ))
      ],
    );
  }
}
