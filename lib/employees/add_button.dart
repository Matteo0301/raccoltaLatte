import 'package:raccoltalatte/config.dart';
import 'package:raccoltalatte/employees/employee.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:raccoltalatte/utils.dart';
import 'package:flutter/material.dart' hide TextField;

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  static Future<void> inputPopup(
      BuildContext context, Employee? initial) async {
    String? s = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => EmployeeForm(
              initial: initial,
            ));
    if (s == null) {
      return;
    }
    final e = Employee(id: '', name: s);
    if (initial == null) {
      await addEmployee(e).catchError((error) {
        snackbarKey.currentState?.showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    } else {
      await updateEmployee(initial.name, e).onError(
        (error, stackTrace) => snackbarKey.currentState?.showSnackBar(
          SnackBar(content: Text(error.toString())),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Button<Employee>(inputPopup: inputPopup);
  }
}

class EmployeeForm extends StatelessWidget {
  EmployeeForm({super.key, required this.initial});
  final _formKey = GlobalKey<FormState>();
  final Employee? initial;

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController(text: initial?.name);
    return AddDialog(
        formKey: _formKey,
        addAction: () {
          Navigator.pop(context, nameController.text);
        },
        context: context,
        children: [
          TextField(
              text: 'Nome',
              error: 'Inserisci il nome',
              controller: nameController),
        ]);
  }
}
