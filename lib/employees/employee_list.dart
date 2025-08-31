import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:raccoltalatte/config.dart';
import 'package:raccoltalatte/employees/add_button.dart';
import 'package:raccoltalatte/employees/employee.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:flutter/material.dart';
import 'package:raccoltalatte/utils.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key, required this.admin, required this.username});
  final bool admin;
  final String username;

  @override
  Widget build(BuildContext context) {
    final query = db.collection(employeesTable);
    return FirestoreListView(
      query: query,
      itemBuilder: (context, doc) => ListTile(
        title: Text(
            style: const TextStyle(fontSize: 20), 'Conferente: ${doc['name']}'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
              onPressed: () async {
                bool? confirm = await showDialog(
                    context: context,
                    builder: (_) {
                      return ConfirmDialog(context: context);
                    });
                if (confirm == null || !confirm) {
                  return;
                }
                removeEmployee(doc['name']).catchError((error) {
                  snackbarKey.currentState?.showSnackBar(
                    SnackBar(content: Text(error.toString())),
                  );
                });
              },
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () async {
                final String name = doc['name'];
                await AddButton.inputPopup(
                    context, Employee(id: '', name: name));
              },
              icon: const Icon(Icons.create))
        ]),
      ),
    );
  }
}
