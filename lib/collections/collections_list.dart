import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:raccoltalatte/config.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:raccoltalatte/utils.dart';
import 'package:flutter/material.dart';

class CollectionsList extends StatelessWidget {
  const CollectionsList({
    super.key,
    required this.username,
    required this.admin,
    required this.date,
    required this.employee,
  });
  final String username;
  final bool admin;
  final DateTime date;
  final String employee;

  @override
  Widget build(BuildContext context) {
    DateTime end = date.copyWith(month: date.month + 1, day: 0, hour: 12);
    DateTime start = end.copyWith(day: 0, hour: 12);
    String endDate = end.toIso8601String();
    String startDate = start.toIso8601String();
    return FirestoreListView(
      query: getCollectionsQuery(username, admin, startDate, endDate),
      itemBuilder: (context, doc) {
        final DateTime date = DateTime.parse(doc['date']);
        return ListTile(
          visualDensity: const VisualDensity(vertical: 4),
          title: Text(
              style: const TextStyle(fontSize: 20),
              'Conferente: ${doc['origin']}'),
          subtitle: Text(
              'Quantità: ${doc['quantity']}, Seconda: ${doc['quantity2']}'),
          trailing: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
                '${doc['user']}\n(${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')})'),
            (admin || !limitUsers)
                ? (Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () async {
                        String? url = await getImageURL(date);
                        if (context.mounted) {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  ImageDialog(context: context, url: url));
                        }
                      },
                    ),
                    IconButton(
                        onPressed: () =>
                            removeCollection(doc['date']).catchError((error) {
                              logAndShow(error.toString());
                            }),
                        icon: const Icon(Icons.delete))
                  ]))
                : const SizedBox()
          ]),
        );
      },
    );
  }
}
