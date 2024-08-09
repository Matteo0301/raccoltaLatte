import 'package:raccoltalatte/collections/add_button.dart';
import 'package:raccoltalatte/collections/collections_list.dart';
import 'package:raccoltalatte/drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home(
      {super.key,
      required this.title,
      required this.username,
      required this.admin});
  final String title;
  final String username;
  final bool admin;
  @override
  Widget build(BuildContext context) {
    return HomePage(
      title: title,
      admin: admin,
      username: username,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.title,
      required this.username,
      required this.admin});

  final String title;
  final String username;
  final bool admin;

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    final next = date.copyWith(day: date.day + 1);
    if (next.day == 1 && date.hour >= 12) {
      date = next;
    }
  }

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
              username: widget.username,
              admin: widget.admin,
              current: 'Home',
            ),
          ),
          Expanded(
              flex: 3,
              child: CollectionsList(widget.username, widget.admin, date)),
        ],
      );
      drawer = null;
      leading = false;
    } else {
      content = CollectionsList(widget.username, widget.admin, date);
      drawer = Drawer(
          child: AppMenu(
        username: widget.username,
        admin: widget.admin,
        current: 'Home',
      ));
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(
                'Mese: ${date.month.toString().padLeft(2, "0")}/${date.year}'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      date = date.copyWith(
                          month: date.month + 2, day: 0, hour: 12);
                      if (date.isAfter(DateTime.now())) {
                        date = DateTime.now().copyWith(
                            month: DateTime.now().month + 1, day: 0, hour: 12);
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      date = date.copyWith(day: 0, hour: 12);
                      if (date.isBefore(DateTime(2021, 1, 1))) {
                        date = DateTime(2021, 1, 1);
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_ios)),
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
        floatingActionButton:
            AddButton(username: widget.username, admin: widget.admin),
        drawer: drawer);
  }
}
