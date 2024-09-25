import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class AddDialog extends AlertDialog {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final VoidCallback addAction;
  final BuildContext context;

  AddDialog(
      {super.key,
      required this.formKey,
      required this.children,
      required this.addAction,
      required this.context})
      : super(
          title: const Text('Inserisci'),
          content: Container(
              padding: const EdgeInsets.all(10),
              height: 300,
              width: 300,
              child: ListView(
                children: [
                  Form(
                      key: formKey,
                      child: Column(
                        children: children,
                      ))
                ],
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState != null &&
                    formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  addAction();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inserisci un valore')));
                }
              },
              child: const Text('Aggiungi'),
            ),
          ],
        );
}

class ImageDialog extends AlertDialog {
  final BuildContext context;
  final String? url;

  ImageDialog({super.key, required this.context, required this.url})
      : super(
          title: const Text('Immagine'),
          content: Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: url != null
                  ? Image.network(
                      url,
                      fit: BoxFit.fitHeight,
                    )
                  : const Text('File non trovato')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
          ],
        );
}

class TextField extends StatelessWidget {
  final String text;
  final String error;
  final TextEditingController controller;
  final String hint;

  const TextField(
      {super.key,
      required this.text,
      required this.error,
      required this.controller,
      this.hint = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        controller: controller,
        validator: (value) => value!.isEmpty ? error : null,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: text,
            hintText: hint),
      ),
    );
  }
}

class AdminCheckbox extends StatefulWidget {
  final void Function(bool) onChanged;
  final bool initialCheckBoxValue;

  const AdminCheckbox(
      {super.key, required this.onChanged, required this.initialCheckBoxValue});

  @override
  // ignore: no_logic_in_create_state
  AdminCheckboxState createState() => AdminCheckboxState(initialCheckBoxValue);
}

class AdminCheckboxState extends State<AdminCheckbox> {
  bool checkboxValue = false;

  AdminCheckboxState(bool initialValue) {
    checkboxValue = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checkboxValue,
          onChanged: (value) {
            setState(() {
              checkboxValue = value!;
            });
            widget.onChanged(checkboxValue);
          },
        ),
        const Text('Amministratore')
      ],
    );
  }
}

class Button<T> extends StatelessWidget {
  final Future<void> Function(BuildContext context, T? initial) inputPopup;

  const Button({super.key, required this.inputPopup});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async => inputPopup(context, null),
      label: const Text('Aggiungi'),
      icon: const Icon(Icons.add),
    );
  }
}

class ConfirmDialog extends AlertDialog {
  final BuildContext context;

  ConfirmDialog({super.key, required this.context})
      : super(title: const Text('Conferma'), actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Conferma'),
          ),
        ]);
}

class FileList {
  static final List<Tuple2<File, String>> filenames = [];
  static bool sent = false;
}
