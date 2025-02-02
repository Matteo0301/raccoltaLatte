import 'package:raccoltalatte/collections/add_button.dart';
import 'package:raccoltalatte/collections/collections_list.dart';
import 'package:raccoltalatte/drawer.dart';
import 'package:flutter/material.dart';
import 'package:raccoltalatte/employees_dropdown.dart';
import 'package:raccoltalatte/gen_excel.dart';

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
  String employee = '';

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
              child: Column(children: [
                EmployeesDropdown((name) {
                  setState(() {
                    employee = name;
                  });
                }),
                Expanded(
                    child: CollectionsList(
                  username: widget.username,
                  admin: widget.admin,
                  date: date,
                  employee: employee,
                ))
              ])),
        ],
      );
      drawer = null;
      leading = false;
    } else {
      content = Column(children: [
        EmployeesDropdown((name) {
          setState(() {
            employee = name;
          });
        }),
        Expanded(
            child: CollectionsList(
          username: widget.username,
          admin: widget.admin,
          date: date,
          employee: employee,
        ))
      ]);
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
                '${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year}'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      date = date.copyWith(day: date.day + 1, hour: 12);
                      if (date.isAfter(DateTime.now())) {
                        date = DateTime.now();
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      date = date.copyWith(day: date.day - 1, hour: 12);
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_ios)),
              widget.admin
                  ? (IconButton(
                      onPressed: () async {
                        final map = await getCollectionsMap(
                            date, widget.admin, widget.username);
                        genExcel('${date.month}_${date.year}.xls', map,
                            map.keys.toList());
                      },
                      icon: const Icon(Icons.download)))
                  : const SizedBox(),
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
        floatingActionButton: AddButton(
          username: widget.username,
          admin: widget.admin,
          employee: employee,
        ),
        drawer: drawer);
  }
}
