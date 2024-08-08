import 'package:raccoltalatte/drawer.dart';
import 'package:raccoltalatte/model.dart';
import 'package:raccoltalatte/origins/origin.dart';
import 'package:raccoltalatte/origins/origins_list.dart';
import 'package:raccoltalatte/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_button.dart';

class OriginPage extends StatelessWidget {
  const OriginPage(
      {super.key,
      required this.title,
      required this.username,
      required this.admin});
  final String title;
  final String username;
  final bool admin;
  @override
  Widget build(BuildContext context) {
    Widget content;
    Drawer? drawer;
    bool leading = true;
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width > 800) {
      content = Row(
        children: [
          Expanded(
            flex: 1,
            child: AppMenu(
              username: username,
              admin: admin,
              current: 'Conferenti',
            ),
          ),
          Expanded(
              flex: 3,
              child: OriginsList(
                admin: admin,
                username: username,
              )),
        ],
      );
      drawer = null;
      leading = false;
    } else {
      content = OriginsList(
        admin: admin,
        username: username,
      );
      drawer = Drawer(
          child: AppMenu(
        username: username,
        admin: admin,
        current: 'Conferenti',
      ));
    }

    return ChangeNotifierProvider(
      create: (context) => Model<Origin>(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              Consumer<Model<Origin>>(
                builder: (context, origins, child) {
                  if (origins.selected.isEmpty) {
                    return const SizedBox.shrink();
                  } else {
                    return IconButton(
                        onPressed: () async {
                          bool? confirm = await showDialog(
                              context: context,
                              builder: (_) {
                                return ConfirmDialog(context: context);
                              });
                          if (confirm == null || !confirm) {
                            return;
                          }
                          List<Origin> o = [];
                          for (var index in origins.selected) {
                            o.add(origins.items[index]);
                          }
                          // TODO
                          /* removeOrigins(o)
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
                          }); */
                        },
                        icon: const Icon(Icons.delete));
                  }
                },
              ),
              Consumer<Model<Origin>>(builder: (context, origins, child) {
                return UpdateButton(model: origins);
              }),
              Consumer<Model<Origin>>(builder: (context, users, child) {
                return ModifyButton(
                    model: users, inputPopup: AddButton.inputPopup);
              })
            ],
            leading: !leading
                ? null
                : Builder(builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        if (leading) {
                          Scaffold.of(context).openDrawer();
                        }
                      },
                    );
                  })),
        body: content,
        drawer: drawer,
        floatingActionButton: const AddButton(),
      ),
    );
  }
}
