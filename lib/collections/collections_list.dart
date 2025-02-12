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

  String getEmployeeFromMap(doc) {
    return doc.containsKey("employee") ? doc['employee'] : '';
  }

  @override
  Widget build(BuildContext context) {
    final DateTime end;
    final DateTime start;
    if (date.hour > 12) {
      end = date.copyWith(day: date.day + 1, hour: 12);
      start = date.copyWith(hour: 12);
    } else {
      start = date.copyWith(day: date.day - 1, hour: 12);
      end = date.copyWith(hour: 12);
    }
    String endDate = end.toIso8601String();
    String startDate = start.toIso8601String();
    return FirestoreListView(
      query: getCollectionsQuery(username, admin, startDate, endDate),
      itemBuilder: (context, docOrig) {
        var doc = Map<String, dynamic>.from(docOrig.data() as Map);
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
                '${doc['user']}:${getEmployeeFromMap(doc)}\n(${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')})'),
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
