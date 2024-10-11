import 'package:raccoltalatte/auth.dart';
import 'package:raccoltalatte/collections/home.dart';
import 'package:raccoltalatte/employees/employee_page.dart';
import 'package:raccoltalatte/origins/origin_page.dart';
import 'package:raccoltalatte/theme.dart';
import 'package:flutter/material.dart';

class AppMenu extends StatelessWidget {
  final String username;
  final bool admin;
  final String current;

  const AppMenu(
      {super.key,
      required this.username,
      required this.admin,
      required this.current});
  @override
  Widget build(BuildContext context) {
    final Widget origins;
    final Widget employees;
    const empty = SizedBox.shrink();

    final children = [
      UserAccountsDrawerHeader(
        decoration: const BoxDecoration(color: MyTheme.mainColor),
        accountName: Text(
          username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        accountEmail: const Text(
          '',
        ),
      ),
      ListTile(
        title: const Text('Home'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Home(title: 'Raccolte', username: username, admin: admin);
          }));
        },
      )
    ];

    if (admin) {
      origins = ListTile(
        title: const Text('Conferenti'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OriginPage(
                title: 'Conferenti', username: username, admin: admin);
          }));
        },
      );
      employees = ListTile(
        title: const Text('Operai'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EmployeePage(
                title: 'Operai', username: username, admin: admin);
          }));
        },
      );
    } else {
      origins = empty;
      employees = empty;
    }

    children.add(origins);
    children.add(employees);

    for (var child in children) {
      if (child.runtimeType == ListTile &&
          (child as ListTile).title.runtimeType == Text) {
        if (((child).title as Text).data != null &&
            ((child).title as Text).data == current) {
          child = ListTile(
            title: Text(((child).title as Text).data!),
            onTap: () {
              Navigator.pop(context);
            },
          );
        }
      }
    }

    children.addAll([
      ListTile(
        leading: const Icon(
          Icons.logout_rounded,
        ),
        title: const Text('Logout'),
        onTap: () {
          logout();
        },
      ),
      const AboutListTile(
        icon: Icon(
          Icons.info,
        ),
        applicationIcon: Icon(
          Icons.local_play,
        ),
        applicationName: 'App Raccolta Latte',
        applicationVersion: '1.0.0',
        aboutBoxChildren: [],
        child: Text('About app'),
      ),
    ]);

    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: children,
    );
  }
}
