import 'package:raccoltalatte/drawer.dart';
import 'package:raccoltalatte/origins/origins_list.dart';
import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [],
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
    );
  }
}
