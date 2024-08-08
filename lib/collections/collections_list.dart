import 'package:raccoltalatte/collections/collection.dart';
import 'package:raccoltalatte/model.dart';
import 'package:raccoltalatte/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionsList extends StatelessWidget {
  const CollectionsList(this.username, this.admin, this.date, this.request,
      {super.key});
  final String username;
  final bool admin;
  final DateTime date;
  final ValueGetter<Future<List<Collection>>> request;

  @override
  Widget build(BuildContext context) {
    return Consumer<Model<Collection>>(
      builder: (context, collections, child) {
        return FutureBuilder(
          future: request(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Nessun dato trovato'));
            } else if (snapshot.hasData) {
              List<Collection> list = snapshot.data as List<Collection>;
              collections.removeAll();
              for (var coll in list) {
                collections.add(coll);
              }
              if (list.isEmpty) {
                return const Center(child: Text('Nessun dato trovato'));
              }
              return Column(children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Totale: ${list.fold(0, (previousValue, element) => previousValue + element.quantity)}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    flex: 15,
                    child: Center(
                        child: ListView.builder(
                            itemCount: collections.items.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    style: const TextStyle(fontSize: 20),
                                    'Conferente: ${collections.items[collections.items.length - index - 1].origin}'),
                                subtitle: Text(
                                    'Quantità: ${collections.items[collections.items.length - index - 1].quantity}, Seconda: ${collections.items[collections.items.length - index - 1].quantity2}'),
                                trailing: Container(
                                    width: 300,
                                    alignment: Alignment.centerRight,
                                    child: Row(children: [
                                      Text(
                                          '${collections.items[collections.items.length - index - 1].user}   (${collections.items[collections.items.length - index - 1].date.day.toString().padLeft(2, '0')}/${collections.items[collections.items.length - index - 1].date.month.toString().padLeft(2, '0')}/${collections.items[collections.items.length - index - 1].date.year} ${collections.items[collections.items.length - index - 1].date.hour}:${collections.items[collections.items.length - index - 1].date.minute.toString().padLeft(2, '0')})'),
                                      IconButton(
                                        icon:
                                            const Icon(Icons.arrow_forward_ios),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => ImageDialog(
                                                  context: context,
                                                  url:
                                                      'collections/${collections.items[collections.items.length - index - 1].date.toIso8601String()}'));
                                        },
                                      ),
                                    ])),
                                selected: collections.selected.contains(
                                    collections.items.length - index - 1),
                                selectedTileColor: Colors.blue[100],
                                onTap: () {
                                  collections.toggleSelected(
                                      collections.items.length - index - 1);
                                },
                              );
                            })))
              ]);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
