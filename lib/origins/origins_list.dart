import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:raccoltalatte/model.dart';
import 'package:raccoltalatte/origin_details/details_page.dart';
import 'package:raccoltalatte/origins/origin.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OriginsList extends StatelessWidget {
  const OriginsList({super.key, required this.admin, required this.username});
  final bool admin;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Consumer<Model<Origin>>(
      builder: (context, origins, child) {
        /* return FutureBuilder(
            future: getOrigins(),
            builder: (context, snapshot) {
              debugPrint('FutureBuilder');
              if (snapshot.hasError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('${snapshot.error}')));
                return const Center(child: Text('Nessun conferente trovato'));
              } else if (snapshot.hasData) {
                List<Origin> list = snapshot.data as List<Origin>;
                origins.removeAll();
                for (var user in list) {
                  origins.add(user);
                }
                if (list.isEmpty) {
                  return const Center(child: Text('Nessun conferente trovato'));
                }
                return Center(
                    child: ListView.builder(
                        itemCount: origins.items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => OriginDetails(
                                            title: 'Dettagli conferente',
                                            admin: admin,
                                            origin: origins
                                                .items[origins.items.length -
                                                    index -
                                                    1]
                                                .name,
                                            username: username,
                                          ))),
                            ),
                            title: Text(
                                style: const TextStyle(fontSize: 20),
                                'Conferente: ${origins.items[origins.items.length - index - 1].name}'),
                            selected: origins.selected
                                .contains(origins.items.length - index - 1),
                            selectedTileColor: Colors.blue[100],
                            onTap: () {
                              origins.toggleSelected(
                                  origins.items.length - index - 1);
                            },
                          );
                        }));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }); */
        final query = db.collection('origins');
        return FirestoreListView(
          query: query,
          itemBuilder: (context, doc) => ListTile(
            title: Text(
                style: const TextStyle(fontSize: 20),
                'Conferente: ${doc['name']}'),
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
                  onPressed: () => removeOrigins(doc['name'])
                          .then((value) => {
                                origins.clearSelected(),
                                origins.notifyListeners()
                              })
                          .catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())),
                        );

                        origins.notifyListeners();
                        return <dynamic>{};
                      }),
                  icon: const Icon(Icons.delete))
            ]),
            selected: origins.selected.contains(doc['name']),
            selectedTileColor: Colors.blue[100],
            onTap: () {
              origins.toggleSelected(doc['name']);
            },
          ),
        );
      },
    );
  }
}
