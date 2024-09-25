import 'package:raccoltalatte/config.dart';
import 'package:raccoltalatte/origins/origin.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:raccoltalatte/utils.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:tuple/tuple.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  static Future<void> inputPopup(BuildContext context, Origin? initial) async {
    String? s = await showDialog(
        context: context,
        builder: (_) => OriginForm(
              initial: initial,
            ));
    final tmp = s?.split(';');
    if (tmp == null) {
      return;
    }
    final coordinates = await address2Coordinates(tmp[1]).catchError((error) {
      snackbarKey.currentState?.showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
      return const Tuple2(0.0, 0.0);
    });
    if (coordinates == const Tuple2(0.0, 0.0)) {
      return;
    }
    if (s == null) {
      return;
    }
    final o = Origin(tmp[0], coordinates.item1, coordinates.item2, tmp[1], '');
    if (initial == null) {
      await addOrigin(o).catchError((error) {
        snackbarKey.currentState?.showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    } else {
      await updateOrigin(initial.name, o).onError(
        (error, stackTrace) => snackbarKey.currentState?.showSnackBar(
          SnackBar(content: Text(error.toString())),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Button<Origin>(inputPopup: inputPopup);
  }
}

class OriginForm extends StatelessWidget {
  OriginForm({super.key, required this.initial});
  final _formKey = GlobalKey<FormState>();
  final Origin? initial;

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController(text: initial?.name);
    var addressController = TextEditingController(text: initial?.address);
    return AddDialog(
        formKey: _formKey,
        addAction: () {
          Navigator.pop(
              context, '${nameController.text};${addressController.text}}');
        },
        context: context,
        children: [
          TextField(
              text: 'Nome',
              error: 'Inserisci il nuovo conferente',
              controller: nameController),
          TextField(
              text: 'Indirizzo',
              error: 'Inserisci l\'indirizzo',
              hint: 'Via Roma 1, Pegognaga',
              controller: addressController),
        ]);
  }
}
